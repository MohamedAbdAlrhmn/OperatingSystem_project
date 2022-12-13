
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
  80003e:	e8 1e 1c 00 00       	call   801c61 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 48 1c 00 00       	call   801c93 <sys_getparentenvid>
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
  80005f:	68 a0 39 80 00       	push   $0x8039a0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 8a 17 00 00       	call   8017f6 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a4 39 80 00       	push   $0x8039a4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 74 17 00 00       	call   8017f6 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ac 39 80 00       	push   $0x8039ac
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 57 17 00 00       	call   8017f6 <sget>
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
  8000b3:	68 ba 39 80 00       	push   $0x8039ba
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
  800126:	68 c4 39 80 00       	push   $0x8039c4
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 e9 39 80 00       	push   $0x8039e9
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
  800159:	68 ee 39 80 00       	push   $0x8039ee
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
  800178:	68 f2 39 80 00       	push   $0x8039f2
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
  800197:	68 f6 39 80 00       	push   $0x8039f6
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
  8001b6:	68 fa 39 80 00       	push   $0x8039fa
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
  800230:	e8 91 1a 00 00       	call   801cc6 <sys_get_virtual_time>
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
  800533:	e8 42 17 00 00       	call   801c7a <sys_getenvindex>
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
  80059e:	e8 e4 14 00 00       	call   801a87 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 18 3a 80 00       	push   $0x803a18
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
  8005ce:	68 40 3a 80 00       	push   $0x803a40
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
  8005ff:	68 68 3a 80 00       	push   $0x803a68
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 50 80 00       	mov    0x805020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 c0 3a 80 00       	push   $0x803ac0
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 18 3a 80 00       	push   $0x803a18
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 64 14 00 00       	call   801aa1 <sys_enable_interrupt>

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
  800650:	e8 f1 15 00 00       	call   801c46 <sys_destroy_env>
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
  800661:	e8 46 16 00 00       	call   801cac <sys_exit_env>
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
  8006af:	e8 25 12 00 00       	call   8018d9 <sys_cputs>
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
  800726:	e8 ae 11 00 00       	call   8018d9 <sys_cputs>
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
  800770:	e8 12 13 00 00       	call   801a87 <sys_disable_interrupt>
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
  800790:	e8 0c 13 00 00       	call   801aa1 <sys_enable_interrupt>
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
  8007da:	e8 5d 2f 00 00       	call   80373c <__udivdi3>
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
  80082a:	e8 1d 30 00 00       	call   80384c <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 f4 3c 80 00       	add    $0x803cf4,%eax
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
  800985:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
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
  800a66:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 05 3d 80 00       	push   $0x803d05
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
  800a8b:	68 0e 3d 80 00       	push   $0x803d0e
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
  800ab8:	be 11 3d 80 00       	mov    $0x803d11,%esi
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
  8014de:	68 70 3e 80 00       	push   $0x803e70
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
  8015ae:	e8 6a 04 00 00       	call   801a1d <sys_allocate_chunk>
  8015b3:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015b6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015bb:	83 ec 0c             	sub    $0xc,%esp
  8015be:	50                   	push   %eax
  8015bf:	e8 df 0a 00 00       	call   8020a3 <initialize_MemBlocksList>
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
  8015ec:	68 95 3e 80 00       	push   $0x803e95
  8015f1:	6a 33                	push   $0x33
  8015f3:	68 b3 3e 80 00       	push   $0x803eb3
  8015f8:	e8 5f 1f 00 00       	call   80355c <_panic>
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
  80166b:	68 c0 3e 80 00       	push   $0x803ec0
  801670:	6a 34                	push   $0x34
  801672:	68 b3 3e 80 00       	push   $0x803eb3
  801677:	e8 e0 1e 00 00       	call   80355c <_panic>
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
  801703:	e8 e3 06 00 00       	call   801deb <sys_isUHeapPlacementStrategyFIRSTFIT>
  801708:	85 c0                	test   %eax,%eax
  80170a:	74 11                	je     80171d <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80170c:	83 ec 0c             	sub    $0xc,%esp
  80170f:	ff 75 e8             	pushl  -0x18(%ebp)
  801712:	e8 4e 0d 00 00       	call   802465 <alloc_block_FF>
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
  801729:	e8 aa 0a 00 00       	call   8021d8 <insert_sorted_allocList>
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
  801749:	68 e4 3e 80 00       	push   $0x803ee4
  80174e:	6a 6f                	push   $0x6f
  801750:	68 b3 3e 80 00       	push   $0x803eb3
  801755:	e8 02 1e 00 00       	call   80355c <_panic>

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
  80176f:	75 07                	jne    801778 <smalloc+0x1e>
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	eb 7c                	jmp    8017f4 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801778:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80177f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801785:	01 d0                	add    %edx,%eax
  801787:	48                   	dec    %eax
  801788:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80178b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178e:	ba 00 00 00 00       	mov    $0x0,%edx
  801793:	f7 75 f0             	divl   -0x10(%ebp)
  801796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801799:	29 d0                	sub    %edx,%eax
  80179b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80179e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017a5:	e8 41 06 00 00       	call   801deb <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	74 11                	je     8017bf <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8017ae:	83 ec 0c             	sub    $0xc,%esp
  8017b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b4:	e8 ac 0c 00 00       	call   802465 <alloc_block_FF>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8017bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017c3:	74 2a                	je     8017ef <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	8b 40 08             	mov    0x8(%eax),%eax
  8017cb:	89 c2                	mov    %eax,%edx
  8017cd:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017d1:	52                   	push   %edx
  8017d2:	50                   	push   %eax
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	e8 92 03 00 00       	call   801b70 <sys_createSharedObject>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8017e4:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8017e8:	74 05                	je     8017ef <smalloc+0x95>
			return (void*)virtual_address;
  8017ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ed:	eb 05                	jmp    8017f4 <smalloc+0x9a>
	}
	return NULL;
  8017ef:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fc:	e8 c6 fc ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 08 3f 80 00       	push   $0x803f08
  801809:	68 b0 00 00 00       	push   $0xb0
  80180e:	68 b3 3e 80 00       	push   $0x803eb3
  801813:	e8 44 1d 00 00       	call   80355c <_panic>

00801818 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80181e:	e8 a4 fc ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	68 2c 3f 80 00       	push   $0x803f2c
  80182b:	68 f4 00 00 00       	push   $0xf4
  801830:	68 b3 3e 80 00       	push   $0x803eb3
  801835:	e8 22 1d 00 00       	call   80355c <_panic>

0080183a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801840:	83 ec 04             	sub    $0x4,%esp
  801843:	68 54 3f 80 00       	push   $0x803f54
  801848:	68 08 01 00 00       	push   $0x108
  80184d:	68 b3 3e 80 00       	push   $0x803eb3
  801852:	e8 05 1d 00 00       	call   80355c <_panic>

00801857 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	68 78 3f 80 00       	push   $0x803f78
  801865:	68 13 01 00 00       	push   $0x113
  80186a:	68 b3 3e 80 00       	push   $0x803eb3
  80186f:	e8 e8 1c 00 00       	call   80355c <_panic>

00801874 <shrink>:

}
void shrink(uint32 newSize)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	68 78 3f 80 00       	push   $0x803f78
  801882:	68 18 01 00 00       	push   $0x118
  801887:	68 b3 3e 80 00       	push   $0x803eb3
  80188c:	e8 cb 1c 00 00       	call   80355c <_panic>

00801891 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	68 78 3f 80 00       	push   $0x803f78
  80189f:	68 1d 01 00 00       	push   $0x11d
  8018a4:	68 b3 3e 80 00       	push   $0x803eb3
  8018a9:	e8 ae 1c 00 00       	call   80355c <_panic>

008018ae <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	57                   	push   %edi
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018c6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018c9:	cd 30                	int    $0x30
  8018cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	5b                   	pop    %ebx
  8018d5:	5e                   	pop    %esi
  8018d6:	5f                   	pop    %edi
  8018d7:	5d                   	pop    %ebp
  8018d8:	c3                   	ret    

008018d9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	52                   	push   %edx
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	50                   	push   %eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	e8 b2 ff ff ff       	call   8018ae <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	90                   	nop
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_cgetc>:

int
sys_cgetc(void)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 01                	push   $0x1
  801911:	e8 98 ff ff ff       	call   8018ae <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80191e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	52                   	push   %edx
  80192b:	50                   	push   %eax
  80192c:	6a 05                	push   $0x5
  80192e:	e8 7b ff ff ff       	call   8018ae <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	56                   	push   %esi
  80193c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80193d:	8b 75 18             	mov    0x18(%ebp),%esi
  801940:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801943:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	56                   	push   %esi
  80194d:	53                   	push   %ebx
  80194e:	51                   	push   %ecx
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 06                	push   $0x6
  801953:	e8 56 ff ff ff       	call   8018ae <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195e:	5b                   	pop    %ebx
  80195f:	5e                   	pop    %esi
  801960:	5d                   	pop    %ebp
  801961:	c3                   	ret    

00801962 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801965:	8b 55 0c             	mov    0xc(%ebp),%edx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	6a 07                	push   $0x7
  801975:	e8 34 ff ff ff       	call   8018ae <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	6a 08                	push   $0x8
  801990:	e8 19 ff ff ff       	call   8018ae <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 09                	push   $0x9
  8019a9:	e8 00 ff ff ff       	call   8018ae <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 0a                	push   $0xa
  8019c2:	e8 e7 fe ff ff       	call   8018ae <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 0b                	push   $0xb
  8019db:	e8 ce fe ff ff       	call   8018ae <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	ff 75 08             	pushl  0x8(%ebp)
  8019f4:	6a 0f                	push   $0xf
  8019f6:	e8 b3 fe ff ff       	call   8018ae <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
	return;
  8019fe:	90                   	nop
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	ff 75 08             	pushl  0x8(%ebp)
  801a10:	6a 10                	push   $0x10
  801a12:	e8 97 fe ff ff       	call   8018ae <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1a:	90                   	nop
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	ff 75 10             	pushl  0x10(%ebp)
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	ff 75 08             	pushl  0x8(%ebp)
  801a2d:	6a 11                	push   $0x11
  801a2f:	e8 7a fe ff ff       	call   8018ae <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
	return ;
  801a37:	90                   	nop
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 0c                	push   $0xc
  801a49:	e8 60 fe ff ff       	call   8018ae <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	ff 75 08             	pushl  0x8(%ebp)
  801a61:	6a 0d                	push   $0xd
  801a63:	e8 46 fe ff ff       	call   8018ae <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 0e                	push   $0xe
  801a7c:	e8 2d fe ff ff       	call   8018ae <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	90                   	nop
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 13                	push   $0x13
  801a96:	e8 13 fe ff ff       	call   8018ae <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	90                   	nop
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 14                	push   $0x14
  801ab0:	e8 f9 fd ff ff       	call   8018ae <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	90                   	nop
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_cputc>:


