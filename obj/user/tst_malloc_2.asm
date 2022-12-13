
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
  800090:	68 40 38 80 00       	push   $0x803840
  800095:	6a 1a                	push   $0x1a
  800097:	68 5c 38 80 00       	push   $0x80385c
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
  800282:	68 70 38 80 00       	push   $0x803870
  800287:	6a 45                	push   $0x45
  800289:	68 5c 38 80 00       	push   $0x80385c
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
  8002b7:	68 70 38 80 00       	push   $0x803870
  8002bc:	6a 46                	push   $0x46
  8002be:	68 5c 38 80 00       	push   $0x80385c
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
  8002eb:	68 70 38 80 00       	push   $0x803870
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 5c 38 80 00       	push   $0x80385c
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
  80031f:	68 70 38 80 00       	push   $0x803870
  800324:	6a 49                	push   $0x49
  800326:	68 5c 38 80 00       	push   $0x80385c
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
  800359:	68 70 38 80 00       	push   $0x803870
  80035e:	6a 4a                	push   $0x4a
  800360:	68 5c 38 80 00       	push   $0x80385c
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
  80038f:	68 70 38 80 00       	push   $0x803870
  800394:	6a 4b                	push   $0x4b
  800396:	68 5c 38 80 00       	push   $0x80385c
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 a8 38 80 00       	push   $0x8038a8
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
  8003bc:	e8 22 19 00 00       	call   801ce3 <sys_getenvindex>
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
  800427:	e8 c4 16 00 00       	call   801af0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 fc 38 80 00       	push   $0x8038fc
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
  800457:	68 24 39 80 00       	push   $0x803924
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
  800488:	68 4c 39 80 00       	push   $0x80394c
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 50 80 00       	mov    0x805020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 a4 39 80 00       	push   $0x8039a4
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 fc 38 80 00       	push   $0x8038fc
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 44 16 00 00       	call   801b0a <sys_enable_interrupt>

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
  8004d9:	e8 d1 17 00 00       	call   801caf <sys_destroy_env>
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
  8004ea:	e8 26 18 00 00       	call   801d15 <sys_exit_env>
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
  800513:	68 b8 39 80 00       	push   $0x8039b8
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 50 80 00       	mov    0x805000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 bd 39 80 00       	push   $0x8039bd
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
  800550:	68 d9 39 80 00       	push   $0x8039d9
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
  80057c:	68 dc 39 80 00       	push   $0x8039dc
  800581:	6a 26                	push   $0x26
  800583:	68 28 3a 80 00       	push   $0x803a28
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
  80064e:	68 34 3a 80 00       	push   $0x803a34
  800653:	6a 3a                	push   $0x3a
  800655:	68 28 3a 80 00       	push   $0x803a28
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
  8006be:	68 88 3a 80 00       	push   $0x803a88
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 28 3a 80 00       	push   $0x803a28
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
  800718:	e8 25 12 00 00       	call   801942 <sys_cputs>
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
  80078f:	e8 ae 11 00 00       	call   801942 <sys_cputs>
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
  8007d9:	e8 12 13 00 00       	call   801af0 <sys_disable_interrupt>
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
  8007f9:	e8 0c 13 00 00       	call   801b0a <sys_enable_interrupt>
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
  800843:	e8 80 2d 00 00       	call   8035c8 <__udivdi3>
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
  800893:	e8 40 2e 00 00       	call   8036d8 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 f4 3c 80 00       	add    $0x803cf4,%eax
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
  8009ee:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
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
  800acf:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 05 3d 80 00       	push   $0x803d05
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
  800af4:	68 0e 3d 80 00       	push   $0x803d0e
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
  800b21:	be 11 3d 80 00       	mov    $0x803d11,%esi
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
  801547:	68 70 3e 80 00       	push   $0x803e70
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
  801617:	e8 6a 04 00 00       	call   801a86 <sys_allocate_chunk>
  80161c:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80161f:	a1 20 51 80 00       	mov    0x805120,%eax
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	50                   	push   %eax
  801628:	e8 df 0a 00 00       	call   80210c <initialize_MemBlocksList>
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
  801655:	68 95 3e 80 00       	push   $0x803e95
  80165a:	6a 33                	push   $0x33
  80165c:	68 b3 3e 80 00       	push   $0x803eb3
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
  8016d4:	68 c0 3e 80 00       	push   $0x803ec0
  8016d9:	6a 34                	push   $0x34
  8016db:	68 b3 3e 80 00       	push   $0x803eb3
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
  801731:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801734:	e8 f7 fd ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  801739:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80173d:	75 07                	jne    801746 <malloc+0x18>
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
  801744:	eb 61                	jmp    8017a7 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801746:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80174d:	8b 55 08             	mov    0x8(%ebp),%edx
  801750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801753:	01 d0                	add    %edx,%eax
  801755:	48                   	dec    %eax
  801756:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175c:	ba 00 00 00 00       	mov    $0x0,%edx
  801761:	f7 75 f0             	divl   -0x10(%ebp)
  801764:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801767:	29 d0                	sub    %edx,%eax
  801769:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80176c:	e8 e3 06 00 00       	call   801e54 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801771:	85 c0                	test   %eax,%eax
  801773:	74 11                	je     801786 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	ff 75 e8             	pushl  -0x18(%ebp)
  80177b:	e8 4e 0d 00 00       	call   8024ce <alloc_block_FF>
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801786:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80178a:	74 16                	je     8017a2 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80178c:	83 ec 0c             	sub    $0xc,%esp
  80178f:	ff 75 f4             	pushl  -0xc(%ebp)
  801792:	e8 aa 0a 00 00       	call   802241 <insert_sorted_allocList>
  801797:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179d:	8b 40 08             	mov    0x8(%eax),%eax
  8017a0:	eb 05                	jmp    8017a7 <malloc+0x79>
	}

    return NULL;
  8017a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8017af:	83 ec 04             	sub    $0x4,%esp
  8017b2:	68 e4 3e 80 00       	push   $0x803ee4
  8017b7:	6a 6f                	push   $0x6f
  8017b9:	68 b3 3e 80 00       	push   $0x803eb3
  8017be:	e8 2f ed ff ff       	call   8004f2 <_panic>

008017c3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 38             	sub    $0x38,%esp
  8017c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cc:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017cf:	e8 5c fd ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017d8:	75 07                	jne    8017e1 <smalloc+0x1e>
  8017da:	b8 00 00 00 00       	mov    $0x0,%eax
  8017df:	eb 7c                	jmp    80185d <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017e1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ee:	01 d0                	add    %edx,%eax
  8017f0:	48                   	dec    %eax
  8017f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fc:	f7 75 f0             	divl   -0x10(%ebp)
  8017ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801802:	29 d0                	sub    %edx,%eax
  801804:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801807:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80180e:	e8 41 06 00 00       	call   801e54 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801813:	85 c0                	test   %eax,%eax
  801815:	74 11                	je     801828 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801817:	83 ec 0c             	sub    $0xc,%esp
  80181a:	ff 75 e8             	pushl  -0x18(%ebp)
  80181d:	e8 ac 0c 00 00       	call   8024ce <alloc_block_FF>
  801822:	83 c4 10             	add    $0x10,%esp
  801825:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80182c:	74 2a                	je     801858 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801831:	8b 40 08             	mov    0x8(%eax),%eax
  801834:	89 c2                	mov    %eax,%edx
  801836:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80183a:	52                   	push   %edx
  80183b:	50                   	push   %eax
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	e8 92 03 00 00       	call   801bd9 <sys_createSharedObject>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80184d:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801851:	74 05                	je     801858 <smalloc+0x95>
			return (void*)virtual_address;
  801853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801856:	eb 05                	jmp    80185d <smalloc+0x9a>
	}
	return NULL;
  801858:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801865:	e8 c6 fc ff ff       	call   801530 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	68 08 3f 80 00       	push   $0x803f08
  801872:	68 b0 00 00 00       	push   $0xb0
  801877:	68 b3 3e 80 00       	push   $0x803eb3
  80187c:	e8 71 ec ff ff       	call   8004f2 <_panic>

00801881 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801887:	e8 a4 fc ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	68 2c 3f 80 00       	push   $0x803f2c
  801894:	68 f4 00 00 00       	push   $0xf4
  801899:	68 b3 3e 80 00       	push   $0x803eb3
  80189e:	e8 4f ec ff ff       	call   8004f2 <_panic>

008018a3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	68 54 3f 80 00       	push   $0x803f54
  8018b1:	68 08 01 00 00       	push   $0x108
  8018b6:	68 b3 3e 80 00       	push   $0x803eb3
  8018bb:	e8 32 ec ff ff       	call   8004f2 <_panic>

008018c0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	68 78 3f 80 00       	push   $0x803f78
  8018ce:	68 13 01 00 00       	push   $0x113
  8018d3:	68 b3 3e 80 00       	push   $0x803eb3
  8018d8:	e8 15 ec ff ff       	call   8004f2 <_panic>

008018dd <shrink>:

}
void shrink(uint32 newSize)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e3:	83 ec 04             	sub    $0x4,%esp
  8018e6:	68 78 3f 80 00       	push   $0x803f78
  8018eb:	68 18 01 00 00       	push   $0x118
  8018f0:	68 b3 3e 80 00       	push   $0x803eb3
  8018f5:	e8 f8 eb ff ff       	call   8004f2 <_panic>

008018fa <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801900:	83 ec 04             	sub    $0x4,%esp
  801903:	68 78 3f 80 00       	push   $0x803f78
  801908:	68 1d 01 00 00       	push   $0x11d
  80190d:	68 b3 3e 80 00       	push   $0x803eb3
  801912:	e8 db eb ff ff       	call   8004f2 <_panic>

00801917 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	57                   	push   %edi
  80191b:	56                   	push   %esi
  80191c:	53                   	push   %ebx
  80191d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	8b 55 0c             	mov    0xc(%ebp),%edx
  801926:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801929:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80192c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80192f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801932:	cd 30                	int    $0x30
  801934:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801937:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	5b                   	pop    %ebx
  80193e:	5e                   	pop    %esi
  80193f:	5f                   	pop    %edi
  801940:	5d                   	pop    %ebp
  801941:	c3                   	ret    

00801942 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	8b 45 10             	mov    0x10(%ebp),%eax
  80194b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80194e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	52                   	push   %edx
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	50                   	push   %eax
  80195e:	6a 00                	push   $0x0
  801960:	e8 b2 ff ff ff       	call   801917 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	90                   	nop
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_cgetc>:

int
sys_cgetc(void)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 01                	push   $0x1
  80197a:	e8 98 ff ff ff       	call   801917 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	52                   	push   %edx
  801994:	50                   	push   %eax
  801995:	6a 05                	push   $0x5
  801997:	e8 7b ff ff ff       	call   801917 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	56                   	push   %esi
  8019a5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019a6:	8b 75 18             	mov    0x18(%ebp),%esi
  8019a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	56                   	push   %esi
  8019b6:	53                   	push   %ebx
  8019b7:	51                   	push   %ecx
  8019b8:	52                   	push   %edx
  8019b9:	50                   	push   %eax
  8019ba:	6a 06                	push   $0x6
  8019bc:	e8 56 ff ff ff       	call   801917 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c7:	5b                   	pop    %ebx
  8019c8:	5e                   	pop    %esi
  8019c9:	5d                   	pop    %ebp
  8019ca:	c3                   	ret    

