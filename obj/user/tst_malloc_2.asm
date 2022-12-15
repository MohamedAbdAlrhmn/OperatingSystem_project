
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
  800090:	68 c0 38 80 00       	push   $0x8038c0
  800095:	6a 1a                	push   $0x1a
  800097:	68 dc 38 80 00       	push   $0x8038dc
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
  800282:	68 f0 38 80 00       	push   $0x8038f0
  800287:	6a 45                	push   $0x45
  800289:	68 dc 38 80 00       	push   $0x8038dc
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
  8002b7:	68 f0 38 80 00       	push   $0x8038f0
  8002bc:	6a 46                	push   $0x46
  8002be:	68 dc 38 80 00       	push   $0x8038dc
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
  8002eb:	68 f0 38 80 00       	push   $0x8038f0
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 dc 38 80 00       	push   $0x8038dc
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
  80031f:	68 f0 38 80 00       	push   $0x8038f0
  800324:	6a 49                	push   $0x49
  800326:	68 dc 38 80 00       	push   $0x8038dc
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
  800359:	68 f0 38 80 00       	push   $0x8038f0
  80035e:	6a 4a                	push   $0x4a
  800360:	68 dc 38 80 00       	push   $0x8038dc
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
  80038f:	68 f0 38 80 00       	push   $0x8038f0
  800394:	6a 4b                	push   $0x4b
  800396:	68 dc 38 80 00       	push   $0x8038dc
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 28 39 80 00       	push   $0x803928
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
  8003bc:	e8 b4 19 00 00       	call   801d75 <sys_getenvindex>
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
  800427:	e8 56 17 00 00       	call   801b82 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 7c 39 80 00       	push   $0x80397c
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
  800457:	68 a4 39 80 00       	push   $0x8039a4
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
  800488:	68 cc 39 80 00       	push   $0x8039cc
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 50 80 00       	mov    0x805020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 24 3a 80 00       	push   $0x803a24
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 7c 39 80 00       	push   $0x80397c
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 d6 16 00 00       	call   801b9c <sys_enable_interrupt>

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
  8004d9:	e8 63 18 00 00       	call   801d41 <sys_destroy_env>
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
  8004ea:	e8 b8 18 00 00       	call   801da7 <sys_exit_env>
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
  800513:	68 38 3a 80 00       	push   $0x803a38
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 50 80 00       	mov    0x805000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 3d 3a 80 00       	push   $0x803a3d
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
  800550:	68 59 3a 80 00       	push   $0x803a59
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
  80057c:	68 5c 3a 80 00       	push   $0x803a5c
  800581:	6a 26                	push   $0x26
  800583:	68 a8 3a 80 00       	push   $0x803aa8
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
  80064e:	68 b4 3a 80 00       	push   $0x803ab4
  800653:	6a 3a                	push   $0x3a
  800655:	68 a8 3a 80 00       	push   $0x803aa8
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
  8006be:	68 08 3b 80 00       	push   $0x803b08
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 a8 3a 80 00       	push   $0x803aa8
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
  800718:	e8 b7 12 00 00       	call   8019d4 <sys_cputs>
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
  80078f:	e8 40 12 00 00       	call   8019d4 <sys_cputs>
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
  8007d9:	e8 a4 13 00 00       	call   801b82 <sys_disable_interrupt>
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
  8007f9:	e8 9e 13 00 00       	call   801b9c <sys_enable_interrupt>
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
  800843:	e8 10 2e 00 00       	call   803658 <__udivdi3>
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
  800893:	e8 d0 2e 00 00       	call   803768 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 74 3d 80 00       	add    $0x803d74,%eax
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
  8009ee:	8b 04 85 98 3d 80 00 	mov    0x803d98(,%eax,4),%eax
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
  800acf:	8b 34 9d e0 3b 80 00 	mov    0x803be0(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 85 3d 80 00       	push   $0x803d85
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
  800af4:	68 8e 3d 80 00       	push   $0x803d8e
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
  800b21:	be 91 3d 80 00       	mov    $0x803d91,%esi
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
  801547:	68 f0 3e 80 00       	push   $0x803ef0
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
  801617:	e8 fc 04 00 00       	call   801b18 <sys_allocate_chunk>
  80161c:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80161f:	a1 20 51 80 00       	mov    0x805120,%eax
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	50                   	push   %eax
  801628:	e8 71 0b 00 00       	call   80219e <initialize_MemBlocksList>
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
  801655:	68 15 3f 80 00       	push   $0x803f15
  80165a:	6a 33                	push   $0x33
  80165c:	68 33 3f 80 00       	push   $0x803f33
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
  8016d4:	68 40 3f 80 00       	push   $0x803f40
  8016d9:	6a 34                	push   $0x34
  8016db:	68 33 3f 80 00       	push   $0x803f33
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
  80176c:	e8 75 07 00 00       	call   801ee6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801771:	85 c0                	test   %eax,%eax
  801773:	74 11                	je     801786 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	ff 75 e8             	pushl  -0x18(%ebp)
  80177b:	e8 e0 0d 00 00       	call   802560 <alloc_block_FF>
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
  801792:	e8 3c 0b 00 00       	call   8022d3 <insert_sorted_allocList>
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
  8017b2:	68 64 3f 80 00       	push   $0x803f64
  8017b7:	6a 6f                	push   $0x6f
  8017b9:	68 33 3f 80 00       	push   $0x803f33
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
  8017d8:	75 0a                	jne    8017e4 <smalloc+0x21>
  8017da:	b8 00 00 00 00       	mov    $0x0,%eax
  8017df:	e9 8b 00 00 00       	jmp    80186f <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017e4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f1:	01 d0                	add    %edx,%eax
  8017f3:	48                   	dec    %eax
  8017f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ff:	f7 75 f0             	divl   -0x10(%ebp)
  801802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801805:	29 d0                	sub    %edx,%eax
  801807:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80180a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801811:	e8 d0 06 00 00       	call   801ee6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801816:	85 c0                	test   %eax,%eax
  801818:	74 11                	je     80182b <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80181a:	83 ec 0c             	sub    $0xc,%esp
  80181d:	ff 75 e8             	pushl  -0x18(%ebp)
  801820:	e8 3b 0d 00 00       	call   802560 <alloc_block_FF>
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80182b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80182f:	74 39                	je     80186a <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801834:	8b 40 08             	mov    0x8(%eax),%eax
  801837:	89 c2                	mov    %eax,%edx
  801839:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80183d:	52                   	push   %edx
  80183e:	50                   	push   %eax
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	ff 75 08             	pushl  0x8(%ebp)
  801845:	e8 21 04 00 00       	call   801c6b <sys_createSharedObject>
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801850:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801854:	74 14                	je     80186a <smalloc+0xa7>
  801856:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80185a:	74 0e                	je     80186a <smalloc+0xa7>
  80185c:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801860:	74 08                	je     80186a <smalloc+0xa7>
			return (void*) mem_block->sva;
  801862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801865:	8b 40 08             	mov    0x8(%eax),%eax
  801868:	eb 05                	jmp    80186f <smalloc+0xac>
	}
	return NULL;
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801877:	e8 b4 fc ff ff       	call   801530 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80187c:	83 ec 08             	sub    $0x8,%esp
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	ff 75 08             	pushl  0x8(%ebp)
  801885:	e8 0b 04 00 00       	call   801c95 <sys_getSizeOfSharedObject>
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801890:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801894:	74 76                	je     80190c <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801896:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80189d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a3:	01 d0                	add    %edx,%eax
  8018a5:	48                   	dec    %eax
  8018a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b1:	f7 75 ec             	divl   -0x14(%ebp)
  8018b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b7:	29 d0                	sub    %edx,%eax
  8018b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8018bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8018c3:	e8 1e 06 00 00       	call   801ee6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	74 11                	je     8018dd <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8018cc:	83 ec 0c             	sub    $0xc,%esp
  8018cf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018d2:	e8 89 0c 00 00       	call   802560 <alloc_block_FF>
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8018dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018e1:	74 29                	je     80190c <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8018e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e6:	8b 40 08             	mov    0x8(%eax),%eax
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	50                   	push   %eax
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	e8 ba 03 00 00       	call   801cb2 <sys_getSharedObject>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8018fe:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801902:	74 08                	je     80190c <sget+0x9b>
				return (void *)mem_block->sva;
  801904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801907:	8b 40 08             	mov    0x8(%eax),%eax
  80190a:	eb 05                	jmp    801911 <sget+0xa0>
		}
	}
	return NULL;
  80190c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801919:	e8 12 fc ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	68 88 3f 80 00       	push   $0x803f88
  801926:	68 f1 00 00 00       	push   $0xf1
  80192b:	68 33 3f 80 00       	push   $0x803f33
  801930:	e8 bd eb ff ff       	call   8004f2 <_panic>

00801935 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80193b:	83 ec 04             	sub    $0x4,%esp
  80193e:	68 b0 3f 80 00       	push   $0x803fb0
  801943:	68 05 01 00 00       	push   $0x105
  801948:	68 33 3f 80 00       	push   $0x803f33
  80194d:	e8 a0 eb ff ff       	call   8004f2 <_panic>

00801952 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	68 d4 3f 80 00       	push   $0x803fd4
  801960:	68 10 01 00 00       	push   $0x110
  801965:	68 33 3f 80 00       	push   $0x803f33
  80196a:	e8 83 eb ff ff       	call   8004f2 <_panic>

0080196f <shrink>:

}
void shrink(uint32 newSize)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801975:	83 ec 04             	sub    $0x4,%esp
  801978:	68 d4 3f 80 00       	push   $0x803fd4
  80197d:	68 15 01 00 00       	push   $0x115
  801982:	68 33 3f 80 00       	push   $0x803f33
  801987:	e8 66 eb ff ff       	call   8004f2 <_panic>

0080198c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	68 d4 3f 80 00       	push   $0x803fd4
  80199a:	68 1a 01 00 00       	push   $0x11a
  80199f:	68 33 3f 80 00       	push   $0x803f33
  8019a4:	e8 49 eb ff ff       	call   8004f2 <_panic>

008019a9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	57                   	push   %edi
  8019ad:	56                   	push   %esi
  8019ae:	53                   	push   %ebx
  8019af:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019be:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019c1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019c4:	cd 30                	int    $0x30
  8019c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019cc:	83 c4 10             	add    $0x10,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5e                   	pop    %esi
  8019d1:	5f                   	pop    %edi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019e0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	52                   	push   %edx
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	6a 00                	push   $0x0
  8019f2:	e8 b2 ff ff ff       	call   8019a9 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	90                   	nop
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 01                	push   $0x1
  801a0c:	e8 98 ff ff ff       	call   8019a9 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	52                   	push   %edx
  801a26:	50                   	push   %eax
  801a27:	6a 05                	push   $0x5
  801a29:	e8 7b ff ff ff       	call   8019a9 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	56                   	push   %esi
  801a37:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a38:	8b 75 18             	mov    0x18(%ebp),%esi
  801a3b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	56                   	push   %esi
  801a48:	53                   	push   %ebx
  801a49:	51                   	push   %ecx
  801a4a:	52                   	push   %edx
  801a4b:	50                   	push   %eax
  801a4c:	6a 06                	push   $0x6
  801a4e:	e8 56 ff ff ff       	call   8019a9 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a59:	5b                   	pop    %ebx
  801a5a:	5e                   	pop    %esi
  801a5b:	5d                   	pop    %ebp
  801a5c:	c3                   	ret    