void
sys_cputc(const char c)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ac7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	50                   	push   %eax
  801ad4:	6a 15                	push   $0x15
  801ad6:	e8 d3 fd ff ff       	call   8018ae <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	90                   	nop
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 16                	push   $0x16
  801af0:	e8 b9 fd ff ff       	call   8018ae <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	90                   	nop
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	50                   	push   %eax
  801b0b:	6a 17                	push   $0x17
  801b0d:	e8 9c fd ff ff       	call   8018ae <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	52                   	push   %edx
  801b27:	50                   	push   %eax
  801b28:	6a 1a                	push   $0x1a
  801b2a:	e8 7f fd ff ff       	call   8018ae <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	52                   	push   %edx
  801b44:	50                   	push   %eax
  801b45:	6a 18                	push   $0x18
  801b47:	e8 62 fd ff ff       	call   8018ae <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 19                	push   $0x19
  801b65:	e8 44 fd ff ff       	call   8018ae <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	90                   	nop
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	8b 45 10             	mov    0x10(%ebp),%eax
  801b79:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b7c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b7f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	51                   	push   %ecx
  801b89:	52                   	push   %edx
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	50                   	push   %eax
  801b8e:	6a 1b                	push   $0x1b
  801b90:	e8 19 fd ff ff       	call   8018ae <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	52                   	push   %edx
  801baa:	50                   	push   %eax
  801bab:	6a 1c                	push   $0x1c
  801bad:	e8 fc fc ff ff       	call   8018ae <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	51                   	push   %ecx
  801bc8:	52                   	push   %edx
  801bc9:	50                   	push   %eax
  801bca:	6a 1d                	push   $0x1d
  801bcc:	e8 dd fc ff ff       	call   8018ae <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	52                   	push   %edx
  801be6:	50                   	push   %eax
  801be7:	6a 1e                	push   $0x1e
  801be9:	e8 c0 fc ff ff       	call   8018ae <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 1f                	push   $0x1f
  801c02:	e8 a7 fc ff ff       	call   8018ae <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	6a 00                	push   $0x0
  801c14:	ff 75 14             	pushl  0x14(%ebp)
  801c17:	ff 75 10             	pushl  0x10(%ebp)
  801c1a:	ff 75 0c             	pushl  0xc(%ebp)
  801c1d:	50                   	push   %eax
  801c1e:	6a 20                	push   $0x20
  801c20:	e8 89 fc ff ff       	call   8018ae <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	50                   	push   %eax
  801c39:	6a 21                	push   $0x21
  801c3b:	e8 6e fc ff ff       	call   8018ae <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	50                   	push   %eax
  801c55:	6a 22                	push   $0x22
  801c57:	e8 52 fc ff ff       	call   8018ae <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 02                	push   $0x2
  801c70:	e8 39 fc ff ff       	call   8018ae <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 03                	push   $0x3
  801c89:	e8 20 fc ff ff       	call   8018ae <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 04                	push   $0x4
  801ca2:	e8 07 fc ff ff       	call   8018ae <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_exit_env>:


void sys_exit_env(void)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 23                	push   $0x23
  801cbb:	e8 ee fb ff ff       	call   8018ae <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	90                   	nop
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ccc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ccf:	8d 50 04             	lea    0x4(%eax),%edx
  801cd2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	52                   	push   %edx
  801cdc:	50                   	push   %eax
  801cdd:	6a 24                	push   $0x24
  801cdf:	e8 ca fb ff ff       	call   8018ae <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
	return result;
  801ce7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ced:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cf0:	89 01                	mov    %eax,(%ecx)
  801cf2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	c9                   	leave  
  801cf9:	c2 04 00             	ret    $0x4

00801cfc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	ff 75 10             	pushl  0x10(%ebp)
  801d06:	ff 75 0c             	pushl  0xc(%ebp)
  801d09:	ff 75 08             	pushl  0x8(%ebp)
  801d0c:	6a 12                	push   $0x12
  801d0e:	e8 9b fb ff ff       	call   8018ae <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
	return ;
  801d16:	90                   	nop
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 25                	push   $0x25
  801d28:	e8 81 fb ff ff       	call   8018ae <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 04             	sub    $0x4,%esp
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d3e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	50                   	push   %eax
  801d4b:	6a 26                	push   $0x26
  801d4d:	e8 5c fb ff ff       	call   8018ae <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
	return ;
  801d55:	90                   	nop
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <rsttst>:
void rsttst()
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 28                	push   $0x28
  801d67:	e8 42 fb ff ff       	call   8018ae <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6f:	90                   	nop
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d7e:	8b 55 18             	mov    0x18(%ebp),%edx
  801d81:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d85:	52                   	push   %edx
  801d86:	50                   	push   %eax
  801d87:	ff 75 10             	pushl  0x10(%ebp)
  801d8a:	ff 75 0c             	pushl  0xc(%ebp)
  801d8d:	ff 75 08             	pushl  0x8(%ebp)
  801d90:	6a 27                	push   $0x27
  801d92:	e8 17 fb ff ff       	call   8018ae <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9a:	90                   	nop
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <chktst>:
void chktst(uint32 n)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	6a 29                	push   $0x29
  801dad:	e8 fc fa ff ff       	call   8018ae <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
	return ;
  801db5:	90                   	nop
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <inctst>:

void inctst()
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 2a                	push   $0x2a
  801dc7:	e8 e2 fa ff ff       	call   8018ae <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcf:	90                   	nop
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <gettst>:
uint32 gettst()
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 2b                	push   $0x2b
  801de1:	e8 c8 fa ff ff       	call   8018ae <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 2c                	push   $0x2c
  801dfd:	e8 ac fa ff ff       	call   8018ae <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
  801e05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e08:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e0c:	75 07                	jne    801e15 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e13:	eb 05                	jmp    801e1a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 2c                	push   $0x2c
  801e2e:	e8 7b fa ff ff       	call   8018ae <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
  801e36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e39:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e3d:	75 07                	jne    801e46 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e44:	eb 05                	jmp    801e4b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 2c                	push   $0x2c
  801e5f:	e8 4a fa ff ff       	call   8018ae <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
  801e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e6a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e6e:	75 07                	jne    801e77 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e70:	b8 01 00 00 00       	mov    $0x1,%eax
  801e75:	eb 05                	jmp    801e7c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 2c                	push   $0x2c
  801e90:	e8 19 fa ff ff       	call   8018ae <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
  801e98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e9b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e9f:	75 07                	jne    801ea8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ea1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea6:	eb 05                	jmp    801ead <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	ff 75 08             	pushl  0x8(%ebp)
  801ebd:	6a 2d                	push   $0x2d
  801ebf:	e8 ea f9 ff ff       	call   8018ae <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec7:	90                   	nop
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ece:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	6a 00                	push   $0x0
  801edc:	53                   	push   %ebx
  801edd:	51                   	push   %ecx
  801ede:	52                   	push   %edx
  801edf:	50                   	push   %eax
  801ee0:	6a 2e                	push   $0x2e
  801ee2:	e8 c7 f9 ff ff       	call   8018ae <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
}
  801eea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ef2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	52                   	push   %edx
  801eff:	50                   	push   %eax
  801f00:	6a 2f                	push   $0x2f
  801f02:	e8 a7 f9 ff ff       	call   8018ae <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
}
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	68 88 3f 80 00       	push   $0x803f88
  801f1a:	e8 1e e8 ff ff       	call   80073d <cprintf>
  801f1f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f29:	83 ec 0c             	sub    $0xc,%esp
  801f2c:	68 b4 3f 80 00       	push   $0x803fb4
  801f31:	e8 07 e8 ff ff       	call   80073d <cprintf>
  801f36:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f39:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f3d:	a1 38 51 80 00       	mov    0x805138,%eax
  801f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f45:	eb 56                	jmp    801f9d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f4b:	74 1c                	je     801f69 <print_mem_block_lists+0x5d>
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 50 08             	mov    0x8(%eax),%edx
  801f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f56:	8b 48 08             	mov    0x8(%eax),%ecx
  801f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5f:	01 c8                	add    %ecx,%eax
  801f61:	39 c2                	cmp    %eax,%edx
  801f63:	73 04                	jae    801f69 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f65:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	8b 50 08             	mov    0x8(%eax),%edx
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	8b 40 0c             	mov    0xc(%eax),%eax
  801f75:	01 c2                	add    %eax,%edx
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 40 08             	mov    0x8(%eax),%eax
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	52                   	push   %edx
  801f81:	50                   	push   %eax
  801f82:	68 c9 3f 80 00       	push   $0x803fc9
  801f87:	e8 b1 e7 ff ff       	call   80073d <cprintf>
  801f8c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f95:	a1 40 51 80 00       	mov    0x805140,%eax
  801f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa1:	74 07                	je     801faa <print_mem_block_lists+0x9e>
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 00                	mov    (%eax),%eax
  801fa8:	eb 05                	jmp    801faf <print_mem_block_lists+0xa3>
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax
  801faf:	a3 40 51 80 00       	mov    %eax,0x805140
  801fb4:	a1 40 51 80 00       	mov    0x805140,%eax
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	75 8a                	jne    801f47 <print_mem_block_lists+0x3b>
  801fbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc1:	75 84                	jne    801f47 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fc3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc7:	75 10                	jne    801fd9 <print_mem_block_lists+0xcd>
  801fc9:	83 ec 0c             	sub    $0xc,%esp
  801fcc:	68 d8 3f 80 00       	push   $0x803fd8
  801fd1:	e8 67 e7 ff ff       	call   80073d <cprintf>
  801fd6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fd9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fe0:	83 ec 0c             	sub    $0xc,%esp
  801fe3:	68 fc 3f 80 00       	push   $0x803ffc
  801fe8:	e8 50 e7 ff ff       	call   80073d <cprintf>
  801fed:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ff0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ff4:	a1 40 50 80 00       	mov    0x805040,%eax
  801ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ffc:	eb 56                	jmp    802054 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ffe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802002:	74 1c                	je     802020 <print_mem_block_lists+0x114>
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	8b 50 08             	mov    0x8(%eax),%edx
  80200a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200d:	8b 48 08             	mov    0x8(%eax),%ecx
  802010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802013:	8b 40 0c             	mov    0xc(%eax),%eax
  802016:	01 c8                	add    %ecx,%eax
  802018:	39 c2                	cmp    %eax,%edx
  80201a:	73 04                	jae    802020 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80201c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	8b 50 08             	mov    0x8(%eax),%edx
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	8b 40 0c             	mov    0xc(%eax),%eax
  80202c:	01 c2                	add    %eax,%edx
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	8b 40 08             	mov    0x8(%eax),%eax
  802034:	83 ec 04             	sub    $0x4,%esp
  802037:	52                   	push   %edx
  802038:	50                   	push   %eax
  802039:	68 c9 3f 80 00       	push   $0x803fc9
  80203e:	e8 fa e6 ff ff       	call   80073d <cprintf>
  802043:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802049:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80204c:	a1 48 50 80 00       	mov    0x805048,%eax
  802051:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802054:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802058:	74 07                	je     802061 <print_mem_block_lists+0x155>
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	8b 00                	mov    (%eax),%eax
  80205f:	eb 05                	jmp    802066 <print_mem_block_lists+0x15a>
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
  802066:	a3 48 50 80 00       	mov    %eax,0x805048
  80206b:	a1 48 50 80 00       	mov    0x805048,%eax
  802070:	85 c0                	test   %eax,%eax
  802072:	75 8a                	jne    801ffe <print_mem_block_lists+0xf2>
  802074:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802078:	75 84                	jne    801ffe <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80207a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80207e:	75 10                	jne    802090 <print_mem_block_lists+0x184>
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	68 14 40 80 00       	push   $0x804014
  802088:	e8 b0 e6 ff ff       	call   80073d <cprintf>
  80208d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802090:	83 ec 0c             	sub    $0xc,%esp
  802093:	68 88 3f 80 00       	push   $0x803f88
  802098:	e8 a0 e6 ff ff       	call   80073d <cprintf>
  80209d:	83 c4 10             	add    $0x10,%esp

}
  8020a0:	90                   	nop
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020a9:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020b0:	00 00 00 
  8020b3:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020ba:	00 00 00 
  8020bd:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020c4:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020ce:	e9 9e 00 00 00       	jmp    802171 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020d3:	a1 50 50 80 00       	mov    0x805050,%eax
  8020d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020db:	c1 e2 04             	shl    $0x4,%edx
  8020de:	01 d0                	add    %edx,%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 14                	jne    8020f8 <initialize_MemBlocksList+0x55>
  8020e4:	83 ec 04             	sub    $0x4,%esp
  8020e7:	68 3c 40 80 00       	push   $0x80403c
  8020ec:	6a 46                	push   $0x46
  8020ee:	68 5f 40 80 00       	push   $0x80405f
  8020f3:	e8 64 14 00 00       	call   80355c <_panic>
  8020f8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802100:	c1 e2 04             	shl    $0x4,%edx
  802103:	01 d0                	add    %edx,%eax
  802105:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80210b:	89 10                	mov    %edx,(%eax)
  80210d:	8b 00                	mov    (%eax),%eax
  80210f:	85 c0                	test   %eax,%eax
  802111:	74 18                	je     80212b <initialize_MemBlocksList+0x88>
  802113:	a1 48 51 80 00       	mov    0x805148,%eax
  802118:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80211e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802121:	c1 e1 04             	shl    $0x4,%ecx
  802124:	01 ca                	add    %ecx,%edx
  802126:	89 50 04             	mov    %edx,0x4(%eax)
  802129:	eb 12                	jmp    80213d <initialize_MemBlocksList+0x9a>
  80212b:	a1 50 50 80 00       	mov    0x805050,%eax
  802130:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802133:	c1 e2 04             	shl    $0x4,%edx
  802136:	01 d0                	add    %edx,%eax
  802138:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80213d:	a1 50 50 80 00       	mov    0x805050,%eax
  802142:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802145:	c1 e2 04             	shl    $0x4,%edx
  802148:	01 d0                	add    %edx,%eax
  80214a:	a3 48 51 80 00       	mov    %eax,0x805148
  80214f:	a1 50 50 80 00       	mov    0x805050,%eax
  802154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802157:	c1 e2 04             	shl    $0x4,%edx
  80215a:	01 d0                	add    %edx,%eax
  80215c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802163:	a1 54 51 80 00       	mov    0x805154,%eax
  802168:	40                   	inc    %eax
  802169:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80216e:	ff 45 f4             	incl   -0xc(%ebp)
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	3b 45 08             	cmp    0x8(%ebp),%eax
  802177:	0f 82 56 ff ff ff    	jb     8020d3 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80217d:	90                   	nop
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	8b 00                	mov    (%eax),%eax
  80218b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80218e:	eb 19                	jmp    8021a9 <find_block+0x29>
	{
		if(va==point->sva)
  802190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802193:	8b 40 08             	mov    0x8(%eax),%eax
  802196:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802199:	75 05                	jne    8021a0 <find_block+0x20>
		   return point;
  80219b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219e:	eb 36                	jmp    8021d6 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	8b 40 08             	mov    0x8(%eax),%eax
  8021a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ad:	74 07                	je     8021b6 <find_block+0x36>
  8021af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b2:	8b 00                	mov    (%eax),%eax
  8021b4:	eb 05                	jmp    8021bb <find_block+0x3b>
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021be:	89 42 08             	mov    %eax,0x8(%edx)
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	8b 40 08             	mov    0x8(%eax),%eax
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	75 c5                	jne    802190 <find_block+0x10>
  8021cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021cf:	75 bf                	jne    802190 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021de:	a1 40 50 80 00       	mov    0x805040,%eax
  8021e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021e6:	a1 44 50 80 00       	mov    0x805044,%eax
  8021eb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021f4:	74 24                	je     80221a <insert_sorted_allocList+0x42>
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	8b 50 08             	mov    0x8(%eax),%edx
  8021fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ff:	8b 40 08             	mov    0x8(%eax),%eax
  802202:	39 c2                	cmp    %eax,%edx
  802204:	76 14                	jbe    80221a <insert_sorted_allocList+0x42>
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	8b 50 08             	mov    0x8(%eax),%edx
  80220c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220f:	8b 40 08             	mov    0x8(%eax),%eax
  802212:	39 c2                	cmp    %eax,%edx
  802214:	0f 82 60 01 00 00    	jb     80237a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80221a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80221e:	75 65                	jne    802285 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802220:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802224:	75 14                	jne    80223a <insert_sorted_allocList+0x62>
  802226:	83 ec 04             	sub    $0x4,%esp
  802229:	68 3c 40 80 00       	push   $0x80403c
  80222e:	6a 6b                	push   $0x6b
  802230:	68 5f 40 80 00       	push   $0x80405f
  802235:	e8 22 13 00 00       	call   80355c <_panic>
  80223a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	89 10                	mov    %edx,(%eax)
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	74 0d                	je     80225b <insert_sorted_allocList+0x83>
  80224e:	a1 40 50 80 00       	mov    0x805040,%eax
  802253:	8b 55 08             	mov    0x8(%ebp),%edx
  802256:	89 50 04             	mov    %edx,0x4(%eax)
  802259:	eb 08                	jmp    802263 <insert_sorted_allocList+0x8b>
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	a3 44 50 80 00       	mov    %eax,0x805044
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	a3 40 50 80 00       	mov    %eax,0x805040
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802275:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80227a:	40                   	inc    %eax
  80227b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802280:	e9 dc 01 00 00       	jmp    802461 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	8b 50 08             	mov    0x8(%eax),%edx
  80228b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228e:	8b 40 08             	mov    0x8(%eax),%eax
  802291:	39 c2                	cmp    %eax,%edx
  802293:	77 6c                	ja     802301 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802295:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802299:	74 06                	je     8022a1 <insert_sorted_allocList+0xc9>
  80229b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229f:	75 14                	jne    8022b5 <insert_sorted_allocList+0xdd>
  8022a1:	83 ec 04             	sub    $0x4,%esp
  8022a4:	68 78 40 80 00       	push   $0x804078
  8022a9:	6a 6f                	push   $0x6f
  8022ab:	68 5f 40 80 00       	push   $0x80405f
  8022b0:	e8 a7 12 00 00       	call   80355c <_panic>
  8022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b8:	8b 50 04             	mov    0x4(%eax),%edx
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c7:	89 10                	mov    %edx,(%eax)
  8022c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cc:	8b 40 04             	mov    0x4(%eax),%eax
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	74 0d                	je     8022e0 <insert_sorted_allocList+0x108>
  8022d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d6:	8b 40 04             	mov    0x4(%eax),%eax
  8022d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022dc:	89 10                	mov    %edx,(%eax)
  8022de:	eb 08                	jmp    8022e8 <insert_sorted_allocList+0x110>
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	a3 40 50 80 00       	mov    %eax,0x805040
  8022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ee:	89 50 04             	mov    %edx,0x4(%eax)
  8022f1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022f6:	40                   	inc    %eax
  8022f7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022fc:	e9 60 01 00 00       	jmp    802461 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	8b 50 08             	mov    0x8(%eax),%edx
  802307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230a:	8b 40 08             	mov    0x8(%eax),%eax
  80230d:	39 c2                	cmp    %eax,%edx
  80230f:	0f 82 4c 01 00 00    	jb     802461 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802315:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802319:	75 14                	jne    80232f <insert_sorted_allocList+0x157>
  80231b:	83 ec 04             	sub    $0x4,%esp
  80231e:	68 b0 40 80 00       	push   $0x8040b0
  802323:	6a 73                	push   $0x73
  802325:	68 5f 40 80 00       	push   $0x80405f
  80232a:	e8 2d 12 00 00       	call   80355c <_panic>
  80232f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	89 50 04             	mov    %edx,0x4(%eax)
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	8b 40 04             	mov    0x4(%eax),%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	74 0c                	je     802351 <insert_sorted_allocList+0x179>
  802345:	a1 44 50 80 00       	mov    0x805044,%eax
  80234a:	8b 55 08             	mov    0x8(%ebp),%edx
  80234d:	89 10                	mov    %edx,(%eax)
  80234f:	eb 08                	jmp    802359 <insert_sorted_allocList+0x181>
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	a3 40 50 80 00       	mov    %eax,0x805040
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	a3 44 50 80 00       	mov    %eax,0x805044
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80236f:	40                   	inc    %eax
  802370:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802375:	e9 e7 00 00 00       	jmp    802461 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80237a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802380:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802387:	a1 40 50 80 00       	mov    0x805040,%eax
  80238c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238f:	e9 9d 00 00 00       	jmp    802431 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 00                	mov    (%eax),%eax
  802399:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	8b 50 08             	mov    0x8(%eax),%edx
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 40 08             	mov    0x8(%eax),%eax
  8023a8:	39 c2                	cmp    %eax,%edx
  8023aa:	76 7d                	jbe    802429 <insert_sorted_allocList+0x251>
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	8b 50 08             	mov    0x8(%eax),%edx
  8023b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023b5:	8b 40 08             	mov    0x8(%eax),%eax
  8023b8:	39 c2                	cmp    %eax,%edx
  8023ba:	73 6d                	jae    802429 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c0:	74 06                	je     8023c8 <insert_sorted_allocList+0x1f0>
  8023c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c6:	75 14                	jne    8023dc <insert_sorted_allocList+0x204>
  8023c8:	83 ec 04             	sub    $0x4,%esp
  8023cb:	68 d4 40 80 00       	push   $0x8040d4
  8023d0:	6a 7f                	push   $0x7f
  8023d2:	68 5f 40 80 00       	push   $0x80405f
  8023d7:	e8 80 11 00 00       	call   80355c <_panic>
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 10                	mov    (%eax),%edx
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	89 10                	mov    %edx,(%eax)
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	8b 00                	mov    (%eax),%eax
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	74 0b                	je     8023fa <insert_sorted_allocList+0x222>
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 00                	mov    (%eax),%eax
  8023f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f7:	89 50 04             	mov    %edx,0x4(%eax)
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802400:	89 10                	mov    %edx,(%eax)
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802408:	89 50 04             	mov    %edx,0x4(%eax)
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	85 c0                	test   %eax,%eax
  802412:	75 08                	jne    80241c <insert_sorted_allocList+0x244>
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	a3 44 50 80 00       	mov    %eax,0x805044
  80241c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802421:	40                   	inc    %eax
  802422:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802427:	eb 39                	jmp    802462 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802429:	a1 48 50 80 00       	mov    0x805048,%eax
  80242e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802435:	74 07                	je     80243e <insert_sorted_allocList+0x266>
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 00                	mov    (%eax),%eax
  80243c:	eb 05                	jmp    802443 <insert_sorted_allocList+0x26b>
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
  802443:	a3 48 50 80 00       	mov    %eax,0x805048
  802448:	a1 48 50 80 00       	mov    0x805048,%eax
  80244d:	85 c0                	test   %eax,%eax
  80244f:	0f 85 3f ff ff ff    	jne    802394 <insert_sorted_allocList+0x1bc>
  802455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802459:	0f 85 35 ff ff ff    	jne    802394 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80245f:	eb 01                	jmp    802462 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802461:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802462:	90                   	nop
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80246b:	a1 38 51 80 00       	mov    0x805138,%eax
  802470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802473:	e9 85 01 00 00       	jmp    8025fd <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 40 0c             	mov    0xc(%eax),%eax
  80247e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802481:	0f 82 6e 01 00 00    	jb     8025f5 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 0c             	mov    0xc(%eax),%eax
  80248d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802490:	0f 85 8a 00 00 00    	jne    802520 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249a:	75 17                	jne    8024b3 <alloc_block_FF+0x4e>
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	68 08 41 80 00       	push   $0x804108
  8024a4:	68 93 00 00 00       	push   $0x93
  8024a9:	68 5f 40 80 00       	push   $0x80405f
  8024ae:	e8 a9 10 00 00       	call   80355c <_panic>
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 10                	je     8024cc <alloc_block_FF+0x67>
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 00                	mov    (%eax),%eax
  8024c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c4:	8b 52 04             	mov    0x4(%edx),%edx
  8024c7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ca:	eb 0b                	jmp    8024d7 <alloc_block_FF+0x72>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 40 04             	mov    0x4(%eax),%eax
  8024d2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 04             	mov    0x4(%eax),%eax
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	74 0f                	je     8024f0 <alloc_block_FF+0x8b>
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 40 04             	mov    0x4(%eax),%eax
  8024e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ea:	8b 12                	mov    (%edx),%edx
  8024ec:	89 10                	mov    %edx,(%eax)
  8024ee:	eb 0a                	jmp    8024fa <alloc_block_FF+0x95>
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 00                	mov    (%eax),%eax
  8024f5:	a3 38 51 80 00       	mov    %eax,0x805138
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250d:	a1 44 51 80 00       	mov    0x805144,%eax
  802512:	48                   	dec    %eax
  802513:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	e9 10 01 00 00       	jmp    802630 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 0c             	mov    0xc(%eax),%eax
  802526:	3b 45 08             	cmp    0x8(%ebp),%eax
  802529:	0f 86 c6 00 00 00    	jbe    8025f5 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80252f:	a1 48 51 80 00       	mov    0x805148,%eax
  802534:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 50 08             	mov    0x8(%eax),%edx
  80253d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802540:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802546:	8b 55 08             	mov    0x8(%ebp),%edx
  802549:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80254c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802550:	75 17                	jne    802569 <alloc_block_FF+0x104>
  802552:	83 ec 04             	sub    $0x4,%esp
  802555:	68 08 41 80 00       	push   $0x804108
  80255a:	68 9b 00 00 00       	push   $0x9b
  80255f:	68 5f 40 80 00       	push   $0x80405f
  802564:	e8 f3 0f 00 00       	call   80355c <_panic>
  802569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	74 10                	je     802582 <alloc_block_FF+0x11d>
  802572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80257a:	8b 52 04             	mov    0x4(%edx),%edx
  80257d:	89 50 04             	mov    %edx,0x4(%eax)
  802580:	eb 0b                	jmp    80258d <alloc_block_FF+0x128>
  802582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802585:	8b 40 04             	mov    0x4(%eax),%eax
  802588:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802590:	8b 40 04             	mov    0x4(%eax),%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	74 0f                	je     8025a6 <alloc_block_FF+0x141>
  802597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259a:	8b 40 04             	mov    0x4(%eax),%eax
  80259d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a0:	8b 12                	mov    (%edx),%edx
  8025a2:	89 10                	mov    %edx,(%eax)
  8025a4:	eb 0a                	jmp    8025b0 <alloc_block_FF+0x14b>
  8025a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8025c8:	48                   	dec    %eax
  8025c9:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 50 08             	mov    0x8(%eax),%edx
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	01 c2                	add    %eax,%edx
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e5:	2b 45 08             	sub    0x8(%ebp),%eax
  8025e8:	89 c2                	mov    %eax,%edx
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f3:	eb 3b                	jmp    802630 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8025fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802601:	74 07                	je     80260a <alloc_block_FF+0x1a5>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	eb 05                	jmp    80260f <alloc_block_FF+0x1aa>
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
  80260f:	a3 40 51 80 00       	mov    %eax,0x805140
  802614:	a1 40 51 80 00       	mov    0x805140,%eax
  802619:	85 c0                	test   %eax,%eax
  80261b:	0f 85 57 fe ff ff    	jne    802478 <alloc_block_FF+0x13>
  802621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802625:	0f 85 4d fe ff ff    	jne    802478 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80262b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
  802635:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802638:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80263f:	a1 38 51 80 00       	mov    0x805138,%eax
  802644:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802647:	e9 df 00 00 00       	jmp    80272b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 0c             	mov    0xc(%eax),%eax
  802652:	3b 45 08             	cmp    0x8(%ebp),%eax
  802655:	0f 82 c8 00 00 00    	jb     802723 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 40 0c             	mov    0xc(%eax),%eax
  802661:	3b 45 08             	cmp    0x8(%ebp),%eax
  802664:	0f 85 8a 00 00 00    	jne    8026f4 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80266a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266e:	75 17                	jne    802687 <alloc_block_BF+0x55>
  802670:	83 ec 04             	sub    $0x4,%esp
  802673:	68 08 41 80 00       	push   $0x804108
  802678:	68 b7 00 00 00       	push   $0xb7
  80267d:	68 5f 40 80 00       	push   $0x80405f
  802682:	e8 d5 0e 00 00       	call   80355c <_panic>
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	74 10                	je     8026a0 <alloc_block_BF+0x6e>
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802698:	8b 52 04             	mov    0x4(%edx),%edx
  80269b:	89 50 04             	mov    %edx,0x4(%eax)
  80269e:	eb 0b                	jmp    8026ab <alloc_block_BF+0x79>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 04             	mov    0x4(%eax),%eax
  8026a6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 04             	mov    0x4(%eax),%eax
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	74 0f                	je     8026c4 <alloc_block_BF+0x92>
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 40 04             	mov    0x4(%eax),%eax
  8026bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026be:	8b 12                	mov    (%edx),%edx
  8026c0:	89 10                	mov    %edx,(%eax)
  8026c2:	eb 0a                	jmp    8026ce <alloc_block_BF+0x9c>
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	a3 38 51 80 00       	mov    %eax,0x805138
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8026e6:	48                   	dec    %eax
  8026e7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	e9 4d 01 00 00       	jmp    802841 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fd:	76 24                	jbe    802723 <alloc_block_BF+0xf1>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 40 0c             	mov    0xc(%eax),%eax
  802705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802708:	73 19                	jae    802723 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80270a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 0c             	mov    0xc(%eax),%eax
  802717:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 08             	mov    0x8(%eax),%eax
  802720:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802723:	a1 40 51 80 00       	mov    0x805140,%eax
  802728:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272f:	74 07                	je     802738 <alloc_block_BF+0x106>
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 00                	mov    (%eax),%eax
  802736:	eb 05                	jmp    80273d <alloc_block_BF+0x10b>
  802738:	b8 00 00 00 00       	mov    $0x0,%eax
  80273d:	a3 40 51 80 00       	mov    %eax,0x805140
  802742:	a1 40 51 80 00       	mov    0x805140,%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	0f 85 fd fe ff ff    	jne    80264c <alloc_block_BF+0x1a>
  80274f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802753:	0f 85 f3 fe ff ff    	jne    80264c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802759:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80275d:	0f 84 d9 00 00 00    	je     80283c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802763:	a1 48 51 80 00       	mov    0x805148,%eax
  802768:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80276b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802771:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802777:	8b 55 08             	mov    0x8(%ebp),%edx
  80277a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80277d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802781:	75 17                	jne    80279a <alloc_block_BF+0x168>
  802783:	83 ec 04             	sub    $0x4,%esp
  802786:	68 08 41 80 00       	push   $0x804108
  80278b:	68 c7 00 00 00       	push   $0xc7
  802790:	68 5f 40 80 00       	push   $0x80405f
  802795:	e8 c2 0d 00 00       	call   80355c <_panic>
  80279a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	74 10                	je     8027b3 <alloc_block_BF+0x181>
  8027a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a6:	8b 00                	mov    (%eax),%eax
  8027a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ab:	8b 52 04             	mov    0x4(%edx),%edx
  8027ae:	89 50 04             	mov    %edx,0x4(%eax)
  8027b1:	eb 0b                	jmp    8027be <alloc_block_BF+0x18c>
  8027b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b6:	8b 40 04             	mov    0x4(%eax),%eax
  8027b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	74 0f                	je     8027d7 <alloc_block_BF+0x1a5>
  8027c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027cb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d1:	8b 12                	mov    (%edx),%edx
  8027d3:	89 10                	mov    %edx,(%eax)
  8027d5:	eb 0a                	jmp    8027e1 <alloc_block_BF+0x1af>
  8027d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8027e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8027f9:	48                   	dec    %eax
  8027fa:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027ff:	83 ec 08             	sub    $0x8,%esp
  802802:	ff 75 ec             	pushl  -0x14(%ebp)
  802805:	68 38 51 80 00       	push   $0x805138
  80280a:	e8 71 f9 ff ff       	call   802180 <find_block>
  80280f:	83 c4 10             	add    $0x10,%esp
  802812:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802815:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802818:	8b 50 08             	mov    0x8(%eax),%edx
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	01 c2                	add    %eax,%edx
  802820:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802823:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802826:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802829:	8b 40 0c             	mov    0xc(%eax),%eax
  80282c:	2b 45 08             	sub    0x8(%ebp),%eax
  80282f:	89 c2                	mov    %eax,%edx
  802831:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802834:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283a:	eb 05                	jmp    802841 <alloc_block_BF+0x20f>
	}
	return NULL;
  80283c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802849:	a1 28 50 80 00       	mov    0x805028,%eax
  80284e:	85 c0                	test   %eax,%eax
  802850:	0f 85 de 01 00 00    	jne    802a34 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802856:	a1 38 51 80 00       	mov    0x805138,%eax
  80285b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285e:	e9 9e 01 00 00       	jmp    802a01 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 40 0c             	mov    0xc(%eax),%eax
  802869:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286c:	0f 82 87 01 00 00    	jb     8029f9 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 40 0c             	mov    0xc(%eax),%eax
  802878:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287b:	0f 85 95 00 00 00    	jne    802916 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802885:	75 17                	jne    80289e <alloc_block_NF+0x5b>
  802887:	83 ec 04             	sub    $0x4,%esp
  80288a:	68 08 41 80 00       	push   $0x804108
  80288f:	68 e0 00 00 00       	push   $0xe0
  802894:	68 5f 40 80 00       	push   $0x80405f
  802899:	e8 be 0c 00 00       	call   80355c <_panic>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	74 10                	je     8028b7 <alloc_block_NF+0x74>
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	8b 00                	mov    (%eax),%eax
  8028ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028af:	8b 52 04             	mov    0x4(%edx),%edx
  8028b2:	89 50 04             	mov    %edx,0x4(%eax)
  8028b5:	eb 0b                	jmp    8028c2 <alloc_block_NF+0x7f>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 04             	mov    0x4(%eax),%eax
  8028bd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 04             	mov    0x4(%eax),%eax
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	74 0f                	je     8028db <alloc_block_NF+0x98>
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 04             	mov    0x4(%eax),%eax
  8028d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d5:	8b 12                	mov    (%edx),%edx
  8028d7:	89 10                	mov    %edx,(%eax)
  8028d9:	eb 0a                	jmp    8028e5 <alloc_block_NF+0xa2>
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8028fd:	48                   	dec    %eax
  8028fe:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 40 08             	mov    0x8(%eax),%eax
  802909:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	e9 f8 04 00 00       	jmp    802e0e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 40 0c             	mov    0xc(%eax),%eax
  80291c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291f:	0f 86 d4 00 00 00    	jbe    8029f9 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802925:	a1 48 51 80 00       	mov    0x805148,%eax
  80292a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 50 08             	mov    0x8(%eax),%edx
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293c:	8b 55 08             	mov    0x8(%ebp),%edx
  80293f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802942:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802946:	75 17                	jne    80295f <alloc_block_NF+0x11c>
  802948:	83 ec 04             	sub    $0x4,%esp
  80294b:	68 08 41 80 00       	push   $0x804108
  802950:	68 e9 00 00 00       	push   $0xe9
  802955:	68 5f 40 80 00       	push   $0x80405f
  80295a:	e8 fd 0b 00 00       	call   80355c <_panic>
  80295f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	85 c0                	test   %eax,%eax
  802966:	74 10                	je     802978 <alloc_block_NF+0x135>
  802968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802970:	8b 52 04             	mov    0x4(%edx),%edx
  802973:	89 50 04             	mov    %edx,0x4(%eax)
  802976:	eb 0b                	jmp    802983 <alloc_block_NF+0x140>
  802978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297b:	8b 40 04             	mov    0x4(%eax),%eax
  80297e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802986:	8b 40 04             	mov    0x4(%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 0f                	je     80299c <alloc_block_NF+0x159>
  80298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802996:	8b 12                	mov    (%edx),%edx
  802998:	89 10                	mov    %edx,(%eax)
  80299a:	eb 0a                	jmp    8029a6 <alloc_block_NF+0x163>
  80299c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	a3 48 51 80 00       	mov    %eax,0x805148
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b9:	a1 54 51 80 00       	mov    0x805154,%eax
  8029be:	48                   	dec    %eax
  8029bf:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ca:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 50 08             	mov    0x8(%eax),%edx
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	01 c2                	add    %eax,%edx
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e6:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e9:	89 c2                	mov    %eax,%edx
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f4:	e9 15 04 00 00       	jmp    802e0e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8029fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a05:	74 07                	je     802a0e <alloc_block_NF+0x1cb>
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	eb 05                	jmp    802a13 <alloc_block_NF+0x1d0>
  802a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a13:	a3 40 51 80 00       	mov    %eax,0x805140
  802a18:	a1 40 51 80 00       	mov    0x805140,%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	0f 85 3e fe ff ff    	jne    802863 <alloc_block_NF+0x20>
  802a25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a29:	0f 85 34 fe ff ff    	jne    802863 <alloc_block_NF+0x20>
  802a2f:	e9 d5 03 00 00       	jmp    802e09 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a34:	a1 38 51 80 00       	mov    0x805138,%eax
  802a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3c:	e9 b1 01 00 00       	jmp    802bf2 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 50 08             	mov    0x8(%eax),%edx
  802a47:	a1 28 50 80 00       	mov    0x805028,%eax
  802a4c:	39 c2                	cmp    %eax,%edx
  802a4e:	0f 82 96 01 00 00    	jb     802bea <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5d:	0f 82 87 01 00 00    	jb     802bea <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 40 0c             	mov    0xc(%eax),%eax
  802a69:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6c:	0f 85 95 00 00 00    	jne    802b07 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a76:	75 17                	jne    802a8f <alloc_block_NF+0x24c>
  802a78:	83 ec 04             	sub    $0x4,%esp
  802a7b:	68 08 41 80 00       	push   $0x804108
  802a80:	68 fc 00 00 00       	push   $0xfc
  802a85:	68 5f 40 80 00       	push   $0x80405f
  802a8a:	e8 cd 0a 00 00       	call   80355c <_panic>
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	74 10                	je     802aa8 <alloc_block_NF+0x265>
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 00                	mov    (%eax),%eax
  802a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa0:	8b 52 04             	mov    0x4(%edx),%edx
  802aa3:	89 50 04             	mov    %edx,0x4(%eax)
  802aa6:	eb 0b                	jmp    802ab3 <alloc_block_NF+0x270>
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 40 04             	mov    0x4(%eax),%eax
  802aae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 0f                	je     802acc <alloc_block_NF+0x289>
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 40 04             	mov    0x4(%eax),%eax
  802ac3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac6:	8b 12                	mov    (%edx),%edx
  802ac8:	89 10                	mov    %edx,(%eax)
  802aca:	eb 0a                	jmp    802ad6 <alloc_block_NF+0x293>
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae9:	a1 44 51 80 00       	mov    0x805144,%eax
  802aee:	48                   	dec    %eax
  802aef:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 08             	mov    0x8(%eax),%eax
  802afa:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	e9 07 03 00 00       	jmp    802e0e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b10:	0f 86 d4 00 00 00    	jbe    802bea <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b16:	a1 48 51 80 00       	mov    0x805148,%eax
  802b1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 50 08             	mov    0x8(%eax),%edx
  802b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b27:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b30:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b33:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b37:	75 17                	jne    802b50 <alloc_block_NF+0x30d>
  802b39:	83 ec 04             	sub    $0x4,%esp
  802b3c:	68 08 41 80 00       	push   $0x804108
  802b41:	68 04 01 00 00       	push   $0x104
  802b46:	68 5f 40 80 00       	push   $0x80405f
  802b4b:	e8 0c 0a 00 00       	call   80355c <_panic>
  802b50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 10                	je     802b69 <alloc_block_NF+0x326>
  802b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b61:	8b 52 04             	mov    0x4(%edx),%edx
  802b64:	89 50 04             	mov    %edx,0x4(%eax)
  802b67:	eb 0b                	jmp    802b74 <alloc_block_NF+0x331>
  802b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6c:	8b 40 04             	mov    0x4(%eax),%eax
  802b6f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 0f                	je     802b8d <alloc_block_NF+0x34a>
  802b7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b81:	8b 40 04             	mov    0x4(%eax),%eax
  802b84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b87:	8b 12                	mov    (%edx),%edx
  802b89:	89 10                	mov    %edx,(%eax)
  802b8b:	eb 0a                	jmp    802b97 <alloc_block_NF+0x354>
  802b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	a3 48 51 80 00       	mov    %eax,0x805148
  802b97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802baa:	a1 54 51 80 00       	mov    0x805154,%eax
  802baf:	48                   	dec    %eax
  802bb0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb8:	8b 40 08             	mov    0x8(%eax),%eax
  802bbb:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 50 08             	mov    0x8(%eax),%edx
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	01 c2                	add    %eax,%edx
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd7:	2b 45 08             	sub    0x8(%ebp),%eax
  802bda:	89 c2                	mov    %eax,%edx
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be5:	e9 24 02 00 00       	jmp    802e0e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bea:	a1 40 51 80 00       	mov    0x805140,%eax
  802bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf6:	74 07                	je     802bff <alloc_block_NF+0x3bc>
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	eb 05                	jmp    802c04 <alloc_block_NF+0x3c1>
  802bff:	b8 00 00 00 00       	mov    $0x0,%eax
  802c04:	a3 40 51 80 00       	mov    %eax,0x805140
  802c09:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	0f 85 2b fe ff ff    	jne    802a41 <alloc_block_NF+0x1fe>
  802c16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1a:	0f 85 21 fe ff ff    	jne    802a41 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c20:	a1 38 51 80 00       	mov    0x805138,%eax
  802c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c28:	e9 ae 01 00 00       	jmp    802ddb <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 50 08             	mov    0x8(%eax),%edx
  802c33:	a1 28 50 80 00       	mov    0x805028,%eax
  802c38:	39 c2                	cmp    %eax,%edx
  802c3a:	0f 83 93 01 00 00    	jae    802dd3 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 0c             	mov    0xc(%eax),%eax
  802c46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c49:	0f 82 84 01 00 00    	jb     802dd3 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 0c             	mov    0xc(%eax),%eax
  802c55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c58:	0f 85 95 00 00 00    	jne    802cf3 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	75 17                	jne    802c7b <alloc_block_NF+0x438>
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	68 08 41 80 00       	push   $0x804108
  802c6c:	68 14 01 00 00       	push   $0x114
  802c71:	68 5f 40 80 00       	push   $0x80405f
  802c76:	e8 e1 08 00 00       	call   80355c <_panic>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 10                	je     802c94 <alloc_block_NF+0x451>
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8c:	8b 52 04             	mov    0x4(%edx),%edx
  802c8f:	89 50 04             	mov    %edx,0x4(%eax)
  802c92:	eb 0b                	jmp    802c9f <alloc_block_NF+0x45c>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 04             	mov    0x4(%eax),%eax
  802c9a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 0f                	je     802cb8 <alloc_block_NF+0x475>
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 04             	mov    0x4(%eax),%eax
  802caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb2:	8b 12                	mov    (%edx),%edx
  802cb4:	89 10                	mov    %edx,(%eax)
  802cb6:	eb 0a                	jmp    802cc2 <alloc_block_NF+0x47f>
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd5:	a1 44 51 80 00       	mov    0x805144,%eax
  802cda:	48                   	dec    %eax
  802cdb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 40 08             	mov    0x8(%eax),%eax
  802ce6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cee:	e9 1b 01 00 00       	jmp    802e0e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cfc:	0f 86 d1 00 00 00    	jbe    802dd3 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d02:	a1 48 51 80 00       	mov    0x805148,%eax
  802d07:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 50 08             	mov    0x8(%eax),%edx
  802d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d13:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d19:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d23:	75 17                	jne    802d3c <alloc_block_NF+0x4f9>
  802d25:	83 ec 04             	sub    $0x4,%esp
  802d28:	68 08 41 80 00       	push   $0x804108
  802d2d:	68 1c 01 00 00       	push   $0x11c
  802d32:	68 5f 40 80 00       	push   $0x80405f
  802d37:	e8 20 08 00 00       	call   80355c <_panic>
  802d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	74 10                	je     802d55 <alloc_block_NF+0x512>
  802d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d4d:	8b 52 04             	mov    0x4(%edx),%edx
  802d50:	89 50 04             	mov    %edx,0x4(%eax)
  802d53:	eb 0b                	jmp    802d60 <alloc_block_NF+0x51d>
  802d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d58:	8b 40 04             	mov    0x4(%eax),%eax
  802d5b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 0f                	je     802d79 <alloc_block_NF+0x536>
  802d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d73:	8b 12                	mov    (%edx),%edx
  802d75:	89 10                	mov    %edx,(%eax)
  802d77:	eb 0a                	jmp    802d83 <alloc_block_NF+0x540>
  802d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	a3 48 51 80 00       	mov    %eax,0x805148
  802d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d96:	a1 54 51 80 00       	mov    0x805154,%eax
  802d9b:	48                   	dec    %eax
  802d9c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	8b 40 08             	mov    0x8(%eax),%eax
  802da7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 50 08             	mov    0x8(%eax),%edx
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	01 c2                	add    %eax,%edx
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc3:	2b 45 08             	sub    0x8(%ebp),%eax
  802dc6:	89 c2                	mov    %eax,%edx
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	eb 3b                	jmp    802e0e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dd3:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddf:	74 07                	je     802de8 <alloc_block_NF+0x5a5>
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	eb 05                	jmp    802ded <alloc_block_NF+0x5aa>
  802de8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ded:	a3 40 51 80 00       	mov    %eax,0x805140
  802df2:	a1 40 51 80 00       	mov    0x805140,%eax
  802df7:	85 c0                	test   %eax,%eax
  802df9:	0f 85 2e fe ff ff    	jne    802c2d <alloc_block_NF+0x3ea>
  802dff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e03:	0f 85 24 fe ff ff    	jne    802c2d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0e:	c9                   	leave  
  802e0f:	c3                   	ret    

00802e10 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
  802e13:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e16:	a1 38 51 80 00       	mov    0x805138,%eax
  802e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e1e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e23:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e26:	a1 38 51 80 00       	mov    0x805138,%eax
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	74 14                	je     802e43 <insert_sorted_with_merge_freeList+0x33>
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 50 08             	mov    0x8(%eax),%edx
  802e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e38:	8b 40 08             	mov    0x8(%eax),%eax
  802e3b:	39 c2                	cmp    %eax,%edx
  802e3d:	0f 87 9b 01 00 00    	ja     802fde <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e47:	75 17                	jne    802e60 <insert_sorted_with_merge_freeList+0x50>
  802e49:	83 ec 04             	sub    $0x4,%esp
  802e4c:	68 3c 40 80 00       	push   $0x80403c
  802e51:	68 38 01 00 00       	push   $0x138
  802e56:	68 5f 40 80 00       	push   $0x80405f
  802e5b:	e8 fc 06 00 00       	call   80355c <_panic>
  802e60:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	89 10                	mov    %edx,(%eax)
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 0d                	je     802e81 <insert_sorted_with_merge_freeList+0x71>
  802e74:	a1 38 51 80 00       	mov    0x805138,%eax
  802e79:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7c:	89 50 04             	mov    %edx,0x4(%eax)
  802e7f:	eb 08                	jmp    802e89 <insert_sorted_with_merge_freeList+0x79>
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	a3 38 51 80 00       	mov    %eax,0x805138
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9b:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea0:	40                   	inc    %eax
  802ea1:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ea6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eaa:	0f 84 a8 06 00 00    	je     803558 <insert_sorted_with_merge_freeList+0x748>
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	8b 50 08             	mov    0x8(%eax),%edx
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebc:	01 c2                	add    %eax,%edx
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	8b 40 08             	mov    0x8(%eax),%eax
  802ec4:	39 c2                	cmp    %eax,%edx
  802ec6:	0f 85 8c 06 00 00    	jne    803558 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed8:	01 c2                	add    %eax,%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee4:	75 17                	jne    802efd <insert_sorted_with_merge_freeList+0xed>
  802ee6:	83 ec 04             	sub    $0x4,%esp
  802ee9:	68 08 41 80 00       	push   $0x804108
  802eee:	68 3c 01 00 00       	push   $0x13c
  802ef3:	68 5f 40 80 00       	push   $0x80405f
  802ef8:	e8 5f 06 00 00       	call   80355c <_panic>
  802efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	85 c0                	test   %eax,%eax
  802f04:	74 10                	je     802f16 <insert_sorted_with_merge_freeList+0x106>
  802f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0e:	8b 52 04             	mov    0x4(%edx),%edx
  802f11:	89 50 04             	mov    %edx,0x4(%eax)
  802f14:	eb 0b                	jmp    802f21 <insert_sorted_with_merge_freeList+0x111>
  802f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f19:	8b 40 04             	mov    0x4(%eax),%eax
  802f1c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f24:	8b 40 04             	mov    0x4(%eax),%eax
  802f27:	85 c0                	test   %eax,%eax
  802f29:	74 0f                	je     802f3a <insert_sorted_with_merge_freeList+0x12a>
  802f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2e:	8b 40 04             	mov    0x4(%eax),%eax
  802f31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f34:	8b 12                	mov    (%edx),%edx
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	eb 0a                	jmp    802f44 <insert_sorted_with_merge_freeList+0x134>
  802f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3d:	8b 00                	mov    (%eax),%eax
  802f3f:	a3 38 51 80 00       	mov    %eax,0x805138
  802f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f57:	a1 44 51 80 00       	mov    0x805144,%eax
  802f5c:	48                   	dec    %eax
  802f5d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f7a:	75 17                	jne    802f93 <insert_sorted_with_merge_freeList+0x183>
  802f7c:	83 ec 04             	sub    $0x4,%esp
  802f7f:	68 3c 40 80 00       	push   $0x80403c
  802f84:	68 3f 01 00 00       	push   $0x13f
  802f89:	68 5f 40 80 00       	push   $0x80405f
  802f8e:	e8 c9 05 00 00       	call   80355c <_panic>
  802f93:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9c:	89 10                	mov    %edx,(%eax)
  802f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa1:	8b 00                	mov    (%eax),%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	74 0d                	je     802fb4 <insert_sorted_with_merge_freeList+0x1a4>
  802fa7:	a1 48 51 80 00       	mov    0x805148,%eax
  802fac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802faf:	89 50 04             	mov    %edx,0x4(%eax)
  802fb2:	eb 08                	jmp    802fbc <insert_sorted_with_merge_freeList+0x1ac>
  802fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbf:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fce:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd3:	40                   	inc    %eax
  802fd4:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fd9:	e9 7a 05 00 00       	jmp    803558 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	8b 50 08             	mov    0x8(%eax),%edx
  802fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe7:	8b 40 08             	mov    0x8(%eax),%eax
  802fea:	39 c2                	cmp    %eax,%edx
  802fec:	0f 82 14 01 00 00    	jb     803106 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffe:	01 c2                	add    %eax,%edx
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 40 08             	mov    0x8(%eax),%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	0f 85 90 00 00 00    	jne    80309e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80300e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803011:	8b 50 0c             	mov    0xc(%eax),%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	8b 40 0c             	mov    0xc(%eax),%eax
  80301a:	01 c2                	add    %eax,%edx
  80301c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803036:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303a:	75 17                	jne    803053 <insert_sorted_with_merge_freeList+0x243>
  80303c:	83 ec 04             	sub    $0x4,%esp
  80303f:	68 3c 40 80 00       	push   $0x80403c
  803044:	68 49 01 00 00       	push   $0x149
  803049:	68 5f 40 80 00       	push   $0x80405f
  80304e:	e8 09 05 00 00       	call   80355c <_panic>
  803053:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	89 10                	mov    %edx,(%eax)
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	85 c0                	test   %eax,%eax
  803065:	74 0d                	je     803074 <insert_sorted_with_merge_freeList+0x264>
  803067:	a1 48 51 80 00       	mov    0x805148,%eax
  80306c:	8b 55 08             	mov    0x8(%ebp),%edx
  80306f:	89 50 04             	mov    %edx,0x4(%eax)
  803072:	eb 08                	jmp    80307c <insert_sorted_with_merge_freeList+0x26c>
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	a3 48 51 80 00       	mov    %eax,0x805148
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308e:	a1 54 51 80 00       	mov    0x805154,%eax
  803093:	40                   	inc    %eax
  803094:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803099:	e9 bb 04 00 00       	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80309e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a2:	75 17                	jne    8030bb <insert_sorted_with_merge_freeList+0x2ab>
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	68 b0 40 80 00       	push   $0x8040b0
  8030ac:	68 4c 01 00 00       	push   $0x14c
  8030b1:	68 5f 40 80 00       	push   $0x80405f
  8030b6:	e8 a1 04 00 00       	call   80355c <_panic>
  8030bb:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	89 50 04             	mov    %edx,0x4(%eax)
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	8b 40 04             	mov    0x4(%eax),%eax
  8030cd:	85 c0                	test   %eax,%eax
  8030cf:	74 0c                	je     8030dd <insert_sorted_with_merge_freeList+0x2cd>
  8030d1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d9:	89 10                	mov    %edx,(%eax)
  8030db:	eb 08                	jmp    8030e5 <insert_sorted_with_merge_freeList+0x2d5>
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8030fb:	40                   	inc    %eax
  8030fc:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803101:	e9 53 04 00 00       	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803106:	a1 38 51 80 00       	mov    0x805138,%eax
  80310b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310e:	e9 15 04 00 00       	jmp    803528 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	8b 50 08             	mov    0x8(%eax),%edx
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 40 08             	mov    0x8(%eax),%eax
  803127:	39 c2                	cmp    %eax,%edx
  803129:	0f 86 f1 03 00 00    	jbe    803520 <insert_sorted_with_merge_freeList+0x710>
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	8b 50 08             	mov    0x8(%eax),%edx
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	8b 40 08             	mov    0x8(%eax),%eax
  80313b:	39 c2                	cmp    %eax,%edx
  80313d:	0f 83 dd 03 00 00    	jae    803520 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	8b 50 08             	mov    0x8(%eax),%edx
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	8b 40 0c             	mov    0xc(%eax),%eax
  80314f:	01 c2                	add    %eax,%edx
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	8b 40 08             	mov    0x8(%eax),%eax
  803157:	39 c2                	cmp    %eax,%edx
  803159:	0f 85 b9 01 00 00    	jne    803318 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	8b 50 08             	mov    0x8(%eax),%edx
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	8b 40 0c             	mov    0xc(%eax),%eax
  80316b:	01 c2                	add    %eax,%edx
  80316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803170:	8b 40 08             	mov    0x8(%eax),%eax
  803173:	39 c2                	cmp    %eax,%edx
  803175:	0f 85 0d 01 00 00    	jne    803288 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	8b 50 0c             	mov    0xc(%eax),%edx
  803181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803184:	8b 40 0c             	mov    0xc(%eax),%eax
  803187:	01 c2                	add    %eax,%edx
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80318f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803193:	75 17                	jne    8031ac <insert_sorted_with_merge_freeList+0x39c>
  803195:	83 ec 04             	sub    $0x4,%esp
  803198:	68 08 41 80 00       	push   $0x804108
  80319d:	68 5c 01 00 00       	push   $0x15c
  8031a2:	68 5f 40 80 00       	push   $0x80405f
  8031a7:	e8 b0 03 00 00       	call   80355c <_panic>
  8031ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	74 10                	je     8031c5 <insert_sorted_with_merge_freeList+0x3b5>
  8031b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b8:	8b 00                	mov    (%eax),%eax
  8031ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031bd:	8b 52 04             	mov    0x4(%edx),%edx
  8031c0:	89 50 04             	mov    %edx,0x4(%eax)
  8031c3:	eb 0b                	jmp    8031d0 <insert_sorted_with_merge_freeList+0x3c0>
  8031c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c8:	8b 40 04             	mov    0x4(%eax),%eax
  8031cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 40 04             	mov    0x4(%eax),%eax
  8031d6:	85 c0                	test   %eax,%eax
  8031d8:	74 0f                	je     8031e9 <insert_sorted_with_merge_freeList+0x3d9>
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e3:	8b 12                	mov    (%edx),%edx
  8031e5:	89 10                	mov    %edx,(%eax)
  8031e7:	eb 0a                	jmp    8031f3 <insert_sorted_with_merge_freeList+0x3e3>
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	8b 00                	mov    (%eax),%eax
  8031ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803206:	a1 44 51 80 00       	mov    0x805144,%eax
  80320b:	48                   	dec    %eax
  80320c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803225:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803229:	75 17                	jne    803242 <insert_sorted_with_merge_freeList+0x432>
  80322b:	83 ec 04             	sub    $0x4,%esp
  80322e:	68 3c 40 80 00       	push   $0x80403c
  803233:	68 5f 01 00 00       	push   $0x15f
  803238:	68 5f 40 80 00       	push   $0x80405f
  80323d:	e8 1a 03 00 00       	call   80355c <_panic>
  803242:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324b:	89 10                	mov    %edx,(%eax)
  80324d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	74 0d                	je     803263 <insert_sorted_with_merge_freeList+0x453>
  803256:	a1 48 51 80 00       	mov    0x805148,%eax
  80325b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	eb 08                	jmp    80326b <insert_sorted_with_merge_freeList+0x45b>
  803263:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803266:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	a3 48 51 80 00       	mov    %eax,0x805148
  803273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803276:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327d:	a1 54 51 80 00       	mov    0x805154,%eax
  803282:	40                   	inc    %eax
  803283:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 50 0c             	mov    0xc(%eax),%edx
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	8b 40 0c             	mov    0xc(%eax),%eax
  803294:	01 c2                	add    %eax,%edx
  803296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803299:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b4:	75 17                	jne    8032cd <insert_sorted_with_merge_freeList+0x4bd>
  8032b6:	83 ec 04             	sub    $0x4,%esp
  8032b9:	68 3c 40 80 00       	push   $0x80403c
  8032be:	68 64 01 00 00       	push   $0x164
  8032c3:	68 5f 40 80 00       	push   $0x80405f
  8032c8:	e8 8f 02 00 00       	call   80355c <_panic>
  8032cd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	8b 00                	mov    (%eax),%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	74 0d                	je     8032ee <insert_sorted_with_merge_freeList+0x4de>
  8032e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ec:	eb 08                	jmp    8032f6 <insert_sorted_with_merge_freeList+0x4e6>
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803308:	a1 54 51 80 00       	mov    0x805154,%eax
  80330d:	40                   	inc    %eax
  80330e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803313:	e9 41 02 00 00       	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	8b 50 08             	mov    0x8(%eax),%edx
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	8b 40 0c             	mov    0xc(%eax),%eax
  803324:	01 c2                	add    %eax,%edx
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	8b 40 08             	mov    0x8(%eax),%eax
  80332c:	39 c2                	cmp    %eax,%edx
  80332e:	0f 85 7c 01 00 00    	jne    8034b0 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803334:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803338:	74 06                	je     803340 <insert_sorted_with_merge_freeList+0x530>
  80333a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333e:	75 17                	jne    803357 <insert_sorted_with_merge_freeList+0x547>
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	68 78 40 80 00       	push   $0x804078
  803348:	68 69 01 00 00       	push   $0x169
  80334d:	68 5f 40 80 00       	push   $0x80405f
  803352:	e8 05 02 00 00       	call   80355c <_panic>
  803357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335a:	8b 50 04             	mov    0x4(%eax),%edx
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	89 50 04             	mov    %edx,0x4(%eax)
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803369:	89 10                	mov    %edx,(%eax)
  80336b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336e:	8b 40 04             	mov    0x4(%eax),%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 0d                	je     803382 <insert_sorted_with_merge_freeList+0x572>
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 40 04             	mov    0x4(%eax),%eax
  80337b:	8b 55 08             	mov    0x8(%ebp),%edx
  80337e:	89 10                	mov    %edx,(%eax)
  803380:	eb 08                	jmp    80338a <insert_sorted_with_merge_freeList+0x57a>
  803382:	8b 45 08             	mov    0x8(%ebp),%eax
  803385:	a3 38 51 80 00       	mov    %eax,0x805138
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	8b 55 08             	mov    0x8(%ebp),%edx
  803390:	89 50 04             	mov    %edx,0x4(%eax)
  803393:	a1 44 51 80 00       	mov    0x805144,%eax
  803398:	40                   	inc    %eax
  803399:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8033a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033aa:	01 c2                	add    %eax,%edx
  8033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8033af:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033b6:	75 17                	jne    8033cf <insert_sorted_with_merge_freeList+0x5bf>
  8033b8:	83 ec 04             	sub    $0x4,%esp
  8033bb:	68 08 41 80 00       	push   $0x804108
  8033c0:	68 6b 01 00 00       	push   $0x16b
  8033c5:	68 5f 40 80 00       	push   $0x80405f
  8033ca:	e8 8d 01 00 00       	call   80355c <_panic>
  8033cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	74 10                	je     8033e8 <insert_sorted_with_merge_freeList+0x5d8>
  8033d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033e0:	8b 52 04             	mov    0x4(%edx),%edx
  8033e3:	89 50 04             	mov    %edx,0x4(%eax)
  8033e6:	eb 0b                	jmp    8033f3 <insert_sorted_with_merge_freeList+0x5e3>
  8033e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033eb:	8b 40 04             	mov    0x4(%eax),%eax
  8033ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f6:	8b 40 04             	mov    0x4(%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	74 0f                	je     80340c <insert_sorted_with_merge_freeList+0x5fc>
  8033fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803400:	8b 40 04             	mov    0x4(%eax),%eax
  803403:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803406:	8b 12                	mov    (%edx),%edx
  803408:	89 10                	mov    %edx,(%eax)
  80340a:	eb 0a                	jmp    803416 <insert_sorted_with_merge_freeList+0x606>
  80340c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	a3 38 51 80 00       	mov    %eax,0x805138
  803416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80341f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803422:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803429:	a1 44 51 80 00       	mov    0x805144,%eax
  80342e:	48                   	dec    %eax
  80342f:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803437:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80343e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803441:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803448:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80344c:	75 17                	jne    803465 <insert_sorted_with_merge_freeList+0x655>
  80344e:	83 ec 04             	sub    $0x4,%esp
  803451:	68 3c 40 80 00       	push   $0x80403c
  803456:	68 6e 01 00 00       	push   $0x16e
  80345b:	68 5f 40 80 00       	push   $0x80405f
  803460:	e8 f7 00 00 00       	call   80355c <_panic>
  803465:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80346b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346e:	89 10                	mov    %edx,(%eax)
  803470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803473:	8b 00                	mov    (%eax),%eax
  803475:	85 c0                	test   %eax,%eax
  803477:	74 0d                	je     803486 <insert_sorted_with_merge_freeList+0x676>
  803479:	a1 48 51 80 00       	mov    0x805148,%eax
  80347e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803481:	89 50 04             	mov    %edx,0x4(%eax)
  803484:	eb 08                	jmp    80348e <insert_sorted_with_merge_freeList+0x67e>
  803486:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803489:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80348e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803491:	a3 48 51 80 00       	mov    %eax,0x805148
  803496:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803499:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a0:	a1 54 51 80 00       	mov    0x805154,%eax
  8034a5:	40                   	inc    %eax
  8034a6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034ab:	e9 a9 00 00 00       	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b4:	74 06                	je     8034bc <insert_sorted_with_merge_freeList+0x6ac>
  8034b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ba:	75 17                	jne    8034d3 <insert_sorted_with_merge_freeList+0x6c3>
  8034bc:	83 ec 04             	sub    $0x4,%esp
  8034bf:	68 d4 40 80 00       	push   $0x8040d4
  8034c4:	68 73 01 00 00       	push   $0x173
  8034c9:	68 5f 40 80 00       	push   $0x80405f
  8034ce:	e8 89 00 00 00       	call   80355c <_panic>
  8034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d6:	8b 10                	mov    (%eax),%edx
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	89 10                	mov    %edx,(%eax)
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	8b 00                	mov    (%eax),%eax
  8034e2:	85 c0                	test   %eax,%eax
  8034e4:	74 0b                	je     8034f1 <insert_sorted_with_merge_freeList+0x6e1>
  8034e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e9:	8b 00                	mov    (%eax),%eax
  8034eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ee:	89 50 04             	mov    %edx,0x4(%eax)
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f7:	89 10                	mov    %edx,(%eax)
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ff:	89 50 04             	mov    %edx,0x4(%eax)
  803502:	8b 45 08             	mov    0x8(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	75 08                	jne    803513 <insert_sorted_with_merge_freeList+0x703>
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803513:	a1 44 51 80 00       	mov    0x805144,%eax
  803518:	40                   	inc    %eax
  803519:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80351e:	eb 39                	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803520:	a1 40 51 80 00       	mov    0x805140,%eax
  803525:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80352c:	74 07                	je     803535 <insert_sorted_with_merge_freeList+0x725>
  80352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803531:	8b 00                	mov    (%eax),%eax
  803533:	eb 05                	jmp    80353a <insert_sorted_with_merge_freeList+0x72a>
  803535:	b8 00 00 00 00       	mov    $0x0,%eax
  80353a:	a3 40 51 80 00       	mov    %eax,0x805140
  80353f:	a1 40 51 80 00       	mov    0x805140,%eax
  803544:	85 c0                	test   %eax,%eax
  803546:	0f 85 c7 fb ff ff    	jne    803113 <insert_sorted_with_merge_freeList+0x303>
  80354c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803550:	0f 85 bd fb ff ff    	jne    803113 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803556:	eb 01                	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803558:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803559:	90                   	nop
  80355a:	c9                   	leave  
  80355b:	c3                   	ret    

0080355c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80355c:	55                   	push   %ebp
  80355d:	89 e5                	mov    %esp,%ebp
  80355f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803562:	8d 45 10             	lea    0x10(%ebp),%eax
  803565:	83 c0 04             	add    $0x4,%eax
  803568:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80356b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803570:	85 c0                	test   %eax,%eax
  803572:	74 16                	je     80358a <_panic+0x2e>
		cprintf("%s: ", argv0);
  803574:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803579:	83 ec 08             	sub    $0x8,%esp
  80357c:	50                   	push   %eax
  80357d:	68 28 41 80 00       	push   $0x804128
  803582:	e8 b6 d1 ff ff       	call   80073d <cprintf>
  803587:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80358a:	a1 00 50 80 00       	mov    0x805000,%eax
  80358f:	ff 75 0c             	pushl  0xc(%ebp)
  803592:	ff 75 08             	pushl  0x8(%ebp)
  803595:	50                   	push   %eax
  803596:	68 2d 41 80 00       	push   $0x80412d
  80359b:	e8 9d d1 ff ff       	call   80073d <cprintf>
  8035a0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8035a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8035a6:	83 ec 08             	sub    $0x8,%esp
  8035a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8035ac:	50                   	push   %eax
  8035ad:	e8 20 d1 ff ff       	call   8006d2 <vcprintf>
  8035b2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8035b5:	83 ec 08             	sub    $0x8,%esp
  8035b8:	6a 00                	push   $0x0
  8035ba:	68 49 41 80 00       	push   $0x804149
  8035bf:	e8 0e d1 ff ff       	call   8006d2 <vcprintf>
  8035c4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8035c7:	e8 8f d0 ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  8035cc:	eb fe                	jmp    8035cc <_panic+0x70>

008035ce <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8035ce:	55                   	push   %ebp
  8035cf:	89 e5                	mov    %esp,%ebp
  8035d1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8035d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8035d9:	8b 50 74             	mov    0x74(%eax),%edx
  8035dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035df:	39 c2                	cmp    %eax,%edx
  8035e1:	74 14                	je     8035f7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8035e3:	83 ec 04             	sub    $0x4,%esp
  8035e6:	68 4c 41 80 00       	push   $0x80414c
  8035eb:	6a 26                	push   $0x26
  8035ed:	68 98 41 80 00       	push   $0x804198
  8035f2:	e8 65 ff ff ff       	call   80355c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8035f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8035fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803605:	e9 c2 00 00 00       	jmp    8036cc <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80360a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	01 d0                	add    %edx,%eax
  803619:	8b 00                	mov    (%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	75 08                	jne    803627 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80361f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803622:	e9 a2 00 00 00       	jmp    8036c9 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803627:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80362e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803635:	eb 69                	jmp    8036a0 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803637:	a1 20 50 80 00       	mov    0x805020,%eax
  80363c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803642:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803645:	89 d0                	mov    %edx,%eax
  803647:	01 c0                	add    %eax,%eax
  803649:	01 d0                	add    %edx,%eax
  80364b:	c1 e0 03             	shl    $0x3,%eax
  80364e:	01 c8                	add    %ecx,%eax
  803650:	8a 40 04             	mov    0x4(%eax),%al
  803653:	84 c0                	test   %al,%al
  803655:	75 46                	jne    80369d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803657:	a1 20 50 80 00       	mov    0x805020,%eax
  80365c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803662:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803665:	89 d0                	mov    %edx,%eax
  803667:	01 c0                	add    %eax,%eax
  803669:	01 d0                	add    %edx,%eax
  80366b:	c1 e0 03             	shl    $0x3,%eax
  80366e:	01 c8                	add    %ecx,%eax
  803670:	8b 00                	mov    (%eax),%eax
  803672:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803675:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803678:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80367d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80367f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803682:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803689:	8b 45 08             	mov    0x8(%ebp),%eax
  80368c:	01 c8                	add    %ecx,%eax
  80368e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803690:	39 c2                	cmp    %eax,%edx
  803692:	75 09                	jne    80369d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803694:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80369b:	eb 12                	jmp    8036af <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80369d:	ff 45 e8             	incl   -0x18(%ebp)
  8036a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8036a5:	8b 50 74             	mov    0x74(%eax),%edx
  8036a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ab:	39 c2                	cmp    %eax,%edx
  8036ad:	77 88                	ja     803637 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8036af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036b3:	75 14                	jne    8036c9 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8036b5:	83 ec 04             	sub    $0x4,%esp
  8036b8:	68 a4 41 80 00       	push   $0x8041a4
  8036bd:	6a 3a                	push   $0x3a
  8036bf:	68 98 41 80 00       	push   $0x804198
  8036c4:	e8 93 fe ff ff       	call   80355c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8036c9:	ff 45 f0             	incl   -0x10(%ebp)
  8036cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036d2:	0f 8c 32 ff ff ff    	jl     80360a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8036d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8036e6:	eb 26                	jmp    80370e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8036e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8036ed:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8036f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036f6:	89 d0                	mov    %edx,%eax
  8036f8:	01 c0                	add    %eax,%eax
  8036fa:	01 d0                	add    %edx,%eax
  8036fc:	c1 e0 03             	shl    $0x3,%eax
  8036ff:	01 c8                	add    %ecx,%eax
  803701:	8a 40 04             	mov    0x4(%eax),%al
  803704:	3c 01                	cmp    $0x1,%al
  803706:	75 03                	jne    80370b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803708:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80370b:	ff 45 e0             	incl   -0x20(%ebp)
  80370e:	a1 20 50 80 00       	mov    0x805020,%eax
  803713:	8b 50 74             	mov    0x74(%eax),%edx
  803716:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803719:	39 c2                	cmp    %eax,%edx
  80371b:	77 cb                	ja     8036e8 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80371d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803720:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803723:	74 14                	je     803739 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803725:	83 ec 04             	sub    $0x4,%esp
  803728:	68 f8 41 80 00       	push   $0x8041f8
  80372d:	6a 44                	push   $0x44
  80372f:	68 98 41 80 00       	push   $0x804198
  803734:	e8 23 fe ff ff       	call   80355c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803739:	90                   	nop
  80373a:	c9                   	leave  
  80373b:	c3                   	ret    

0080373c <__udivdi3>:
  80373c:	55                   	push   %ebp
  80373d:	57                   	push   %edi
  80373e:	56                   	push   %esi
  80373f:	53                   	push   %ebx
  803740:	83 ec 1c             	sub    $0x1c,%esp
  803743:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803747:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80374b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80374f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803753:	89 ca                	mov    %ecx,%edx
  803755:	89 f8                	mov    %edi,%eax
  803757:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80375b:	85 f6                	test   %esi,%esi
  80375d:	75 2d                	jne    80378c <__udivdi3+0x50>
  80375f:	39 cf                	cmp    %ecx,%edi
  803761:	77 65                	ja     8037c8 <__udivdi3+0x8c>
  803763:	89 fd                	mov    %edi,%ebp
  803765:	85 ff                	test   %edi,%edi
  803767:	75 0b                	jne    803774 <__udivdi3+0x38>
  803769:	b8 01 00 00 00       	mov    $0x1,%eax
  80376e:	31 d2                	xor    %edx,%edx
  803770:	f7 f7                	div    %edi
  803772:	89 c5                	mov    %eax,%ebp
  803774:	31 d2                	xor    %edx,%edx
  803776:	89 c8                	mov    %ecx,%eax
  803778:	f7 f5                	div    %ebp
  80377a:	89 c1                	mov    %eax,%ecx
  80377c:	89 d8                	mov    %ebx,%eax
  80377e:	f7 f5                	div    %ebp
  803780:	89 cf                	mov    %ecx,%edi
  803782:	89 fa                	mov    %edi,%edx
  803784:	83 c4 1c             	add    $0x1c,%esp
  803787:	5b                   	pop    %ebx
  803788:	5e                   	pop    %esi
  803789:	5f                   	pop    %edi
  80378a:	5d                   	pop    %ebp
  80378b:	c3                   	ret    
  80378c:	39 ce                	cmp    %ecx,%esi
  80378e:	77 28                	ja     8037b8 <__udivdi3+0x7c>
  803790:	0f bd fe             	bsr    %esi,%edi
  803793:	83 f7 1f             	xor    $0x1f,%edi
  803796:	75 40                	jne    8037d8 <__udivdi3+0x9c>
  803798:	39 ce                	cmp    %ecx,%esi
  80379a:	72 0a                	jb     8037a6 <__udivdi3+0x6a>
  80379c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037a0:	0f 87 9e 00 00 00    	ja     803844 <__udivdi3+0x108>
  8037a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037ab:	89 fa                	mov    %edi,%edx
  8037ad:	83 c4 1c             	add    $0x1c,%esp
  8037b0:	5b                   	pop    %ebx
  8037b1:	5e                   	pop    %esi
  8037b2:	5f                   	pop    %edi
  8037b3:	5d                   	pop    %ebp
  8037b4:	c3                   	ret    
  8037b5:	8d 76 00             	lea    0x0(%esi),%esi
  8037b8:	31 ff                	xor    %edi,%edi
  8037ba:	31 c0                	xor    %eax,%eax
  8037bc:	89 fa                	mov    %edi,%edx
  8037be:	83 c4 1c             	add    $0x1c,%esp
  8037c1:	5b                   	pop    %ebx
  8037c2:	5e                   	pop    %esi
  8037c3:	5f                   	pop    %edi
  8037c4:	5d                   	pop    %ebp
  8037c5:	c3                   	ret    
  8037c6:	66 90                	xchg   %ax,%ax
  8037c8:	89 d8                	mov    %ebx,%eax
  8037ca:	f7 f7                	div    %edi
  8037cc:	31 ff                	xor    %edi,%edi
  8037ce:	89 fa                	mov    %edi,%edx
  8037d0:	83 c4 1c             	add    $0x1c,%esp
  8037d3:	5b                   	pop    %ebx
  8037d4:	5e                   	pop    %esi
  8037d5:	5f                   	pop    %edi
  8037d6:	5d                   	pop    %ebp
  8037d7:	c3                   	ret    
  8037d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037dd:	89 eb                	mov    %ebp,%ebx
  8037df:	29 fb                	sub    %edi,%ebx
  8037e1:	89 f9                	mov    %edi,%ecx
  8037e3:	d3 e6                	shl    %cl,%esi
  8037e5:	89 c5                	mov    %eax,%ebp
  8037e7:	88 d9                	mov    %bl,%cl
  8037e9:	d3 ed                	shr    %cl,%ebp
  8037eb:	89 e9                	mov    %ebp,%ecx
  8037ed:	09 f1                	or     %esi,%ecx
  8037ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037f3:	89 f9                	mov    %edi,%ecx
  8037f5:	d3 e0                	shl    %cl,%eax
  8037f7:	89 c5                	mov    %eax,%ebp
  8037f9:	89 d6                	mov    %edx,%esi
  8037fb:	88 d9                	mov    %bl,%cl
  8037fd:	d3 ee                	shr    %cl,%esi
  8037ff:	89 f9                	mov    %edi,%ecx
  803801:	d3 e2                	shl    %cl,%edx
  803803:	8b 44 24 08          	mov    0x8(%esp),%eax
  803807:	88 d9                	mov    %bl,%cl
  803809:	d3 e8                	shr    %cl,%eax
  80380b:	09 c2                	or     %eax,%edx
  80380d:	89 d0                	mov    %edx,%eax
  80380f:	89 f2                	mov    %esi,%edx
  803811:	f7 74 24 0c          	divl   0xc(%esp)
  803815:	89 d6                	mov    %edx,%esi
  803817:	89 c3                	mov    %eax,%ebx
  803819:	f7 e5                	mul    %ebp
  80381b:	39 d6                	cmp    %edx,%esi
  80381d:	72 19                	jb     803838 <__udivdi3+0xfc>
  80381f:	74 0b                	je     80382c <__udivdi3+0xf0>
  803821:	89 d8                	mov    %ebx,%eax
  803823:	31 ff                	xor    %edi,%edi
  803825:	e9 58 ff ff ff       	jmp    803782 <__udivdi3+0x46>
  80382a:	66 90                	xchg   %ax,%ax
  80382c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803830:	89 f9                	mov    %edi,%ecx
  803832:	d3 e2                	shl    %cl,%edx
  803834:	39 c2                	cmp    %eax,%edx
  803836:	73 e9                	jae    803821 <__udivdi3+0xe5>
  803838:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80383b:	31 ff                	xor    %edi,%edi
  80383d:	e9 40 ff ff ff       	jmp    803782 <__udivdi3+0x46>
  803842:	66 90                	xchg   %ax,%ax
  803844:	31 c0                	xor    %eax,%eax
  803846:	e9 37 ff ff ff       	jmp    803782 <__udivdi3+0x46>
  80384b:	90                   	nop

0080384c <__umoddi3>:
  80384c:	55                   	push   %ebp
  80384d:	57                   	push   %edi
  80384e:	56                   	push   %esi
  80384f:	53                   	push   %ebx
  803850:	83 ec 1c             	sub    $0x1c,%esp
  803853:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803857:	8b 74 24 34          	mov    0x34(%esp),%esi
  80385b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80385f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803863:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803867:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80386b:	89 f3                	mov    %esi,%ebx
  80386d:	89 fa                	mov    %edi,%edx
  80386f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803873:	89 34 24             	mov    %esi,(%esp)
  803876:	85 c0                	test   %eax,%eax
  803878:	75 1a                	jne    803894 <__umoddi3+0x48>
  80387a:	39 f7                	cmp    %esi,%edi
  80387c:	0f 86 a2 00 00 00    	jbe    803924 <__umoddi3+0xd8>
  803882:	89 c8                	mov    %ecx,%eax
  803884:	89 f2                	mov    %esi,%edx
  803886:	f7 f7                	div    %edi
  803888:	89 d0                	mov    %edx,%eax
  80388a:	31 d2                	xor    %edx,%edx
  80388c:	83 c4 1c             	add    $0x1c,%esp
  80388f:	5b                   	pop    %ebx
  803890:	5e                   	pop    %esi
  803891:	5f                   	pop    %edi
  803892:	5d                   	pop    %ebp
  803893:	c3                   	ret    
  803894:	39 f0                	cmp    %esi,%eax
  803896:	0f 87 ac 00 00 00    	ja     803948 <__umoddi3+0xfc>
  80389c:	0f bd e8             	bsr    %eax,%ebp
  80389f:	83 f5 1f             	xor    $0x1f,%ebp
  8038a2:	0f 84 ac 00 00 00    	je     803954 <__umoddi3+0x108>
  8038a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8038ad:	29 ef                	sub    %ebp,%edi
  8038af:	89 fe                	mov    %edi,%esi
  8038b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038b5:	89 e9                	mov    %ebp,%ecx
  8038b7:	d3 e0                	shl    %cl,%eax
  8038b9:	89 d7                	mov    %edx,%edi
  8038bb:	89 f1                	mov    %esi,%ecx
  8038bd:	d3 ef                	shr    %cl,%edi
  8038bf:	09 c7                	or     %eax,%edi
  8038c1:	89 e9                	mov    %ebp,%ecx
  8038c3:	d3 e2                	shl    %cl,%edx
  8038c5:	89 14 24             	mov    %edx,(%esp)
  8038c8:	89 d8                	mov    %ebx,%eax
  8038ca:	d3 e0                	shl    %cl,%eax
  8038cc:	89 c2                	mov    %eax,%edx
  8038ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038d2:	d3 e0                	shl    %cl,%eax
  8038d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038dc:	89 f1                	mov    %esi,%ecx
  8038de:	d3 e8                	shr    %cl,%eax
  8038e0:	09 d0                	or     %edx,%eax
  8038e2:	d3 eb                	shr    %cl,%ebx
  8038e4:	89 da                	mov    %ebx,%edx
  8038e6:	f7 f7                	div    %edi
  8038e8:	89 d3                	mov    %edx,%ebx
  8038ea:	f7 24 24             	mull   (%esp)
  8038ed:	89 c6                	mov    %eax,%esi
  8038ef:	89 d1                	mov    %edx,%ecx
  8038f1:	39 d3                	cmp    %edx,%ebx
  8038f3:	0f 82 87 00 00 00    	jb     803980 <__umoddi3+0x134>
  8038f9:	0f 84 91 00 00 00    	je     803990 <__umoddi3+0x144>
  8038ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  803903:	29 f2                	sub    %esi,%edx
  803905:	19 cb                	sbb    %ecx,%ebx
  803907:	89 d8                	mov    %ebx,%eax
  803909:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80390d:	d3 e0                	shl    %cl,%eax
  80390f:	89 e9                	mov    %ebp,%ecx
  803911:	d3 ea                	shr    %cl,%edx
  803913:	09 d0                	or     %edx,%eax
  803915:	89 e9                	mov    %ebp,%ecx
  803917:	d3 eb                	shr    %cl,%ebx
  803919:	89 da                	mov    %ebx,%edx
  80391b:	83 c4 1c             	add    $0x1c,%esp
  80391e:	5b                   	pop    %ebx
  80391f:	5e                   	pop    %esi
  803920:	5f                   	pop    %edi
  803921:	5d                   	pop    %ebp
  803922:	c3                   	ret    
  803923:	90                   	nop
  803924:	89 fd                	mov    %edi,%ebp
  803926:	85 ff                	test   %edi,%edi
  803928:	75 0b                	jne    803935 <__umoddi3+0xe9>
  80392a:	b8 01 00 00 00       	mov    $0x1,%eax
  80392f:	31 d2                	xor    %edx,%edx
  803931:	f7 f7                	div    %edi
  803933:	89 c5                	mov    %eax,%ebp
  803935:	89 f0                	mov    %esi,%eax
  803937:	31 d2                	xor    %edx,%edx
  803939:	f7 f5                	div    %ebp
  80393b:	89 c8                	mov    %ecx,%eax
  80393d:	f7 f5                	div    %ebp
  80393f:	89 d0                	mov    %edx,%eax
  803941:	e9 44 ff ff ff       	jmp    80388a <__umoddi3+0x3e>
  803946:	66 90                	xchg   %ax,%ax
  803948:	89 c8                	mov    %ecx,%eax
  80394a:	89 f2                	mov    %esi,%edx
  80394c:	83 c4 1c             	add    $0x1c,%esp
  80394f:	5b                   	pop    %ebx
  803950:	5e                   	pop    %esi
  803951:	5f                   	pop    %edi
  803952:	5d                   	pop    %ebp
  803953:	c3                   	ret    
  803954:	3b 04 24             	cmp    (%esp),%eax
  803957:	72 06                	jb     80395f <__umoddi3+0x113>
  803959:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80395d:	77 0f                	ja     80396e <__umoddi3+0x122>
  80395f:	89 f2                	mov    %esi,%edx
  803961:	29 f9                	sub    %edi,%ecx
  803963:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803967:	89 14 24             	mov    %edx,(%esp)
  80396a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80396e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803972:	8b 14 24             	mov    (%esp),%edx
  803975:	83 c4 1c             	add    $0x1c,%esp
  803978:	5b                   	pop    %ebx
  803979:	5e                   	pop    %esi
  80397a:	5f                   	pop    %edi
  80397b:	5d                   	pop    %ebp
  80397c:	c3                   	ret    
  80397d:	8d 76 00             	lea    0x0(%esi),%esi
  803980:	2b 04 24             	sub    (%esp),%eax
  803983:	19 fa                	sbb    %edi,%edx
  803985:	89 d1                	mov    %edx,%ecx
  803987:	89 c6                	mov    %eax,%esi
  803989:	e9 71 ff ff ff       	jmp    8038ff <__umoddi3+0xb3>
  80398e:	66 90                	xchg   %ax,%ax
  803990:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803994:	72 ea                	jb     803980 <__umoddi3+0x134>
  803996:	89 d9                	mov    %ebx,%ecx
  803998:	e9 62 ff ff ff       	jmp    8038ff <__umoddi3+0xb3>
