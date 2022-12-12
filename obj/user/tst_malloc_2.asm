
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 80 03 00 00       	call   8003b6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 50 80 00       	mov    0x805020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 50 80 00       	mov    0x805020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 e0 37 80 00       	push   $0x8037e0
  800095:	6a 1a                	push   $0x1a
  800097:	68 fc 37 80 00       	push   $0x8037fc
  80009c:	e8 51 04 00 00       	call   8004f2 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 83 16 00 00       	call   80172e <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ae:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000bc:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000c0:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000c4:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000ca:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000d0:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d7:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000de:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000e4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	89 d7                	mov    %edx,%edi
  8000f0:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f5:	01 c0                	add    %eax,%eax
  8000f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 2b 16 00 00       	call   80172e <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  80010c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800118:	01 c0                	add    %eax,%eax
  80011a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011d:	48                   	dec    %eax
  80011e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  800121:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800124:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800127:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800129:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80012c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012f:	01 c2                	add    %eax,%edx
  800131:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800134:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	01 c0                	add    %eax,%eax
  80013b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	50                   	push   %eax
  800142:	e8 e7 15 00 00       	call   80172e <malloc>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800150:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800156:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015c:	01 c0                	add    %eax,%eax
  80015e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800161:	d1 e8                	shr    %eax
  800163:	48                   	dec    %eax
  800164:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800167:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80016a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016d:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800170:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800173:	01 c0                	add    %eax,%eax
  800175:	89 c2                	mov    %eax,%edx
  800177:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80017a:	01 c2                	add    %eax,%edx
  80017c:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800180:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800186:	89 c2                	mov    %eax,%edx
  800188:	01 d2                	add    %edx,%edx
  80018a:	01 d0                	add    %edx,%eax
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	e8 99 15 00 00       	call   80172e <malloc>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80019e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8001a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	c1 e8 02             	shr    $0x2,%eax
  8001af:	48                   	dec    %eax
  8001b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001b9:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c8:	01 c2                	add    %eax,%edx
  8001ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001cd:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001d2:	89 d0                	mov    %edx,%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	50                   	push   %eax
  8001e0:	e8 49 15 00 00       	call   80172e <malloc>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001fa:	89 d0                	mov    %edx,%eax
  8001fc:	01 c0                	add    %eax,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	c1 e8 03             	shr    $0x3,%eax
  800207:	48                   	dec    %eax
  800208:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80020b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020e:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800211:	88 10                	mov    %dl,(%eax)
  800213:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800219:	66 89 42 02          	mov    %ax,0x2(%edx)
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800223:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800226:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800229:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800230:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800233:	01 c2                	add    %eax,%edx
  800235:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800238:	88 02                	mov    %al,(%edx)
  80023a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800244:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800247:	01 c2                	add    %eax,%edx
  800249:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80024d:	66 89 42 02          	mov    %ax,0x2(%edx)
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80025b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80025e:	01 c2                	add    %eax,%edx
  800260:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800263:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800269:	8a 00                	mov    (%eax),%al
  80026b:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80026e:	75 0f                	jne    80027f <_main+0x247>
  800270:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8a 00                	mov    (%eax),%al
  80027a:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80027d:	74 14                	je     800293 <_main+0x25b>
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	68 10 38 80 00       	push   $0x803810
  800287:	6a 45                	push   $0x45
  800289:	68 fc 37 80 00       	push   $0x8037fc
  80028e:	e8 5f 02 00 00       	call   8004f2 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	66 8b 00             	mov    (%eax),%ax
  800299:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80029d:	75 15                	jne    8002b4 <_main+0x27c>
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	66 8b 00             	mov    (%eax),%ax
  8002ae:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  8002b2:	74 14                	je     8002c8 <_main+0x290>
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	68 10 38 80 00       	push   $0x803810
  8002bc:	6a 46                	push   $0x46
  8002be:	68 fc 37 80 00       	push   $0x8037fc
  8002c3:	e8 2a 02 00 00       	call   8004f2 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d0:	75 16                	jne    8002e8 <_main+0x2b0>
  8002d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8b 00                	mov    (%eax),%eax
  8002e3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 10 38 80 00       	push   $0x803810
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 fc 37 80 00       	push   $0x8037fc
  8002f7:	e8 f6 01 00 00       	call   8004f2 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ff:	8a 00                	mov    (%eax),%al
  800301:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800304:	75 16                	jne    80031c <_main+0x2e4>
  800306:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800309:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800310:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	8a 00                	mov    (%eax),%al
  800317:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80031a:	74 14                	je     800330 <_main+0x2f8>
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 10 38 80 00       	push   $0x803810
  800324:	6a 49                	push   $0x49
  800326:	68 fc 37 80 00       	push   $0x8037fc
  80032b:	e8 c2 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800330:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800333:	66 8b 40 02          	mov    0x2(%eax),%ax
  800337:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80033b:	75 19                	jne    800356 <_main+0x31e>
  80033d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800340:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800347:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800350:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800354:	74 14                	je     80036a <_main+0x332>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 10 38 80 00       	push   $0x803810
  80035e:	6a 4a                	push   $0x4a
  800360:	68 fc 37 80 00       	push   $0x8037fc
  800365:	e8 88 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  80036a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036d:	8b 40 04             	mov    0x4(%eax),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	75 17                	jne    80038c <_main+0x354>
  800375:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800378:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80037f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8b 40 04             	mov    0x4(%eax),%eax
  800387:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80038a:	74 14                	je     8003a0 <_main+0x368>
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 10 38 80 00       	push   $0x803810
  800394:	6a 4b                	push   $0x4b
  800396:	68 fc 37 80 00       	push   $0x8037fc
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 48 38 80 00       	push   $0x803848
  8003a8:	e8 f9 03 00 00       	call   8007a6 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp

	return;
  8003b0:	90                   	nop
}
  8003b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003bc:	e8 d5 18 00 00       	call   801c96 <sys_getenvindex>
  8003c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	c1 e0 03             	shl    $0x3,%eax
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	c1 e0 04             	shl    $0x4,%eax
  8003de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ed:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003f3:	84 c0                	test   %al,%al
  8003f5:	74 0f                	je     800406 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fc:	05 5c 05 00 00       	add    $0x55c,%eax
  800401:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80040a:	7e 0a                	jle    800416 <libmain+0x60>
		binaryname = argv[0];
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 14 fc ff ff       	call   800038 <_main>
  800424:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800427:	e8 77 16 00 00       	call   801aa3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 9c 38 80 00       	push   $0x80389c
  800434:	e8 6d 03 00 00       	call   8007a6 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043c:	a1 20 50 80 00       	mov    0x805020,%eax
  800441:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800447:	a1 20 50 80 00       	mov    0x805020,%eax
  80044c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	68 c4 38 80 00       	push   $0x8038c4
  80045c:	e8 45 03 00 00       	call   8007a6 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800464:	a1 20 50 80 00       	mov    0x805020,%eax
  800469:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80046f:	a1 20 50 80 00       	mov    0x805020,%eax
  800474:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80047a:	a1 20 50 80 00       	mov    0x805020,%eax
  80047f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800485:	51                   	push   %ecx
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	68 ec 38 80 00       	push   $0x8038ec
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 50 80 00       	mov    0x805020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 44 39 80 00       	push   $0x803944
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 9c 38 80 00       	push   $0x80389c
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 f7 15 00 00       	call   801abd <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004c6:	e8 19 00 00 00       	call   8004e4 <exit>
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	6a 00                	push   $0x0
  8004d9:	e8 84 17 00 00       	call   801c62 <sys_destroy_env>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	90                   	nop
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <exit>:

void
exit(void)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ea:	e8 d9 17 00 00       	call   801cc8 <sys_exit_env>
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800501:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	74 16                	je     800520 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050a:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	50                   	push   %eax
  800513:	68 58 39 80 00       	push   $0x803958
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 50 80 00       	mov    0x805000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 5d 39 80 00       	push   $0x80395d
  800531:	e8 70 02 00 00       	call   8007a6 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800539:	8b 45 10             	mov    0x10(%ebp),%eax
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 f4             	pushl  -0xc(%ebp)
  800542:	50                   	push   %eax
  800543:	e8 f3 01 00 00       	call   80073b <vcprintf>
  800548:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	6a 00                	push   $0x0
  800550:	68 79 39 80 00       	push   $0x803979
  800555:	e8 e1 01 00 00       	call   80073b <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80055d:	e8 82 ff ff ff       	call   8004e4 <exit>

	// should not return here
	while (1) ;
  800562:	eb fe                	jmp    800562 <_panic+0x70>

