
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
  80003e:	e8 d1 1b 00 00       	call   801c14 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 fb 1b 00 00       	call   801c46 <sys_getparentenvid>
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
  80005f:	68 60 39 80 00       	push   $0x803960
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 3d 17 00 00       	call   8017a9 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 64 39 80 00       	push   $0x803964
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 27 17 00 00       	call   8017a9 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 6c 39 80 00       	push   $0x80396c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 0a 17 00 00       	call   8017a9 <sget>
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
  8000b3:	68 7a 39 80 00       	push   $0x80397a
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
  800126:	68 84 39 80 00       	push   $0x803984
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 a9 39 80 00       	push   $0x8039a9
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
  800159:	68 ae 39 80 00       	push   $0x8039ae
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
  800178:	68 b2 39 80 00       	push   $0x8039b2
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
  800197:	68 b6 39 80 00       	push   $0x8039b6
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
  8001b6:	68 ba 39 80 00       	push   $0x8039ba
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
  800230:	e8 44 1a 00 00       	call   801c79 <sys_get_virtual_time>
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
  800533:	e8 f5 16 00 00       	call   801c2d <sys_getenvindex>
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
  80059e:	e8 97 14 00 00       	call   801a3a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 d8 39 80 00       	push   $0x8039d8
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
  8005ce:	68 00 3a 80 00       	push   $0x803a00
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
  8005ff:	68 28 3a 80 00       	push   $0x803a28
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 50 80 00       	mov    0x805020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 80 3a 80 00       	push   $0x803a80
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 d8 39 80 00       	push   $0x8039d8
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 17 14 00 00       	call   801a54 <sys_enable_interrupt>

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
  800650:	e8 a4 15 00 00       	call   801bf9 <sys_destroy_env>
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
  800661:	e8 f9 15 00 00       	call   801c5f <sys_exit_env>
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
  8006af:	e8 d8 11 00 00       	call   80188c <sys_cputs>
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
  800726:	e8 61 11 00 00       	call   80188c <sys_cputs>
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
  800770:	e8 c5 12 00 00       	call   801a3a <sys_disable_interrupt>
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
  800790:	e8 bf 12 00 00       	call   801a54 <sys_enable_interrupt>
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
  8007da:	e8 11 2f 00 00       	call   8036f0 <__udivdi3>
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
  80082a:	e8 d1 2f 00 00       	call   803800 <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 b4 3c 80 00       	add    $0x803cb4,%eax
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
  800985:	8b 04 85 d8 3c 80 00 	mov    0x803cd8(,%eax,4),%eax
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
  800a66:	8b 34 9d 20 3b 80 00 	mov    0x803b20(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 c5 3c 80 00       	push   $0x803cc5
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
  800a8b:	68 ce 3c 80 00       	push   $0x803cce
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
  800ab8:	be d1 3c 80 00       	mov    $0x803cd1,%esi
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
  8014de:	68 30 3e 80 00       	push   $0x803e30
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
  8015ae:	e8 1d 04 00 00       	call   8019d0 <sys_allocate_chunk>
  8015b3:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015b6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015bb:	83 ec 0c             	sub    $0xc,%esp
  8015be:	50                   	push   %eax
  8015bf:	e8 92 0a 00 00       	call   802056 <initialize_MemBlocksList>
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
  8015ec:	68 55 3e 80 00       	push   $0x803e55
  8015f1:	6a 33                	push   $0x33
  8015f3:	68 73 3e 80 00       	push   $0x803e73
  8015f8:	e8 12 1f 00 00       	call   80350f <_panic>
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
  80166b:	68 80 3e 80 00       	push   $0x803e80
  801670:	6a 34                	push   $0x34
  801672:	68 73 3e 80 00       	push   $0x803e73
  801677:	e8 93 1e 00 00       	call   80350f <_panic>
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
  8016e0:	68 a4 3e 80 00       	push   $0x803ea4
  8016e5:	6a 46                	push   $0x46
  8016e7:	68 73 3e 80 00       	push   $0x803e73
  8016ec:	e8 1e 1e 00 00       	call   80350f <_panic>
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
  8016fc:	68 cc 3e 80 00       	push   $0x803ecc
  801701:	6a 61                	push   $0x61
  801703:	68 73 3e 80 00       	push   $0x803e73
  801708:	e8 02 1e 00 00       	call   80350f <_panic>

0080170d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 38             	sub    $0x38,%esp
  801713:	8b 45 10             	mov    0x10(%ebp),%eax
  801716:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801719:	e8 a9 fd ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  80171e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801722:	75 07                	jne    80172b <smalloc+0x1e>
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
  801729:	eb 7c                	jmp    8017a7 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80172b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801732:	8b 55 0c             	mov    0xc(%ebp),%edx
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801738:	01 d0                	add    %edx,%eax
  80173a:	48                   	dec    %eax
  80173b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80173e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801741:	ba 00 00 00 00       	mov    $0x0,%edx
  801746:	f7 75 f0             	divl   -0x10(%ebp)
  801749:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174c:	29 d0                	sub    %edx,%eax
  80174e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801751:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801758:	e8 41 06 00 00       	call   801d9e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80175d:	85 c0                	test   %eax,%eax
  80175f:	74 11                	je     801772 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801761:	83 ec 0c             	sub    $0xc,%esp
  801764:	ff 75 e8             	pushl  -0x18(%ebp)
  801767:	e8 ac 0c 00 00       	call   802418 <alloc_block_FF>
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801776:	74 2a                	je     8017a2 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177b:	8b 40 08             	mov    0x8(%eax),%eax
  80177e:	89 c2                	mov    %eax,%edx
  801780:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801784:	52                   	push   %edx
  801785:	50                   	push   %eax
  801786:	ff 75 0c             	pushl  0xc(%ebp)
  801789:	ff 75 08             	pushl  0x8(%ebp)
  80178c:	e8 92 03 00 00       	call   801b23 <sys_createSharedObject>
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801797:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80179b:	74 05                	je     8017a2 <smalloc+0x95>
			return (void*)virtual_address;
  80179d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a0:	eb 05                	jmp    8017a7 <smalloc+0x9a>
	}
	return NULL;
  8017a2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017af:	e8 13 fd ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	68 f0 3e 80 00       	push   $0x803ef0
  8017bc:	68 a2 00 00 00       	push   $0xa2
  8017c1:	68 73 3e 80 00       	push   $0x803e73
  8017c6:	e8 44 1d 00 00       	call   80350f <_panic>

008017cb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017d1:	e8 f1 fc ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	68 14 3f 80 00       	push   $0x803f14
  8017de:	68 e6 00 00 00       	push   $0xe6
  8017e3:	68 73 3e 80 00       	push   $0x803e73
  8017e8:	e8 22 1d 00 00       	call   80350f <_panic>

008017ed <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	68 3c 3f 80 00       	push   $0x803f3c
  8017fb:	68 fa 00 00 00       	push   $0xfa
  801800:	68 73 3e 80 00       	push   $0x803e73
  801805:	e8 05 1d 00 00       	call   80350f <_panic>

0080180a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	68 60 3f 80 00       	push   $0x803f60
  801818:	68 05 01 00 00       	push   $0x105
  80181d:	68 73 3e 80 00       	push   $0x803e73
  801822:	e8 e8 1c 00 00       	call   80350f <_panic>

00801827 <shrink>:

}
void shrink(uint32 newSize)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182d:	83 ec 04             	sub    $0x4,%esp
  801830:	68 60 3f 80 00       	push   $0x803f60
  801835:	68 0a 01 00 00       	push   $0x10a
  80183a:	68 73 3e 80 00       	push   $0x803e73
  80183f:	e8 cb 1c 00 00       	call   80350f <_panic>

00801844 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	68 60 3f 80 00       	push   $0x803f60
  801852:	68 0f 01 00 00       	push   $0x10f
  801857:	68 73 3e 80 00       	push   $0x803e73
  80185c:	e8 ae 1c 00 00       	call   80350f <_panic>

00801861 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	57                   	push   %edi
  801865:	56                   	push   %esi
  801866:	53                   	push   %ebx
  801867:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801870:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801873:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801876:	8b 7d 18             	mov    0x18(%ebp),%edi
  801879:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80187c:	cd 30                	int    $0x30
  80187e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801881:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	5b                   	pop    %ebx
  801888:	5e                   	pop    %esi
  801889:	5f                   	pop    %edi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	8b 45 10             	mov    0x10(%ebp),%eax
  801895:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801898:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	52                   	push   %edx
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	50                   	push   %eax
  8018a8:	6a 00                	push   $0x0
  8018aa:	e8 b2 ff ff ff       	call   801861 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	90                   	nop
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 01                	push   $0x1
  8018c4:	e8 98 ff ff ff       	call   801861 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	52                   	push   %edx
  8018de:	50                   	push   %eax
  8018df:	6a 05                	push   $0x5
  8018e1:	e8 7b ff ff ff       	call   801861 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	56                   	push   %esi
  8018ef:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018f0:	8b 75 18             	mov    0x18(%ebp),%esi
  8018f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	56                   	push   %esi
  801900:	53                   	push   %ebx
  801901:	51                   	push   %ecx
  801902:	52                   	push   %edx
  801903:	50                   	push   %eax
  801904:	6a 06                	push   $0x6
  801906:	e8 56 ff ff ff       	call   801861 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801911:	5b                   	pop    %ebx
  801912:	5e                   	pop    %esi
  801913:	5d                   	pop    %ebp
  801914:	c3                   	ret    

00801915 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801918:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	52                   	push   %edx
  801925:	50                   	push   %eax
  801926:	6a 07                	push   $0x7
  801928:	e8 34 ff ff ff       	call   801861 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	ff 75 08             	pushl  0x8(%ebp)
  801941:	6a 08                	push   $0x8
  801943:	e8 19 ff ff ff       	call   801861 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 09                	push   $0x9
  80195c:	e8 00 ff ff ff       	call   801861 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 0a                	push   $0xa
  801975:	e8 e7 fe ff ff       	call   801861 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 0b                	push   $0xb
  80198e:	e8 ce fe ff ff       	call   801861 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	6a 0f                	push   $0xf
  8019a9:	e8 b3 fe ff ff       	call   801861 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
	return;
  8019b1:	90                   	nop
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	ff 75 08             	pushl  0x8(%ebp)
  8019c3:	6a 10                	push   $0x10
  8019c5:	e8 97 fe ff ff       	call   801861 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cd:	90                   	nop
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 10             	pushl  0x10(%ebp)
  8019da:	ff 75 0c             	pushl  0xc(%ebp)
  8019dd:	ff 75 08             	pushl  0x8(%ebp)
  8019e0:	6a 11                	push   $0x11
  8019e2:	e8 7a fe ff ff       	call   801861 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ea:	90                   	nop
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 0c                	push   $0xc
  8019fc:	e8 60 fe ff ff       	call   801861 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	6a 0d                	push   $0xd
  801a16:	e8 46 fe ff ff       	call   801861 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 0e                	push   $0xe
  801a2f:	e8 2d fe ff ff       	call   801861 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	90                   	nop
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 13                	push   $0x13
  801a49:	e8 13 fe ff ff       	call   801861 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	90                   	nop
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 14                	push   $0x14
  801a63:	e8 f9 fd ff ff       	call   801861 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_cputc>:


