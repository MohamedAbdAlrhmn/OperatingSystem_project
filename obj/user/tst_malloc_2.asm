
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
  800090:	68 80 39 80 00       	push   $0x803980
  800095:	6a 1a                	push   $0x1a
  800097:	68 9c 39 80 00       	push   $0x80399c
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
  800282:	68 b0 39 80 00       	push   $0x8039b0
  800287:	6a 45                	push   $0x45
  800289:	68 9c 39 80 00       	push   $0x80399c
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
  8002b7:	68 b0 39 80 00       	push   $0x8039b0
  8002bc:	6a 46                	push   $0x46
  8002be:	68 9c 39 80 00       	push   $0x80399c
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
  8002eb:	68 b0 39 80 00       	push   $0x8039b0
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 9c 39 80 00       	push   $0x80399c
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
  80031f:	68 b0 39 80 00       	push   $0x8039b0
  800324:	6a 49                	push   $0x49
  800326:	68 9c 39 80 00       	push   $0x80399c
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
  800359:	68 b0 39 80 00       	push   $0x8039b0
  80035e:	6a 4a                	push   $0x4a
  800360:	68 9c 39 80 00       	push   $0x80399c
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
  80038f:	68 b0 39 80 00       	push   $0x8039b0
  800394:	6a 4b                	push   $0x4b
  800396:	68 9c 39 80 00       	push   $0x80399c
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 e8 39 80 00       	push   $0x8039e8
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
  8003bc:	e8 6a 1a 00 00       	call   801e2b <sys_getenvindex>
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
  800427:	e8 0c 18 00 00       	call   801c38 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 3c 3a 80 00       	push   $0x803a3c
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
  800457:	68 64 3a 80 00       	push   $0x803a64
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
  800488:	68 8c 3a 80 00       	push   $0x803a8c
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 50 80 00       	mov    0x805020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 e4 3a 80 00       	push   $0x803ae4
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 3c 3a 80 00       	push   $0x803a3c
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 8c 17 00 00       	call   801c52 <sys_enable_interrupt>

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
  8004d9:	e8 19 19 00 00       	call   801df7 <sys_destroy_env>
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
  8004ea:	e8 6e 19 00 00       	call   801e5d <sys_exit_env>
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
  800513:	68 f8 3a 80 00       	push   $0x803af8
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 50 80 00       	mov    0x805000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 fd 3a 80 00       	push   $0x803afd
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
  800550:	68 19 3b 80 00       	push   $0x803b19
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
  80057c:	68 1c 3b 80 00       	push   $0x803b1c
  800581:	6a 26                	push   $0x26
  800583:	68 68 3b 80 00       	push   $0x803b68
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
  80064e:	68 74 3b 80 00       	push   $0x803b74
  800653:	6a 3a                	push   $0x3a
  800655:	68 68 3b 80 00       	push   $0x803b68
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
  8006be:	68 c8 3b 80 00       	push   $0x803bc8
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 68 3b 80 00       	push   $0x803b68
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
  800718:	e8 6d 13 00 00       	call   801a8a <sys_cputs>
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
  80078f:	e8 f6 12 00 00       	call   801a8a <sys_cputs>
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
  8007d9:	e8 5a 14 00 00       	call   801c38 <sys_disable_interrupt>
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
  8007f9:	e8 54 14 00 00       	call   801c52 <sys_enable_interrupt>
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
  800843:	e8 c8 2e 00 00       	call   803710 <__udivdi3>
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
  800893:	e8 88 2f 00 00       	call   803820 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 34 3e 80 00       	add    $0x803e34,%eax
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
  8009ee:	8b 04 85 58 3e 80 00 	mov    0x803e58(,%eax,4),%eax
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
  800acf:	8b 34 9d a0 3c 80 00 	mov    0x803ca0(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 45 3e 80 00       	push   $0x803e45
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
  800af4:	68 4e 3e 80 00       	push   $0x803e4e
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
  800b21:	be 51 3e 80 00       	mov    $0x803e51,%esi
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
  801547:	68 b0 3f 80 00       	push   $0x803fb0
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
  801617:	e8 b2 05 00 00       	call   801bce <sys_allocate_chunk>
  80161c:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80161f:	a1 20 51 80 00       	mov    0x805120,%eax
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	50                   	push   %eax
  801628:	e8 27 0c 00 00       	call   802254 <initialize_MemBlocksList>
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
  801655:	68 d5 3f 80 00       	push   $0x803fd5
  80165a:	6a 33                	push   $0x33
  80165c:	68 f3 3f 80 00       	push   $0x803ff3
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
  8016d4:	68 00 40 80 00       	push   $0x804000
  8016d9:	6a 34                	push   $0x34
  8016db:	68 f3 3f 80 00       	push   $0x803ff3
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
  80176c:	e8 2b 08 00 00       	call   801f9c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801771:	85 c0                	test   %eax,%eax
  801773:	74 11                	je     801786 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	ff 75 e8             	pushl  -0x18(%ebp)
  80177b:	e8 96 0e 00 00       	call   802616 <alloc_block_FF>
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
  801792:	e8 f2 0b 00 00       	call   802389 <insert_sorted_allocList>
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
  8017ac:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	83 ec 08             	sub    $0x8,%esp
  8017b5:	50                   	push   %eax
  8017b6:	68 40 50 80 00       	push   $0x805040
  8017bb:	e8 71 0b 00 00       	call   802331 <find_block>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8017c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ca:	0f 84 a6 00 00 00    	je     801876 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8017d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d9:	8b 40 08             	mov    0x8(%eax),%eax
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	52                   	push   %edx
  8017e0:	50                   	push   %eax
  8017e1:	e8 b0 03 00 00       	call   801b96 <sys_free_user_mem>
  8017e6:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8017e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ed:	75 14                	jne    801803 <free+0x5a>
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	68 d5 3f 80 00       	push   $0x803fd5
  8017f7:	6a 74                	push   $0x74
  8017f9:	68 f3 3f 80 00       	push   $0x803ff3
  8017fe:	e8 ef ec ff ff       	call   8004f2 <_panic>
  801803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801806:	8b 00                	mov    (%eax),%eax
  801808:	85 c0                	test   %eax,%eax
  80180a:	74 10                	je     80181c <free+0x73>
  80180c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180f:	8b 00                	mov    (%eax),%eax
  801811:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801814:	8b 52 04             	mov    0x4(%edx),%edx
  801817:	89 50 04             	mov    %edx,0x4(%eax)
  80181a:	eb 0b                	jmp    801827 <free+0x7e>
  80181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181f:	8b 40 04             	mov    0x4(%eax),%eax
  801822:	a3 44 50 80 00       	mov    %eax,0x805044
  801827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182a:	8b 40 04             	mov    0x4(%eax),%eax
  80182d:	85 c0                	test   %eax,%eax
  80182f:	74 0f                	je     801840 <free+0x97>
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801834:	8b 40 04             	mov    0x4(%eax),%eax
  801837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183a:	8b 12                	mov    (%edx),%edx
  80183c:	89 10                	mov    %edx,(%eax)
  80183e:	eb 0a                	jmp    80184a <free+0xa1>
  801840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801843:	8b 00                	mov    (%eax),%eax
  801845:	a3 40 50 80 00       	mov    %eax,0x805040
  80184a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801856:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80185d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801862:	48                   	dec    %eax
  801863:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	ff 75 f4             	pushl  -0xc(%ebp)
  80186e:	e8 4e 17 00 00       	call   802fc1 <insert_sorted_with_merge_freeList>
  801873:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	83 ec 08             	sub    $0x8,%esp
  8017b5:	50                   	push   %eax
  8017b6:	68 40 50 80 00       	push   $0x805040
  8017bb:	e8 71 0b 00 00       	call   802331 <find_block>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  8017c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ca:	0f 84 a6 00 00 00    	je     801876 <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  8017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8017d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d9:	8b 40 08             	mov    0x8(%eax),%eax
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	52                   	push   %edx
  8017e0:	50                   	push   %eax
  8017e1:	e8 b0 03 00 00       	call   801b96 <sys_free_user_mem>
  8017e6:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  8017e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ed:	75 14                	jne    801803 <free+0x5a>
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	68 d5 3f 80 00       	push   $0x803fd5
  8017f7:	6a 7a                	push   $0x7a
  8017f9:	68 f3 3f 80 00       	push   $0x803ff3
  8017fe:	e8 ef ec ff ff       	call   8004f2 <_panic>
  801803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801806:	8b 00                	mov    (%eax),%eax
  801808:	85 c0                	test   %eax,%eax
  80180a:	74 10                	je     80181c <free+0x73>
  80180c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180f:	8b 00                	mov    (%eax),%eax
  801811:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801814:	8b 52 04             	mov    0x4(%edx),%edx
  801817:	89 50 04             	mov    %edx,0x4(%eax)
  80181a:	eb 0b                	jmp    801827 <free+0x7e>
  80181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181f:	8b 40 04             	mov    0x4(%eax),%eax
  801822:	a3 44 50 80 00       	mov    %eax,0x805044
  801827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182a:	8b 40 04             	mov    0x4(%eax),%eax
  80182d:	85 c0                	test   %eax,%eax
  80182f:	74 0f                	je     801840 <free+0x97>
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801834:	8b 40 04             	mov    0x4(%eax),%eax
  801837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183a:	8b 12                	mov    (%edx),%edx
  80183c:	89 10                	mov    %edx,(%eax)
  80183e:	eb 0a                	jmp    80184a <free+0xa1>
  801840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801843:	8b 00                	mov    (%eax),%eax
  801845:	a3 40 50 80 00       	mov    %eax,0x805040
  80184a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801856:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80185d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801862:	48                   	dec    %eax
  801863:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	ff 75 f4             	pushl  -0xc(%ebp)
  80186e:	e8 4e 17 00 00       	call   802fc1 <insert_sorted_with_merge_freeList>
  801873:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801876:	90                   	nop
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 38             	sub    $0x38,%esp
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801885:	e8 a6 fc ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  80188a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80188e:	75 0a                	jne    80189a <smalloc+0x21>
  801890:	b8 00 00 00 00       	mov    $0x0,%eax
  801895:	e9 8b 00 00 00       	jmp    801925 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80189a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a7:	01 d0                	add    %edx,%eax
  8018a9:	48                   	dec    %eax
  8018aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b5:	f7 75 f0             	divl   -0x10(%ebp)
  8018b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018bb:	29 d0                	sub    %edx,%eax
  8018bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8018c0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8018c7:	e8 d0 06 00 00       	call   801f9c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	74 11                	je     8018e1 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8018d0:	83 ec 0c             	sub    $0xc,%esp
  8018d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8018d6:	e8 3b 0d 00 00       	call   802616 <alloc_block_FF>
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8018e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018e5:	74 39                	je     801920 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8018e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ea:	8b 40 08             	mov    0x8(%eax),%eax
  8018ed:	89 c2                	mov    %eax,%edx
  8018ef:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018f3:	52                   	push   %edx
  8018f4:	50                   	push   %eax
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	ff 75 08             	pushl  0x8(%ebp)
  8018fb:	e8 21 04 00 00       	call   801d21 <sys_createSharedObject>
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801906:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80190a:	74 14                	je     801920 <smalloc+0xa7>
  80190c:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801910:	74 0e                	je     801920 <smalloc+0xa7>
  801912:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801916:	74 08                	je     801920 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191b:	8b 40 08             	mov    0x8(%eax),%eax
  80191e:	eb 05                	jmp    801925 <smalloc+0xac>
	}
	return NULL;
  801920:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80192d:	e8 fe fb ff ff       	call   801530 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801932:	83 ec 08             	sub    $0x8,%esp
  801935:	ff 75 0c             	pushl  0xc(%ebp)
  801938:	ff 75 08             	pushl  0x8(%ebp)
  80193b:	e8 0b 04 00 00       	call   801d4b <sys_getSizeOfSharedObject>
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801946:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80194a:	74 76                	je     8019c2 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80194c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801953:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	48                   	dec    %eax
  80195c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80195f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801962:	ba 00 00 00 00       	mov    $0x0,%edx
  801967:	f7 75 ec             	divl   -0x14(%ebp)
  80196a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80196d:	29 d0                	sub    %edx,%eax
  80196f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801979:	e8 1e 06 00 00       	call   801f9c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80197e:	85 c0                	test   %eax,%eax
  801980:	74 11                	je     801993 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801982:	83 ec 0c             	sub    $0xc,%esp
  801985:	ff 75 e4             	pushl  -0x1c(%ebp)
  801988:	e8 89 0c 00 00       	call   802616 <alloc_block_FF>
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801993:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801997:	74 29                	je     8019c2 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199c:	8b 40 08             	mov    0x8(%eax),%eax
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	50                   	push   %eax
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	ff 75 08             	pushl  0x8(%ebp)
  8019a9:	e8 ba 03 00 00       	call   801d68 <sys_getSharedObject>
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8019b4:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8019b8:	74 08                	je     8019c2 <sget+0x9b>
				return (void *)mem_block->sva;
  8019ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bd:	8b 40 08             	mov    0x8(%eax),%eax
  8019c0:	eb 05                	jmp    8019c7 <sget+0xa0>
		}
	}
	return NULL;
  8019c2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019cf:	e8 5c fb ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019d4:	83 ec 04             	sub    $0x4,%esp
  8019d7:	68 24 40 80 00       	push   $0x804024