00800564 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056a:	a1 20 50 80 00       	mov    0x805020,%eax
  80056f:	8b 50 74             	mov    0x74(%eax),%edx
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	74 14                	je     80058d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 7c 39 80 00       	push   $0x80397c
  800581:	6a 26                	push   $0x26
  800583:	68 c8 39 80 00       	push   $0x8039c8
  800588:	e8 65 ff ff ff       	call   8004f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80058d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059b:	e9 c2 00 00 00       	jmp    800662 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	85 c0                	test   %eax,%eax
  8005b3:	75 08                	jne    8005bd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005b5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005b8:	e9 a2 00 00 00       	jmp    80065f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005cb:	eb 69                	jmp    800636 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005db:	89 d0                	mov    %edx,%eax
  8005dd:	01 c0                	add    %eax,%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c1 e0 03             	shl    $0x3,%eax
  8005e4:	01 c8                	add    %ecx,%eax
  8005e6:	8a 40 04             	mov    0x4(%eax),%al
  8005e9:	84 c0                	test   %al,%al
  8005eb:	75 46                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	01 c0                	add    %eax,%eax
  8005ff:	01 d0                	add    %edx,%eax
  800601:	c1 e0 03             	shl    $0x3,%eax
  800604:	01 c8                	add    %ecx,%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800613:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800618:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800626:	39 c2                	cmp    %eax,%edx
  800628:	75 09                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80062a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800631:	eb 12                	jmp    800645 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800633:	ff 45 e8             	incl   -0x18(%ebp)
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 50 74             	mov    0x74(%eax),%edx
  80063e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 88                	ja     8005cd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800649:	75 14                	jne    80065f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	68 d4 39 80 00       	push   $0x8039d4
  800653:	6a 3a                	push   $0x3a
  800655:	68 c8 39 80 00       	push   $0x8039c8
  80065a:	e8 93 fe ff ff       	call   8004f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80065f:	ff 45 f0             	incl   -0x10(%ebp)
  800662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800665:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800668:	0f 8c 32 ff ff ff    	jl     8005a0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800675:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80067c:	eb 26                	jmp    8006a4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80067e:	a1 20 50 80 00       	mov    0x805020,%eax
  800683:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	01 c0                	add    %eax,%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	c1 e0 03             	shl    $0x3,%eax
  800695:	01 c8                	add    %ecx,%eax
  800697:	8a 40 04             	mov    0x4(%eax),%al
  80069a:	3c 01                	cmp    $0x1,%al
  80069c:	75 03                	jne    8006a1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80069e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a1:	ff 45 e0             	incl   -0x20(%ebp)
  8006a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a9:	8b 50 74             	mov    0x74(%eax),%edx
  8006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006af:	39 c2                	cmp    %eax,%edx
  8006b1:	77 cb                	ja     80067e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b9:	74 14                	je     8006cf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	68 28 3a 80 00       	push   $0x803a28
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 c8 39 80 00       	push   $0x8039c8
  8006ca:	e8 23 fe ff ff       	call   8004f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8006e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e3:	89 0a                	mov    %ecx,(%edx)
  8006e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006e8:	88 d1                	mov    %dl,%cl
  8006ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006fb:	75 2c                	jne    800729 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006fd:	a0 24 50 80 00       	mov    0x805024,%al
  800702:	0f b6 c0             	movzbl %al,%eax
  800705:	8b 55 0c             	mov    0xc(%ebp),%edx
  800708:	8b 12                	mov    (%edx),%edx
  80070a:	89 d1                	mov    %edx,%ecx
  80070c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070f:	83 c2 08             	add    $0x8,%edx
  800712:	83 ec 04             	sub    $0x4,%esp
  800715:	50                   	push   %eax
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	e8 d8 11 00 00       	call   8018f5 <sys_cputs>
  80071d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	8b 40 04             	mov    0x4(%eax),%eax
  80072f:	8d 50 01             	lea    0x1(%eax),%edx
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 50 04             	mov    %edx,0x4(%eax)
}
  800738:	90                   	nop
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800744:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80074b:	00 00 00 
	b.cnt = 0;
  80074e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800755:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	ff 75 08             	pushl  0x8(%ebp)
  80075e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	68 d2 06 80 00       	push   $0x8006d2
  80076a:	e8 11 02 00 00       	call   800980 <vprintfmt>
  80076f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800772:	a0 24 50 80 00       	mov    0x805024,%al
  800777:	0f b6 c0             	movzbl %al,%eax
  80077a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800780:	83 ec 04             	sub    $0x4,%esp
  800783:	50                   	push   %eax
  800784:	52                   	push   %edx
  800785:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80078b:	83 c0 08             	add    $0x8,%eax
  80078e:	50                   	push   %eax
  80078f:	e8 61 11 00 00       	call   8018f5 <sys_cputs>
  800794:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800797:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80079e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007ac:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8007b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 73 ff ff ff       	call   80073b <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d9:	e8 c5 12 00 00       	call   801aa3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 48 ff ff ff       	call   80073b <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f9:	e8 bf 12 00 00       	call   801abd <sys_enable_interrupt>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 30 2d 00 00       	call   803578 <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 f0 2d 00 00       	call   803688 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 94 3c 80 00       	add    $0x803c94,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 af 03 00 00    	je     800d41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 55             	cmp    $0x55,%eax
  8009e8:	0f 87 2b 03 00 00    	ja     800d19 <vprintfmt+0x399>
  8009ee:	8b 04 85 b8 3c 80 00 	mov    0x803cb8(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 89 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d 00 3b 80 00 	mov    0x803b00(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 a5 3c 80 00       	push   $0x803ca5
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 5e 02 00 00       	call   800d49 <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 49 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 ae 3c 80 00       	push   $0x803cae
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 45 02 00 00       	call   800d49 <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 30 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be b1 3c 80 00       	mov    $0x803cb1,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 0c 03 00 00       	call   800e4b <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 66 01 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 bc 00 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 34                	jmp    800d3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 25                	push   $0x25
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	ff 4d 10             	decl   0x10(%ebp)
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x3b1>
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	48                   	dec    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 f3                	jne    800d2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	e9 47 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 16 fc ff ff       	call   800980 <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 40 08             	mov    0x8(%eax),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 10                	mov    (%eax),%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 40 04             	mov    0x4(%eax),%eax
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	73 12                	jae    800da3 <sprintputch+0x33>
		*b->buf++ = ch;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 48 01             	lea    0x1(%eax),%ecx
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 0a                	mov    %ecx,(%edx)
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	88 10                	mov    %dl,(%eax)
}
  800da3:	90                   	nop
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 d0                	add    %edx,%eax
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	74 06                	je     800dd3 <vsnprintf+0x2d>
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	7f 07                	jg     800dda <vsnprintf+0x34>
		return -E_INVAL;
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	eb 20                	jmp    800dfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dda:	ff 75 14             	pushl  0x14(%ebp)
  800ddd:	ff 75 10             	pushl  0x10(%ebp)
  800de0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 70 0d 80 00       	push   $0x800d70
  800de9:	e8 92 fb ff ff       	call   800980 <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 89 ff ff ff       	call   800da6 <vsnprintf>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 06                	jmp    800e3d <strlen+0x15>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 f1                	jne    800e37 <strlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 09                	jmp    800e63 <strnlen+0x18>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 4d 0c             	decl   0xc(%ebp)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 09                	je     800e72 <strnlen+0x27>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e8                	jne    800e5a <strnlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e83:	90                   	nop
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e96:	8a 12                	mov    (%edx),%dl
  800e98:	88 10                	mov    %dl,(%eax)
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e4                	jne    800e84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 1f                	jmp    800ed9 <strncpy+0x34>
		*dst++ = *src;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	74 03                	je     800ed6 <strncpy+0x31>
			src++;
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	72 d9                	jb     800eba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 30                	je     800f28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef8:	eb 16                	jmp    800f10 <strlcpy+0x2a>
			*dst++ = *src++;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 09                	je     800f22 <strlcpy+0x3c>
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 d8                	jne    800efa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0xb>
		p++, q++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 0e                	je     800f56 <strcmp+0x22>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 e3                	je     800f39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6f:	eb 09                	jmp    800f7a <strncmp+0xe>
		n--, p++, q++;
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 17                	je     800f97 <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 0e                	je     800f97 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 10                	mov    (%eax),%dl
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	38 c2                	cmp    %al,%dl
  800f95:	74 da                	je     800f71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strncmp+0x38>
		return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb 14                	jmp    800fb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc6:	eb 12                	jmp    800fda <strchr+0x20>
		if (*s == c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd0:	75 05                	jne    800fd7 <strchr+0x1d>
			return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	eb 11                	jmp    800fe8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e5                	jne    800fc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff6:	eb 0d                	jmp    801005 <strfind+0x1b>
		if (*s == c)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801000:	74 0e                	je     801010 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801002:	ff 45 08             	incl   0x8(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ea                	jne    800ff8 <strfind+0xe>
  80100e:	eb 01                	jmp    801011 <strfind+0x27>
		if (*s == c)
			break;
  801010:	90                   	nop
	return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801028:	eb 0e                	jmp    801038 <memset+0x22>
		*p++ = c;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801038:	ff 4d f8             	decl   -0x8(%ebp)
  80103b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80103f:	79 e9                	jns    80102a <memset+0x14>
		*p++ = c;

	return v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801058:	eb 16                	jmp    801070 <memcpy+0x2a>
		*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109a:	73 50                	jae    8010ec <memmove+0x6a>
  80109c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a7:	76 43                	jbe    8010ec <memmove+0x6a>
		s += n;
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b5:	eb 10                	jmp    8010c7 <memmove+0x45>
			*--d = *--s;
  8010b7:	ff 4d f8             	decl   -0x8(%ebp)
  8010ba:	ff 4d fc             	decl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	8a 10                	mov    (%eax),%dl
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	75 e3                	jne    8010b7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d4:	eb 23                	jmp    8010f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e8:	8a 12                	mov    (%edx),%dl
  8010ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	75 dd                	jne    8010d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801110:	eb 2a                	jmp    80113c <memcmp+0x3e>
		if (*s1 != *s2)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	8a 10                	mov    (%eax),%dl
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	38 c2                	cmp    %al,%dl
  80111e:	74 16                	je     801136 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	0f b6 c0             	movzbl %al,%eax
  801130:	29 c2                	sub    %eax,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	eb 18                	jmp    80114e <memcmp+0x50>
		s1++, s2++;
  801136:	ff 45 fc             	incl   -0x4(%ebp)
  801139:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 c9                	jne    801112 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801161:	eb 15                	jmp    801178 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	39 c2                	cmp    %eax,%edx
  801173:	74 0d                	je     801182 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801175:	ff 45 08             	incl   0x8(%ebp)
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117e:	72 e3                	jb     801163 <memfind+0x13>
  801180:	eb 01                	jmp    801183 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801182:	90                   	nop
	return (void *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119c:	eb 03                	jmp    8011a1 <strtol+0x19>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 20                	cmp    $0x20,%al
  8011a8:	74 f4                	je     80119e <strtol+0x16>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 09                	cmp    $0x9,%al
  8011b1:	74 eb                	je     80119e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 2b                	cmp    $0x2b,%al
  8011ba:	75 05                	jne    8011c1 <strtol+0x39>
		s++;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	eb 13                	jmp    8011d4 <strtol+0x4c>
	else if (*s == '-')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 2d                	cmp    $0x2d,%al
  8011c8:	75 0a                	jne    8011d4 <strtol+0x4c>
		s++, neg = 1;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d8:	74 06                	je     8011e0 <strtol+0x58>
  8011da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011de:	75 20                	jne    801200 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 30                	cmp    $0x30,%al
  8011e7:	75 17                	jne    801200 <strtol+0x78>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	40                   	inc    %eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 78                	cmp    $0x78,%al
  8011f1:	75 0d                	jne    801200 <strtol+0x78>
		s += 2, base = 16;
  8011f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fe:	eb 28                	jmp    801228 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	75 15                	jne    80121b <strtol+0x93>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 0c                	jne    80121b <strtol+0x93>
		s++, base = 8;
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801219:	eb 0d                	jmp    801228 <strtol+0xa0>
	else if (base == 0)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	75 07                	jne    801228 <strtol+0xa0>
		base = 10;
  801221:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 2f                	cmp    $0x2f,%al
  80122f:	7e 19                	jle    80124a <strtol+0xc2>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 39                	cmp    $0x39,%al
  801238:	7f 10                	jg     80124a <strtol+0xc2>
			dig = *s - '0';
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	83 e8 30             	sub    $0x30,%eax
  801245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801248:	eb 42                	jmp    80128c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 60                	cmp    $0x60,%al
  801251:	7e 19                	jle    80126c <strtol+0xe4>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 7a                	cmp    $0x7a,%al
  80125a:	7f 10                	jg     80126c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	0f be c0             	movsbl %al,%eax
  801264:	83 e8 57             	sub    $0x57,%eax
  801267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126a:	eb 20                	jmp    80128c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 40                	cmp    $0x40,%al
  801273:	7e 39                	jle    8012ae <strtol+0x126>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 30                	jg     8012ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	83 e8 37             	sub    $0x37,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801292:	7d 19                	jge    8012ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a8:	e9 7b ff ff ff       	jmp    801228 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b2:	74 08                	je     8012bc <strtol+0x134>
		*endptr = (char *) s;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c0:	74 07                	je     8012c9 <strtol+0x141>
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	f7 d8                	neg    %eax
  8012c7:	eb 03                	jmp    8012cc <strtol+0x144>
  8012c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <ltostr>:

void
ltostr(long value, char *str)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e6:	79 13                	jns    8012fb <ltostr+0x2d>
	{
		neg = 1;
  8012e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801303:	99                   	cltd   
  801304:	f7 f9                	idiv   %ecx
  801306:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80131c:	83 c2 30             	add    $0x30,%edx
  80131f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801324:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801329:	f7 e9                	imul   %ecx
  80132b:	c1 fa 02             	sar    $0x2,%edx
  80132e:	89 c8                	mov    %ecx,%eax
  801330:	c1 f8 1f             	sar    $0x1f,%eax
  801333:	29 c2                	sub    %eax,%edx
  801335:	89 d0                	mov    %edx,%eax
  801337:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80133a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801342:	f7 e9                	imul   %ecx
  801344:	c1 fa 02             	sar    $0x2,%edx
  801347:	89 c8                	mov    %ecx,%eax
  801349:	c1 f8 1f             	sar    $0x1f,%eax
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	c1 e0 02             	shl    $0x2,%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	01 c0                	add    %eax,%eax
  801357:	29 c1                	sub    %eax,%ecx
  801359:	89 ca                	mov    %ecx,%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	75 9c                	jne    8012fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xe2>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 54 fa ff ff       	call   800e28 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 46 fa ff ff       	call   800e28 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 13 fb ff ff       	call   800fba <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 b5 fa ff ff       	call   800fba <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801536:	a1 04 50 80 00       	mov    0x805004,%eax
  80153b:	85 c0                	test   %eax,%eax
  80153d:	74 1f                	je     80155e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80153f:	e8 1d 00 00 00       	call   801561 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	68 10 3e 80 00       	push   $0x803e10
  80154c:	e8 55 f2 ff ff       	call   8007a6 <cprintf>
  801551:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801554:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80155b:	00 00 00 
	}
}
  80155e:	90                   	nop
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801567:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80156e:	00 00 00 
  801571:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801578:	00 00 00 
  80157b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801582:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801585:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80158c:	00 00 00 
  80158f:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801596:	00 00 00 
  801599:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8015a0:	00 00 00 
	uint32 arr_size = 0;
  8015a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8015aa:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8015b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015b9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015be:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8015c3:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8015ca:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8015cd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8015d4:	a1 20 51 80 00       	mov    0x805120,%eax
  8015d9:	c1 e0 04             	shl    $0x4,%eax
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	48                   	dec    %eax
  8015e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ef:	f7 75 ec             	divl   -0x14(%ebp)
  8015f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f5:	29 d0                	sub    %edx,%eax
  8015f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8015fa:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801604:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801609:	2d 00 10 00 00       	sub    $0x1000,%eax
  80160e:	83 ec 04             	sub    $0x4,%esp
  801611:	6a 06                	push   $0x6
  801613:	ff 75 f4             	pushl  -0xc(%ebp)
  801616:	50                   	push   %eax
  801617:	e8 1d 04 00 00       	call   801a39 <sys_allocate_chunk>
  80161c:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80161f:	a1 20 51 80 00       	mov    0x805120,%eax
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	50                   	push   %eax
  801628:	e8 92 0a 00 00       	call   8020bf <initialize_MemBlocksList>
  80162d:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801630:	a1 48 51 80 00       	mov    0x805148,%eax
  801635:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801638:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801645:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  80164c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801650:	75 14                	jne    801666 <initialize_dyn_block_system+0x105>
  801652:	83 ec 04             	sub    $0x4,%esp
  801655:	68 35 3e 80 00       	push   $0x803e35
  80165a:	6a 33                	push   $0x33
  80165c:	68 53 3e 80 00       	push   $0x803e53
  801661:	e8 8c ee ff ff       	call   8004f2 <_panic>
  801666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801669:	8b 00                	mov    (%eax),%eax
  80166b:	85 c0                	test   %eax,%eax
  80166d:	74 10                	je     80167f <initialize_dyn_block_system+0x11e>
  80166f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801672:	8b 00                	mov    (%eax),%eax
  801674:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801677:	8b 52 04             	mov    0x4(%edx),%edx
  80167a:	89 50 04             	mov    %edx,0x4(%eax)
  80167d:	eb 0b                	jmp    80168a <initialize_dyn_block_system+0x129>
  80167f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801682:	8b 40 04             	mov    0x4(%eax),%eax
  801685:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80168a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80168d:	8b 40 04             	mov    0x4(%eax),%eax
  801690:	85 c0                	test   %eax,%eax
  801692:	74 0f                	je     8016a3 <initialize_dyn_block_system+0x142>
  801694:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801697:	8b 40 04             	mov    0x4(%eax),%eax
  80169a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80169d:	8b 12                	mov    (%edx),%edx
  80169f:	89 10                	mov    %edx,(%eax)
  8016a1:	eb 0a                	jmp    8016ad <initialize_dyn_block_system+0x14c>
  8016a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a6:	8b 00                	mov    (%eax),%eax
  8016a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8016ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8016c5:	48                   	dec    %eax
  8016c6:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8016cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016cf:	75 14                	jne    8016e5 <initialize_dyn_block_system+0x184>
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	68 60 3e 80 00       	push   $0x803e60
  8016d9:	6a 34                	push   $0x34
  8016db:	68 53 3e 80 00       	push   $0x803e53
  8016e0:	e8 0d ee ff ff       	call   8004f2 <_panic>
  8016e5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8016eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ee:	89 10                	mov    %edx,(%eax)
  8016f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f3:	8b 00                	mov    (%eax),%eax
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	74 0d                	je     801706 <initialize_dyn_block_system+0x1a5>
  8016f9:	a1 38 51 80 00       	mov    0x805138,%eax
  8016fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801701:	89 50 04             	mov    %edx,0x4(%eax)
  801704:	eb 08                	jmp    80170e <initialize_dyn_block_system+0x1ad>
  801706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801709:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80170e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801711:	a3 38 51 80 00       	mov    %eax,0x805138
  801716:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801719:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801720:	a1 44 51 80 00       	mov    0x805144,%eax
  801725:	40                   	inc    %eax
  801726:	a3 44 51 80 00       	mov    %eax,0x805144
}
  80172b:	90                   	nop
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801734:	e8 f7 fd ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  801739:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80173d:	75 07                	jne    801746 <malloc+0x18>
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
  801744:	eb 14                	jmp    80175a <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 84 3e 80 00       	push   $0x803e84
  80174e:	6a 46                	push   $0x46
  801750:	68 53 3e 80 00       	push   $0x803e53
  801755:	e8 98 ed ff ff       	call   8004f2 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	68 ac 3e 80 00       	push   $0x803eac
  80176a:	6a 61                	push   $0x61
  80176c:	68 53 3e 80 00       	push   $0x803e53
  801771:	e8 7c ed ff ff       	call   8004f2 <_panic>

00801776 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 38             	sub    $0x38,%esp
  80177c:	8b 45 10             	mov    0x10(%ebp),%eax
  80177f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801782:	e8 a9 fd ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  801787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178b:	75 07                	jne    801794 <smalloc+0x1e>
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	eb 7c                	jmp    801810 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801794:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80179b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	48                   	dec    %eax
  8017a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017af:	f7 75 f0             	divl   -0x10(%ebp)
  8017b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b5:	29 d0                	sub    %edx,%eax
  8017b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017c1:	e8 41 06 00 00       	call   801e07 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	74 11                	je     8017db <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8017ca:	83 ec 0c             	sub    $0xc,%esp
  8017cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d0:	e8 ac 0c 00 00       	call   802481 <alloc_block_FF>
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8017db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017df:	74 2a                	je     80180b <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e4:	8b 40 08             	mov    0x8(%eax),%eax
  8017e7:	89 c2                	mov    %eax,%edx
  8017e9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017ed:	52                   	push   %edx
  8017ee:	50                   	push   %eax
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	e8 92 03 00 00       	call   801b8c <sys_createSharedObject>
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801800:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801804:	74 05                	je     80180b <smalloc+0x95>
			return (void*)virtual_address;
  801806:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801809:	eb 05                	jmp    801810 <smalloc+0x9a>
	}
	return NULL;
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801818:	e8 13 fd ff ff       	call   801530 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	68 d0 3e 80 00       	push   $0x803ed0
  801825:	68 a2 00 00 00       	push   $0xa2
  80182a:	68 53 3e 80 00       	push   $0x803e53
  80182f:	e8 be ec ff ff       	call   8004f2 <_panic>

00801834 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80183a:	e8 f1 fc ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80183f:	83 ec 04             	sub    $0x4,%esp
  801842:	68 f4 3e 80 00       	push   $0x803ef4
  801847:	68 e6 00 00 00       	push   $0xe6
  80184c:	68 53 3e 80 00       	push   $0x803e53
  801851:	e8 9c ec ff ff       	call   8004f2 <_panic>

00801856 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	68 1c 3f 80 00       	push   $0x803f1c
  801864:	68 fa 00 00 00       	push   $0xfa
  801869:	68 53 3e 80 00       	push   $0x803e53
  80186e:	e8 7f ec ff ff       	call   8004f2 <_panic>

00801873 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801879:	83 ec 04             	sub    $0x4,%esp
  80187c:	68 40 3f 80 00       	push   $0x803f40
  801881:	68 05 01 00 00       	push   $0x105
  801886:	68 53 3e 80 00       	push   $0x803e53
  80188b:	e8 62 ec ff ff       	call   8004f2 <_panic>

00801890 <shrink>:

}
void shrink(uint32 newSize)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801896:	83 ec 04             	sub    $0x4,%esp
  801899:	68 40 3f 80 00       	push   $0x803f40
  80189e:	68 0a 01 00 00       	push   $0x10a
  8018a3:	68 53 3e 80 00       	push   $0x803e53
  8018a8:	e8 45 ec ff ff       	call   8004f2 <_panic>