void
sys_cputc(const char c)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a7a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	50                   	push   %eax
  801a87:	6a 15                	push   $0x15
  801a89:	e8 d3 fd ff ff       	call   801861 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 16                	push   $0x16
  801aa3:	e8 b9 fd ff ff       	call   801861 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	90                   	nop
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	ff 75 0c             	pushl  0xc(%ebp)
  801abd:	50                   	push   %eax
  801abe:	6a 17                	push   $0x17
  801ac0:	e8 9c fd ff ff       	call   801861 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	52                   	push   %edx
  801ada:	50                   	push   %eax
  801adb:	6a 1a                	push   $0x1a
  801add:	e8 7f fd ff ff       	call   801861 <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	52                   	push   %edx
  801af7:	50                   	push   %eax
  801af8:	6a 18                	push   $0x18
  801afa:	e8 62 fd ff ff       	call   801861 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	90                   	nop
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 19                	push   $0x19
  801b18:	e8 44 fd ff ff       	call   801861 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	90                   	nop
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 04             	sub    $0x4,%esp
  801b29:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b2f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b32:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	6a 00                	push   $0x0
  801b3b:	51                   	push   %ecx
  801b3c:	52                   	push   %edx
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	50                   	push   %eax
  801b41:	6a 1b                	push   $0x1b
  801b43:	e8 19 fd ff ff       	call   801861 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	52                   	push   %edx
  801b5d:	50                   	push   %eax
  801b5e:	6a 1c                	push   $0x1c
  801b60:	e8 fc fc ff ff       	call   801861 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	51                   	push   %ecx
  801b7b:	52                   	push   %edx
  801b7c:	50                   	push   %eax
  801b7d:	6a 1d                	push   $0x1d
  801b7f:	e8 dd fc ff ff       	call   801861 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	6a 1e                	push   $0x1e
  801b9c:	e8 c0 fc ff ff       	call   801861 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 1f                	push   $0x1f
  801bb5:	e8 a7 fc ff ff       	call   801861 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	ff 75 14             	pushl  0x14(%ebp)
  801bca:	ff 75 10             	pushl  0x10(%ebp)
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	50                   	push   %eax
  801bd1:	6a 20                	push   $0x20
  801bd3:	e8 89 fc ff ff       	call   801861 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	50                   	push   %eax
  801bec:	6a 21                	push   $0x21
  801bee:	e8 6e fc ff ff       	call   801861 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	90                   	nop
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	50                   	push   %eax
  801c08:	6a 22                	push   $0x22
  801c0a:	e8 52 fc ff ff       	call   801861 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 02                	push   $0x2
  801c23:	e8 39 fc ff ff       	call   801861 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 03                	push   $0x3
  801c3c:	e8 20 fc ff ff       	call   801861 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 04                	push   $0x4
  801c55:	e8 07 fc ff ff       	call   801861 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_exit_env>:


void sys_exit_env(void)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 23                	push   $0x23
  801c6e:	e8 ee fb ff ff       	call   801861 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	90                   	nop
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c7f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c82:	8d 50 04             	lea    0x4(%eax),%edx
  801c85:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	52                   	push   %edx
  801c8f:	50                   	push   %eax
  801c90:	6a 24                	push   $0x24
  801c92:	e8 ca fb ff ff       	call   801861 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return result;
  801c9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca3:	89 01                	mov    %eax,(%ecx)
  801ca5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	c9                   	leave  
  801cac:	c2 04 00             	ret    $0x4

00801caf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	ff 75 10             	pushl  0x10(%ebp)
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	ff 75 08             	pushl  0x8(%ebp)
  801cbf:	6a 12                	push   $0x12
  801cc1:	e8 9b fb ff ff       	call   801861 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc9:	90                   	nop
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_rcr2>:
uint32 sys_rcr2()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 25                	push   $0x25
  801cdb:	e8 81 fb ff ff       	call   801861 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cf1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	50                   	push   %eax
  801cfe:	6a 26                	push   $0x26
  801d00:	e8 5c fb ff ff       	call   801861 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
	return ;
  801d08:	90                   	nop
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <rsttst>:
void rsttst()
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 28                	push   $0x28
  801d1a:	e8 42 fb ff ff       	call   801861 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d22:	90                   	nop
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	83 ec 04             	sub    $0x4,%esp
  801d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d31:	8b 55 18             	mov    0x18(%ebp),%edx
  801d34:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d38:	52                   	push   %edx
  801d39:	50                   	push   %eax
  801d3a:	ff 75 10             	pushl  0x10(%ebp)
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	ff 75 08             	pushl  0x8(%ebp)
  801d43:	6a 27                	push   $0x27
  801d45:	e8 17 fb ff ff       	call   801861 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4d:	90                   	nop
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <chktst>:
void chktst(uint32 n)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	ff 75 08             	pushl  0x8(%ebp)
  801d5e:	6a 29                	push   $0x29
  801d60:	e8 fc fa ff ff       	call   801861 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
	return ;
  801d68:	90                   	nop
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <inctst>:

void inctst()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 2a                	push   $0x2a
  801d7a:	e8 e2 fa ff ff       	call   801861 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <gettst>:
uint32 gettst()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 2b                	push   $0x2b
  801d94:	e8 c8 fa ff ff       	call   801861 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 2c                	push   $0x2c
  801db0:	e8 ac fa ff ff       	call   801861 <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
  801db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dbb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dbf:	75 07                	jne    801dc8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc6:	eb 05                	jmp    801dcd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 2c                	push   $0x2c
  801de1:	e8 7b fa ff ff       	call   801861 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
  801de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dec:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801df0:	75 07                	jne    801df9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801df2:	b8 01 00 00 00       	mov    $0x1,%eax
  801df7:	eb 05                	jmp    801dfe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 2c                	push   $0x2c
  801e12:	e8 4a fa ff ff       	call   801861 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
  801e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e1d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e21:	75 07                	jne    801e2a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e23:	b8 01 00 00 00       	mov    $0x1,%eax
  801e28:	eb 05                	jmp    801e2f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 2c                	push   $0x2c
  801e43:	e8 19 fa ff ff       	call   801861 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
  801e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e4e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e52:	75 07                	jne    801e5b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e54:	b8 01 00 00 00       	mov    $0x1,%eax
  801e59:	eb 05                	jmp    801e60 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	ff 75 08             	pushl  0x8(%ebp)
  801e70:	6a 2d                	push   $0x2d
  801e72:	e8 ea f9 ff ff       	call   801861 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7a:	90                   	nop
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e81:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	6a 00                	push   $0x0
  801e8f:	53                   	push   %ebx
  801e90:	51                   	push   %ecx
  801e91:	52                   	push   %edx
  801e92:	50                   	push   %eax
  801e93:	6a 2e                	push   $0x2e
  801e95:	e8 c7 f9 ff ff       	call   801861 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
}
  801e9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	52                   	push   %edx
  801eb2:	50                   	push   %eax
  801eb3:	6a 2f                	push   $0x2f
  801eb5:	e8 a7 f9 ff ff       	call   801861 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	68 70 3f 80 00       	push   $0x803f70
  801ecd:	e8 6b e8 ff ff       	call   80073d <cprintf>
  801ed2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ed5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	68 9c 3f 80 00       	push   $0x803f9c
  801ee4:	e8 54 e8 ff ff       	call   80073d <cprintf>
  801ee9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eec:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ef0:	a1 38 51 80 00       	mov    0x805138,%eax
  801ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef8:	eb 56                	jmp    801f50 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801efa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801efe:	74 1c                	je     801f1c <print_mem_block_lists+0x5d>
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	8b 50 08             	mov    0x8(%eax),%edx
  801f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f09:	8b 48 08             	mov    0x8(%eax),%ecx
  801f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f12:	01 c8                	add    %ecx,%eax
  801f14:	39 c2                	cmp    %eax,%edx
  801f16:	73 04                	jae    801f1c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f18:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1f:	8b 50 08             	mov    0x8(%eax),%edx
  801f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f25:	8b 40 0c             	mov    0xc(%eax),%eax
  801f28:	01 c2                	add    %eax,%edx
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 40 08             	mov    0x8(%eax),%eax
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	52                   	push   %edx
  801f34:	50                   	push   %eax
  801f35:	68 b1 3f 80 00       	push   $0x803fb1
  801f3a:	e8 fe e7 ff ff       	call   80073d <cprintf>
  801f3f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f48:	a1 40 51 80 00       	mov    0x805140,%eax
  801f4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f54:	74 07                	je     801f5d <print_mem_block_lists+0x9e>
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	8b 00                	mov    (%eax),%eax
  801f5b:	eb 05                	jmp    801f62 <print_mem_block_lists+0xa3>
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f62:	a3 40 51 80 00       	mov    %eax,0x805140
  801f67:	a1 40 51 80 00       	mov    0x805140,%eax
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	75 8a                	jne    801efa <print_mem_block_lists+0x3b>
  801f70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f74:	75 84                	jne    801efa <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f76:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f7a:	75 10                	jne    801f8c <print_mem_block_lists+0xcd>
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	68 c0 3f 80 00       	push   $0x803fc0
  801f84:	e8 b4 e7 ff ff       	call   80073d <cprintf>
  801f89:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f93:	83 ec 0c             	sub    $0xc,%esp
  801f96:	68 e4 3f 80 00       	push   $0x803fe4
  801f9b:	e8 9d e7 ff ff       	call   80073d <cprintf>
  801fa0:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fa3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fa7:	a1 40 50 80 00       	mov    0x805040,%eax
  801fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801faf:	eb 56                	jmp    802007 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb5:	74 1c                	je     801fd3 <print_mem_block_lists+0x114>
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 50 08             	mov    0x8(%eax),%edx
  801fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc0:	8b 48 08             	mov    0x8(%eax),%ecx
  801fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc9:	01 c8                	add    %ecx,%eax
  801fcb:	39 c2                	cmp    %eax,%edx
  801fcd:	73 04                	jae    801fd3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fcf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd6:	8b 50 08             	mov    0x8(%eax),%edx
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801fdf:	01 c2                	add    %eax,%edx
  801fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe4:	8b 40 08             	mov    0x8(%eax),%eax
  801fe7:	83 ec 04             	sub    $0x4,%esp
  801fea:	52                   	push   %edx
  801feb:	50                   	push   %eax
  801fec:	68 b1 3f 80 00       	push   $0x803fb1
  801ff1:	e8 47 e7 ff ff       	call   80073d <cprintf>
  801ff6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fff:	a1 48 50 80 00       	mov    0x805048,%eax
  802004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802007:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200b:	74 07                	je     802014 <print_mem_block_lists+0x155>
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	8b 00                	mov    (%eax),%eax
  802012:	eb 05                	jmp    802019 <print_mem_block_lists+0x15a>
  802014:	b8 00 00 00 00       	mov    $0x0,%eax
  802019:	a3 48 50 80 00       	mov    %eax,0x805048
  80201e:	a1 48 50 80 00       	mov    0x805048,%eax
  802023:	85 c0                	test   %eax,%eax
  802025:	75 8a                	jne    801fb1 <print_mem_block_lists+0xf2>
  802027:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202b:	75 84                	jne    801fb1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80202d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802031:	75 10                	jne    802043 <print_mem_block_lists+0x184>
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	68 fc 3f 80 00       	push   $0x803ffc
  80203b:	e8 fd e6 ff ff       	call   80073d <cprintf>
  802040:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802043:	83 ec 0c             	sub    $0xc,%esp
  802046:	68 70 3f 80 00       	push   $0x803f70
  80204b:	e8 ed e6 ff ff       	call   80073d <cprintf>
  802050:	83 c4 10             	add    $0x10,%esp

}
  802053:	90                   	nop
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80205c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802063:	00 00 00 
  802066:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80206d:	00 00 00 
  802070:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802077:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80207a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802081:	e9 9e 00 00 00       	jmp    802124 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802086:	a1 50 50 80 00       	mov    0x805050,%eax
  80208b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208e:	c1 e2 04             	shl    $0x4,%edx
  802091:	01 d0                	add    %edx,%eax
  802093:	85 c0                	test   %eax,%eax
  802095:	75 14                	jne    8020ab <initialize_MemBlocksList+0x55>
  802097:	83 ec 04             	sub    $0x4,%esp
  80209a:	68 24 40 80 00       	push   $0x804024
  80209f:	6a 46                	push   $0x46
  8020a1:	68 47 40 80 00       	push   $0x804047
  8020a6:	e8 64 14 00 00       	call   80350f <_panic>
  8020ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8020b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b3:	c1 e2 04             	shl    $0x4,%edx
  8020b6:	01 d0                	add    %edx,%eax
  8020b8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020be:	89 10                	mov    %edx,(%eax)
  8020c0:	8b 00                	mov    (%eax),%eax
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	74 18                	je     8020de <initialize_MemBlocksList+0x88>
  8020c6:	a1 48 51 80 00       	mov    0x805148,%eax
  8020cb:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020d1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020d4:	c1 e1 04             	shl    $0x4,%ecx
  8020d7:	01 ca                	add    %ecx,%edx
  8020d9:	89 50 04             	mov    %edx,0x4(%eax)
  8020dc:	eb 12                	jmp    8020f0 <initialize_MemBlocksList+0x9a>
  8020de:	a1 50 50 80 00       	mov    0x805050,%eax
  8020e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e6:	c1 e2 04             	shl    $0x4,%edx
  8020e9:	01 d0                	add    %edx,%eax
  8020eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8020f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f8:	c1 e2 04             	shl    $0x4,%edx
  8020fb:	01 d0                	add    %edx,%eax
  8020fd:	a3 48 51 80 00       	mov    %eax,0x805148
  802102:	a1 50 50 80 00       	mov    0x805050,%eax
  802107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210a:	c1 e2 04             	shl    $0x4,%edx
  80210d:	01 d0                	add    %edx,%eax
  80210f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802116:	a1 54 51 80 00       	mov    0x805154,%eax
  80211b:	40                   	inc    %eax
  80211c:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802121:	ff 45 f4             	incl   -0xc(%ebp)
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	3b 45 08             	cmp    0x8(%ebp),%eax
  80212a:	0f 82 56 ff ff ff    	jb     802086 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802130:	90                   	nop
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	8b 00                	mov    (%eax),%eax
  80213e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802141:	eb 19                	jmp    80215c <find_block+0x29>
	{
		if(va==point->sva)
  802143:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802146:	8b 40 08             	mov    0x8(%eax),%eax
  802149:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80214c:	75 05                	jne    802153 <find_block+0x20>
		   return point;
  80214e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802151:	eb 36                	jmp    802189 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	8b 40 08             	mov    0x8(%eax),%eax
  802159:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80215c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802160:	74 07                	je     802169 <find_block+0x36>
  802162:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802165:	8b 00                	mov    (%eax),%eax
  802167:	eb 05                	jmp    80216e <find_block+0x3b>
  802169:	b8 00 00 00 00       	mov    $0x0,%eax
  80216e:	8b 55 08             	mov    0x8(%ebp),%edx
  802171:	89 42 08             	mov    %eax,0x8(%edx)
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	8b 40 08             	mov    0x8(%eax),%eax
  80217a:	85 c0                	test   %eax,%eax
  80217c:	75 c5                	jne    802143 <find_block+0x10>
  80217e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802182:	75 bf                	jne    802143 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802184:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802191:	a1 40 50 80 00       	mov    0x805040,%eax
  802196:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802199:	a1 44 50 80 00       	mov    0x805044,%eax
  80219e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021a7:	74 24                	je     8021cd <insert_sorted_allocList+0x42>
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	8b 50 08             	mov    0x8(%eax),%edx
  8021af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b2:	8b 40 08             	mov    0x8(%eax),%eax
  8021b5:	39 c2                	cmp    %eax,%edx
  8021b7:	76 14                	jbe    8021cd <insert_sorted_allocList+0x42>
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	8b 50 08             	mov    0x8(%eax),%edx
  8021bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c2:	8b 40 08             	mov    0x8(%eax),%eax
  8021c5:	39 c2                	cmp    %eax,%edx
  8021c7:	0f 82 60 01 00 00    	jb     80232d <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021d1:	75 65                	jne    802238 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d7:	75 14                	jne    8021ed <insert_sorted_allocList+0x62>
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	68 24 40 80 00       	push   $0x804024
  8021e1:	6a 6b                	push   $0x6b
  8021e3:	68 47 40 80 00       	push   $0x804047
  8021e8:	e8 22 13 00 00       	call   80350f <_panic>
  8021ed:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	89 10                	mov    %edx,(%eax)
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	8b 00                	mov    (%eax),%eax
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	74 0d                	je     80220e <insert_sorted_allocList+0x83>
  802201:	a1 40 50 80 00       	mov    0x805040,%eax
  802206:	8b 55 08             	mov    0x8(%ebp),%edx
  802209:	89 50 04             	mov    %edx,0x4(%eax)
  80220c:	eb 08                	jmp    802216 <insert_sorted_allocList+0x8b>
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	a3 44 50 80 00       	mov    %eax,0x805044
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	a3 40 50 80 00       	mov    %eax,0x805040
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802228:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80222d:	40                   	inc    %eax
  80222e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802233:	e9 dc 01 00 00       	jmp    802414 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	8b 50 08             	mov    0x8(%eax),%edx
  80223e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802241:	8b 40 08             	mov    0x8(%eax),%eax
  802244:	39 c2                	cmp    %eax,%edx
  802246:	77 6c                	ja     8022b4 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802248:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80224c:	74 06                	je     802254 <insert_sorted_allocList+0xc9>
  80224e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802252:	75 14                	jne    802268 <insert_sorted_allocList+0xdd>
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	68 60 40 80 00       	push   $0x804060
  80225c:	6a 6f                	push   $0x6f
  80225e:	68 47 40 80 00       	push   $0x804047
  802263:	e8 a7 12 00 00       	call   80350f <_panic>
  802268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226b:	8b 50 04             	mov    0x4(%eax),%edx
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	89 50 04             	mov    %edx,0x4(%eax)
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80227a:	89 10                	mov    %edx,(%eax)
  80227c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227f:	8b 40 04             	mov    0x4(%eax),%eax
  802282:	85 c0                	test   %eax,%eax
  802284:	74 0d                	je     802293 <insert_sorted_allocList+0x108>
  802286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802289:	8b 40 04             	mov    0x4(%eax),%eax
  80228c:	8b 55 08             	mov    0x8(%ebp),%edx
  80228f:	89 10                	mov    %edx,(%eax)
  802291:	eb 08                	jmp    80229b <insert_sorted_allocList+0x110>
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	a3 40 50 80 00       	mov    %eax,0x805040
  80229b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229e:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a1:	89 50 04             	mov    %edx,0x4(%eax)
  8022a4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022a9:	40                   	inc    %eax
  8022aa:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022af:	e9 60 01 00 00       	jmp    802414 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	8b 50 08             	mov    0x8(%eax),%edx
  8022ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bd:	8b 40 08             	mov    0x8(%eax),%eax
  8022c0:	39 c2                	cmp    %eax,%edx
  8022c2:	0f 82 4c 01 00 00    	jb     802414 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022cc:	75 14                	jne    8022e2 <insert_sorted_allocList+0x157>
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	68 98 40 80 00       	push   $0x804098
  8022d6:	6a 73                	push   $0x73
  8022d8:	68 47 40 80 00       	push   $0x804047
  8022dd:	e8 2d 12 00 00       	call   80350f <_panic>
  8022e2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	89 50 04             	mov    %edx,0x4(%eax)
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	8b 40 04             	mov    0x4(%eax),%eax
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	74 0c                	je     802304 <insert_sorted_allocList+0x179>
  8022f8:	a1 44 50 80 00       	mov    0x805044,%eax
  8022fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802300:	89 10                	mov    %edx,(%eax)
  802302:	eb 08                	jmp    80230c <insert_sorted_allocList+0x181>
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	a3 40 50 80 00       	mov    %eax,0x805040
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	a3 44 50 80 00       	mov    %eax,0x805044
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80231d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802322:	40                   	inc    %eax
  802323:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802328:	e9 e7 00 00 00       	jmp    802414 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80232d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802330:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802333:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80233a:	a1 40 50 80 00       	mov    0x805040,%eax
  80233f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802342:	e9 9d 00 00 00       	jmp    8023e4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	8b 50 08             	mov    0x8(%eax),%edx
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 40 08             	mov    0x8(%eax),%eax
  80235b:	39 c2                	cmp    %eax,%edx
  80235d:	76 7d                	jbe    8023dc <insert_sorted_allocList+0x251>
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	8b 50 08             	mov    0x8(%eax),%edx
  802365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802368:	8b 40 08             	mov    0x8(%eax),%eax
  80236b:	39 c2                	cmp    %eax,%edx
  80236d:	73 6d                	jae    8023dc <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80236f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802373:	74 06                	je     80237b <insert_sorted_allocList+0x1f0>
  802375:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802379:	75 14                	jne    80238f <insert_sorted_allocList+0x204>
  80237b:	83 ec 04             	sub    $0x4,%esp
  80237e:	68 bc 40 80 00       	push   $0x8040bc
  802383:	6a 7f                	push   $0x7f
  802385:	68 47 40 80 00       	push   $0x804047
  80238a:	e8 80 11 00 00       	call   80350f <_panic>
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	8b 10                	mov    (%eax),%edx
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	89 10                	mov    %edx,(%eax)
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	74 0b                	je     8023ad <insert_sorted_allocList+0x222>
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023aa:	89 50 04             	mov    %edx,0x4(%eax)
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b3:	89 10                	mov    %edx,(%eax)
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bb:	89 50 04             	mov    %edx,0x4(%eax)
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	75 08                	jne    8023cf <insert_sorted_allocList+0x244>
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	a3 44 50 80 00       	mov    %eax,0x805044
  8023cf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023d4:	40                   	inc    %eax
  8023d5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023da:	eb 39                	jmp    802415 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023dc:	a1 48 50 80 00       	mov    0x805048,%eax
  8023e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e8:	74 07                	je     8023f1 <insert_sorted_allocList+0x266>
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	eb 05                	jmp    8023f6 <insert_sorted_allocList+0x26b>
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f6:	a3 48 50 80 00       	mov    %eax,0x805048
  8023fb:	a1 48 50 80 00       	mov    0x805048,%eax
  802400:	85 c0                	test   %eax,%eax
  802402:	0f 85 3f ff ff ff    	jne    802347 <insert_sorted_allocList+0x1bc>
  802408:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240c:	0f 85 35 ff ff ff    	jne    802347 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802412:	eb 01                	jmp    802415 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802414:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802415:	90                   	nop
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80241e:	a1 38 51 80 00       	mov    0x805138,%eax
  802423:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802426:	e9 85 01 00 00       	jmp    8025b0 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 40 0c             	mov    0xc(%eax),%eax
  802431:	3b 45 08             	cmp    0x8(%ebp),%eax
  802434:	0f 82 6e 01 00 00    	jb     8025a8 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 40 0c             	mov    0xc(%eax),%eax
  802440:	3b 45 08             	cmp    0x8(%ebp),%eax
  802443:	0f 85 8a 00 00 00    	jne    8024d3 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244d:	75 17                	jne    802466 <alloc_block_FF+0x4e>
  80244f:	83 ec 04             	sub    $0x4,%esp
  802452:	68 f0 40 80 00       	push   $0x8040f0
  802457:	68 93 00 00 00       	push   $0x93
  80245c:	68 47 40 80 00       	push   $0x804047
  802461:	e8 a9 10 00 00       	call   80350f <_panic>
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 00                	mov    (%eax),%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	74 10                	je     80247f <alloc_block_FF+0x67>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802477:	8b 52 04             	mov    0x4(%edx),%edx
  80247a:	89 50 04             	mov    %edx,0x4(%eax)
  80247d:	eb 0b                	jmp    80248a <alloc_block_FF+0x72>
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 40 04             	mov    0x4(%eax),%eax
  802485:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 40 04             	mov    0x4(%eax),%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	74 0f                	je     8024a3 <alloc_block_FF+0x8b>
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 40 04             	mov    0x4(%eax),%eax
  80249a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249d:	8b 12                	mov    (%edx),%edx
  80249f:	89 10                	mov    %edx,(%eax)
  8024a1:	eb 0a                	jmp    8024ad <alloc_block_FF+0x95>
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 00                	mov    (%eax),%eax
  8024a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8024c5:	48                   	dec    %eax
  8024c6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	e9 10 01 00 00       	jmp    8025e3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dc:	0f 86 c6 00 00 00    	jbe    8025a8 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8024e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 50 08             	mov    0x8(%eax),%edx
  8024f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fc:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802503:	75 17                	jne    80251c <alloc_block_FF+0x104>
  802505:	83 ec 04             	sub    $0x4,%esp
  802508:	68 f0 40 80 00       	push   $0x8040f0
  80250d:	68 9b 00 00 00       	push   $0x9b
  802512:	68 47 40 80 00       	push   $0x804047
  802517:	e8 f3 0f 00 00       	call   80350f <_panic>
  80251c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251f:	8b 00                	mov    (%eax),%eax
  802521:	85 c0                	test   %eax,%eax
  802523:	74 10                	je     802535 <alloc_block_FF+0x11d>
  802525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802528:	8b 00                	mov    (%eax),%eax
  80252a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252d:	8b 52 04             	mov    0x4(%edx),%edx
  802530:	89 50 04             	mov    %edx,0x4(%eax)
  802533:	eb 0b                	jmp    802540 <alloc_block_FF+0x128>
  802535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802538:	8b 40 04             	mov    0x4(%eax),%eax
  80253b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	8b 40 04             	mov    0x4(%eax),%eax
  802546:	85 c0                	test   %eax,%eax
  802548:	74 0f                	je     802559 <alloc_block_FF+0x141>
  80254a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254d:	8b 40 04             	mov    0x4(%eax),%eax
  802550:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802553:	8b 12                	mov    (%edx),%edx
  802555:	89 10                	mov    %edx,(%eax)
  802557:	eb 0a                	jmp    802563 <alloc_block_FF+0x14b>
  802559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255c:	8b 00                	mov    (%eax),%eax
  80255e:	a3 48 51 80 00       	mov    %eax,0x805148
  802563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802576:	a1 54 51 80 00       	mov    0x805154,%eax
  80257b:	48                   	dec    %eax
  80257c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 50 08             	mov    0x8(%eax),%edx
  802587:	8b 45 08             	mov    0x8(%ebp),%eax
  80258a:	01 c2                	add    %eax,%edx
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 0c             	mov    0xc(%eax),%eax
  802598:	2b 45 08             	sub    0x8(%ebp),%eax
  80259b:	89 c2                	mov    %eax,%edx
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a6:	eb 3b                	jmp    8025e3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b4:	74 07                	je     8025bd <alloc_block_FF+0x1a5>
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	eb 05                	jmp    8025c2 <alloc_block_FF+0x1aa>
  8025bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c2:	a3 40 51 80 00       	mov    %eax,0x805140
  8025c7:	a1 40 51 80 00       	mov    0x805140,%eax
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	0f 85 57 fe ff ff    	jne    80242b <alloc_block_FF+0x13>
  8025d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d8:	0f 85 4d fe ff ff    	jne    80242b <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
  8025e8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025eb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8025f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fa:	e9 df 00 00 00       	jmp    8026de <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 40 0c             	mov    0xc(%eax),%eax
  802605:	3b 45 08             	cmp    0x8(%ebp),%eax
  802608:	0f 82 c8 00 00 00    	jb     8026d6 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	8b 40 0c             	mov    0xc(%eax),%eax
  802614:	3b 45 08             	cmp    0x8(%ebp),%eax
  802617:	0f 85 8a 00 00 00    	jne    8026a7 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80261d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802621:	75 17                	jne    80263a <alloc_block_BF+0x55>
  802623:	83 ec 04             	sub    $0x4,%esp
  802626:	68 f0 40 80 00       	push   $0x8040f0
  80262b:	68 b7 00 00 00       	push   $0xb7
  802630:	68 47 40 80 00       	push   $0x804047
  802635:	e8 d5 0e 00 00       	call   80350f <_panic>
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 00                	mov    (%eax),%eax
  80263f:	85 c0                	test   %eax,%eax
  802641:	74 10                	je     802653 <alloc_block_BF+0x6e>
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 00                	mov    (%eax),%eax
  802648:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264b:	8b 52 04             	mov    0x4(%edx),%edx
  80264e:	89 50 04             	mov    %edx,0x4(%eax)
  802651:	eb 0b                	jmp    80265e <alloc_block_BF+0x79>
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 40 04             	mov    0x4(%eax),%eax
  802664:	85 c0                	test   %eax,%eax
  802666:	74 0f                	je     802677 <alloc_block_BF+0x92>
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 04             	mov    0x4(%eax),%eax
  80266e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802671:	8b 12                	mov    (%edx),%edx
  802673:	89 10                	mov    %edx,(%eax)
  802675:	eb 0a                	jmp    802681 <alloc_block_BF+0x9c>
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 00                	mov    (%eax),%eax
  80267c:	a3 38 51 80 00       	mov    %eax,0x805138
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802694:	a1 44 51 80 00       	mov    0x805144,%eax
  802699:	48                   	dec    %eax
  80269a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	e9 4d 01 00 00       	jmp    8027f4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b0:	76 24                	jbe    8026d6 <alloc_block_BF+0xf1>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026bb:	73 19                	jae    8026d6 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026bd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 40 08             	mov    0x8(%eax),%eax
  8026d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8026db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e2:	74 07                	je     8026eb <alloc_block_BF+0x106>
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	eb 05                	jmp    8026f0 <alloc_block_BF+0x10b>
  8026eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f0:	a3 40 51 80 00       	mov    %eax,0x805140
  8026f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	0f 85 fd fe ff ff    	jne    8025ff <alloc_block_BF+0x1a>
  802702:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802706:	0f 85 f3 fe ff ff    	jne    8025ff <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80270c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802710:	0f 84 d9 00 00 00    	je     8027ef <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802716:	a1 48 51 80 00       	mov    0x805148,%eax
  80271b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80271e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802721:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802724:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272a:	8b 55 08             	mov    0x8(%ebp),%edx
  80272d:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802730:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802734:	75 17                	jne    80274d <alloc_block_BF+0x168>
  802736:	83 ec 04             	sub    $0x4,%esp
  802739:	68 f0 40 80 00       	push   $0x8040f0
  80273e:	68 c7 00 00 00       	push   $0xc7
  802743:	68 47 40 80 00       	push   $0x804047
  802748:	e8 c2 0d 00 00       	call   80350f <_panic>
  80274d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	85 c0                	test   %eax,%eax
  802754:	74 10                	je     802766 <alloc_block_BF+0x181>
  802756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80275e:	8b 52 04             	mov    0x4(%edx),%edx
  802761:	89 50 04             	mov    %edx,0x4(%eax)
  802764:	eb 0b                	jmp    802771 <alloc_block_BF+0x18c>
  802766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802769:	8b 40 04             	mov    0x4(%eax),%eax
  80276c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 0f                	je     80278a <alloc_block_BF+0x1a5>
  80277b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277e:	8b 40 04             	mov    0x4(%eax),%eax
  802781:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802784:	8b 12                	mov    (%edx),%edx
  802786:	89 10                	mov    %edx,(%eax)
  802788:	eb 0a                	jmp    802794 <alloc_block_BF+0x1af>
  80278a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	a3 48 51 80 00       	mov    %eax,0x805148
  802794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ac:	48                   	dec    %eax
  8027ad:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027b2:	83 ec 08             	sub    $0x8,%esp
  8027b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8027b8:	68 38 51 80 00       	push   $0x805138
  8027bd:	e8 71 f9 ff ff       	call   802133 <find_block>
  8027c2:	83 c4 10             	add    $0x10,%esp
  8027c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cb:	8b 50 08             	mov    0x8(%eax),%edx
  8027ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d1:	01 c2                	add    %eax,%edx
  8027d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d6:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027df:	2b 45 08             	sub    0x8(%ebp),%eax
  8027e2:	89 c2                	mov    %eax,%edx
  8027e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ed:	eb 05                	jmp    8027f4 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
  8027f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027fc:	a1 28 50 80 00       	mov    0x805028,%eax
  802801:	85 c0                	test   %eax,%eax
  802803:	0f 85 de 01 00 00    	jne    8029e7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802809:	a1 38 51 80 00       	mov    0x805138,%eax
  80280e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802811:	e9 9e 01 00 00       	jmp    8029b4 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 40 0c             	mov    0xc(%eax),%eax
  80281c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80281f:	0f 82 87 01 00 00    	jb     8029ac <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 40 0c             	mov    0xc(%eax),%eax
  80282b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282e:	0f 85 95 00 00 00    	jne    8028c9 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802834:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802838:	75 17                	jne    802851 <alloc_block_NF+0x5b>
  80283a:	83 ec 04             	sub    $0x4,%esp
  80283d:	68 f0 40 80 00       	push   $0x8040f0
  802842:	68 e0 00 00 00       	push   $0xe0
  802847:	68 47 40 80 00       	push   $0x804047
  80284c:	e8 be 0c 00 00       	call   80350f <_panic>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	85 c0                	test   %eax,%eax
  802858:	74 10                	je     80286a <alloc_block_NF+0x74>
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 00                	mov    (%eax),%eax
  80285f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802862:	8b 52 04             	mov    0x4(%edx),%edx
  802865:	89 50 04             	mov    %edx,0x4(%eax)
  802868:	eb 0b                	jmp    802875 <alloc_block_NF+0x7f>
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 40 04             	mov    0x4(%eax),%eax
  802870:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 40 04             	mov    0x4(%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	74 0f                	je     80288e <alloc_block_NF+0x98>
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 04             	mov    0x4(%eax),%eax
  802885:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802888:	8b 12                	mov    (%edx),%edx
  80288a:	89 10                	mov    %edx,(%eax)
  80288c:	eb 0a                	jmp    802898 <alloc_block_NF+0xa2>
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	a3 38 51 80 00       	mov    %eax,0x805138
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8028b0:	48                   	dec    %eax
  8028b1:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 08             	mov    0x8(%eax),%eax
  8028bc:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	e9 f8 04 00 00       	jmp    802dc1 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d2:	0f 86 d4 00 00 00    	jbe    8029ac <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8028dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 50 08             	mov    0x8(%eax),%edx
  8028e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028f9:	75 17                	jne    802912 <alloc_block_NF+0x11c>
  8028fb:	83 ec 04             	sub    $0x4,%esp
  8028fe:	68 f0 40 80 00       	push   $0x8040f0
  802903:	68 e9 00 00 00       	push   $0xe9
  802908:	68 47 40 80 00       	push   $0x804047
  80290d:	e8 fd 0b 00 00       	call   80350f <_panic>
  802912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 10                	je     80292b <alloc_block_NF+0x135>
  80291b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802923:	8b 52 04             	mov    0x4(%edx),%edx
  802926:	89 50 04             	mov    %edx,0x4(%eax)
  802929:	eb 0b                	jmp    802936 <alloc_block_NF+0x140>
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	8b 40 04             	mov    0x4(%eax),%eax
  802931:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802939:	8b 40 04             	mov    0x4(%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 0f                	je     80294f <alloc_block_NF+0x159>
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	8b 40 04             	mov    0x4(%eax),%eax
  802946:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802949:	8b 12                	mov    (%edx),%edx
  80294b:	89 10                	mov    %edx,(%eax)
  80294d:	eb 0a                	jmp    802959 <alloc_block_NF+0x163>
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	a3 48 51 80 00       	mov    %eax,0x805148
  802959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296c:	a1 54 51 80 00       	mov    0x805154,%eax
  802971:	48                   	dec    %eax
  802972:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297a:	8b 40 08             	mov    0x8(%eax),%eax
  80297d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 50 08             	mov    0x8(%eax),%edx
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	01 c2                	add    %eax,%edx
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 40 0c             	mov    0xc(%eax),%eax
  802999:	2b 45 08             	sub    0x8(%ebp),%eax
  80299c:	89 c2                	mov    %eax,%edx
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a7:	e9 15 04 00 00       	jmp    802dc1 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029ac:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b8:	74 07                	je     8029c1 <alloc_block_NF+0x1cb>
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	eb 05                	jmp    8029c6 <alloc_block_NF+0x1d0>
  8029c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c6:	a3 40 51 80 00       	mov    %eax,0x805140
  8029cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8029d0:	85 c0                	test   %eax,%eax
  8029d2:	0f 85 3e fe ff ff    	jne    802816 <alloc_block_NF+0x20>
  8029d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029dc:	0f 85 34 fe ff ff    	jne    802816 <alloc_block_NF+0x20>
  8029e2:	e9 d5 03 00 00       	jmp    802dbc <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8029ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ef:	e9 b1 01 00 00       	jmp    802ba5 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 50 08             	mov    0x8(%eax),%edx
  8029fa:	a1 28 50 80 00       	mov    0x805028,%eax
  8029ff:	39 c2                	cmp    %eax,%edx
  802a01:	0f 82 96 01 00 00    	jb     802b9d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a10:	0f 82 87 01 00 00    	jb     802b9d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1f:	0f 85 95 00 00 00    	jne    802aba <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a29:	75 17                	jne    802a42 <alloc_block_NF+0x24c>
  802a2b:	83 ec 04             	sub    $0x4,%esp
  802a2e:	68 f0 40 80 00       	push   $0x8040f0
  802a33:	68 fc 00 00 00       	push   $0xfc
  802a38:	68 47 40 80 00       	push   $0x804047
  802a3d:	e8 cd 0a 00 00       	call   80350f <_panic>
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 10                	je     802a5b <alloc_block_NF+0x265>
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a53:	8b 52 04             	mov    0x4(%edx),%edx
  802a56:	89 50 04             	mov    %edx,0x4(%eax)
  802a59:	eb 0b                	jmp    802a66 <alloc_block_NF+0x270>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 40 04             	mov    0x4(%eax),%eax
  802a61:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 40 04             	mov    0x4(%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 0f                	je     802a7f <alloc_block_NF+0x289>
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a79:	8b 12                	mov    (%edx),%edx
  802a7b:	89 10                	mov    %edx,(%eax)
  802a7d:	eb 0a                	jmp    802a89 <alloc_block_NF+0x293>
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	a3 38 51 80 00       	mov    %eax,0x805138
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9c:	a1 44 51 80 00       	mov    0x805144,%eax
  802aa1:	48                   	dec    %eax
  802aa2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 40 08             	mov    0x8(%eax),%eax
  802aad:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	e9 07 03 00 00       	jmp    802dc1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac3:	0f 86 d4 00 00 00    	jbe    802b9d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ac9:	a1 48 51 80 00       	mov    0x805148,%eax
  802ace:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 50 08             	mov    0x8(%eax),%edx
  802ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ada:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ae6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aea:	75 17                	jne    802b03 <alloc_block_NF+0x30d>
  802aec:	83 ec 04             	sub    $0x4,%esp
  802aef:	68 f0 40 80 00       	push   $0x8040f0
  802af4:	68 04 01 00 00       	push   $0x104
  802af9:	68 47 40 80 00       	push   $0x804047
  802afe:	e8 0c 0a 00 00       	call   80350f <_panic>
  802b03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	74 10                	je     802b1c <alloc_block_NF+0x326>
  802b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b14:	8b 52 04             	mov    0x4(%edx),%edx
  802b17:	89 50 04             	mov    %edx,0x4(%eax)
  802b1a:	eb 0b                	jmp    802b27 <alloc_block_NF+0x331>
  802b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2a:	8b 40 04             	mov    0x4(%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 0f                	je     802b40 <alloc_block_NF+0x34a>
  802b31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b34:	8b 40 04             	mov    0x4(%eax),%eax
  802b37:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b3a:	8b 12                	mov    (%edx),%edx
  802b3c:	89 10                	mov    %edx,(%eax)
  802b3e:	eb 0a                	jmp    802b4a <alloc_block_NF+0x354>
  802b40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	a3 48 51 80 00       	mov    %eax,0x805148
  802b4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5d:	a1 54 51 80 00       	mov    0x805154,%eax
  802b62:	48                   	dec    %eax
  802b63:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6b:	8b 40 08             	mov    0x8(%eax),%eax
  802b6e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 50 08             	mov    0x8(%eax),%edx
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	01 c2                	add    %eax,%edx
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8a:	2b 45 08             	sub    0x8(%ebp),%eax
  802b8d:	89 c2                	mov    %eax,%edx
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b98:	e9 24 02 00 00       	jmp    802dc1 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b9d:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba9:	74 07                	je     802bb2 <alloc_block_NF+0x3bc>
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 00                	mov    (%eax),%eax
  802bb0:	eb 05                	jmp    802bb7 <alloc_block_NF+0x3c1>
  802bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb7:	a3 40 51 80 00       	mov    %eax,0x805140
  802bbc:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	0f 85 2b fe ff ff    	jne    8029f4 <alloc_block_NF+0x1fe>
  802bc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcd:	0f 85 21 fe ff ff    	jne    8029f4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bd3:	a1 38 51 80 00       	mov    0x805138,%eax
  802bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bdb:	e9 ae 01 00 00       	jmp    802d8e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 50 08             	mov    0x8(%eax),%edx
  802be6:	a1 28 50 80 00       	mov    0x805028,%eax
  802beb:	39 c2                	cmp    %eax,%edx
  802bed:	0f 83 93 01 00 00    	jae    802d86 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bfc:	0f 82 84 01 00 00    	jb     802d86 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 40 0c             	mov    0xc(%eax),%eax
  802c08:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0b:	0f 85 95 00 00 00    	jne    802ca6 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c15:	75 17                	jne    802c2e <alloc_block_NF+0x438>
  802c17:	83 ec 04             	sub    $0x4,%esp
  802c1a:	68 f0 40 80 00       	push   $0x8040f0
  802c1f:	68 14 01 00 00       	push   $0x114
  802c24:	68 47 40 80 00       	push   $0x804047
  802c29:	e8 e1 08 00 00       	call   80350f <_panic>
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	74 10                	je     802c47 <alloc_block_NF+0x451>
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3f:	8b 52 04             	mov    0x4(%edx),%edx
  802c42:	89 50 04             	mov    %edx,0x4(%eax)
  802c45:	eb 0b                	jmp    802c52 <alloc_block_NF+0x45c>
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 40 04             	mov    0x4(%eax),%eax
  802c4d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 40 04             	mov    0x4(%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 0f                	je     802c6b <alloc_block_NF+0x475>
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 40 04             	mov    0x4(%eax),%eax
  802c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c65:	8b 12                	mov    (%edx),%edx
  802c67:	89 10                	mov    %edx,(%eax)
  802c69:	eb 0a                	jmp    802c75 <alloc_block_NF+0x47f>
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	a3 38 51 80 00       	mov    %eax,0x805138
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c88:	a1 44 51 80 00       	mov    0x805144,%eax
  802c8d:	48                   	dec    %eax
  802c8e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 40 08             	mov    0x8(%eax),%eax
  802c99:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	e9 1b 01 00 00       	jmp    802dc1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cac:	3b 45 08             	cmp    0x8(%ebp),%eax
  802caf:	0f 86 d1 00 00 00    	jbe    802d86 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cb5:	a1 48 51 80 00       	mov    0x805148,%eax
  802cba:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 50 08             	mov    0x8(%eax),%edx
  802cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccf:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cd2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cd6:	75 17                	jne    802cef <alloc_block_NF+0x4f9>
  802cd8:	83 ec 04             	sub    $0x4,%esp
  802cdb:	68 f0 40 80 00       	push   $0x8040f0
  802ce0:	68 1c 01 00 00       	push   $0x11c
  802ce5:	68 47 40 80 00       	push   $0x804047
  802cea:	e8 20 08 00 00       	call   80350f <_panic>
  802cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	85 c0                	test   %eax,%eax
  802cf6:	74 10                	je     802d08 <alloc_block_NF+0x512>
  802cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d00:	8b 52 04             	mov    0x4(%edx),%edx
  802d03:	89 50 04             	mov    %edx,0x4(%eax)
  802d06:	eb 0b                	jmp    802d13 <alloc_block_NF+0x51d>
  802d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0b:	8b 40 04             	mov    0x4(%eax),%eax
  802d0e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d16:	8b 40 04             	mov    0x4(%eax),%eax
  802d19:	85 c0                	test   %eax,%eax
  802d1b:	74 0f                	je     802d2c <alloc_block_NF+0x536>
  802d1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d20:	8b 40 04             	mov    0x4(%eax),%eax
  802d23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d26:	8b 12                	mov    (%edx),%edx
  802d28:	89 10                	mov    %edx,(%eax)
  802d2a:	eb 0a                	jmp    802d36 <alloc_block_NF+0x540>
  802d2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	a3 48 51 80 00       	mov    %eax,0x805148
  802d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d49:	a1 54 51 80 00       	mov    0x805154,%eax
  802d4e:	48                   	dec    %eax
  802d4f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d57:	8b 40 08             	mov    0x8(%eax),%eax
  802d5a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 50 08             	mov    0x8(%eax),%edx
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	01 c2                	add    %eax,%edx
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 40 0c             	mov    0xc(%eax),%eax
  802d76:	2b 45 08             	sub    0x8(%ebp),%eax
  802d79:	89 c2                	mov    %eax,%edx
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d84:	eb 3b                	jmp    802dc1 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d86:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d92:	74 07                	je     802d9b <alloc_block_NF+0x5a5>
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	8b 00                	mov    (%eax),%eax
  802d99:	eb 05                	jmp    802da0 <alloc_block_NF+0x5aa>
  802d9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802da0:	a3 40 51 80 00       	mov    %eax,0x805140
  802da5:	a1 40 51 80 00       	mov    0x805140,%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	0f 85 2e fe ff ff    	jne    802be0 <alloc_block_NF+0x3ea>
  802db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db6:	0f 85 24 fe ff ff    	jne    802be0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc1:	c9                   	leave  
  802dc2:	c3                   	ret    

00802dc3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802dc3:	55                   	push   %ebp
  802dc4:	89 e5                	mov    %esp,%ebp
  802dc6:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802dc9:	a1 38 51 80 00       	mov    0x805138,%eax
  802dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802dd1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dd6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802dd9:	a1 38 51 80 00       	mov    0x805138,%eax
  802dde:	85 c0                	test   %eax,%eax
  802de0:	74 14                	je     802df6 <insert_sorted_with_merge_freeList+0x33>
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 50 08             	mov    0x8(%eax),%edx
  802de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802deb:	8b 40 08             	mov    0x8(%eax),%eax
  802dee:	39 c2                	cmp    %eax,%edx
  802df0:	0f 87 9b 01 00 00    	ja     802f91 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802df6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfa:	75 17                	jne    802e13 <insert_sorted_with_merge_freeList+0x50>
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	68 24 40 80 00       	push   $0x804024
  802e04:	68 38 01 00 00       	push   $0x138
  802e09:	68 47 40 80 00       	push   $0x804047
  802e0e:	e8 fc 06 00 00       	call   80350f <_panic>
  802e13:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	89 10                	mov    %edx,(%eax)
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 0d                	je     802e34 <insert_sorted_with_merge_freeList+0x71>
  802e27:	a1 38 51 80 00       	mov    0x805138,%eax
  802e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2f:	89 50 04             	mov    %edx,0x4(%eax)
  802e32:	eb 08                	jmp    802e3c <insert_sorted_with_merge_freeList+0x79>
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	a3 38 51 80 00       	mov    %eax,0x805138
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e53:	40                   	inc    %eax
  802e54:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e5d:	0f 84 a8 06 00 00    	je     80350b <insert_sorted_with_merge_freeList+0x748>
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	8b 50 08             	mov    0x8(%eax),%edx
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6f:	01 c2                	add    %eax,%edx
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	8b 40 08             	mov    0x8(%eax),%eax
  802e77:	39 c2                	cmp    %eax,%edx
  802e79:	0f 85 8c 06 00 00    	jne    80350b <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	8b 50 0c             	mov    0xc(%eax),%edx
  802e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e88:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8b:	01 c2                	add    %eax,%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e97:	75 17                	jne    802eb0 <insert_sorted_with_merge_freeList+0xed>
  802e99:	83 ec 04             	sub    $0x4,%esp
  802e9c:	68 f0 40 80 00       	push   $0x8040f0
  802ea1:	68 3c 01 00 00       	push   $0x13c
  802ea6:	68 47 40 80 00       	push   $0x804047
  802eab:	e8 5f 06 00 00       	call   80350f <_panic>
  802eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 10                	je     802ec9 <insert_sorted_with_merge_freeList+0x106>
  802eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec1:	8b 52 04             	mov    0x4(%edx),%edx
  802ec4:	89 50 04             	mov    %edx,0x4(%eax)
  802ec7:	eb 0b                	jmp    802ed4 <insert_sorted_with_merge_freeList+0x111>
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	8b 40 04             	mov    0x4(%eax),%eax
  802ecf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	8b 40 04             	mov    0x4(%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 0f                	je     802eed <insert_sorted_with_merge_freeList+0x12a>
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	8b 40 04             	mov    0x4(%eax),%eax
  802ee4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee7:	8b 12                	mov    (%edx),%edx
  802ee9:	89 10                	mov    %edx,(%eax)
  802eeb:	eb 0a                	jmp    802ef7 <insert_sorted_with_merge_freeList+0x134>
  802eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f0f:	48                   	dec    %eax
  802f10:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f18:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f2d:	75 17                	jne    802f46 <insert_sorted_with_merge_freeList+0x183>
  802f2f:	83 ec 04             	sub    $0x4,%esp
  802f32:	68 24 40 80 00       	push   $0x804024
  802f37:	68 3f 01 00 00       	push   $0x13f
  802f3c:	68 47 40 80 00       	push   $0x804047
  802f41:	e8 c9 05 00 00       	call   80350f <_panic>
  802f46:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4f:	89 10                	mov    %edx,(%eax)
  802f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 0d                	je     802f67 <insert_sorted_with_merge_freeList+0x1a4>
  802f5a:	a1 48 51 80 00       	mov    0x805148,%eax
  802f5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f62:	89 50 04             	mov    %edx,0x4(%eax)
  802f65:	eb 08                	jmp    802f6f <insert_sorted_with_merge_freeList+0x1ac>
  802f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f72:	a3 48 51 80 00       	mov    %eax,0x805148
  802f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f81:	a1 54 51 80 00       	mov    0x805154,%eax
  802f86:	40                   	inc    %eax
  802f87:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f8c:	e9 7a 05 00 00       	jmp    80350b <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	8b 50 08             	mov    0x8(%eax),%edx
  802f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9a:	8b 40 08             	mov    0x8(%eax),%eax
  802f9d:	39 c2                	cmp    %eax,%edx
  802f9f:	0f 82 14 01 00 00    	jb     8030b9 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa8:	8b 50 08             	mov    0x8(%eax),%edx
  802fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fae:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb1:	01 c2                	add    %eax,%edx
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 40 08             	mov    0x8(%eax),%eax
  802fb9:	39 c2                	cmp    %eax,%edx
  802fbb:	0f 85 90 00 00 00    	jne    803051 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc4:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcd:	01 c2                	add    %eax,%edx
  802fcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd2:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fe9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fed:	75 17                	jne    803006 <insert_sorted_with_merge_freeList+0x243>
  802fef:	83 ec 04             	sub    $0x4,%esp
  802ff2:	68 24 40 80 00       	push   $0x804024
  802ff7:	68 49 01 00 00       	push   $0x149
  802ffc:	68 47 40 80 00       	push   $0x804047
  803001:	e8 09 05 00 00       	call   80350f <_panic>
  803006:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 0d                	je     803027 <insert_sorted_with_merge_freeList+0x264>
  80301a:	a1 48 51 80 00       	mov    0x805148,%eax
  80301f:	8b 55 08             	mov    0x8(%ebp),%edx
  803022:	89 50 04             	mov    %edx,0x4(%eax)
  803025:	eb 08                	jmp    80302f <insert_sorted_with_merge_freeList+0x26c>
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	a3 48 51 80 00       	mov    %eax,0x805148
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803041:	a1 54 51 80 00       	mov    0x805154,%eax
  803046:	40                   	inc    %eax
  803047:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80304c:	e9 bb 04 00 00       	jmp    80350c <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803051:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803055:	75 17                	jne    80306e <insert_sorted_with_merge_freeList+0x2ab>
  803057:	83 ec 04             	sub    $0x4,%esp
  80305a:	68 98 40 80 00       	push   $0x804098
  80305f:	68 4c 01 00 00       	push   $0x14c
  803064:	68 47 40 80 00       	push   $0x804047
  803069:	e8 a1 04 00 00       	call   80350f <_panic>
  80306e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	89 50 04             	mov    %edx,0x4(%eax)
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	8b 40 04             	mov    0x4(%eax),%eax
  803080:	85 c0                	test   %eax,%eax
  803082:	74 0c                	je     803090 <insert_sorted_with_merge_freeList+0x2cd>
  803084:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803089:	8b 55 08             	mov    0x8(%ebp),%edx
  80308c:	89 10                	mov    %edx,(%eax)
  80308e:	eb 08                	jmp    803098 <insert_sorted_with_merge_freeList+0x2d5>
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	a3 38 51 80 00       	mov    %eax,0x805138
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ae:	40                   	inc    %eax
  8030af:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030b4:	e9 53 04 00 00       	jmp    80350c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8030be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c1:	e9 15 04 00 00       	jmp    8034db <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 00                	mov    (%eax),%eax
  8030cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 50 08             	mov    0x8(%eax),%edx
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 40 08             	mov    0x8(%eax),%eax
  8030da:	39 c2                	cmp    %eax,%edx
  8030dc:	0f 86 f1 03 00 00    	jbe    8034d3 <insert_sorted_with_merge_freeList+0x710>
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	8b 50 08             	mov    0x8(%eax),%edx
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	8b 40 08             	mov    0x8(%eax),%eax
  8030ee:	39 c2                	cmp    %eax,%edx
  8030f0:	0f 83 dd 03 00 00    	jae    8034d3 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	8b 50 08             	mov    0x8(%eax),%edx
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803102:	01 c2                	add    %eax,%edx
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	8b 40 08             	mov    0x8(%eax),%eax
  80310a:	39 c2                	cmp    %eax,%edx
  80310c:	0f 85 b9 01 00 00    	jne    8032cb <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	8b 50 08             	mov    0x8(%eax),%edx
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	8b 40 0c             	mov    0xc(%eax),%eax
  80311e:	01 c2                	add    %eax,%edx
  803120:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803123:	8b 40 08             	mov    0x8(%eax),%eax
  803126:	39 c2                	cmp    %eax,%edx
  803128:	0f 85 0d 01 00 00    	jne    80323b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80312e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803131:	8b 50 0c             	mov    0xc(%eax),%edx
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	8b 40 0c             	mov    0xc(%eax),%eax
  80313a:	01 c2                	add    %eax,%edx
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803142:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803146:	75 17                	jne    80315f <insert_sorted_with_merge_freeList+0x39c>
  803148:	83 ec 04             	sub    $0x4,%esp
  80314b:	68 f0 40 80 00       	push   $0x8040f0
  803150:	68 5c 01 00 00       	push   $0x15c
  803155:	68 47 40 80 00       	push   $0x804047
  80315a:	e8 b0 03 00 00       	call   80350f <_panic>
  80315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803162:	8b 00                	mov    (%eax),%eax
  803164:	85 c0                	test   %eax,%eax
  803166:	74 10                	je     803178 <insert_sorted_with_merge_freeList+0x3b5>
  803168:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803170:	8b 52 04             	mov    0x4(%edx),%edx
  803173:	89 50 04             	mov    %edx,0x4(%eax)
  803176:	eb 0b                	jmp    803183 <insert_sorted_with_merge_freeList+0x3c0>
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	8b 40 04             	mov    0x4(%eax),%eax
  80317e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	8b 40 04             	mov    0x4(%eax),%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	74 0f                	je     80319c <insert_sorted_with_merge_freeList+0x3d9>
  80318d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803190:	8b 40 04             	mov    0x4(%eax),%eax
  803193:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803196:	8b 12                	mov    (%edx),%edx
  803198:	89 10                	mov    %edx,(%eax)
  80319a:	eb 0a                	jmp    8031a6 <insert_sorted_with_merge_freeList+0x3e3>
  80319c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319f:	8b 00                	mov    (%eax),%eax
  8031a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8031be:	48                   	dec    %eax
  8031bf:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031dc:	75 17                	jne    8031f5 <insert_sorted_with_merge_freeList+0x432>
  8031de:	83 ec 04             	sub    $0x4,%esp
  8031e1:	68 24 40 80 00       	push   $0x804024
  8031e6:	68 5f 01 00 00       	push   $0x15f
  8031eb:	68 47 40 80 00       	push   $0x804047
  8031f0:	e8 1a 03 00 00       	call   80350f <_panic>
  8031f5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	89 10                	mov    %edx,(%eax)
  803200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803203:	8b 00                	mov    (%eax),%eax
  803205:	85 c0                	test   %eax,%eax
  803207:	74 0d                	je     803216 <insert_sorted_with_merge_freeList+0x453>
  803209:	a1 48 51 80 00       	mov    0x805148,%eax
  80320e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803211:	89 50 04             	mov    %edx,0x4(%eax)
  803214:	eb 08                	jmp    80321e <insert_sorted_with_merge_freeList+0x45b>
  803216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803219:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	a3 48 51 80 00       	mov    %eax,0x805148
  803226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803229:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803230:	a1 54 51 80 00       	mov    0x805154,%eax
  803235:	40                   	inc    %eax
  803236:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80323b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323e:	8b 50 0c             	mov    0xc(%eax),%edx
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	8b 40 0c             	mov    0xc(%eax),%eax
  803247:	01 c2                	add    %eax,%edx
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803263:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803267:	75 17                	jne    803280 <insert_sorted_with_merge_freeList+0x4bd>
  803269:	83 ec 04             	sub    $0x4,%esp
  80326c:	68 24 40 80 00       	push   $0x804024
  803271:	68 64 01 00 00       	push   $0x164
  803276:	68 47 40 80 00       	push   $0x804047
  80327b:	e8 8f 02 00 00       	call   80350f <_panic>
  803280:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	89 10                	mov    %edx,(%eax)
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	85 c0                	test   %eax,%eax
  803292:	74 0d                	je     8032a1 <insert_sorted_with_merge_freeList+0x4de>
  803294:	a1 48 51 80 00       	mov    0x805148,%eax
  803299:	8b 55 08             	mov    0x8(%ebp),%edx
  80329c:	89 50 04             	mov    %edx,0x4(%eax)
  80329f:	eb 08                	jmp    8032a9 <insert_sorted_with_merge_freeList+0x4e6>
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8032c0:	40                   	inc    %eax
  8032c1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032c6:	e9 41 02 00 00       	jmp    80350c <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	8b 50 08             	mov    0x8(%eax),%edx
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d7:	01 c2                	add    %eax,%edx
  8032d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032dc:	8b 40 08             	mov    0x8(%eax),%eax
  8032df:	39 c2                	cmp    %eax,%edx
  8032e1:	0f 85 7c 01 00 00    	jne    803463 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032eb:	74 06                	je     8032f3 <insert_sorted_with_merge_freeList+0x530>
  8032ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f1:	75 17                	jne    80330a <insert_sorted_with_merge_freeList+0x547>
  8032f3:	83 ec 04             	sub    $0x4,%esp
  8032f6:	68 60 40 80 00       	push   $0x804060
  8032fb:	68 69 01 00 00       	push   $0x169
  803300:	68 47 40 80 00       	push   $0x804047
  803305:	e8 05 02 00 00       	call   80350f <_panic>
  80330a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330d:	8b 50 04             	mov    0x4(%eax),%edx
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	89 50 04             	mov    %edx,0x4(%eax)
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331c:	89 10                	mov    %edx,(%eax)
  80331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803321:	8b 40 04             	mov    0x4(%eax),%eax
  803324:	85 c0                	test   %eax,%eax
  803326:	74 0d                	je     803335 <insert_sorted_with_merge_freeList+0x572>
  803328:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332b:	8b 40 04             	mov    0x4(%eax),%eax
  80332e:	8b 55 08             	mov    0x8(%ebp),%edx
  803331:	89 10                	mov    %edx,(%eax)
  803333:	eb 08                	jmp    80333d <insert_sorted_with_merge_freeList+0x57a>
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	a3 38 51 80 00       	mov    %eax,0x805138
  80333d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803340:	8b 55 08             	mov    0x8(%ebp),%edx
  803343:	89 50 04             	mov    %edx,0x4(%eax)
  803346:	a1 44 51 80 00       	mov    0x805144,%eax
  80334b:	40                   	inc    %eax
  80334c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	8b 50 0c             	mov    0xc(%eax),%edx
  803357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335a:	8b 40 0c             	mov    0xc(%eax),%eax
  80335d:	01 c2                	add    %eax,%edx
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803365:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803369:	75 17                	jne    803382 <insert_sorted_with_merge_freeList+0x5bf>
  80336b:	83 ec 04             	sub    $0x4,%esp
  80336e:	68 f0 40 80 00       	push   $0x8040f0
  803373:	68 6b 01 00 00       	push   $0x16b
  803378:	68 47 40 80 00       	push   $0x804047
  80337d:	e8 8d 01 00 00       	call   80350f <_panic>
  803382:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803385:	8b 00                	mov    (%eax),%eax
  803387:	85 c0                	test   %eax,%eax
  803389:	74 10                	je     80339b <insert_sorted_with_merge_freeList+0x5d8>
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	8b 00                	mov    (%eax),%eax
  803390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803393:	8b 52 04             	mov    0x4(%edx),%edx
  803396:	89 50 04             	mov    %edx,0x4(%eax)
  803399:	eb 0b                	jmp    8033a6 <insert_sorted_with_merge_freeList+0x5e3>
  80339b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339e:	8b 40 04             	mov    0x4(%eax),%eax
  8033a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a9:	8b 40 04             	mov    0x4(%eax),%eax
  8033ac:	85 c0                	test   %eax,%eax
  8033ae:	74 0f                	je     8033bf <insert_sorted_with_merge_freeList+0x5fc>
  8033b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b3:	8b 40 04             	mov    0x4(%eax),%eax
  8033b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b9:	8b 12                	mov    (%edx),%edx
  8033bb:	89 10                	mov    %edx,(%eax)
  8033bd:	eb 0a                	jmp    8033c9 <insert_sorted_with_merge_freeList+0x606>
  8033bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c2:	8b 00                	mov    (%eax),%eax
  8033c4:	a3 38 51 80 00       	mov    %eax,0x805138
  8033c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e1:	48                   	dec    %eax
  8033e2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033ff:	75 17                	jne    803418 <insert_sorted_with_merge_freeList+0x655>
  803401:	83 ec 04             	sub    $0x4,%esp
  803404:	68 24 40 80 00       	push   $0x804024
  803409:	68 6e 01 00 00       	push   $0x16e
  80340e:	68 47 40 80 00       	push   $0x804047
  803413:	e8 f7 00 00 00       	call   80350f <_panic>
  803418:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80341e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803421:	89 10                	mov    %edx,(%eax)
  803423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	85 c0                	test   %eax,%eax
  80342a:	74 0d                	je     803439 <insert_sorted_with_merge_freeList+0x676>
  80342c:	a1 48 51 80 00       	mov    0x805148,%eax
  803431:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803434:	89 50 04             	mov    %edx,0x4(%eax)
  803437:	eb 08                	jmp    803441 <insert_sorted_with_merge_freeList+0x67e>
  803439:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803444:	a3 48 51 80 00       	mov    %eax,0x805148
  803449:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803453:	a1 54 51 80 00       	mov    0x805154,%eax
  803458:	40                   	inc    %eax
  803459:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80345e:	e9 a9 00 00 00       	jmp    80350c <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803467:	74 06                	je     80346f <insert_sorted_with_merge_freeList+0x6ac>
  803469:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80346d:	75 17                	jne    803486 <insert_sorted_with_merge_freeList+0x6c3>
  80346f:	83 ec 04             	sub    $0x4,%esp
  803472:	68 bc 40 80 00       	push   $0x8040bc
  803477:	68 73 01 00 00       	push   $0x173
  80347c:	68 47 40 80 00       	push   $0x804047
  803481:	e8 89 00 00 00       	call   80350f <_panic>
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	8b 10                	mov    (%eax),%edx
  80348b:	8b 45 08             	mov    0x8(%ebp),%eax
  80348e:	89 10                	mov    %edx,(%eax)
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	8b 00                	mov    (%eax),%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	74 0b                	je     8034a4 <insert_sorted_with_merge_freeList+0x6e1>
  803499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349c:	8b 00                	mov    (%eax),%eax
  80349e:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a1:	89 50 04             	mov    %edx,0x4(%eax)
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034aa:	89 10                	mov    %edx,(%eax)
  8034ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8034af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b2:	89 50 04             	mov    %edx,0x4(%eax)
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	8b 00                	mov    (%eax),%eax
  8034ba:	85 c0                	test   %eax,%eax
  8034bc:	75 08                	jne    8034c6 <insert_sorted_with_merge_freeList+0x703>
  8034be:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034c6:	a1 44 51 80 00       	mov    0x805144,%eax
  8034cb:	40                   	inc    %eax
  8034cc:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034d1:	eb 39                	jmp    80350c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8034d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034df:	74 07                	je     8034e8 <insert_sorted_with_merge_freeList+0x725>
  8034e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	eb 05                	jmp    8034ed <insert_sorted_with_merge_freeList+0x72a>
  8034e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ed:	a3 40 51 80 00       	mov    %eax,0x805140
  8034f2:	a1 40 51 80 00       	mov    0x805140,%eax
  8034f7:	85 c0                	test   %eax,%eax
  8034f9:	0f 85 c7 fb ff ff    	jne    8030c6 <insert_sorted_with_merge_freeList+0x303>
  8034ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803503:	0f 85 bd fb ff ff    	jne    8030c6 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803509:	eb 01                	jmp    80350c <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80350b:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80350c:	90                   	nop
  80350d:	c9                   	leave  
  80350e:	c3                   	ret    

0080350f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80350f:	55                   	push   %ebp
  803510:	89 e5                	mov    %esp,%ebp
  803512:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803515:	8d 45 10             	lea    0x10(%ebp),%eax
  803518:	83 c0 04             	add    $0x4,%eax
  80351b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80351e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803523:	85 c0                	test   %eax,%eax
  803525:	74 16                	je     80353d <_panic+0x2e>
		cprintf("%s: ", argv0);
  803527:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80352c:	83 ec 08             	sub    $0x8,%esp
  80352f:	50                   	push   %eax
  803530:	68 10 41 80 00       	push   $0x804110
  803535:	e8 03 d2 ff ff       	call   80073d <cprintf>
  80353a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80353d:	a1 00 50 80 00       	mov    0x805000,%eax
  803542:	ff 75 0c             	pushl  0xc(%ebp)
  803545:	ff 75 08             	pushl  0x8(%ebp)
  803548:	50                   	push   %eax
  803549:	68 15 41 80 00       	push   $0x804115
  80354e:	e8 ea d1 ff ff       	call   80073d <cprintf>
  803553:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803556:	8b 45 10             	mov    0x10(%ebp),%eax
  803559:	83 ec 08             	sub    $0x8,%esp
  80355c:	ff 75 f4             	pushl  -0xc(%ebp)
  80355f:	50                   	push   %eax
  803560:	e8 6d d1 ff ff       	call   8006d2 <vcprintf>
  803565:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803568:	83 ec 08             	sub    $0x8,%esp
  80356b:	6a 00                	push   $0x0
  80356d:	68 31 41 80 00       	push   $0x804131
  803572:	e8 5b d1 ff ff       	call   8006d2 <vcprintf>
  803577:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80357a:	e8 dc d0 ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  80357f:	eb fe                	jmp    80357f <_panic+0x70>

00803581 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803581:	55                   	push   %ebp
  803582:	89 e5                	mov    %esp,%ebp
  803584:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803587:	a1 20 50 80 00       	mov    0x805020,%eax
  80358c:	8b 50 74             	mov    0x74(%eax),%edx
  80358f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803592:	39 c2                	cmp    %eax,%edx
  803594:	74 14                	je     8035aa <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803596:	83 ec 04             	sub    $0x4,%esp
  803599:	68 34 41 80 00       	push   $0x804134
  80359e:	6a 26                	push   $0x26
  8035a0:	68 80 41 80 00       	push   $0x804180
  8035a5:	e8 65 ff ff ff       	call   80350f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8035aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8035b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035b8:	e9 c2 00 00 00       	jmp    80367f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8035bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	01 d0                	add    %edx,%eax
  8035cc:	8b 00                	mov    (%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	75 08                	jne    8035da <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8035d2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8035d5:	e9 a2 00 00 00       	jmp    80367c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8035da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8035e8:	eb 69                	jmp    803653 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8035ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8035ef:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035f8:	89 d0                	mov    %edx,%eax
  8035fa:	01 c0                	add    %eax,%eax
  8035fc:	01 d0                	add    %edx,%eax
  8035fe:	c1 e0 03             	shl    $0x3,%eax
  803601:	01 c8                	add    %ecx,%eax
  803603:	8a 40 04             	mov    0x4(%eax),%al
  803606:	84 c0                	test   %al,%al
  803608:	75 46                	jne    803650 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80360a:	a1 20 50 80 00       	mov    0x805020,%eax
  80360f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803615:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803618:	89 d0                	mov    %edx,%eax
  80361a:	01 c0                	add    %eax,%eax
  80361c:	01 d0                	add    %edx,%eax
  80361e:	c1 e0 03             	shl    $0x3,%eax
  803621:	01 c8                	add    %ecx,%eax
  803623:	8b 00                	mov    (%eax),%eax
  803625:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803628:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80362b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803630:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803632:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803635:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80363c:	8b 45 08             	mov    0x8(%ebp),%eax
  80363f:	01 c8                	add    %ecx,%eax
  803641:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803643:	39 c2                	cmp    %eax,%edx
  803645:	75 09                	jne    803650 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803647:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80364e:	eb 12                	jmp    803662 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803650:	ff 45 e8             	incl   -0x18(%ebp)
  803653:	a1 20 50 80 00       	mov    0x805020,%eax
  803658:	8b 50 74             	mov    0x74(%eax),%edx
  80365b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365e:	39 c2                	cmp    %eax,%edx
  803660:	77 88                	ja     8035ea <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803662:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803666:	75 14                	jne    80367c <CheckWSWithoutLastIndex+0xfb>
			panic(
  803668:	83 ec 04             	sub    $0x4,%esp
  80366b:	68 8c 41 80 00       	push   $0x80418c
  803670:	6a 3a                	push   $0x3a
  803672:	68 80 41 80 00       	push   $0x804180
  803677:	e8 93 fe ff ff       	call   80350f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80367c:	ff 45 f0             	incl   -0x10(%ebp)
  80367f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803682:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803685:	0f 8c 32 ff ff ff    	jl     8035bd <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80368b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803692:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803699:	eb 26                	jmp    8036c1 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80369b:	a1 20 50 80 00       	mov    0x805020,%eax
  8036a0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8036a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036a9:	89 d0                	mov    %edx,%eax
  8036ab:	01 c0                	add    %eax,%eax
  8036ad:	01 d0                	add    %edx,%eax
  8036af:	c1 e0 03             	shl    $0x3,%eax
  8036b2:	01 c8                	add    %ecx,%eax
  8036b4:	8a 40 04             	mov    0x4(%eax),%al
  8036b7:	3c 01                	cmp    $0x1,%al
  8036b9:	75 03                	jne    8036be <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8036bb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036be:	ff 45 e0             	incl   -0x20(%ebp)
  8036c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8036c6:	8b 50 74             	mov    0x74(%eax),%edx
  8036c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036cc:	39 c2                	cmp    %eax,%edx
  8036ce:	77 cb                	ja     80369b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8036d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036d6:	74 14                	je     8036ec <CheckWSWithoutLastIndex+0x16b>
		panic(
  8036d8:	83 ec 04             	sub    $0x4,%esp
  8036db:	68 e0 41 80 00       	push   $0x8041e0
  8036e0:	6a 44                	push   $0x44
  8036e2:	68 80 41 80 00       	push   $0x804180
  8036e7:	e8 23 fe ff ff       	call   80350f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8036ec:	90                   	nop
  8036ed:	c9                   	leave  
  8036ee:	c3                   	ret    
  8036ef:	90                   	nop

008036f0 <__udivdi3>:
  8036f0:	55                   	push   %ebp
  8036f1:	57                   	push   %edi
  8036f2:	56                   	push   %esi
  8036f3:	53                   	push   %ebx
  8036f4:	83 ec 1c             	sub    $0x1c,%esp
  8036f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803703:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803707:	89 ca                	mov    %ecx,%edx
  803709:	89 f8                	mov    %edi,%eax
  80370b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80370f:	85 f6                	test   %esi,%esi
  803711:	75 2d                	jne    803740 <__udivdi3+0x50>
  803713:	39 cf                	cmp    %ecx,%edi
  803715:	77 65                	ja     80377c <__udivdi3+0x8c>
  803717:	89 fd                	mov    %edi,%ebp
  803719:	85 ff                	test   %edi,%edi
  80371b:	75 0b                	jne    803728 <__udivdi3+0x38>
  80371d:	b8 01 00 00 00       	mov    $0x1,%eax
  803722:	31 d2                	xor    %edx,%edx
  803724:	f7 f7                	div    %edi
  803726:	89 c5                	mov    %eax,%ebp
  803728:	31 d2                	xor    %edx,%edx
  80372a:	89 c8                	mov    %ecx,%eax
  80372c:	f7 f5                	div    %ebp
  80372e:	89 c1                	mov    %eax,%ecx
  803730:	89 d8                	mov    %ebx,%eax
  803732:	f7 f5                	div    %ebp
  803734:	89 cf                	mov    %ecx,%edi
  803736:	89 fa                	mov    %edi,%edx
  803738:	83 c4 1c             	add    $0x1c,%esp
  80373b:	5b                   	pop    %ebx
  80373c:	5e                   	pop    %esi
  80373d:	5f                   	pop    %edi
  80373e:	5d                   	pop    %ebp
  80373f:	c3                   	ret    
  803740:	39 ce                	cmp    %ecx,%esi
  803742:	77 28                	ja     80376c <__udivdi3+0x7c>
  803744:	0f bd fe             	bsr    %esi,%edi
  803747:	83 f7 1f             	xor    $0x1f,%edi
  80374a:	75 40                	jne    80378c <__udivdi3+0x9c>
  80374c:	39 ce                	cmp    %ecx,%esi
  80374e:	72 0a                	jb     80375a <__udivdi3+0x6a>
  803750:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803754:	0f 87 9e 00 00 00    	ja     8037f8 <__udivdi3+0x108>
  80375a:	b8 01 00 00 00       	mov    $0x1,%eax
  80375f:	89 fa                	mov    %edi,%edx
  803761:	83 c4 1c             	add    $0x1c,%esp
  803764:	5b                   	pop    %ebx
  803765:	5e                   	pop    %esi
  803766:	5f                   	pop    %edi
  803767:	5d                   	pop    %ebp
  803768:	c3                   	ret    
  803769:	8d 76 00             	lea    0x0(%esi),%esi
  80376c:	31 ff                	xor    %edi,%edi
  80376e:	31 c0                	xor    %eax,%eax
  803770:	89 fa                	mov    %edi,%edx
  803772:	83 c4 1c             	add    $0x1c,%esp
  803775:	5b                   	pop    %ebx
  803776:	5e                   	pop    %esi
  803777:	5f                   	pop    %edi
  803778:	5d                   	pop    %ebp
  803779:	c3                   	ret    
  80377a:	66 90                	xchg   %ax,%ax
  80377c:	89 d8                	mov    %ebx,%eax
  80377e:	f7 f7                	div    %edi
  803780:	31 ff                	xor    %edi,%edi
  803782:	89 fa                	mov    %edi,%edx
  803784:	83 c4 1c             	add    $0x1c,%esp
  803787:	5b                   	pop    %ebx
  803788:	5e                   	pop    %esi
  803789:	5f                   	pop    %edi
  80378a:	5d                   	pop    %ebp
  80378b:	c3                   	ret    
  80378c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803791:	89 eb                	mov    %ebp,%ebx
  803793:	29 fb                	sub    %edi,%ebx
  803795:	89 f9                	mov    %edi,%ecx
  803797:	d3 e6                	shl    %cl,%esi
  803799:	89 c5                	mov    %eax,%ebp
  80379b:	88 d9                	mov    %bl,%cl
  80379d:	d3 ed                	shr    %cl,%ebp
  80379f:	89 e9                	mov    %ebp,%ecx
  8037a1:	09 f1                	or     %esi,%ecx
  8037a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037a7:	89 f9                	mov    %edi,%ecx
  8037a9:	d3 e0                	shl    %cl,%eax
  8037ab:	89 c5                	mov    %eax,%ebp
  8037ad:	89 d6                	mov    %edx,%esi
  8037af:	88 d9                	mov    %bl,%cl
  8037b1:	d3 ee                	shr    %cl,%esi
  8037b3:	89 f9                	mov    %edi,%ecx
  8037b5:	d3 e2                	shl    %cl,%edx
  8037b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037bb:	88 d9                	mov    %bl,%cl
  8037bd:	d3 e8                	shr    %cl,%eax
  8037bf:	09 c2                	or     %eax,%edx
  8037c1:	89 d0                	mov    %edx,%eax
  8037c3:	89 f2                	mov    %esi,%edx
  8037c5:	f7 74 24 0c          	divl   0xc(%esp)
  8037c9:	89 d6                	mov    %edx,%esi
  8037cb:	89 c3                	mov    %eax,%ebx
  8037cd:	f7 e5                	mul    %ebp
  8037cf:	39 d6                	cmp    %edx,%esi
  8037d1:	72 19                	jb     8037ec <__udivdi3+0xfc>
  8037d3:	74 0b                	je     8037e0 <__udivdi3+0xf0>
  8037d5:	89 d8                	mov    %ebx,%eax
  8037d7:	31 ff                	xor    %edi,%edi
  8037d9:	e9 58 ff ff ff       	jmp    803736 <__udivdi3+0x46>
  8037de:	66 90                	xchg   %ax,%ax
  8037e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037e4:	89 f9                	mov    %edi,%ecx
  8037e6:	d3 e2                	shl    %cl,%edx
  8037e8:	39 c2                	cmp    %eax,%edx
  8037ea:	73 e9                	jae    8037d5 <__udivdi3+0xe5>
  8037ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037ef:	31 ff                	xor    %edi,%edi
  8037f1:	e9 40 ff ff ff       	jmp    803736 <__udivdi3+0x46>
  8037f6:	66 90                	xchg   %ax,%ax
  8037f8:	31 c0                	xor    %eax,%eax
  8037fa:	e9 37 ff ff ff       	jmp    803736 <__udivdi3+0x46>
  8037ff:	90                   	nop

00803800 <__umoddi3>:
  803800:	55                   	push   %ebp
  803801:	57                   	push   %edi
  803802:	56                   	push   %esi
  803803:	53                   	push   %ebx
  803804:	83 ec 1c             	sub    $0x1c,%esp
  803807:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80380b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80380f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803813:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803817:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80381b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80381f:	89 f3                	mov    %esi,%ebx
  803821:	89 fa                	mov    %edi,%edx
  803823:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803827:	89 34 24             	mov    %esi,(%esp)
  80382a:	85 c0                	test   %eax,%eax
  80382c:	75 1a                	jne    803848 <__umoddi3+0x48>
  80382e:	39 f7                	cmp    %esi,%edi
  803830:	0f 86 a2 00 00 00    	jbe    8038d8 <__umoddi3+0xd8>
  803836:	89 c8                	mov    %ecx,%eax
  803838:	89 f2                	mov    %esi,%edx
  80383a:	f7 f7                	div    %edi
  80383c:	89 d0                	mov    %edx,%eax
  80383e:	31 d2                	xor    %edx,%edx
  803840:	83 c4 1c             	add    $0x1c,%esp
  803843:	5b                   	pop    %ebx
  803844:	5e                   	pop    %esi
  803845:	5f                   	pop    %edi
  803846:	5d                   	pop    %ebp
  803847:	c3                   	ret    
  803848:	39 f0                	cmp    %esi,%eax
  80384a:	0f 87 ac 00 00 00    	ja     8038fc <__umoddi3+0xfc>
  803850:	0f bd e8             	bsr    %eax,%ebp
  803853:	83 f5 1f             	xor    $0x1f,%ebp
  803856:	0f 84 ac 00 00 00    	je     803908 <__umoddi3+0x108>
  80385c:	bf 20 00 00 00       	mov    $0x20,%edi
  803861:	29 ef                	sub    %ebp,%edi
  803863:	89 fe                	mov    %edi,%esi
  803865:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803869:	89 e9                	mov    %ebp,%ecx
  80386b:	d3 e0                	shl    %cl,%eax
  80386d:	89 d7                	mov    %edx,%edi
  80386f:	89 f1                	mov    %esi,%ecx
  803871:	d3 ef                	shr    %cl,%edi
  803873:	09 c7                	or     %eax,%edi
  803875:	89 e9                	mov    %ebp,%ecx
  803877:	d3 e2                	shl    %cl,%edx
  803879:	89 14 24             	mov    %edx,(%esp)
  80387c:	89 d8                	mov    %ebx,%eax
  80387e:	d3 e0                	shl    %cl,%eax
  803880:	89 c2                	mov    %eax,%edx
  803882:	8b 44 24 08          	mov    0x8(%esp),%eax
  803886:	d3 e0                	shl    %cl,%eax
  803888:	89 44 24 04          	mov    %eax,0x4(%esp)
  80388c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803890:	89 f1                	mov    %esi,%ecx
  803892:	d3 e8                	shr    %cl,%eax
  803894:	09 d0                	or     %edx,%eax
  803896:	d3 eb                	shr    %cl,%ebx
  803898:	89 da                	mov    %ebx,%edx
  80389a:	f7 f7                	div    %edi
  80389c:	89 d3                	mov    %edx,%ebx
  80389e:	f7 24 24             	mull   (%esp)
  8038a1:	89 c6                	mov    %eax,%esi
  8038a3:	89 d1                	mov    %edx,%ecx
  8038a5:	39 d3                	cmp    %edx,%ebx
  8038a7:	0f 82 87 00 00 00    	jb     803934 <__umoddi3+0x134>
  8038ad:	0f 84 91 00 00 00    	je     803944 <__umoddi3+0x144>
  8038b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038b7:	29 f2                	sub    %esi,%edx
  8038b9:	19 cb                	sbb    %ecx,%ebx
  8038bb:	89 d8                	mov    %ebx,%eax
  8038bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038c1:	d3 e0                	shl    %cl,%eax
  8038c3:	89 e9                	mov    %ebp,%ecx
  8038c5:	d3 ea                	shr    %cl,%edx
  8038c7:	09 d0                	or     %edx,%eax
  8038c9:	89 e9                	mov    %ebp,%ecx
  8038cb:	d3 eb                	shr    %cl,%ebx
  8038cd:	89 da                	mov    %ebx,%edx
  8038cf:	83 c4 1c             	add    $0x1c,%esp
  8038d2:	5b                   	pop    %ebx
  8038d3:	5e                   	pop    %esi
  8038d4:	5f                   	pop    %edi
  8038d5:	5d                   	pop    %ebp
  8038d6:	c3                   	ret    
  8038d7:	90                   	nop
  8038d8:	89 fd                	mov    %edi,%ebp
  8038da:	85 ff                	test   %edi,%edi
  8038dc:	75 0b                	jne    8038e9 <__umoddi3+0xe9>
  8038de:	b8 01 00 00 00       	mov    $0x1,%eax
  8038e3:	31 d2                	xor    %edx,%edx
  8038e5:	f7 f7                	div    %edi
  8038e7:	89 c5                	mov    %eax,%ebp
  8038e9:	89 f0                	mov    %esi,%eax
  8038eb:	31 d2                	xor    %edx,%edx
  8038ed:	f7 f5                	div    %ebp
  8038ef:	89 c8                	mov    %ecx,%eax
  8038f1:	f7 f5                	div    %ebp
  8038f3:	89 d0                	mov    %edx,%eax
  8038f5:	e9 44 ff ff ff       	jmp    80383e <__umoddi3+0x3e>
  8038fa:	66 90                	xchg   %ax,%ax
  8038fc:	89 c8                	mov    %ecx,%eax
  8038fe:	89 f2                	mov    %esi,%edx
  803900:	83 c4 1c             	add    $0x1c,%esp
  803903:	5b                   	pop    %ebx
  803904:	5e                   	pop    %esi
  803905:	5f                   	pop    %edi
  803906:	5d                   	pop    %ebp
  803907:	c3                   	ret    
  803908:	3b 04 24             	cmp    (%esp),%eax
  80390b:	72 06                	jb     803913 <__umoddi3+0x113>
  80390d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803911:	77 0f                	ja     803922 <__umoddi3+0x122>
  803913:	89 f2                	mov    %esi,%edx
  803915:	29 f9                	sub    %edi,%ecx
  803917:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80391b:	89 14 24             	mov    %edx,(%esp)
  80391e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803922:	8b 44 24 04          	mov    0x4(%esp),%eax
  803926:	8b 14 24             	mov    (%esp),%edx
  803929:	83 c4 1c             	add    $0x1c,%esp
  80392c:	5b                   	pop    %ebx
  80392d:	5e                   	pop    %esi
  80392e:	5f                   	pop    %edi
  80392f:	5d                   	pop    %ebp
  803930:	c3                   	ret    
  803931:	8d 76 00             	lea    0x0(%esi),%esi
  803934:	2b 04 24             	sub    (%esp),%eax
  803937:	19 fa                	sbb    %edi,%edx
  803939:	89 d1                	mov    %edx,%ecx
  80393b:	89 c6                	mov    %eax,%esi
  80393d:	e9 71 ff ff ff       	jmp    8038b3 <__umoddi3+0xb3>
  803942:	66 90                	xchg   %ax,%ax
  803944:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803948:	72 ea                	jb     803934 <__umoddi3+0x134>
  80394a:	89 d9                	mov    %ebx,%ecx
  80394c:	e9 62 ff ff ff       	jmp    8038b3 <__umoddi3+0xb3>