<<<<<<< HEAD
  8019dc:	68 fc 00 00 00       	push   $0xfc
=======
  8019dc:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8019e1:	68 f3 3f 80 00       	push   $0x803ff3
  8019e6:	e8 07 eb ff ff       	call   8004f2 <_panic>

008019eb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	68 4c 40 80 00       	push   $0x80404c
<<<<<<< HEAD
  8019f9:	68 10 01 00 00       	push   $0x110
=======
  8019f9:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8019fe:	68 f3 3f 80 00       	push   $0x803ff3
  801a03:	e8 ea ea ff ff       	call   8004f2 <_panic>

00801a08 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a0e:	83 ec 04             	sub    $0x4,%esp
  801a11:	68 70 40 80 00       	push   $0x804070
<<<<<<< HEAD
  801a16:	68 1b 01 00 00       	push   $0x11b
=======
  801a16:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801a1b:	68 f3 3f 80 00       	push   $0x803ff3
  801a20:	e8 cd ea ff ff       	call   8004f2 <_panic>

00801a25 <shrink>:

}
void shrink(uint32 newSize)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	68 70 40 80 00       	push   $0x804070
<<<<<<< HEAD
  801a33:	68 20 01 00 00       	push   $0x120
=======
  801a33:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801a38:	68 f3 3f 80 00       	push   $0x803ff3
  801a3d:	e8 b0 ea ff ff       	call   8004f2 <_panic>

00801a42 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a48:	83 ec 04             	sub    $0x4,%esp
  801a4b:	68 70 40 80 00       	push   $0x804070
<<<<<<< HEAD
  801a50:	68 25 01 00 00       	push   $0x125
=======
  801a50:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801a55:	68 f3 3f 80 00       	push   $0x803ff3
  801a5a:	e8 93 ea ff ff       	call   8004f2 <_panic>

00801a5f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	57                   	push   %edi
  801a63:	56                   	push   %esi
  801a64:	53                   	push   %ebx
  801a65:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a71:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a74:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a77:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a7a:	cd 30                	int    $0x30
  801a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	5b                   	pop    %ebx
  801a86:	5e                   	pop    %esi
  801a87:	5f                   	pop    %edi
  801a88:	5d                   	pop    %ebp
  801a89:	c3                   	ret    

00801a8a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	8b 45 10             	mov    0x10(%ebp),%eax
  801a93:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a96:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	52                   	push   %edx
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	50                   	push   %eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	e8 b2 ff ff ff       	call   801a5f <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	90                   	nop
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 01                	push   $0x1
  801ac2:	e8 98 ff ff ff       	call   801a5f <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	52                   	push   %edx
  801adc:	50                   	push   %eax
  801add:	6a 05                	push   $0x5
  801adf:	e8 7b ff ff ff       	call   801a5f <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	56                   	push   %esi
  801aed:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801aee:	8b 75 18             	mov    0x18(%ebp),%esi
  801af1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	56                   	push   %esi
  801afe:	53                   	push   %ebx
  801aff:	51                   	push   %ecx
  801b00:	52                   	push   %edx
  801b01:	50                   	push   %eax
  801b02:	6a 06                	push   $0x6
  801b04:	e8 56 ff ff ff       	call   801a5f <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0f:	5b                   	pop    %ebx
  801b10:	5e                   	pop    %esi
  801b11:	5d                   	pop    %ebp
  801b12:	c3                   	ret    

00801b13 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	52                   	push   %edx
  801b23:	50                   	push   %eax
  801b24:	6a 07                	push   $0x7
  801b26:	e8 34 ff ff ff       	call   801a5f <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	ff 75 08             	pushl  0x8(%ebp)
  801b3f:	6a 08                	push   $0x8
  801b41:	e8 19 ff ff ff       	call   801a5f <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 09                	push   $0x9
  801b5a:	e8 00 ff ff ff       	call   801a5f <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 0a                	push   $0xa
  801b73:	e8 e7 fe ff ff       	call   801a5f <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 0b                	push   $0xb
  801b8c:	e8 ce fe ff ff       	call   801a5f <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	ff 75 08             	pushl  0x8(%ebp)
  801ba5:	6a 0f                	push   $0xf
  801ba7:	e8 b3 fe ff ff       	call   801a5f <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
	return;
  801baf:	90                   	nop
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	ff 75 08             	pushl  0x8(%ebp)
  801bc1:	6a 10                	push   $0x10
  801bc3:	e8 97 fe ff ff       	call   801a5f <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcb:	90                   	nop
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	ff 75 10             	pushl  0x10(%ebp)
  801bd8:	ff 75 0c             	pushl  0xc(%ebp)
  801bdb:	ff 75 08             	pushl  0x8(%ebp)
  801bde:	6a 11                	push   $0x11
  801be0:	e8 7a fe ff ff       	call   801a5f <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
	return ;
  801be8:	90                   	nop
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 0c                	push   $0xc
  801bfa:	e8 60 fe ff ff       	call   801a5f <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	ff 75 08             	pushl  0x8(%ebp)
  801c12:	6a 0d                	push   $0xd
  801c14:	e8 46 fe ff ff       	call   801a5f <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 0e                	push   $0xe
  801c2d:	e8 2d fe ff ff       	call   801a5f <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	90                   	nop
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 13                	push   $0x13
  801c47:	e8 13 fe ff ff       	call   801a5f <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	90                   	nop
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 14                	push   $0x14
  801c61:	e8 f9 fd ff ff       	call   801a5f <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	90                   	nop
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_cputc>:


void
sys_cputc(const char c)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 04             	sub    $0x4,%esp
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c78:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	50                   	push   %eax
  801c85:	6a 15                	push   $0x15
  801c87:	e8 d3 fd ff ff       	call   801a5f <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 16                	push   $0x16
  801ca1:	e8 b9 fd ff ff       	call   801a5f <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
}
  801ca9:	90                   	nop
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	ff 75 0c             	pushl  0xc(%ebp)
  801cbb:	50                   	push   %eax
  801cbc:	6a 17                	push   $0x17
  801cbe:	e8 9c fd ff ff       	call   801a5f <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	52                   	push   %edx
  801cd8:	50                   	push   %eax
  801cd9:	6a 1a                	push   $0x1a
  801cdb:	e8 7f fd ff ff       	call   801a5f <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	6a 18                	push   $0x18
  801cf8:	e8 62 fd ff ff       	call   801a5f <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	90                   	nop
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	52                   	push   %edx
  801d13:	50                   	push   %eax
  801d14:	6a 19                	push   $0x19
  801d16:	e8 44 fd ff ff       	call   801a5f <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	90                   	nop
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d2d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d30:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	6a 00                	push   $0x0
  801d39:	51                   	push   %ecx
  801d3a:	52                   	push   %edx
  801d3b:	ff 75 0c             	pushl  0xc(%ebp)
  801d3e:	50                   	push   %eax
  801d3f:	6a 1b                	push   $0x1b
  801d41:	e8 19 fd ff ff       	call   801a5f <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	52                   	push   %edx
  801d5b:	50                   	push   %eax
  801d5c:	6a 1c                	push   $0x1c
  801d5e:	e8 fc fc ff ff       	call   801a5f <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	51                   	push   %ecx
  801d79:	52                   	push   %edx
  801d7a:	50                   	push   %eax
  801d7b:	6a 1d                	push   $0x1d
  801d7d:	e8 dd fc ff ff       	call   801a5f <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	52                   	push   %edx
  801d97:	50                   	push   %eax
  801d98:	6a 1e                	push   $0x1e
  801d9a:	e8 c0 fc ff ff       	call   801a5f <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 1f                	push   $0x1f
  801db3:	e8 a7 fc ff ff       	call   801a5f <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc3:	6a 00                	push   $0x0
  801dc5:	ff 75 14             	pushl  0x14(%ebp)
  801dc8:	ff 75 10             	pushl  0x10(%ebp)
  801dcb:	ff 75 0c             	pushl  0xc(%ebp)
  801dce:	50                   	push   %eax
  801dcf:	6a 20                	push   $0x20
  801dd1:	e8 89 fc ff ff       	call   801a5f <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	50                   	push   %eax
  801dea:	6a 21                	push   $0x21
  801dec:	e8 6e fc ff ff       	call   801a5f <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
}
  801df4:	90                   	nop
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	50                   	push   %eax
  801e06:	6a 22                	push   $0x22
  801e08:	e8 52 fc ff ff       	call   801a5f <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 02                	push   $0x2
  801e21:	e8 39 fc ff ff       	call   801a5f <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 03                	push   $0x3
  801e3a:	e8 20 fc ff ff       	call   801a5f <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 04                	push   $0x4
  801e53:	e8 07 fc ff ff       	call   801a5f <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_exit_env>:


void sys_exit_env(void)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 23                	push   $0x23
  801e6c:	e8 ee fb ff ff       	call   801a5f <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
}
  801e74:	90                   	nop
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e7d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e80:	8d 50 04             	lea    0x4(%eax),%edx
  801e83:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	52                   	push   %edx
  801e8d:	50                   	push   %eax
  801e8e:	6a 24                	push   $0x24
  801e90:	e8 ca fb ff ff       	call   801a5f <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
	return result;
  801e98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ea1:	89 01                	mov    %eax,(%ecx)
  801ea3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	c9                   	leave  
  801eaa:	c2 04 00             	ret    $0x4

00801ead <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	ff 75 10             	pushl  0x10(%ebp)
  801eb7:	ff 75 0c             	pushl  0xc(%ebp)
  801eba:	ff 75 08             	pushl  0x8(%ebp)
  801ebd:	6a 12                	push   $0x12
  801ebf:	e8 9b fb ff ff       	call   801a5f <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec7:	90                   	nop
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_rcr2>:
uint32 sys_rcr2()
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 25                	push   $0x25
  801ed9:	e8 81 fb ff ff       	call   801a5f <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	83 ec 04             	sub    $0x4,%esp
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801eef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	50                   	push   %eax
  801efc:	6a 26                	push   $0x26
  801efe:	e8 5c fb ff ff       	call   801a5f <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
	return ;
  801f06:	90                   	nop
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <rsttst>:
void rsttst()
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 28                	push   $0x28
  801f18:	e8 42 fb ff ff       	call   801a5f <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f20:	90                   	nop
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	8b 45 14             	mov    0x14(%ebp),%eax
  801f2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f2f:	8b 55 18             	mov    0x18(%ebp),%edx
  801f32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f36:	52                   	push   %edx
  801f37:	50                   	push   %eax
  801f38:	ff 75 10             	pushl  0x10(%ebp)
  801f3b:	ff 75 0c             	pushl  0xc(%ebp)
  801f3e:	ff 75 08             	pushl  0x8(%ebp)
  801f41:	6a 27                	push   $0x27
  801f43:	e8 17 fb ff ff       	call   801a5f <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4b:	90                   	nop
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <chktst>:
void chktst(uint32 n)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	ff 75 08             	pushl  0x8(%ebp)
  801f5c:	6a 29                	push   $0x29
  801f5e:	e8 fc fa ff ff       	call   801a5f <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
	return ;
  801f66:	90                   	nop
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <inctst>:

void inctst()
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 2a                	push   $0x2a
  801f78:	e8 e2 fa ff ff       	call   801a5f <syscall>
  801f7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f80:	90                   	nop
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <gettst>:
uint32 gettst()
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 2b                	push   $0x2b
  801f92:	e8 c8 fa ff ff       	call   801a5f <syscall>
  801f97:	83 c4 18             	add    $0x18,%esp
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 2c                	push   $0x2c
  801fae:	e8 ac fa ff ff       	call   801a5f <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
  801fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fb9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fbd:	75 07                	jne    801fc6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc4:	eb 05                	jmp    801fcb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 2c                	push   $0x2c
  801fdf:	e8 7b fa ff ff       	call   801a5f <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
  801fe7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fea:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fee:	75 07                	jne    801ff7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ff0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff5:	eb 05                	jmp    801ffc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 2c                	push   $0x2c
  802010:	e8 4a fa ff ff       	call   801a5f <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
  802018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80201b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80201f:	75 07                	jne    802028 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802021:	b8 01 00 00 00       	mov    $0x1,%eax
  802026:	eb 05                	jmp    80202d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802028:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 2c                	push   $0x2c
  802041:	e8 19 fa ff ff       	call   801a5f <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
  802049:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80204c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802050:	75 07                	jne    802059 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802052:	b8 01 00 00 00       	mov    $0x1,%eax
  802057:	eb 05                	jmp    80205e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	ff 75 08             	pushl  0x8(%ebp)
  80206e:	6a 2d                	push   $0x2d
  802070:	e8 ea f9 ff ff       	call   801a5f <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
	return ;
  802078:	90                   	nop
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80207f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802082:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802085:	8b 55 0c             	mov    0xc(%ebp),%edx
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	6a 00                	push   $0x0
  80208d:	53                   	push   %ebx
  80208e:	51                   	push   %ecx
  80208f:	52                   	push   %edx
  802090:	50                   	push   %eax
  802091:	6a 2e                	push   $0x2e
  802093:	e8 c7 f9 ff ff       	call   801a5f <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
}
  80209b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	52                   	push   %edx
  8020b0:	50                   	push   %eax
  8020b1:	6a 2f                	push   $0x2f
  8020b3:	e8 a7 f9 ff ff       	call   801a5f <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020c3:	83 ec 0c             	sub    $0xc,%esp
  8020c6:	68 80 40 80 00       	push   $0x804080
  8020cb:	e8 d6 e6 ff ff       	call   8007a6 <cprintf>
  8020d0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	68 ac 40 80 00       	push   $0x8040ac
  8020e2:	e8 bf e6 ff ff       	call   8007a6 <cprintf>
  8020e7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020ea:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020ee:	a1 38 51 80 00       	mov    0x805138,%eax
  8020f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f6:	eb 56                	jmp    80214e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020fc:	74 1c                	je     80211a <print_mem_block_lists+0x5d>
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	8b 50 08             	mov    0x8(%eax),%edx
  802104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802107:	8b 48 08             	mov    0x8(%eax),%ecx
  80210a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210d:	8b 40 0c             	mov    0xc(%eax),%eax
  802110:	01 c8                	add    %ecx,%eax
  802112:	39 c2                	cmp    %eax,%edx
  802114:	73 04                	jae    80211a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802116:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	8b 50 08             	mov    0x8(%eax),%edx
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	8b 40 0c             	mov    0xc(%eax),%eax
  802126:	01 c2                	add    %eax,%edx
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	8b 40 08             	mov    0x8(%eax),%eax
  80212e:	83 ec 04             	sub    $0x4,%esp
  802131:	52                   	push   %edx
  802132:	50                   	push   %eax
  802133:	68 c1 40 80 00       	push   $0x8040c1
  802138:	e8 69 e6 ff ff       	call   8007a6 <cprintf>
  80213d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802146:	a1 40 51 80 00       	mov    0x805140,%eax
  80214b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802152:	74 07                	je     80215b <print_mem_block_lists+0x9e>
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	8b 00                	mov    (%eax),%eax
  802159:	eb 05                	jmp    802160 <print_mem_block_lists+0xa3>
  80215b:	b8 00 00 00 00       	mov    $0x0,%eax
  802160:	a3 40 51 80 00       	mov    %eax,0x805140
  802165:	a1 40 51 80 00       	mov    0x805140,%eax
  80216a:	85 c0                	test   %eax,%eax
  80216c:	75 8a                	jne    8020f8 <print_mem_block_lists+0x3b>
  80216e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802172:	75 84                	jne    8020f8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802174:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802178:	75 10                	jne    80218a <print_mem_block_lists+0xcd>
  80217a:	83 ec 0c             	sub    $0xc,%esp
  80217d:	68 d0 40 80 00       	push   $0x8040d0
  802182:	e8 1f e6 ff ff       	call   8007a6 <cprintf>
  802187:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80218a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802191:	83 ec 0c             	sub    $0xc,%esp
  802194:	68 f4 40 80 00       	push   $0x8040f4
  802199:	e8 08 e6 ff ff       	call   8007a6 <cprintf>
  80219e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021a1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021a5:	a1 40 50 80 00       	mov    0x805040,%eax
  8021aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ad:	eb 56                	jmp    802205 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b3:	74 1c                	je     8021d1 <print_mem_block_lists+0x114>
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 50 08             	mov    0x8(%eax),%edx
  8021bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021be:	8b 48 08             	mov    0x8(%eax),%ecx
  8021c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c7:	01 c8                	add    %ecx,%eax
  8021c9:	39 c2                	cmp    %eax,%edx
  8021cb:	73 04                	jae    8021d1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021cd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	8b 50 08             	mov    0x8(%eax),%edx
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	8b 40 0c             	mov    0xc(%eax),%eax
  8021dd:	01 c2                	add    %eax,%edx
  8021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e2:	8b 40 08             	mov    0x8(%eax),%eax
  8021e5:	83 ec 04             	sub    $0x4,%esp
  8021e8:	52                   	push   %edx
  8021e9:	50                   	push   %eax
  8021ea:	68 c1 40 80 00       	push   $0x8040c1
  8021ef:	e8 b2 e5 ff ff       	call   8007a6 <cprintf>
  8021f4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021fd:	a1 48 50 80 00       	mov    0x805048,%eax
  802202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802209:	74 07                	je     802212 <print_mem_block_lists+0x155>
  80220b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220e:	8b 00                	mov    (%eax),%eax
  802210:	eb 05                	jmp    802217 <print_mem_block_lists+0x15a>
  802212:	b8 00 00 00 00       	mov    $0x0,%eax
  802217:	a3 48 50 80 00       	mov    %eax,0x805048
  80221c:	a1 48 50 80 00       	mov    0x805048,%eax
  802221:	85 c0                	test   %eax,%eax
  802223:	75 8a                	jne    8021af <print_mem_block_lists+0xf2>
  802225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802229:	75 84                	jne    8021af <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80222b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80222f:	75 10                	jne    802241 <print_mem_block_lists+0x184>
  802231:	83 ec 0c             	sub    $0xc,%esp
  802234:	68 0c 41 80 00       	push   $0x80410c
  802239:	e8 68 e5 ff ff       	call   8007a6 <cprintf>
  80223e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802241:	83 ec 0c             	sub    $0xc,%esp
  802244:	68 80 40 80 00       	push   $0x804080
  802249:	e8 58 e5 ff ff       	call   8007a6 <cprintf>
  80224e:	83 c4 10             	add    $0x10,%esp

}
  802251:	90                   	nop
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80225a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802261:	00 00 00 
  802264:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80226b:	00 00 00 
  80226e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802275:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802278:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80227f:	e9 9e 00 00 00       	jmp    802322 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802284:	a1 50 50 80 00       	mov    0x805050,%eax
  802289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228c:	c1 e2 04             	shl    $0x4,%edx
  80228f:	01 d0                	add    %edx,%eax
  802291:	85 c0                	test   %eax,%eax
  802293:	75 14                	jne    8022a9 <initialize_MemBlocksList+0x55>
  802295:	83 ec 04             	sub    $0x4,%esp
  802298:	68 34 41 80 00       	push   $0x804134
  80229d:	6a 46                	push   $0x46
  80229f:	68 57 41 80 00       	push   $0x804157
  8022a4:	e8 49 e2 ff ff       	call   8004f2 <_panic>
  8022a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8022ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b1:	c1 e2 04             	shl    $0x4,%edx
  8022b4:	01 d0                	add    %edx,%eax
  8022b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8022bc:	89 10                	mov    %edx,(%eax)
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	74 18                	je     8022dc <initialize_MemBlocksList+0x88>
  8022c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8022c9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8022cf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022d2:	c1 e1 04             	shl    $0x4,%ecx
  8022d5:	01 ca                	add    %ecx,%edx
  8022d7:	89 50 04             	mov    %edx,0x4(%eax)
  8022da:	eb 12                	jmp    8022ee <initialize_MemBlocksList+0x9a>
  8022dc:	a1 50 50 80 00       	mov    0x805050,%eax
  8022e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e4:	c1 e2 04             	shl    $0x4,%edx
  8022e7:	01 d0                	add    %edx,%eax
  8022e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022ee:	a1 50 50 80 00       	mov    0x805050,%eax
  8022f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f6:	c1 e2 04             	shl    $0x4,%edx
  8022f9:	01 d0                	add    %edx,%eax
  8022fb:	a3 48 51 80 00       	mov    %eax,0x805148
  802300:	a1 50 50 80 00       	mov    0x805050,%eax
  802305:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802308:	c1 e2 04             	shl    $0x4,%edx
  80230b:	01 d0                	add    %edx,%eax
  80230d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802314:	a1 54 51 80 00       	mov    0x805154,%eax
  802319:	40                   	inc    %eax
  80231a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80231f:	ff 45 f4             	incl   -0xc(%ebp)
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	3b 45 08             	cmp    0x8(%ebp),%eax
  802328:	0f 82 56 ff ff ff    	jb     802284 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80232e:	90                   	nop
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
  802334:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	8b 00                	mov    (%eax),%eax
  80233c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80233f:	eb 19                	jmp    80235a <find_block+0x29>
	{
		if(va==point->sva)
  802341:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802344:	8b 40 08             	mov    0x8(%eax),%eax
  802347:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80234a:	75 05                	jne    802351 <find_block+0x20>
		   return point;
  80234c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80234f:	eb 36                	jmp    802387 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	8b 40 08             	mov    0x8(%eax),%eax
  802357:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80235a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80235e:	74 07                	je     802367 <find_block+0x36>
  802360:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	eb 05                	jmp    80236c <find_block+0x3b>
  802367:	b8 00 00 00 00       	mov    $0x0,%eax
  80236c:	8b 55 08             	mov    0x8(%ebp),%edx
  80236f:	89 42 08             	mov    %eax,0x8(%edx)
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	8b 40 08             	mov    0x8(%eax),%eax
  802378:	85 c0                	test   %eax,%eax
  80237a:	75 c5                	jne    802341 <find_block+0x10>
  80237c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802380:	75 bf                	jne    802341 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802382:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80238f:	a1 40 50 80 00       	mov    0x805040,%eax
  802394:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802397:	a1 44 50 80 00       	mov    0x805044,%eax
  80239c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80239f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023a5:	74 24                	je     8023cb <insert_sorted_allocList+0x42>
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	8b 50 08             	mov    0x8(%eax),%edx
  8023ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b0:	8b 40 08             	mov    0x8(%eax),%eax
  8023b3:	39 c2                	cmp    %eax,%edx
  8023b5:	76 14                	jbe    8023cb <insert_sorted_allocList+0x42>
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	8b 50 08             	mov    0x8(%eax),%edx
  8023bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c0:	8b 40 08             	mov    0x8(%eax),%eax
  8023c3:	39 c2                	cmp    %eax,%edx
  8023c5:	0f 82 60 01 00 00    	jb     80252b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8023cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023cf:	75 65                	jne    802436 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8023d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d5:	75 14                	jne    8023eb <insert_sorted_allocList+0x62>
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	68 34 41 80 00       	push   $0x804134
  8023df:	6a 6b                	push   $0x6b
  8023e1:	68 57 41 80 00       	push   $0x804157
  8023e6:	e8 07 e1 ff ff       	call   8004f2 <_panic>
  8023eb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	89 10                	mov    %edx,(%eax)
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	74 0d                	je     80240c <insert_sorted_allocList+0x83>
  8023ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802404:	8b 55 08             	mov    0x8(%ebp),%edx
  802407:	89 50 04             	mov    %edx,0x4(%eax)
  80240a:	eb 08                	jmp    802414 <insert_sorted_allocList+0x8b>
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	a3 44 50 80 00       	mov    %eax,0x805044
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	a3 40 50 80 00       	mov    %eax,0x805040
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802426:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80242b:	40                   	inc    %eax
  80242c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802431:	e9 dc 01 00 00       	jmp    802612 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	8b 50 08             	mov    0x8(%eax),%edx
  80243c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243f:	8b 40 08             	mov    0x8(%eax),%eax
  802442:	39 c2                	cmp    %eax,%edx
  802444:	77 6c                	ja     8024b2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802446:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80244a:	74 06                	je     802452 <insert_sorted_allocList+0xc9>
  80244c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802450:	75 14                	jne    802466 <insert_sorted_allocList+0xdd>
  802452:	83 ec 04             	sub    $0x4,%esp
  802455:	68 70 41 80 00       	push   $0x804170
  80245a:	6a 6f                	push   $0x6f
  80245c:	68 57 41 80 00       	push   $0x804157
  802461:	e8 8c e0 ff ff       	call   8004f2 <_panic>
  802466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802469:	8b 50 04             	mov    0x4(%eax),%edx
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	89 50 04             	mov    %edx,0x4(%eax)
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802478:	89 10                	mov    %edx,(%eax)
  80247a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247d:	8b 40 04             	mov    0x4(%eax),%eax
  802480:	85 c0                	test   %eax,%eax
  802482:	74 0d                	je     802491 <insert_sorted_allocList+0x108>
  802484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802487:	8b 40 04             	mov    0x4(%eax),%eax
  80248a:	8b 55 08             	mov    0x8(%ebp),%edx
  80248d:	89 10                	mov    %edx,(%eax)
  80248f:	eb 08                	jmp    802499 <insert_sorted_allocList+0x110>
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	a3 40 50 80 00       	mov    %eax,0x805040
  802499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249c:	8b 55 08             	mov    0x8(%ebp),%edx
  80249f:	89 50 04             	mov    %edx,0x4(%eax)
  8024a2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024a7:	40                   	inc    %eax
  8024a8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024ad:	e9 60 01 00 00       	jmp    802612 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	8b 50 08             	mov    0x8(%eax),%edx
  8024b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bb:	8b 40 08             	mov    0x8(%eax),%eax
  8024be:	39 c2                	cmp    %eax,%edx
  8024c0:	0f 82 4c 01 00 00    	jb     802612 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8024c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024ca:	75 14                	jne    8024e0 <insert_sorted_allocList+0x157>
  8024cc:	83 ec 04             	sub    $0x4,%esp
  8024cf:	68 a8 41 80 00       	push   $0x8041a8
  8024d4:	6a 73                	push   $0x73
  8024d6:	68 57 41 80 00       	push   $0x804157
  8024db:	e8 12 e0 ff ff       	call   8004f2 <_panic>
  8024e0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	89 50 04             	mov    %edx,0x4(%eax)
  8024ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ef:	8b 40 04             	mov    0x4(%eax),%eax
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	74 0c                	je     802502 <insert_sorted_allocList+0x179>
  8024f6:	a1 44 50 80 00       	mov    0x805044,%eax
  8024fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fe:	89 10                	mov    %edx,(%eax)
  802500:	eb 08                	jmp    80250a <insert_sorted_allocList+0x181>
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	a3 40 50 80 00       	mov    %eax,0x805040
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	a3 44 50 80 00       	mov    %eax,0x805044
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802520:	40                   	inc    %eax
  802521:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802526:	e9 e7 00 00 00       	jmp    802612 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80252b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802531:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802538:	a1 40 50 80 00       	mov    0x805040,%eax
  80253d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802540:	e9 9d 00 00 00       	jmp    8025e2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	8b 50 08             	mov    0x8(%eax),%edx
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 40 08             	mov    0x8(%eax),%eax
  802559:	39 c2                	cmp    %eax,%edx
  80255b:	76 7d                	jbe    8025da <insert_sorted_allocList+0x251>
  80255d:	8b 45 08             	mov    0x8(%ebp),%eax
  802560:	8b 50 08             	mov    0x8(%eax),%edx
  802563:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802566:	8b 40 08             	mov    0x8(%eax),%eax
  802569:	39 c2                	cmp    %eax,%edx
  80256b:	73 6d                	jae    8025da <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80256d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802571:	74 06                	je     802579 <insert_sorted_allocList+0x1f0>
  802573:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802577:	75 14                	jne    80258d <insert_sorted_allocList+0x204>
  802579:	83 ec 04             	sub    $0x4,%esp
  80257c:	68 cc 41 80 00       	push   $0x8041cc
  802581:	6a 7f                	push   $0x7f
  802583:	68 57 41 80 00       	push   $0x804157
  802588:	e8 65 df ff ff       	call   8004f2 <_panic>
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 10                	mov    (%eax),%edx
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	89 10                	mov    %edx,(%eax)
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	8b 00                	mov    (%eax),%eax
  80259c:	85 c0                	test   %eax,%eax
  80259e:	74 0b                	je     8025ab <insert_sorted_allocList+0x222>
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 00                	mov    (%eax),%eax
  8025a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a8:	89 50 04             	mov    %edx,0x4(%eax)
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b1:	89 10                	mov    %edx,(%eax)
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b9:	89 50 04             	mov    %edx,0x4(%eax)
  8025bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	75 08                	jne    8025cd <insert_sorted_allocList+0x244>
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	a3 44 50 80 00       	mov    %eax,0x805044
  8025cd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025d2:	40                   	inc    %eax
  8025d3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8025d8:	eb 39                	jmp    802613 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025da:	a1 48 50 80 00       	mov    0x805048,%eax
  8025df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e6:	74 07                	je     8025ef <insert_sorted_allocList+0x266>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	eb 05                	jmp    8025f4 <insert_sorted_allocList+0x26b>
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	a3 48 50 80 00       	mov    %eax,0x805048
  8025f9:	a1 48 50 80 00       	mov    0x805048,%eax
  8025fe:	85 c0                	test   %eax,%eax
  802600:	0f 85 3f ff ff ff    	jne    802545 <insert_sorted_allocList+0x1bc>
  802606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260a:	0f 85 35 ff ff ff    	jne    802545 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802610:	eb 01                	jmp    802613 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802612:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802613:	90                   	nop
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80261c:	a1 38 51 80 00       	mov    0x805138,%eax
  802621:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802624:	e9 85 01 00 00       	jmp    8027ae <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 40 0c             	mov    0xc(%eax),%eax
  80262f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802632:	0f 82 6e 01 00 00    	jb     8027a6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 40 0c             	mov    0xc(%eax),%eax
  80263e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802641:	0f 85 8a 00 00 00    	jne    8026d1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264b:	75 17                	jne    802664 <alloc_block_FF+0x4e>
  80264d:	83 ec 04             	sub    $0x4,%esp
  802650:	68 00 42 80 00       	push   $0x804200
  802655:	68 93 00 00 00       	push   $0x93
  80265a:	68 57 41 80 00       	push   $0x804157
  80265f:	e8 8e de ff ff       	call   8004f2 <_panic>
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	85 c0                	test   %eax,%eax
  80266b:	74 10                	je     80267d <alloc_block_FF+0x67>
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 00                	mov    (%eax),%eax
  802672:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802675:	8b 52 04             	mov    0x4(%edx),%edx
  802678:	89 50 04             	mov    %edx,0x4(%eax)
  80267b:	eb 0b                	jmp    802688 <alloc_block_FF+0x72>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 40 04             	mov    0x4(%eax),%eax
  802683:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 40 04             	mov    0x4(%eax),%eax
  80268e:	85 c0                	test   %eax,%eax
  802690:	74 0f                	je     8026a1 <alloc_block_FF+0x8b>
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 04             	mov    0x4(%eax),%eax
  802698:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269b:	8b 12                	mov    (%edx),%edx
  80269d:	89 10                	mov    %edx,(%eax)
  80269f:	eb 0a                	jmp    8026ab <alloc_block_FF+0x95>
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 00                	mov    (%eax),%eax
  8026a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026be:	a1 44 51 80 00       	mov    0x805144,%eax
  8026c3:	48                   	dec    %eax
  8026c4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	e9 10 01 00 00       	jmp    8027e1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026da:	0f 86 c6 00 00 00    	jbe    8027a6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8026e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 50 08             	mov    0x8(%eax),%edx
  8026ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f1:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8026f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026fa:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802701:	75 17                	jne    80271a <alloc_block_FF+0x104>
  802703:	83 ec 04             	sub    $0x4,%esp
  802706:	68 00 42 80 00       	push   $0x804200
  80270b:	68 9b 00 00 00       	push   $0x9b
  802710:	68 57 41 80 00       	push   $0x804157
  802715:	e8 d8 dd ff ff       	call   8004f2 <_panic>
  80271a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	74 10                	je     802733 <alloc_block_FF+0x11d>
  802723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802726:	8b 00                	mov    (%eax),%eax
  802728:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80272b:	8b 52 04             	mov    0x4(%edx),%edx
  80272e:	89 50 04             	mov    %edx,0x4(%eax)
  802731:	eb 0b                	jmp    80273e <alloc_block_FF+0x128>
  802733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802736:	8b 40 04             	mov    0x4(%eax),%eax
  802739:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802741:	8b 40 04             	mov    0x4(%eax),%eax
  802744:	85 c0                	test   %eax,%eax
  802746:	74 0f                	je     802757 <alloc_block_FF+0x141>
  802748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274b:	8b 40 04             	mov    0x4(%eax),%eax
  80274e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802751:	8b 12                	mov    (%edx),%edx
  802753:	89 10                	mov    %edx,(%eax)
  802755:	eb 0a                	jmp    802761 <alloc_block_FF+0x14b>
  802757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	a3 48 51 80 00       	mov    %eax,0x805148
  802761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802764:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802774:	a1 54 51 80 00       	mov    0x805154,%eax
  802779:	48                   	dec    %eax
  80277a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 50 08             	mov    0x8(%eax),%edx
  802785:	8b 45 08             	mov    0x8(%ebp),%eax
  802788:	01 c2                	add    %eax,%edx
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 40 0c             	mov    0xc(%eax),%eax
  802796:	2b 45 08             	sub    0x8(%ebp),%eax
  802799:	89 c2                	mov    %eax,%edx
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8027a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a4:	eb 3b                	jmp    8027e1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8027a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b2:	74 07                	je     8027bb <alloc_block_FF+0x1a5>
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 00                	mov    (%eax),%eax
  8027b9:	eb 05                	jmp    8027c0 <alloc_block_FF+0x1aa>
  8027bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c0:	a3 40 51 80 00       	mov    %eax,0x805140
  8027c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	0f 85 57 fe ff ff    	jne    802629 <alloc_block_FF+0x13>
  8027d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d6:	0f 85 4d fe ff ff    	jne    802629 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    

008027e3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
  8027e6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8027e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027f0:	a1 38 51 80 00       	mov    0x805138,%eax
  8027f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f8:	e9 df 00 00 00       	jmp    8028dc <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 40 0c             	mov    0xc(%eax),%eax
  802803:	3b 45 08             	cmp    0x8(%ebp),%eax
  802806:	0f 82 c8 00 00 00    	jb     8028d4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 40 0c             	mov    0xc(%eax),%eax
  802812:	3b 45 08             	cmp    0x8(%ebp),%eax
  802815:	0f 85 8a 00 00 00    	jne    8028a5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80281b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281f:	75 17                	jne    802838 <alloc_block_BF+0x55>
  802821:	83 ec 04             	sub    $0x4,%esp
  802824:	68 00 42 80 00       	push   $0x804200
  802829:	68 b7 00 00 00       	push   $0xb7
  80282e:	68 57 41 80 00       	push   $0x804157
  802833:	e8 ba dc ff ff       	call   8004f2 <_panic>
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 00                	mov    (%eax),%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	74 10                	je     802851 <alloc_block_BF+0x6e>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802849:	8b 52 04             	mov    0x4(%edx),%edx
  80284c:	89 50 04             	mov    %edx,0x4(%eax)
  80284f:	eb 0b                	jmp    80285c <alloc_block_BF+0x79>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 40 04             	mov    0x4(%eax),%eax
  802857:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	74 0f                	je     802875 <alloc_block_BF+0x92>
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 40 04             	mov    0x4(%eax),%eax
  80286c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286f:	8b 12                	mov    (%edx),%edx
  802871:	89 10                	mov    %edx,(%eax)
  802873:	eb 0a                	jmp    80287f <alloc_block_BF+0x9c>
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	a3 38 51 80 00       	mov    %eax,0x805138
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802892:	a1 44 51 80 00       	mov    0x805144,%eax
  802897:	48                   	dec    %eax
  802898:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	e9 4d 01 00 00       	jmp    8029f2 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ae:	76 24                	jbe    8028d4 <alloc_block_BF+0xf1>
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028b9:	73 19                	jae    8028d4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8028bb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 40 08             	mov    0x8(%eax),%eax
  8028d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e0:	74 07                	je     8028e9 <alloc_block_BF+0x106>
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	eb 05                	jmp    8028ee <alloc_block_BF+0x10b>
  8028e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ee:	a3 40 51 80 00       	mov    %eax,0x805140
  8028f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	0f 85 fd fe ff ff    	jne    8027fd <alloc_block_BF+0x1a>
  802900:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802904:	0f 85 f3 fe ff ff    	jne    8027fd <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80290a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80290e:	0f 84 d9 00 00 00    	je     8029ed <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802914:	a1 48 51 80 00       	mov    0x805148,%eax
  802919:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80291c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802922:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802928:	8b 55 08             	mov    0x8(%ebp),%edx
  80292b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80292e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802932:	75 17                	jne    80294b <alloc_block_BF+0x168>
  802934:	83 ec 04             	sub    $0x4,%esp
  802937:	68 00 42 80 00       	push   $0x804200
  80293c:	68 c7 00 00 00       	push   $0xc7
  802941:	68 57 41 80 00       	push   $0x804157
  802946:	e8 a7 db ff ff       	call   8004f2 <_panic>
  80294b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	74 10                	je     802964 <alloc_block_BF+0x181>
  802954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80295c:	8b 52 04             	mov    0x4(%edx),%edx
  80295f:	89 50 04             	mov    %edx,0x4(%eax)
  802962:	eb 0b                	jmp    80296f <alloc_block_BF+0x18c>
  802964:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802967:	8b 40 04             	mov    0x4(%eax),%eax
  80296a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80296f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802972:	8b 40 04             	mov    0x4(%eax),%eax
  802975:	85 c0                	test   %eax,%eax
  802977:	74 0f                	je     802988 <alloc_block_BF+0x1a5>
  802979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297c:	8b 40 04             	mov    0x4(%eax),%eax
  80297f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802982:	8b 12                	mov    (%edx),%edx
  802984:	89 10                	mov    %edx,(%eax)
  802986:	eb 0a                	jmp    802992 <alloc_block_BF+0x1af>
  802988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	a3 48 51 80 00       	mov    %eax,0x805148
  802992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802995:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a5:	a1 54 51 80 00       	mov    0x805154,%eax
  8029aa:	48                   	dec    %eax
  8029ab:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8029b0:	83 ec 08             	sub    $0x8,%esp
  8029b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8029b6:	68 38 51 80 00       	push   $0x805138
  8029bb:	e8 71 f9 ff ff       	call   802331 <find_block>
  8029c0:	83 c4 10             	add    $0x10,%esp
  8029c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8029c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c9:	8b 50 08             	mov    0x8(%eax),%edx
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	01 c2                	add    %eax,%edx
  8029d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8029d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029da:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dd:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e0:	89 c2                	mov    %eax,%edx
  8029e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8029e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029eb:	eb 05                	jmp    8029f2 <alloc_block_BF+0x20f>
	}
	return NULL;
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f2:	c9                   	leave  
  8029f3:	c3                   	ret    