00801a5d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	52                   	push   %edx
  801a6d:	50                   	push   %eax
  801a6e:	6a 07                	push   $0x7
  801a70:	e8 34 ff ff ff       	call   8019a9 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	ff 75 08             	pushl  0x8(%ebp)
  801a89:	6a 08                	push   $0x8
  801a8b:	e8 19 ff ff ff       	call   8019a9 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 09                	push   $0x9
  801aa4:	e8 00 ff ff ff       	call   8019a9 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 0a                	push   $0xa
  801abd:	e8 e7 fe ff ff       	call   8019a9 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 0b                	push   $0xb
  801ad6:	e8 ce fe ff ff       	call   8019a9 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	ff 75 08             	pushl  0x8(%ebp)
  801aef:	6a 0f                	push   $0xf
  801af1:	e8 b3 fe ff ff       	call   8019a9 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
	return;
  801af9:	90                   	nop
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	ff 75 0c             	pushl  0xc(%ebp)
  801b08:	ff 75 08             	pushl  0x8(%ebp)
  801b0b:	6a 10                	push   $0x10
  801b0d:	e8 97 fe ff ff       	call   8019a9 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
	return ;
  801b15:	90                   	nop
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	ff 75 10             	pushl  0x10(%ebp)
  801b22:	ff 75 0c             	pushl  0xc(%ebp)
  801b25:	ff 75 08             	pushl  0x8(%ebp)
  801b28:	6a 11                	push   $0x11
  801b2a:	e8 7a fe ff ff       	call   8019a9 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b32:	90                   	nop
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 0c                	push   $0xc
  801b44:	e8 60 fe ff ff       	call   8019a9 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	ff 75 08             	pushl  0x8(%ebp)
  801b5c:	6a 0d                	push   $0xd
  801b5e:	e8 46 fe ff ff       	call   8019a9 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 0e                	push   $0xe
  801b77:	e8 2d fe ff ff       	call   8019a9 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	90                   	nop
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 13                	push   $0x13
  801b91:	e8 13 fe ff ff       	call   8019a9 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	90                   	nop
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 14                	push   $0x14
  801bab:	e8 f9 fd ff ff       	call   8019a9 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	90                   	nop
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_cputc>:


void
sys_cputc(const char c)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 04             	sub    $0x4,%esp
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bc2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	50                   	push   %eax
  801bcf:	6a 15                	push   $0x15
  801bd1:	e8 d3 fd ff ff       	call   8019a9 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	90                   	nop
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 16                	push   $0x16
  801beb:	e8 b9 fd ff ff       	call   8019a9 <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	90                   	nop
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	ff 75 0c             	pushl  0xc(%ebp)
  801c05:	50                   	push   %eax
  801c06:	6a 17                	push   $0x17
  801c08:	e8 9c fd ff ff       	call   8019a9 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	52                   	push   %edx
  801c22:	50                   	push   %eax
  801c23:	6a 1a                	push   $0x1a
  801c25:	e8 7f fd ff ff       	call   8019a9 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	52                   	push   %edx
  801c3f:	50                   	push   %eax
  801c40:	6a 18                	push   $0x18
  801c42:	e8 62 fd ff ff       	call   8019a9 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	90                   	nop
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	52                   	push   %edx
  801c5d:	50                   	push   %eax
  801c5e:	6a 19                	push   $0x19
  801c60:	e8 44 fd ff ff       	call   8019a9 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	90                   	nop
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c77:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c7a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	6a 00                	push   $0x0
  801c83:	51                   	push   %ecx
  801c84:	52                   	push   %edx
  801c85:	ff 75 0c             	pushl  0xc(%ebp)
  801c88:	50                   	push   %eax
  801c89:	6a 1b                	push   $0x1b
  801c8b:	e8 19 fd ff ff       	call   8019a9 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	52                   	push   %edx
  801ca5:	50                   	push   %eax
  801ca6:	6a 1c                	push   $0x1c
  801ca8:	e8 fc fc ff ff       	call   8019a9 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	51                   	push   %ecx
  801cc3:	52                   	push   %edx
  801cc4:	50                   	push   %eax
  801cc5:	6a 1d                	push   $0x1d
  801cc7:	e8 dd fc ff ff       	call   8019a9 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	52                   	push   %edx
  801ce1:	50                   	push   %eax
  801ce2:	6a 1e                	push   $0x1e
  801ce4:	e8 c0 fc ff ff       	call   8019a9 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 1f                	push   $0x1f
  801cfd:	e8 a7 fc ff ff       	call   8019a9 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	ff 75 14             	pushl  0x14(%ebp)
  801d12:	ff 75 10             	pushl  0x10(%ebp)
  801d15:	ff 75 0c             	pushl  0xc(%ebp)
  801d18:	50                   	push   %eax
  801d19:	6a 20                	push   $0x20
  801d1b:	e8 89 fc ff ff       	call   8019a9 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	50                   	push   %eax
  801d34:	6a 21                	push   $0x21
  801d36:	e8 6e fc ff ff       	call   8019a9 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	90                   	nop
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	50                   	push   %eax
  801d50:	6a 22                	push   $0x22
  801d52:	e8 52 fc ff ff       	call   8019a9 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 02                	push   $0x2
  801d6b:	e8 39 fc ff ff       	call   8019a9 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 03                	push   $0x3
  801d84:	e8 20 fc ff ff       	call   8019a9 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 04                	push   $0x4
  801d9d:	e8 07 fc ff ff       	call   8019a9 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_exit_env>:


void sys_exit_env(void)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 23                	push   $0x23
  801db6:	e8 ee fb ff ff       	call   8019a9 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	90                   	nop
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dc7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dca:	8d 50 04             	lea    0x4(%eax),%edx
  801dcd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	52                   	push   %edx
  801dd7:	50                   	push   %eax
  801dd8:	6a 24                	push   $0x24
  801dda:	e8 ca fb ff ff       	call   8019a9 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
	return result;
  801de2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801de8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801deb:	89 01                	mov    %eax,(%ecx)
  801ded:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	c9                   	leave  
  801df4:	c2 04 00             	ret    $0x4

00801df7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	ff 75 10             	pushl  0x10(%ebp)
  801e01:	ff 75 0c             	pushl  0xc(%ebp)
  801e04:	ff 75 08             	pushl  0x8(%ebp)
  801e07:	6a 12                	push   $0x12
  801e09:	e8 9b fb ff ff       	call   8019a9 <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e11:	90                   	nop
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 25                	push   $0x25
  801e23:	e8 81 fb ff ff       	call   8019a9 <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 04             	sub    $0x4,%esp
  801e33:	8b 45 08             	mov    0x8(%ebp),%eax
  801e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e39:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	50                   	push   %eax
  801e46:	6a 26                	push   $0x26
  801e48:	e8 5c fb ff ff       	call   8019a9 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e50:	90                   	nop
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <rsttst>:
void rsttst()
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 28                	push   $0x28
  801e62:	e8 42 fb ff ff       	call   8019a9 <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6a:	90                   	nop
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	8b 45 14             	mov    0x14(%ebp),%eax
  801e76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e79:	8b 55 18             	mov    0x18(%ebp),%edx
  801e7c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e80:	52                   	push   %edx
  801e81:	50                   	push   %eax
  801e82:	ff 75 10             	pushl  0x10(%ebp)
  801e85:	ff 75 0c             	pushl  0xc(%ebp)
  801e88:	ff 75 08             	pushl  0x8(%ebp)
  801e8b:	6a 27                	push   $0x27
  801e8d:	e8 17 fb ff ff       	call   8019a9 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
	return ;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <chktst>:
void chktst(uint32 n)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	ff 75 08             	pushl  0x8(%ebp)
  801ea6:	6a 29                	push   $0x29
  801ea8:	e8 fc fa ff ff       	call   8019a9 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb0:	90                   	nop
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <inctst>:

void inctst()
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 2a                	push   $0x2a
  801ec2:	e8 e2 fa ff ff       	call   8019a9 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eca:	90                   	nop
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <gettst>:
uint32 gettst()
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 2b                	push   $0x2b
  801edc:	e8 c8 fa ff ff       	call   8019a9 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 2c                	push   $0x2c
  801ef8:	e8 ac fa ff ff       	call   8019a9 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
  801f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f03:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f07:	75 07                	jne    801f10 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f09:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0e:	eb 05                	jmp    801f15 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 2c                	push   $0x2c
  801f29:	e8 7b fa ff ff       	call   8019a9 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
  801f31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f34:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f38:	75 07                	jne    801f41 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3f:	eb 05                	jmp    801f46 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 2c                	push   $0x2c
  801f5a:	e8 4a fa ff ff       	call   8019a9 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
  801f62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f65:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f69:	75 07                	jne    801f72 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f70:	eb 05                	jmp    801f77 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 2c                	push   $0x2c
  801f8b:	e8 19 fa ff ff       	call   8019a9 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
  801f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f96:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f9a:	75 07                	jne    801fa3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa1:	eb 05                	jmp    801fa8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	ff 75 08             	pushl  0x8(%ebp)
  801fb8:	6a 2d                	push   $0x2d
  801fba:	e8 ea f9 ff ff       	call   8019a9 <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc2:	90                   	nop
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	6a 00                	push   $0x0
  801fd7:	53                   	push   %ebx
  801fd8:	51                   	push   %ecx
  801fd9:	52                   	push   %edx
  801fda:	50                   	push   %eax
  801fdb:	6a 2e                	push   $0x2e
  801fdd:	e8 c7 f9 ff ff       	call   8019a9 <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	52                   	push   %edx
  801ffa:	50                   	push   %eax
  801ffb:	6a 2f                	push   $0x2f
  801ffd:	e8 a7 f9 ff ff       	call   8019a9 <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	68 e4 3f 80 00       	push   $0x803fe4
  802015:	e8 8c e7 ff ff       	call   8007a6 <cprintf>
  80201a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80201d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802024:	83 ec 0c             	sub    $0xc,%esp
  802027:	68 10 40 80 00       	push   $0x804010
  80202c:	e8 75 e7 ff ff       	call   8007a6 <cprintf>
  802031:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802034:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802038:	a1 38 51 80 00       	mov    0x805138,%eax
  80203d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802040:	eb 56                	jmp    802098 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802042:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802046:	74 1c                	je     802064 <print_mem_block_lists+0x5d>
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	8b 50 08             	mov    0x8(%eax),%edx
  80204e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802051:	8b 48 08             	mov    0x8(%eax),%ecx
  802054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802057:	8b 40 0c             	mov    0xc(%eax),%eax
  80205a:	01 c8                	add    %ecx,%eax
  80205c:	39 c2                	cmp    %eax,%edx
  80205e:	73 04                	jae    802064 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802060:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	8b 50 08             	mov    0x8(%eax),%edx
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 40 0c             	mov    0xc(%eax),%eax
  802070:	01 c2                	add    %eax,%edx
  802072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802075:	8b 40 08             	mov    0x8(%eax),%eax
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	52                   	push   %edx
  80207c:	50                   	push   %eax
  80207d:	68 25 40 80 00       	push   $0x804025
  802082:	e8 1f e7 ff ff       	call   8007a6 <cprintf>
  802087:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80208a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802090:	a1 40 51 80 00       	mov    0x805140,%eax
  802095:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802098:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209c:	74 07                	je     8020a5 <print_mem_block_lists+0x9e>
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	8b 00                	mov    (%eax),%eax
  8020a3:	eb 05                	jmp    8020aa <print_mem_block_lists+0xa3>
  8020a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020aa:	a3 40 51 80 00       	mov    %eax,0x805140
  8020af:	a1 40 51 80 00       	mov    0x805140,%eax
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	75 8a                	jne    802042 <print_mem_block_lists+0x3b>
  8020b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020bc:	75 84                	jne    802042 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020be:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020c2:	75 10                	jne    8020d4 <print_mem_block_lists+0xcd>
  8020c4:	83 ec 0c             	sub    $0xc,%esp
  8020c7:	68 34 40 80 00       	push   $0x804034
  8020cc:	e8 d5 e6 ff ff       	call   8007a6 <cprintf>
  8020d1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020db:	83 ec 0c             	sub    $0xc,%esp
  8020de:	68 58 40 80 00       	push   $0x804058
  8020e3:	e8 be e6 ff ff       	call   8007a6 <cprintf>
  8020e8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020eb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020ef:	a1 40 50 80 00       	mov    0x805040,%eax
  8020f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f7:	eb 56                	jmp    80214f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020fd:	74 1c                	je     80211b <print_mem_block_lists+0x114>
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	8b 50 08             	mov    0x8(%eax),%edx
  802105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802108:	8b 48 08             	mov    0x8(%eax),%ecx
  80210b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210e:	8b 40 0c             	mov    0xc(%eax),%eax
  802111:	01 c8                	add    %ecx,%eax
  802113:	39 c2                	cmp    %eax,%edx
  802115:	73 04                	jae    80211b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802117:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	8b 50 08             	mov    0x8(%eax),%edx
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	8b 40 0c             	mov    0xc(%eax),%eax
  802127:	01 c2                	add    %eax,%edx
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	8b 40 08             	mov    0x8(%eax),%eax
  80212f:	83 ec 04             	sub    $0x4,%esp
  802132:	52                   	push   %edx
  802133:	50                   	push   %eax
  802134:	68 25 40 80 00       	push   $0x804025
  802139:	e8 68 e6 ff ff       	call   8007a6 <cprintf>
  80213e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802147:	a1 48 50 80 00       	mov    0x805048,%eax
  80214c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802153:	74 07                	je     80215c <print_mem_block_lists+0x155>
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802158:	8b 00                	mov    (%eax),%eax
  80215a:	eb 05                	jmp    802161 <print_mem_block_lists+0x15a>
  80215c:	b8 00 00 00 00       	mov    $0x0,%eax
  802161:	a3 48 50 80 00       	mov    %eax,0x805048
  802166:	a1 48 50 80 00       	mov    0x805048,%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	75 8a                	jne    8020f9 <print_mem_block_lists+0xf2>
  80216f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802173:	75 84                	jne    8020f9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802175:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802179:	75 10                	jne    80218b <print_mem_block_lists+0x184>
  80217b:	83 ec 0c             	sub    $0xc,%esp
  80217e:	68 70 40 80 00       	push   $0x804070
  802183:	e8 1e e6 ff ff       	call   8007a6 <cprintf>
  802188:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80218b:	83 ec 0c             	sub    $0xc,%esp
  80218e:	68 e4 3f 80 00       	push   $0x803fe4
  802193:	e8 0e e6 ff ff       	call   8007a6 <cprintf>
  802198:	83 c4 10             	add    $0x10,%esp

}
  80219b:	90                   	nop
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8021a4:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8021ab:	00 00 00 
  8021ae:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8021b5:	00 00 00 
  8021b8:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8021bf:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8021c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021c9:	e9 9e 00 00 00       	jmp    80226c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8021ce:	a1 50 50 80 00       	mov    0x805050,%eax
  8021d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d6:	c1 e2 04             	shl    $0x4,%edx
  8021d9:	01 d0                	add    %edx,%eax
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	75 14                	jne    8021f3 <initialize_MemBlocksList+0x55>
  8021df:	83 ec 04             	sub    $0x4,%esp
  8021e2:	68 98 40 80 00       	push   $0x804098
  8021e7:	6a 46                	push   $0x46
  8021e9:	68 bb 40 80 00       	push   $0x8040bb
  8021ee:	e8 ff e2 ff ff       	call   8004f2 <_panic>
  8021f3:	a1 50 50 80 00       	mov    0x805050,%eax
  8021f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fb:	c1 e2 04             	shl    $0x4,%edx
  8021fe:	01 d0                	add    %edx,%eax
  802200:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802206:	89 10                	mov    %edx,(%eax)
  802208:	8b 00                	mov    (%eax),%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	74 18                	je     802226 <initialize_MemBlocksList+0x88>
  80220e:	a1 48 51 80 00       	mov    0x805148,%eax
  802213:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802219:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80221c:	c1 e1 04             	shl    $0x4,%ecx
  80221f:	01 ca                	add    %ecx,%edx
  802221:	89 50 04             	mov    %edx,0x4(%eax)
  802224:	eb 12                	jmp    802238 <initialize_MemBlocksList+0x9a>
  802226:	a1 50 50 80 00       	mov    0x805050,%eax
  80222b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222e:	c1 e2 04             	shl    $0x4,%edx
  802231:	01 d0                	add    %edx,%eax
  802233:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802238:	a1 50 50 80 00       	mov    0x805050,%eax
  80223d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802240:	c1 e2 04             	shl    $0x4,%edx
  802243:	01 d0                	add    %edx,%eax
  802245:	a3 48 51 80 00       	mov    %eax,0x805148
  80224a:	a1 50 50 80 00       	mov    0x805050,%eax
  80224f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802252:	c1 e2 04             	shl    $0x4,%edx
  802255:	01 d0                	add    %edx,%eax
  802257:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225e:	a1 54 51 80 00       	mov    0x805154,%eax
  802263:	40                   	inc    %eax
  802264:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802269:	ff 45 f4             	incl   -0xc(%ebp)
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802272:	0f 82 56 ff ff ff    	jb     8021ce <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802278:	90                   	nop
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	8b 00                	mov    (%eax),%eax
  802286:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802289:	eb 19                	jmp    8022a4 <find_block+0x29>
	{
		if(va==point->sva)
  80228b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80228e:	8b 40 08             	mov    0x8(%eax),%eax
  802291:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802294:	75 05                	jne    80229b <find_block+0x20>
		   return point;
  802296:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802299:	eb 36                	jmp    8022d1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	8b 40 08             	mov    0x8(%eax),%eax
  8022a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a8:	74 07                	je     8022b1 <find_block+0x36>
  8022aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	eb 05                	jmp    8022b6 <find_block+0x3b>
  8022b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b9:	89 42 08             	mov    %eax,0x8(%edx)
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	8b 40 08             	mov    0x8(%eax),%eax
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	75 c5                	jne    80228b <find_block+0x10>
  8022c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022ca:	75 bf                	jne    80228b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8022d9:	a1 40 50 80 00       	mov    0x805040,%eax
  8022de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8022e1:	a1 44 50 80 00       	mov    0x805044,%eax
  8022e6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8022e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022ef:	74 24                	je     802315 <insert_sorted_allocList+0x42>
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	8b 50 08             	mov    0x8(%eax),%edx
  8022f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fa:	8b 40 08             	mov    0x8(%eax),%eax
  8022fd:	39 c2                	cmp    %eax,%edx
  8022ff:	76 14                	jbe    802315 <insert_sorted_allocList+0x42>
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	8b 50 08             	mov    0x8(%eax),%edx
  802307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230a:	8b 40 08             	mov    0x8(%eax),%eax
  80230d:	39 c2                	cmp    %eax,%edx
  80230f:	0f 82 60 01 00 00    	jb     802475 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802315:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802319:	75 65                	jne    802380 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80231b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80231f:	75 14                	jne    802335 <insert_sorted_allocList+0x62>
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	68 98 40 80 00       	push   $0x804098
  802329:	6a 6b                	push   $0x6b
  80232b:	68 bb 40 80 00       	push   $0x8040bb
  802330:	e8 bd e1 ff ff       	call   8004f2 <_panic>
  802335:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	89 10                	mov    %edx,(%eax)
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	85 c0                	test   %eax,%eax
  802347:	74 0d                	je     802356 <insert_sorted_allocList+0x83>
  802349:	a1 40 50 80 00       	mov    0x805040,%eax
  80234e:	8b 55 08             	mov    0x8(%ebp),%edx
  802351:	89 50 04             	mov    %edx,0x4(%eax)
  802354:	eb 08                	jmp    80235e <insert_sorted_allocList+0x8b>
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	a3 44 50 80 00       	mov    %eax,0x805044
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	a3 40 50 80 00       	mov    %eax,0x805040
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802370:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802375:	40                   	inc    %eax
  802376:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80237b:	e9 dc 01 00 00       	jmp    80255c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8b 50 08             	mov    0x8(%eax),%edx
  802386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802389:	8b 40 08             	mov    0x8(%eax),%eax
  80238c:	39 c2                	cmp    %eax,%edx
  80238e:	77 6c                	ja     8023fc <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802390:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802394:	74 06                	je     80239c <insert_sorted_allocList+0xc9>
  802396:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239a:	75 14                	jne    8023b0 <insert_sorted_allocList+0xdd>
  80239c:	83 ec 04             	sub    $0x4,%esp
  80239f:	68 d4 40 80 00       	push   $0x8040d4
  8023a4:	6a 6f                	push   $0x6f
  8023a6:	68 bb 40 80 00       	push   $0x8040bb
  8023ab:	e8 42 e1 ff ff       	call   8004f2 <_panic>
  8023b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b3:	8b 50 04             	mov    0x4(%eax),%edx
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	89 50 04             	mov    %edx,0x4(%eax)
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c2:	89 10                	mov    %edx,(%eax)
  8023c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	74 0d                	je     8023db <insert_sorted_allocList+0x108>
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	8b 40 04             	mov    0x4(%eax),%eax
  8023d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d7:	89 10                	mov    %edx,(%eax)
  8023d9:	eb 08                	jmp    8023e3 <insert_sorted_allocList+0x110>
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	a3 40 50 80 00       	mov    %eax,0x805040
  8023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e9:	89 50 04             	mov    %edx,0x4(%eax)
  8023ec:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023f1:	40                   	inc    %eax
  8023f2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023f7:	e9 60 01 00 00       	jmp    80255c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	8b 50 08             	mov    0x8(%eax),%edx
  802402:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802405:	8b 40 08             	mov    0x8(%eax),%eax
  802408:	39 c2                	cmp    %eax,%edx
  80240a:	0f 82 4c 01 00 00    	jb     80255c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802410:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802414:	75 14                	jne    80242a <insert_sorted_allocList+0x157>
  802416:	83 ec 04             	sub    $0x4,%esp
  802419:	68 0c 41 80 00       	push   $0x80410c
  80241e:	6a 73                	push   $0x73
  802420:	68 bb 40 80 00       	push   $0x8040bb
  802425:	e8 c8 e0 ff ff       	call   8004f2 <_panic>
  80242a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	89 50 04             	mov    %edx,0x4(%eax)
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	8b 40 04             	mov    0x4(%eax),%eax
  80243c:	85 c0                	test   %eax,%eax
  80243e:	74 0c                	je     80244c <insert_sorted_allocList+0x179>
  802440:	a1 44 50 80 00       	mov    0x805044,%eax
  802445:	8b 55 08             	mov    0x8(%ebp),%edx
  802448:	89 10                	mov    %edx,(%eax)
  80244a:	eb 08                	jmp    802454 <insert_sorted_allocList+0x181>
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	a3 40 50 80 00       	mov    %eax,0x805040
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	a3 44 50 80 00       	mov    %eax,0x805044
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802465:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80246a:	40                   	inc    %eax
  80246b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802470:	e9 e7 00 00 00       	jmp    80255c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802478:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80247b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802482:	a1 40 50 80 00       	mov    0x805040,%eax
  802487:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248a:	e9 9d 00 00 00       	jmp    80252c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	8b 50 08             	mov    0x8(%eax),%edx
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 08             	mov    0x8(%eax),%eax
  8024a3:	39 c2                	cmp    %eax,%edx
  8024a5:	76 7d                	jbe    802524 <insert_sorted_allocList+0x251>
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	8b 50 08             	mov    0x8(%eax),%edx
  8024ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b0:	8b 40 08             	mov    0x8(%eax),%eax
  8024b3:	39 c2                	cmp    %eax,%edx
  8024b5:	73 6d                	jae    802524 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8024b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bb:	74 06                	je     8024c3 <insert_sorted_allocList+0x1f0>
  8024bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024c1:	75 14                	jne    8024d7 <insert_sorted_allocList+0x204>
  8024c3:	83 ec 04             	sub    $0x4,%esp
  8024c6:	68 30 41 80 00       	push   $0x804130
  8024cb:	6a 7f                	push   $0x7f
  8024cd:	68 bb 40 80 00       	push   $0x8040bb
  8024d2:	e8 1b e0 ff ff       	call   8004f2 <_panic>
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 10                	mov    (%eax),%edx
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	89 10                	mov    %edx,(%eax)
  8024e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	74 0b                	je     8024f5 <insert_sorted_allocList+0x222>
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 00                	mov    (%eax),%eax
  8024ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f2:	89 50 04             	mov    %edx,0x4(%eax)
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fb:	89 10                	mov    %edx,(%eax)
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802503:	89 50 04             	mov    %edx,0x4(%eax)
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	8b 00                	mov    (%eax),%eax
  80250b:	85 c0                	test   %eax,%eax
  80250d:	75 08                	jne    802517 <insert_sorted_allocList+0x244>
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	a3 44 50 80 00       	mov    %eax,0x805044
  802517:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80251c:	40                   	inc    %eax
  80251d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802522:	eb 39                	jmp    80255d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802524:	a1 48 50 80 00       	mov    0x805048,%eax
  802529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802530:	74 07                	je     802539 <insert_sorted_allocList+0x266>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	eb 05                	jmp    80253e <insert_sorted_allocList+0x26b>
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	a3 48 50 80 00       	mov    %eax,0x805048
  802543:	a1 48 50 80 00       	mov    0x805048,%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 85 3f ff ff ff    	jne    80248f <insert_sorted_allocList+0x1bc>
  802550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802554:	0f 85 35 ff ff ff    	jne    80248f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80255a:	eb 01                	jmp    80255d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80255c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80255d:	90                   	nop
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802566:	a1 38 51 80 00       	mov    0x805138,%eax
  80256b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256e:	e9 85 01 00 00       	jmp    8026f8 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 0c             	mov    0xc(%eax),%eax
  802579:	3b 45 08             	cmp    0x8(%ebp),%eax
  80257c:	0f 82 6e 01 00 00    	jb     8026f0 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 40 0c             	mov    0xc(%eax),%eax
  802588:	3b 45 08             	cmp    0x8(%ebp),%eax
  80258b:	0f 85 8a 00 00 00    	jne    80261b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802595:	75 17                	jne    8025ae <alloc_block_FF+0x4e>
  802597:	83 ec 04             	sub    $0x4,%esp
  80259a:	68 64 41 80 00       	push   $0x804164
  80259f:	68 93 00 00 00       	push   $0x93
  8025a4:	68 bb 40 80 00       	push   $0x8040bb
  8025a9:	e8 44 df ff ff       	call   8004f2 <_panic>
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 10                	je     8025c7 <alloc_block_FF+0x67>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bf:	8b 52 04             	mov    0x4(%edx),%edx
  8025c2:	89 50 04             	mov    %edx,0x4(%eax)
  8025c5:	eb 0b                	jmp    8025d2 <alloc_block_FF+0x72>
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 40 04             	mov    0x4(%eax),%eax
  8025cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 40 04             	mov    0x4(%eax),%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 0f                	je     8025eb <alloc_block_FF+0x8b>
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 40 04             	mov    0x4(%eax),%eax
  8025e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e5:	8b 12                	mov    (%edx),%edx
  8025e7:	89 10                	mov    %edx,(%eax)
  8025e9:	eb 0a                	jmp    8025f5 <alloc_block_FF+0x95>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802608:	a1 44 51 80 00       	mov    0x805144,%eax
  80260d:	48                   	dec    %eax
  80260e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	e9 10 01 00 00       	jmp    80272b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 40 0c             	mov    0xc(%eax),%eax
  802621:	3b 45 08             	cmp    0x8(%ebp),%eax
  802624:	0f 86 c6 00 00 00    	jbe    8026f0 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80262a:	a1 48 51 80 00       	mov    0x805148,%eax
  80262f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 50 08             	mov    0x8(%eax),%edx
  802638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	8b 55 08             	mov    0x8(%ebp),%edx
  802644:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802647:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80264b:	75 17                	jne    802664 <alloc_block_FF+0x104>
  80264d:	83 ec 04             	sub    $0x4,%esp
  802650:	68 64 41 80 00       	push   $0x804164
  802655:	68 9b 00 00 00       	push   $0x9b
  80265a:	68 bb 40 80 00       	push   $0x8040bb
  80265f:	e8 8e de ff ff       	call   8004f2 <_panic>
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	85 c0                	test   %eax,%eax
  80266b:	74 10                	je     80267d <alloc_block_FF+0x11d>
  80266d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802670:	8b 00                	mov    (%eax),%eax
  802672:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802675:	8b 52 04             	mov    0x4(%edx),%edx
  802678:	89 50 04             	mov    %edx,0x4(%eax)
  80267b:	eb 0b                	jmp    802688 <alloc_block_FF+0x128>
  80267d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802680:	8b 40 04             	mov    0x4(%eax),%eax
  802683:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268b:	8b 40 04             	mov    0x4(%eax),%eax
  80268e:	85 c0                	test   %eax,%eax
  802690:	74 0f                	je     8026a1 <alloc_block_FF+0x141>
  802692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802695:	8b 40 04             	mov    0x4(%eax),%eax
  802698:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80269b:	8b 12                	mov    (%edx),%edx
  80269d:	89 10                	mov    %edx,(%eax)
  80269f:	eb 0a                	jmp    8026ab <alloc_block_FF+0x14b>
  8026a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a4:	8b 00                	mov    (%eax),%eax
  8026a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8026ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026be:	a1 54 51 80 00       	mov    0x805154,%eax
  8026c3:	48                   	dec    %eax
  8026c4:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 50 08             	mov    0x8(%eax),%edx
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	01 c2                	add    %eax,%edx
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8026e3:	89 c2                	mov    %eax,%edx
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8026eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ee:	eb 3b                	jmp    80272b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8026f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fc:	74 07                	je     802705 <alloc_block_FF+0x1a5>
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	eb 05                	jmp    80270a <alloc_block_FF+0x1aa>
  802705:	b8 00 00 00 00       	mov    $0x0,%eax
  80270a:	a3 40 51 80 00       	mov    %eax,0x805140
  80270f:	a1 40 51 80 00       	mov    0x805140,%eax
  802714:	85 c0                	test   %eax,%eax
  802716:	0f 85 57 fe ff ff    	jne    802573 <alloc_block_FF+0x13>
  80271c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802720:	0f 85 4d fe ff ff    	jne    802573 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802726:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272b:	c9                   	leave  
  80272c:	c3                   	ret    

0080272d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80272d:	55                   	push   %ebp
  80272e:	89 e5                	mov    %esp,%ebp
  802730:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802733:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80273a:	a1 38 51 80 00       	mov    0x805138,%eax
  80273f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802742:	e9 df 00 00 00       	jmp    802826 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 40 0c             	mov    0xc(%eax),%eax
  80274d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802750:	0f 82 c8 00 00 00    	jb     80281e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 40 0c             	mov    0xc(%eax),%eax
  80275c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80275f:	0f 85 8a 00 00 00    	jne    8027ef <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802765:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802769:	75 17                	jne    802782 <alloc_block_BF+0x55>
  80276b:	83 ec 04             	sub    $0x4,%esp
  80276e:	68 64 41 80 00       	push   $0x804164
  802773:	68 b7 00 00 00       	push   $0xb7
  802778:	68 bb 40 80 00       	push   $0x8040bb
  80277d:	e8 70 dd ff ff       	call   8004f2 <_panic>
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	74 10                	je     80279b <alloc_block_BF+0x6e>
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802793:	8b 52 04             	mov    0x4(%edx),%edx
  802796:	89 50 04             	mov    %edx,0x4(%eax)
  802799:	eb 0b                	jmp    8027a6 <alloc_block_BF+0x79>
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 04             	mov    0x4(%eax),%eax
  8027a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	74 0f                	je     8027bf <alloc_block_BF+0x92>
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b9:	8b 12                	mov    (%edx),%edx
  8027bb:	89 10                	mov    %edx,(%eax)
  8027bd:	eb 0a                	jmp    8027c9 <alloc_block_BF+0x9c>
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	a3 38 51 80 00       	mov    %eax,0x805138
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8027e1:	48                   	dec    %eax
  8027e2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	e9 4d 01 00 00       	jmp    80293c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f8:	76 24                	jbe    80281e <alloc_block_BF+0xf1>
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802800:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802803:	73 19                	jae    80281e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802805:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 40 0c             	mov    0xc(%eax),%eax
  802812:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 40 08             	mov    0x8(%eax),%eax
  80281b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80281e:	a1 40 51 80 00       	mov    0x805140,%eax
  802823:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282a:	74 07                	je     802833 <alloc_block_BF+0x106>
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	eb 05                	jmp    802838 <alloc_block_BF+0x10b>
  802833:	b8 00 00 00 00       	mov    $0x0,%eax
  802838:	a3 40 51 80 00       	mov    %eax,0x805140
  80283d:	a1 40 51 80 00       	mov    0x805140,%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	0f 85 fd fe ff ff    	jne    802747 <alloc_block_BF+0x1a>
  80284a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284e:	0f 85 f3 fe ff ff    	jne    802747 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802854:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802858:	0f 84 d9 00 00 00    	je     802937 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80285e:	a1 48 51 80 00       	mov    0x805148,%eax
  802863:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802869:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80286c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80286f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802872:	8b 55 08             	mov    0x8(%ebp),%edx
  802875:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802878:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80287c:	75 17                	jne    802895 <alloc_block_BF+0x168>
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	68 64 41 80 00       	push   $0x804164
  802886:	68 c7 00 00 00       	push   $0xc7
  80288b:	68 bb 40 80 00       	push   $0x8040bb
  802890:	e8 5d dc ff ff       	call   8004f2 <_panic>
  802895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	74 10                	je     8028ae <alloc_block_BF+0x181>
  80289e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a6:	8b 52 04             	mov    0x4(%edx),%edx
  8028a9:	89 50 04             	mov    %edx,0x4(%eax)
  8028ac:	eb 0b                	jmp    8028b9 <alloc_block_BF+0x18c>
  8028ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b1:	8b 40 04             	mov    0x4(%eax),%eax
  8028b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028bc:	8b 40 04             	mov    0x4(%eax),%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	74 0f                	je     8028d2 <alloc_block_BF+0x1a5>
  8028c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028cc:	8b 12                	mov    (%edx),%edx
  8028ce:	89 10                	mov    %edx,(%eax)
  8028d0:	eb 0a                	jmp    8028dc <alloc_block_BF+0x1af>
  8028d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8028dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8028f4:	48                   	dec    %eax
  8028f5:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8028fa:	83 ec 08             	sub    $0x8,%esp
  8028fd:	ff 75 ec             	pushl  -0x14(%ebp)
  802900:	68 38 51 80 00       	push   $0x805138
  802905:	e8 71 f9 ff ff       	call   80227b <find_block>
  80290a:	83 c4 10             	add    $0x10,%esp
  80290d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802910:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802913:	8b 50 08             	mov    0x8(%eax),%edx
  802916:	8b 45 08             	mov    0x8(%ebp),%eax
  802919:	01 c2                	add    %eax,%edx
  80291b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802921:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802924:	8b 40 0c             	mov    0xc(%eax),%eax
  802927:	2b 45 08             	sub    0x8(%ebp),%eax
  80292a:	89 c2                	mov    %eax,%edx
  80292c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802935:	eb 05                	jmp    80293c <alloc_block_BF+0x20f>
	}
	return NULL;
  802937:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80293c:	c9                   	leave  
  80293d:	c3                   	ret    