008018ad <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b3:	83 ec 04             	sub    $0x4,%esp
  8018b6:	68 40 3f 80 00       	push   $0x803f40
  8018bb:	68 0f 01 00 00       	push   $0x10f
  8018c0:	68 53 3e 80 00       	push   $0x803e53
  8018c5:	e8 28 ec ff ff       	call   8004f2 <_panic>

008018ca <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	57                   	push   %edi
  8018ce:	56                   	push   %esi
  8018cf:	53                   	push   %ebx
  8018d0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018df:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018e2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018e5:	cd 30                	int    $0x30
  8018e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	5b                   	pop    %ebx
  8018f1:	5e                   	pop    %esi
  8018f2:	5f                   	pop    %edi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    

008018f5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801901:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	52                   	push   %edx
  80190d:	ff 75 0c             	pushl  0xc(%ebp)
  801910:	50                   	push   %eax
  801911:	6a 00                	push   $0x0
  801913:	e8 b2 ff ff ff       	call   8018ca <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	90                   	nop
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_cgetc>:

int
sys_cgetc(void)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 01                	push   $0x1
  80192d:	e8 98 ff ff ff       	call   8018ca <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80193a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	52                   	push   %edx
  801947:	50                   	push   %eax
  801948:	6a 05                	push   $0x5
  80194a:	e8 7b ff ff ff       	call   8018ca <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	56                   	push   %esi
  801958:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801959:	8b 75 18             	mov    0x18(%ebp),%esi
  80195c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80195f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801962:	8b 55 0c             	mov    0xc(%ebp),%edx
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	56                   	push   %esi
  801969:	53                   	push   %ebx
  80196a:	51                   	push   %ecx
  80196b:	52                   	push   %edx
  80196c:	50                   	push   %eax
  80196d:	6a 06                	push   $0x6
  80196f:	e8 56 ff ff ff       	call   8018ca <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197a:	5b                   	pop    %ebx
  80197b:	5e                   	pop    %esi
  80197c:	5d                   	pop    %ebp
  80197d:	c3                   	ret    

0080197e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801981:	8b 55 0c             	mov    0xc(%ebp),%edx
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	52                   	push   %edx
  80198e:	50                   	push   %eax
  80198f:	6a 07                	push   $0x7
  801991:	e8 34 ff ff ff       	call   8018ca <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	6a 08                	push   $0x8
  8019ac:	e8 19 ff ff ff       	call   8018ca <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 09                	push   $0x9
  8019c5:	e8 00 ff ff ff       	call   8018ca <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 0a                	push   $0xa
  8019de:	e8 e7 fe ff ff       	call   8018ca <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 0b                	push   $0xb
  8019f7:	e8 ce fe ff ff       	call   8018ca <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	ff 75 08             	pushl  0x8(%ebp)
  801a10:	6a 0f                	push   $0xf
  801a12:	e8 b3 fe ff ff       	call   8018ca <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
	return;
  801a1a:	90                   	nop
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	ff 75 08             	pushl  0x8(%ebp)
  801a2c:	6a 10                	push   $0x10
  801a2e:	e8 97 fe ff ff       	call   8018ca <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
	return ;
  801a36:	90                   	nop
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	ff 75 10             	pushl  0x10(%ebp)
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	ff 75 08             	pushl  0x8(%ebp)
  801a49:	6a 11                	push   $0x11
  801a4b:	e8 7a fe ff ff       	call   8018ca <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
	return ;
  801a53:	90                   	nop
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 0c                	push   $0xc
  801a65:	e8 60 fe ff ff       	call   8018ca <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	ff 75 08             	pushl  0x8(%ebp)
  801a7d:	6a 0d                	push   $0xd
  801a7f:	e8 46 fe ff ff       	call   8018ca <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 0e                	push   $0xe
  801a98:	e8 2d fe ff ff       	call   8018ca <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	90                   	nop
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 13                	push   $0x13
  801ab2:	e8 13 fe ff ff       	call   8018ca <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	90                   	nop
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 14                	push   $0x14
  801acc:	e8 f9 fd ff ff       	call   8018ca <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	90                   	nop
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 04             	sub    $0x4,%esp
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ae3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	50                   	push   %eax
  801af0:	6a 15                	push   $0x15
  801af2:	e8 d3 fd ff ff       	call   8018ca <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	90                   	nop
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 16                	push   $0x16
  801b0c:	e8 b9 fd ff ff       	call   8018ca <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	90                   	nop
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	50                   	push   %eax
  801b27:	6a 17                	push   $0x17
  801b29:	e8 9c fd ff ff       	call   8018ca <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	52                   	push   %edx
  801b43:	50                   	push   %eax
  801b44:	6a 1a                	push   $0x1a
  801b46:	e8 7f fd ff ff       	call   8018ca <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	52                   	push   %edx
  801b60:	50                   	push   %eax
  801b61:	6a 18                	push   $0x18
  801b63:	e8 62 fd ff ff       	call   8018ca <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	90                   	nop
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	52                   	push   %edx
  801b7e:	50                   	push   %eax
  801b7f:	6a 19                	push   $0x19
  801b81:	e8 44 fd ff ff       	call   8018ca <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	90                   	nop
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 04             	sub    $0x4,%esp
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b98:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b9b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	51                   	push   %ecx
  801ba5:	52                   	push   %edx
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	50                   	push   %eax
  801baa:	6a 1b                	push   $0x1b
  801bac:	e8 19 fd ff ff       	call   8018ca <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	52                   	push   %edx
  801bc6:	50                   	push   %eax
  801bc7:	6a 1c                	push   $0x1c
  801bc9:	e8 fc fc ff ff       	call   8018ca <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	51                   	push   %ecx
  801be4:	52                   	push   %edx
  801be5:	50                   	push   %eax
  801be6:	6a 1d                	push   $0x1d
  801be8:	e8 dd fc ff ff       	call   8018ca <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	52                   	push   %edx
  801c02:	50                   	push   %eax
  801c03:	6a 1e                	push   $0x1e
  801c05:	e8 c0 fc ff ff       	call   8018ca <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 1f                	push   $0x1f
  801c1e:	e8 a7 fc ff ff       	call   8018ca <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	6a 00                	push   $0x0
  801c30:	ff 75 14             	pushl  0x14(%ebp)
  801c33:	ff 75 10             	pushl  0x10(%ebp)
  801c36:	ff 75 0c             	pushl  0xc(%ebp)
  801c39:	50                   	push   %eax
  801c3a:	6a 20                	push   $0x20
  801c3c:	e8 89 fc ff ff       	call   8018ca <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	50                   	push   %eax
  801c55:	6a 21                	push   $0x21
  801c57:	e8 6e fc ff ff       	call   8018ca <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	90                   	nop
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	50                   	push   %eax
  801c71:	6a 22                	push   $0x22
  801c73:	e8 52 fc ff ff       	call   8018ca <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 02                	push   $0x2
  801c8c:	e8 39 fc ff ff       	call   8018ca <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 03                	push   $0x3
  801ca5:	e8 20 fc ff ff       	call   8018ca <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 04                	push   $0x4
  801cbe:	e8 07 fc ff ff       	call   8018ca <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_exit_env>:


void sys_exit_env(void)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 23                	push   $0x23
  801cd7:	e8 ee fb ff ff       	call   8018ca <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	90                   	nop
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ce8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ceb:	8d 50 04             	lea    0x4(%eax),%edx
  801cee:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	52                   	push   %edx
  801cf8:	50                   	push   %eax
  801cf9:	6a 24                	push   $0x24
  801cfb:	e8 ca fb ff ff       	call   8018ca <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
	return result;
  801d03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d09:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d0c:	89 01                	mov    %eax,(%ecx)
  801d0e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	c9                   	leave  
  801d15:	c2 04 00             	ret    $0x4

00801d18 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	ff 75 10             	pushl  0x10(%ebp)
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	ff 75 08             	pushl  0x8(%ebp)
  801d28:	6a 12                	push   $0x12
  801d2a:	e8 9b fb ff ff       	call   8018ca <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d32:	90                   	nop
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 25                	push   $0x25
  801d44:	e8 81 fb ff ff       	call   8018ca <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d5a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	50                   	push   %eax
  801d67:	6a 26                	push   $0x26
  801d69:	e8 5c fb ff ff       	call   8018ca <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d71:	90                   	nop
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <rsttst>:
void rsttst()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 28                	push   $0x28
  801d83:	e8 42 fb ff ff       	call   8018ca <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8b:	90                   	nop
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 04             	sub    $0x4,%esp
  801d94:	8b 45 14             	mov    0x14(%ebp),%eax
  801d97:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d9a:	8b 55 18             	mov    0x18(%ebp),%edx
  801d9d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da1:	52                   	push   %edx
  801da2:	50                   	push   %eax
  801da3:	ff 75 10             	pushl  0x10(%ebp)
  801da6:	ff 75 0c             	pushl  0xc(%ebp)
  801da9:	ff 75 08             	pushl  0x8(%ebp)
  801dac:	6a 27                	push   $0x27
  801dae:	e8 17 fb ff ff       	call   8018ca <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
	return ;
  801db6:	90                   	nop
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <chktst>:
void chktst(uint32 n)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	ff 75 08             	pushl  0x8(%ebp)
  801dc7:	6a 29                	push   $0x29
  801dc9:	e8 fc fa ff ff       	call   8018ca <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd1:	90                   	nop
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <inctst>:

void inctst()
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 2a                	push   $0x2a
  801de3:	e8 e2 fa ff ff       	call   8018ca <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
	return ;
  801deb:	90                   	nop
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <gettst>:
uint32 gettst()
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 2b                	push   $0x2b
  801dfd:	e8 c8 fa ff ff       	call   8018ca <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 2c                	push   $0x2c
  801e19:	e8 ac fa ff ff       	call   8018ca <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
  801e21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e24:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e28:	75 07                	jne    801e31 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2f:	eb 05                	jmp    801e36 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 2c                	push   $0x2c
  801e4a:	e8 7b fa ff ff       	call   8018ca <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
  801e52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e55:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e59:	75 07                	jne    801e62 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e60:	eb 05                	jmp    801e67 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 2c                	push   $0x2c
  801e7b:	e8 4a fa ff ff       	call   8018ca <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
  801e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e86:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e8a:	75 07                	jne    801e93 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e91:	eb 05                	jmp    801e98 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 2c                	push   $0x2c
  801eac:	e8 19 fa ff ff       	call   8018ca <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
  801eb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eb7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ebb:	75 07                	jne    801ec4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ebd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec2:	eb 05                	jmp    801ec9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	ff 75 08             	pushl  0x8(%ebp)
  801ed9:	6a 2d                	push   $0x2d
  801edb:	e8 ea f9 ff ff       	call   8018ca <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee3:	90                   	nop
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	6a 00                	push   $0x0
  801ef8:	53                   	push   %ebx
  801ef9:	51                   	push   %ecx
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	6a 2e                	push   $0x2e
  801efe:	e8 c7 f9 ff ff       	call   8018ca <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	52                   	push   %edx
  801f1b:	50                   	push   %eax
  801f1c:	6a 2f                	push   $0x2f
  801f1e:	e8 a7 f9 ff ff       	call   8018ca <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f2e:	83 ec 0c             	sub    $0xc,%esp
  801f31:	68 50 3f 80 00       	push   $0x803f50
  801f36:	e8 6b e8 ff ff       	call   8007a6 <cprintf>
  801f3b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f3e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f45:	83 ec 0c             	sub    $0xc,%esp
  801f48:	68 7c 3f 80 00       	push   $0x803f7c
  801f4d:	e8 54 e8 ff ff       	call   8007a6 <cprintf>
  801f52:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f55:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f59:	a1 38 51 80 00       	mov    0x805138,%eax
  801f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f61:	eb 56                	jmp    801fb9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f67:	74 1c                	je     801f85 <print_mem_block_lists+0x5d>
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	8b 50 08             	mov    0x8(%eax),%edx
  801f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f72:	8b 48 08             	mov    0x8(%eax),%ecx
  801f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f78:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7b:	01 c8                	add    %ecx,%eax
  801f7d:	39 c2                	cmp    %eax,%edx
  801f7f:	73 04                	jae    801f85 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f81:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 50 08             	mov    0x8(%eax),%edx
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f91:	01 c2                	add    %eax,%edx
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	8b 40 08             	mov    0x8(%eax),%eax
  801f99:	83 ec 04             	sub    $0x4,%esp
  801f9c:	52                   	push   %edx
  801f9d:	50                   	push   %eax
  801f9e:	68 91 3f 80 00       	push   $0x803f91
  801fa3:	e8 fe e7 ff ff       	call   8007a6 <cprintf>
  801fa8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fb1:	a1 40 51 80 00       	mov    0x805140,%eax
  801fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbd:	74 07                	je     801fc6 <print_mem_block_lists+0x9e>
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	8b 00                	mov    (%eax),%eax
  801fc4:	eb 05                	jmp    801fcb <print_mem_block_lists+0xa3>
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcb:	a3 40 51 80 00       	mov    %eax,0x805140
  801fd0:	a1 40 51 80 00       	mov    0x805140,%eax
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	75 8a                	jne    801f63 <print_mem_block_lists+0x3b>
  801fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fdd:	75 84                	jne    801f63 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fdf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fe3:	75 10                	jne    801ff5 <print_mem_block_lists+0xcd>
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	68 a0 3f 80 00       	push   $0x803fa0
  801fed:	e8 b4 e7 ff ff       	call   8007a6 <cprintf>
  801ff2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ff5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ffc:	83 ec 0c             	sub    $0xc,%esp
  801fff:	68 c4 3f 80 00       	push   $0x803fc4
  802004:	e8 9d e7 ff ff       	call   8007a6 <cprintf>
  802009:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80200c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802010:	a1 40 50 80 00       	mov    0x805040,%eax
  802015:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802018:	eb 56                	jmp    802070 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80201a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80201e:	74 1c                	je     80203c <print_mem_block_lists+0x114>
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	8b 50 08             	mov    0x8(%eax),%edx
  802026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802029:	8b 48 08             	mov    0x8(%eax),%ecx
  80202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202f:	8b 40 0c             	mov    0xc(%eax),%eax
  802032:	01 c8                	add    %ecx,%eax
  802034:	39 c2                	cmp    %eax,%edx
  802036:	73 04                	jae    80203c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802038:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203f:	8b 50 08             	mov    0x8(%eax),%edx
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	8b 40 0c             	mov    0xc(%eax),%eax
  802048:	01 c2                	add    %eax,%edx
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	8b 40 08             	mov    0x8(%eax),%eax
  802050:	83 ec 04             	sub    $0x4,%esp
  802053:	52                   	push   %edx
  802054:	50                   	push   %eax
  802055:	68 91 3f 80 00       	push   $0x803f91
  80205a:	e8 47 e7 ff ff       	call   8007a6 <cprintf>
  80205f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802065:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802068:	a1 48 50 80 00       	mov    0x805048,%eax
  80206d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802074:	74 07                	je     80207d <print_mem_block_lists+0x155>
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	8b 00                	mov    (%eax),%eax
  80207b:	eb 05                	jmp    802082 <print_mem_block_lists+0x15a>
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
  802082:	a3 48 50 80 00       	mov    %eax,0x805048
  802087:	a1 48 50 80 00       	mov    0x805048,%eax
  80208c:	85 c0                	test   %eax,%eax
  80208e:	75 8a                	jne    80201a <print_mem_block_lists+0xf2>
  802090:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802094:	75 84                	jne    80201a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802096:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80209a:	75 10                	jne    8020ac <print_mem_block_lists+0x184>
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	68 dc 3f 80 00       	push   $0x803fdc
  8020a4:	e8 fd e6 ff ff       	call   8007a6 <cprintf>
  8020a9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020ac:	83 ec 0c             	sub    $0xc,%esp
  8020af:	68 50 3f 80 00       	push   $0x803f50
  8020b4:	e8 ed e6 ff ff       	call   8007a6 <cprintf>
  8020b9:	83 c4 10             	add    $0x10,%esp

}
  8020bc:	90                   	nop
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020c5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020cc:	00 00 00 
  8020cf:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020d6:	00 00 00 
  8020d9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020e0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020ea:	e9 9e 00 00 00       	jmp    80218d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020ef:	a1 50 50 80 00       	mov    0x805050,%eax
  8020f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f7:	c1 e2 04             	shl    $0x4,%edx
  8020fa:	01 d0                	add    %edx,%eax
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	75 14                	jne    802114 <initialize_MemBlocksList+0x55>
  802100:	83 ec 04             	sub    $0x4,%esp
  802103:	68 04 40 80 00       	push   $0x804004
  802108:	6a 46                	push   $0x46
  80210a:	68 27 40 80 00       	push   $0x804027
  80210f:	e8 de e3 ff ff       	call   8004f2 <_panic>
  802114:	a1 50 50 80 00       	mov    0x805050,%eax
  802119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211c:	c1 e2 04             	shl    $0x4,%edx
  80211f:	01 d0                	add    %edx,%eax
  802121:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802127:	89 10                	mov    %edx,(%eax)
  802129:	8b 00                	mov    (%eax),%eax
  80212b:	85 c0                	test   %eax,%eax
  80212d:	74 18                	je     802147 <initialize_MemBlocksList+0x88>
  80212f:	a1 48 51 80 00       	mov    0x805148,%eax
  802134:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80213a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80213d:	c1 e1 04             	shl    $0x4,%ecx
  802140:	01 ca                	add    %ecx,%edx
  802142:	89 50 04             	mov    %edx,0x4(%eax)
  802145:	eb 12                	jmp    802159 <initialize_MemBlocksList+0x9a>
  802147:	a1 50 50 80 00       	mov    0x805050,%eax
  80214c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214f:	c1 e2 04             	shl    $0x4,%edx
  802152:	01 d0                	add    %edx,%eax
  802154:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802159:	a1 50 50 80 00       	mov    0x805050,%eax
  80215e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802161:	c1 e2 04             	shl    $0x4,%edx
  802164:	01 d0                	add    %edx,%eax
  802166:	a3 48 51 80 00       	mov    %eax,0x805148
  80216b:	a1 50 50 80 00       	mov    0x805050,%eax
  802170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802173:	c1 e2 04             	shl    $0x4,%edx
  802176:	01 d0                	add    %edx,%eax
  802178:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80217f:	a1 54 51 80 00       	mov    0x805154,%eax
  802184:	40                   	inc    %eax
  802185:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80218a:	ff 45 f4             	incl   -0xc(%ebp)
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	3b 45 08             	cmp    0x8(%ebp),%eax
  802193:	0f 82 56 ff ff ff    	jb     8020ef <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802199:	90                   	nop
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	8b 00                	mov    (%eax),%eax
  8021a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021aa:	eb 19                	jmp    8021c5 <find_block+0x29>
	{
		if(va==point->sva)
  8021ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021af:	8b 40 08             	mov    0x8(%eax),%eax
  8021b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021b5:	75 05                	jne    8021bc <find_block+0x20>
		   return point;
  8021b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ba:	eb 36                	jmp    8021f2 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	8b 40 08             	mov    0x8(%eax),%eax
  8021c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021c9:	74 07                	je     8021d2 <find_block+0x36>
  8021cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ce:	8b 00                	mov    (%eax),%eax
  8021d0:	eb 05                	jmp    8021d7 <find_block+0x3b>
  8021d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021da:	89 42 08             	mov    %eax,0x8(%edx)
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	8b 40 08             	mov    0x8(%eax),%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	75 c5                	jne    8021ac <find_block+0x10>
  8021e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021eb:	75 bf                	jne    8021ac <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8021ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802202:	a1 44 50 80 00       	mov    0x805044,%eax
  802207:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80220a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802210:	74 24                	je     802236 <insert_sorted_allocList+0x42>
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	8b 50 08             	mov    0x8(%eax),%edx
  802218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221b:	8b 40 08             	mov    0x8(%eax),%eax
  80221e:	39 c2                	cmp    %eax,%edx
  802220:	76 14                	jbe    802236 <insert_sorted_allocList+0x42>
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	8b 50 08             	mov    0x8(%eax),%edx
  802228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222b:	8b 40 08             	mov    0x8(%eax),%eax
  80222e:	39 c2                	cmp    %eax,%edx
  802230:	0f 82 60 01 00 00    	jb     802396 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802236:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80223a:	75 65                	jne    8022a1 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80223c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802240:	75 14                	jne    802256 <insert_sorted_allocList+0x62>
  802242:	83 ec 04             	sub    $0x4,%esp
  802245:	68 04 40 80 00       	push   $0x804004
  80224a:	6a 6b                	push   $0x6b
  80224c:	68 27 40 80 00       	push   $0x804027
  802251:	e8 9c e2 ff ff       	call   8004f2 <_panic>
  802256:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	89 10                	mov    %edx,(%eax)
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	8b 00                	mov    (%eax),%eax
  802266:	85 c0                	test   %eax,%eax
  802268:	74 0d                	je     802277 <insert_sorted_allocList+0x83>
  80226a:	a1 40 50 80 00       	mov    0x805040,%eax
  80226f:	8b 55 08             	mov    0x8(%ebp),%edx
  802272:	89 50 04             	mov    %edx,0x4(%eax)
  802275:	eb 08                	jmp    80227f <insert_sorted_allocList+0x8b>
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	a3 44 50 80 00       	mov    %eax,0x805044
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	a3 40 50 80 00       	mov    %eax,0x805040
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802291:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802296:	40                   	inc    %eax
  802297:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80229c:	e9 dc 01 00 00       	jmp    80247d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8b 50 08             	mov    0x8(%eax),%edx
  8022a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022aa:	8b 40 08             	mov    0x8(%eax),%eax
  8022ad:	39 c2                	cmp    %eax,%edx
  8022af:	77 6c                	ja     80231d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b5:	74 06                	je     8022bd <insert_sorted_allocList+0xc9>
  8022b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022bb:	75 14                	jne    8022d1 <insert_sorted_allocList+0xdd>
  8022bd:	83 ec 04             	sub    $0x4,%esp
  8022c0:	68 40 40 80 00       	push   $0x804040
  8022c5:	6a 6f                	push   $0x6f
  8022c7:	68 27 40 80 00       	push   $0x804027
  8022cc:	e8 21 e2 ff ff       	call   8004f2 <_panic>
  8022d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d4:	8b 50 04             	mov    0x4(%eax),%edx
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	89 50 04             	mov    %edx,0x4(%eax)
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e3:	89 10                	mov    %edx,(%eax)
  8022e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e8:	8b 40 04             	mov    0x4(%eax),%eax
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	74 0d                	je     8022fc <insert_sorted_allocList+0x108>
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f2:	8b 40 04             	mov    0x4(%eax),%eax
  8022f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f8:	89 10                	mov    %edx,(%eax)
  8022fa:	eb 08                	jmp    802304 <insert_sorted_allocList+0x110>
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	a3 40 50 80 00       	mov    %eax,0x805040
  802304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802307:	8b 55 08             	mov    0x8(%ebp),%edx
  80230a:	89 50 04             	mov    %edx,0x4(%eax)
  80230d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802312:	40                   	inc    %eax
  802313:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802318:	e9 60 01 00 00       	jmp    80247d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	8b 50 08             	mov    0x8(%eax),%edx
  802323:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802326:	8b 40 08             	mov    0x8(%eax),%eax
  802329:	39 c2                	cmp    %eax,%edx
  80232b:	0f 82 4c 01 00 00    	jb     80247d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802331:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802335:	75 14                	jne    80234b <insert_sorted_allocList+0x157>
  802337:	83 ec 04             	sub    $0x4,%esp
  80233a:	68 78 40 80 00       	push   $0x804078
  80233f:	6a 73                	push   $0x73
  802341:	68 27 40 80 00       	push   $0x804027
  802346:	e8 a7 e1 ff ff       	call   8004f2 <_panic>
  80234b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	89 50 04             	mov    %edx,0x4(%eax)
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	74 0c                	je     80236d <insert_sorted_allocList+0x179>
  802361:	a1 44 50 80 00       	mov    0x805044,%eax
  802366:	8b 55 08             	mov    0x8(%ebp),%edx
  802369:	89 10                	mov    %edx,(%eax)
  80236b:	eb 08                	jmp    802375 <insert_sorted_allocList+0x181>
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	a3 40 50 80 00       	mov    %eax,0x805040
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	a3 44 50 80 00       	mov    %eax,0x805044
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802386:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80238b:	40                   	inc    %eax
  80238c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802391:	e9 e7 00 00 00       	jmp    80247d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802399:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80239c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023a3:	a1 40 50 80 00       	mov    0x805040,%eax
  8023a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ab:	e9 9d 00 00 00       	jmp    80244d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8b 50 08             	mov    0x8(%eax),%edx
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	8b 40 08             	mov    0x8(%eax),%eax
  8023c4:	39 c2                	cmp    %eax,%edx
  8023c6:	76 7d                	jbe    802445 <insert_sorted_allocList+0x251>
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	8b 50 08             	mov    0x8(%eax),%edx
  8023ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023d1:	8b 40 08             	mov    0x8(%eax),%eax
  8023d4:	39 c2                	cmp    %eax,%edx
  8023d6:	73 6d                	jae    802445 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023dc:	74 06                	je     8023e4 <insert_sorted_allocList+0x1f0>
  8023de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023e2:	75 14                	jne    8023f8 <insert_sorted_allocList+0x204>
  8023e4:	83 ec 04             	sub    $0x4,%esp
  8023e7:	68 9c 40 80 00       	push   $0x80409c
  8023ec:	6a 7f                	push   $0x7f
  8023ee:	68 27 40 80 00       	push   $0x804027
  8023f3:	e8 fa e0 ff ff       	call   8004f2 <_panic>
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	8b 10                	mov    (%eax),%edx
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	89 10                	mov    %edx,(%eax)
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 0b                	je     802416 <insert_sorted_allocList+0x222>
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	8b 55 08             	mov    0x8(%ebp),%edx
  802413:	89 50 04             	mov    %edx,0x4(%eax)
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 55 08             	mov    0x8(%ebp),%edx
  80241c:	89 10                	mov    %edx,(%eax)
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802424:	89 50 04             	mov    %edx,0x4(%eax)
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	8b 00                	mov    (%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	75 08                	jne    802438 <insert_sorted_allocList+0x244>
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	a3 44 50 80 00       	mov    %eax,0x805044
  802438:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80243d:	40                   	inc    %eax
  80243e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802443:	eb 39                	jmp    80247e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802445:	a1 48 50 80 00       	mov    0x805048,%eax
  80244a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802451:	74 07                	je     80245a <insert_sorted_allocList+0x266>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	eb 05                	jmp    80245f <insert_sorted_allocList+0x26b>
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	a3 48 50 80 00       	mov    %eax,0x805048
  802464:	a1 48 50 80 00       	mov    0x805048,%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	0f 85 3f ff ff ff    	jne    8023b0 <insert_sorted_allocList+0x1bc>
  802471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802475:	0f 85 35 ff ff ff    	jne    8023b0 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80247b:	eb 01                	jmp    80247e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80247d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80247e:	90                   	nop
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802487:	a1 38 51 80 00       	mov    0x805138,%eax
  80248c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248f:	e9 85 01 00 00       	jmp    802619 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 40 0c             	mov    0xc(%eax),%eax
  80249a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249d:	0f 82 6e 01 00 00    	jb     802611 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ac:	0f 85 8a 00 00 00    	jne    80253c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b6:	75 17                	jne    8024cf <alloc_block_FF+0x4e>
  8024b8:	83 ec 04             	sub    $0x4,%esp
  8024bb:	68 d0 40 80 00       	push   $0x8040d0
  8024c0:	68 93 00 00 00       	push   $0x93
  8024c5:	68 27 40 80 00       	push   $0x804027
  8024ca:	e8 23 e0 ff ff       	call   8004f2 <_panic>
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 00                	mov    (%eax),%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	74 10                	je     8024e8 <alloc_block_FF+0x67>
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 00                	mov    (%eax),%eax
  8024dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e0:	8b 52 04             	mov    0x4(%edx),%edx
  8024e3:	89 50 04             	mov    %edx,0x4(%eax)
  8024e6:	eb 0b                	jmp    8024f3 <alloc_block_FF+0x72>
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	8b 40 04             	mov    0x4(%eax),%eax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	74 0f                	je     80250c <alloc_block_FF+0x8b>
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 40 04             	mov    0x4(%eax),%eax
  802503:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802506:	8b 12                	mov    (%edx),%edx
  802508:	89 10                	mov    %edx,(%eax)
  80250a:	eb 0a                	jmp    802516 <alloc_block_FF+0x95>
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 00                	mov    (%eax),%eax
  802511:	a3 38 51 80 00       	mov    %eax,0x805138
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802529:	a1 44 51 80 00       	mov    0x805144,%eax
  80252e:	48                   	dec    %eax
  80252f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	e9 10 01 00 00       	jmp    80264c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 0c             	mov    0xc(%eax),%eax
  802542:	3b 45 08             	cmp    0x8(%ebp),%eax
  802545:	0f 86 c6 00 00 00    	jbe    802611 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80254b:	a1 48 51 80 00       	mov    0x805148,%eax
  802550:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 50 08             	mov    0x8(%eax),%edx
  802559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80255f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802562:	8b 55 08             	mov    0x8(%ebp),%edx
  802565:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802568:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80256c:	75 17                	jne    802585 <alloc_block_FF+0x104>
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	68 d0 40 80 00       	push   $0x8040d0
  802576:	68 9b 00 00 00       	push   $0x9b
  80257b:	68 27 40 80 00       	push   $0x804027
  802580:	e8 6d df ff ff       	call   8004f2 <_panic>
  802585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	74 10                	je     80259e <alloc_block_FF+0x11d>
  80258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802596:	8b 52 04             	mov    0x4(%edx),%edx
  802599:	89 50 04             	mov    %edx,0x4(%eax)
  80259c:	eb 0b                	jmp    8025a9 <alloc_block_FF+0x128>
  80259e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a1:	8b 40 04             	mov    0x4(%eax),%eax
  8025a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ac:	8b 40 04             	mov    0x4(%eax),%eax
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	74 0f                	je     8025c2 <alloc_block_FF+0x141>
  8025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b6:	8b 40 04             	mov    0x4(%eax),%eax
  8025b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025bc:	8b 12                	mov    (%edx),%edx
  8025be:	89 10                	mov    %edx,(%eax)
  8025c0:	eb 0a                	jmp    8025cc <alloc_block_FF+0x14b>
  8025c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c5:	8b 00                	mov    (%eax),%eax
  8025c7:	a3 48 51 80 00       	mov    %eax,0x805148
  8025cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025df:	a1 54 51 80 00       	mov    0x805154,%eax
  8025e4:	48                   	dec    %eax
  8025e5:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 50 08             	mov    0x8(%eax),%edx
  8025f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f3:	01 c2                	add    %eax,%edx
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802601:	2b 45 08             	sub    0x8(%ebp),%eax
  802604:	89 c2                	mov    %eax,%edx
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80260c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260f:	eb 3b                	jmp    80264c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802611:	a1 40 51 80 00       	mov    0x805140,%eax
  802616:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261d:	74 07                	je     802626 <alloc_block_FF+0x1a5>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	eb 05                	jmp    80262b <alloc_block_FF+0x1aa>
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
  80262b:	a3 40 51 80 00       	mov    %eax,0x805140
  802630:	a1 40 51 80 00       	mov    0x805140,%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	0f 85 57 fe ff ff    	jne    802494 <alloc_block_FF+0x13>
  80263d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802641:	0f 85 4d fe ff ff    	jne    802494 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264c:	c9                   	leave  
  80264d:	c3                   	ret    

0080264e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
  802651:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802654:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80265b:	a1 38 51 80 00       	mov    0x805138,%eax
  802660:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802663:	e9 df 00 00 00       	jmp    802747 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 0c             	mov    0xc(%eax),%eax
  80266e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802671:	0f 82 c8 00 00 00    	jb     80273f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 40 0c             	mov    0xc(%eax),%eax
  80267d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802680:	0f 85 8a 00 00 00    	jne    802710 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268a:	75 17                	jne    8026a3 <alloc_block_BF+0x55>
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 d0 40 80 00       	push   $0x8040d0
  802694:	68 b7 00 00 00       	push   $0xb7
  802699:	68 27 40 80 00       	push   $0x804027
  80269e:	e8 4f de ff ff       	call   8004f2 <_panic>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 00                	mov    (%eax),%eax
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	74 10                	je     8026bc <alloc_block_BF+0x6e>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b4:	8b 52 04             	mov    0x4(%edx),%edx
  8026b7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ba:	eb 0b                	jmp    8026c7 <alloc_block_BF+0x79>
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 40 04             	mov    0x4(%eax),%eax
  8026c2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 0f                	je     8026e0 <alloc_block_BF+0x92>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 40 04             	mov    0x4(%eax),%eax
  8026d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026da:	8b 12                	mov    (%edx),%edx
  8026dc:	89 10                	mov    %edx,(%eax)
  8026de:	eb 0a                	jmp    8026ea <alloc_block_BF+0x9c>
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 00                	mov    (%eax),%eax
  8026e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fd:	a1 44 51 80 00       	mov    0x805144,%eax
  802702:	48                   	dec    %eax
  802703:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	e9 4d 01 00 00       	jmp    80285d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 0c             	mov    0xc(%eax),%eax
  802716:	3b 45 08             	cmp    0x8(%ebp),%eax
  802719:	76 24                	jbe    80273f <alloc_block_BF+0xf1>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 0c             	mov    0xc(%eax),%eax
  802721:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802724:	73 19                	jae    80273f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802726:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 40 0c             	mov    0xc(%eax),%eax
  802733:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 40 08             	mov    0x8(%eax),%eax
  80273c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80273f:	a1 40 51 80 00       	mov    0x805140,%eax
  802744:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274b:	74 07                	je     802754 <alloc_block_BF+0x106>
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	eb 05                	jmp    802759 <alloc_block_BF+0x10b>
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
  802759:	a3 40 51 80 00       	mov    %eax,0x805140
  80275e:	a1 40 51 80 00       	mov    0x805140,%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	0f 85 fd fe ff ff    	jne    802668 <alloc_block_BF+0x1a>
  80276b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276f:	0f 85 f3 fe ff ff    	jne    802668 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802775:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802779:	0f 84 d9 00 00 00    	je     802858 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80277f:	a1 48 51 80 00       	mov    0x805148,%eax
  802784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80278d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802793:	8b 55 08             	mov    0x8(%ebp),%edx
  802796:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802799:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80279d:	75 17                	jne    8027b6 <alloc_block_BF+0x168>
  80279f:	83 ec 04             	sub    $0x4,%esp
  8027a2:	68 d0 40 80 00       	push   $0x8040d0
  8027a7:	68 c7 00 00 00       	push   $0xc7
  8027ac:	68 27 40 80 00       	push   $0x804027
  8027b1:	e8 3c dd ff ff       	call   8004f2 <_panic>
  8027b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	74 10                	je     8027cf <alloc_block_BF+0x181>
  8027bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c7:	8b 52 04             	mov    0x4(%edx),%edx
  8027ca:	89 50 04             	mov    %edx,0x4(%eax)
  8027cd:	eb 0b                	jmp    8027da <alloc_block_BF+0x18c>
  8027cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d2:	8b 40 04             	mov    0x4(%eax),%eax
  8027d5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027dd:	8b 40 04             	mov    0x4(%eax),%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	74 0f                	je     8027f3 <alloc_block_BF+0x1a5>
  8027e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ed:	8b 12                	mov    (%edx),%edx
  8027ef:	89 10                	mov    %edx,(%eax)
  8027f1:	eb 0a                	jmp    8027fd <alloc_block_BF+0x1af>
  8027f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f6:	8b 00                	mov    (%eax),%eax
  8027f8:	a3 48 51 80 00       	mov    %eax,0x805148
  8027fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802806:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802809:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802810:	a1 54 51 80 00       	mov    0x805154,%eax
  802815:	48                   	dec    %eax
  802816:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80281b:	83 ec 08             	sub    $0x8,%esp
  80281e:	ff 75 ec             	pushl  -0x14(%ebp)
  802821:	68 38 51 80 00       	push   $0x805138
  802826:	e8 71 f9 ff ff       	call   80219c <find_block>
  80282b:	83 c4 10             	add    $0x10,%esp
  80282e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802831:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802834:	8b 50 08             	mov    0x8(%eax),%edx
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	01 c2                	add    %eax,%edx
  80283c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80283f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802842:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802845:	8b 40 0c             	mov    0xc(%eax),%eax
  802848:	2b 45 08             	sub    0x8(%ebp),%eax
  80284b:	89 c2                	mov    %eax,%edx
  80284d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802850:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802856:	eb 05                	jmp    80285d <alloc_block_BF+0x20f>
	}
	return NULL;
  802858:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
  802862:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802865:	a1 28 50 80 00       	mov    0x805028,%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	0f 85 de 01 00 00    	jne    802a50 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802872:	a1 38 51 80 00       	mov    0x805138,%eax
  802877:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287a:	e9 9e 01 00 00       	jmp    802a1d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 0c             	mov    0xc(%eax),%eax
  802885:	3b 45 08             	cmp    0x8(%ebp),%eax
  802888:	0f 82 87 01 00 00    	jb     802a15 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 40 0c             	mov    0xc(%eax),%eax
  802894:	3b 45 08             	cmp    0x8(%ebp),%eax
  802897:	0f 85 95 00 00 00    	jne    802932 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80289d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a1:	75 17                	jne    8028ba <alloc_block_NF+0x5b>
  8028a3:	83 ec 04             	sub    $0x4,%esp
  8028a6:	68 d0 40 80 00       	push   $0x8040d0
  8028ab:	68 e0 00 00 00       	push   $0xe0
  8028b0:	68 27 40 80 00       	push   $0x804027
  8028b5:	e8 38 dc ff ff       	call   8004f2 <_panic>
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 00                	mov    (%eax),%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	74 10                	je     8028d3 <alloc_block_NF+0x74>
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cb:	8b 52 04             	mov    0x4(%edx),%edx
  8028ce:	89 50 04             	mov    %edx,0x4(%eax)
  8028d1:	eb 0b                	jmp    8028de <alloc_block_NF+0x7f>
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 40 04             	mov    0x4(%eax),%eax
  8028d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 40 04             	mov    0x4(%eax),%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	74 0f                	je     8028f7 <alloc_block_NF+0x98>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f1:	8b 12                	mov    (%edx),%edx
  8028f3:	89 10                	mov    %edx,(%eax)
  8028f5:	eb 0a                	jmp    802901 <alloc_block_NF+0xa2>
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	a3 38 51 80 00       	mov    %eax,0x805138
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802914:	a1 44 51 80 00       	mov    0x805144,%eax
  802919:	48                   	dec    %eax
  80291a:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 40 08             	mov    0x8(%eax),%eax
  802925:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	e9 f8 04 00 00       	jmp    802e2a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 40 0c             	mov    0xc(%eax),%eax
  802938:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293b:	0f 86 d4 00 00 00    	jbe    802a15 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802941:	a1 48 51 80 00       	mov    0x805148,%eax
  802946:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 50 08             	mov    0x8(%eax),%edx
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802958:	8b 55 08             	mov    0x8(%ebp),%edx
  80295b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80295e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802962:	75 17                	jne    80297b <alloc_block_NF+0x11c>
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	68 d0 40 80 00       	push   $0x8040d0
  80296c:	68 e9 00 00 00       	push   $0xe9
  802971:	68 27 40 80 00       	push   $0x804027
  802976:	e8 77 db ff ff       	call   8004f2 <_panic>
  80297b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	74 10                	je     802994 <alloc_block_NF+0x135>
  802984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298c:	8b 52 04             	mov    0x4(%edx),%edx
  80298f:	89 50 04             	mov    %edx,0x4(%eax)
  802992:	eb 0b                	jmp    80299f <alloc_block_NF+0x140>
  802994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802997:	8b 40 04             	mov    0x4(%eax),%eax
  80299a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80299f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a2:	8b 40 04             	mov    0x4(%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 0f                	je     8029b8 <alloc_block_NF+0x159>
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	8b 40 04             	mov    0x4(%eax),%eax
  8029af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b2:	8b 12                	mov    (%edx),%edx
  8029b4:	89 10                	mov    %edx,(%eax)
  8029b6:	eb 0a                	jmp    8029c2 <alloc_block_NF+0x163>
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8029da:	48                   	dec    %eax
  8029db:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e3:	8b 40 08             	mov    0x8(%eax),%eax
  8029e6:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 50 08             	mov    0x8(%eax),%edx
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	01 c2                	add    %eax,%edx
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	2b 45 08             	sub    0x8(%ebp),%eax
  802a05:	89 c2                	mov    %eax,%edx
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a10:	e9 15 04 00 00       	jmp    802e2a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a15:	a1 40 51 80 00       	mov    0x805140,%eax
  802a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a21:	74 07                	je     802a2a <alloc_block_NF+0x1cb>
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	eb 05                	jmp    802a2f <alloc_block_NF+0x1d0>
  802a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2f:	a3 40 51 80 00       	mov    %eax,0x805140
  802a34:	a1 40 51 80 00       	mov    0x805140,%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	0f 85 3e fe ff ff    	jne    80287f <alloc_block_NF+0x20>
  802a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a45:	0f 85 34 fe ff ff    	jne    80287f <alloc_block_NF+0x20>
  802a4b:	e9 d5 03 00 00       	jmp    802e25 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a50:	a1 38 51 80 00       	mov    0x805138,%eax
  802a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a58:	e9 b1 01 00 00       	jmp    802c0e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 50 08             	mov    0x8(%eax),%edx
  802a63:	a1 28 50 80 00       	mov    0x805028,%eax
  802a68:	39 c2                	cmp    %eax,%edx
  802a6a:	0f 82 96 01 00 00    	jb     802c06 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 0c             	mov    0xc(%eax),%eax
  802a76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a79:	0f 82 87 01 00 00    	jb     802c06 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 40 0c             	mov    0xc(%eax),%eax
  802a85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a88:	0f 85 95 00 00 00    	jne    802b23 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a92:	75 17                	jne    802aab <alloc_block_NF+0x24c>
  802a94:	83 ec 04             	sub    $0x4,%esp
  802a97:	68 d0 40 80 00       	push   $0x8040d0
  802a9c:	68 fc 00 00 00       	push   $0xfc
  802aa1:	68 27 40 80 00       	push   $0x804027
  802aa6:	e8 47 da ff ff       	call   8004f2 <_panic>
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 00                	mov    (%eax),%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	74 10                	je     802ac4 <alloc_block_NF+0x265>
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abc:	8b 52 04             	mov    0x4(%edx),%edx
  802abf:	89 50 04             	mov    %edx,0x4(%eax)
  802ac2:	eb 0b                	jmp    802acf <alloc_block_NF+0x270>
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 40 04             	mov    0x4(%eax),%eax
  802aca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 04             	mov    0x4(%eax),%eax
  802ad5:	85 c0                	test   %eax,%eax
  802ad7:	74 0f                	je     802ae8 <alloc_block_NF+0x289>
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae2:	8b 12                	mov    (%edx),%edx
  802ae4:	89 10                	mov    %edx,(%eax)
  802ae6:	eb 0a                	jmp    802af2 <alloc_block_NF+0x293>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	a3 38 51 80 00       	mov    %eax,0x805138
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b05:	a1 44 51 80 00       	mov    0x805144,%eax
  802b0a:	48                   	dec    %eax
  802b0b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 40 08             	mov    0x8(%eax),%eax
  802b16:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	e9 07 03 00 00       	jmp    802e2a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 40 0c             	mov    0xc(%eax),%eax
  802b29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2c:	0f 86 d4 00 00 00    	jbe    802c06 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b32:	a1 48 51 80 00       	mov    0x805148,%eax
  802b37:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 50 08             	mov    0x8(%eax),%edx
  802b40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b43:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b49:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b53:	75 17                	jne    802b6c <alloc_block_NF+0x30d>
  802b55:	83 ec 04             	sub    $0x4,%esp
  802b58:	68 d0 40 80 00       	push   $0x8040d0
  802b5d:	68 04 01 00 00       	push   $0x104
  802b62:	68 27 40 80 00       	push   $0x804027
  802b67:	e8 86 d9 ff ff       	call   8004f2 <_panic>
  802b6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	74 10                	je     802b85 <alloc_block_NF+0x326>
  802b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b7d:	8b 52 04             	mov    0x4(%edx),%edx
  802b80:	89 50 04             	mov    %edx,0x4(%eax)
  802b83:	eb 0b                	jmp    802b90 <alloc_block_NF+0x331>
  802b85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b88:	8b 40 04             	mov    0x4(%eax),%eax
  802b8b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b93:	8b 40 04             	mov    0x4(%eax),%eax
  802b96:	85 c0                	test   %eax,%eax
  802b98:	74 0f                	je     802ba9 <alloc_block_NF+0x34a>
  802b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ba0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba3:	8b 12                	mov    (%edx),%edx
  802ba5:	89 10                	mov    %edx,(%eax)
  802ba7:	eb 0a                	jmp    802bb3 <alloc_block_NF+0x354>
  802ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc6:	a1 54 51 80 00       	mov    0x805154,%eax
  802bcb:	48                   	dec    %eax
  802bcc:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd4:	8b 40 08             	mov    0x8(%eax),%eax
  802bd7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 50 08             	mov    0x8(%eax),%edx
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	01 c2                	add    %eax,%edx
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf3:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf6:	89 c2                	mov    %eax,%edx
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c01:	e9 24 02 00 00       	jmp    802e2a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c06:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c12:	74 07                	je     802c1b <alloc_block_NF+0x3bc>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	eb 05                	jmp    802c20 <alloc_block_NF+0x3c1>
  802c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c20:	a3 40 51 80 00       	mov    %eax,0x805140
  802c25:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	0f 85 2b fe ff ff    	jne    802a5d <alloc_block_NF+0x1fe>
  802c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c36:	0f 85 21 fe ff ff    	jne    802a5d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c3c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c44:	e9 ae 01 00 00       	jmp    802df7 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 50 08             	mov    0x8(%eax),%edx
  802c4f:	a1 28 50 80 00       	mov    0x805028,%eax
  802c54:	39 c2                	cmp    %eax,%edx
  802c56:	0f 83 93 01 00 00    	jae    802def <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c65:	0f 82 84 01 00 00    	jb     802def <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c71:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c74:	0f 85 95 00 00 00    	jne    802d0f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7e:	75 17                	jne    802c97 <alloc_block_NF+0x438>
  802c80:	83 ec 04             	sub    $0x4,%esp
  802c83:	68 d0 40 80 00       	push   $0x8040d0
  802c88:	68 14 01 00 00       	push   $0x114
  802c8d:	68 27 40 80 00       	push   $0x804027
  802c92:	e8 5b d8 ff ff       	call   8004f2 <_panic>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	74 10                	je     802cb0 <alloc_block_NF+0x451>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca8:	8b 52 04             	mov    0x4(%edx),%edx
  802cab:	89 50 04             	mov    %edx,0x4(%eax)
  802cae:	eb 0b                	jmp    802cbb <alloc_block_NF+0x45c>
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 40 04             	mov    0x4(%eax),%eax
  802cb6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	74 0f                	je     802cd4 <alloc_block_NF+0x475>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 04             	mov    0x4(%eax),%eax
  802ccb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cce:	8b 12                	mov    (%edx),%edx
  802cd0:	89 10                	mov    %edx,(%eax)
  802cd2:	eb 0a                	jmp    802cde <alloc_block_NF+0x47f>
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	a3 38 51 80 00       	mov    %eax,0x805138
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf1:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf6:	48                   	dec    %eax
  802cf7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 40 08             	mov    0x8(%eax),%eax
  802d02:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	e9 1b 01 00 00       	jmp    802e2a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	8b 40 0c             	mov    0xc(%eax),%eax
  802d15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d18:	0f 86 d1 00 00 00    	jbe    802def <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d1e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d23:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 50 08             	mov    0x8(%eax),%edx
  802d2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d35:	8b 55 08             	mov    0x8(%ebp),%edx
  802d38:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d3f:	75 17                	jne    802d58 <alloc_block_NF+0x4f9>
  802d41:	83 ec 04             	sub    $0x4,%esp
  802d44:	68 d0 40 80 00       	push   $0x8040d0
  802d49:	68 1c 01 00 00       	push   $0x11c
  802d4e:	68 27 40 80 00       	push   $0x804027
  802d53:	e8 9a d7 ff ff       	call   8004f2 <_panic>
  802d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	74 10                	je     802d71 <alloc_block_NF+0x512>
  802d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d69:	8b 52 04             	mov    0x4(%edx),%edx
  802d6c:	89 50 04             	mov    %edx,0x4(%eax)
  802d6f:	eb 0b                	jmp    802d7c <alloc_block_NF+0x51d>
  802d71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d74:	8b 40 04             	mov    0x4(%eax),%eax
  802d77:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7f:	8b 40 04             	mov    0x4(%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 0f                	je     802d95 <alloc_block_NF+0x536>
  802d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d8f:	8b 12                	mov    (%edx),%edx
  802d91:	89 10                	mov    %edx,(%eax)
  802d93:	eb 0a                	jmp    802d9f <alloc_block_NF+0x540>
  802d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	a3 48 51 80 00       	mov    %eax,0x805148
  802d9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db2:	a1 54 51 80 00       	mov    0x805154,%eax
  802db7:	48                   	dec    %eax
  802db8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc0:	8b 40 08             	mov    0x8(%eax),%eax
  802dc3:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 50 08             	mov    0x8(%eax),%edx
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	01 c2                	add    %eax,%edx
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddf:	2b 45 08             	sub    0x8(%ebp),%eax
  802de2:	89 c2                	mov    %eax,%edx
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	eb 3b                	jmp    802e2a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802def:	a1 40 51 80 00       	mov    0x805140,%eax
  802df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfb:	74 07                	je     802e04 <alloc_block_NF+0x5a5>
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 00                	mov    (%eax),%eax
  802e02:	eb 05                	jmp    802e09 <alloc_block_NF+0x5aa>
  802e04:	b8 00 00 00 00       	mov    $0x0,%eax
  802e09:	a3 40 51 80 00       	mov    %eax,0x805140
  802e0e:	a1 40 51 80 00       	mov    0x805140,%eax
  802e13:	85 c0                	test   %eax,%eax
  802e15:	0f 85 2e fe ff ff    	jne    802c49 <alloc_block_NF+0x3ea>
  802e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1f:	0f 85 24 fe ff ff    	jne    802c49 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2a:	c9                   	leave  
  802e2b:	c3                   	ret    

00802e2c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e2c:	55                   	push   %ebp
  802e2d:	89 e5                	mov    %esp,%ebp
  802e2f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e32:	a1 38 51 80 00       	mov    0x805138,%eax
  802e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e3a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e3f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e42:	a1 38 51 80 00       	mov    0x805138,%eax
  802e47:	85 c0                	test   %eax,%eax
  802e49:	74 14                	je     802e5f <insert_sorted_with_merge_freeList+0x33>
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	8b 50 08             	mov    0x8(%eax),%edx
  802e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e54:	8b 40 08             	mov    0x8(%eax),%eax
  802e57:	39 c2                	cmp    %eax,%edx
  802e59:	0f 87 9b 01 00 00    	ja     802ffa <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e63:	75 17                	jne    802e7c <insert_sorted_with_merge_freeList+0x50>
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	68 04 40 80 00       	push   $0x804004
  802e6d:	68 38 01 00 00       	push   $0x138
  802e72:	68 27 40 80 00       	push   $0x804027
  802e77:	e8 76 d6 ff ff       	call   8004f2 <_panic>
  802e7c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	89 10                	mov    %edx,(%eax)
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 00                	mov    (%eax),%eax
  802e8c:	85 c0                	test   %eax,%eax
  802e8e:	74 0d                	je     802e9d <insert_sorted_with_merge_freeList+0x71>
  802e90:	a1 38 51 80 00       	mov    0x805138,%eax
  802e95:	8b 55 08             	mov    0x8(%ebp),%edx
  802e98:	89 50 04             	mov    %edx,0x4(%eax)
  802e9b:	eb 08                	jmp    802ea5 <insert_sorted_with_merge_freeList+0x79>
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	a3 38 51 80 00       	mov    %eax,0x805138
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb7:	a1 44 51 80 00       	mov    0x805144,%eax
  802ebc:	40                   	inc    %eax
  802ebd:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ec2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec6:	0f 84 a8 06 00 00    	je     803574 <insert_sorted_with_merge_freeList+0x748>
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 50 08             	mov    0x8(%eax),%edx
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed8:	01 c2                	add    %eax,%edx
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	8b 40 08             	mov    0x8(%eax),%eax
  802ee0:	39 c2                	cmp    %eax,%edx
  802ee2:	0f 85 8c 06 00 00    	jne    803574 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	8b 50 0c             	mov    0xc(%eax),%edx
  802eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef4:	01 c2                	add    %eax,%edx
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802efc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f00:	75 17                	jne    802f19 <insert_sorted_with_merge_freeList+0xed>
  802f02:	83 ec 04             	sub    $0x4,%esp
  802f05:	68 d0 40 80 00       	push   $0x8040d0
  802f0a:	68 3c 01 00 00       	push   $0x13c
  802f0f:	68 27 40 80 00       	push   $0x804027
  802f14:	e8 d9 d5 ff ff       	call   8004f2 <_panic>
  802f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 10                	je     802f32 <insert_sorted_with_merge_freeList+0x106>
  802f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f2a:	8b 52 04             	mov    0x4(%edx),%edx
  802f2d:	89 50 04             	mov    %edx,0x4(%eax)
  802f30:	eb 0b                	jmp    802f3d <insert_sorted_with_merge_freeList+0x111>
  802f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f35:	8b 40 04             	mov    0x4(%eax),%eax
  802f38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 0f                	je     802f56 <insert_sorted_with_merge_freeList+0x12a>
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	8b 40 04             	mov    0x4(%eax),%eax
  802f4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f50:	8b 12                	mov    (%edx),%edx
  802f52:	89 10                	mov    %edx,(%eax)
  802f54:	eb 0a                	jmp    802f60 <insert_sorted_with_merge_freeList+0x134>
  802f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f73:	a1 44 51 80 00       	mov    0x805144,%eax
  802f78:	48                   	dec    %eax
  802f79:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f81:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f96:	75 17                	jne    802faf <insert_sorted_with_merge_freeList+0x183>
  802f98:	83 ec 04             	sub    $0x4,%esp
  802f9b:	68 04 40 80 00       	push   $0x804004
  802fa0:	68 3f 01 00 00       	push   $0x13f
  802fa5:	68 27 40 80 00       	push   $0x804027
  802faa:	e8 43 d5 ff ff       	call   8004f2 <_panic>
  802faf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb8:	89 10                	mov    %edx,(%eax)
  802fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	74 0d                	je     802fd0 <insert_sorted_with_merge_freeList+0x1a4>
  802fc3:	a1 48 51 80 00       	mov    0x805148,%eax
  802fc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fcb:	89 50 04             	mov    %edx,0x4(%eax)
  802fce:	eb 08                	jmp    802fd8 <insert_sorted_with_merge_freeList+0x1ac>
  802fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdb:	a3 48 51 80 00       	mov    %eax,0x805148
  802fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fea:	a1 54 51 80 00       	mov    0x805154,%eax
  802fef:	40                   	inc    %eax
  802ff0:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ff5:	e9 7a 05 00 00       	jmp    803574 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	8b 50 08             	mov    0x8(%eax),%edx
  803000:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803003:	8b 40 08             	mov    0x8(%eax),%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	0f 82 14 01 00 00    	jb     803122 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80300e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803011:	8b 50 08             	mov    0x8(%eax),%edx
  803014:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803017:	8b 40 0c             	mov    0xc(%eax),%eax
  80301a:	01 c2                	add    %eax,%edx
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	8b 40 08             	mov    0x8(%eax),%eax
  803022:	39 c2                	cmp    %eax,%edx
  803024:	0f 85 90 00 00 00    	jne    8030ba <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80302a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302d:	8b 50 0c             	mov    0xc(%eax),%edx
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	8b 40 0c             	mov    0xc(%eax),%eax
  803036:	01 c2                	add    %eax,%edx
  803038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803052:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803056:	75 17                	jne    80306f <insert_sorted_with_merge_freeList+0x243>
  803058:	83 ec 04             	sub    $0x4,%esp
  80305b:	68 04 40 80 00       	push   $0x804004
  803060:	68 49 01 00 00       	push   $0x149
  803065:	68 27 40 80 00       	push   $0x804027
  80306a:	e8 83 d4 ff ff       	call   8004f2 <_panic>
  80306f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	89 10                	mov    %edx,(%eax)
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	8b 00                	mov    (%eax),%eax
  80307f:	85 c0                	test   %eax,%eax
  803081:	74 0d                	je     803090 <insert_sorted_with_merge_freeList+0x264>
  803083:	a1 48 51 80 00       	mov    0x805148,%eax
  803088:	8b 55 08             	mov    0x8(%ebp),%edx
  80308b:	89 50 04             	mov    %edx,0x4(%eax)
  80308e:	eb 08                	jmp    803098 <insert_sorted_with_merge_freeList+0x26c>
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8030af:	40                   	inc    %eax
  8030b0:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030b5:	e9 bb 04 00 00       	jmp    803575 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030be:	75 17                	jne    8030d7 <insert_sorted_with_merge_freeList+0x2ab>
  8030c0:	83 ec 04             	sub    $0x4,%esp
  8030c3:	68 78 40 80 00       	push   $0x804078
  8030c8:	68 4c 01 00 00       	push   $0x14c
  8030cd:	68 27 40 80 00       	push   $0x804027
  8030d2:	e8 1b d4 ff ff       	call   8004f2 <_panic>
  8030d7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	8b 40 04             	mov    0x4(%eax),%eax
  8030e9:	85 c0                	test   %eax,%eax
  8030eb:	74 0c                	je     8030f9 <insert_sorted_with_merge_freeList+0x2cd>
  8030ed:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f5:	89 10                	mov    %edx,(%eax)
  8030f7:	eb 08                	jmp    803101 <insert_sorted_with_merge_freeList+0x2d5>
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803112:	a1 44 51 80 00       	mov    0x805144,%eax
  803117:	40                   	inc    %eax
  803118:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80311d:	e9 53 04 00 00       	jmp    803575 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803122:	a1 38 51 80 00       	mov    0x805138,%eax
  803127:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80312a:	e9 15 04 00 00       	jmp    803544 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	8b 50 08             	mov    0x8(%eax),%edx
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 40 08             	mov    0x8(%eax),%eax
  803143:	39 c2                	cmp    %eax,%edx
  803145:	0f 86 f1 03 00 00    	jbe    80353c <insert_sorted_with_merge_freeList+0x710>
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 50 08             	mov    0x8(%eax),%edx
  803151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803154:	8b 40 08             	mov    0x8(%eax),%eax
  803157:	39 c2                	cmp    %eax,%edx
  803159:	0f 83 dd 03 00 00    	jae    80353c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803162:	8b 50 08             	mov    0x8(%eax),%edx
  803165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803168:	8b 40 0c             	mov    0xc(%eax),%eax
  80316b:	01 c2                	add    %eax,%edx
  80316d:	8b 45 08             	mov    0x8(%ebp),%eax
  803170:	8b 40 08             	mov    0x8(%eax),%eax
  803173:	39 c2                	cmp    %eax,%edx
  803175:	0f 85 b9 01 00 00    	jne    803334 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	8b 50 08             	mov    0x8(%eax),%edx
  803181:	8b 45 08             	mov    0x8(%ebp),%eax
  803184:	8b 40 0c             	mov    0xc(%eax),%eax
  803187:	01 c2                	add    %eax,%edx
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	8b 40 08             	mov    0x8(%eax),%eax
  80318f:	39 c2                	cmp    %eax,%edx
  803191:	0f 85 0d 01 00 00    	jne    8032a4 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319a:	8b 50 0c             	mov    0xc(%eax),%edx
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a3:	01 c2                	add    %eax,%edx
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031af:	75 17                	jne    8031c8 <insert_sorted_with_merge_freeList+0x39c>
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	68 d0 40 80 00       	push   $0x8040d0
  8031b9:	68 5c 01 00 00       	push   $0x15c
  8031be:	68 27 40 80 00       	push   $0x804027
  8031c3:	e8 2a d3 ff ff       	call   8004f2 <_panic>
  8031c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	85 c0                	test   %eax,%eax
  8031cf:	74 10                	je     8031e1 <insert_sorted_with_merge_freeList+0x3b5>
  8031d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d4:	8b 00                	mov    (%eax),%eax
  8031d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d9:	8b 52 04             	mov    0x4(%edx),%edx
  8031dc:	89 50 04             	mov    %edx,0x4(%eax)
  8031df:	eb 0b                	jmp    8031ec <insert_sorted_with_merge_freeList+0x3c0>
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	8b 40 04             	mov    0x4(%eax),%eax
  8031e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ef:	8b 40 04             	mov    0x4(%eax),%eax
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	74 0f                	je     803205 <insert_sorted_with_merge_freeList+0x3d9>
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	8b 40 04             	mov    0x4(%eax),%eax
  8031fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ff:	8b 12                	mov    (%edx),%edx
  803201:	89 10                	mov    %edx,(%eax)
  803203:	eb 0a                	jmp    80320f <insert_sorted_with_merge_freeList+0x3e3>
  803205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	a3 38 51 80 00       	mov    %eax,0x805138
  80320f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803212:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803222:	a1 44 51 80 00       	mov    0x805144,%eax
  803227:	48                   	dec    %eax
  803228:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80322d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803230:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803241:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803245:	75 17                	jne    80325e <insert_sorted_with_merge_freeList+0x432>
  803247:	83 ec 04             	sub    $0x4,%esp
  80324a:	68 04 40 80 00       	push   $0x804004
  80324f:	68 5f 01 00 00       	push   $0x15f
  803254:	68 27 40 80 00       	push   $0x804027
  803259:	e8 94 d2 ff ff       	call   8004f2 <_panic>
  80325e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	89 10                	mov    %edx,(%eax)
  803269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326c:	8b 00                	mov    (%eax),%eax
  80326e:	85 c0                	test   %eax,%eax
  803270:	74 0d                	je     80327f <insert_sorted_with_merge_freeList+0x453>
  803272:	a1 48 51 80 00       	mov    0x805148,%eax
  803277:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327a:	89 50 04             	mov    %edx,0x4(%eax)
  80327d:	eb 08                	jmp    803287 <insert_sorted_with_merge_freeList+0x45b>
  80327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803282:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328a:	a3 48 51 80 00       	mov    %eax,0x805148
  80328f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803292:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803299:	a1 54 51 80 00       	mov    0x805154,%eax
  80329e:	40                   	inc    %eax
  80329f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 50 0c             	mov    0xc(%eax),%edx
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b0:	01 c2                	add    %eax,%edx
  8032b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b5:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d0:	75 17                	jne    8032e9 <insert_sorted_with_merge_freeList+0x4bd>
  8032d2:	83 ec 04             	sub    $0x4,%esp
  8032d5:	68 04 40 80 00       	push   $0x804004
  8032da:	68 64 01 00 00       	push   $0x164
  8032df:	68 27 40 80 00       	push   $0x804027
  8032e4:	e8 09 d2 ff ff       	call   8004f2 <_panic>
  8032e9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	89 10                	mov    %edx,(%eax)
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	8b 00                	mov    (%eax),%eax
  8032f9:	85 c0                	test   %eax,%eax
  8032fb:	74 0d                	je     80330a <insert_sorted_with_merge_freeList+0x4de>
  8032fd:	a1 48 51 80 00       	mov    0x805148,%eax
  803302:	8b 55 08             	mov    0x8(%ebp),%edx
  803305:	89 50 04             	mov    %edx,0x4(%eax)
  803308:	eb 08                	jmp    803312 <insert_sorted_with_merge_freeList+0x4e6>
  80330a:	8b 45 08             	mov    0x8(%ebp),%eax
  80330d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	a3 48 51 80 00       	mov    %eax,0x805148
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803324:	a1 54 51 80 00       	mov    0x805154,%eax
  803329:	40                   	inc    %eax
  80332a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80332f:	e9 41 02 00 00       	jmp    803575 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	8b 50 08             	mov    0x8(%eax),%edx
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	8b 40 0c             	mov    0xc(%eax),%eax
  803340:	01 c2                	add    %eax,%edx
  803342:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803345:	8b 40 08             	mov    0x8(%eax),%eax
  803348:	39 c2                	cmp    %eax,%edx
  80334a:	0f 85 7c 01 00 00    	jne    8034cc <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803350:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803354:	74 06                	je     80335c <insert_sorted_with_merge_freeList+0x530>
  803356:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80335a:	75 17                	jne    803373 <insert_sorted_with_merge_freeList+0x547>
  80335c:	83 ec 04             	sub    $0x4,%esp
  80335f:	68 40 40 80 00       	push   $0x804040
  803364:	68 69 01 00 00       	push   $0x169
  803369:	68 27 40 80 00       	push   $0x804027
  80336e:	e8 7f d1 ff ff       	call   8004f2 <_panic>
  803373:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803376:	8b 50 04             	mov    0x4(%eax),%edx
  803379:	8b 45 08             	mov    0x8(%ebp),%eax
  80337c:	89 50 04             	mov    %edx,0x4(%eax)
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803385:	89 10                	mov    %edx,(%eax)
  803387:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338a:	8b 40 04             	mov    0x4(%eax),%eax
  80338d:	85 c0                	test   %eax,%eax
  80338f:	74 0d                	je     80339e <insert_sorted_with_merge_freeList+0x572>
  803391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803394:	8b 40 04             	mov    0x4(%eax),%eax
  803397:	8b 55 08             	mov    0x8(%ebp),%edx
  80339a:	89 10                	mov    %edx,(%eax)
  80339c:	eb 08                	jmp    8033a6 <insert_sorted_with_merge_freeList+0x57a>
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ac:	89 50 04             	mov    %edx,0x4(%eax)
  8033af:	a1 44 51 80 00       	mov    0x805144,%eax
  8033b4:	40                   	inc    %eax
  8033b5:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	8b 50 0c             	mov    0xc(%eax),%edx
  8033c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c6:	01 c2                	add    %eax,%edx
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033d2:	75 17                	jne    8033eb <insert_sorted_with_merge_freeList+0x5bf>
  8033d4:	83 ec 04             	sub    $0x4,%esp
  8033d7:	68 d0 40 80 00       	push   $0x8040d0
  8033dc:	68 6b 01 00 00       	push   $0x16b
  8033e1:	68 27 40 80 00       	push   $0x804027
  8033e6:	e8 07 d1 ff ff       	call   8004f2 <_panic>
  8033eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ee:	8b 00                	mov    (%eax),%eax
  8033f0:	85 c0                	test   %eax,%eax
  8033f2:	74 10                	je     803404 <insert_sorted_with_merge_freeList+0x5d8>
  8033f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033fc:	8b 52 04             	mov    0x4(%edx),%edx
  8033ff:	89 50 04             	mov    %edx,0x4(%eax)
  803402:	eb 0b                	jmp    80340f <insert_sorted_with_merge_freeList+0x5e3>
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	8b 40 04             	mov    0x4(%eax),%eax
  80340a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80340f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803412:	8b 40 04             	mov    0x4(%eax),%eax
  803415:	85 c0                	test   %eax,%eax
  803417:	74 0f                	je     803428 <insert_sorted_with_merge_freeList+0x5fc>
  803419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341c:	8b 40 04             	mov    0x4(%eax),%eax
  80341f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803422:	8b 12                	mov    (%edx),%edx
  803424:	89 10                	mov    %edx,(%eax)
  803426:	eb 0a                	jmp    803432 <insert_sorted_with_merge_freeList+0x606>
  803428:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	a3 38 51 80 00       	mov    %eax,0x805138
  803432:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803435:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80343b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803445:	a1 44 51 80 00       	mov    0x805144,%eax
  80344a:	48                   	dec    %eax
  80344b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803450:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803453:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80345a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803464:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803468:	75 17                	jne    803481 <insert_sorted_with_merge_freeList+0x655>
  80346a:	83 ec 04             	sub    $0x4,%esp
  80346d:	68 04 40 80 00       	push   $0x804004
  803472:	68 6e 01 00 00       	push   $0x16e
  803477:	68 27 40 80 00       	push   $0x804027
  80347c:	e8 71 d0 ff ff       	call   8004f2 <_panic>
  803481:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348a:	89 10                	mov    %edx,(%eax)
  80348c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348f:	8b 00                	mov    (%eax),%eax
  803491:	85 c0                	test   %eax,%eax
  803493:	74 0d                	je     8034a2 <insert_sorted_with_merge_freeList+0x676>
  803495:	a1 48 51 80 00       	mov    0x805148,%eax
  80349a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80349d:	89 50 04             	mov    %edx,0x4(%eax)
  8034a0:	eb 08                	jmp    8034aa <insert_sorted_with_merge_freeList+0x67e>
  8034a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8034b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8034c1:	40                   	inc    %eax
  8034c2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034c7:	e9 a9 00 00 00       	jmp    803575 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d0:	74 06                	je     8034d8 <insert_sorted_with_merge_freeList+0x6ac>
  8034d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d6:	75 17                	jne    8034ef <insert_sorted_with_merge_freeList+0x6c3>
  8034d8:	83 ec 04             	sub    $0x4,%esp
  8034db:	68 9c 40 80 00       	push   $0x80409c
  8034e0:	68 73 01 00 00       	push   $0x173
  8034e5:	68 27 40 80 00       	push   $0x804027
  8034ea:	e8 03 d0 ff ff       	call   8004f2 <_panic>
  8034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f2:	8b 10                	mov    (%eax),%edx
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	89 10                	mov    %edx,(%eax)
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	8b 00                	mov    (%eax),%eax
  8034fe:	85 c0                	test   %eax,%eax
  803500:	74 0b                	je     80350d <insert_sorted_with_merge_freeList+0x6e1>
  803502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	8b 55 08             	mov    0x8(%ebp),%edx
  80350a:	89 50 04             	mov    %edx,0x4(%eax)
  80350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803510:	8b 55 08             	mov    0x8(%ebp),%edx
  803513:	89 10                	mov    %edx,(%eax)
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80351b:	89 50 04             	mov    %edx,0x4(%eax)
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	8b 00                	mov    (%eax),%eax
  803523:	85 c0                	test   %eax,%eax
  803525:	75 08                	jne    80352f <insert_sorted_with_merge_freeList+0x703>
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80352f:	a1 44 51 80 00       	mov    0x805144,%eax
  803534:	40                   	inc    %eax
  803535:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80353a:	eb 39                	jmp    803575 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80353c:	a1 40 51 80 00       	mov    0x805140,%eax
  803541:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803544:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803548:	74 07                	je     803551 <insert_sorted_with_merge_freeList+0x725>
  80354a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354d:	8b 00                	mov    (%eax),%eax
  80354f:	eb 05                	jmp    803556 <insert_sorted_with_merge_freeList+0x72a>
  803551:	b8 00 00 00 00       	mov    $0x0,%eax
  803556:	a3 40 51 80 00       	mov    %eax,0x805140
  80355b:	a1 40 51 80 00       	mov    0x805140,%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	0f 85 c7 fb ff ff    	jne    80312f <insert_sorted_with_merge_freeList+0x303>
  803568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356c:	0f 85 bd fb ff ff    	jne    80312f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803572:	eb 01                	jmp    803575 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803574:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803575:	90                   	nop
  803576:	c9                   	leave  
  803577:	c3                   	ret    

00803578 <__udivdi3>:
  803578:	55                   	push   %ebp
  803579:	57                   	push   %edi
  80357a:	56                   	push   %esi
  80357b:	53                   	push   %ebx
  80357c:	83 ec 1c             	sub    $0x1c,%esp
  80357f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803583:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803587:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80358b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80358f:	89 ca                	mov    %ecx,%edx
  803591:	89 f8                	mov    %edi,%eax
  803593:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803597:	85 f6                	test   %esi,%esi
  803599:	75 2d                	jne    8035c8 <__udivdi3+0x50>
  80359b:	39 cf                	cmp    %ecx,%edi
  80359d:	77 65                	ja     803604 <__udivdi3+0x8c>
  80359f:	89 fd                	mov    %edi,%ebp
  8035a1:	85 ff                	test   %edi,%edi
  8035a3:	75 0b                	jne    8035b0 <__udivdi3+0x38>
  8035a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035aa:	31 d2                	xor    %edx,%edx
  8035ac:	f7 f7                	div    %edi
  8035ae:	89 c5                	mov    %eax,%ebp
  8035b0:	31 d2                	xor    %edx,%edx
  8035b2:	89 c8                	mov    %ecx,%eax
  8035b4:	f7 f5                	div    %ebp
  8035b6:	89 c1                	mov    %eax,%ecx
  8035b8:	89 d8                	mov    %ebx,%eax
  8035ba:	f7 f5                	div    %ebp
  8035bc:	89 cf                	mov    %ecx,%edi
  8035be:	89 fa                	mov    %edi,%edx
  8035c0:	83 c4 1c             	add    $0x1c,%esp
  8035c3:	5b                   	pop    %ebx
  8035c4:	5e                   	pop    %esi
  8035c5:	5f                   	pop    %edi
  8035c6:	5d                   	pop    %ebp
  8035c7:	c3                   	ret    
  8035c8:	39 ce                	cmp    %ecx,%esi
  8035ca:	77 28                	ja     8035f4 <__udivdi3+0x7c>
  8035cc:	0f bd fe             	bsr    %esi,%edi
  8035cf:	83 f7 1f             	xor    $0x1f,%edi
  8035d2:	75 40                	jne    803614 <__udivdi3+0x9c>
  8035d4:	39 ce                	cmp    %ecx,%esi
  8035d6:	72 0a                	jb     8035e2 <__udivdi3+0x6a>
  8035d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035dc:	0f 87 9e 00 00 00    	ja     803680 <__udivdi3+0x108>
  8035e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035e7:	89 fa                	mov    %edi,%edx
  8035e9:	83 c4 1c             	add    $0x1c,%esp
  8035ec:	5b                   	pop    %ebx
  8035ed:	5e                   	pop    %esi
  8035ee:	5f                   	pop    %edi
  8035ef:	5d                   	pop    %ebp
  8035f0:	c3                   	ret    
  8035f1:	8d 76 00             	lea    0x0(%esi),%esi
  8035f4:	31 ff                	xor    %edi,%edi
  8035f6:	31 c0                	xor    %eax,%eax
  8035f8:	89 fa                	mov    %edi,%edx
  8035fa:	83 c4 1c             	add    $0x1c,%esp
  8035fd:	5b                   	pop    %ebx
  8035fe:	5e                   	pop    %esi
  8035ff:	5f                   	pop    %edi
  803600:	5d                   	pop    %ebp
  803601:	c3                   	ret    
  803602:	66 90                	xchg   %ax,%ax
  803604:	89 d8                	mov    %ebx,%eax
  803606:	f7 f7                	div    %edi
  803608:	31 ff                	xor    %edi,%edi
  80360a:	89 fa                	mov    %edi,%edx
  80360c:	83 c4 1c             	add    $0x1c,%esp
  80360f:	5b                   	pop    %ebx
  803610:	5e                   	pop    %esi
  803611:	5f                   	pop    %edi
  803612:	5d                   	pop    %ebp
  803613:	c3                   	ret    
  803614:	bd 20 00 00 00       	mov    $0x20,%ebp
  803619:	89 eb                	mov    %ebp,%ebx
  80361b:	29 fb                	sub    %edi,%ebx
  80361d:	89 f9                	mov    %edi,%ecx
  80361f:	d3 e6                	shl    %cl,%esi
  803621:	89 c5                	mov    %eax,%ebp
  803623:	88 d9                	mov    %bl,%cl
  803625:	d3 ed                	shr    %cl,%ebp
  803627:	89 e9                	mov    %ebp,%ecx
  803629:	09 f1                	or     %esi,%ecx
  80362b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80362f:	89 f9                	mov    %edi,%ecx
  803631:	d3 e0                	shl    %cl,%eax
  803633:	89 c5                	mov    %eax,%ebp
  803635:	89 d6                	mov    %edx,%esi
  803637:	88 d9                	mov    %bl,%cl
  803639:	d3 ee                	shr    %cl,%esi
  80363b:	89 f9                	mov    %edi,%ecx
  80363d:	d3 e2                	shl    %cl,%edx
  80363f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803643:	88 d9                	mov    %bl,%cl
  803645:	d3 e8                	shr    %cl,%eax
  803647:	09 c2                	or     %eax,%edx
  803649:	89 d0                	mov    %edx,%eax
  80364b:	89 f2                	mov    %esi,%edx
  80364d:	f7 74 24 0c          	divl   0xc(%esp)
  803651:	89 d6                	mov    %edx,%esi
  803653:	89 c3                	mov    %eax,%ebx
  803655:	f7 e5                	mul    %ebp
  803657:	39 d6                	cmp    %edx,%esi
  803659:	72 19                	jb     803674 <__udivdi3+0xfc>
  80365b:	74 0b                	je     803668 <__udivdi3+0xf0>
  80365d:	89 d8                	mov    %ebx,%eax
  80365f:	31 ff                	xor    %edi,%edi
  803661:	e9 58 ff ff ff       	jmp    8035be <__udivdi3+0x46>
  803666:	66 90                	xchg   %ax,%ax
  803668:	8b 54 24 08          	mov    0x8(%esp),%edx
  80366c:	89 f9                	mov    %edi,%ecx
  80366e:	d3 e2                	shl    %cl,%edx
  803670:	39 c2                	cmp    %eax,%edx
  803672:	73 e9                	jae    80365d <__udivdi3+0xe5>
  803674:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803677:	31 ff                	xor    %edi,%edi
  803679:	e9 40 ff ff ff       	jmp    8035be <__udivdi3+0x46>
  80367e:	66 90                	xchg   %ax,%ax
  803680:	31 c0                	xor    %eax,%eax
  803682:	e9 37 ff ff ff       	jmp    8035be <__udivdi3+0x46>
  803687:	90                   	nop

00803688 <__umoddi3>:
  803688:	55                   	push   %ebp
  803689:	57                   	push   %edi
  80368a:	56                   	push   %esi
  80368b:	53                   	push   %ebx
  80368c:	83 ec 1c             	sub    $0x1c,%esp
  80368f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803693:	8b 74 24 34          	mov    0x34(%esp),%esi
  803697:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80369b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80369f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036a7:	89 f3                	mov    %esi,%ebx
  8036a9:	89 fa                	mov    %edi,%edx
  8036ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036af:	89 34 24             	mov    %esi,(%esp)
  8036b2:	85 c0                	test   %eax,%eax
  8036b4:	75 1a                	jne    8036d0 <__umoddi3+0x48>
  8036b6:	39 f7                	cmp    %esi,%edi
  8036b8:	0f 86 a2 00 00 00    	jbe    803760 <__umoddi3+0xd8>
  8036be:	89 c8                	mov    %ecx,%eax
  8036c0:	89 f2                	mov    %esi,%edx
  8036c2:	f7 f7                	div    %edi
  8036c4:	89 d0                	mov    %edx,%eax
  8036c6:	31 d2                	xor    %edx,%edx
  8036c8:	83 c4 1c             	add    $0x1c,%esp
  8036cb:	5b                   	pop    %ebx
  8036cc:	5e                   	pop    %esi
  8036cd:	5f                   	pop    %edi
  8036ce:	5d                   	pop    %ebp
  8036cf:	c3                   	ret    
  8036d0:	39 f0                	cmp    %esi,%eax
  8036d2:	0f 87 ac 00 00 00    	ja     803784 <__umoddi3+0xfc>
  8036d8:	0f bd e8             	bsr    %eax,%ebp
  8036db:	83 f5 1f             	xor    $0x1f,%ebp
  8036de:	0f 84 ac 00 00 00    	je     803790 <__umoddi3+0x108>
  8036e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036e9:	29 ef                	sub    %ebp,%edi
  8036eb:	89 fe                	mov    %edi,%esi
  8036ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036f1:	89 e9                	mov    %ebp,%ecx
  8036f3:	d3 e0                	shl    %cl,%eax
  8036f5:	89 d7                	mov    %edx,%edi
  8036f7:	89 f1                	mov    %esi,%ecx
  8036f9:	d3 ef                	shr    %cl,%edi
  8036fb:	09 c7                	or     %eax,%edi
  8036fd:	89 e9                	mov    %ebp,%ecx
  8036ff:	d3 e2                	shl    %cl,%edx
  803701:	89 14 24             	mov    %edx,(%esp)
  803704:	89 d8                	mov    %ebx,%eax
  803706:	d3 e0                	shl    %cl,%eax
  803708:	89 c2                	mov    %eax,%edx
  80370a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80370e:	d3 e0                	shl    %cl,%eax
  803710:	89 44 24 04          	mov    %eax,0x4(%esp)
  803714:	8b 44 24 08          	mov    0x8(%esp),%eax
  803718:	89 f1                	mov    %esi,%ecx
  80371a:	d3 e8                	shr    %cl,%eax
  80371c:	09 d0                	or     %edx,%eax
  80371e:	d3 eb                	shr    %cl,%ebx
  803720:	89 da                	mov    %ebx,%edx
  803722:	f7 f7                	div    %edi
  803724:	89 d3                	mov    %edx,%ebx
  803726:	f7 24 24             	mull   (%esp)
  803729:	89 c6                	mov    %eax,%esi
  80372b:	89 d1                	mov    %edx,%ecx
  80372d:	39 d3                	cmp    %edx,%ebx
  80372f:	0f 82 87 00 00 00    	jb     8037bc <__umoddi3+0x134>
  803735:	0f 84 91 00 00 00    	je     8037cc <__umoddi3+0x144>
  80373b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80373f:	29 f2                	sub    %esi,%edx
  803741:	19 cb                	sbb    %ecx,%ebx
  803743:	89 d8                	mov    %ebx,%eax
  803745:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803749:	d3 e0                	shl    %cl,%eax
  80374b:	89 e9                	mov    %ebp,%ecx
  80374d:	d3 ea                	shr    %cl,%edx
  80374f:	09 d0                	or     %edx,%eax
  803751:	89 e9                	mov    %ebp,%ecx
  803753:	d3 eb                	shr    %cl,%ebx
  803755:	89 da                	mov    %ebx,%edx
  803757:	83 c4 1c             	add    $0x1c,%esp
  80375a:	5b                   	pop    %ebx
  80375b:	5e                   	pop    %esi
  80375c:	5f                   	pop    %edi
  80375d:	5d                   	pop    %ebp
  80375e:	c3                   	ret    
  80375f:	90                   	nop
  803760:	89 fd                	mov    %edi,%ebp
  803762:	85 ff                	test   %edi,%edi
  803764:	75 0b                	jne    803771 <__umoddi3+0xe9>
  803766:	b8 01 00 00 00       	mov    $0x1,%eax
  80376b:	31 d2                	xor    %edx,%edx
  80376d:	f7 f7                	div    %edi
  80376f:	89 c5                	mov    %eax,%ebp
  803771:	89 f0                	mov    %esi,%eax
  803773:	31 d2                	xor    %edx,%edx
  803775:	f7 f5                	div    %ebp
  803777:	89 c8                	mov    %ecx,%eax
  803779:	f7 f5                	div    %ebp
  80377b:	89 d0                	mov    %edx,%eax
  80377d:	e9 44 ff ff ff       	jmp    8036c6 <__umoddi3+0x3e>
  803782:	66 90                	xchg   %ax,%ax
  803784:	89 c8                	mov    %ecx,%eax
  803786:	89 f2                	mov    %esi,%edx
  803788:	83 c4 1c             	add    $0x1c,%esp
  80378b:	5b                   	pop    %ebx
  80378c:	5e                   	pop    %esi
  80378d:	5f                   	pop    %edi
  80378e:	5d                   	pop    %ebp
  80378f:	c3                   	ret    
  803790:	3b 04 24             	cmp    (%esp),%eax
  803793:	72 06                	jb     80379b <__umoddi3+0x113>
  803795:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803799:	77 0f                	ja     8037aa <__umoddi3+0x122>
  80379b:	89 f2                	mov    %esi,%edx
  80379d:	29 f9                	sub    %edi,%ecx
  80379f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037a3:	89 14 24             	mov    %edx,(%esp)
  8037a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037ae:	8b 14 24             	mov    (%esp),%edx
  8037b1:	83 c4 1c             	add    $0x1c,%esp
  8037b4:	5b                   	pop    %ebx
  8037b5:	5e                   	pop    %esi
  8037b6:	5f                   	pop    %edi
  8037b7:	5d                   	pop    %ebp
  8037b8:	c3                   	ret    
  8037b9:	8d 76 00             	lea    0x0(%esi),%esi
  8037bc:	2b 04 24             	sub    (%esp),%eax
  8037bf:	19 fa                	sbb    %edi,%edx
  8037c1:	89 d1                	mov    %edx,%ecx
  8037c3:	89 c6                	mov    %eax,%esi
  8037c5:	e9 71 ff ff ff       	jmp    80373b <__umoddi3+0xb3>
  8037ca:	66 90                	xchg   %ax,%ax
  8037cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037d0:	72 ea                	jb     8037bc <__umoddi3+0x134>
  8037d2:	89 d9                	mov    %ebx,%ecx
  8037d4:	e9 62 ff ff ff       	jmp    80373b <__umoddi3+0xb3>