008019cb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	52                   	push   %edx
  8019db:	50                   	push   %eax
  8019dc:	6a 07                	push   $0x7
  8019de:	e8 34 ff ff ff       	call   801917 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	ff 75 08             	pushl  0x8(%ebp)
  8019f7:	6a 08                	push   $0x8
  8019f9:	e8 19 ff ff ff       	call   801917 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 09                	push   $0x9
  801a12:	e8 00 ff ff ff       	call   801917 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 0a                	push   $0xa
  801a2b:	e8 e7 fe ff ff       	call   801917 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 0b                	push   $0xb
  801a44:	e8 ce fe ff ff       	call   801917 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	ff 75 08             	pushl  0x8(%ebp)
  801a5d:	6a 0f                	push   $0xf
  801a5f:	e8 b3 fe ff ff       	call   801917 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
	return;
  801a67:	90                   	nop
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	ff 75 0c             	pushl  0xc(%ebp)
  801a76:	ff 75 08             	pushl  0x8(%ebp)
  801a79:	6a 10                	push   $0x10
  801a7b:	e8 97 fe ff ff       	call   801917 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
	return ;
  801a83:	90                   	nop
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	ff 75 10             	pushl  0x10(%ebp)
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	ff 75 08             	pushl  0x8(%ebp)
  801a96:	6a 11                	push   $0x11
  801a98:	e8 7a fe ff ff       	call   801917 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa0:	90                   	nop
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 0c                	push   $0xc
  801ab2:	e8 60 fe ff ff       	call   801917 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	ff 75 08             	pushl  0x8(%ebp)
  801aca:	6a 0d                	push   $0xd
  801acc:	e8 46 fe ff ff       	call   801917 <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 0e                	push   $0xe
  801ae5:	e8 2d fe ff ff       	call   801917 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	90                   	nop
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 13                	push   $0x13
  801aff:	e8 13 fe ff ff       	call   801917 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	90                   	nop
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 14                	push   $0x14
  801b19:	e8 f9 fd ff ff       	call   801917 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 04             	sub    $0x4,%esp
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	50                   	push   %eax
  801b3d:	6a 15                	push   $0x15
  801b3f:	e8 d3 fd ff ff       	call   801917 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 16                	push   $0x16
  801b59:	e8 b9 fd ff ff       	call   801917 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	50                   	push   %eax
  801b74:	6a 17                	push   $0x17
  801b76:	e8 9c fd ff ff       	call   801917 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	52                   	push   %edx
  801b90:	50                   	push   %eax
  801b91:	6a 1a                	push   $0x1a
  801b93:	e8 7f fd ff ff       	call   801917 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	52                   	push   %edx
  801bad:	50                   	push   %eax
  801bae:	6a 18                	push   $0x18
  801bb0:	e8 62 fd ff ff       	call   801917 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	90                   	nop
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	52                   	push   %edx
  801bcb:	50                   	push   %eax
  801bcc:	6a 19                	push   $0x19
  801bce:	e8 44 fd ff ff       	call   801917 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	90                   	nop
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 04             	sub    $0x4,%esp
  801bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  801be2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801be5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801be8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	6a 00                	push   $0x0
  801bf1:	51                   	push   %ecx
  801bf2:	52                   	push   %edx
  801bf3:	ff 75 0c             	pushl  0xc(%ebp)
  801bf6:	50                   	push   %eax
  801bf7:	6a 1b                	push   $0x1b
  801bf9:	e8 19 fd ff ff       	call   801917 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	52                   	push   %edx
  801c13:	50                   	push   %eax
  801c14:	6a 1c                	push   $0x1c
  801c16:	e8 fc fc ff ff       	call   801917 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	51                   	push   %ecx
  801c31:	52                   	push   %edx
  801c32:	50                   	push   %eax
  801c33:	6a 1d                	push   $0x1d
  801c35:	e8 dd fc ff ff       	call   801917 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	52                   	push   %edx
  801c4f:	50                   	push   %eax
  801c50:	6a 1e                	push   $0x1e
  801c52:	e8 c0 fc ff ff       	call   801917 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 1f                	push   $0x1f
  801c6b:	e8 a7 fc ff ff       	call   801917 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	6a 00                	push   $0x0
  801c7d:	ff 75 14             	pushl  0x14(%ebp)
  801c80:	ff 75 10             	pushl  0x10(%ebp)
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	50                   	push   %eax
  801c87:	6a 20                	push   $0x20
  801c89:	e8 89 fc ff ff       	call   801917 <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	50                   	push   %eax
  801ca2:	6a 21                	push   $0x21
  801ca4:	e8 6e fc ff ff       	call   801917 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	90                   	nop
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	50                   	push   %eax
  801cbe:	6a 22                	push   $0x22
  801cc0:	e8 52 fc ff ff       	call   801917 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 02                	push   $0x2
  801cd9:	e8 39 fc ff ff       	call   801917 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 03                	push   $0x3
  801cf2:	e8 20 fc ff ff       	call   801917 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 04                	push   $0x4
  801d0b:	e8 07 fc ff ff       	call   801917 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_exit_env>:


void sys_exit_env(void)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 23                	push   $0x23
  801d24:	e8 ee fb ff ff       	call   801917 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	90                   	nop
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d35:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d38:	8d 50 04             	lea    0x4(%eax),%edx
  801d3b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	52                   	push   %edx
  801d45:	50                   	push   %eax
  801d46:	6a 24                	push   $0x24
  801d48:	e8 ca fb ff ff       	call   801917 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
	return result;
  801d50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d59:	89 01                	mov    %eax,(%ecx)
  801d5b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	c9                   	leave  
  801d62:	c2 04 00             	ret    $0x4

00801d65 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	ff 75 10             	pushl  0x10(%ebp)
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	ff 75 08             	pushl  0x8(%ebp)
  801d75:	6a 12                	push   $0x12
  801d77:	e8 9b fb ff ff       	call   801917 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7f:	90                   	nop
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 25                	push   $0x25
  801d91:	e8 81 fb ff ff       	call   801917 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801da7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	50                   	push   %eax
  801db4:	6a 26                	push   $0x26
  801db6:	e8 5c fb ff ff       	call   801917 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbe:	90                   	nop
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <rsttst>:
void rsttst()
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 28                	push   $0x28
  801dd0:	e8 42 fb ff ff       	call   801917 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd8:	90                   	nop
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	83 ec 04             	sub    $0x4,%esp
  801de1:	8b 45 14             	mov    0x14(%ebp),%eax
  801de4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801de7:	8b 55 18             	mov    0x18(%ebp),%edx
  801dea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dee:	52                   	push   %edx
  801def:	50                   	push   %eax
  801df0:	ff 75 10             	pushl  0x10(%ebp)
  801df3:	ff 75 0c             	pushl  0xc(%ebp)
  801df6:	ff 75 08             	pushl  0x8(%ebp)
  801df9:	6a 27                	push   $0x27
  801dfb:	e8 17 fb ff ff       	call   801917 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
	return ;
  801e03:	90                   	nop
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <chktst>:
void chktst(uint32 n)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	ff 75 08             	pushl  0x8(%ebp)
  801e14:	6a 29                	push   $0x29
  801e16:	e8 fc fa ff ff       	call   801917 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1e:	90                   	nop
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <inctst>:

void inctst()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 2a                	push   $0x2a
  801e30:	e8 e2 fa ff ff       	call   801917 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
	return ;
  801e38:	90                   	nop
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <gettst>:
uint32 gettst()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 2b                	push   $0x2b
  801e4a:	e8 c8 fa ff ff       	call   801917 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 2c                	push   $0x2c
  801e66:	e8 ac fa ff ff       	call   801917 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
  801e6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e71:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e75:	75 07                	jne    801e7e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e77:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7c:	eb 05                	jmp    801e83 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 2c                	push   $0x2c
  801e97:	e8 7b fa ff ff       	call   801917 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
  801e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ea2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ea6:	75 07                	jne    801eaf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ea8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ead:	eb 05                	jmp    801eb4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 2c                	push   $0x2c
  801ec8:	e8 4a fa ff ff       	call   801917 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
  801ed0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ed3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ed7:	75 07                	jne    801ee0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ed9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ede:	eb 05                	jmp    801ee5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ee0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 2c                	push   $0x2c
  801ef9:	e8 19 fa ff ff       	call   801917 <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
  801f01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f04:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f08:	75 07                	jne    801f11 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0f:	eb 05                	jmp    801f16 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	ff 75 08             	pushl  0x8(%ebp)
  801f26:	6a 2d                	push   $0x2d
  801f28:	e8 ea f9 ff ff       	call   801917 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f30:	90                   	nop
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f37:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	6a 00                	push   $0x0
  801f45:	53                   	push   %ebx
  801f46:	51                   	push   %ecx
  801f47:	52                   	push   %edx
  801f48:	50                   	push   %eax
  801f49:	6a 2e                	push   $0x2e
  801f4b:	e8 c7 f9 ff ff       	call   801917 <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	52                   	push   %edx
  801f68:	50                   	push   %eax
  801f69:	6a 2f                	push   $0x2f
  801f6b:	e8 a7 f9 ff ff       	call   801917 <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	68 88 3f 80 00       	push   $0x803f88
  801f83:	e8 1e e8 ff ff       	call   8007a6 <cprintf>
  801f88:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f92:	83 ec 0c             	sub    $0xc,%esp
  801f95:	68 b4 3f 80 00       	push   $0x803fb4
  801f9a:	e8 07 e8 ff ff       	call   8007a6 <cprintf>
  801f9f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fa2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fa6:	a1 38 51 80 00       	mov    0x805138,%eax
  801fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fae:	eb 56                	jmp    802006 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb4:	74 1c                	je     801fd2 <print_mem_block_lists+0x5d>
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	8b 50 08             	mov    0x8(%eax),%edx
  801fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbf:	8b 48 08             	mov    0x8(%eax),%ecx
  801fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc8:	01 c8                	add    %ecx,%eax
  801fca:	39 c2                	cmp    %eax,%edx
  801fcc:	73 04                	jae    801fd2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fce:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	8b 50 08             	mov    0x8(%eax),%edx
  801fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdb:	8b 40 0c             	mov    0xc(%eax),%eax
  801fde:	01 c2                	add    %eax,%edx
  801fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe3:	8b 40 08             	mov    0x8(%eax),%eax
  801fe6:	83 ec 04             	sub    $0x4,%esp
  801fe9:	52                   	push   %edx
  801fea:	50                   	push   %eax
  801feb:	68 c9 3f 80 00       	push   $0x803fc9
  801ff0:	e8 b1 e7 ff ff       	call   8007a6 <cprintf>
  801ff5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ffe:	a1 40 51 80 00       	mov    0x805140,%eax
  802003:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802006:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200a:	74 07                	je     802013 <print_mem_block_lists+0x9e>
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200f:	8b 00                	mov    (%eax),%eax
  802011:	eb 05                	jmp    802018 <print_mem_block_lists+0xa3>
  802013:	b8 00 00 00 00       	mov    $0x0,%eax
  802018:	a3 40 51 80 00       	mov    %eax,0x805140
  80201d:	a1 40 51 80 00       	mov    0x805140,%eax
  802022:	85 c0                	test   %eax,%eax
  802024:	75 8a                	jne    801fb0 <print_mem_block_lists+0x3b>
  802026:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202a:	75 84                	jne    801fb0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80202c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802030:	75 10                	jne    802042 <print_mem_block_lists+0xcd>
  802032:	83 ec 0c             	sub    $0xc,%esp
  802035:	68 d8 3f 80 00       	push   $0x803fd8
  80203a:	e8 67 e7 ff ff       	call   8007a6 <cprintf>
  80203f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	68 fc 3f 80 00       	push   $0x803ffc
  802051:	e8 50 e7 ff ff       	call   8007a6 <cprintf>
  802056:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802059:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80205d:	a1 40 50 80 00       	mov    0x805040,%eax
  802062:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802065:	eb 56                	jmp    8020bd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802067:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80206b:	74 1c                	je     802089 <print_mem_block_lists+0x114>
  80206d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802070:	8b 50 08             	mov    0x8(%eax),%edx
  802073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802076:	8b 48 08             	mov    0x8(%eax),%ecx
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207c:	8b 40 0c             	mov    0xc(%eax),%eax
  80207f:	01 c8                	add    %ecx,%eax
  802081:	39 c2                	cmp    %eax,%edx
  802083:	73 04                	jae    802089 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802085:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	8b 50 08             	mov    0x8(%eax),%edx
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	8b 40 0c             	mov    0xc(%eax),%eax
  802095:	01 c2                	add    %eax,%edx
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	8b 40 08             	mov    0x8(%eax),%eax
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	52                   	push   %edx
  8020a1:	50                   	push   %eax
  8020a2:	68 c9 3f 80 00       	push   $0x803fc9
  8020a7:	e8 fa e6 ff ff       	call   8007a6 <cprintf>
  8020ac:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020b5:	a1 48 50 80 00       	mov    0x805048,%eax
  8020ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c1:	74 07                	je     8020ca <print_mem_block_lists+0x155>
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	8b 00                	mov    (%eax),%eax
  8020c8:	eb 05                	jmp    8020cf <print_mem_block_lists+0x15a>
  8020ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cf:	a3 48 50 80 00       	mov    %eax,0x805048
  8020d4:	a1 48 50 80 00       	mov    0x805048,%eax
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	75 8a                	jne    802067 <print_mem_block_lists+0xf2>
  8020dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e1:	75 84                	jne    802067 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020e3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020e7:	75 10                	jne    8020f9 <print_mem_block_lists+0x184>
  8020e9:	83 ec 0c             	sub    $0xc,%esp
  8020ec:	68 14 40 80 00       	push   $0x804014
  8020f1:	e8 b0 e6 ff ff       	call   8007a6 <cprintf>
  8020f6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020f9:	83 ec 0c             	sub    $0xc,%esp
  8020fc:	68 88 3f 80 00       	push   $0x803f88
  802101:	e8 a0 e6 ff ff       	call   8007a6 <cprintf>
  802106:	83 c4 10             	add    $0x10,%esp

}
  802109:	90                   	nop
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802112:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802119:	00 00 00 
  80211c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802123:	00 00 00 
  802126:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80212d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802130:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802137:	e9 9e 00 00 00       	jmp    8021da <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80213c:	a1 50 50 80 00       	mov    0x805050,%eax
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	c1 e2 04             	shl    $0x4,%edx
  802147:	01 d0                	add    %edx,%eax
  802149:	85 c0                	test   %eax,%eax
  80214b:	75 14                	jne    802161 <initialize_MemBlocksList+0x55>
  80214d:	83 ec 04             	sub    $0x4,%esp
  802150:	68 3c 40 80 00       	push   $0x80403c
  802155:	6a 46                	push   $0x46
  802157:	68 5f 40 80 00       	push   $0x80405f
  80215c:	e8 91 e3 ff ff       	call   8004f2 <_panic>
  802161:	a1 50 50 80 00       	mov    0x805050,%eax
  802166:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802169:	c1 e2 04             	shl    $0x4,%edx
  80216c:	01 d0                	add    %edx,%eax
  80216e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802174:	89 10                	mov    %edx,(%eax)
  802176:	8b 00                	mov    (%eax),%eax
  802178:	85 c0                	test   %eax,%eax
  80217a:	74 18                	je     802194 <initialize_MemBlocksList+0x88>
  80217c:	a1 48 51 80 00       	mov    0x805148,%eax
  802181:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802187:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80218a:	c1 e1 04             	shl    $0x4,%ecx
  80218d:	01 ca                	add    %ecx,%edx
  80218f:	89 50 04             	mov    %edx,0x4(%eax)
  802192:	eb 12                	jmp    8021a6 <initialize_MemBlocksList+0x9a>
  802194:	a1 50 50 80 00       	mov    0x805050,%eax
  802199:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219c:	c1 e2 04             	shl    $0x4,%edx
  80219f:	01 d0                	add    %edx,%eax
  8021a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021a6:	a1 50 50 80 00       	mov    0x805050,%eax
  8021ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ae:	c1 e2 04             	shl    $0x4,%edx
  8021b1:	01 d0                	add    %edx,%eax
  8021b3:	a3 48 51 80 00       	mov    %eax,0x805148
  8021b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8021bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c0:	c1 e2 04             	shl    $0x4,%edx
  8021c3:	01 d0                	add    %edx,%eax
  8021c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8021d1:	40                   	inc    %eax
  8021d2:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021d7:	ff 45 f4             	incl   -0xc(%ebp)
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021e0:	0f 82 56 ff ff ff    	jb     80213c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021e6:	90                   	nop
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	8b 00                	mov    (%eax),%eax
  8021f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021f7:	eb 19                	jmp    802212 <find_block+0x29>
	{
		if(va==point->sva)
  8021f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021fc:	8b 40 08             	mov    0x8(%eax),%eax
  8021ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802202:	75 05                	jne    802209 <find_block+0x20>
		   return point;
  802204:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802207:	eb 36                	jmp    80223f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	8b 40 08             	mov    0x8(%eax),%eax
  80220f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802212:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802216:	74 07                	je     80221f <find_block+0x36>
  802218:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221b:	8b 00                	mov    (%eax),%eax
  80221d:	eb 05                	jmp    802224 <find_block+0x3b>
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
  802224:	8b 55 08             	mov    0x8(%ebp),%edx
  802227:	89 42 08             	mov    %eax,0x8(%edx)
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	8b 40 08             	mov    0x8(%eax),%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	75 c5                	jne    8021f9 <find_block+0x10>
  802234:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802238:	75 bf                	jne    8021f9 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80223a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802247:	a1 40 50 80 00       	mov    0x805040,%eax
  80224c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80224f:	a1 44 50 80 00       	mov    0x805044,%eax
  802254:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80225d:	74 24                	je     802283 <insert_sorted_allocList+0x42>
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	8b 50 08             	mov    0x8(%eax),%edx
  802265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802268:	8b 40 08             	mov    0x8(%eax),%eax
  80226b:	39 c2                	cmp    %eax,%edx
  80226d:	76 14                	jbe    802283 <insert_sorted_allocList+0x42>
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	8b 50 08             	mov    0x8(%eax),%edx
  802275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802278:	8b 40 08             	mov    0x8(%eax),%eax
  80227b:	39 c2                	cmp    %eax,%edx
  80227d:	0f 82 60 01 00 00    	jb     8023e3 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802283:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802287:	75 65                	jne    8022ee <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228d:	75 14                	jne    8022a3 <insert_sorted_allocList+0x62>
  80228f:	83 ec 04             	sub    $0x4,%esp
  802292:	68 3c 40 80 00       	push   $0x80403c
  802297:	6a 6b                	push   $0x6b
  802299:	68 5f 40 80 00       	push   $0x80405f
  80229e:	e8 4f e2 ff ff       	call   8004f2 <_panic>
  8022a3:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	89 10                	mov    %edx,(%eax)
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	74 0d                	je     8022c4 <insert_sorted_allocList+0x83>
  8022b7:	a1 40 50 80 00       	mov    0x805040,%eax
  8022bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bf:	89 50 04             	mov    %edx,0x4(%eax)
  8022c2:	eb 08                	jmp    8022cc <insert_sorted_allocList+0x8b>
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 44 50 80 00       	mov    %eax,0x805044
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	a3 40 50 80 00       	mov    %eax,0x805040
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022de:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022e3:	40                   	inc    %eax
  8022e4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022e9:	e9 dc 01 00 00       	jmp    8024ca <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	8b 50 08             	mov    0x8(%eax),%edx
  8022f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f7:	8b 40 08             	mov    0x8(%eax),%eax
  8022fa:	39 c2                	cmp    %eax,%edx
  8022fc:	77 6c                	ja     80236a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802302:	74 06                	je     80230a <insert_sorted_allocList+0xc9>
  802304:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802308:	75 14                	jne    80231e <insert_sorted_allocList+0xdd>
  80230a:	83 ec 04             	sub    $0x4,%esp
  80230d:	68 78 40 80 00       	push   $0x804078
  802312:	6a 6f                	push   $0x6f
  802314:	68 5f 40 80 00       	push   $0x80405f
  802319:	e8 d4 e1 ff ff       	call   8004f2 <_panic>
  80231e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802321:	8b 50 04             	mov    0x4(%eax),%edx
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	89 50 04             	mov    %edx,0x4(%eax)
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802330:	89 10                	mov    %edx,(%eax)
  802332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802335:	8b 40 04             	mov    0x4(%eax),%eax
  802338:	85 c0                	test   %eax,%eax
  80233a:	74 0d                	je     802349 <insert_sorted_allocList+0x108>
  80233c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233f:	8b 40 04             	mov    0x4(%eax),%eax
  802342:	8b 55 08             	mov    0x8(%ebp),%edx
  802345:	89 10                	mov    %edx,(%eax)
  802347:	eb 08                	jmp    802351 <insert_sorted_allocList+0x110>
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	a3 40 50 80 00       	mov    %eax,0x805040
  802351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	89 50 04             	mov    %edx,0x4(%eax)
  80235a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80235f:	40                   	inc    %eax
  802360:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802365:	e9 60 01 00 00       	jmp    8024ca <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80236a:	8b 45 08             	mov    0x8(%ebp),%eax
  80236d:	8b 50 08             	mov    0x8(%eax),%edx
  802370:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802373:	8b 40 08             	mov    0x8(%eax),%eax
  802376:	39 c2                	cmp    %eax,%edx
  802378:	0f 82 4c 01 00 00    	jb     8024ca <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80237e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802382:	75 14                	jne    802398 <insert_sorted_allocList+0x157>
  802384:	83 ec 04             	sub    $0x4,%esp
  802387:	68 b0 40 80 00       	push   $0x8040b0
  80238c:	6a 73                	push   $0x73
  80238e:	68 5f 40 80 00       	push   $0x80405f
  802393:	e8 5a e1 ff ff       	call   8004f2 <_panic>
  802398:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	89 50 04             	mov    %edx,0x4(%eax)
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	8b 40 04             	mov    0x4(%eax),%eax
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	74 0c                	je     8023ba <insert_sorted_allocList+0x179>
  8023ae:	a1 44 50 80 00       	mov    0x805044,%eax
  8023b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b6:	89 10                	mov    %edx,(%eax)
  8023b8:	eb 08                	jmp    8023c2 <insert_sorted_allocList+0x181>
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	a3 40 50 80 00       	mov    %eax,0x805040
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	a3 44 50 80 00       	mov    %eax,0x805044
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023d8:	40                   	inc    %eax
  8023d9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023de:	e9 e7 00 00 00       	jmp    8024ca <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023f0:	a1 40 50 80 00       	mov    0x805040,%eax
  8023f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f8:	e9 9d 00 00 00       	jmp    80249a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	8b 50 08             	mov    0x8(%eax),%edx
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 40 08             	mov    0x8(%eax),%eax
  802411:	39 c2                	cmp    %eax,%edx
  802413:	76 7d                	jbe    802492 <insert_sorted_allocList+0x251>
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	8b 50 08             	mov    0x8(%eax),%edx
  80241b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80241e:	8b 40 08             	mov    0x8(%eax),%eax
  802421:	39 c2                	cmp    %eax,%edx
  802423:	73 6d                	jae    802492 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802429:	74 06                	je     802431 <insert_sorted_allocList+0x1f0>
  80242b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80242f:	75 14                	jne    802445 <insert_sorted_allocList+0x204>
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	68 d4 40 80 00       	push   $0x8040d4
  802439:	6a 7f                	push   $0x7f
  80243b:	68 5f 40 80 00       	push   $0x80405f
  802440:	e8 ad e0 ff ff       	call   8004f2 <_panic>
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 10                	mov    (%eax),%edx
  80244a:	8b 45 08             	mov    0x8(%ebp),%eax
  80244d:	89 10                	mov    %edx,(%eax)
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	8b 00                	mov    (%eax),%eax
  802454:	85 c0                	test   %eax,%eax
  802456:	74 0b                	je     802463 <insert_sorted_allocList+0x222>
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 00                	mov    (%eax),%eax
  80245d:	8b 55 08             	mov    0x8(%ebp),%edx
  802460:	89 50 04             	mov    %edx,0x4(%eax)
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 55 08             	mov    0x8(%ebp),%edx
  802469:	89 10                	mov    %edx,(%eax)
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802471:	89 50 04             	mov    %edx,0x4(%eax)
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	75 08                	jne    802485 <insert_sorted_allocList+0x244>
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	a3 44 50 80 00       	mov    %eax,0x805044
  802485:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80248a:	40                   	inc    %eax
  80248b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802490:	eb 39                	jmp    8024cb <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802492:	a1 48 50 80 00       	mov    0x805048,%eax
  802497:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249e:	74 07                	je     8024a7 <insert_sorted_allocList+0x266>
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	eb 05                	jmp    8024ac <insert_sorted_allocList+0x26b>
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ac:	a3 48 50 80 00       	mov    %eax,0x805048
  8024b1:	a1 48 50 80 00       	mov    0x805048,%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	0f 85 3f ff ff ff    	jne    8023fd <insert_sorted_allocList+0x1bc>
  8024be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c2:	0f 85 35 ff ff ff    	jne    8023fd <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024c8:	eb 01                	jmp    8024cb <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024ca:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024cb:	90                   	nop
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024d4:	a1 38 51 80 00       	mov    0x805138,%eax
  8024d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024dc:	e9 85 01 00 00       	jmp    802666 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ea:	0f 82 6e 01 00 00    	jb     80265e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f9:	0f 85 8a 00 00 00    	jne    802589 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802503:	75 17                	jne    80251c <alloc_block_FF+0x4e>
  802505:	83 ec 04             	sub    $0x4,%esp
  802508:	68 08 41 80 00       	push   $0x804108
  80250d:	68 93 00 00 00       	push   $0x93
  802512:	68 5f 40 80 00       	push   $0x80405f
  802517:	e8 d6 df ff ff       	call   8004f2 <_panic>
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 00                	mov    (%eax),%eax
  802521:	85 c0                	test   %eax,%eax
  802523:	74 10                	je     802535 <alloc_block_FF+0x67>
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 00                	mov    (%eax),%eax
  80252a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252d:	8b 52 04             	mov    0x4(%edx),%edx
  802530:	89 50 04             	mov    %edx,0x4(%eax)
  802533:	eb 0b                	jmp    802540 <alloc_block_FF+0x72>
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 40 04             	mov    0x4(%eax),%eax
  80253b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 40 04             	mov    0x4(%eax),%eax
  802546:	85 c0                	test   %eax,%eax
  802548:	74 0f                	je     802559 <alloc_block_FF+0x8b>
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 40 04             	mov    0x4(%eax),%eax
  802550:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802553:	8b 12                	mov    (%edx),%edx
  802555:	89 10                	mov    %edx,(%eax)
  802557:	eb 0a                	jmp    802563 <alloc_block_FF+0x95>
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 00                	mov    (%eax),%eax
  80255e:	a3 38 51 80 00       	mov    %eax,0x805138
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802576:	a1 44 51 80 00       	mov    0x805144,%eax
  80257b:	48                   	dec    %eax
  80257c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	e9 10 01 00 00       	jmp    802699 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 40 0c             	mov    0xc(%eax),%eax
  80258f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802592:	0f 86 c6 00 00 00    	jbe    80265e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802598:	a1 48 51 80 00       	mov    0x805148,%eax
  80259d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 50 08             	mov    0x8(%eax),%edx
  8025a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025af:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b2:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025b9:	75 17                	jne    8025d2 <alloc_block_FF+0x104>
  8025bb:	83 ec 04             	sub    $0x4,%esp
  8025be:	68 08 41 80 00       	push   $0x804108
  8025c3:	68 9b 00 00 00       	push   $0x9b
  8025c8:	68 5f 40 80 00       	push   $0x80405f
  8025cd:	e8 20 df ff ff       	call   8004f2 <_panic>
  8025d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 10                	je     8025eb <alloc_block_FF+0x11d>
  8025db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025de:	8b 00                	mov    (%eax),%eax
  8025e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e3:	8b 52 04             	mov    0x4(%edx),%edx
  8025e6:	89 50 04             	mov    %edx,0x4(%eax)
  8025e9:	eb 0b                	jmp    8025f6 <alloc_block_FF+0x128>
  8025eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ee:	8b 40 04             	mov    0x4(%eax),%eax
  8025f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f9:	8b 40 04             	mov    0x4(%eax),%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	74 0f                	je     80260f <alloc_block_FF+0x141>
  802600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802603:	8b 40 04             	mov    0x4(%eax),%eax
  802606:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802609:	8b 12                	mov    (%edx),%edx
  80260b:	89 10                	mov    %edx,(%eax)
  80260d:	eb 0a                	jmp    802619 <alloc_block_FF+0x14b>
  80260f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	a3 48 51 80 00       	mov    %eax,0x805148
  802619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802625:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262c:	a1 54 51 80 00       	mov    0x805154,%eax
  802631:	48                   	dec    %eax
  802632:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 50 08             	mov    0x8(%eax),%edx
  80263d:	8b 45 08             	mov    0x8(%ebp),%eax
  802640:	01 c2                	add    %eax,%edx
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 40 0c             	mov    0xc(%eax),%eax
  80264e:	2b 45 08             	sub    0x8(%ebp),%eax
  802651:	89 c2                	mov    %eax,%edx
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265c:	eb 3b                	jmp    802699 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80265e:	a1 40 51 80 00       	mov    0x805140,%eax
  802663:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802666:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266a:	74 07                	je     802673 <alloc_block_FF+0x1a5>
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	eb 05                	jmp    802678 <alloc_block_FF+0x1aa>
  802673:	b8 00 00 00 00       	mov    $0x0,%eax
  802678:	a3 40 51 80 00       	mov    %eax,0x805140
  80267d:	a1 40 51 80 00       	mov    0x805140,%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	0f 85 57 fe ff ff    	jne    8024e1 <alloc_block_FF+0x13>
  80268a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268e:	0f 85 4d fe ff ff    	jne    8024e1 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8026ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b0:	e9 df 00 00 00       	jmp    802794 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026be:	0f 82 c8 00 00 00    	jb     80278c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026cd:	0f 85 8a 00 00 00    	jne    80275d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d7:	75 17                	jne    8026f0 <alloc_block_BF+0x55>
  8026d9:	83 ec 04             	sub    $0x4,%esp
  8026dc:	68 08 41 80 00       	push   $0x804108
  8026e1:	68 b7 00 00 00       	push   $0xb7
  8026e6:	68 5f 40 80 00       	push   $0x80405f
  8026eb:	e8 02 de ff ff       	call   8004f2 <_panic>
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	8b 00                	mov    (%eax),%eax
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	74 10                	je     802709 <alloc_block_BF+0x6e>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802701:	8b 52 04             	mov    0x4(%edx),%edx
  802704:	89 50 04             	mov    %edx,0x4(%eax)
  802707:	eb 0b                	jmp    802714 <alloc_block_BF+0x79>
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	74 0f                	je     80272d <alloc_block_BF+0x92>
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 40 04             	mov    0x4(%eax),%eax
  802724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802727:	8b 12                	mov    (%edx),%edx
  802729:	89 10                	mov    %edx,(%eax)
  80272b:	eb 0a                	jmp    802737 <alloc_block_BF+0x9c>
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 00                	mov    (%eax),%eax
  802732:	a3 38 51 80 00       	mov    %eax,0x805138
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274a:	a1 44 51 80 00       	mov    0x805144,%eax
  80274f:	48                   	dec    %eax
  802750:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	e9 4d 01 00 00       	jmp    8028aa <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 40 0c             	mov    0xc(%eax),%eax
  802763:	3b 45 08             	cmp    0x8(%ebp),%eax
  802766:	76 24                	jbe    80278c <alloc_block_BF+0xf1>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802771:	73 19                	jae    80278c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802773:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 40 0c             	mov    0xc(%eax),%eax
  802780:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 08             	mov    0x8(%eax),%eax
  802789:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80278c:	a1 40 51 80 00       	mov    0x805140,%eax
  802791:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802794:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802798:	74 07                	je     8027a1 <alloc_block_BF+0x106>
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	eb 05                	jmp    8027a6 <alloc_block_BF+0x10b>
  8027a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a6:	a3 40 51 80 00       	mov    %eax,0x805140
  8027ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	0f 85 fd fe ff ff    	jne    8026b5 <alloc_block_BF+0x1a>
  8027b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bc:	0f 85 f3 fe ff ff    	jne    8026b5 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027c6:	0f 84 d9 00 00 00    	je     8028a5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027cc:	a1 48 51 80 00       	mov    0x805148,%eax
  8027d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027da:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e3:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027ea:	75 17                	jne    802803 <alloc_block_BF+0x168>
  8027ec:	83 ec 04             	sub    $0x4,%esp
  8027ef:	68 08 41 80 00       	push   $0x804108
  8027f4:	68 c7 00 00 00       	push   $0xc7
  8027f9:	68 5f 40 80 00       	push   $0x80405f
  8027fe:	e8 ef dc ff ff       	call   8004f2 <_panic>
  802803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	85 c0                	test   %eax,%eax
  80280a:	74 10                	je     80281c <alloc_block_BF+0x181>
  80280c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802814:	8b 52 04             	mov    0x4(%edx),%edx
  802817:	89 50 04             	mov    %edx,0x4(%eax)
  80281a:	eb 0b                	jmp    802827 <alloc_block_BF+0x18c>
  80281c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281f:	8b 40 04             	mov    0x4(%eax),%eax
  802822:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282a:	8b 40 04             	mov    0x4(%eax),%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	74 0f                	je     802840 <alloc_block_BF+0x1a5>
  802831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802834:	8b 40 04             	mov    0x4(%eax),%eax
  802837:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80283a:	8b 12                	mov    (%edx),%edx
  80283c:	89 10                	mov    %edx,(%eax)
  80283e:	eb 0a                	jmp    80284a <alloc_block_BF+0x1af>
  802840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	a3 48 51 80 00       	mov    %eax,0x805148
  80284a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802856:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285d:	a1 54 51 80 00       	mov    0x805154,%eax
  802862:	48                   	dec    %eax
  802863:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802868:	83 ec 08             	sub    $0x8,%esp
  80286b:	ff 75 ec             	pushl  -0x14(%ebp)
  80286e:	68 38 51 80 00       	push   $0x805138
  802873:	e8 71 f9 ff ff       	call   8021e9 <find_block>
  802878:	83 c4 10             	add    $0x10,%esp
  80287b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80287e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802881:	8b 50 08             	mov    0x8(%eax),%edx
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	01 c2                	add    %eax,%edx
  802889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80288f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802892:	8b 40 0c             	mov    0xc(%eax),%eax
  802895:	2b 45 08             	sub    0x8(%ebp),%eax
  802898:	89 c2                	mov    %eax,%edx
  80289a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a3:	eb 05                	jmp    8028aa <alloc_block_BF+0x20f>
	}
	return NULL;
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028b2:	a1 28 50 80 00       	mov    0x805028,%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	0f 85 de 01 00 00    	jne    802a9d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028bf:	a1 38 51 80 00       	mov    0x805138,%eax
  8028c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c7:	e9 9e 01 00 00       	jmp    802a6a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d5:	0f 82 87 01 00 00    	jb     802a62 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e4:	0f 85 95 00 00 00    	jne    80297f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ee:	75 17                	jne    802907 <alloc_block_NF+0x5b>
  8028f0:	83 ec 04             	sub    $0x4,%esp
  8028f3:	68 08 41 80 00       	push   $0x804108
  8028f8:	68 e0 00 00 00       	push   $0xe0
  8028fd:	68 5f 40 80 00       	push   $0x80405f
  802902:	e8 eb db ff ff       	call   8004f2 <_panic>
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 00                	mov    (%eax),%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	74 10                	je     802920 <alloc_block_NF+0x74>
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	8b 00                	mov    (%eax),%eax
  802915:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802918:	8b 52 04             	mov    0x4(%edx),%edx
  80291b:	89 50 04             	mov    %edx,0x4(%eax)
  80291e:	eb 0b                	jmp    80292b <alloc_block_NF+0x7f>
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 40 04             	mov    0x4(%eax),%eax
  802926:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 40 04             	mov    0x4(%eax),%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	74 0f                	je     802944 <alloc_block_NF+0x98>
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 04             	mov    0x4(%eax),%eax
  80293b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293e:	8b 12                	mov    (%edx),%edx
  802940:	89 10                	mov    %edx,(%eax)
  802942:	eb 0a                	jmp    80294e <alloc_block_NF+0xa2>
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	a3 38 51 80 00       	mov    %eax,0x805138
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802961:	a1 44 51 80 00       	mov    0x805144,%eax
  802966:	48                   	dec    %eax
  802967:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 40 08             	mov    0x8(%eax),%eax
  802972:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	e9 f8 04 00 00       	jmp    802e77 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 40 0c             	mov    0xc(%eax),%eax
  802985:	3b 45 08             	cmp    0x8(%ebp),%eax
  802988:	0f 86 d4 00 00 00    	jbe    802a62 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80298e:	a1 48 51 80 00       	mov    0x805148,%eax
  802993:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 50 08             	mov    0x8(%eax),%edx
  80299c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029af:	75 17                	jne    8029c8 <alloc_block_NF+0x11c>
  8029b1:	83 ec 04             	sub    $0x4,%esp
  8029b4:	68 08 41 80 00       	push   $0x804108
  8029b9:	68 e9 00 00 00       	push   $0xe9
  8029be:	68 5f 40 80 00       	push   $0x80405f
  8029c3:	e8 2a db ff ff       	call   8004f2 <_panic>
  8029c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cb:	8b 00                	mov    (%eax),%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	74 10                	je     8029e1 <alloc_block_NF+0x135>
  8029d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d9:	8b 52 04             	mov    0x4(%edx),%edx
  8029dc:	89 50 04             	mov    %edx,0x4(%eax)
  8029df:	eb 0b                	jmp    8029ec <alloc_block_NF+0x140>
  8029e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e4:	8b 40 04             	mov    0x4(%eax),%eax
  8029e7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ef:	8b 40 04             	mov    0x4(%eax),%eax
  8029f2:	85 c0                	test   %eax,%eax
  8029f4:	74 0f                	je     802a05 <alloc_block_NF+0x159>
  8029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f9:	8b 40 04             	mov    0x4(%eax),%eax
  8029fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ff:	8b 12                	mov    (%edx),%edx
  802a01:	89 10                	mov    %edx,(%eax)
  802a03:	eb 0a                	jmp    802a0f <alloc_block_NF+0x163>
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	8b 00                	mov    (%eax),%eax
  802a0a:	a3 48 51 80 00       	mov    %eax,0x805148
  802a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a22:	a1 54 51 80 00       	mov    0x805154,%eax
  802a27:	48                   	dec    %eax
  802a28:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a30:	8b 40 08             	mov    0x8(%eax),%eax
  802a33:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 50 08             	mov    0x8(%eax),%edx
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	01 c2                	add    %eax,%edx
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a52:	89 c2                	mov    %eax,%edx
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5d:	e9 15 04 00 00       	jmp    802e77 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a62:	a1 40 51 80 00       	mov    0x805140,%eax
  802a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6e:	74 07                	je     802a77 <alloc_block_NF+0x1cb>
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 00                	mov    (%eax),%eax
  802a75:	eb 05                	jmp    802a7c <alloc_block_NF+0x1d0>
  802a77:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7c:	a3 40 51 80 00       	mov    %eax,0x805140
  802a81:	a1 40 51 80 00       	mov    0x805140,%eax
  802a86:	85 c0                	test   %eax,%eax
  802a88:	0f 85 3e fe ff ff    	jne    8028cc <alloc_block_NF+0x20>
  802a8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a92:	0f 85 34 fe ff ff    	jne    8028cc <alloc_block_NF+0x20>
  802a98:	e9 d5 03 00 00       	jmp    802e72 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa5:	e9 b1 01 00 00       	jmp    802c5b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 50 08             	mov    0x8(%eax),%edx
  802ab0:	a1 28 50 80 00       	mov    0x805028,%eax
  802ab5:	39 c2                	cmp    %eax,%edx
  802ab7:	0f 82 96 01 00 00    	jb     802c53 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac6:	0f 82 87 01 00 00    	jb     802c53 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad5:	0f 85 95 00 00 00    	jne    802b70 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802adb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802adf:	75 17                	jne    802af8 <alloc_block_NF+0x24c>
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	68 08 41 80 00       	push   $0x804108
  802ae9:	68 fc 00 00 00       	push   $0xfc
  802aee:	68 5f 40 80 00       	push   $0x80405f
  802af3:	e8 fa d9 ff ff       	call   8004f2 <_panic>
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 10                	je     802b11 <alloc_block_NF+0x265>
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b09:	8b 52 04             	mov    0x4(%edx),%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	eb 0b                	jmp    802b1c <alloc_block_NF+0x270>
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0f                	je     802b35 <alloc_block_NF+0x289>
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2f:	8b 12                	mov    (%edx),%edx
  802b31:	89 10                	mov    %edx,(%eax)
  802b33:	eb 0a                	jmp    802b3f <alloc_block_NF+0x293>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	a3 38 51 80 00       	mov    %eax,0x805138
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b52:	a1 44 51 80 00       	mov    0x805144,%eax
  802b57:	48                   	dec    %eax
  802b58:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	8b 40 08             	mov    0x8(%eax),%eax
  802b63:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	e9 07 03 00 00       	jmp    802e77 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 0c             	mov    0xc(%eax),%eax
  802b76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b79:	0f 86 d4 00 00 00    	jbe    802c53 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b7f:	a1 48 51 80 00       	mov    0x805148,%eax
  802b84:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 50 08             	mov    0x8(%eax),%edx
  802b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b90:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b96:	8b 55 08             	mov    0x8(%ebp),%edx
  802b99:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ba0:	75 17                	jne    802bb9 <alloc_block_NF+0x30d>
  802ba2:	83 ec 04             	sub    $0x4,%esp
  802ba5:	68 08 41 80 00       	push   $0x804108
  802baa:	68 04 01 00 00       	push   $0x104
  802baf:	68 5f 40 80 00       	push   $0x80405f
  802bb4:	e8 39 d9 ff ff       	call   8004f2 <_panic>
  802bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	74 10                	je     802bd2 <alloc_block_NF+0x326>
  802bc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bca:	8b 52 04             	mov    0x4(%edx),%edx
  802bcd:	89 50 04             	mov    %edx,0x4(%eax)
  802bd0:	eb 0b                	jmp    802bdd <alloc_block_NF+0x331>
  802bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd5:	8b 40 04             	mov    0x4(%eax),%eax
  802bd8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	85 c0                	test   %eax,%eax
  802be5:	74 0f                	je     802bf6 <alloc_block_NF+0x34a>
  802be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bea:	8b 40 04             	mov    0x4(%eax),%eax
  802bed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bf0:	8b 12                	mov    (%edx),%edx
  802bf2:	89 10                	mov    %edx,(%eax)
  802bf4:	eb 0a                	jmp    802c00 <alloc_block_NF+0x354>
  802bf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	a3 48 51 80 00       	mov    %eax,0x805148
  802c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c13:	a1 54 51 80 00       	mov    0x805154,%eax
  802c18:	48                   	dec    %eax
  802c19:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c21:	8b 40 08             	mov    0x8(%eax),%eax
  802c24:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 50 08             	mov    0x8(%eax),%edx
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	01 c2                	add    %eax,%edx
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c40:	2b 45 08             	sub    0x8(%ebp),%eax
  802c43:	89 c2                	mov    %eax,%edx
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4e:	e9 24 02 00 00       	jmp    802e77 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c53:	a1 40 51 80 00       	mov    0x805140,%eax
  802c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5f:	74 07                	je     802c68 <alloc_block_NF+0x3bc>
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	eb 05                	jmp    802c6d <alloc_block_NF+0x3c1>
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6d:	a3 40 51 80 00       	mov    %eax,0x805140
  802c72:	a1 40 51 80 00       	mov    0x805140,%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	0f 85 2b fe ff ff    	jne    802aaa <alloc_block_NF+0x1fe>
  802c7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c83:	0f 85 21 fe ff ff    	jne    802aaa <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c89:	a1 38 51 80 00       	mov    0x805138,%eax
  802c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c91:	e9 ae 01 00 00       	jmp    802e44 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 50 08             	mov    0x8(%eax),%edx
  802c9c:	a1 28 50 80 00       	mov    0x805028,%eax
  802ca1:	39 c2                	cmp    %eax,%edx
  802ca3:	0f 83 93 01 00 00    	jae    802e3c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 0c             	mov    0xc(%eax),%eax
  802caf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb2:	0f 82 84 01 00 00    	jb     802e3c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc1:	0f 85 95 00 00 00    	jne    802d5c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccb:	75 17                	jne    802ce4 <alloc_block_NF+0x438>
  802ccd:	83 ec 04             	sub    $0x4,%esp
  802cd0:	68 08 41 80 00       	push   $0x804108
  802cd5:	68 14 01 00 00       	push   $0x114
  802cda:	68 5f 40 80 00       	push   $0x80405f
  802cdf:	e8 0e d8 ff ff       	call   8004f2 <_panic>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 10                	je     802cfd <alloc_block_NF+0x451>
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf5:	8b 52 04             	mov    0x4(%edx),%edx
  802cf8:	89 50 04             	mov    %edx,0x4(%eax)
  802cfb:	eb 0b                	jmp    802d08 <alloc_block_NF+0x45c>
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 40 04             	mov    0x4(%eax),%eax
  802d03:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 40 04             	mov    0x4(%eax),%eax
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	74 0f                	je     802d21 <alloc_block_NF+0x475>
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1b:	8b 12                	mov    (%edx),%edx
  802d1d:	89 10                	mov    %edx,(%eax)
  802d1f:	eb 0a                	jmp    802d2b <alloc_block_NF+0x47f>
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	a3 38 51 80 00       	mov    %eax,0x805138
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3e:	a1 44 51 80 00       	mov    0x805144,%eax
  802d43:	48                   	dec    %eax
  802d44:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 40 08             	mov    0x8(%eax),%eax
  802d4f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	e9 1b 01 00 00       	jmp    802e77 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d65:	0f 86 d1 00 00 00    	jbe    802e3c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d6b:	a1 48 51 80 00       	mov    0x805148,%eax
  802d70:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 50 08             	mov    0x8(%eax),%edx
  802d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d82:	8b 55 08             	mov    0x8(%ebp),%edx
  802d85:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d8c:	75 17                	jne    802da5 <alloc_block_NF+0x4f9>
  802d8e:	83 ec 04             	sub    $0x4,%esp
  802d91:	68 08 41 80 00       	push   $0x804108
  802d96:	68 1c 01 00 00       	push   $0x11c
  802d9b:	68 5f 40 80 00       	push   $0x80405f
  802da0:	e8 4d d7 ff ff       	call   8004f2 <_panic>
  802da5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	74 10                	je     802dbe <alloc_block_NF+0x512>
  802dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db1:	8b 00                	mov    (%eax),%eax
  802db3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802db6:	8b 52 04             	mov    0x4(%edx),%edx
  802db9:	89 50 04             	mov    %edx,0x4(%eax)
  802dbc:	eb 0b                	jmp    802dc9 <alloc_block_NF+0x51d>
  802dbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc1:	8b 40 04             	mov    0x4(%eax),%eax
  802dc4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	74 0f                	je     802de2 <alloc_block_NF+0x536>
  802dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd6:	8b 40 04             	mov    0x4(%eax),%eax
  802dd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ddc:	8b 12                	mov    (%edx),%edx
  802dde:	89 10                	mov    %edx,(%eax)
  802de0:	eb 0a                	jmp    802dec <alloc_block_NF+0x540>
  802de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	a3 48 51 80 00       	mov    %eax,0x805148
  802dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802def:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dff:	a1 54 51 80 00       	mov    0x805154,%eax
  802e04:	48                   	dec    %eax
  802e05:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0d:	8b 40 08             	mov    0x8(%eax),%eax
  802e10:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 50 08             	mov    0x8(%eax),%edx
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	01 c2                	add    %eax,%edx
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2c:	2b 45 08             	sub    0x8(%ebp),%eax
  802e2f:	89 c2                	mov    %eax,%edx
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3a:	eb 3b                	jmp    802e77 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e3c:	a1 40 51 80 00       	mov    0x805140,%eax
  802e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e48:	74 07                	je     802e51 <alloc_block_NF+0x5a5>
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	eb 05                	jmp    802e56 <alloc_block_NF+0x5aa>
  802e51:	b8 00 00 00 00       	mov    $0x0,%eax
  802e56:	a3 40 51 80 00       	mov    %eax,0x805140
  802e5b:	a1 40 51 80 00       	mov    0x805140,%eax
  802e60:	85 c0                	test   %eax,%eax
  802e62:	0f 85 2e fe ff ff    	jne    802c96 <alloc_block_NF+0x3ea>
  802e68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6c:	0f 85 24 fe ff ff    	jne    802c96 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e77:	c9                   	leave  
  802e78:	c3                   	ret    