0080293e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80293e:	55                   	push   %ebp
  80293f:	89 e5                	mov    %esp,%ebp
  802941:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802944:	a1 28 50 80 00       	mov    0x805028,%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	0f 85 de 01 00 00    	jne    802b2f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802951:	a1 38 51 80 00       	mov    0x805138,%eax
  802956:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802959:	e9 9e 01 00 00       	jmp    802afc <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 40 0c             	mov    0xc(%eax),%eax
  802964:	3b 45 08             	cmp    0x8(%ebp),%eax
  802967:	0f 82 87 01 00 00    	jb     802af4 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 0c             	mov    0xc(%eax),%eax
  802973:	3b 45 08             	cmp    0x8(%ebp),%eax
  802976:	0f 85 95 00 00 00    	jne    802a11 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80297c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802980:	75 17                	jne    802999 <alloc_block_NF+0x5b>
  802982:	83 ec 04             	sub    $0x4,%esp
  802985:	68 64 41 80 00       	push   $0x804164
  80298a:	68 e0 00 00 00       	push   $0xe0
  80298f:	68 bb 40 80 00       	push   $0x8040bb
  802994:	e8 59 db ff ff       	call   8004f2 <_panic>
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	74 10                	je     8029b2 <alloc_block_NF+0x74>
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029aa:	8b 52 04             	mov    0x4(%edx),%edx
  8029ad:	89 50 04             	mov    %edx,0x4(%eax)
  8029b0:	eb 0b                	jmp    8029bd <alloc_block_NF+0x7f>
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 40 04             	mov    0x4(%eax),%eax
  8029b8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 40 04             	mov    0x4(%eax),%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	74 0f                	je     8029d6 <alloc_block_NF+0x98>
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d0:	8b 12                	mov    (%edx),%edx
  8029d2:	89 10                	mov    %edx,(%eax)
  8029d4:	eb 0a                	jmp    8029e0 <alloc_block_NF+0xa2>
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	a3 38 51 80 00       	mov    %eax,0x805138
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8029f8:	48                   	dec    %eax
  8029f9:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 08             	mov    0x8(%eax),%eax
  802a04:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	e9 f8 04 00 00       	jmp    802f09 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	8b 40 0c             	mov    0xc(%eax),%eax
  802a17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1a:	0f 86 d4 00 00 00    	jbe    802af4 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a20:	a1 48 51 80 00       	mov    0x805148,%eax
  802a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 50 08             	mov    0x8(%eax),%edx
  802a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a31:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a37:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a41:	75 17                	jne    802a5a <alloc_block_NF+0x11c>
  802a43:	83 ec 04             	sub    $0x4,%esp
  802a46:	68 64 41 80 00       	push   $0x804164
  802a4b:	68 e9 00 00 00       	push   $0xe9
  802a50:	68 bb 40 80 00       	push   $0x8040bb
  802a55:	e8 98 da ff ff       	call   8004f2 <_panic>
  802a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 10                	je     802a73 <alloc_block_NF+0x135>
  802a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a6b:	8b 52 04             	mov    0x4(%edx),%edx
  802a6e:	89 50 04             	mov    %edx,0x4(%eax)
  802a71:	eb 0b                	jmp    802a7e <alloc_block_NF+0x140>
  802a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a76:	8b 40 04             	mov    0x4(%eax),%eax
  802a79:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a81:	8b 40 04             	mov    0x4(%eax),%eax
  802a84:	85 c0                	test   %eax,%eax
  802a86:	74 0f                	je     802a97 <alloc_block_NF+0x159>
  802a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a91:	8b 12                	mov    (%edx),%edx
  802a93:	89 10                	mov    %edx,(%eax)
  802a95:	eb 0a                	jmp    802aa1 <alloc_block_NF+0x163>
  802a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	a3 48 51 80 00       	mov    %eax,0x805148
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab4:	a1 54 51 80 00       	mov    0x805154,%eax
  802ab9:	48                   	dec    %eax
  802aba:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac2:	8b 40 08             	mov    0x8(%eax),%eax
  802ac5:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 50 08             	mov    0x8(%eax),%edx
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	01 c2                	add    %eax,%edx
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae4:	89 c2                	mov    %eax,%edx
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	e9 15 04 00 00       	jmp    802f09 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802af4:	a1 40 51 80 00       	mov    0x805140,%eax
  802af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b00:	74 07                	je     802b09 <alloc_block_NF+0x1cb>
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	eb 05                	jmp    802b0e <alloc_block_NF+0x1d0>
  802b09:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0e:	a3 40 51 80 00       	mov    %eax,0x805140
  802b13:	a1 40 51 80 00       	mov    0x805140,%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	0f 85 3e fe ff ff    	jne    80295e <alloc_block_NF+0x20>
  802b20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b24:	0f 85 34 fe ff ff    	jne    80295e <alloc_block_NF+0x20>
  802b2a:	e9 d5 03 00 00       	jmp    802f04 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b2f:	a1 38 51 80 00       	mov    0x805138,%eax
  802b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b37:	e9 b1 01 00 00       	jmp    802ced <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 50 08             	mov    0x8(%eax),%edx
  802b42:	a1 28 50 80 00       	mov    0x805028,%eax
  802b47:	39 c2                	cmp    %eax,%edx
  802b49:	0f 82 96 01 00 00    	jb     802ce5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	8b 40 0c             	mov    0xc(%eax),%eax
  802b55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b58:	0f 82 87 01 00 00    	jb     802ce5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 40 0c             	mov    0xc(%eax),%eax
  802b64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b67:	0f 85 95 00 00 00    	jne    802c02 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b71:	75 17                	jne    802b8a <alloc_block_NF+0x24c>
  802b73:	83 ec 04             	sub    $0x4,%esp
  802b76:	68 64 41 80 00       	push   $0x804164
  802b7b:	68 fc 00 00 00       	push   $0xfc
  802b80:	68 bb 40 80 00       	push   $0x8040bb
  802b85:	e8 68 d9 ff ff       	call   8004f2 <_panic>
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	74 10                	je     802ba3 <alloc_block_NF+0x265>
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 00                	mov    (%eax),%eax
  802b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9b:	8b 52 04             	mov    0x4(%edx),%edx
  802b9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ba1:	eb 0b                	jmp    802bae <alloc_block_NF+0x270>
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 40 04             	mov    0x4(%eax),%eax
  802ba9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 40 04             	mov    0x4(%eax),%eax
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	74 0f                	je     802bc7 <alloc_block_NF+0x289>
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 40 04             	mov    0x4(%eax),%eax
  802bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc1:	8b 12                	mov    (%edx),%edx
  802bc3:	89 10                	mov    %edx,(%eax)
  802bc5:	eb 0a                	jmp    802bd1 <alloc_block_NF+0x293>
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	a3 38 51 80 00       	mov    %eax,0x805138
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be4:	a1 44 51 80 00       	mov    0x805144,%eax
  802be9:	48                   	dec    %eax
  802bea:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 40 08             	mov    0x8(%eax),%eax
  802bf5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	e9 07 03 00 00       	jmp    802f09 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 40 0c             	mov    0xc(%eax),%eax
  802c08:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0b:	0f 86 d4 00 00 00    	jbe    802ce5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c11:	a1 48 51 80 00       	mov    0x805148,%eax
  802c16:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 50 08             	mov    0x8(%eax),%edx
  802c1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c22:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c28:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c32:	75 17                	jne    802c4b <alloc_block_NF+0x30d>
  802c34:	83 ec 04             	sub    $0x4,%esp
  802c37:	68 64 41 80 00       	push   $0x804164
  802c3c:	68 04 01 00 00       	push   $0x104
  802c41:	68 bb 40 80 00       	push   $0x8040bb
  802c46:	e8 a7 d8 ff ff       	call   8004f2 <_panic>
  802c4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	74 10                	je     802c64 <alloc_block_NF+0x326>
  802c54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c5c:	8b 52 04             	mov    0x4(%edx),%edx
  802c5f:	89 50 04             	mov    %edx,0x4(%eax)
  802c62:	eb 0b                	jmp    802c6f <alloc_block_NF+0x331>
  802c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c67:	8b 40 04             	mov    0x4(%eax),%eax
  802c6a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c72:	8b 40 04             	mov    0x4(%eax),%eax
  802c75:	85 c0                	test   %eax,%eax
  802c77:	74 0f                	je     802c88 <alloc_block_NF+0x34a>
  802c79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7c:	8b 40 04             	mov    0x4(%eax),%eax
  802c7f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c82:	8b 12                	mov    (%edx),%edx
  802c84:	89 10                	mov    %edx,(%eax)
  802c86:	eb 0a                	jmp    802c92 <alloc_block_NF+0x354>
  802c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	a3 48 51 80 00       	mov    %eax,0x805148
  802c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca5:	a1 54 51 80 00       	mov    0x805154,%eax
  802caa:	48                   	dec    %eax
  802cab:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb3:	8b 40 08             	mov    0x8(%eax),%eax
  802cb6:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 50 08             	mov    0x8(%eax),%edx
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	01 c2                	add    %eax,%edx
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd2:	2b 45 08             	sub    0x8(%ebp),%eax
  802cd5:	89 c2                	mov    %eax,%edx
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce0:	e9 24 02 00 00       	jmp    802f09 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ce5:	a1 40 51 80 00       	mov    0x805140,%eax
  802cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf1:	74 07                	je     802cfa <alloc_block_NF+0x3bc>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	eb 05                	jmp    802cff <alloc_block_NF+0x3c1>
  802cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  802cff:	a3 40 51 80 00       	mov    %eax,0x805140
  802d04:	a1 40 51 80 00       	mov    0x805140,%eax
  802d09:	85 c0                	test   %eax,%eax
  802d0b:	0f 85 2b fe ff ff    	jne    802b3c <alloc_block_NF+0x1fe>
  802d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d15:	0f 85 21 fe ff ff    	jne    802b3c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d23:	e9 ae 01 00 00       	jmp    802ed6 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 50 08             	mov    0x8(%eax),%edx
  802d2e:	a1 28 50 80 00       	mov    0x805028,%eax
  802d33:	39 c2                	cmp    %eax,%edx
  802d35:	0f 83 93 01 00 00    	jae    802ece <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d44:	0f 82 84 01 00 00    	jb     802ece <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d53:	0f 85 95 00 00 00    	jne    802dee <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5d:	75 17                	jne    802d76 <alloc_block_NF+0x438>
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 64 41 80 00       	push   $0x804164
  802d67:	68 14 01 00 00       	push   $0x114
  802d6c:	68 bb 40 80 00       	push   $0x8040bb
  802d71:	e8 7c d7 ff ff       	call   8004f2 <_panic>
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	85 c0                	test   %eax,%eax
  802d7d:	74 10                	je     802d8f <alloc_block_NF+0x451>
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d87:	8b 52 04             	mov    0x4(%edx),%edx
  802d8a:	89 50 04             	mov    %edx,0x4(%eax)
  802d8d:	eb 0b                	jmp    802d9a <alloc_block_NF+0x45c>
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	8b 40 04             	mov    0x4(%eax),%eax
  802d95:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	74 0f                	je     802db3 <alloc_block_NF+0x475>
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 40 04             	mov    0x4(%eax),%eax
  802daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dad:	8b 12                	mov    (%edx),%edx
  802daf:	89 10                	mov    %edx,(%eax)
  802db1:	eb 0a                	jmp    802dbd <alloc_block_NF+0x47f>
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	a3 38 51 80 00       	mov    %eax,0x805138
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd0:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd5:	48                   	dec    %eax
  802dd6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 40 08             	mov    0x8(%eax),%eax
  802de1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	e9 1b 01 00 00       	jmp    802f09 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 40 0c             	mov    0xc(%eax),%eax
  802df4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802df7:	0f 86 d1 00 00 00    	jbe    802ece <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dfd:	a1 48 51 80 00       	mov    0x805148,%eax
  802e02:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 50 08             	mov    0x8(%eax),%edx
  802e0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e14:	8b 55 08             	mov    0x8(%ebp),%edx
  802e17:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e1e:	75 17                	jne    802e37 <alloc_block_NF+0x4f9>
  802e20:	83 ec 04             	sub    $0x4,%esp
  802e23:	68 64 41 80 00       	push   $0x804164
  802e28:	68 1c 01 00 00       	push   $0x11c
  802e2d:	68 bb 40 80 00       	push   $0x8040bb
  802e32:	e8 bb d6 ff ff       	call   8004f2 <_panic>
  802e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	74 10                	je     802e50 <alloc_block_NF+0x512>
  802e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e48:	8b 52 04             	mov    0x4(%edx),%edx
  802e4b:	89 50 04             	mov    %edx,0x4(%eax)
  802e4e:	eb 0b                	jmp    802e5b <alloc_block_NF+0x51d>
  802e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e53:	8b 40 04             	mov    0x4(%eax),%eax
  802e56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5e:	8b 40 04             	mov    0x4(%eax),%eax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	74 0f                	je     802e74 <alloc_block_NF+0x536>
  802e65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e68:	8b 40 04             	mov    0x4(%eax),%eax
  802e6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e6e:	8b 12                	mov    (%edx),%edx
  802e70:	89 10                	mov    %edx,(%eax)
  802e72:	eb 0a                	jmp    802e7e <alloc_block_NF+0x540>
  802e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	a3 48 51 80 00       	mov    %eax,0x805148
  802e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e91:	a1 54 51 80 00       	mov    0x805154,%eax
  802e96:	48                   	dec    %eax
  802e97:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ea2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 50 08             	mov    0x8(%eax),%edx
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	01 c2                	add    %eax,%edx
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebe:	2b 45 08             	sub    0x8(%ebp),%eax
  802ec1:	89 c2                	mov    %eax,%edx
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecc:	eb 3b                	jmp    802f09 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ece:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eda:	74 07                	je     802ee3 <alloc_block_NF+0x5a5>
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	eb 05                	jmp    802ee8 <alloc_block_NF+0x5aa>
  802ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee8:	a3 40 51 80 00       	mov    %eax,0x805140
  802eed:	a1 40 51 80 00       	mov    0x805140,%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	0f 85 2e fe ff ff    	jne    802d28 <alloc_block_NF+0x3ea>
  802efa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efe:	0f 85 24 fe ff ff    	jne    802d28 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f09:	c9                   	leave  
  802f0a:	c3                   	ret    

