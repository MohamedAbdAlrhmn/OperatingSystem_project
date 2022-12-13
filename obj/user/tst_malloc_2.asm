
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
  800090:	68 20 38 80 00       	push   $0x803820
  800095:	6a 1a                	push   $0x1a
  800097:	68 3c 38 80 00       	push   $0x80383c
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
  800282:	68 50 38 80 00       	push   $0x803850
  800287:	6a 45                	push   $0x45
  800289:	68 3c 38 80 00       	push   $0x80383c
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
  8002b7:	68 50 38 80 00       	push   $0x803850
  8002bc:	6a 46                	push   $0x46
  8002be:	68 3c 38 80 00       	push   $0x80383c
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
  8002eb:	68 50 38 80 00       	push   $0x803850
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 3c 38 80 00       	push   $0x80383c
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
  80031f:	68 50 38 80 00       	push   $0x803850
  800324:	6a 49                	push   $0x49
  800326:	68 3c 38 80 00       	push   $0x80383c
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
  800359:	68 50 38 80 00       	push   $0x803850
  80035e:	6a 4a                	push   $0x4a
  800360:	68 3c 38 80 00       	push   $0x80383c
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
  80038f:	68 50 38 80 00       	push   $0x803850
  800394:	6a 4b                	push   $0x4b
  800396:	68 3c 38 80 00       	push   $0x80383c
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 88 38 80 00       	push   $0x803888
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
  8003bc:	e8 fa 18 00 00       	call   801cbb <sys_getenvindex>
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
  800427:	e8 9c 16 00 00       	call   801ac8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 dc 38 80 00       	push   $0x8038dc
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
  800457:	68 04 39 80 00       	push   $0x803904
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
  800488:	68 2c 39 80 00       	push   $0x80392c
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 50 80 00       	mov    0x805020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 84 39 80 00       	push   $0x803984
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 dc 38 80 00       	push   $0x8038dc
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 1c 16 00 00       	call   801ae2 <sys_enable_interrupt>

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
  8004d9:	e8 a9 17 00 00       	call   801c87 <sys_destroy_env>
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
  8004ea:	e8 fe 17 00 00       	call   801ced <sys_exit_env>
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
  800513:	68 98 39 80 00       	push   $0x803998
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 50 80 00       	mov    0x805000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 9d 39 80 00       	push   $0x80399d
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
  800550:	68 b9 39 80 00       	push   $0x8039b9
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
  80057c:	68 bc 39 80 00       	push   $0x8039bc
  800581:	6a 26                	push   $0x26
  800583:	68 08 3a 80 00       	push   $0x803a08
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
  80064e:	68 14 3a 80 00       	push   $0x803a14
  800653:	6a 3a                	push   $0x3a
  800655:	68 08 3a 80 00       	push   $0x803a08
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
  8006be:	68 68 3a 80 00       	push   $0x803a68
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 08 3a 80 00       	push   $0x803a08
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
  800718:	e8 fd 11 00 00       	call   80191a <sys_cputs>
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
  80078f:	e8 86 11 00 00       	call   80191a <sys_cputs>
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
  8007d9:	e8 ea 12 00 00       	call   801ac8 <sys_disable_interrupt>
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
  8007f9:	e8 e4 12 00 00       	call   801ae2 <sys_enable_interrupt>
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
  800843:	e8 58 2d 00 00       	call   8035a0 <__udivdi3>
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
  800893:	e8 18 2e 00 00       	call   8036b0 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 d4 3c 80 00       	add    $0x803cd4,%eax
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
  8009ee:	8b 04 85 f8 3c 80 00 	mov    0x803cf8(,%eax,4),%eax
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
  800acf:	8b 34 9d 40 3b 80 00 	mov    0x803b40(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 e5 3c 80 00       	push   $0x803ce5
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
  800af4:	68 ee 3c 80 00       	push   $0x803cee
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
  800b21:	be f1 3c 80 00       	mov    $0x803cf1,%esi
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
  801547:	68 50 3e 80 00       	push   $0x803e50
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
  801617:	e8 42 04 00 00       	call   801a5e <sys_allocate_chunk>
  80161c:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80161f:	a1 20 51 80 00       	mov    0x805120,%eax
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	50                   	push   %eax
  801628:	e8 b7 0a 00 00       	call   8020e4 <initialize_MemBlocksList>
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
  801655:	68 75 3e 80 00       	push   $0x803e75
  80165a:	6a 33                	push   $0x33
  80165c:	68 93 3e 80 00       	push   $0x803e93
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
  8016d4:	68 a0 3e 80 00       	push   $0x803ea0
  8016d9:	6a 34                	push   $0x34
  8016db:	68 93 3e 80 00       	push   $0x803e93
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
  801749:	68 c4 3e 80 00       	push   $0x803ec4
  80174e:	6a 46                	push   $0x46
  801750:	68 93 3e 80 00       	push   $0x803e93
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
  801765:	68 ec 3e 80 00       	push   $0x803eec
  80176a:	6a 61                	push   $0x61
  80176c:	68 93 3e 80 00       	push   $0x803e93
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
  80178b:	75 0a                	jne    801797 <smalloc+0x21>
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	e9 9e 00 00 00       	jmp    801835 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801797:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80179e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a4:	01 d0                	add    %edx,%eax
  8017a6:	48                   	dec    %eax
  8017a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b2:	f7 75 f0             	divl   -0x10(%ebp)
  8017b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b8:	29 d0                	sub    %edx,%eax
  8017ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017bd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017c4:	e8 63 06 00 00       	call   801e2c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	74 11                	je     8017de <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d3:	e8 ce 0c 00 00       	call   8024a6 <alloc_block_FF>
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8017de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e2:	74 4c                	je     801830 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e7:	8b 40 08             	mov    0x8(%eax),%eax
  8017ea:	89 c2                	mov    %eax,%edx
  8017ec:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	ff 75 0c             	pushl  0xc(%ebp)
  8017f5:	ff 75 08             	pushl  0x8(%ebp)
  8017f8:	e8 b4 03 00 00       	call   801bb1 <sys_createSharedObject>
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801803:	83 ec 08             	sub    $0x8,%esp
  801806:	ff 75 e0             	pushl  -0x20(%ebp)
  801809:	68 0f 3f 80 00       	push   $0x803f0f
  80180e:	e8 93 ef ff ff       	call   8007a6 <cprintf>
  801813:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801816:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80181a:	74 14                	je     801830 <smalloc+0xba>
  80181c:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801820:	74 0e                	je     801830 <smalloc+0xba>
  801822:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801826:	74 08                	je     801830 <smalloc+0xba>
			return (void*) mem_block->sva;
  801828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182b:	8b 40 08             	mov    0x8(%eax),%eax
  80182e:	eb 05                	jmp    801835 <smalloc+0xbf>
	}
	return NULL;
  801830:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80183d:	e8 ee fc ff ff       	call   801530 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801842:	83 ec 04             	sub    $0x4,%esp
  801845:	68 24 3f 80 00       	push   $0x803f24
  80184a:	68 ab 00 00 00       	push   $0xab
  80184f:	68 93 3e 80 00       	push   $0x803e93
  801854:	e8 99 ec ff ff       	call   8004f2 <_panic>

00801859 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80185f:	e8 cc fc ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	68 48 3f 80 00       	push   $0x803f48
  80186c:	68 ef 00 00 00       	push   $0xef
  801871:	68 93 3e 80 00       	push   $0x803e93
  801876:	e8 77 ec ff ff       	call   8004f2 <_panic>

0080187b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	68 70 3f 80 00       	push   $0x803f70
  801889:	68 03 01 00 00       	push   $0x103
  80188e:	68 93 3e 80 00       	push   $0x803e93
  801893:	e8 5a ec ff ff       	call   8004f2 <_panic>

00801898 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	68 94 3f 80 00       	push   $0x803f94
  8018a6:	68 0e 01 00 00       	push   $0x10e
  8018ab:	68 93 3e 80 00       	push   $0x803e93
  8018b0:	e8 3d ec ff ff       	call   8004f2 <_panic>

008018b5 <shrink>:

}
void shrink(uint32 newSize)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bb:	83 ec 04             	sub    $0x4,%esp
  8018be:	68 94 3f 80 00       	push   $0x803f94
  8018c3:	68 13 01 00 00       	push   $0x113
  8018c8:	68 93 3e 80 00       	push   $0x803e93
  8018cd:	e8 20 ec ff ff       	call   8004f2 <_panic>

008018d2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	68 94 3f 80 00       	push   $0x803f94
  8018e0:	68 18 01 00 00       	push   $0x118
  8018e5:	68 93 3e 80 00       	push   $0x803e93
  8018ea:	e8 03 ec ff ff       	call   8004f2 <_panic>

008018ef <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	57                   	push   %edi
  8018f3:	56                   	push   %esi
  8018f4:	53                   	push   %ebx
  8018f5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801901:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801904:	8b 7d 18             	mov    0x18(%ebp),%edi
  801907:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80190a:	cd 30                	int    $0x30
  80190c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80190f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	5b                   	pop    %ebx
  801916:	5e                   	pop    %esi
  801917:	5f                   	pop    %edi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    

0080191a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	8b 45 10             	mov    0x10(%ebp),%eax
  801923:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801926:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	52                   	push   %edx
  801932:	ff 75 0c             	pushl  0xc(%ebp)
  801935:	50                   	push   %eax
  801936:	6a 00                	push   $0x0
  801938:	e8 b2 ff ff ff       	call   8018ef <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	90                   	nop
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_cgetc>:

int
sys_cgetc(void)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 01                	push   $0x1
  801952:	e8 98 ff ff ff       	call   8018ef <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80195f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	52                   	push   %edx
  80196c:	50                   	push   %eax
  80196d:	6a 05                	push   $0x5
  80196f:	e8 7b ff ff ff       	call   8018ef <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	56                   	push   %esi
  80197d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80197e:	8b 75 18             	mov    0x18(%ebp),%esi
  801981:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801984:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	56                   	push   %esi
  80198e:	53                   	push   %ebx
  80198f:	51                   	push   %ecx
  801990:	52                   	push   %edx
  801991:	50                   	push   %eax
  801992:	6a 06                	push   $0x6
  801994:	e8 56 ff ff ff       	call   8018ef <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    

008019a3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	52                   	push   %edx
  8019b3:	50                   	push   %eax
  8019b4:	6a 07                	push   $0x7
  8019b6:	e8 34 ff ff ff       	call   8018ef <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	6a 08                	push   $0x8
  8019d1:	e8 19 ff ff ff       	call   8018ef <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 09                	push   $0x9
  8019ea:	e8 00 ff ff ff       	call   8018ef <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 0a                	push   $0xa
  801a03:	e8 e7 fe ff ff       	call   8018ef <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 0b                	push   $0xb
  801a1c:	e8 ce fe ff ff       	call   8018ef <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	ff 75 0c             	pushl  0xc(%ebp)
  801a32:	ff 75 08             	pushl  0x8(%ebp)
  801a35:	6a 0f                	push   $0xf
  801a37:	e8 b3 fe ff ff       	call   8018ef <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	6a 10                	push   $0x10
  801a53:	e8 97 fe ff ff       	call   8018ef <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5b:	90                   	nop
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	ff 75 10             	pushl  0x10(%ebp)
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	6a 11                	push   $0x11
  801a70:	e8 7a fe ff ff       	call   8018ef <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
	return ;
  801a78:	90                   	nop
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 0c                	push   $0xc
  801a8a:	e8 60 fe ff ff       	call   8018ef <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	ff 75 08             	pushl  0x8(%ebp)
  801aa2:	6a 0d                	push   $0xd
  801aa4:	e8 46 fe ff ff       	call   8018ef <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 0e                	push   $0xe
  801abd:	e8 2d fe ff ff       	call   8018ef <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	90                   	nop
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 13                	push   $0x13
  801ad7:	e8 13 fe ff ff       	call   8018ef <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	90                   	nop
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 14                	push   $0x14
  801af1:	e8 f9 fd ff ff       	call   8018ef <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	90                   	nop
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_cputc>:


void
sys_cputc(const char c)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 04             	sub    $0x4,%esp
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	50                   	push   %eax
  801b15:	6a 15                	push   $0x15
  801b17:	e8 d3 fd ff ff       	call   8018ef <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	90                   	nop
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 16                	push   $0x16
  801b31:	e8 b9 fd ff ff       	call   8018ef <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	90                   	nop
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	ff 75 0c             	pushl  0xc(%ebp)
  801b4b:	50                   	push   %eax
  801b4c:	6a 17                	push   $0x17
  801b4e:	e8 9c fd ff ff       	call   8018ef <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	52                   	push   %edx
  801b68:	50                   	push   %eax
  801b69:	6a 1a                	push   $0x1a
  801b6b:	e8 7f fd ff ff       	call   8018ef <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	52                   	push   %edx
  801b85:	50                   	push   %eax
  801b86:	6a 18                	push   $0x18
  801b88:	e8 62 fd ff ff       	call   8018ef <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	90                   	nop
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	52                   	push   %edx
  801ba3:	50                   	push   %eax
  801ba4:	6a 19                	push   $0x19
  801ba6:	e8 44 fd ff ff       	call   8018ef <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	90                   	nop
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bba:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bbd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bc0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	6a 00                	push   $0x0
  801bc9:	51                   	push   %ecx
  801bca:	52                   	push   %edx
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	50                   	push   %eax
  801bcf:	6a 1b                	push   $0x1b
  801bd1:	e8 19 fd ff ff       	call   8018ef <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	52                   	push   %edx
  801beb:	50                   	push   %eax
  801bec:	6a 1c                	push   $0x1c
  801bee:	e8 fc fc ff ff       	call   8018ef <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	51                   	push   %ecx
  801c09:	52                   	push   %edx
  801c0a:	50                   	push   %eax
  801c0b:	6a 1d                	push   $0x1d
  801c0d:	e8 dd fc ff ff       	call   8018ef <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	52                   	push   %edx
  801c27:	50                   	push   %eax
  801c28:	6a 1e                	push   $0x1e
  801c2a:	e8 c0 fc ff ff       	call   8018ef <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 1f                	push   $0x1f
  801c43:	e8 a7 fc ff ff       	call   8018ef <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	6a 00                	push   $0x0
  801c55:	ff 75 14             	pushl  0x14(%ebp)
  801c58:	ff 75 10             	pushl  0x10(%ebp)
  801c5b:	ff 75 0c             	pushl  0xc(%ebp)
  801c5e:	50                   	push   %eax
  801c5f:	6a 20                	push   $0x20
  801c61:	e8 89 fc ff ff       	call   8018ef <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	50                   	push   %eax
  801c7a:	6a 21                	push   $0x21
  801c7c:	e8 6e fc ff ff       	call   8018ef <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	90                   	nop
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	50                   	push   %eax
  801c96:	6a 22                	push   $0x22
  801c98:	e8 52 fc ff ff       	call   8018ef <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 02                	push   $0x2
  801cb1:	e8 39 fc ff ff       	call   8018ef <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 03                	push   $0x3
  801cca:	e8 20 fc ff ff       	call   8018ef <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 04                	push   $0x4
  801ce3:	e8 07 fc ff ff       	call   8018ef <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_exit_env>:


void sys_exit_env(void)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 23                	push   $0x23
  801cfc:	e8 ee fb ff ff       	call   8018ef <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	90                   	nop
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d0d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d10:	8d 50 04             	lea    0x4(%eax),%edx
  801d13:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	52                   	push   %edx
  801d1d:	50                   	push   %eax
  801d1e:	6a 24                	push   $0x24
  801d20:	e8 ca fb ff ff       	call   8018ef <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
	return result;
  801d28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d31:	89 01                	mov    %eax,(%ecx)
  801d33:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	c9                   	leave  
  801d3a:	c2 04 00             	ret    $0x4

00801d3d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	ff 75 10             	pushl  0x10(%ebp)
  801d47:	ff 75 0c             	pushl  0xc(%ebp)
  801d4a:	ff 75 08             	pushl  0x8(%ebp)
  801d4d:	6a 12                	push   $0x12
  801d4f:	e8 9b fb ff ff       	call   8018ef <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
	return ;
  801d57:	90                   	nop
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_rcr2>:
uint32 sys_rcr2()
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 25                	push   $0x25
  801d69:	e8 81 fb ff ff       	call   8018ef <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 04             	sub    $0x4,%esp
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d7f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	50                   	push   %eax
  801d8c:	6a 26                	push   $0x26
  801d8e:	e8 5c fb ff ff       	call   8018ef <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
	return ;
  801d96:	90                   	nop
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <rsttst>:
void rsttst()
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 28                	push   $0x28
  801da8:	e8 42 fb ff ff       	call   8018ef <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
	return ;
  801db0:	90                   	nop
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	83 ec 04             	sub    $0x4,%esp
  801db9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dbf:	8b 55 18             	mov    0x18(%ebp),%edx
  801dc2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dc6:	52                   	push   %edx
  801dc7:	50                   	push   %eax
  801dc8:	ff 75 10             	pushl  0x10(%ebp)
  801dcb:	ff 75 0c             	pushl  0xc(%ebp)
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	6a 27                	push   $0x27
  801dd3:	e8 17 fb ff ff       	call   8018ef <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddb:	90                   	nop
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <chktst>:
void chktst(uint32 n)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	ff 75 08             	pushl  0x8(%ebp)
  801dec:	6a 29                	push   $0x29
  801dee:	e8 fc fa ff ff       	call   8018ef <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
	return ;
  801df6:	90                   	nop
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <inctst>:

void inctst()
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 2a                	push   $0x2a
  801e08:	e8 e2 fa ff ff       	call   8018ef <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e10:	90                   	nop
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <gettst>:
uint32 gettst()
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 2b                	push   $0x2b
  801e22:	e8 c8 fa ff ff       	call   8018ef <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 2c                	push   $0x2c
  801e3e:	e8 ac fa ff ff       	call   8018ef <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
  801e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e49:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e4d:	75 07                	jne    801e56 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e54:	eb 05                	jmp    801e5b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 2c                	push   $0x2c
  801e6f:	e8 7b fa ff ff       	call   8018ef <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
  801e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e7a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e7e:	75 07                	jne    801e87 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e80:	b8 01 00 00 00       	mov    $0x1,%eax
  801e85:	eb 05                	jmp    801e8c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 2c                	push   $0x2c
  801ea0:	e8 4a fa ff ff       	call   8018ef <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
  801ea8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eab:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eaf:	75 07                	jne    801eb8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb6:	eb 05                	jmp    801ebd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 2c                	push   $0x2c
  801ed1:	e8 19 fa ff ff       	call   8018ef <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
  801ed9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801edc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ee0:	75 07                	jne    801ee9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ee2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee7:	eb 05                	jmp    801eee <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ee9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	ff 75 08             	pushl  0x8(%ebp)
  801efe:	6a 2d                	push   $0x2d
  801f00:	e8 ea f9 ff ff       	call   8018ef <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
	return ;
  801f08:	90                   	nop
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	6a 00                	push   $0x0
  801f1d:	53                   	push   %ebx
  801f1e:	51                   	push   %ecx
  801f1f:	52                   	push   %edx
  801f20:	50                   	push   %eax
  801f21:	6a 2e                	push   $0x2e
  801f23:	e8 c7 f9 ff ff       	call   8018ef <syscall>
  801f28:	83 c4 18             	add    $0x18,%esp
}
  801f2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	52                   	push   %edx
  801f40:	50                   	push   %eax
  801f41:	6a 2f                	push   $0x2f
  801f43:	e8 a7 f9 ff ff       	call   8018ef <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f53:	83 ec 0c             	sub    $0xc,%esp
  801f56:	68 a4 3f 80 00       	push   $0x803fa4
  801f5b:	e8 46 e8 ff ff       	call   8007a6 <cprintf>
  801f60:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f6a:	83 ec 0c             	sub    $0xc,%esp
  801f6d:	68 d0 3f 80 00       	push   $0x803fd0
  801f72:	e8 2f e8 ff ff       	call   8007a6 <cprintf>
  801f77:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f7a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f7e:	a1 38 51 80 00       	mov    0x805138,%eax
  801f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f86:	eb 56                	jmp    801fde <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8c:	74 1c                	je     801faa <print_mem_block_lists+0x5d>
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	8b 50 08             	mov    0x8(%eax),%edx
  801f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f97:	8b 48 08             	mov    0x8(%eax),%ecx
  801f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa0:	01 c8                	add    %ecx,%eax
  801fa2:	39 c2                	cmp    %eax,%edx
  801fa4:	73 04                	jae    801faa <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fa6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 50 08             	mov    0x8(%eax),%edx
  801fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb6:	01 c2                	add    %eax,%edx
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8b 40 08             	mov    0x8(%eax),%eax
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	52                   	push   %edx
  801fc2:	50                   	push   %eax
  801fc3:	68 e5 3f 80 00       	push   $0x803fe5
  801fc8:	e8 d9 e7 ff ff       	call   8007a6 <cprintf>
  801fcd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fd6:	a1 40 51 80 00       	mov    0x805140,%eax
  801fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe2:	74 07                	je     801feb <print_mem_block_lists+0x9e>
  801fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe7:	8b 00                	mov    (%eax),%eax
  801fe9:	eb 05                	jmp    801ff0 <print_mem_block_lists+0xa3>
  801feb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff0:	a3 40 51 80 00       	mov    %eax,0x805140
  801ff5:	a1 40 51 80 00       	mov    0x805140,%eax
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	75 8a                	jne    801f88 <print_mem_block_lists+0x3b>
  801ffe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802002:	75 84                	jne    801f88 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802004:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802008:	75 10                	jne    80201a <print_mem_block_lists+0xcd>
  80200a:	83 ec 0c             	sub    $0xc,%esp
  80200d:	68 f4 3f 80 00       	push   $0x803ff4
  802012:	e8 8f e7 ff ff       	call   8007a6 <cprintf>
  802017:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80201a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802021:	83 ec 0c             	sub    $0xc,%esp
  802024:	68 18 40 80 00       	push   $0x804018
  802029:	e8 78 e7 ff ff       	call   8007a6 <cprintf>
  80202e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802031:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802035:	a1 40 50 80 00       	mov    0x805040,%eax
  80203a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203d:	eb 56                	jmp    802095 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80203f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802043:	74 1c                	je     802061 <print_mem_block_lists+0x114>
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	8b 50 08             	mov    0x8(%eax),%edx
  80204b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204e:	8b 48 08             	mov    0x8(%eax),%ecx
  802051:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802054:	8b 40 0c             	mov    0xc(%eax),%eax
  802057:	01 c8                	add    %ecx,%eax
  802059:	39 c2                	cmp    %eax,%edx
  80205b:	73 04                	jae    802061 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80205d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802064:	8b 50 08             	mov    0x8(%eax),%edx
  802067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206a:	8b 40 0c             	mov    0xc(%eax),%eax
  80206d:	01 c2                	add    %eax,%edx
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	8b 40 08             	mov    0x8(%eax),%eax
  802075:	83 ec 04             	sub    $0x4,%esp
  802078:	52                   	push   %edx
  802079:	50                   	push   %eax
  80207a:	68 e5 3f 80 00       	push   $0x803fe5
  80207f:	e8 22 e7 ff ff       	call   8007a6 <cprintf>
  802084:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80208d:	a1 48 50 80 00       	mov    0x805048,%eax
  802092:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802095:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802099:	74 07                	je     8020a2 <print_mem_block_lists+0x155>
  80209b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209e:	8b 00                	mov    (%eax),%eax
  8020a0:	eb 05                	jmp    8020a7 <print_mem_block_lists+0x15a>
  8020a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a7:	a3 48 50 80 00       	mov    %eax,0x805048
  8020ac:	a1 48 50 80 00       	mov    0x805048,%eax
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	75 8a                	jne    80203f <print_mem_block_lists+0xf2>
  8020b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b9:	75 84                	jne    80203f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020bb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020bf:	75 10                	jne    8020d1 <print_mem_block_lists+0x184>
  8020c1:	83 ec 0c             	sub    $0xc,%esp
  8020c4:	68 30 40 80 00       	push   $0x804030
  8020c9:	e8 d8 e6 ff ff       	call   8007a6 <cprintf>
  8020ce:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	68 a4 3f 80 00       	push   $0x803fa4
  8020d9:	e8 c8 e6 ff ff       	call   8007a6 <cprintf>
  8020de:	83 c4 10             	add    $0x10,%esp

}
  8020e1:	90                   	nop
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020ea:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020f1:	00 00 00 
  8020f4:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020fb:	00 00 00 
  8020fe:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802105:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802108:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80210f:	e9 9e 00 00 00       	jmp    8021b2 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802114:	a1 50 50 80 00       	mov    0x805050,%eax
  802119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211c:	c1 e2 04             	shl    $0x4,%edx
  80211f:	01 d0                	add    %edx,%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	75 14                	jne    802139 <initialize_MemBlocksList+0x55>
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	68 58 40 80 00       	push   $0x804058
  80212d:	6a 46                	push   $0x46
  80212f:	68 7b 40 80 00       	push   $0x80407b
  802134:	e8 b9 e3 ff ff       	call   8004f2 <_panic>
  802139:	a1 50 50 80 00       	mov    0x805050,%eax
  80213e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802141:	c1 e2 04             	shl    $0x4,%edx
  802144:	01 d0                	add    %edx,%eax
  802146:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80214c:	89 10                	mov    %edx,(%eax)
  80214e:	8b 00                	mov    (%eax),%eax
  802150:	85 c0                	test   %eax,%eax
  802152:	74 18                	je     80216c <initialize_MemBlocksList+0x88>
  802154:	a1 48 51 80 00       	mov    0x805148,%eax
  802159:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80215f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802162:	c1 e1 04             	shl    $0x4,%ecx
  802165:	01 ca                	add    %ecx,%edx
  802167:	89 50 04             	mov    %edx,0x4(%eax)
  80216a:	eb 12                	jmp    80217e <initialize_MemBlocksList+0x9a>
  80216c:	a1 50 50 80 00       	mov    0x805050,%eax
  802171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802174:	c1 e2 04             	shl    $0x4,%edx
  802177:	01 d0                	add    %edx,%eax
  802179:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80217e:	a1 50 50 80 00       	mov    0x805050,%eax
  802183:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802186:	c1 e2 04             	shl    $0x4,%edx
  802189:	01 d0                	add    %edx,%eax
  80218b:	a3 48 51 80 00       	mov    %eax,0x805148
  802190:	a1 50 50 80 00       	mov    0x805050,%eax
  802195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802198:	c1 e2 04             	shl    $0x4,%edx
  80219b:	01 d0                	add    %edx,%eax
  80219d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8021a9:	40                   	inc    %eax
  8021aa:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021af:	ff 45 f4             	incl   -0xc(%ebp)
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b8:	0f 82 56 ff ff ff    	jb     802114 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021be:	90                   	nop
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	8b 00                	mov    (%eax),%eax
  8021cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021cf:	eb 19                	jmp    8021ea <find_block+0x29>
	{
		if(va==point->sva)
  8021d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d4:	8b 40 08             	mov    0x8(%eax),%eax
  8021d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021da:	75 05                	jne    8021e1 <find_block+0x20>
		   return point;
  8021dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021df:	eb 36                	jmp    802217 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	8b 40 08             	mov    0x8(%eax),%eax
  8021e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ee:	74 07                	je     8021f7 <find_block+0x36>
  8021f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f3:	8b 00                	mov    (%eax),%eax
  8021f5:	eb 05                	jmp    8021fc <find_block+0x3b>
  8021f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ff:	89 42 08             	mov    %eax,0x8(%edx)
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	8b 40 08             	mov    0x8(%eax),%eax
  802208:	85 c0                	test   %eax,%eax
  80220a:	75 c5                	jne    8021d1 <find_block+0x10>
  80220c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802210:	75 bf                	jne    8021d1 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802212:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80221f:	a1 40 50 80 00       	mov    0x805040,%eax
  802224:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802227:	a1 44 50 80 00       	mov    0x805044,%eax
  80222c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80222f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802232:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802235:	74 24                	je     80225b <insert_sorted_allocList+0x42>
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	8b 50 08             	mov    0x8(%eax),%edx
  80223d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802240:	8b 40 08             	mov    0x8(%eax),%eax
  802243:	39 c2                	cmp    %eax,%edx
  802245:	76 14                	jbe    80225b <insert_sorted_allocList+0x42>
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8b 50 08             	mov    0x8(%eax),%edx
  80224d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802250:	8b 40 08             	mov    0x8(%eax),%eax
  802253:	39 c2                	cmp    %eax,%edx
  802255:	0f 82 60 01 00 00    	jb     8023bb <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80225b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80225f:	75 65                	jne    8022c6 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802261:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802265:	75 14                	jne    80227b <insert_sorted_allocList+0x62>
  802267:	83 ec 04             	sub    $0x4,%esp
  80226a:	68 58 40 80 00       	push   $0x804058
  80226f:	6a 6b                	push   $0x6b
  802271:	68 7b 40 80 00       	push   $0x80407b
  802276:	e8 77 e2 ff ff       	call   8004f2 <_panic>
  80227b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	89 10                	mov    %edx,(%eax)
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	8b 00                	mov    (%eax),%eax
  80228b:	85 c0                	test   %eax,%eax
  80228d:	74 0d                	je     80229c <insert_sorted_allocList+0x83>
  80228f:	a1 40 50 80 00       	mov    0x805040,%eax
  802294:	8b 55 08             	mov    0x8(%ebp),%edx
  802297:	89 50 04             	mov    %edx,0x4(%eax)
  80229a:	eb 08                	jmp    8022a4 <insert_sorted_allocList+0x8b>
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	a3 44 50 80 00       	mov    %eax,0x805044
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	a3 40 50 80 00       	mov    %eax,0x805040
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022bb:	40                   	inc    %eax
  8022bc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022c1:	e9 dc 01 00 00       	jmp    8024a2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 50 08             	mov    0x8(%eax),%edx
  8022cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cf:	8b 40 08             	mov    0x8(%eax),%eax
  8022d2:	39 c2                	cmp    %eax,%edx
  8022d4:	77 6c                	ja     802342 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022da:	74 06                	je     8022e2 <insert_sorted_allocList+0xc9>
  8022dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e0:	75 14                	jne    8022f6 <insert_sorted_allocList+0xdd>
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	68 94 40 80 00       	push   $0x804094
  8022ea:	6a 6f                	push   $0x6f
  8022ec:	68 7b 40 80 00       	push   $0x80407b
  8022f1:	e8 fc e1 ff ff       	call   8004f2 <_panic>
  8022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f9:	8b 50 04             	mov    0x4(%eax),%edx
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	89 50 04             	mov    %edx,0x4(%eax)
  802302:	8b 45 08             	mov    0x8(%ebp),%eax
  802305:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802308:	89 10                	mov    %edx,(%eax)
  80230a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230d:	8b 40 04             	mov    0x4(%eax),%eax
  802310:	85 c0                	test   %eax,%eax
  802312:	74 0d                	je     802321 <insert_sorted_allocList+0x108>
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	8b 40 04             	mov    0x4(%eax),%eax
  80231a:	8b 55 08             	mov    0x8(%ebp),%edx
  80231d:	89 10                	mov    %edx,(%eax)
  80231f:	eb 08                	jmp    802329 <insert_sorted_allocList+0x110>
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	a3 40 50 80 00       	mov    %eax,0x805040
  802329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232c:	8b 55 08             	mov    0x8(%ebp),%edx
  80232f:	89 50 04             	mov    %edx,0x4(%eax)
  802332:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802337:	40                   	inc    %eax
  802338:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80233d:	e9 60 01 00 00       	jmp    8024a2 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	8b 50 08             	mov    0x8(%eax),%edx
  802348:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234b:	8b 40 08             	mov    0x8(%eax),%eax
  80234e:	39 c2                	cmp    %eax,%edx
  802350:	0f 82 4c 01 00 00    	jb     8024a2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802356:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80235a:	75 14                	jne    802370 <insert_sorted_allocList+0x157>
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	68 cc 40 80 00       	push   $0x8040cc
  802364:	6a 73                	push   $0x73
  802366:	68 7b 40 80 00       	push   $0x80407b
  80236b:	e8 82 e1 ff ff       	call   8004f2 <_panic>
  802370:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	89 50 04             	mov    %edx,0x4(%eax)
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	8b 40 04             	mov    0x4(%eax),%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	74 0c                	je     802392 <insert_sorted_allocList+0x179>
  802386:	a1 44 50 80 00       	mov    0x805044,%eax
  80238b:	8b 55 08             	mov    0x8(%ebp),%edx
  80238e:	89 10                	mov    %edx,(%eax)
  802390:	eb 08                	jmp    80239a <insert_sorted_allocList+0x181>
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	a3 40 50 80 00       	mov    %eax,0x805040
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	a3 44 50 80 00       	mov    %eax,0x805044
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ab:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023b0:	40                   	inc    %eax
  8023b1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023b6:	e9 e7 00 00 00       	jmp    8024a2 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8023cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d0:	e9 9d 00 00 00       	jmp    802472 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 00                	mov    (%eax),%eax
  8023da:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	8b 50 08             	mov    0x8(%eax),%edx
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 40 08             	mov    0x8(%eax),%eax
  8023e9:	39 c2                	cmp    %eax,%edx
  8023eb:	76 7d                	jbe    80246a <insert_sorted_allocList+0x251>
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	8b 50 08             	mov    0x8(%eax),%edx
  8023f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023f6:	8b 40 08             	mov    0x8(%eax),%eax
  8023f9:	39 c2                	cmp    %eax,%edx
  8023fb:	73 6d                	jae    80246a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802401:	74 06                	je     802409 <insert_sorted_allocList+0x1f0>
  802403:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802407:	75 14                	jne    80241d <insert_sorted_allocList+0x204>
  802409:	83 ec 04             	sub    $0x4,%esp
  80240c:	68 f0 40 80 00       	push   $0x8040f0
  802411:	6a 7f                	push   $0x7f
  802413:	68 7b 40 80 00       	push   $0x80407b
  802418:	e8 d5 e0 ff ff       	call   8004f2 <_panic>
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 10                	mov    (%eax),%edx
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	89 10                	mov    %edx,(%eax)
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	8b 00                	mov    (%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	74 0b                	je     80243b <insert_sorted_allocList+0x222>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	8b 55 08             	mov    0x8(%ebp),%edx
  802438:	89 50 04             	mov    %edx,0x4(%eax)
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 55 08             	mov    0x8(%ebp),%edx
  802441:	89 10                	mov    %edx,(%eax)
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802449:	89 50 04             	mov    %edx,0x4(%eax)
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	8b 00                	mov    (%eax),%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	75 08                	jne    80245d <insert_sorted_allocList+0x244>
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	a3 44 50 80 00       	mov    %eax,0x805044
  80245d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802462:	40                   	inc    %eax
  802463:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802468:	eb 39                	jmp    8024a3 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80246a:	a1 48 50 80 00       	mov    0x805048,%eax
  80246f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802476:	74 07                	je     80247f <insert_sorted_allocList+0x266>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	eb 05                	jmp    802484 <insert_sorted_allocList+0x26b>
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
  802484:	a3 48 50 80 00       	mov    %eax,0x805048
  802489:	a1 48 50 80 00       	mov    0x805048,%eax
  80248e:	85 c0                	test   %eax,%eax
  802490:	0f 85 3f ff ff ff    	jne    8023d5 <insert_sorted_allocList+0x1bc>
  802496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249a:	0f 85 35 ff ff ff    	jne    8023d5 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024a0:	eb 01                	jmp    8024a3 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024a2:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024a3:	90                   	nop
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
  8024a9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024ac:	a1 38 51 80 00       	mov    0x805138,%eax
  8024b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b4:	e9 85 01 00 00       	jmp    80263e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c2:	0f 82 6e 01 00 00    	jb     802636 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d1:	0f 85 8a 00 00 00    	jne    802561 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024db:	75 17                	jne    8024f4 <alloc_block_FF+0x4e>
  8024dd:	83 ec 04             	sub    $0x4,%esp
  8024e0:	68 24 41 80 00       	push   $0x804124
  8024e5:	68 93 00 00 00       	push   $0x93
  8024ea:	68 7b 40 80 00       	push   $0x80407b
  8024ef:	e8 fe df ff ff       	call   8004f2 <_panic>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	74 10                	je     80250d <alloc_block_FF+0x67>
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802505:	8b 52 04             	mov    0x4(%edx),%edx
  802508:	89 50 04             	mov    %edx,0x4(%eax)
  80250b:	eb 0b                	jmp    802518 <alloc_block_FF+0x72>
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 40 04             	mov    0x4(%eax),%eax
  802513:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 04             	mov    0x4(%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 0f                	je     802531 <alloc_block_FF+0x8b>
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 40 04             	mov    0x4(%eax),%eax
  802528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252b:	8b 12                	mov    (%edx),%edx
  80252d:	89 10                	mov    %edx,(%eax)
  80252f:	eb 0a                	jmp    80253b <alloc_block_FF+0x95>
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 00                	mov    (%eax),%eax
  802536:	a3 38 51 80 00       	mov    %eax,0x805138
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80254e:	a1 44 51 80 00       	mov    0x805144,%eax
  802553:	48                   	dec    %eax
  802554:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	e9 10 01 00 00       	jmp    802671 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 0c             	mov    0xc(%eax),%eax
  802567:	3b 45 08             	cmp    0x8(%ebp),%eax
  80256a:	0f 86 c6 00 00 00    	jbe    802636 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802570:	a1 48 51 80 00       	mov    0x805148,%eax
  802575:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 50 08             	mov    0x8(%eax),%edx
  80257e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802581:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802587:	8b 55 08             	mov    0x8(%ebp),%edx
  80258a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80258d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802591:	75 17                	jne    8025aa <alloc_block_FF+0x104>
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	68 24 41 80 00       	push   $0x804124
  80259b:	68 9b 00 00 00       	push   $0x9b
  8025a0:	68 7b 40 80 00       	push   $0x80407b
  8025a5:	e8 48 df ff ff       	call   8004f2 <_panic>
  8025aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ad:	8b 00                	mov    (%eax),%eax
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	74 10                	je     8025c3 <alloc_block_FF+0x11d>
  8025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025bb:	8b 52 04             	mov    0x4(%edx),%edx
  8025be:	89 50 04             	mov    %edx,0x4(%eax)
  8025c1:	eb 0b                	jmp    8025ce <alloc_block_FF+0x128>
  8025c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c6:	8b 40 04             	mov    0x4(%eax),%eax
  8025c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d1:	8b 40 04             	mov    0x4(%eax),%eax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	74 0f                	je     8025e7 <alloc_block_FF+0x141>
  8025d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025db:	8b 40 04             	mov    0x4(%eax),%eax
  8025de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e1:	8b 12                	mov    (%edx),%edx
  8025e3:	89 10                	mov    %edx,(%eax)
  8025e5:	eb 0a                	jmp    8025f1 <alloc_block_FF+0x14b>
  8025e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ea:	8b 00                	mov    (%eax),%eax
  8025ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8025f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802604:	a1 54 51 80 00       	mov    0x805154,%eax
  802609:	48                   	dec    %eax
  80260a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 50 08             	mov    0x8(%eax),%edx
  802615:	8b 45 08             	mov    0x8(%ebp),%eax
  802618:	01 c2                	add    %eax,%edx
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 0c             	mov    0xc(%eax),%eax
  802626:	2b 45 08             	sub    0x8(%ebp),%eax
  802629:	89 c2                	mov    %eax,%edx
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802634:	eb 3b                	jmp    802671 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802636:	a1 40 51 80 00       	mov    0x805140,%eax
  80263b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802642:	74 07                	je     80264b <alloc_block_FF+0x1a5>
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 00                	mov    (%eax),%eax
  802649:	eb 05                	jmp    802650 <alloc_block_FF+0x1aa>
  80264b:	b8 00 00 00 00       	mov    $0x0,%eax
  802650:	a3 40 51 80 00       	mov    %eax,0x805140
  802655:	a1 40 51 80 00       	mov    0x805140,%eax
  80265a:	85 c0                	test   %eax,%eax
  80265c:	0f 85 57 fe ff ff    	jne    8024b9 <alloc_block_FF+0x13>
  802662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802666:	0f 85 4d fe ff ff    	jne    8024b9 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802679:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802680:	a1 38 51 80 00       	mov    0x805138,%eax
  802685:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802688:	e9 df 00 00 00       	jmp    80276c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 0c             	mov    0xc(%eax),%eax
  802693:	3b 45 08             	cmp    0x8(%ebp),%eax
  802696:	0f 82 c8 00 00 00    	jb     802764 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a5:	0f 85 8a 00 00 00    	jne    802735 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026af:	75 17                	jne    8026c8 <alloc_block_BF+0x55>
  8026b1:	83 ec 04             	sub    $0x4,%esp
  8026b4:	68 24 41 80 00       	push   $0x804124
  8026b9:	68 b7 00 00 00       	push   $0xb7
  8026be:	68 7b 40 80 00       	push   $0x80407b
  8026c3:	e8 2a de ff ff       	call   8004f2 <_panic>
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 00                	mov    (%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 10                	je     8026e1 <alloc_block_BF+0x6e>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 00                	mov    (%eax),%eax
  8026d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d9:	8b 52 04             	mov    0x4(%edx),%edx
  8026dc:	89 50 04             	mov    %edx,0x4(%eax)
  8026df:	eb 0b                	jmp    8026ec <alloc_block_BF+0x79>
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	8b 40 04             	mov    0x4(%eax),%eax
  8026e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 40 04             	mov    0x4(%eax),%eax
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	74 0f                	je     802705 <alloc_block_BF+0x92>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 04             	mov    0x4(%eax),%eax
  8026fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ff:	8b 12                	mov    (%edx),%edx
  802701:	89 10                	mov    %edx,(%eax)
  802703:	eb 0a                	jmp    80270f <alloc_block_BF+0x9c>
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 00                	mov    (%eax),%eax
  80270a:	a3 38 51 80 00       	mov    %eax,0x805138
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802722:	a1 44 51 80 00       	mov    0x805144,%eax
  802727:	48                   	dec    %eax
  802728:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	e9 4d 01 00 00       	jmp    802882 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 40 0c             	mov    0xc(%eax),%eax
  80273b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273e:	76 24                	jbe    802764 <alloc_block_BF+0xf1>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 40 0c             	mov    0xc(%eax),%eax
  802746:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802749:	73 19                	jae    802764 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80274b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 40 0c             	mov    0xc(%eax),%eax
  802758:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 40 08             	mov    0x8(%eax),%eax
  802761:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802764:	a1 40 51 80 00       	mov    0x805140,%eax
  802769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802770:	74 07                	je     802779 <alloc_block_BF+0x106>
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	eb 05                	jmp    80277e <alloc_block_BF+0x10b>
  802779:	b8 00 00 00 00       	mov    $0x0,%eax
  80277e:	a3 40 51 80 00       	mov    %eax,0x805140
  802783:	a1 40 51 80 00       	mov    0x805140,%eax
  802788:	85 c0                	test   %eax,%eax
  80278a:	0f 85 fd fe ff ff    	jne    80268d <alloc_block_BF+0x1a>
  802790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802794:	0f 85 f3 fe ff ff    	jne    80268d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80279a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80279e:	0f 84 d9 00 00 00    	je     80287d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8027a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b2:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bb:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027c2:	75 17                	jne    8027db <alloc_block_BF+0x168>
  8027c4:	83 ec 04             	sub    $0x4,%esp
  8027c7:	68 24 41 80 00       	push   $0x804124
  8027cc:	68 c7 00 00 00       	push   $0xc7
  8027d1:	68 7b 40 80 00       	push   $0x80407b
  8027d6:	e8 17 dd ff ff       	call   8004f2 <_panic>
  8027db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	74 10                	je     8027f4 <alloc_block_BF+0x181>
  8027e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e7:	8b 00                	mov    (%eax),%eax
  8027e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ec:	8b 52 04             	mov    0x4(%edx),%edx
  8027ef:	89 50 04             	mov    %edx,0x4(%eax)
  8027f2:	eb 0b                	jmp    8027ff <alloc_block_BF+0x18c>
  8027f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f7:	8b 40 04             	mov    0x4(%eax),%eax
  8027fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802802:	8b 40 04             	mov    0x4(%eax),%eax
  802805:	85 c0                	test   %eax,%eax
  802807:	74 0f                	je     802818 <alloc_block_BF+0x1a5>
  802809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280c:	8b 40 04             	mov    0x4(%eax),%eax
  80280f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802812:	8b 12                	mov    (%edx),%edx
  802814:	89 10                	mov    %edx,(%eax)
  802816:	eb 0a                	jmp    802822 <alloc_block_BF+0x1af>
  802818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	a3 48 51 80 00       	mov    %eax,0x805148
  802822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802825:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802835:	a1 54 51 80 00       	mov    0x805154,%eax
  80283a:	48                   	dec    %eax
  80283b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802840:	83 ec 08             	sub    $0x8,%esp
  802843:	ff 75 ec             	pushl  -0x14(%ebp)
  802846:	68 38 51 80 00       	push   $0x805138
  80284b:	e8 71 f9 ff ff       	call   8021c1 <find_block>
  802850:	83 c4 10             	add    $0x10,%esp
  802853:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802856:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802859:	8b 50 08             	mov    0x8(%eax),%edx
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	01 c2                	add    %eax,%edx
  802861:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802864:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802867:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286a:	8b 40 0c             	mov    0xc(%eax),%eax
  80286d:	2b 45 08             	sub    0x8(%ebp),%eax
  802870:	89 c2                	mov    %eax,%edx
  802872:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802875:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287b:	eb 05                	jmp    802882 <alloc_block_BF+0x20f>
	}
	return NULL;
  80287d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802882:	c9                   	leave  
  802883:	c3                   	ret    

00802884 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802884:	55                   	push   %ebp
  802885:	89 e5                	mov    %esp,%ebp
  802887:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80288a:	a1 28 50 80 00       	mov    0x805028,%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	0f 85 de 01 00 00    	jne    802a75 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802897:	a1 38 51 80 00       	mov    0x805138,%eax
  80289c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289f:	e9 9e 01 00 00       	jmp    802a42 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ad:	0f 82 87 01 00 00    	jb     802a3a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028bc:	0f 85 95 00 00 00    	jne    802957 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c6:	75 17                	jne    8028df <alloc_block_NF+0x5b>
  8028c8:	83 ec 04             	sub    $0x4,%esp
  8028cb:	68 24 41 80 00       	push   $0x804124
  8028d0:	68 e0 00 00 00       	push   $0xe0
  8028d5:	68 7b 40 80 00       	push   $0x80407b
  8028da:	e8 13 dc ff ff       	call   8004f2 <_panic>
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	74 10                	je     8028f8 <alloc_block_NF+0x74>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f0:	8b 52 04             	mov    0x4(%edx),%edx
  8028f3:	89 50 04             	mov    %edx,0x4(%eax)
  8028f6:	eb 0b                	jmp    802903 <alloc_block_NF+0x7f>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 40 04             	mov    0x4(%eax),%eax
  8028fe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 40 04             	mov    0x4(%eax),%eax
  802909:	85 c0                	test   %eax,%eax
  80290b:	74 0f                	je     80291c <alloc_block_NF+0x98>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 40 04             	mov    0x4(%eax),%eax
  802913:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802916:	8b 12                	mov    (%edx),%edx
  802918:	89 10                	mov    %edx,(%eax)
  80291a:	eb 0a                	jmp    802926 <alloc_block_NF+0xa2>
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	a3 38 51 80 00       	mov    %eax,0x805138
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802939:	a1 44 51 80 00       	mov    0x805144,%eax
  80293e:	48                   	dec    %eax
  80293f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 40 08             	mov    0x8(%eax),%eax
  80294a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	e9 f8 04 00 00       	jmp    802e4f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802960:	0f 86 d4 00 00 00    	jbe    802a3a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802966:	a1 48 51 80 00       	mov    0x805148,%eax
  80296b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 50 08             	mov    0x8(%eax),%edx
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	8b 55 08             	mov    0x8(%ebp),%edx
  802980:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802983:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802987:	75 17                	jne    8029a0 <alloc_block_NF+0x11c>
  802989:	83 ec 04             	sub    $0x4,%esp
  80298c:	68 24 41 80 00       	push   $0x804124
  802991:	68 e9 00 00 00       	push   $0xe9
  802996:	68 7b 40 80 00       	push   $0x80407b
  80299b:	e8 52 db ff ff       	call   8004f2 <_panic>
  8029a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 10                	je     8029b9 <alloc_block_NF+0x135>
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b1:	8b 52 04             	mov    0x4(%edx),%edx
  8029b4:	89 50 04             	mov    %edx,0x4(%eax)
  8029b7:	eb 0b                	jmp    8029c4 <alloc_block_NF+0x140>
  8029b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bc:	8b 40 04             	mov    0x4(%eax),%eax
  8029bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	74 0f                	je     8029dd <alloc_block_NF+0x159>
  8029ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d1:	8b 40 04             	mov    0x4(%eax),%eax
  8029d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d7:	8b 12                	mov    (%edx),%edx
  8029d9:	89 10                	mov    %edx,(%eax)
  8029db:	eb 0a                	jmp    8029e7 <alloc_block_NF+0x163>
  8029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e0:	8b 00                	mov    (%eax),%eax
  8029e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8029ff:	48                   	dec    %eax
  802a00:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	8b 40 08             	mov    0x8(%eax),%eax
  802a0b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 50 08             	mov    0x8(%eax),%edx
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	01 c2                	add    %eax,%edx
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 0c             	mov    0xc(%eax),%eax
  802a27:	2b 45 08             	sub    0x8(%ebp),%eax
  802a2a:	89 c2                	mov    %eax,%edx
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a35:	e9 15 04 00 00       	jmp    802e4f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a3a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a46:	74 07                	je     802a4f <alloc_block_NF+0x1cb>
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	eb 05                	jmp    802a54 <alloc_block_NF+0x1d0>
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a54:	a3 40 51 80 00       	mov    %eax,0x805140
  802a59:	a1 40 51 80 00       	mov    0x805140,%eax
  802a5e:	85 c0                	test   %eax,%eax
  802a60:	0f 85 3e fe ff ff    	jne    8028a4 <alloc_block_NF+0x20>
  802a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6a:	0f 85 34 fe ff ff    	jne    8028a4 <alloc_block_NF+0x20>
  802a70:	e9 d5 03 00 00       	jmp    802e4a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a75:	a1 38 51 80 00       	mov    0x805138,%eax
  802a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7d:	e9 b1 01 00 00       	jmp    802c33 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 50 08             	mov    0x8(%eax),%edx
  802a88:	a1 28 50 80 00       	mov    0x805028,%eax
  802a8d:	39 c2                	cmp    %eax,%edx
  802a8f:	0f 82 96 01 00 00    	jb     802c2b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9e:	0f 82 87 01 00 00    	jb     802c2b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aad:	0f 85 95 00 00 00    	jne    802b48 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ab3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab7:	75 17                	jne    802ad0 <alloc_block_NF+0x24c>
  802ab9:	83 ec 04             	sub    $0x4,%esp
  802abc:	68 24 41 80 00       	push   $0x804124
  802ac1:	68 fc 00 00 00       	push   $0xfc
  802ac6:	68 7b 40 80 00       	push   $0x80407b
  802acb:	e8 22 da ff ff       	call   8004f2 <_panic>
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 00                	mov    (%eax),%eax
  802ad5:	85 c0                	test   %eax,%eax
  802ad7:	74 10                	je     802ae9 <alloc_block_NF+0x265>
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae1:	8b 52 04             	mov    0x4(%edx),%edx
  802ae4:	89 50 04             	mov    %edx,0x4(%eax)
  802ae7:	eb 0b                	jmp    802af4 <alloc_block_NF+0x270>
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 40 04             	mov    0x4(%eax),%eax
  802aef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 04             	mov    0x4(%eax),%eax
  802afa:	85 c0                	test   %eax,%eax
  802afc:	74 0f                	je     802b0d <alloc_block_NF+0x289>
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 04             	mov    0x4(%eax),%eax
  802b04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b07:	8b 12                	mov    (%edx),%edx
  802b09:	89 10                	mov    %edx,(%eax)
  802b0b:	eb 0a                	jmp    802b17 <alloc_block_NF+0x293>
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	a3 38 51 80 00       	mov    %eax,0x805138
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2a:	a1 44 51 80 00       	mov    0x805144,%eax
  802b2f:	48                   	dec    %eax
  802b30:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 40 08             	mov    0x8(%eax),%eax
  802b3b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	e9 07 03 00 00       	jmp    802e4f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b51:	0f 86 d4 00 00 00    	jbe    802c2b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b57:	a1 48 51 80 00       	mov    0x805148,%eax
  802b5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 50 08             	mov    0x8(%eax),%edx
  802b65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b68:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b71:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b78:	75 17                	jne    802b91 <alloc_block_NF+0x30d>
  802b7a:	83 ec 04             	sub    $0x4,%esp
  802b7d:	68 24 41 80 00       	push   $0x804124
  802b82:	68 04 01 00 00       	push   $0x104
  802b87:	68 7b 40 80 00       	push   $0x80407b
  802b8c:	e8 61 d9 ff ff       	call   8004f2 <_panic>
  802b91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	85 c0                	test   %eax,%eax
  802b98:	74 10                	je     802baa <alloc_block_NF+0x326>
  802b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9d:	8b 00                	mov    (%eax),%eax
  802b9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba2:	8b 52 04             	mov    0x4(%edx),%edx
  802ba5:	89 50 04             	mov    %edx,0x4(%eax)
  802ba8:	eb 0b                	jmp    802bb5 <alloc_block_NF+0x331>
  802baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bad:	8b 40 04             	mov    0x4(%eax),%eax
  802bb0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb8:	8b 40 04             	mov    0x4(%eax),%eax
  802bbb:	85 c0                	test   %eax,%eax
  802bbd:	74 0f                	je     802bce <alloc_block_NF+0x34a>
  802bbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc2:	8b 40 04             	mov    0x4(%eax),%eax
  802bc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bc8:	8b 12                	mov    (%edx),%edx
  802bca:	89 10                	mov    %edx,(%eax)
  802bcc:	eb 0a                	jmp    802bd8 <alloc_block_NF+0x354>
  802bce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	a3 48 51 80 00       	mov    %eax,0x805148
  802bd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802beb:	a1 54 51 80 00       	mov    0x805154,%eax
  802bf0:	48                   	dec    %eax
  802bf1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf9:	8b 40 08             	mov    0x8(%eax),%eax
  802bfc:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 50 08             	mov    0x8(%eax),%edx
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	01 c2                	add    %eax,%edx
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 40 0c             	mov    0xc(%eax),%eax
  802c18:	2b 45 08             	sub    0x8(%ebp),%eax
  802c1b:	89 c2                	mov    %eax,%edx
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c26:	e9 24 02 00 00       	jmp    802e4f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c2b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c37:	74 07                	je     802c40 <alloc_block_NF+0x3bc>
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 00                	mov    (%eax),%eax
  802c3e:	eb 05                	jmp    802c45 <alloc_block_NF+0x3c1>
  802c40:	b8 00 00 00 00       	mov    $0x0,%eax
  802c45:	a3 40 51 80 00       	mov    %eax,0x805140
  802c4a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c4f:	85 c0                	test   %eax,%eax
  802c51:	0f 85 2b fe ff ff    	jne    802a82 <alloc_block_NF+0x1fe>
  802c57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5b:	0f 85 21 fe ff ff    	jne    802a82 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c61:	a1 38 51 80 00       	mov    0x805138,%eax
  802c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c69:	e9 ae 01 00 00       	jmp    802e1c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	8b 50 08             	mov    0x8(%eax),%edx
  802c74:	a1 28 50 80 00       	mov    0x805028,%eax
  802c79:	39 c2                	cmp    %eax,%edx
  802c7b:	0f 83 93 01 00 00    	jae    802e14 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 0c             	mov    0xc(%eax),%eax
  802c87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c8a:	0f 82 84 01 00 00    	jb     802e14 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 40 0c             	mov    0xc(%eax),%eax
  802c96:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c99:	0f 85 95 00 00 00    	jne    802d34 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca3:	75 17                	jne    802cbc <alloc_block_NF+0x438>
  802ca5:	83 ec 04             	sub    $0x4,%esp
  802ca8:	68 24 41 80 00       	push   $0x804124
  802cad:	68 14 01 00 00       	push   $0x114
  802cb2:	68 7b 40 80 00       	push   $0x80407b
  802cb7:	e8 36 d8 ff ff       	call   8004f2 <_panic>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	74 10                	je     802cd5 <alloc_block_NF+0x451>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccd:	8b 52 04             	mov    0x4(%edx),%edx
  802cd0:	89 50 04             	mov    %edx,0x4(%eax)
  802cd3:	eb 0b                	jmp    802ce0 <alloc_block_NF+0x45c>
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 40 04             	mov    0x4(%eax),%eax
  802cdb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 40 04             	mov    0x4(%eax),%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	74 0f                	je     802cf9 <alloc_block_NF+0x475>
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 40 04             	mov    0x4(%eax),%eax
  802cf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf3:	8b 12                	mov    (%edx),%edx
  802cf5:	89 10                	mov    %edx,(%eax)
  802cf7:	eb 0a                	jmp    802d03 <alloc_block_NF+0x47f>
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 00                	mov    (%eax),%eax
  802cfe:	a3 38 51 80 00       	mov    %eax,0x805138
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d16:	a1 44 51 80 00       	mov    0x805144,%eax
  802d1b:	48                   	dec    %eax
  802d1c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 40 08             	mov    0x8(%eax),%eax
  802d27:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	e9 1b 01 00 00       	jmp    802e4f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d3d:	0f 86 d1 00 00 00    	jbe    802e14 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d43:	a1 48 51 80 00       	mov    0x805148,%eax
  802d48:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 50 08             	mov    0x8(%eax),%edx
  802d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d54:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d64:	75 17                	jne    802d7d <alloc_block_NF+0x4f9>
  802d66:	83 ec 04             	sub    $0x4,%esp
  802d69:	68 24 41 80 00       	push   $0x804124
  802d6e:	68 1c 01 00 00       	push   $0x11c
  802d73:	68 7b 40 80 00       	push   $0x80407b
  802d78:	e8 75 d7 ff ff       	call   8004f2 <_panic>
  802d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d80:	8b 00                	mov    (%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 10                	je     802d96 <alloc_block_NF+0x512>
  802d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d8e:	8b 52 04             	mov    0x4(%edx),%edx
  802d91:	89 50 04             	mov    %edx,0x4(%eax)
  802d94:	eb 0b                	jmp    802da1 <alloc_block_NF+0x51d>
  802d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d99:	8b 40 04             	mov    0x4(%eax),%eax
  802d9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	8b 40 04             	mov    0x4(%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 0f                	je     802dba <alloc_block_NF+0x536>
  802dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dae:	8b 40 04             	mov    0x4(%eax),%eax
  802db1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802db4:	8b 12                	mov    (%edx),%edx
  802db6:	89 10                	mov    %edx,(%eax)
  802db8:	eb 0a                	jmp    802dc4 <alloc_block_NF+0x540>
  802dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	a3 48 51 80 00       	mov    %eax,0x805148
  802dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd7:	a1 54 51 80 00       	mov    0x805154,%eax
  802ddc:	48                   	dec    %eax
  802ddd:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de5:	8b 40 08             	mov    0x8(%eax),%eax
  802de8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 50 08             	mov    0x8(%eax),%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	01 c2                	add    %eax,%edx
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 40 0c             	mov    0xc(%eax),%eax
  802e04:	2b 45 08             	sub    0x8(%ebp),%eax
  802e07:	89 c2                	mov    %eax,%edx
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e12:	eb 3b                	jmp    802e4f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e14:	a1 40 51 80 00       	mov    0x805140,%eax
  802e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e20:	74 07                	je     802e29 <alloc_block_NF+0x5a5>
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	eb 05                	jmp    802e2e <alloc_block_NF+0x5aa>
  802e29:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2e:	a3 40 51 80 00       	mov    %eax,0x805140
  802e33:	a1 40 51 80 00       	mov    0x805140,%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	0f 85 2e fe ff ff    	jne    802c6e <alloc_block_NF+0x3ea>
  802e40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e44:	0f 85 24 fe ff ff    	jne    802c6e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e4f:	c9                   	leave  
  802e50:	c3                   	ret    

00802e51 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e51:	55                   	push   %ebp
  802e52:	89 e5                	mov    %esp,%ebp
  802e54:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e57:	a1 38 51 80 00       	mov    0x805138,%eax
  802e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e5f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e64:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e67:	a1 38 51 80 00       	mov    0x805138,%eax
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	74 14                	je     802e84 <insert_sorted_with_merge_freeList+0x33>
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	8b 50 08             	mov    0x8(%eax),%edx
  802e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e79:	8b 40 08             	mov    0x8(%eax),%eax
  802e7c:	39 c2                	cmp    %eax,%edx
  802e7e:	0f 87 9b 01 00 00    	ja     80301f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e88:	75 17                	jne    802ea1 <insert_sorted_with_merge_freeList+0x50>
  802e8a:	83 ec 04             	sub    $0x4,%esp
  802e8d:	68 58 40 80 00       	push   $0x804058
  802e92:	68 38 01 00 00       	push   $0x138
  802e97:	68 7b 40 80 00       	push   $0x80407b
  802e9c:	e8 51 d6 ff ff       	call   8004f2 <_panic>
  802ea1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	89 10                	mov    %edx,(%eax)
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	74 0d                	je     802ec2 <insert_sorted_with_merge_freeList+0x71>
  802eb5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eba:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebd:	89 50 04             	mov    %edx,0x4(%eax)
  802ec0:	eb 08                	jmp    802eca <insert_sorted_with_merge_freeList+0x79>
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	a3 38 51 80 00       	mov    %eax,0x805138
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edc:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee1:	40                   	inc    %eax
  802ee2:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ee7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eeb:	0f 84 a8 06 00 00    	je     803599 <insert_sorted_with_merge_freeList+0x748>
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	8b 50 08             	mov    0x8(%eax),%edx
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	8b 40 0c             	mov    0xc(%eax),%eax
  802efd:	01 c2                	add    %eax,%edx
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	8b 40 08             	mov    0x8(%eax),%eax
  802f05:	39 c2                	cmp    %eax,%edx
  802f07:	0f 85 8c 06 00 00    	jne    803599 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	8b 50 0c             	mov    0xc(%eax),%edx
  802f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f16:	8b 40 0c             	mov    0xc(%eax),%eax
  802f19:	01 c2                	add    %eax,%edx
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f25:	75 17                	jne    802f3e <insert_sorted_with_merge_freeList+0xed>
  802f27:	83 ec 04             	sub    $0x4,%esp
  802f2a:	68 24 41 80 00       	push   $0x804124
  802f2f:	68 3c 01 00 00       	push   $0x13c
  802f34:	68 7b 40 80 00       	push   $0x80407b
  802f39:	e8 b4 d5 ff ff       	call   8004f2 <_panic>
  802f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 10                	je     802f57 <insert_sorted_with_merge_freeList+0x106>
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f4f:	8b 52 04             	mov    0x4(%edx),%edx
  802f52:	89 50 04             	mov    %edx,0x4(%eax)
  802f55:	eb 0b                	jmp    802f62 <insert_sorted_with_merge_freeList+0x111>
  802f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5a:	8b 40 04             	mov    0x4(%eax),%eax
  802f5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	8b 40 04             	mov    0x4(%eax),%eax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	74 0f                	je     802f7b <insert_sorted_with_merge_freeList+0x12a>
  802f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6f:	8b 40 04             	mov    0x4(%eax),%eax
  802f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f75:	8b 12                	mov    (%edx),%edx
  802f77:	89 10                	mov    %edx,(%eax)
  802f79:	eb 0a                	jmp    802f85 <insert_sorted_with_merge_freeList+0x134>
  802f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	a3 38 51 80 00       	mov    %eax,0x805138
  802f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f98:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9d:	48                   	dec    %eax
  802f9e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fbb:	75 17                	jne    802fd4 <insert_sorted_with_merge_freeList+0x183>
  802fbd:	83 ec 04             	sub    $0x4,%esp
  802fc0:	68 58 40 80 00       	push   $0x804058
  802fc5:	68 3f 01 00 00       	push   $0x13f
  802fca:	68 7b 40 80 00       	push   $0x80407b
  802fcf:	e8 1e d5 ff ff       	call   8004f2 <_panic>
  802fd4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdd:	89 10                	mov    %edx,(%eax)
  802fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	85 c0                	test   %eax,%eax
  802fe6:	74 0d                	je     802ff5 <insert_sorted_with_merge_freeList+0x1a4>
  802fe8:	a1 48 51 80 00       	mov    0x805148,%eax
  802fed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ff0:	89 50 04             	mov    %edx,0x4(%eax)
  802ff3:	eb 08                	jmp    802ffd <insert_sorted_with_merge_freeList+0x1ac>
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803000:	a3 48 51 80 00       	mov    %eax,0x805148
  803005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803008:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300f:	a1 54 51 80 00       	mov    0x805154,%eax
  803014:	40                   	inc    %eax
  803015:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80301a:	e9 7a 05 00 00       	jmp    803599 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	8b 50 08             	mov    0x8(%eax),%edx
  803025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803028:	8b 40 08             	mov    0x8(%eax),%eax
  80302b:	39 c2                	cmp    %eax,%edx
  80302d:	0f 82 14 01 00 00    	jb     803147 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803033:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803036:	8b 50 08             	mov    0x8(%eax),%edx
  803039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303c:	8b 40 0c             	mov    0xc(%eax),%eax
  80303f:	01 c2                	add    %eax,%edx
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	8b 40 08             	mov    0x8(%eax),%eax
  803047:	39 c2                	cmp    %eax,%edx
  803049:	0f 85 90 00 00 00    	jne    8030df <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80304f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803052:	8b 50 0c             	mov    0xc(%eax),%edx
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	8b 40 0c             	mov    0xc(%eax),%eax
  80305b:	01 c2                	add    %eax,%edx
  80305d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803060:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803077:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307b:	75 17                	jne    803094 <insert_sorted_with_merge_freeList+0x243>
  80307d:	83 ec 04             	sub    $0x4,%esp
  803080:	68 58 40 80 00       	push   $0x804058
  803085:	68 49 01 00 00       	push   $0x149
  80308a:	68 7b 40 80 00       	push   $0x80407b
  80308f:	e8 5e d4 ff ff       	call   8004f2 <_panic>
  803094:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	89 10                	mov    %edx,(%eax)
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	85 c0                	test   %eax,%eax
  8030a6:	74 0d                	je     8030b5 <insert_sorted_with_merge_freeList+0x264>
  8030a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b0:	89 50 04             	mov    %edx,0x4(%eax)
  8030b3:	eb 08                	jmp    8030bd <insert_sorted_with_merge_freeList+0x26c>
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cf:	a1 54 51 80 00       	mov    0x805154,%eax
  8030d4:	40                   	inc    %eax
  8030d5:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030da:	e9 bb 04 00 00       	jmp    80359a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e3:	75 17                	jne    8030fc <insert_sorted_with_merge_freeList+0x2ab>
  8030e5:	83 ec 04             	sub    $0x4,%esp
  8030e8:	68 cc 40 80 00       	push   $0x8040cc
  8030ed:	68 4c 01 00 00       	push   $0x14c
  8030f2:	68 7b 40 80 00       	push   $0x80407b
  8030f7:	e8 f6 d3 ff ff       	call   8004f2 <_panic>
  8030fc:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	89 50 04             	mov    %edx,0x4(%eax)
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	8b 40 04             	mov    0x4(%eax),%eax
  80310e:	85 c0                	test   %eax,%eax
  803110:	74 0c                	je     80311e <insert_sorted_with_merge_freeList+0x2cd>
  803112:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803117:	8b 55 08             	mov    0x8(%ebp),%edx
  80311a:	89 10                	mov    %edx,(%eax)
  80311c:	eb 08                	jmp    803126 <insert_sorted_with_merge_freeList+0x2d5>
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	a3 38 51 80 00       	mov    %eax,0x805138
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803137:	a1 44 51 80 00       	mov    0x805144,%eax
  80313c:	40                   	inc    %eax
  80313d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803142:	e9 53 04 00 00       	jmp    80359a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803147:	a1 38 51 80 00       	mov    0x805138,%eax
  80314c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80314f:	e9 15 04 00 00       	jmp    803569 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	8b 00                	mov    (%eax),%eax
  803159:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	8b 50 08             	mov    0x8(%eax),%edx
  803162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803165:	8b 40 08             	mov    0x8(%eax),%eax
  803168:	39 c2                	cmp    %eax,%edx
  80316a:	0f 86 f1 03 00 00    	jbe    803561 <insert_sorted_with_merge_freeList+0x710>
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	8b 50 08             	mov    0x8(%eax),%edx
  803176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803179:	8b 40 08             	mov    0x8(%eax),%eax
  80317c:	39 c2                	cmp    %eax,%edx
  80317e:	0f 83 dd 03 00 00    	jae    803561 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	8b 50 08             	mov    0x8(%eax),%edx
  80318a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318d:	8b 40 0c             	mov    0xc(%eax),%eax
  803190:	01 c2                	add    %eax,%edx
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	8b 40 08             	mov    0x8(%eax),%eax
  803198:	39 c2                	cmp    %eax,%edx
  80319a:	0f 85 b9 01 00 00    	jne    803359 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	8b 50 08             	mov    0x8(%eax),%edx
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ac:	01 c2                	add    %eax,%edx
  8031ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b1:	8b 40 08             	mov    0x8(%eax),%eax
  8031b4:	39 c2                	cmp    %eax,%edx
  8031b6:	0f 85 0d 01 00 00    	jne    8032c9 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bf:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c8:	01 c2                	add    %eax,%edx
  8031ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cd:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031d4:	75 17                	jne    8031ed <insert_sorted_with_merge_freeList+0x39c>
  8031d6:	83 ec 04             	sub    $0x4,%esp
  8031d9:	68 24 41 80 00       	push   $0x804124
  8031de:	68 5c 01 00 00       	push   $0x15c
  8031e3:	68 7b 40 80 00       	push   $0x80407b
  8031e8:	e8 05 d3 ff ff       	call   8004f2 <_panic>
  8031ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f0:	8b 00                	mov    (%eax),%eax
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	74 10                	je     803206 <insert_sorted_with_merge_freeList+0x3b5>
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031fe:	8b 52 04             	mov    0x4(%edx),%edx
  803201:	89 50 04             	mov    %edx,0x4(%eax)
  803204:	eb 0b                	jmp    803211 <insert_sorted_with_merge_freeList+0x3c0>
  803206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803209:	8b 40 04             	mov    0x4(%eax),%eax
  80320c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	8b 40 04             	mov    0x4(%eax),%eax
  803217:	85 c0                	test   %eax,%eax
  803219:	74 0f                	je     80322a <insert_sorted_with_merge_freeList+0x3d9>
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	8b 40 04             	mov    0x4(%eax),%eax
  803221:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803224:	8b 12                	mov    (%edx),%edx
  803226:	89 10                	mov    %edx,(%eax)
  803228:	eb 0a                	jmp    803234 <insert_sorted_with_merge_freeList+0x3e3>
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	a3 38 51 80 00       	mov    %eax,0x805138
  803234:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803237:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803247:	a1 44 51 80 00       	mov    0x805144,%eax
  80324c:	48                   	dec    %eax
  80324d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803252:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803255:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803266:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80326a:	75 17                	jne    803283 <insert_sorted_with_merge_freeList+0x432>
  80326c:	83 ec 04             	sub    $0x4,%esp
  80326f:	68 58 40 80 00       	push   $0x804058
  803274:	68 5f 01 00 00       	push   $0x15f
  803279:	68 7b 40 80 00       	push   $0x80407b
  80327e:	e8 6f d2 ff ff       	call   8004f2 <_panic>
  803283:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	89 10                	mov    %edx,(%eax)
  80328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	85 c0                	test   %eax,%eax
  803295:	74 0d                	je     8032a4 <insert_sorted_with_merge_freeList+0x453>
  803297:	a1 48 51 80 00       	mov    0x805148,%eax
  80329c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329f:	89 50 04             	mov    %edx,0x4(%eax)
  8032a2:	eb 08                	jmp    8032ac <insert_sorted_with_merge_freeList+0x45b>
  8032a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032af:	a3 48 51 80 00       	mov    %eax,0x805148
  8032b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032be:	a1 54 51 80 00       	mov    0x805154,%eax
  8032c3:	40                   	inc    %eax
  8032c4:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d5:	01 c2                	add    %eax,%edx
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f5:	75 17                	jne    80330e <insert_sorted_with_merge_freeList+0x4bd>
  8032f7:	83 ec 04             	sub    $0x4,%esp
  8032fa:	68 58 40 80 00       	push   $0x804058
  8032ff:	68 64 01 00 00       	push   $0x164
  803304:	68 7b 40 80 00       	push   $0x80407b
  803309:	e8 e4 d1 ff ff       	call   8004f2 <_panic>
  80330e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	89 10                	mov    %edx,(%eax)
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	8b 00                	mov    (%eax),%eax
  80331e:	85 c0                	test   %eax,%eax
  803320:	74 0d                	je     80332f <insert_sorted_with_merge_freeList+0x4de>
  803322:	a1 48 51 80 00       	mov    0x805148,%eax
  803327:	8b 55 08             	mov    0x8(%ebp),%edx
  80332a:	89 50 04             	mov    %edx,0x4(%eax)
  80332d:	eb 08                	jmp    803337 <insert_sorted_with_merge_freeList+0x4e6>
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	a3 48 51 80 00       	mov    %eax,0x805148
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803349:	a1 54 51 80 00       	mov    0x805154,%eax
  80334e:	40                   	inc    %eax
  80334f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803354:	e9 41 02 00 00       	jmp    80359a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	8b 50 08             	mov    0x8(%eax),%edx
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	8b 40 0c             	mov    0xc(%eax),%eax
  803365:	01 c2                	add    %eax,%edx
  803367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336a:	8b 40 08             	mov    0x8(%eax),%eax
  80336d:	39 c2                	cmp    %eax,%edx
  80336f:	0f 85 7c 01 00 00    	jne    8034f1 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803375:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803379:	74 06                	je     803381 <insert_sorted_with_merge_freeList+0x530>
  80337b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80337f:	75 17                	jne    803398 <insert_sorted_with_merge_freeList+0x547>
  803381:	83 ec 04             	sub    $0x4,%esp
  803384:	68 94 40 80 00       	push   $0x804094
  803389:	68 69 01 00 00       	push   $0x169
  80338e:	68 7b 40 80 00       	push   $0x80407b
  803393:	e8 5a d1 ff ff       	call   8004f2 <_panic>
  803398:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339b:	8b 50 04             	mov    0x4(%eax),%edx
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	89 50 04             	mov    %edx,0x4(%eax)
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033aa:	89 10                	mov    %edx,(%eax)
  8033ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033af:	8b 40 04             	mov    0x4(%eax),%eax
  8033b2:	85 c0                	test   %eax,%eax
  8033b4:	74 0d                	je     8033c3 <insert_sorted_with_merge_freeList+0x572>
  8033b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b9:	8b 40 04             	mov    0x4(%eax),%eax
  8033bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bf:	89 10                	mov    %edx,(%eax)
  8033c1:	eb 08                	jmp    8033cb <insert_sorted_with_merge_freeList+0x57a>
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8033cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d1:	89 50 04             	mov    %edx,0x4(%eax)
  8033d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d9:	40                   	inc    %eax
  8033da:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033df:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033eb:	01 c2                	add    %eax,%edx
  8033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f0:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033f7:	75 17                	jne    803410 <insert_sorted_with_merge_freeList+0x5bf>
  8033f9:	83 ec 04             	sub    $0x4,%esp
  8033fc:	68 24 41 80 00       	push   $0x804124
  803401:	68 6b 01 00 00       	push   $0x16b
  803406:	68 7b 40 80 00       	push   $0x80407b
  80340b:	e8 e2 d0 ff ff       	call   8004f2 <_panic>
  803410:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803413:	8b 00                	mov    (%eax),%eax
  803415:	85 c0                	test   %eax,%eax
  803417:	74 10                	je     803429 <insert_sorted_with_merge_freeList+0x5d8>
  803419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803421:	8b 52 04             	mov    0x4(%edx),%edx
  803424:	89 50 04             	mov    %edx,0x4(%eax)
  803427:	eb 0b                	jmp    803434 <insert_sorted_with_merge_freeList+0x5e3>
  803429:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342c:	8b 40 04             	mov    0x4(%eax),%eax
  80342f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803437:	8b 40 04             	mov    0x4(%eax),%eax
  80343a:	85 c0                	test   %eax,%eax
  80343c:	74 0f                	je     80344d <insert_sorted_with_merge_freeList+0x5fc>
  80343e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803441:	8b 40 04             	mov    0x4(%eax),%eax
  803444:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803447:	8b 12                	mov    (%edx),%edx
  803449:	89 10                	mov    %edx,(%eax)
  80344b:	eb 0a                	jmp    803457 <insert_sorted_with_merge_freeList+0x606>
  80344d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	a3 38 51 80 00       	mov    %eax,0x805138
  803457:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803463:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346a:	a1 44 51 80 00       	mov    0x805144,%eax
  80346f:	48                   	dec    %eax
  803470:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803478:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80347f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803482:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803489:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80348d:	75 17                	jne    8034a6 <insert_sorted_with_merge_freeList+0x655>
  80348f:	83 ec 04             	sub    $0x4,%esp
  803492:	68 58 40 80 00       	push   $0x804058
  803497:	68 6e 01 00 00       	push   $0x16e
  80349c:	68 7b 40 80 00       	push   $0x80407b
  8034a1:	e8 4c d0 ff ff       	call   8004f2 <_panic>
  8034a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034af:	89 10                	mov    %edx,(%eax)
  8034b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b4:	8b 00                	mov    (%eax),%eax
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	74 0d                	je     8034c7 <insert_sorted_with_merge_freeList+0x676>
  8034ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8034bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034c2:	89 50 04             	mov    %edx,0x4(%eax)
  8034c5:	eb 08                	jmp    8034cf <insert_sorted_with_merge_freeList+0x67e>
  8034c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8034d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8034e6:	40                   	inc    %eax
  8034e7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034ec:	e9 a9 00 00 00       	jmp    80359a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f5:	74 06                	je     8034fd <insert_sorted_with_merge_freeList+0x6ac>
  8034f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034fb:	75 17                	jne    803514 <insert_sorted_with_merge_freeList+0x6c3>
  8034fd:	83 ec 04             	sub    $0x4,%esp
  803500:	68 f0 40 80 00       	push   $0x8040f0
  803505:	68 73 01 00 00       	push   $0x173
  80350a:	68 7b 40 80 00       	push   $0x80407b
  80350f:	e8 de cf ff ff       	call   8004f2 <_panic>
  803514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803517:	8b 10                	mov    (%eax),%edx
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	89 10                	mov    %edx,(%eax)
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	8b 00                	mov    (%eax),%eax
  803523:	85 c0                	test   %eax,%eax
  803525:	74 0b                	je     803532 <insert_sorted_with_merge_freeList+0x6e1>
  803527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352a:	8b 00                	mov    (%eax),%eax
  80352c:	8b 55 08             	mov    0x8(%ebp),%edx
  80352f:	89 50 04             	mov    %edx,0x4(%eax)
  803532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803535:	8b 55 08             	mov    0x8(%ebp),%edx
  803538:	89 10                	mov    %edx,(%eax)
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803540:	89 50 04             	mov    %edx,0x4(%eax)
  803543:	8b 45 08             	mov    0x8(%ebp),%eax
  803546:	8b 00                	mov    (%eax),%eax
  803548:	85 c0                	test   %eax,%eax
  80354a:	75 08                	jne    803554 <insert_sorted_with_merge_freeList+0x703>
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803554:	a1 44 51 80 00       	mov    0x805144,%eax
  803559:	40                   	inc    %eax
  80355a:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80355f:	eb 39                	jmp    80359a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803561:	a1 40 51 80 00       	mov    0x805140,%eax
  803566:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356d:	74 07                	je     803576 <insert_sorted_with_merge_freeList+0x725>
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	8b 00                	mov    (%eax),%eax
  803574:	eb 05                	jmp    80357b <insert_sorted_with_merge_freeList+0x72a>
  803576:	b8 00 00 00 00       	mov    $0x0,%eax
  80357b:	a3 40 51 80 00       	mov    %eax,0x805140
  803580:	a1 40 51 80 00       	mov    0x805140,%eax
  803585:	85 c0                	test   %eax,%eax
  803587:	0f 85 c7 fb ff ff    	jne    803154 <insert_sorted_with_merge_freeList+0x303>
  80358d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803591:	0f 85 bd fb ff ff    	jne    803154 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803597:	eb 01                	jmp    80359a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803599:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80359a:	90                   	nop
  80359b:	c9                   	leave  
  80359c:	c3                   	ret    
  80359d:	66 90                	xchg   %ax,%ax
  80359f:	90                   	nop

008035a0 <__udivdi3>:
  8035a0:	55                   	push   %ebp
  8035a1:	57                   	push   %edi
  8035a2:	56                   	push   %esi
  8035a3:	53                   	push   %ebx
  8035a4:	83 ec 1c             	sub    $0x1c,%esp
  8035a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035b7:	89 ca                	mov    %ecx,%edx
  8035b9:	89 f8                	mov    %edi,%eax
  8035bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035bf:	85 f6                	test   %esi,%esi
  8035c1:	75 2d                	jne    8035f0 <__udivdi3+0x50>
  8035c3:	39 cf                	cmp    %ecx,%edi
  8035c5:	77 65                	ja     80362c <__udivdi3+0x8c>
  8035c7:	89 fd                	mov    %edi,%ebp
  8035c9:	85 ff                	test   %edi,%edi
  8035cb:	75 0b                	jne    8035d8 <__udivdi3+0x38>
  8035cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d2:	31 d2                	xor    %edx,%edx
  8035d4:	f7 f7                	div    %edi
  8035d6:	89 c5                	mov    %eax,%ebp
  8035d8:	31 d2                	xor    %edx,%edx
  8035da:	89 c8                	mov    %ecx,%eax
  8035dc:	f7 f5                	div    %ebp
  8035de:	89 c1                	mov    %eax,%ecx
  8035e0:	89 d8                	mov    %ebx,%eax
  8035e2:	f7 f5                	div    %ebp
  8035e4:	89 cf                	mov    %ecx,%edi
  8035e6:	89 fa                	mov    %edi,%edx
  8035e8:	83 c4 1c             	add    $0x1c,%esp
  8035eb:	5b                   	pop    %ebx
  8035ec:	5e                   	pop    %esi
  8035ed:	5f                   	pop    %edi
  8035ee:	5d                   	pop    %ebp
  8035ef:	c3                   	ret    
  8035f0:	39 ce                	cmp    %ecx,%esi
  8035f2:	77 28                	ja     80361c <__udivdi3+0x7c>
  8035f4:	0f bd fe             	bsr    %esi,%edi
  8035f7:	83 f7 1f             	xor    $0x1f,%edi
  8035fa:	75 40                	jne    80363c <__udivdi3+0x9c>
  8035fc:	39 ce                	cmp    %ecx,%esi
  8035fe:	72 0a                	jb     80360a <__udivdi3+0x6a>
  803600:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803604:	0f 87 9e 00 00 00    	ja     8036a8 <__udivdi3+0x108>
  80360a:	b8 01 00 00 00       	mov    $0x1,%eax
  80360f:	89 fa                	mov    %edi,%edx
  803611:	83 c4 1c             	add    $0x1c,%esp
  803614:	5b                   	pop    %ebx
  803615:	5e                   	pop    %esi
  803616:	5f                   	pop    %edi
  803617:	5d                   	pop    %ebp
  803618:	c3                   	ret    
  803619:	8d 76 00             	lea    0x0(%esi),%esi
  80361c:	31 ff                	xor    %edi,%edi
  80361e:	31 c0                	xor    %eax,%eax
  803620:	89 fa                	mov    %edi,%edx
  803622:	83 c4 1c             	add    $0x1c,%esp
  803625:	5b                   	pop    %ebx
  803626:	5e                   	pop    %esi
  803627:	5f                   	pop    %edi
  803628:	5d                   	pop    %ebp
  803629:	c3                   	ret    
  80362a:	66 90                	xchg   %ax,%ax
  80362c:	89 d8                	mov    %ebx,%eax
  80362e:	f7 f7                	div    %edi
  803630:	31 ff                	xor    %edi,%edi
  803632:	89 fa                	mov    %edi,%edx
  803634:	83 c4 1c             	add    $0x1c,%esp
  803637:	5b                   	pop    %ebx
  803638:	5e                   	pop    %esi
  803639:	5f                   	pop    %edi
  80363a:	5d                   	pop    %ebp
  80363b:	c3                   	ret    
  80363c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803641:	89 eb                	mov    %ebp,%ebx
  803643:	29 fb                	sub    %edi,%ebx
  803645:	89 f9                	mov    %edi,%ecx
  803647:	d3 e6                	shl    %cl,%esi
  803649:	89 c5                	mov    %eax,%ebp
  80364b:	88 d9                	mov    %bl,%cl
  80364d:	d3 ed                	shr    %cl,%ebp
  80364f:	89 e9                	mov    %ebp,%ecx
  803651:	09 f1                	or     %esi,%ecx
  803653:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803657:	89 f9                	mov    %edi,%ecx
  803659:	d3 e0                	shl    %cl,%eax
  80365b:	89 c5                	mov    %eax,%ebp
  80365d:	89 d6                	mov    %edx,%esi
  80365f:	88 d9                	mov    %bl,%cl
  803661:	d3 ee                	shr    %cl,%esi
  803663:	89 f9                	mov    %edi,%ecx
  803665:	d3 e2                	shl    %cl,%edx
  803667:	8b 44 24 08          	mov    0x8(%esp),%eax
  80366b:	88 d9                	mov    %bl,%cl
  80366d:	d3 e8                	shr    %cl,%eax
  80366f:	09 c2                	or     %eax,%edx
  803671:	89 d0                	mov    %edx,%eax
  803673:	89 f2                	mov    %esi,%edx
  803675:	f7 74 24 0c          	divl   0xc(%esp)
  803679:	89 d6                	mov    %edx,%esi
  80367b:	89 c3                	mov    %eax,%ebx
  80367d:	f7 e5                	mul    %ebp
  80367f:	39 d6                	cmp    %edx,%esi
  803681:	72 19                	jb     80369c <__udivdi3+0xfc>
  803683:	74 0b                	je     803690 <__udivdi3+0xf0>
  803685:	89 d8                	mov    %ebx,%eax
  803687:	31 ff                	xor    %edi,%edi
  803689:	e9 58 ff ff ff       	jmp    8035e6 <__udivdi3+0x46>
  80368e:	66 90                	xchg   %ax,%ax
  803690:	8b 54 24 08          	mov    0x8(%esp),%edx
  803694:	89 f9                	mov    %edi,%ecx
  803696:	d3 e2                	shl    %cl,%edx
  803698:	39 c2                	cmp    %eax,%edx
  80369a:	73 e9                	jae    803685 <__udivdi3+0xe5>
  80369c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80369f:	31 ff                	xor    %edi,%edi
  8036a1:	e9 40 ff ff ff       	jmp    8035e6 <__udivdi3+0x46>
  8036a6:	66 90                	xchg   %ax,%ax
  8036a8:	31 c0                	xor    %eax,%eax
  8036aa:	e9 37 ff ff ff       	jmp    8035e6 <__udivdi3+0x46>
  8036af:	90                   	nop

008036b0 <__umoddi3>:
  8036b0:	55                   	push   %ebp
  8036b1:	57                   	push   %edi
  8036b2:	56                   	push   %esi
  8036b3:	53                   	push   %ebx
  8036b4:	83 ec 1c             	sub    $0x1c,%esp
  8036b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036cf:	89 f3                	mov    %esi,%ebx
  8036d1:	89 fa                	mov    %edi,%edx
  8036d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036d7:	89 34 24             	mov    %esi,(%esp)
  8036da:	85 c0                	test   %eax,%eax
  8036dc:	75 1a                	jne    8036f8 <__umoddi3+0x48>
  8036de:	39 f7                	cmp    %esi,%edi
  8036e0:	0f 86 a2 00 00 00    	jbe    803788 <__umoddi3+0xd8>
  8036e6:	89 c8                	mov    %ecx,%eax
  8036e8:	89 f2                	mov    %esi,%edx
  8036ea:	f7 f7                	div    %edi
  8036ec:	89 d0                	mov    %edx,%eax
  8036ee:	31 d2                	xor    %edx,%edx
  8036f0:	83 c4 1c             	add    $0x1c,%esp
  8036f3:	5b                   	pop    %ebx
  8036f4:	5e                   	pop    %esi
  8036f5:	5f                   	pop    %edi
  8036f6:	5d                   	pop    %ebp
  8036f7:	c3                   	ret    
  8036f8:	39 f0                	cmp    %esi,%eax
  8036fa:	0f 87 ac 00 00 00    	ja     8037ac <__umoddi3+0xfc>
  803700:	0f bd e8             	bsr    %eax,%ebp
  803703:	83 f5 1f             	xor    $0x1f,%ebp
  803706:	0f 84 ac 00 00 00    	je     8037b8 <__umoddi3+0x108>
  80370c:	bf 20 00 00 00       	mov    $0x20,%edi
  803711:	29 ef                	sub    %ebp,%edi
  803713:	89 fe                	mov    %edi,%esi
  803715:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803719:	89 e9                	mov    %ebp,%ecx
  80371b:	d3 e0                	shl    %cl,%eax
  80371d:	89 d7                	mov    %edx,%edi
  80371f:	89 f1                	mov    %esi,%ecx
  803721:	d3 ef                	shr    %cl,%edi
  803723:	09 c7                	or     %eax,%edi
  803725:	89 e9                	mov    %ebp,%ecx
  803727:	d3 e2                	shl    %cl,%edx
  803729:	89 14 24             	mov    %edx,(%esp)
  80372c:	89 d8                	mov    %ebx,%eax
  80372e:	d3 e0                	shl    %cl,%eax
  803730:	89 c2                	mov    %eax,%edx
  803732:	8b 44 24 08          	mov    0x8(%esp),%eax
  803736:	d3 e0                	shl    %cl,%eax
  803738:	89 44 24 04          	mov    %eax,0x4(%esp)
  80373c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803740:	89 f1                	mov    %esi,%ecx
  803742:	d3 e8                	shr    %cl,%eax
  803744:	09 d0                	or     %edx,%eax
  803746:	d3 eb                	shr    %cl,%ebx
  803748:	89 da                	mov    %ebx,%edx
  80374a:	f7 f7                	div    %edi
  80374c:	89 d3                	mov    %edx,%ebx
  80374e:	f7 24 24             	mull   (%esp)
  803751:	89 c6                	mov    %eax,%esi
  803753:	89 d1                	mov    %edx,%ecx
  803755:	39 d3                	cmp    %edx,%ebx
  803757:	0f 82 87 00 00 00    	jb     8037e4 <__umoddi3+0x134>
  80375d:	0f 84 91 00 00 00    	je     8037f4 <__umoddi3+0x144>
  803763:	8b 54 24 04          	mov    0x4(%esp),%edx
  803767:	29 f2                	sub    %esi,%edx
  803769:	19 cb                	sbb    %ecx,%ebx
  80376b:	89 d8                	mov    %ebx,%eax
  80376d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803771:	d3 e0                	shl    %cl,%eax
  803773:	89 e9                	mov    %ebp,%ecx
  803775:	d3 ea                	shr    %cl,%edx
  803777:	09 d0                	or     %edx,%eax
  803779:	89 e9                	mov    %ebp,%ecx
  80377b:	d3 eb                	shr    %cl,%ebx
  80377d:	89 da                	mov    %ebx,%edx
  80377f:	83 c4 1c             	add    $0x1c,%esp
  803782:	5b                   	pop    %ebx
  803783:	5e                   	pop    %esi
  803784:	5f                   	pop    %edi
  803785:	5d                   	pop    %ebp
  803786:	c3                   	ret    
  803787:	90                   	nop
  803788:	89 fd                	mov    %edi,%ebp
  80378a:	85 ff                	test   %edi,%edi
  80378c:	75 0b                	jne    803799 <__umoddi3+0xe9>
  80378e:	b8 01 00 00 00       	mov    $0x1,%eax
  803793:	31 d2                	xor    %edx,%edx
  803795:	f7 f7                	div    %edi
  803797:	89 c5                	mov    %eax,%ebp
  803799:	89 f0                	mov    %esi,%eax
  80379b:	31 d2                	xor    %edx,%edx
  80379d:	f7 f5                	div    %ebp
  80379f:	89 c8                	mov    %ecx,%eax
  8037a1:	f7 f5                	div    %ebp
  8037a3:	89 d0                	mov    %edx,%eax
  8037a5:	e9 44 ff ff ff       	jmp    8036ee <__umoddi3+0x3e>
  8037aa:	66 90                	xchg   %ax,%ax
  8037ac:	89 c8                	mov    %ecx,%eax
  8037ae:	89 f2                	mov    %esi,%edx
  8037b0:	83 c4 1c             	add    $0x1c,%esp
  8037b3:	5b                   	pop    %ebx
  8037b4:	5e                   	pop    %esi
  8037b5:	5f                   	pop    %edi
  8037b6:	5d                   	pop    %ebp
  8037b7:	c3                   	ret    
  8037b8:	3b 04 24             	cmp    (%esp),%eax
  8037bb:	72 06                	jb     8037c3 <__umoddi3+0x113>
  8037bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037c1:	77 0f                	ja     8037d2 <__umoddi3+0x122>
  8037c3:	89 f2                	mov    %esi,%edx
  8037c5:	29 f9                	sub    %edi,%ecx
  8037c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037cb:	89 14 24             	mov    %edx,(%esp)
  8037ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037d6:	8b 14 24             	mov    (%esp),%edx
  8037d9:	83 c4 1c             	add    $0x1c,%esp
  8037dc:	5b                   	pop    %ebx
  8037dd:	5e                   	pop    %esi
  8037de:	5f                   	pop    %edi
  8037df:	5d                   	pop    %ebp
  8037e0:	c3                   	ret    
  8037e1:	8d 76 00             	lea    0x0(%esi),%esi
  8037e4:	2b 04 24             	sub    (%esp),%eax
  8037e7:	19 fa                	sbb    %edi,%edx
  8037e9:	89 d1                	mov    %edx,%ecx
  8037eb:	89 c6                	mov    %eax,%esi
  8037ed:	e9 71 ff ff ff       	jmp    803763 <__umoddi3+0xb3>
  8037f2:	66 90                	xchg   %ax,%ax
  8037f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037f8:	72 ea                	jb     8037e4 <__umoddi3+0x134>
  8037fa:	89 d9                	mov    %ebx,%ecx
  8037fc:	e9 62 ff ff ff       	jmp    803763 <__umoddi3+0xb3>