00802e79 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e79:	55                   	push   %ebp
  802e7a:	89 e5                	mov    %esp,%ebp
  802e7c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e7f:	a1 38 51 80 00       	mov    0x805138,%eax
  802e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e87:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e8c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e8f:	a1 38 51 80 00       	mov    0x805138,%eax
  802e94:	85 c0                	test   %eax,%eax
  802e96:	74 14                	je     802eac <insert_sorted_with_merge_freeList+0x33>
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 50 08             	mov    0x8(%eax),%edx
  802e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea1:	8b 40 08             	mov    0x8(%eax),%eax
  802ea4:	39 c2                	cmp    %eax,%edx
  802ea6:	0f 87 9b 01 00 00    	ja     803047 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802eac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb0:	75 17                	jne    802ec9 <insert_sorted_with_merge_freeList+0x50>
  802eb2:	83 ec 04             	sub    $0x4,%esp
  802eb5:	68 3c 40 80 00       	push   $0x80403c
  802eba:	68 38 01 00 00       	push   $0x138
  802ebf:	68 5f 40 80 00       	push   $0x80405f
  802ec4:	e8 29 d6 ff ff       	call   8004f2 <_panic>
  802ec9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	89 10                	mov    %edx,(%eax)
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	8b 00                	mov    (%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 0d                	je     802eea <insert_sorted_with_merge_freeList+0x71>
  802edd:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee5:	89 50 04             	mov    %edx,0x4(%eax)
  802ee8:	eb 08                	jmp    802ef2 <insert_sorted_with_merge_freeList+0x79>
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	a3 38 51 80 00       	mov    %eax,0x805138
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f04:	a1 44 51 80 00       	mov    0x805144,%eax
  802f09:	40                   	inc    %eax
  802f0a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f13:	0f 84 a8 06 00 00    	je     8035c1 <insert_sorted_with_merge_freeList+0x748>
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	8b 50 08             	mov    0x8(%eax),%edx
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 40 0c             	mov    0xc(%eax),%eax
  802f25:	01 c2                	add    %eax,%edx
  802f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2a:	8b 40 08             	mov    0x8(%eax),%eax
  802f2d:	39 c2                	cmp    %eax,%edx
  802f2f:	0f 85 8c 06 00 00    	jne    8035c1 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f41:	01 c2                	add    %eax,%edx
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4d:	75 17                	jne    802f66 <insert_sorted_with_merge_freeList+0xed>
  802f4f:	83 ec 04             	sub    $0x4,%esp
  802f52:	68 08 41 80 00       	push   $0x804108
  802f57:	68 3c 01 00 00       	push   $0x13c
  802f5c:	68 5f 40 80 00       	push   $0x80405f
  802f61:	e8 8c d5 ff ff       	call   8004f2 <_panic>
  802f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f69:	8b 00                	mov    (%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 10                	je     802f7f <insert_sorted_with_merge_freeList+0x106>
  802f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f77:	8b 52 04             	mov    0x4(%edx),%edx
  802f7a:	89 50 04             	mov    %edx,0x4(%eax)
  802f7d:	eb 0b                	jmp    802f8a <insert_sorted_with_merge_freeList+0x111>
  802f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f82:	8b 40 04             	mov    0x4(%eax),%eax
  802f85:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8d:	8b 40 04             	mov    0x4(%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 0f                	je     802fa3 <insert_sorted_with_merge_freeList+0x12a>
  802f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f97:	8b 40 04             	mov    0x4(%eax),%eax
  802f9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f9d:	8b 12                	mov    (%edx),%edx
  802f9f:	89 10                	mov    %edx,(%eax)
  802fa1:	eb 0a                	jmp    802fad <insert_sorted_with_merge_freeList+0x134>
  802fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	a3 38 51 80 00       	mov    %eax,0x805138
  802fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc0:	a1 44 51 80 00       	mov    0x805144,%eax
  802fc5:	48                   	dec    %eax
  802fc6:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe3:	75 17                	jne    802ffc <insert_sorted_with_merge_freeList+0x183>
  802fe5:	83 ec 04             	sub    $0x4,%esp
  802fe8:	68 3c 40 80 00       	push   $0x80403c
  802fed:	68 3f 01 00 00       	push   $0x13f
  802ff2:	68 5f 40 80 00       	push   $0x80405f
  802ff7:	e8 f6 d4 ff ff       	call   8004f2 <_panic>
  802ffc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803005:	89 10                	mov    %edx,(%eax)
  803007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300a:	8b 00                	mov    (%eax),%eax
  80300c:	85 c0                	test   %eax,%eax
  80300e:	74 0d                	je     80301d <insert_sorted_with_merge_freeList+0x1a4>
  803010:	a1 48 51 80 00       	mov    0x805148,%eax
  803015:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803018:	89 50 04             	mov    %edx,0x4(%eax)
  80301b:	eb 08                	jmp    803025 <insert_sorted_with_merge_freeList+0x1ac>
  80301d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803020:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803028:	a3 48 51 80 00       	mov    %eax,0x805148
  80302d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803030:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803037:	a1 54 51 80 00       	mov    0x805154,%eax
  80303c:	40                   	inc    %eax
  80303d:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803042:	e9 7a 05 00 00       	jmp    8035c1 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	8b 50 08             	mov    0x8(%eax),%edx
  80304d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803050:	8b 40 08             	mov    0x8(%eax),%eax
  803053:	39 c2                	cmp    %eax,%edx
  803055:	0f 82 14 01 00 00    	jb     80316f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80305b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305e:	8b 50 08             	mov    0x8(%eax),%edx
  803061:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803064:	8b 40 0c             	mov    0xc(%eax),%eax
  803067:	01 c2                	add    %eax,%edx
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	8b 40 08             	mov    0x8(%eax),%eax
  80306f:	39 c2                	cmp    %eax,%edx
  803071:	0f 85 90 00 00 00    	jne    803107 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803077:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307a:	8b 50 0c             	mov    0xc(%eax),%edx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	8b 40 0c             	mov    0xc(%eax),%eax
  803083:	01 c2                	add    %eax,%edx
  803085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803088:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80309f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a3:	75 17                	jne    8030bc <insert_sorted_with_merge_freeList+0x243>
  8030a5:	83 ec 04             	sub    $0x4,%esp
  8030a8:	68 3c 40 80 00       	push   $0x80403c
  8030ad:	68 49 01 00 00       	push   $0x149
  8030b2:	68 5f 40 80 00       	push   $0x80405f
  8030b7:	e8 36 d4 ff ff       	call   8004f2 <_panic>
  8030bc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	89 10                	mov    %edx,(%eax)
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	8b 00                	mov    (%eax),%eax
  8030cc:	85 c0                	test   %eax,%eax
  8030ce:	74 0d                	je     8030dd <insert_sorted_with_merge_freeList+0x264>
  8030d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8030d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d8:	89 50 04             	mov    %edx,0x4(%eax)
  8030db:	eb 08                	jmp    8030e5 <insert_sorted_with_merge_freeList+0x26c>
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f7:	a1 54 51 80 00       	mov    0x805154,%eax
  8030fc:	40                   	inc    %eax
  8030fd:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803102:	e9 bb 04 00 00       	jmp    8035c2 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310b:	75 17                	jne    803124 <insert_sorted_with_merge_freeList+0x2ab>
  80310d:	83 ec 04             	sub    $0x4,%esp
  803110:	68 b0 40 80 00       	push   $0x8040b0
  803115:	68 4c 01 00 00       	push   $0x14c
  80311a:	68 5f 40 80 00       	push   $0x80405f
  80311f:	e8 ce d3 ff ff       	call   8004f2 <_panic>
  803124:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	89 50 04             	mov    %edx,0x4(%eax)
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	8b 40 04             	mov    0x4(%eax),%eax
  803136:	85 c0                	test   %eax,%eax
  803138:	74 0c                	je     803146 <insert_sorted_with_merge_freeList+0x2cd>
  80313a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80313f:	8b 55 08             	mov    0x8(%ebp),%edx
  803142:	89 10                	mov    %edx,(%eax)
  803144:	eb 08                	jmp    80314e <insert_sorted_with_merge_freeList+0x2d5>
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	a3 38 51 80 00       	mov    %eax,0x805138
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80315f:	a1 44 51 80 00       	mov    0x805144,%eax
  803164:	40                   	inc    %eax
  803165:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80316a:	e9 53 04 00 00       	jmp    8035c2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80316f:	a1 38 51 80 00       	mov    0x805138,%eax
  803174:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803177:	e9 15 04 00 00       	jmp    803591 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	8b 00                	mov    (%eax),%eax
  803181:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	8b 50 08             	mov    0x8(%eax),%edx
  80318a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318d:	8b 40 08             	mov    0x8(%eax),%eax
  803190:	39 c2                	cmp    %eax,%edx
  803192:	0f 86 f1 03 00 00    	jbe    803589 <insert_sorted_with_merge_freeList+0x710>
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	8b 50 08             	mov    0x8(%eax),%edx
  80319e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a1:	8b 40 08             	mov    0x8(%eax),%eax
  8031a4:	39 c2                	cmp    %eax,%edx
  8031a6:	0f 83 dd 03 00 00    	jae    803589 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	8b 50 08             	mov    0x8(%eax),%edx
  8031b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b8:	01 c2                	add    %eax,%edx
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	8b 40 08             	mov    0x8(%eax),%eax
  8031c0:	39 c2                	cmp    %eax,%edx
  8031c2:	0f 85 b9 01 00 00    	jne    803381 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 50 08             	mov    0x8(%eax),%edx
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d4:	01 c2                	add    %eax,%edx
  8031d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d9:	8b 40 08             	mov    0x8(%eax),%eax
  8031dc:	39 c2                	cmp    %eax,%edx
  8031de:	0f 85 0d 01 00 00    	jne    8032f1 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f0:	01 c2                	add    %eax,%edx
  8031f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f5:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031fc:	75 17                	jne    803215 <insert_sorted_with_merge_freeList+0x39c>
  8031fe:	83 ec 04             	sub    $0x4,%esp
  803201:	68 08 41 80 00       	push   $0x804108
  803206:	68 5c 01 00 00       	push   $0x15c
  80320b:	68 5f 40 80 00       	push   $0x80405f
  803210:	e8 dd d2 ff ff       	call   8004f2 <_panic>
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	8b 00                	mov    (%eax),%eax
  80321a:	85 c0                	test   %eax,%eax
  80321c:	74 10                	je     80322e <insert_sorted_with_merge_freeList+0x3b5>
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803226:	8b 52 04             	mov    0x4(%edx),%edx
  803229:	89 50 04             	mov    %edx,0x4(%eax)
  80322c:	eb 0b                	jmp    803239 <insert_sorted_with_merge_freeList+0x3c0>
  80322e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803231:	8b 40 04             	mov    0x4(%eax),%eax
  803234:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	8b 40 04             	mov    0x4(%eax),%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	74 0f                	je     803252 <insert_sorted_with_merge_freeList+0x3d9>
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	8b 40 04             	mov    0x4(%eax),%eax
  803249:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80324c:	8b 12                	mov    (%edx),%edx
  80324e:	89 10                	mov    %edx,(%eax)
  803250:	eb 0a                	jmp    80325c <insert_sorted_with_merge_freeList+0x3e3>
  803252:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	a3 38 51 80 00       	mov    %eax,0x805138
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803268:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326f:	a1 44 51 80 00       	mov    0x805144,%eax
  803274:	48                   	dec    %eax
  803275:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80327a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803287:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80328e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803292:	75 17                	jne    8032ab <insert_sorted_with_merge_freeList+0x432>
  803294:	83 ec 04             	sub    $0x4,%esp
  803297:	68 3c 40 80 00       	push   $0x80403c
  80329c:	68 5f 01 00 00       	push   $0x15f
  8032a1:	68 5f 40 80 00       	push   $0x80405f
  8032a6:	e8 47 d2 ff ff       	call   8004f2 <_panic>
  8032ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	85 c0                	test   %eax,%eax
  8032bd:	74 0d                	je     8032cc <insert_sorted_with_merge_freeList+0x453>
  8032bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ca:	eb 08                	jmp    8032d4 <insert_sorted_with_merge_freeList+0x45b>
  8032cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8032dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8032eb:	40                   	inc    %eax
  8032ec:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fd:	01 c2                	add    %eax,%edx
  8032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803302:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331d:	75 17                	jne    803336 <insert_sorted_with_merge_freeList+0x4bd>
  80331f:	83 ec 04             	sub    $0x4,%esp
  803322:	68 3c 40 80 00       	push   $0x80403c
  803327:	68 64 01 00 00       	push   $0x164
  80332c:	68 5f 40 80 00       	push   $0x80405f
  803331:	e8 bc d1 ff ff       	call   8004f2 <_panic>
  803336:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	89 10                	mov    %edx,(%eax)
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	85 c0                	test   %eax,%eax
  803348:	74 0d                	je     803357 <insert_sorted_with_merge_freeList+0x4de>
  80334a:	a1 48 51 80 00       	mov    0x805148,%eax
  80334f:	8b 55 08             	mov    0x8(%ebp),%edx
  803352:	89 50 04             	mov    %edx,0x4(%eax)
  803355:	eb 08                	jmp    80335f <insert_sorted_with_merge_freeList+0x4e6>
  803357:	8b 45 08             	mov    0x8(%ebp),%eax
  80335a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	a3 48 51 80 00       	mov    %eax,0x805148
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803371:	a1 54 51 80 00       	mov    0x805154,%eax
  803376:	40                   	inc    %eax
  803377:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80337c:	e9 41 02 00 00       	jmp    8035c2 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	8b 50 08             	mov    0x8(%eax),%edx
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	8b 40 0c             	mov    0xc(%eax),%eax
  80338d:	01 c2                	add    %eax,%edx
  80338f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803392:	8b 40 08             	mov    0x8(%eax),%eax
  803395:	39 c2                	cmp    %eax,%edx
  803397:	0f 85 7c 01 00 00    	jne    803519 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80339d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033a1:	74 06                	je     8033a9 <insert_sorted_with_merge_freeList+0x530>
  8033a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a7:	75 17                	jne    8033c0 <insert_sorted_with_merge_freeList+0x547>
  8033a9:	83 ec 04             	sub    $0x4,%esp
  8033ac:	68 78 40 80 00       	push   $0x804078
  8033b1:	68 69 01 00 00       	push   $0x169
  8033b6:	68 5f 40 80 00       	push   $0x80405f
  8033bb:	e8 32 d1 ff ff       	call   8004f2 <_panic>
  8033c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c3:	8b 50 04             	mov    0x4(%eax),%edx
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	89 50 04             	mov    %edx,0x4(%eax)
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d2:	89 10                	mov    %edx,(%eax)
  8033d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d7:	8b 40 04             	mov    0x4(%eax),%eax
  8033da:	85 c0                	test   %eax,%eax
  8033dc:	74 0d                	je     8033eb <insert_sorted_with_merge_freeList+0x572>
  8033de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e1:	8b 40 04             	mov    0x4(%eax),%eax
  8033e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e7:	89 10                	mov    %edx,(%eax)
  8033e9:	eb 08                	jmp    8033f3 <insert_sorted_with_merge_freeList+0x57a>
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f9:	89 50 04             	mov    %edx,0x4(%eax)
  8033fc:	a1 44 51 80 00       	mov    0x805144,%eax
  803401:	40                   	inc    %eax
  803402:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	8b 50 0c             	mov    0xc(%eax),%edx
  80340d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803410:	8b 40 0c             	mov    0xc(%eax),%eax
  803413:	01 c2                	add    %eax,%edx
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80341b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80341f:	75 17                	jne    803438 <insert_sorted_with_merge_freeList+0x5bf>
  803421:	83 ec 04             	sub    $0x4,%esp
  803424:	68 08 41 80 00       	push   $0x804108
  803429:	68 6b 01 00 00       	push   $0x16b
  80342e:	68 5f 40 80 00       	push   $0x80405f
  803433:	e8 ba d0 ff ff       	call   8004f2 <_panic>
  803438:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343b:	8b 00                	mov    (%eax),%eax
  80343d:	85 c0                	test   %eax,%eax
  80343f:	74 10                	je     803451 <insert_sorted_with_merge_freeList+0x5d8>
  803441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803449:	8b 52 04             	mov    0x4(%edx),%edx
  80344c:	89 50 04             	mov    %edx,0x4(%eax)
  80344f:	eb 0b                	jmp    80345c <insert_sorted_with_merge_freeList+0x5e3>
  803451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803454:	8b 40 04             	mov    0x4(%eax),%eax
  803457:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80345c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345f:	8b 40 04             	mov    0x4(%eax),%eax
  803462:	85 c0                	test   %eax,%eax
  803464:	74 0f                	je     803475 <insert_sorted_with_merge_freeList+0x5fc>
  803466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803469:	8b 40 04             	mov    0x4(%eax),%eax
  80346c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80346f:	8b 12                	mov    (%edx),%edx
  803471:	89 10                	mov    %edx,(%eax)
  803473:	eb 0a                	jmp    80347f <insert_sorted_with_merge_freeList+0x606>
  803475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803478:	8b 00                	mov    (%eax),%eax
  80347a:	a3 38 51 80 00       	mov    %eax,0x805138
  80347f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803488:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803492:	a1 44 51 80 00       	mov    0x805144,%eax
  803497:	48                   	dec    %eax
  803498:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80349d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034aa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034b5:	75 17                	jne    8034ce <insert_sorted_with_merge_freeList+0x655>
  8034b7:	83 ec 04             	sub    $0x4,%esp
  8034ba:	68 3c 40 80 00       	push   $0x80403c
  8034bf:	68 6e 01 00 00       	push   $0x16e
  8034c4:	68 5f 40 80 00       	push   $0x80405f
  8034c9:	e8 24 d0 ff ff       	call   8004f2 <_panic>
  8034ce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d7:	89 10                	mov    %edx,(%eax)
  8034d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	85 c0                	test   %eax,%eax
  8034e0:	74 0d                	je     8034ef <insert_sorted_with_merge_freeList+0x676>
  8034e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8034e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034ea:	89 50 04             	mov    %edx,0x4(%eax)
  8034ed:	eb 08                	jmp    8034f7 <insert_sorted_with_merge_freeList+0x67e>
  8034ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8034ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803509:	a1 54 51 80 00       	mov    0x805154,%eax
  80350e:	40                   	inc    %eax
  80350f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803514:	e9 a9 00 00 00       	jmp    8035c2 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80351d:	74 06                	je     803525 <insert_sorted_with_merge_freeList+0x6ac>
  80351f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803523:	75 17                	jne    80353c <insert_sorted_with_merge_freeList+0x6c3>
  803525:	83 ec 04             	sub    $0x4,%esp
  803528:	68 d4 40 80 00       	push   $0x8040d4
  80352d:	68 73 01 00 00       	push   $0x173
  803532:	68 5f 40 80 00       	push   $0x80405f
  803537:	e8 b6 cf ff ff       	call   8004f2 <_panic>
  80353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353f:	8b 10                	mov    (%eax),%edx
  803541:	8b 45 08             	mov    0x8(%ebp),%eax
  803544:	89 10                	mov    %edx,(%eax)
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	8b 00                	mov    (%eax),%eax
  80354b:	85 c0                	test   %eax,%eax
  80354d:	74 0b                	je     80355a <insert_sorted_with_merge_freeList+0x6e1>
  80354f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803552:	8b 00                	mov    (%eax),%eax
  803554:	8b 55 08             	mov    0x8(%ebp),%edx
  803557:	89 50 04             	mov    %edx,0x4(%eax)
  80355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355d:	8b 55 08             	mov    0x8(%ebp),%edx
  803560:	89 10                	mov    %edx,(%eax)
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803568:	89 50 04             	mov    %edx,0x4(%eax)
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	85 c0                	test   %eax,%eax
  803572:	75 08                	jne    80357c <insert_sorted_with_merge_freeList+0x703>
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80357c:	a1 44 51 80 00       	mov    0x805144,%eax
  803581:	40                   	inc    %eax
  803582:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803587:	eb 39                	jmp    8035c2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803589:	a1 40 51 80 00       	mov    0x805140,%eax
  80358e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803595:	74 07                	je     80359e <insert_sorted_with_merge_freeList+0x725>
  803597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359a:	8b 00                	mov    (%eax),%eax
  80359c:	eb 05                	jmp    8035a3 <insert_sorted_with_merge_freeList+0x72a>
  80359e:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a3:	a3 40 51 80 00       	mov    %eax,0x805140
  8035a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8035ad:	85 c0                	test   %eax,%eax
  8035af:	0f 85 c7 fb ff ff    	jne    80317c <insert_sorted_with_merge_freeList+0x303>
  8035b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b9:	0f 85 bd fb ff ff    	jne    80317c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035bf:	eb 01                	jmp    8035c2 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035c1:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035c2:	90                   	nop
  8035c3:	c9                   	leave  
  8035c4:	c3                   	ret    
  8035c5:	66 90                	xchg   %ax,%ax
  8035c7:	90                   	nop

008035c8 <__udivdi3>:
  8035c8:	55                   	push   %ebp
  8035c9:	57                   	push   %edi
  8035ca:	56                   	push   %esi
  8035cb:	53                   	push   %ebx
  8035cc:	83 ec 1c             	sub    $0x1c,%esp
  8035cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035df:	89 ca                	mov    %ecx,%edx
  8035e1:	89 f8                	mov    %edi,%eax
  8035e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035e7:	85 f6                	test   %esi,%esi
  8035e9:	75 2d                	jne    803618 <__udivdi3+0x50>
  8035eb:	39 cf                	cmp    %ecx,%edi
  8035ed:	77 65                	ja     803654 <__udivdi3+0x8c>
  8035ef:	89 fd                	mov    %edi,%ebp
  8035f1:	85 ff                	test   %edi,%edi
  8035f3:	75 0b                	jne    803600 <__udivdi3+0x38>
  8035f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fa:	31 d2                	xor    %edx,%edx
  8035fc:	f7 f7                	div    %edi
  8035fe:	89 c5                	mov    %eax,%ebp
  803600:	31 d2                	xor    %edx,%edx
  803602:	89 c8                	mov    %ecx,%eax
  803604:	f7 f5                	div    %ebp
  803606:	89 c1                	mov    %eax,%ecx
  803608:	89 d8                	mov    %ebx,%eax
  80360a:	f7 f5                	div    %ebp
  80360c:	89 cf                	mov    %ecx,%edi
  80360e:	89 fa                	mov    %edi,%edx
  803610:	83 c4 1c             	add    $0x1c,%esp
  803613:	5b                   	pop    %ebx
  803614:	5e                   	pop    %esi
  803615:	5f                   	pop    %edi
  803616:	5d                   	pop    %ebp
  803617:	c3                   	ret    
  803618:	39 ce                	cmp    %ecx,%esi
  80361a:	77 28                	ja     803644 <__udivdi3+0x7c>
  80361c:	0f bd fe             	bsr    %esi,%edi
  80361f:	83 f7 1f             	xor    $0x1f,%edi
  803622:	75 40                	jne    803664 <__udivdi3+0x9c>
  803624:	39 ce                	cmp    %ecx,%esi
  803626:	72 0a                	jb     803632 <__udivdi3+0x6a>
  803628:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80362c:	0f 87 9e 00 00 00    	ja     8036d0 <__udivdi3+0x108>
  803632:	b8 01 00 00 00       	mov    $0x1,%eax
  803637:	89 fa                	mov    %edi,%edx
  803639:	83 c4 1c             	add    $0x1c,%esp
  80363c:	5b                   	pop    %ebx
  80363d:	5e                   	pop    %esi
  80363e:	5f                   	pop    %edi
  80363f:	5d                   	pop    %ebp
  803640:	c3                   	ret    
  803641:	8d 76 00             	lea    0x0(%esi),%esi
  803644:	31 ff                	xor    %edi,%edi
  803646:	31 c0                	xor    %eax,%eax
  803648:	89 fa                	mov    %edi,%edx
  80364a:	83 c4 1c             	add    $0x1c,%esp
  80364d:	5b                   	pop    %ebx
  80364e:	5e                   	pop    %esi
  80364f:	5f                   	pop    %edi
  803650:	5d                   	pop    %ebp
  803651:	c3                   	ret    
  803652:	66 90                	xchg   %ax,%ax
  803654:	89 d8                	mov    %ebx,%eax
  803656:	f7 f7                	div    %edi
  803658:	31 ff                	xor    %edi,%edi
  80365a:	89 fa                	mov    %edi,%edx
  80365c:	83 c4 1c             	add    $0x1c,%esp
  80365f:	5b                   	pop    %ebx
  803660:	5e                   	pop    %esi
  803661:	5f                   	pop    %edi
  803662:	5d                   	pop    %ebp
  803663:	c3                   	ret    
  803664:	bd 20 00 00 00       	mov    $0x20,%ebp
  803669:	89 eb                	mov    %ebp,%ebx
  80366b:	29 fb                	sub    %edi,%ebx
  80366d:	89 f9                	mov    %edi,%ecx
  80366f:	d3 e6                	shl    %cl,%esi
  803671:	89 c5                	mov    %eax,%ebp
  803673:	88 d9                	mov    %bl,%cl
  803675:	d3 ed                	shr    %cl,%ebp
  803677:	89 e9                	mov    %ebp,%ecx
  803679:	09 f1                	or     %esi,%ecx
  80367b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80367f:	89 f9                	mov    %edi,%ecx
  803681:	d3 e0                	shl    %cl,%eax
  803683:	89 c5                	mov    %eax,%ebp
  803685:	89 d6                	mov    %edx,%esi
  803687:	88 d9                	mov    %bl,%cl
  803689:	d3 ee                	shr    %cl,%esi
  80368b:	89 f9                	mov    %edi,%ecx
  80368d:	d3 e2                	shl    %cl,%edx
  80368f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803693:	88 d9                	mov    %bl,%cl
  803695:	d3 e8                	shr    %cl,%eax
  803697:	09 c2                	or     %eax,%edx
  803699:	89 d0                	mov    %edx,%eax
  80369b:	89 f2                	mov    %esi,%edx
  80369d:	f7 74 24 0c          	divl   0xc(%esp)
  8036a1:	89 d6                	mov    %edx,%esi
  8036a3:	89 c3                	mov    %eax,%ebx
  8036a5:	f7 e5                	mul    %ebp
  8036a7:	39 d6                	cmp    %edx,%esi
  8036a9:	72 19                	jb     8036c4 <__udivdi3+0xfc>
  8036ab:	74 0b                	je     8036b8 <__udivdi3+0xf0>
  8036ad:	89 d8                	mov    %ebx,%eax
  8036af:	31 ff                	xor    %edi,%edi
  8036b1:	e9 58 ff ff ff       	jmp    80360e <__udivdi3+0x46>
  8036b6:	66 90                	xchg   %ax,%ax
  8036b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036bc:	89 f9                	mov    %edi,%ecx
  8036be:	d3 e2                	shl    %cl,%edx
  8036c0:	39 c2                	cmp    %eax,%edx
  8036c2:	73 e9                	jae    8036ad <__udivdi3+0xe5>
  8036c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036c7:	31 ff                	xor    %edi,%edi
  8036c9:	e9 40 ff ff ff       	jmp    80360e <__udivdi3+0x46>
  8036ce:	66 90                	xchg   %ax,%ax
  8036d0:	31 c0                	xor    %eax,%eax
  8036d2:	e9 37 ff ff ff       	jmp    80360e <__udivdi3+0x46>
  8036d7:	90                   	nop

008036d8 <__umoddi3>:
  8036d8:	55                   	push   %ebp
  8036d9:	57                   	push   %edi
  8036da:	56                   	push   %esi
  8036db:	53                   	push   %ebx
  8036dc:	83 ec 1c             	sub    $0x1c,%esp
  8036df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036f7:	89 f3                	mov    %esi,%ebx
  8036f9:	89 fa                	mov    %edi,%edx
  8036fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ff:	89 34 24             	mov    %esi,(%esp)
  803702:	85 c0                	test   %eax,%eax
  803704:	75 1a                	jne    803720 <__umoddi3+0x48>
  803706:	39 f7                	cmp    %esi,%edi
  803708:	0f 86 a2 00 00 00    	jbe    8037b0 <__umoddi3+0xd8>
  80370e:	89 c8                	mov    %ecx,%eax
  803710:	89 f2                	mov    %esi,%edx
  803712:	f7 f7                	div    %edi
  803714:	89 d0                	mov    %edx,%eax
  803716:	31 d2                	xor    %edx,%edx
  803718:	83 c4 1c             	add    $0x1c,%esp
  80371b:	5b                   	pop    %ebx
  80371c:	5e                   	pop    %esi
  80371d:	5f                   	pop    %edi
  80371e:	5d                   	pop    %ebp
  80371f:	c3                   	ret    
  803720:	39 f0                	cmp    %esi,%eax
  803722:	0f 87 ac 00 00 00    	ja     8037d4 <__umoddi3+0xfc>
  803728:	0f bd e8             	bsr    %eax,%ebp
  80372b:	83 f5 1f             	xor    $0x1f,%ebp
  80372e:	0f 84 ac 00 00 00    	je     8037e0 <__umoddi3+0x108>
  803734:	bf 20 00 00 00       	mov    $0x20,%edi
  803739:	29 ef                	sub    %ebp,%edi
  80373b:	89 fe                	mov    %edi,%esi
  80373d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803741:	89 e9                	mov    %ebp,%ecx
  803743:	d3 e0                	shl    %cl,%eax
  803745:	89 d7                	mov    %edx,%edi
  803747:	89 f1                	mov    %esi,%ecx
  803749:	d3 ef                	shr    %cl,%edi
  80374b:	09 c7                	or     %eax,%edi
  80374d:	89 e9                	mov    %ebp,%ecx
  80374f:	d3 e2                	shl    %cl,%edx
  803751:	89 14 24             	mov    %edx,(%esp)
  803754:	89 d8                	mov    %ebx,%eax
  803756:	d3 e0                	shl    %cl,%eax
  803758:	89 c2                	mov    %eax,%edx
  80375a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80375e:	d3 e0                	shl    %cl,%eax
  803760:	89 44 24 04          	mov    %eax,0x4(%esp)
  803764:	8b 44 24 08          	mov    0x8(%esp),%eax
  803768:	89 f1                	mov    %esi,%ecx
  80376a:	d3 e8                	shr    %cl,%eax
  80376c:	09 d0                	or     %edx,%eax
  80376e:	d3 eb                	shr    %cl,%ebx
  803770:	89 da                	mov    %ebx,%edx
  803772:	f7 f7                	div    %edi
  803774:	89 d3                	mov    %edx,%ebx
  803776:	f7 24 24             	mull   (%esp)
  803779:	89 c6                	mov    %eax,%esi
  80377b:	89 d1                	mov    %edx,%ecx
  80377d:	39 d3                	cmp    %edx,%ebx
  80377f:	0f 82 87 00 00 00    	jb     80380c <__umoddi3+0x134>
  803785:	0f 84 91 00 00 00    	je     80381c <__umoddi3+0x144>
  80378b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80378f:	29 f2                	sub    %esi,%edx
  803791:	19 cb                	sbb    %ecx,%ebx
  803793:	89 d8                	mov    %ebx,%eax
  803795:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803799:	d3 e0                	shl    %cl,%eax
  80379b:	89 e9                	mov    %ebp,%ecx
  80379d:	d3 ea                	shr    %cl,%edx
  80379f:	09 d0                	or     %edx,%eax
  8037a1:	89 e9                	mov    %ebp,%ecx
  8037a3:	d3 eb                	shr    %cl,%ebx
  8037a5:	89 da                	mov    %ebx,%edx
  8037a7:	83 c4 1c             	add    $0x1c,%esp
  8037aa:	5b                   	pop    %ebx
  8037ab:	5e                   	pop    %esi
  8037ac:	5f                   	pop    %edi
  8037ad:	5d                   	pop    %ebp
  8037ae:	c3                   	ret    
  8037af:	90                   	nop
  8037b0:	89 fd                	mov    %edi,%ebp
  8037b2:	85 ff                	test   %edi,%edi
  8037b4:	75 0b                	jne    8037c1 <__umoddi3+0xe9>
  8037b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037bb:	31 d2                	xor    %edx,%edx
  8037bd:	f7 f7                	div    %edi
  8037bf:	89 c5                	mov    %eax,%ebp
  8037c1:	89 f0                	mov    %esi,%eax
  8037c3:	31 d2                	xor    %edx,%edx
  8037c5:	f7 f5                	div    %ebp
  8037c7:	89 c8                	mov    %ecx,%eax
  8037c9:	f7 f5                	div    %ebp
  8037cb:	89 d0                	mov    %edx,%eax
  8037cd:	e9 44 ff ff ff       	jmp    803716 <__umoddi3+0x3e>
  8037d2:	66 90                	xchg   %ax,%ax
  8037d4:	89 c8                	mov    %ecx,%eax
  8037d6:	89 f2                	mov    %esi,%edx
  8037d8:	83 c4 1c             	add    $0x1c,%esp
  8037db:	5b                   	pop    %ebx
  8037dc:	5e                   	pop    %esi
  8037dd:	5f                   	pop    %edi
  8037de:	5d                   	pop    %ebp
  8037df:	c3                   	ret    
  8037e0:	3b 04 24             	cmp    (%esp),%eax
  8037e3:	72 06                	jb     8037eb <__umoddi3+0x113>
  8037e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037e9:	77 0f                	ja     8037fa <__umoddi3+0x122>
  8037eb:	89 f2                	mov    %esi,%edx
  8037ed:	29 f9                	sub    %edi,%ecx
  8037ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037f3:	89 14 24             	mov    %edx,(%esp)
  8037f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037fe:	8b 14 24             	mov    (%esp),%edx
  803801:	83 c4 1c             	add    $0x1c,%esp
  803804:	5b                   	pop    %ebx
  803805:	5e                   	pop    %esi
  803806:	5f                   	pop    %edi
  803807:	5d                   	pop    %ebp
  803808:	c3                   	ret    
  803809:	8d 76 00             	lea    0x0(%esi),%esi
  80380c:	2b 04 24             	sub    (%esp),%eax
  80380f:	19 fa                	sbb    %edi,%edx
  803811:	89 d1                	mov    %edx,%ecx
  803813:	89 c6                	mov    %eax,%esi
  803815:	e9 71 ff ff ff       	jmp    80378b <__umoddi3+0xb3>
  80381a:	66 90                	xchg   %ax,%ax
  80381c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803820:	72 ea                	jb     80380c <__umoddi3+0x134>
  803822:	89 d9                	mov    %ebx,%ecx
  803824:	e9 62 ff ff ff       	jmp    80378b <__umoddi3+0xb3>