00802f0b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f0b:	55                   	push   %ebp
  802f0c:	89 e5                	mov    %esp,%ebp
  802f0e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802f11:	a1 38 51 80 00       	mov    0x805138,%eax
  802f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802f19:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f1e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802f21:	a1 38 51 80 00       	mov    0x805138,%eax
  802f26:	85 c0                	test   %eax,%eax
  802f28:	74 14                	je     802f3e <insert_sorted_with_merge_freeList+0x33>
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	8b 50 08             	mov    0x8(%eax),%edx
  802f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f33:	8b 40 08             	mov    0x8(%eax),%eax
  802f36:	39 c2                	cmp    %eax,%edx
  802f38:	0f 87 9b 01 00 00    	ja     8030d9 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f42:	75 17                	jne    802f5b <insert_sorted_with_merge_freeList+0x50>
  802f44:	83 ec 04             	sub    $0x4,%esp
  802f47:	68 98 40 80 00       	push   $0x804098
  802f4c:	68 38 01 00 00       	push   $0x138
  802f51:	68 bb 40 80 00       	push   $0x8040bb
  802f56:	e8 97 d5 ff ff       	call   8004f2 <_panic>
  802f5b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	89 10                	mov    %edx,(%eax)
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	8b 00                	mov    (%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 0d                	je     802f7c <insert_sorted_with_merge_freeList+0x71>
  802f6f:	a1 38 51 80 00       	mov    0x805138,%eax
  802f74:	8b 55 08             	mov    0x8(%ebp),%edx
  802f77:	89 50 04             	mov    %edx,0x4(%eax)
  802f7a:	eb 08                	jmp    802f84 <insert_sorted_with_merge_freeList+0x79>
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	a3 38 51 80 00       	mov    %eax,0x805138
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f96:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9b:	40                   	inc    %eax
  802f9c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fa1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fa5:	0f 84 a8 06 00 00    	je     803653 <insert_sorted_with_merge_freeList+0x748>
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	8b 50 08             	mov    0x8(%eax),%edx
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb7:	01 c2                	add    %eax,%edx
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	8b 40 08             	mov    0x8(%eax),%eax
  802fbf:	39 c2                	cmp    %eax,%edx
  802fc1:	0f 85 8c 06 00 00    	jne    803653 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	8b 50 0c             	mov    0xc(%eax),%edx
  802fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd3:	01 c2                	add    %eax,%edx
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802fdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fdf:	75 17                	jne    802ff8 <insert_sorted_with_merge_freeList+0xed>
  802fe1:	83 ec 04             	sub    $0x4,%esp
  802fe4:	68 64 41 80 00       	push   $0x804164
  802fe9:	68 3c 01 00 00       	push   $0x13c
  802fee:	68 bb 40 80 00       	push   $0x8040bb
  802ff3:	e8 fa d4 ff ff       	call   8004f2 <_panic>
  802ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 10                	je     803011 <insert_sorted_with_merge_freeList+0x106>
  803001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803009:	8b 52 04             	mov    0x4(%edx),%edx
  80300c:	89 50 04             	mov    %edx,0x4(%eax)
  80300f:	eb 0b                	jmp    80301c <insert_sorted_with_merge_freeList+0x111>
  803011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803014:	8b 40 04             	mov    0x4(%eax),%eax
  803017:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80301c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301f:	8b 40 04             	mov    0x4(%eax),%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 0f                	je     803035 <insert_sorted_with_merge_freeList+0x12a>
  803026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803029:	8b 40 04             	mov    0x4(%eax),%eax
  80302c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80302f:	8b 12                	mov    (%edx),%edx
  803031:	89 10                	mov    %edx,(%eax)
  803033:	eb 0a                	jmp    80303f <insert_sorted_with_merge_freeList+0x134>
  803035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	a3 38 51 80 00       	mov    %eax,0x805138
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803052:	a1 44 51 80 00       	mov    0x805144,%eax
  803057:	48                   	dec    %eax
  803058:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80305d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803060:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803071:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803075:	75 17                	jne    80308e <insert_sorted_with_merge_freeList+0x183>
  803077:	83 ec 04             	sub    $0x4,%esp
  80307a:	68 98 40 80 00       	push   $0x804098
  80307f:	68 3f 01 00 00       	push   $0x13f
  803084:	68 bb 40 80 00       	push   $0x8040bb
  803089:	e8 64 d4 ff ff       	call   8004f2 <_panic>
  80308e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803097:	89 10                	mov    %edx,(%eax)
  803099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 0d                	je     8030af <insert_sorted_with_merge_freeList+0x1a4>
  8030a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8030a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030aa:	89 50 04             	mov    %edx,0x4(%eax)
  8030ad:	eb 08                	jmp    8030b7 <insert_sorted_with_merge_freeList+0x1ac>
  8030af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ba:	a3 48 51 80 00       	mov    %eax,0x805148
  8030bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ce:	40                   	inc    %eax
  8030cf:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030d4:	e9 7a 05 00 00       	jmp    803653 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	8b 50 08             	mov    0x8(%eax),%edx
  8030df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e2:	8b 40 08             	mov    0x8(%eax),%eax
  8030e5:	39 c2                	cmp    %eax,%edx
  8030e7:	0f 82 14 01 00 00    	jb     803201 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8030ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f0:	8b 50 08             	mov    0x8(%eax),%edx
  8030f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f9:	01 c2                	add    %eax,%edx
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	8b 40 08             	mov    0x8(%eax),%eax
  803101:	39 c2                	cmp    %eax,%edx
  803103:	0f 85 90 00 00 00    	jne    803199 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310c:	8b 50 0c             	mov    0xc(%eax),%edx
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	8b 40 0c             	mov    0xc(%eax),%eax
  803115:	01 c2                	add    %eax,%edx
  803117:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803131:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803135:	75 17                	jne    80314e <insert_sorted_with_merge_freeList+0x243>
  803137:	83 ec 04             	sub    $0x4,%esp
  80313a:	68 98 40 80 00       	push   $0x804098
  80313f:	68 49 01 00 00       	push   $0x149
  803144:	68 bb 40 80 00       	push   $0x8040bb
  803149:	e8 a4 d3 ff ff       	call   8004f2 <_panic>
  80314e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	89 10                	mov    %edx,(%eax)
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	85 c0                	test   %eax,%eax
  803160:	74 0d                	je     80316f <insert_sorted_with_merge_freeList+0x264>
  803162:	a1 48 51 80 00       	mov    0x805148,%eax
  803167:	8b 55 08             	mov    0x8(%ebp),%edx
  80316a:	89 50 04             	mov    %edx,0x4(%eax)
  80316d:	eb 08                	jmp    803177 <insert_sorted_with_merge_freeList+0x26c>
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	a3 48 51 80 00       	mov    %eax,0x805148
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803189:	a1 54 51 80 00       	mov    0x805154,%eax
  80318e:	40                   	inc    %eax
  80318f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803194:	e9 bb 04 00 00       	jmp    803654 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803199:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319d:	75 17                	jne    8031b6 <insert_sorted_with_merge_freeList+0x2ab>
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	68 0c 41 80 00       	push   $0x80410c
  8031a7:	68 4c 01 00 00       	push   $0x14c
  8031ac:	68 bb 40 80 00       	push   $0x8040bb
  8031b1:	e8 3c d3 ff ff       	call   8004f2 <_panic>
  8031b6:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	89 50 04             	mov    %edx,0x4(%eax)
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	8b 40 04             	mov    0x4(%eax),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	74 0c                	je     8031d8 <insert_sorted_with_merge_freeList+0x2cd>
  8031cc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d4:	89 10                	mov    %edx,(%eax)
  8031d6:	eb 08                	jmp    8031e0 <insert_sorted_with_merge_freeList+0x2d5>
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	a3 38 51 80 00       	mov    %eax,0x805138
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f1:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f6:	40                   	inc    %eax
  8031f7:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031fc:	e9 53 04 00 00       	jmp    803654 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803201:	a1 38 51 80 00       	mov    0x805138,%eax
  803206:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803209:	e9 15 04 00 00       	jmp    803623 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	8b 00                	mov    (%eax),%eax
  803213:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	8b 50 08             	mov    0x8(%eax),%edx
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	8b 40 08             	mov    0x8(%eax),%eax
  803222:	39 c2                	cmp    %eax,%edx
  803224:	0f 86 f1 03 00 00    	jbe    80361b <insert_sorted_with_merge_freeList+0x710>
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	8b 50 08             	mov    0x8(%eax),%edx
  803230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803233:	8b 40 08             	mov    0x8(%eax),%eax
  803236:	39 c2                	cmp    %eax,%edx
  803238:	0f 83 dd 03 00 00    	jae    80361b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	8b 50 08             	mov    0x8(%eax),%edx
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	01 c2                	add    %eax,%edx
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	8b 40 08             	mov    0x8(%eax),%eax
  803252:	39 c2                	cmp    %eax,%edx
  803254:	0f 85 b9 01 00 00    	jne    803413 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	8b 50 08             	mov    0x8(%eax),%edx
  803260:	8b 45 08             	mov    0x8(%ebp),%eax
  803263:	8b 40 0c             	mov    0xc(%eax),%eax
  803266:	01 c2                	add    %eax,%edx
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	8b 40 08             	mov    0x8(%eax),%eax
  80326e:	39 c2                	cmp    %eax,%edx
  803270:	0f 85 0d 01 00 00    	jne    803383 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	8b 50 0c             	mov    0xc(%eax),%edx
  80327c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327f:	8b 40 0c             	mov    0xc(%eax),%eax
  803282:	01 c2                	add    %eax,%edx
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80328a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80328e:	75 17                	jne    8032a7 <insert_sorted_with_merge_freeList+0x39c>
  803290:	83 ec 04             	sub    $0x4,%esp
  803293:	68 64 41 80 00       	push   $0x804164
  803298:	68 5c 01 00 00       	push   $0x15c
  80329d:	68 bb 40 80 00       	push   $0x8040bb
  8032a2:	e8 4b d2 ff ff       	call   8004f2 <_panic>
  8032a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032aa:	8b 00                	mov    (%eax),%eax
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	74 10                	je     8032c0 <insert_sorted_with_merge_freeList+0x3b5>
  8032b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b8:	8b 52 04             	mov    0x4(%edx),%edx
  8032bb:	89 50 04             	mov    %edx,0x4(%eax)
  8032be:	eb 0b                	jmp    8032cb <insert_sorted_with_merge_freeList+0x3c0>
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	8b 40 04             	mov    0x4(%eax),%eax
  8032c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ce:	8b 40 04             	mov    0x4(%eax),%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	74 0f                	je     8032e4 <insert_sorted_with_merge_freeList+0x3d9>
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	8b 40 04             	mov    0x4(%eax),%eax
  8032db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032de:	8b 12                	mov    (%edx),%edx
  8032e0:	89 10                	mov    %edx,(%eax)
  8032e2:	eb 0a                	jmp    8032ee <insert_sorted_with_merge_freeList+0x3e3>
  8032e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803301:	a1 44 51 80 00       	mov    0x805144,%eax
  803306:	48                   	dec    %eax
  803307:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80330c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803316:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803319:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803320:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803324:	75 17                	jne    80333d <insert_sorted_with_merge_freeList+0x432>
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	68 98 40 80 00       	push   $0x804098
  80332e:	68 5f 01 00 00       	push   $0x15f
  803333:	68 bb 40 80 00       	push   $0x8040bb
  803338:	e8 b5 d1 ff ff       	call   8004f2 <_panic>
  80333d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803346:	89 10                	mov    %edx,(%eax)
  803348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	85 c0                	test   %eax,%eax
  80334f:	74 0d                	je     80335e <insert_sorted_with_merge_freeList+0x453>
  803351:	a1 48 51 80 00       	mov    0x805148,%eax
  803356:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803359:	89 50 04             	mov    %edx,0x4(%eax)
  80335c:	eb 08                	jmp    803366 <insert_sorted_with_merge_freeList+0x45b>
  80335e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803361:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803369:	a3 48 51 80 00       	mov    %eax,0x805148
  80336e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803371:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803378:	a1 54 51 80 00       	mov    0x805154,%eax
  80337d:	40                   	inc    %eax
  80337e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803386:	8b 50 0c             	mov    0xc(%eax),%edx
  803389:	8b 45 08             	mov    0x8(%ebp),%eax
  80338c:	8b 40 0c             	mov    0xc(%eax),%eax
  80338f:	01 c2                	add    %eax,%edx
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033af:	75 17                	jne    8033c8 <insert_sorted_with_merge_freeList+0x4bd>
  8033b1:	83 ec 04             	sub    $0x4,%esp
  8033b4:	68 98 40 80 00       	push   $0x804098
  8033b9:	68 64 01 00 00       	push   $0x164
  8033be:	68 bb 40 80 00       	push   $0x8040bb
  8033c3:	e8 2a d1 ff ff       	call   8004f2 <_panic>
  8033c8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	89 10                	mov    %edx,(%eax)
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	8b 00                	mov    (%eax),%eax
  8033d8:	85 c0                	test   %eax,%eax
  8033da:	74 0d                	je     8033e9 <insert_sorted_with_merge_freeList+0x4de>
  8033dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e4:	89 50 04             	mov    %edx,0x4(%eax)
  8033e7:	eb 08                	jmp    8033f1 <insert_sorted_with_merge_freeList+0x4e6>
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	a3 48 51 80 00       	mov    %eax,0x805148
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803403:	a1 54 51 80 00       	mov    0x805154,%eax
  803408:	40                   	inc    %eax
  803409:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80340e:	e9 41 02 00 00       	jmp    803654 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	8b 50 08             	mov    0x8(%eax),%edx
  803419:	8b 45 08             	mov    0x8(%ebp),%eax
  80341c:	8b 40 0c             	mov    0xc(%eax),%eax
  80341f:	01 c2                	add    %eax,%edx
  803421:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803424:	8b 40 08             	mov    0x8(%eax),%eax
  803427:	39 c2                	cmp    %eax,%edx
  803429:	0f 85 7c 01 00 00    	jne    8035ab <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80342f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803433:	74 06                	je     80343b <insert_sorted_with_merge_freeList+0x530>
  803435:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803439:	75 17                	jne    803452 <insert_sorted_with_merge_freeList+0x547>
  80343b:	83 ec 04             	sub    $0x4,%esp
  80343e:	68 d4 40 80 00       	push   $0x8040d4
  803443:	68 69 01 00 00       	push   $0x169
  803448:	68 bb 40 80 00       	push   $0x8040bb
  80344d:	e8 a0 d0 ff ff       	call   8004f2 <_panic>
  803452:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803455:	8b 50 04             	mov    0x4(%eax),%edx
  803458:	8b 45 08             	mov    0x8(%ebp),%eax
  80345b:	89 50 04             	mov    %edx,0x4(%eax)
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803464:	89 10                	mov    %edx,(%eax)
  803466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803469:	8b 40 04             	mov    0x4(%eax),%eax
  80346c:	85 c0                	test   %eax,%eax
  80346e:	74 0d                	je     80347d <insert_sorted_with_merge_freeList+0x572>
  803470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803473:	8b 40 04             	mov    0x4(%eax),%eax
  803476:	8b 55 08             	mov    0x8(%ebp),%edx
  803479:	89 10                	mov    %edx,(%eax)
  80347b:	eb 08                	jmp    803485 <insert_sorted_with_merge_freeList+0x57a>
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	a3 38 51 80 00       	mov    %eax,0x805138
  803485:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803488:	8b 55 08             	mov    0x8(%ebp),%edx
  80348b:	89 50 04             	mov    %edx,0x4(%eax)
  80348e:	a1 44 51 80 00       	mov    0x805144,%eax
  803493:	40                   	inc    %eax
  803494:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	8b 50 0c             	mov    0xc(%eax),%edx
  80349f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a5:	01 c2                	add    %eax,%edx
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8034ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034b1:	75 17                	jne    8034ca <insert_sorted_with_merge_freeList+0x5bf>
  8034b3:	83 ec 04             	sub    $0x4,%esp
  8034b6:	68 64 41 80 00       	push   $0x804164
  8034bb:	68 6b 01 00 00       	push   $0x16b
  8034c0:	68 bb 40 80 00       	push   $0x8040bb
  8034c5:	e8 28 d0 ff ff       	call   8004f2 <_panic>
  8034ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cd:	8b 00                	mov    (%eax),%eax
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	74 10                	je     8034e3 <insert_sorted_with_merge_freeList+0x5d8>
  8034d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034db:	8b 52 04             	mov    0x4(%edx),%edx
  8034de:	89 50 04             	mov    %edx,0x4(%eax)
  8034e1:	eb 0b                	jmp    8034ee <insert_sorted_with_merge_freeList+0x5e3>
  8034e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e6:	8b 40 04             	mov    0x4(%eax),%eax
  8034e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f1:	8b 40 04             	mov    0x4(%eax),%eax
  8034f4:	85 c0                	test   %eax,%eax
  8034f6:	74 0f                	je     803507 <insert_sorted_with_merge_freeList+0x5fc>
  8034f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fb:	8b 40 04             	mov    0x4(%eax),%eax
  8034fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803501:	8b 12                	mov    (%edx),%edx
  803503:	89 10                	mov    %edx,(%eax)
  803505:	eb 0a                	jmp    803511 <insert_sorted_with_merge_freeList+0x606>
  803507:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350a:	8b 00                	mov    (%eax),%eax
  80350c:	a3 38 51 80 00       	mov    %eax,0x805138
  803511:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803514:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803524:	a1 44 51 80 00       	mov    0x805144,%eax
  803529:	48                   	dec    %eax
  80352a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80352f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803532:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803539:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803543:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803547:	75 17                	jne    803560 <insert_sorted_with_merge_freeList+0x655>
  803549:	83 ec 04             	sub    $0x4,%esp
  80354c:	68 98 40 80 00       	push   $0x804098
  803551:	68 6e 01 00 00       	push   $0x16e
  803556:	68 bb 40 80 00       	push   $0x8040bb
  80355b:	e8 92 cf ff ff       	call   8004f2 <_panic>
  803560:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803566:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803569:	89 10                	mov    %edx,(%eax)
  80356b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	85 c0                	test   %eax,%eax
  803572:	74 0d                	je     803581 <insert_sorted_with_merge_freeList+0x676>
  803574:	a1 48 51 80 00       	mov    0x805148,%eax
  803579:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80357c:	89 50 04             	mov    %edx,0x4(%eax)
  80357f:	eb 08                	jmp    803589 <insert_sorted_with_merge_freeList+0x67e>
  803581:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803584:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803589:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358c:	a3 48 51 80 00       	mov    %eax,0x805148
  803591:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803594:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359b:	a1 54 51 80 00       	mov    0x805154,%eax
  8035a0:	40                   	inc    %eax
  8035a1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035a6:	e9 a9 00 00 00       	jmp    803654 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8035ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035af:	74 06                	je     8035b7 <insert_sorted_with_merge_freeList+0x6ac>
  8035b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b5:	75 17                	jne    8035ce <insert_sorted_with_merge_freeList+0x6c3>
  8035b7:	83 ec 04             	sub    $0x4,%esp
  8035ba:	68 30 41 80 00       	push   $0x804130
  8035bf:	68 73 01 00 00       	push   $0x173
  8035c4:	68 bb 40 80 00       	push   $0x8040bb
  8035c9:	e8 24 cf ff ff       	call   8004f2 <_panic>
  8035ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d1:	8b 10                	mov    (%eax),%edx
  8035d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d6:	89 10                	mov    %edx,(%eax)
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035db:	8b 00                	mov    (%eax),%eax
  8035dd:	85 c0                	test   %eax,%eax
  8035df:	74 0b                	je     8035ec <insert_sorted_with_merge_freeList+0x6e1>
  8035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e4:	8b 00                	mov    (%eax),%eax
  8035e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e9:	89 50 04             	mov    %edx,0x4(%eax)
  8035ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8035f2:	89 10                	mov    %edx,(%eax)
  8035f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035fa:	89 50 04             	mov    %edx,0x4(%eax)
  8035fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803600:	8b 00                	mov    (%eax),%eax
  803602:	85 c0                	test   %eax,%eax
  803604:	75 08                	jne    80360e <insert_sorted_with_merge_freeList+0x703>
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80360e:	a1 44 51 80 00       	mov    0x805144,%eax
  803613:	40                   	inc    %eax
  803614:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803619:	eb 39                	jmp    803654 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80361b:	a1 40 51 80 00       	mov    0x805140,%eax
  803620:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803623:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803627:	74 07                	je     803630 <insert_sorted_with_merge_freeList+0x725>
  803629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362c:	8b 00                	mov    (%eax),%eax
  80362e:	eb 05                	jmp    803635 <insert_sorted_with_merge_freeList+0x72a>
  803630:	b8 00 00 00 00       	mov    $0x0,%eax
  803635:	a3 40 51 80 00       	mov    %eax,0x805140
  80363a:	a1 40 51 80 00       	mov    0x805140,%eax
  80363f:	85 c0                	test   %eax,%eax
  803641:	0f 85 c7 fb ff ff    	jne    80320e <insert_sorted_with_merge_freeList+0x303>
  803647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364b:	0f 85 bd fb ff ff    	jne    80320e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803651:	eb 01                	jmp    803654 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803653:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803654:	90                   	nop
  803655:	c9                   	leave  
  803656:	c3                   	ret    
  803657:	90                   	nop

00803658 <__udivdi3>:
  803658:	55                   	push   %ebp
  803659:	57                   	push   %edi
  80365a:	56                   	push   %esi
  80365b:	53                   	push   %ebx
  80365c:	83 ec 1c             	sub    $0x1c,%esp
  80365f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803663:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803667:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80366b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80366f:	89 ca                	mov    %ecx,%edx
  803671:	89 f8                	mov    %edi,%eax
  803673:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803677:	85 f6                	test   %esi,%esi
  803679:	75 2d                	jne    8036a8 <__udivdi3+0x50>
  80367b:	39 cf                	cmp    %ecx,%edi
  80367d:	77 65                	ja     8036e4 <__udivdi3+0x8c>
  80367f:	89 fd                	mov    %edi,%ebp
  803681:	85 ff                	test   %edi,%edi
  803683:	75 0b                	jne    803690 <__udivdi3+0x38>
  803685:	b8 01 00 00 00       	mov    $0x1,%eax
  80368a:	31 d2                	xor    %edx,%edx
  80368c:	f7 f7                	div    %edi
  80368e:	89 c5                	mov    %eax,%ebp
  803690:	31 d2                	xor    %edx,%edx
  803692:	89 c8                	mov    %ecx,%eax
  803694:	f7 f5                	div    %ebp
  803696:	89 c1                	mov    %eax,%ecx
  803698:	89 d8                	mov    %ebx,%eax
  80369a:	f7 f5                	div    %ebp
  80369c:	89 cf                	mov    %ecx,%edi
  80369e:	89 fa                	mov    %edi,%edx
  8036a0:	83 c4 1c             	add    $0x1c,%esp
  8036a3:	5b                   	pop    %ebx
  8036a4:	5e                   	pop    %esi
  8036a5:	5f                   	pop    %edi
  8036a6:	5d                   	pop    %ebp
  8036a7:	c3                   	ret    
  8036a8:	39 ce                	cmp    %ecx,%esi
  8036aa:	77 28                	ja     8036d4 <__udivdi3+0x7c>
  8036ac:	0f bd fe             	bsr    %esi,%edi
  8036af:	83 f7 1f             	xor    $0x1f,%edi
  8036b2:	75 40                	jne    8036f4 <__udivdi3+0x9c>
  8036b4:	39 ce                	cmp    %ecx,%esi
  8036b6:	72 0a                	jb     8036c2 <__udivdi3+0x6a>
  8036b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036bc:	0f 87 9e 00 00 00    	ja     803760 <__udivdi3+0x108>
  8036c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8036c7:	89 fa                	mov    %edi,%edx
  8036c9:	83 c4 1c             	add    $0x1c,%esp
  8036cc:	5b                   	pop    %ebx
  8036cd:	5e                   	pop    %esi
  8036ce:	5f                   	pop    %edi
  8036cf:	5d                   	pop    %ebp
  8036d0:	c3                   	ret    
  8036d1:	8d 76 00             	lea    0x0(%esi),%esi
  8036d4:	31 ff                	xor    %edi,%edi
  8036d6:	31 c0                	xor    %eax,%eax
  8036d8:	89 fa                	mov    %edi,%edx
  8036da:	83 c4 1c             	add    $0x1c,%esp
  8036dd:	5b                   	pop    %ebx
  8036de:	5e                   	pop    %esi
  8036df:	5f                   	pop    %edi
  8036e0:	5d                   	pop    %ebp
  8036e1:	c3                   	ret    
  8036e2:	66 90                	xchg   %ax,%ax
  8036e4:	89 d8                	mov    %ebx,%eax
  8036e6:	f7 f7                	div    %edi
  8036e8:	31 ff                	xor    %edi,%edi
  8036ea:	89 fa                	mov    %edi,%edx
  8036ec:	83 c4 1c             	add    $0x1c,%esp
  8036ef:	5b                   	pop    %ebx
  8036f0:	5e                   	pop    %esi
  8036f1:	5f                   	pop    %edi
  8036f2:	5d                   	pop    %ebp
  8036f3:	c3                   	ret    
  8036f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036f9:	89 eb                	mov    %ebp,%ebx
  8036fb:	29 fb                	sub    %edi,%ebx
  8036fd:	89 f9                	mov    %edi,%ecx
  8036ff:	d3 e6                	shl    %cl,%esi
  803701:	89 c5                	mov    %eax,%ebp
  803703:	88 d9                	mov    %bl,%cl
  803705:	d3 ed                	shr    %cl,%ebp
  803707:	89 e9                	mov    %ebp,%ecx
  803709:	09 f1                	or     %esi,%ecx
  80370b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80370f:	89 f9                	mov    %edi,%ecx
  803711:	d3 e0                	shl    %cl,%eax
  803713:	89 c5                	mov    %eax,%ebp
  803715:	89 d6                	mov    %edx,%esi
  803717:	88 d9                	mov    %bl,%cl
  803719:	d3 ee                	shr    %cl,%esi
  80371b:	89 f9                	mov    %edi,%ecx
  80371d:	d3 e2                	shl    %cl,%edx
  80371f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803723:	88 d9                	mov    %bl,%cl
  803725:	d3 e8                	shr    %cl,%eax
  803727:	09 c2                	or     %eax,%edx
  803729:	89 d0                	mov    %edx,%eax
  80372b:	89 f2                	mov    %esi,%edx
  80372d:	f7 74 24 0c          	divl   0xc(%esp)
  803731:	89 d6                	mov    %edx,%esi
  803733:	89 c3                	mov    %eax,%ebx
  803735:	f7 e5                	mul    %ebp
  803737:	39 d6                	cmp    %edx,%esi
  803739:	72 19                	jb     803754 <__udivdi3+0xfc>
  80373b:	74 0b                	je     803748 <__udivdi3+0xf0>
  80373d:	89 d8                	mov    %ebx,%eax
  80373f:	31 ff                	xor    %edi,%edi
  803741:	e9 58 ff ff ff       	jmp    80369e <__udivdi3+0x46>
  803746:	66 90                	xchg   %ax,%ax
  803748:	8b 54 24 08          	mov    0x8(%esp),%edx
  80374c:	89 f9                	mov    %edi,%ecx
  80374e:	d3 e2                	shl    %cl,%edx
  803750:	39 c2                	cmp    %eax,%edx
  803752:	73 e9                	jae    80373d <__udivdi3+0xe5>
  803754:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803757:	31 ff                	xor    %edi,%edi
  803759:	e9 40 ff ff ff       	jmp    80369e <__udivdi3+0x46>
  80375e:	66 90                	xchg   %ax,%ax
  803760:	31 c0                	xor    %eax,%eax
  803762:	e9 37 ff ff ff       	jmp    80369e <__udivdi3+0x46>
  803767:	90                   	nop

00803768 <__umoddi3>:
  803768:	55                   	push   %ebp
  803769:	57                   	push   %edi
  80376a:	56                   	push   %esi
  80376b:	53                   	push   %ebx
  80376c:	83 ec 1c             	sub    $0x1c,%esp
  80376f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803773:	8b 74 24 34          	mov    0x34(%esp),%esi
  803777:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80377b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80377f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803783:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803787:	89 f3                	mov    %esi,%ebx
  803789:	89 fa                	mov    %edi,%edx
  80378b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80378f:	89 34 24             	mov    %esi,(%esp)
  803792:	85 c0                	test   %eax,%eax
  803794:	75 1a                	jne    8037b0 <__umoddi3+0x48>
  803796:	39 f7                	cmp    %esi,%edi
  803798:	0f 86 a2 00 00 00    	jbe    803840 <__umoddi3+0xd8>
  80379e:	89 c8                	mov    %ecx,%eax
  8037a0:	89 f2                	mov    %esi,%edx
  8037a2:	f7 f7                	div    %edi
  8037a4:	89 d0                	mov    %edx,%eax
  8037a6:	31 d2                	xor    %edx,%edx
  8037a8:	83 c4 1c             	add    $0x1c,%esp
  8037ab:	5b                   	pop    %ebx
  8037ac:	5e                   	pop    %esi
  8037ad:	5f                   	pop    %edi
  8037ae:	5d                   	pop    %ebp
  8037af:	c3                   	ret    
  8037b0:	39 f0                	cmp    %esi,%eax
  8037b2:	0f 87 ac 00 00 00    	ja     803864 <__umoddi3+0xfc>
  8037b8:	0f bd e8             	bsr    %eax,%ebp
  8037bb:	83 f5 1f             	xor    $0x1f,%ebp
  8037be:	0f 84 ac 00 00 00    	je     803870 <__umoddi3+0x108>
  8037c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8037c9:	29 ef                	sub    %ebp,%edi
  8037cb:	89 fe                	mov    %edi,%esi
  8037cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037d1:	89 e9                	mov    %ebp,%ecx
  8037d3:	d3 e0                	shl    %cl,%eax
  8037d5:	89 d7                	mov    %edx,%edi
  8037d7:	89 f1                	mov    %esi,%ecx
  8037d9:	d3 ef                	shr    %cl,%edi
  8037db:	09 c7                	or     %eax,%edi
  8037dd:	89 e9                	mov    %ebp,%ecx
  8037df:	d3 e2                	shl    %cl,%edx
  8037e1:	89 14 24             	mov    %edx,(%esp)
  8037e4:	89 d8                	mov    %ebx,%eax
  8037e6:	d3 e0                	shl    %cl,%eax
  8037e8:	89 c2                	mov    %eax,%edx
  8037ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037ee:	d3 e0                	shl    %cl,%eax
  8037f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037f8:	89 f1                	mov    %esi,%ecx
  8037fa:	d3 e8                	shr    %cl,%eax
  8037fc:	09 d0                	or     %edx,%eax
  8037fe:	d3 eb                	shr    %cl,%ebx
  803800:	89 da                	mov    %ebx,%edx
  803802:	f7 f7                	div    %edi
  803804:	89 d3                	mov    %edx,%ebx
  803806:	f7 24 24             	mull   (%esp)
  803809:	89 c6                	mov    %eax,%esi
  80380b:	89 d1                	mov    %edx,%ecx
  80380d:	39 d3                	cmp    %edx,%ebx
  80380f:	0f 82 87 00 00 00    	jb     80389c <__umoddi3+0x134>
  803815:	0f 84 91 00 00 00    	je     8038ac <__umoddi3+0x144>
  80381b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80381f:	29 f2                	sub    %esi,%edx
  803821:	19 cb                	sbb    %ecx,%ebx
  803823:	89 d8                	mov    %ebx,%eax
  803825:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803829:	d3 e0                	shl    %cl,%eax
  80382b:	89 e9                	mov    %ebp,%ecx
  80382d:	d3 ea                	shr    %cl,%edx
  80382f:	09 d0                	or     %edx,%eax
  803831:	89 e9                	mov    %ebp,%ecx
  803833:	d3 eb                	shr    %cl,%ebx
  803835:	89 da                	mov    %ebx,%edx
  803837:	83 c4 1c             	add    $0x1c,%esp
  80383a:	5b                   	pop    %ebx
  80383b:	5e                   	pop    %esi
  80383c:	5f                   	pop    %edi
  80383d:	5d                   	pop    %ebp
  80383e:	c3                   	ret    
  80383f:	90                   	nop
  803840:	89 fd                	mov    %edi,%ebp
  803842:	85 ff                	test   %edi,%edi
  803844:	75 0b                	jne    803851 <__umoddi3+0xe9>
  803846:	b8 01 00 00 00       	mov    $0x1,%eax
  80384b:	31 d2                	xor    %edx,%edx
  80384d:	f7 f7                	div    %edi
  80384f:	89 c5                	mov    %eax,%ebp
  803851:	89 f0                	mov    %esi,%eax
  803853:	31 d2                	xor    %edx,%edx
  803855:	f7 f5                	div    %ebp
  803857:	89 c8                	mov    %ecx,%eax
  803859:	f7 f5                	div    %ebp
  80385b:	89 d0                	mov    %edx,%eax
  80385d:	e9 44 ff ff ff       	jmp    8037a6 <__umoddi3+0x3e>
  803862:	66 90                	xchg   %ax,%ax
  803864:	89 c8                	mov    %ecx,%eax
  803866:	89 f2                	mov    %esi,%edx
  803868:	83 c4 1c             	add    $0x1c,%esp
  80386b:	5b                   	pop    %ebx
  80386c:	5e                   	pop    %esi
  80386d:	5f                   	pop    %edi
  80386e:	5d                   	pop    %ebp
  80386f:	c3                   	ret    
  803870:	3b 04 24             	cmp    (%esp),%eax
  803873:	72 06                	jb     80387b <__umoddi3+0x113>
  803875:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803879:	77 0f                	ja     80388a <__umoddi3+0x122>
  80387b:	89 f2                	mov    %esi,%edx
  80387d:	29 f9                	sub    %edi,%ecx
  80387f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803883:	89 14 24             	mov    %edx,(%esp)
  803886:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80388a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80388e:	8b 14 24             	mov    (%esp),%edx
  803891:	83 c4 1c             	add    $0x1c,%esp
  803894:	5b                   	pop    %ebx
  803895:	5e                   	pop    %esi
  803896:	5f                   	pop    %edi
  803897:	5d                   	pop    %ebp
  803898:	c3                   	ret    
  803899:	8d 76 00             	lea    0x0(%esi),%esi
  80389c:	2b 04 24             	sub    (%esp),%eax
  80389f:	19 fa                	sbb    %edi,%edx
  8038a1:	89 d1                	mov    %edx,%ecx
  8038a3:	89 c6                	mov    %eax,%esi
  8038a5:	e9 71 ff ff ff       	jmp    80381b <__umoddi3+0xb3>
  8038aa:	66 90                	xchg   %ax,%ax
  8038ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038b0:	72 ea                	jb     80389c <__umoddi3+0x134>
  8038b2:	89 d9                	mov    %ebx,%ecx
  8038b4:	e9 62 ff ff ff       	jmp    80381b <__umoddi3+0xb3>