008029f4 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029f4:	55                   	push   %ebp
  8029f5:	89 e5                	mov    %esp,%ebp
  8029f7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8029fa:	a1 28 50 80 00       	mov    0x805028,%eax
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	0f 85 de 01 00 00    	jne    802be5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a07:	a1 38 51 80 00       	mov    0x805138,%eax
  802a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0f:	e9 9e 01 00 00       	jmp    802bb2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1d:	0f 82 87 01 00 00    	jb     802baa <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 40 0c             	mov    0xc(%eax),%eax
  802a29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2c:	0f 85 95 00 00 00    	jne    802ac7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a36:	75 17                	jne    802a4f <alloc_block_NF+0x5b>
  802a38:	83 ec 04             	sub    $0x4,%esp
  802a3b:	68 00 42 80 00       	push   $0x804200
  802a40:	68 e0 00 00 00       	push   $0xe0
  802a45:	68 57 41 80 00       	push   $0x804157
  802a4a:	e8 a3 da ff ff       	call   8004f2 <_panic>
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 10                	je     802a68 <alloc_block_NF+0x74>
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 00                	mov    (%eax),%eax
  802a5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a60:	8b 52 04             	mov    0x4(%edx),%edx
  802a63:	89 50 04             	mov    %edx,0x4(%eax)
  802a66:	eb 0b                	jmp    802a73 <alloc_block_NF+0x7f>
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 40 04             	mov    0x4(%eax),%eax
  802a6e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 40 04             	mov    0x4(%eax),%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 0f                	je     802a8c <alloc_block_NF+0x98>
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a86:	8b 12                	mov    (%edx),%edx
  802a88:	89 10                	mov    %edx,(%eax)
  802a8a:	eb 0a                	jmp    802a96 <alloc_block_NF+0xa2>
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 00                	mov    (%eax),%eax
  802a91:	a3 38 51 80 00       	mov    %eax,0x805138
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa9:	a1 44 51 80 00       	mov    0x805144,%eax
  802aae:	48                   	dec    %eax
  802aaf:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 40 08             	mov    0x8(%eax),%eax
  802aba:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	e9 f8 04 00 00       	jmp    802fbf <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 40 0c             	mov    0xc(%eax),%eax
  802acd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad0:	0f 86 d4 00 00 00    	jbe    802baa <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ad6:	a1 48 51 80 00       	mov    0x805148,%eax
  802adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	8b 50 08             	mov    0x8(%eax),%edx
  802ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aed:	8b 55 08             	mov    0x8(%ebp),%edx
  802af0:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802af3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802af7:	75 17                	jne    802b10 <alloc_block_NF+0x11c>
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	68 00 42 80 00       	push   $0x804200
  802b01:	68 e9 00 00 00       	push   $0xe9
  802b06:	68 57 41 80 00       	push   $0x804157
  802b0b:	e8 e2 d9 ff ff       	call   8004f2 <_panic>
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	74 10                	je     802b29 <alloc_block_NF+0x135>
  802b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1c:	8b 00                	mov    (%eax),%eax
  802b1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b21:	8b 52 04             	mov    0x4(%edx),%edx
  802b24:	89 50 04             	mov    %edx,0x4(%eax)
  802b27:	eb 0b                	jmp    802b34 <alloc_block_NF+0x140>
  802b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2c:	8b 40 04             	mov    0x4(%eax),%eax
  802b2f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 0f                	je     802b4d <alloc_block_NF+0x159>
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	8b 40 04             	mov    0x4(%eax),%eax
  802b44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b47:	8b 12                	mov    (%edx),%edx
  802b49:	89 10                	mov    %edx,(%eax)
  802b4b:	eb 0a                	jmp    802b57 <alloc_block_NF+0x163>
  802b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	a3 48 51 80 00       	mov    %eax,0x805148
  802b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6a:	a1 54 51 80 00       	mov    0x805154,%eax
  802b6f:	48                   	dec    %eax
  802b70:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b78:	8b 40 08             	mov    0x8(%eax),%eax
  802b7b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b83:	8b 50 08             	mov    0x8(%eax),%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	01 c2                	add    %eax,%edx
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 40 0c             	mov    0xc(%eax),%eax
  802b97:	2b 45 08             	sub    0x8(%ebp),%eax
  802b9a:	89 c2                	mov    %eax,%edx
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	e9 15 04 00 00       	jmp    802fbf <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802baa:	a1 40 51 80 00       	mov    0x805140,%eax
  802baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb6:	74 07                	je     802bbf <alloc_block_NF+0x1cb>
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	eb 05                	jmp    802bc4 <alloc_block_NF+0x1d0>
  802bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc4:	a3 40 51 80 00       	mov    %eax,0x805140
  802bc9:	a1 40 51 80 00       	mov    0x805140,%eax
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	0f 85 3e fe ff ff    	jne    802a14 <alloc_block_NF+0x20>
  802bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bda:	0f 85 34 fe ff ff    	jne    802a14 <alloc_block_NF+0x20>
  802be0:	e9 d5 03 00 00       	jmp    802fba <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802be5:	a1 38 51 80 00       	mov    0x805138,%eax
  802bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bed:	e9 b1 01 00 00       	jmp    802da3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 50 08             	mov    0x8(%eax),%edx
  802bf8:	a1 28 50 80 00       	mov    0x805028,%eax
  802bfd:	39 c2                	cmp    %eax,%edx
  802bff:	0f 82 96 01 00 00    	jb     802d9b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0e:	0f 82 87 01 00 00    	jb     802d9b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1d:	0f 85 95 00 00 00    	jne    802cb8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c27:	75 17                	jne    802c40 <alloc_block_NF+0x24c>
  802c29:	83 ec 04             	sub    $0x4,%esp
  802c2c:	68 00 42 80 00       	push   $0x804200
  802c31:	68 fc 00 00 00       	push   $0xfc
  802c36:	68 57 41 80 00       	push   $0x804157
  802c3b:	e8 b2 d8 ff ff       	call   8004f2 <_panic>
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 00                	mov    (%eax),%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	74 10                	je     802c59 <alloc_block_NF+0x265>
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 00                	mov    (%eax),%eax
  802c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c51:	8b 52 04             	mov    0x4(%edx),%edx
  802c54:	89 50 04             	mov    %edx,0x4(%eax)
  802c57:	eb 0b                	jmp    802c64 <alloc_block_NF+0x270>
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 40 04             	mov    0x4(%eax),%eax
  802c5f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 40 04             	mov    0x4(%eax),%eax
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	74 0f                	je     802c7d <alloc_block_NF+0x289>
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	8b 40 04             	mov    0x4(%eax),%eax
  802c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c77:	8b 12                	mov    (%edx),%edx
  802c79:	89 10                	mov    %edx,(%eax)
  802c7b:	eb 0a                	jmp    802c87 <alloc_block_NF+0x293>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	a3 38 51 80 00       	mov    %eax,0x805138
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c9f:	48                   	dec    %eax
  802ca0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	8b 40 08             	mov    0x8(%eax),%eax
  802cab:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	e9 07 03 00 00       	jmp    802fbf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc1:	0f 86 d4 00 00 00    	jbe    802d9b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cc7:	a1 48 51 80 00       	mov    0x805148,%eax
  802ccc:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 50 08             	mov    0x8(%eax),%edx
  802cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cde:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ce4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ce8:	75 17                	jne    802d01 <alloc_block_NF+0x30d>
  802cea:	83 ec 04             	sub    $0x4,%esp
  802ced:	68 00 42 80 00       	push   $0x804200
  802cf2:	68 04 01 00 00       	push   $0x104
  802cf7:	68 57 41 80 00       	push   $0x804157
  802cfc:	e8 f1 d7 ff ff       	call   8004f2 <_panic>
  802d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d04:	8b 00                	mov    (%eax),%eax
  802d06:	85 c0                	test   %eax,%eax
  802d08:	74 10                	je     802d1a <alloc_block_NF+0x326>
  802d0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0d:	8b 00                	mov    (%eax),%eax
  802d0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d12:	8b 52 04             	mov    0x4(%edx),%edx
  802d15:	89 50 04             	mov    %edx,0x4(%eax)
  802d18:	eb 0b                	jmp    802d25 <alloc_block_NF+0x331>
  802d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d28:	8b 40 04             	mov    0x4(%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	74 0f                	je     802d3e <alloc_block_NF+0x34a>
  802d2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d32:	8b 40 04             	mov    0x4(%eax),%eax
  802d35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d38:	8b 12                	mov    (%edx),%edx
  802d3a:	89 10                	mov    %edx,(%eax)
  802d3c:	eb 0a                	jmp    802d48 <alloc_block_NF+0x354>
  802d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	a3 48 51 80 00       	mov    %eax,0x805148
  802d48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5b:	a1 54 51 80 00       	mov    0x805154,%eax
  802d60:	48                   	dec    %eax
  802d61:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d69:	8b 40 08             	mov    0x8(%eax),%eax
  802d6c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 50 08             	mov    0x8(%eax),%edx
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	01 c2                	add    %eax,%edx
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 40 0c             	mov    0xc(%eax),%eax
  802d88:	2b 45 08             	sub    0x8(%ebp),%eax
  802d8b:	89 c2                	mov    %eax,%edx
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d96:	e9 24 02 00 00       	jmp    802fbf <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d9b:	a1 40 51 80 00       	mov    0x805140,%eax
  802da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da7:	74 07                	je     802db0 <alloc_block_NF+0x3bc>
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	eb 05                	jmp    802db5 <alloc_block_NF+0x3c1>
  802db0:	b8 00 00 00 00       	mov    $0x0,%eax
  802db5:	a3 40 51 80 00       	mov    %eax,0x805140
  802dba:	a1 40 51 80 00       	mov    0x805140,%eax
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	0f 85 2b fe ff ff    	jne    802bf2 <alloc_block_NF+0x1fe>
  802dc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dcb:	0f 85 21 fe ff ff    	jne    802bf2 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dd1:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd9:	e9 ae 01 00 00       	jmp    802f8c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 50 08             	mov    0x8(%eax),%edx
  802de4:	a1 28 50 80 00       	mov    0x805028,%eax
  802de9:	39 c2                	cmp    %eax,%edx
  802deb:	0f 83 93 01 00 00    	jae    802f84 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 0c             	mov    0xc(%eax),%eax
  802df7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dfa:	0f 82 84 01 00 00    	jb     802f84 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 40 0c             	mov    0xc(%eax),%eax
  802e06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e09:	0f 85 95 00 00 00    	jne    802ea4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e13:	75 17                	jne    802e2c <alloc_block_NF+0x438>
  802e15:	83 ec 04             	sub    $0x4,%esp
  802e18:	68 00 42 80 00       	push   $0x804200
  802e1d:	68 14 01 00 00       	push   $0x114
  802e22:	68 57 41 80 00       	push   $0x804157
  802e27:	e8 c6 d6 ff ff       	call   8004f2 <_panic>
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	85 c0                	test   %eax,%eax
  802e33:	74 10                	je     802e45 <alloc_block_NF+0x451>
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3d:	8b 52 04             	mov    0x4(%edx),%edx
  802e40:	89 50 04             	mov    %edx,0x4(%eax)
  802e43:	eb 0b                	jmp    802e50 <alloc_block_NF+0x45c>
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 40 04             	mov    0x4(%eax),%eax
  802e4b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 40 04             	mov    0x4(%eax),%eax
  802e56:	85 c0                	test   %eax,%eax
  802e58:	74 0f                	je     802e69 <alloc_block_NF+0x475>
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 40 04             	mov    0x4(%eax),%eax
  802e60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e63:	8b 12                	mov    (%edx),%edx
  802e65:	89 10                	mov    %edx,(%eax)
  802e67:	eb 0a                	jmp    802e73 <alloc_block_NF+0x47f>
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 00                	mov    (%eax),%eax
  802e6e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e86:	a1 44 51 80 00       	mov    0x805144,%eax
  802e8b:	48                   	dec    %eax
  802e8c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	8b 40 08             	mov    0x8(%eax),%eax
  802e97:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	e9 1b 01 00 00       	jmp    802fbf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eaa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ead:	0f 86 d1 00 00 00    	jbe    802f84 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802eb3:	a1 48 51 80 00       	mov    0x805148,%eax
  802eb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 50 08             	mov    0x8(%eax),%edx
  802ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eca:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ed0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ed4:	75 17                	jne    802eed <alloc_block_NF+0x4f9>
  802ed6:	83 ec 04             	sub    $0x4,%esp
  802ed9:	68 00 42 80 00       	push   $0x804200
  802ede:	68 1c 01 00 00       	push   $0x11c
  802ee3:	68 57 41 80 00       	push   $0x804157
  802ee8:	e8 05 d6 ff ff       	call   8004f2 <_panic>
  802eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 10                	je     802f06 <alloc_block_NF+0x512>
  802ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef9:	8b 00                	mov    (%eax),%eax
  802efb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802efe:	8b 52 04             	mov    0x4(%edx),%edx
  802f01:	89 50 04             	mov    %edx,0x4(%eax)
  802f04:	eb 0b                	jmp    802f11 <alloc_block_NF+0x51d>
  802f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f09:	8b 40 04             	mov    0x4(%eax),%eax
  802f0c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f14:	8b 40 04             	mov    0x4(%eax),%eax
  802f17:	85 c0                	test   %eax,%eax
  802f19:	74 0f                	je     802f2a <alloc_block_NF+0x536>
  802f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1e:	8b 40 04             	mov    0x4(%eax),%eax
  802f21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f24:	8b 12                	mov    (%edx),%edx
  802f26:	89 10                	mov    %edx,(%eax)
  802f28:	eb 0a                	jmp    802f34 <alloc_block_NF+0x540>
  802f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f47:	a1 54 51 80 00       	mov    0x805154,%eax
  802f4c:	48                   	dec    %eax
  802f4d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f55:	8b 40 08             	mov    0x8(%eax),%eax
  802f58:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	8b 50 08             	mov    0x8(%eax),%edx
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	01 c2                	add    %eax,%edx
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	8b 40 0c             	mov    0xc(%eax),%eax
  802f74:	2b 45 08             	sub    0x8(%ebp),%eax
  802f77:	89 c2                	mov    %eax,%edx
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f82:	eb 3b                	jmp    802fbf <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f84:	a1 40 51 80 00       	mov    0x805140,%eax
  802f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f90:	74 07                	je     802f99 <alloc_block_NF+0x5a5>
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	8b 00                	mov    (%eax),%eax
  802f97:	eb 05                	jmp    802f9e <alloc_block_NF+0x5aa>
  802f99:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9e:	a3 40 51 80 00       	mov    %eax,0x805140
  802fa3:	a1 40 51 80 00       	mov    0x805140,%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	0f 85 2e fe ff ff    	jne    802dde <alloc_block_NF+0x3ea>
  802fb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb4:	0f 85 24 fe ff ff    	jne    802dde <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fbf:	c9                   	leave  
  802fc0:	c3                   	ret    

00802fc1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802fc1:	55                   	push   %ebp
  802fc2:	89 e5                	mov    %esp,%ebp
  802fc4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802fc7:	a1 38 51 80 00       	mov    0x805138,%eax
  802fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802fcf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fd4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802fd7:	a1 38 51 80 00       	mov    0x805138,%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 14                	je     802ff4 <insert_sorted_with_merge_freeList+0x33>
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	8b 50 08             	mov    0x8(%eax),%edx
  802fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe9:	8b 40 08             	mov    0x8(%eax),%eax
  802fec:	39 c2                	cmp    %eax,%edx
  802fee:	0f 87 9b 01 00 00    	ja     80318f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ff4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff8:	75 17                	jne    803011 <insert_sorted_with_merge_freeList+0x50>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 34 41 80 00       	push   $0x804134
  803002:	68 38 01 00 00       	push   $0x138
  803007:	68 57 41 80 00       	push   $0x804157
  80300c:	e8 e1 d4 ff ff       	call   8004f2 <_panic>
  803011:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	74 0d                	je     803032 <insert_sorted_with_merge_freeList+0x71>
  803025:	a1 38 51 80 00       	mov    0x805138,%eax
  80302a:	8b 55 08             	mov    0x8(%ebp),%edx
  80302d:	89 50 04             	mov    %edx,0x4(%eax)
  803030:	eb 08                	jmp    80303a <insert_sorted_with_merge_freeList+0x79>
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	a3 38 51 80 00       	mov    %eax,0x805138
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304c:	a1 44 51 80 00       	mov    0x805144,%eax
  803051:	40                   	inc    %eax
  803052:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803057:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80305b:	0f 84 a8 06 00 00    	je     803709 <insert_sorted_with_merge_freeList+0x748>
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	8b 50 08             	mov    0x8(%eax),%edx
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	8b 40 0c             	mov    0xc(%eax),%eax
  80306d:	01 c2                	add    %eax,%edx
  80306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803072:	8b 40 08             	mov    0x8(%eax),%eax
  803075:	39 c2                	cmp    %eax,%edx
  803077:	0f 85 8c 06 00 00    	jne    803709 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	8b 50 0c             	mov    0xc(%eax),%edx
  803083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803086:	8b 40 0c             	mov    0xc(%eax),%eax
  803089:	01 c2                	add    %eax,%edx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803091:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803095:	75 17                	jne    8030ae <insert_sorted_with_merge_freeList+0xed>
  803097:	83 ec 04             	sub    $0x4,%esp
  80309a:	68 00 42 80 00       	push   $0x804200
  80309f:	68 3c 01 00 00       	push   $0x13c
  8030a4:	68 57 41 80 00       	push   $0x804157
  8030a9:	e8 44 d4 ff ff       	call   8004f2 <_panic>
  8030ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b1:	8b 00                	mov    (%eax),%eax
  8030b3:	85 c0                	test   %eax,%eax
  8030b5:	74 10                	je     8030c7 <insert_sorted_with_merge_freeList+0x106>
  8030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ba:	8b 00                	mov    (%eax),%eax
  8030bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030bf:	8b 52 04             	mov    0x4(%edx),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%eax)
  8030c5:	eb 0b                	jmp    8030d2 <insert_sorted_with_merge_freeList+0x111>
  8030c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ca:	8b 40 04             	mov    0x4(%eax),%eax
  8030cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d5:	8b 40 04             	mov    0x4(%eax),%eax
  8030d8:	85 c0                	test   %eax,%eax
  8030da:	74 0f                	je     8030eb <insert_sorted_with_merge_freeList+0x12a>
  8030dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030df:	8b 40 04             	mov    0x4(%eax),%eax
  8030e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030e5:	8b 12                	mov    (%edx),%edx
  8030e7:	89 10                	mov    %edx,(%eax)
  8030e9:	eb 0a                	jmp    8030f5 <insert_sorted_with_merge_freeList+0x134>
  8030eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8030f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803101:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803108:	a1 44 51 80 00       	mov    0x805144,%eax
  80310d:	48                   	dec    %eax
  80310e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803116:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803120:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803127:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80312b:	75 17                	jne    803144 <insert_sorted_with_merge_freeList+0x183>
  80312d:	83 ec 04             	sub    $0x4,%esp
  803130:	68 34 41 80 00       	push   $0x804134
  803135:	68 3f 01 00 00       	push   $0x13f
  80313a:	68 57 41 80 00       	push   $0x804157
  80313f:	e8 ae d3 ff ff       	call   8004f2 <_panic>
  803144:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80314a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314d:	89 10                	mov    %edx,(%eax)
  80314f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803152:	8b 00                	mov    (%eax),%eax
  803154:	85 c0                	test   %eax,%eax
  803156:	74 0d                	je     803165 <insert_sorted_with_merge_freeList+0x1a4>
  803158:	a1 48 51 80 00       	mov    0x805148,%eax
  80315d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803160:	89 50 04             	mov    %edx,0x4(%eax)
  803163:	eb 08                	jmp    80316d <insert_sorted_with_merge_freeList+0x1ac>
  803165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803168:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80316d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803170:	a3 48 51 80 00       	mov    %eax,0x805148
  803175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803178:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317f:	a1 54 51 80 00       	mov    0x805154,%eax
  803184:	40                   	inc    %eax
  803185:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80318a:	e9 7a 05 00 00       	jmp    803709 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	8b 50 08             	mov    0x8(%eax),%edx
  803195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803198:	8b 40 08             	mov    0x8(%eax),%eax
  80319b:	39 c2                	cmp    %eax,%edx
  80319d:	0f 82 14 01 00 00    	jb     8032b7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8031a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a6:	8b 50 08             	mov    0x8(%eax),%edx
  8031a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8031af:	01 c2                	add    %eax,%edx
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	8b 40 08             	mov    0x8(%eax),%eax
  8031b7:	39 c2                	cmp    %eax,%edx
  8031b9:	0f 85 90 00 00 00    	jne    80324f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8031bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c2:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cb:	01 c2                	add    %eax,%edx
  8031cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031eb:	75 17                	jne    803204 <insert_sorted_with_merge_freeList+0x243>
  8031ed:	83 ec 04             	sub    $0x4,%esp
  8031f0:	68 34 41 80 00       	push   $0x804134
  8031f5:	68 49 01 00 00       	push   $0x149
  8031fa:	68 57 41 80 00       	push   $0x804157
  8031ff:	e8 ee d2 ff ff       	call   8004f2 <_panic>
  803204:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	89 10                	mov    %edx,(%eax)
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	8b 00                	mov    (%eax),%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	74 0d                	je     803225 <insert_sorted_with_merge_freeList+0x264>
  803218:	a1 48 51 80 00       	mov    0x805148,%eax
  80321d:	8b 55 08             	mov    0x8(%ebp),%edx
  803220:	89 50 04             	mov    %edx,0x4(%eax)
  803223:	eb 08                	jmp    80322d <insert_sorted_with_merge_freeList+0x26c>
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	a3 48 51 80 00       	mov    %eax,0x805148
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323f:	a1 54 51 80 00       	mov    0x805154,%eax
  803244:	40                   	inc    %eax
  803245:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80324a:	e9 bb 04 00 00       	jmp    80370a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80324f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803253:	75 17                	jne    80326c <insert_sorted_with_merge_freeList+0x2ab>
  803255:	83 ec 04             	sub    $0x4,%esp
  803258:	68 a8 41 80 00       	push   $0x8041a8
  80325d:	68 4c 01 00 00       	push   $0x14c
  803262:	68 57 41 80 00       	push   $0x804157
  803267:	e8 86 d2 ff ff       	call   8004f2 <_panic>
  80326c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	89 50 04             	mov    %edx,0x4(%eax)
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	8b 40 04             	mov    0x4(%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 0c                	je     80328e <insert_sorted_with_merge_freeList+0x2cd>
  803282:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803287:	8b 55 08             	mov    0x8(%ebp),%edx
  80328a:	89 10                	mov    %edx,(%eax)
  80328c:	eb 08                	jmp    803296 <insert_sorted_with_merge_freeList+0x2d5>
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	a3 38 51 80 00       	mov    %eax,0x805138
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ac:	40                   	inc    %eax
  8032ad:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032b2:	e9 53 04 00 00       	jmp    80370a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8032bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032bf:	e9 15 04 00 00       	jmp    8036d9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	8b 50 08             	mov    0x8(%eax),%edx
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	8b 40 08             	mov    0x8(%eax),%eax
  8032d8:	39 c2                	cmp    %eax,%edx
  8032da:	0f 86 f1 03 00 00    	jbe    8036d1 <insert_sorted_with_merge_freeList+0x710>
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	8b 50 08             	mov    0x8(%eax),%edx
  8032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e9:	8b 40 08             	mov    0x8(%eax),%eax
  8032ec:	39 c2                	cmp    %eax,%edx
  8032ee:	0f 83 dd 03 00 00    	jae    8036d1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8032f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f7:	8b 50 08             	mov    0x8(%eax),%edx
  8032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803300:	01 c2                	add    %eax,%edx
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	8b 40 08             	mov    0x8(%eax),%eax
  803308:	39 c2                	cmp    %eax,%edx
  80330a:	0f 85 b9 01 00 00    	jne    8034c9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	8b 50 08             	mov    0x8(%eax),%edx
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	8b 40 0c             	mov    0xc(%eax),%eax
  80331c:	01 c2                	add    %eax,%edx
  80331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803321:	8b 40 08             	mov    0x8(%eax),%eax
  803324:	39 c2                	cmp    %eax,%edx
  803326:	0f 85 0d 01 00 00    	jne    803439 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	8b 50 0c             	mov    0xc(%eax),%edx
  803332:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803335:	8b 40 0c             	mov    0xc(%eax),%eax
  803338:	01 c2                	add    %eax,%edx
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803340:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803344:	75 17                	jne    80335d <insert_sorted_with_merge_freeList+0x39c>
  803346:	83 ec 04             	sub    $0x4,%esp
  803349:	68 00 42 80 00       	push   $0x804200
  80334e:	68 5c 01 00 00       	push   $0x15c
  803353:	68 57 41 80 00       	push   $0x804157
  803358:	e8 95 d1 ff ff       	call   8004f2 <_panic>
  80335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803360:	8b 00                	mov    (%eax),%eax
  803362:	85 c0                	test   %eax,%eax
  803364:	74 10                	je     803376 <insert_sorted_with_merge_freeList+0x3b5>
  803366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80336e:	8b 52 04             	mov    0x4(%edx),%edx
  803371:	89 50 04             	mov    %edx,0x4(%eax)
  803374:	eb 0b                	jmp    803381 <insert_sorted_with_merge_freeList+0x3c0>
  803376:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803379:	8b 40 04             	mov    0x4(%eax),%eax
  80337c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803384:	8b 40 04             	mov    0x4(%eax),%eax
  803387:	85 c0                	test   %eax,%eax
  803389:	74 0f                	je     80339a <insert_sorted_with_merge_freeList+0x3d9>
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	8b 40 04             	mov    0x4(%eax),%eax
  803391:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803394:	8b 12                	mov    (%edx),%edx
  803396:	89 10                	mov    %edx,(%eax)
  803398:	eb 0a                	jmp    8033a4 <insert_sorted_with_merge_freeList+0x3e3>
  80339a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339d:	8b 00                	mov    (%eax),%eax
  80339f:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8033bc:	48                   	dec    %eax
  8033bd:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8033c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8033cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033da:	75 17                	jne    8033f3 <insert_sorted_with_merge_freeList+0x432>
  8033dc:	83 ec 04             	sub    $0x4,%esp
  8033df:	68 34 41 80 00       	push   $0x804134
  8033e4:	68 5f 01 00 00       	push   $0x15f
  8033e9:	68 57 41 80 00       	push   $0x804157
  8033ee:	e8 ff d0 ff ff       	call   8004f2 <_panic>
  8033f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fc:	89 10                	mov    %edx,(%eax)
  8033fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803401:	8b 00                	mov    (%eax),%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	74 0d                	je     803414 <insert_sorted_with_merge_freeList+0x453>
  803407:	a1 48 51 80 00       	mov    0x805148,%eax
  80340c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80340f:	89 50 04             	mov    %edx,0x4(%eax)
  803412:	eb 08                	jmp    80341c <insert_sorted_with_merge_freeList+0x45b>
  803414:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803417:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	a3 48 51 80 00       	mov    %eax,0x805148
  803424:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803427:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342e:	a1 54 51 80 00       	mov    0x805154,%eax
  803433:	40                   	inc    %eax
  803434:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 50 0c             	mov    0xc(%eax),%edx
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	8b 40 0c             	mov    0xc(%eax),%eax
  803445:	01 c2                	add    %eax,%edx
  803447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803461:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803465:	75 17                	jne    80347e <insert_sorted_with_merge_freeList+0x4bd>
  803467:	83 ec 04             	sub    $0x4,%esp
  80346a:	68 34 41 80 00       	push   $0x804134
  80346f:	68 64 01 00 00       	push   $0x164
  803474:	68 57 41 80 00       	push   $0x804157
  803479:	e8 74 d0 ff ff       	call   8004f2 <_panic>
  80347e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	89 10                	mov    %edx,(%eax)
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	85 c0                	test   %eax,%eax
  803490:	74 0d                	je     80349f <insert_sorted_with_merge_freeList+0x4de>
  803492:	a1 48 51 80 00       	mov    0x805148,%eax
  803497:	8b 55 08             	mov    0x8(%ebp),%edx
  80349a:	89 50 04             	mov    %edx,0x4(%eax)
  80349d:	eb 08                	jmp    8034a7 <insert_sorted_with_merge_freeList+0x4e6>
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	a3 48 51 80 00       	mov    %eax,0x805148
  8034af:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b9:	a1 54 51 80 00       	mov    0x805154,%eax
  8034be:	40                   	inc    %eax
  8034bf:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034c4:	e9 41 02 00 00       	jmp    80370a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cc:	8b 50 08             	mov    0x8(%eax),%edx
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d5:	01 c2                	add    %eax,%edx
  8034d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034da:	8b 40 08             	mov    0x8(%eax),%eax
  8034dd:	39 c2                	cmp    %eax,%edx
  8034df:	0f 85 7c 01 00 00    	jne    803661 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8034e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034e9:	74 06                	je     8034f1 <insert_sorted_with_merge_freeList+0x530>
  8034eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ef:	75 17                	jne    803508 <insert_sorted_with_merge_freeList+0x547>
  8034f1:	83 ec 04             	sub    $0x4,%esp
  8034f4:	68 70 41 80 00       	push   $0x804170
  8034f9:	68 69 01 00 00       	push   $0x169
  8034fe:	68 57 41 80 00       	push   $0x804157
  803503:	e8 ea cf ff ff       	call   8004f2 <_panic>
  803508:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350b:	8b 50 04             	mov    0x4(%eax),%edx
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	89 50 04             	mov    %edx,0x4(%eax)
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80351a:	89 10                	mov    %edx,(%eax)
  80351c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351f:	8b 40 04             	mov    0x4(%eax),%eax
  803522:	85 c0                	test   %eax,%eax
  803524:	74 0d                	je     803533 <insert_sorted_with_merge_freeList+0x572>
  803526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803529:	8b 40 04             	mov    0x4(%eax),%eax
  80352c:	8b 55 08             	mov    0x8(%ebp),%edx
  80352f:	89 10                	mov    %edx,(%eax)
  803531:	eb 08                	jmp    80353b <insert_sorted_with_merge_freeList+0x57a>
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	a3 38 51 80 00       	mov    %eax,0x805138
  80353b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353e:	8b 55 08             	mov    0x8(%ebp),%edx
  803541:	89 50 04             	mov    %edx,0x4(%eax)
  803544:	a1 44 51 80 00       	mov    0x805144,%eax
  803549:	40                   	inc    %eax
  80354a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80354f:	8b 45 08             	mov    0x8(%ebp),%eax
  803552:	8b 50 0c             	mov    0xc(%eax),%edx
  803555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803558:	8b 40 0c             	mov    0xc(%eax),%eax
  80355b:	01 c2                	add    %eax,%edx
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803563:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803567:	75 17                	jne    803580 <insert_sorted_with_merge_freeList+0x5bf>
  803569:	83 ec 04             	sub    $0x4,%esp
  80356c:	68 00 42 80 00       	push   $0x804200
  803571:	68 6b 01 00 00       	push   $0x16b
  803576:	68 57 41 80 00       	push   $0x804157
  80357b:	e8 72 cf ff ff       	call   8004f2 <_panic>
  803580:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803583:	8b 00                	mov    (%eax),%eax
  803585:	85 c0                	test   %eax,%eax
  803587:	74 10                	je     803599 <insert_sorted_with_merge_freeList+0x5d8>
  803589:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803591:	8b 52 04             	mov    0x4(%edx),%edx
  803594:	89 50 04             	mov    %edx,0x4(%eax)
  803597:	eb 0b                	jmp    8035a4 <insert_sorted_with_merge_freeList+0x5e3>
  803599:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359c:	8b 40 04             	mov    0x4(%eax),%eax
  80359f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a7:	8b 40 04             	mov    0x4(%eax),%eax
  8035aa:	85 c0                	test   %eax,%eax
  8035ac:	74 0f                	je     8035bd <insert_sorted_with_merge_freeList+0x5fc>
  8035ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b1:	8b 40 04             	mov    0x4(%eax),%eax
  8035b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035b7:	8b 12                	mov    (%edx),%edx
  8035b9:	89 10                	mov    %edx,(%eax)
  8035bb:	eb 0a                	jmp    8035c7 <insert_sorted_with_merge_freeList+0x606>
  8035bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c0:	8b 00                	mov    (%eax),%eax
  8035c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8035c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035da:	a1 44 51 80 00       	mov    0x805144,%eax
  8035df:	48                   	dec    %eax
  8035e0:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8035e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8035ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035fd:	75 17                	jne    803616 <insert_sorted_with_merge_freeList+0x655>
  8035ff:	83 ec 04             	sub    $0x4,%esp
  803602:	68 34 41 80 00       	push   $0x804134
  803607:	68 6e 01 00 00       	push   $0x16e
  80360c:	68 57 41 80 00       	push   $0x804157
  803611:	e8 dc ce ff ff       	call   8004f2 <_panic>
  803616:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80361c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361f:	89 10                	mov    %edx,(%eax)
  803621:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803624:	8b 00                	mov    (%eax),%eax
  803626:	85 c0                	test   %eax,%eax
  803628:	74 0d                	je     803637 <insert_sorted_with_merge_freeList+0x676>
  80362a:	a1 48 51 80 00       	mov    0x805148,%eax
  80362f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803632:	89 50 04             	mov    %edx,0x4(%eax)
  803635:	eb 08                	jmp    80363f <insert_sorted_with_merge_freeList+0x67e>
  803637:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80363f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803642:	a3 48 51 80 00       	mov    %eax,0x805148
  803647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803651:	a1 54 51 80 00       	mov    0x805154,%eax
  803656:	40                   	inc    %eax
  803657:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80365c:	e9 a9 00 00 00       	jmp    80370a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803665:	74 06                	je     80366d <insert_sorted_with_merge_freeList+0x6ac>
  803667:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366b:	75 17                	jne    803684 <insert_sorted_with_merge_freeList+0x6c3>
  80366d:	83 ec 04             	sub    $0x4,%esp
  803670:	68 cc 41 80 00       	push   $0x8041cc
  803675:	68 73 01 00 00       	push   $0x173
  80367a:	68 57 41 80 00       	push   $0x804157
  80367f:	e8 6e ce ff ff       	call   8004f2 <_panic>
  803684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803687:	8b 10                	mov    (%eax),%edx
  803689:	8b 45 08             	mov    0x8(%ebp),%eax
  80368c:	89 10                	mov    %edx,(%eax)
  80368e:	8b 45 08             	mov    0x8(%ebp),%eax
  803691:	8b 00                	mov    (%eax),%eax
  803693:	85 c0                	test   %eax,%eax
  803695:	74 0b                	je     8036a2 <insert_sorted_with_merge_freeList+0x6e1>
  803697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	8b 55 08             	mov    0x8(%ebp),%edx
  80369f:	89 50 04             	mov    %edx,0x4(%eax)
  8036a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a8:	89 10                	mov    %edx,(%eax)
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036b0:	89 50 04             	mov    %edx,0x4(%eax)
  8036b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	85 c0                	test   %eax,%eax
  8036ba:	75 08                	jne    8036c4 <insert_sorted_with_merge_freeList+0x703>
  8036bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c9:	40                   	inc    %eax
  8036ca:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8036cf:	eb 39                	jmp    80370a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8036d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036dd:	74 07                	je     8036e6 <insert_sorted_with_merge_freeList+0x725>
  8036df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e2:	8b 00                	mov    (%eax),%eax
  8036e4:	eb 05                	jmp    8036eb <insert_sorted_with_merge_freeList+0x72a>
  8036e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036eb:	a3 40 51 80 00       	mov    %eax,0x805140
  8036f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	0f 85 c7 fb ff ff    	jne    8032c4 <insert_sorted_with_merge_freeList+0x303>
  8036fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803701:	0f 85 bd fb ff ff    	jne    8032c4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803707:	eb 01                	jmp    80370a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803709:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80370a:	90                   	nop
  80370b:	c9                   	leave  
  80370c:	c3                   	ret    
  80370d:	66 90                	xchg   %ax,%ax
  80370f:	90                   	nop

00803710 <__udivdi3>:
  803710:	55                   	push   %ebp
  803711:	57                   	push   %edi
  803712:	56                   	push   %esi
  803713:	53                   	push   %ebx
  803714:	83 ec 1c             	sub    $0x1c,%esp
  803717:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80371b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80371f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803723:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803727:	89 ca                	mov    %ecx,%edx
  803729:	89 f8                	mov    %edi,%eax
  80372b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80372f:	85 f6                	test   %esi,%esi
  803731:	75 2d                	jne    803760 <__udivdi3+0x50>
  803733:	39 cf                	cmp    %ecx,%edi
  803735:	77 65                	ja     80379c <__udivdi3+0x8c>
  803737:	89 fd                	mov    %edi,%ebp
  803739:	85 ff                	test   %edi,%edi
  80373b:	75 0b                	jne    803748 <__udivdi3+0x38>
  80373d:	b8 01 00 00 00       	mov    $0x1,%eax
  803742:	31 d2                	xor    %edx,%edx
  803744:	f7 f7                	div    %edi
  803746:	89 c5                	mov    %eax,%ebp
  803748:	31 d2                	xor    %edx,%edx
  80374a:	89 c8                	mov    %ecx,%eax
  80374c:	f7 f5                	div    %ebp
  80374e:	89 c1                	mov    %eax,%ecx
  803750:	89 d8                	mov    %ebx,%eax
  803752:	f7 f5                	div    %ebp
  803754:	89 cf                	mov    %ecx,%edi
  803756:	89 fa                	mov    %edi,%edx
  803758:	83 c4 1c             	add    $0x1c,%esp
  80375b:	5b                   	pop    %ebx
  80375c:	5e                   	pop    %esi
  80375d:	5f                   	pop    %edi
  80375e:	5d                   	pop    %ebp
  80375f:	c3                   	ret    
  803760:	39 ce                	cmp    %ecx,%esi
  803762:	77 28                	ja     80378c <__udivdi3+0x7c>
  803764:	0f bd fe             	bsr    %esi,%edi
  803767:	83 f7 1f             	xor    $0x1f,%edi
  80376a:	75 40                	jne    8037ac <__udivdi3+0x9c>
  80376c:	39 ce                	cmp    %ecx,%esi
  80376e:	72 0a                	jb     80377a <__udivdi3+0x6a>
  803770:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803774:	0f 87 9e 00 00 00    	ja     803818 <__udivdi3+0x108>
  80377a:	b8 01 00 00 00       	mov    $0x1,%eax
  80377f:	89 fa                	mov    %edi,%edx
  803781:	83 c4 1c             	add    $0x1c,%esp
  803784:	5b                   	pop    %ebx
  803785:	5e                   	pop    %esi
  803786:	5f                   	pop    %edi
  803787:	5d                   	pop    %ebp
  803788:	c3                   	ret    
  803789:	8d 76 00             	lea    0x0(%esi),%esi
  80378c:	31 ff                	xor    %edi,%edi
  80378e:	31 c0                	xor    %eax,%eax
  803790:	89 fa                	mov    %edi,%edx
  803792:	83 c4 1c             	add    $0x1c,%esp
  803795:	5b                   	pop    %ebx
  803796:	5e                   	pop    %esi
  803797:	5f                   	pop    %edi
  803798:	5d                   	pop    %ebp
  803799:	c3                   	ret    
  80379a:	66 90                	xchg   %ax,%ax
  80379c:	89 d8                	mov    %ebx,%eax
  80379e:	f7 f7                	div    %edi
  8037a0:	31 ff                	xor    %edi,%edi
  8037a2:	89 fa                	mov    %edi,%edx
  8037a4:	83 c4 1c             	add    $0x1c,%esp
  8037a7:	5b                   	pop    %ebx
  8037a8:	5e                   	pop    %esi
  8037a9:	5f                   	pop    %edi
  8037aa:	5d                   	pop    %ebp
  8037ab:	c3                   	ret    
  8037ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037b1:	89 eb                	mov    %ebp,%ebx
  8037b3:	29 fb                	sub    %edi,%ebx
  8037b5:	89 f9                	mov    %edi,%ecx
  8037b7:	d3 e6                	shl    %cl,%esi
  8037b9:	89 c5                	mov    %eax,%ebp
  8037bb:	88 d9                	mov    %bl,%cl
  8037bd:	d3 ed                	shr    %cl,%ebp
  8037bf:	89 e9                	mov    %ebp,%ecx
  8037c1:	09 f1                	or     %esi,%ecx
  8037c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037c7:	89 f9                	mov    %edi,%ecx
  8037c9:	d3 e0                	shl    %cl,%eax
  8037cb:	89 c5                	mov    %eax,%ebp
  8037cd:	89 d6                	mov    %edx,%esi
  8037cf:	88 d9                	mov    %bl,%cl
  8037d1:	d3 ee                	shr    %cl,%esi
  8037d3:	89 f9                	mov    %edi,%ecx
  8037d5:	d3 e2                	shl    %cl,%edx
  8037d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037db:	88 d9                	mov    %bl,%cl
  8037dd:	d3 e8                	shr    %cl,%eax
  8037df:	09 c2                	or     %eax,%edx
  8037e1:	89 d0                	mov    %edx,%eax
  8037e3:	89 f2                	mov    %esi,%edx
  8037e5:	f7 74 24 0c          	divl   0xc(%esp)
  8037e9:	89 d6                	mov    %edx,%esi
  8037eb:	89 c3                	mov    %eax,%ebx
  8037ed:	f7 e5                	mul    %ebp
  8037ef:	39 d6                	cmp    %edx,%esi
  8037f1:	72 19                	jb     80380c <__udivdi3+0xfc>
  8037f3:	74 0b                	je     803800 <__udivdi3+0xf0>
  8037f5:	89 d8                	mov    %ebx,%eax
  8037f7:	31 ff                	xor    %edi,%edi
  8037f9:	e9 58 ff ff ff       	jmp    803756 <__udivdi3+0x46>
  8037fe:	66 90                	xchg   %ax,%ax
  803800:	8b 54 24 08          	mov    0x8(%esp),%edx
  803804:	89 f9                	mov    %edi,%ecx
  803806:	d3 e2                	shl    %cl,%edx
  803808:	39 c2                	cmp    %eax,%edx
  80380a:	73 e9                	jae    8037f5 <__udivdi3+0xe5>
  80380c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80380f:	31 ff                	xor    %edi,%edi
  803811:	e9 40 ff ff ff       	jmp    803756 <__udivdi3+0x46>
  803816:	66 90                	xchg   %ax,%ax
  803818:	31 c0                	xor    %eax,%eax
  80381a:	e9 37 ff ff ff       	jmp    803756 <__udivdi3+0x46>
  80381f:	90                   	nop

00803820 <__umoddi3>:
  803820:	55                   	push   %ebp
  803821:	57                   	push   %edi
  803822:	56                   	push   %esi
  803823:	53                   	push   %ebx
  803824:	83 ec 1c             	sub    $0x1c,%esp
  803827:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80382b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80382f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803833:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803837:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80383b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80383f:	89 f3                	mov    %esi,%ebx
  803841:	89 fa                	mov    %edi,%edx
  803843:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803847:	89 34 24             	mov    %esi,(%esp)
  80384a:	85 c0                	test   %eax,%eax
  80384c:	75 1a                	jne    803868 <__umoddi3+0x48>
  80384e:	39 f7                	cmp    %esi,%edi
  803850:	0f 86 a2 00 00 00    	jbe    8038f8 <__umoddi3+0xd8>
  803856:	89 c8                	mov    %ecx,%eax
  803858:	89 f2                	mov    %esi,%edx
  80385a:	f7 f7                	div    %edi
  80385c:	89 d0                	mov    %edx,%eax
  80385e:	31 d2                	xor    %edx,%edx
  803860:	83 c4 1c             	add    $0x1c,%esp
  803863:	5b                   	pop    %ebx
  803864:	5e                   	pop    %esi
  803865:	5f                   	pop    %edi
  803866:	5d                   	pop    %ebp
  803867:	c3                   	ret    
  803868:	39 f0                	cmp    %esi,%eax
  80386a:	0f 87 ac 00 00 00    	ja     80391c <__umoddi3+0xfc>
  803870:	0f bd e8             	bsr    %eax,%ebp
  803873:	83 f5 1f             	xor    $0x1f,%ebp
  803876:	0f 84 ac 00 00 00    	je     803928 <__umoddi3+0x108>
  80387c:	bf 20 00 00 00       	mov    $0x20,%edi
  803881:	29 ef                	sub    %ebp,%edi
  803883:	89 fe                	mov    %edi,%esi
  803885:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803889:	89 e9                	mov    %ebp,%ecx
  80388b:	d3 e0                	shl    %cl,%eax
  80388d:	89 d7                	mov    %edx,%edi
  80388f:	89 f1                	mov    %esi,%ecx
  803891:	d3 ef                	shr    %cl,%edi
  803893:	09 c7                	or     %eax,%edi
  803895:	89 e9                	mov    %ebp,%ecx
  803897:	d3 e2                	shl    %cl,%edx
  803899:	89 14 24             	mov    %edx,(%esp)
  80389c:	89 d8                	mov    %ebx,%eax
  80389e:	d3 e0                	shl    %cl,%eax
  8038a0:	89 c2                	mov    %eax,%edx
  8038a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038a6:	d3 e0                	shl    %cl,%eax
  8038a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038b0:	89 f1                	mov    %esi,%ecx
  8038b2:	d3 e8                	shr    %cl,%eax
  8038b4:	09 d0                	or     %edx,%eax
  8038b6:	d3 eb                	shr    %cl,%ebx
  8038b8:	89 da                	mov    %ebx,%edx
  8038ba:	f7 f7                	div    %edi
  8038bc:	89 d3                	mov    %edx,%ebx
  8038be:	f7 24 24             	mull   (%esp)
  8038c1:	89 c6                	mov    %eax,%esi
  8038c3:	89 d1                	mov    %edx,%ecx
  8038c5:	39 d3                	cmp    %edx,%ebx
  8038c7:	0f 82 87 00 00 00    	jb     803954 <__umoddi3+0x134>
  8038cd:	0f 84 91 00 00 00    	je     803964 <__umoddi3+0x144>
  8038d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038d7:	29 f2                	sub    %esi,%edx
  8038d9:	19 cb                	sbb    %ecx,%ebx
  8038db:	89 d8                	mov    %ebx,%eax
  8038dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038e1:	d3 e0                	shl    %cl,%eax
  8038e3:	89 e9                	mov    %ebp,%ecx
  8038e5:	d3 ea                	shr    %cl,%edx
  8038e7:	09 d0                	or     %edx,%eax
  8038e9:	89 e9                	mov    %ebp,%ecx
  8038eb:	d3 eb                	shr    %cl,%ebx
  8038ed:	89 da                	mov    %ebx,%edx
  8038ef:	83 c4 1c             	add    $0x1c,%esp
  8038f2:	5b                   	pop    %ebx
  8038f3:	5e                   	pop    %esi
  8038f4:	5f                   	pop    %edi
  8038f5:	5d                   	pop    %ebp
  8038f6:	c3                   	ret    
  8038f7:	90                   	nop
  8038f8:	89 fd                	mov    %edi,%ebp
  8038fa:	85 ff                	test   %edi,%edi
  8038fc:	75 0b                	jne    803909 <__umoddi3+0xe9>
  8038fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803903:	31 d2                	xor    %edx,%edx
  803905:	f7 f7                	div    %edi
  803907:	89 c5                	mov    %eax,%ebp
  803909:	89 f0                	mov    %esi,%eax
  80390b:	31 d2                	xor    %edx,%edx
  80390d:	f7 f5                	div    %ebp
  80390f:	89 c8                	mov    %ecx,%eax
  803911:	f7 f5                	div    %ebp
  803913:	89 d0                	mov    %edx,%eax
  803915:	e9 44 ff ff ff       	jmp    80385e <__umoddi3+0x3e>
  80391a:	66 90                	xchg   %ax,%ax
  80391c:	89 c8                	mov    %ecx,%eax
  80391e:	89 f2                	mov    %esi,%edx
  803920:	83 c4 1c             	add    $0x1c,%esp
  803923:	5b                   	pop    %ebx
  803924:	5e                   	pop    %esi
  803925:	5f                   	pop    %edi
  803926:	5d                   	pop    %ebp
  803927:	c3                   	ret    
  803928:	3b 04 24             	cmp    (%esp),%eax
  80392b:	72 06                	jb     803933 <__umoddi3+0x113>
  80392d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803931:	77 0f                	ja     803942 <__umoddi3+0x122>
  803933:	89 f2                	mov    %esi,%edx
  803935:	29 f9                	sub    %edi,%ecx
  803937:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80393b:	89 14 24             	mov    %edx,(%esp)
  80393e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803942:	8b 44 24 04          	mov    0x4(%esp),%eax
  803946:	8b 14 24             	mov    (%esp),%edx
  803949:	83 c4 1c             	add    $0x1c,%esp
  80394c:	5b                   	pop    %ebx
  80394d:	5e                   	pop    %esi
  80394e:	5f                   	pop    %edi
  80394f:	5d                   	pop    %ebp
  803950:	c3                   	ret    
  803951:	8d 76 00             	lea    0x0(%esi),%esi
  803954:	2b 04 24             	sub    (%esp),%eax
  803957:	19 fa                	sbb    %edi,%edx
  803959:	89 d1                	mov    %edx,%ecx
  80395b:	89 c6                	mov    %eax,%esi
  80395d:	e9 71 ff ff ff       	jmp    8038d3 <__umoddi3+0xb3>
  803962:	66 90                	xchg   %ax,%ax
  803964:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803968:	72 ea                	jb     803954 <__umoddi3+0x134>
  80396a:	89 d9                	mov    %ebx,%ecx
  80396c:	e9 62 ff ff ff       	jmp    8038d3 <__umoddi3+0xb3>
