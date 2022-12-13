
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 e7 05 00 00       	call   80061d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
	int parentenvID = sys_getparentenvid();
  800044:	e8 1a 1f 00 00       	call   801f63 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb d5 3a 80 00       	mov    $0x803ad5,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb df 3a 80 00       	mov    $0x803adf,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb eb 3a 80 00       	mov    $0x803aeb,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb fa 3a 80 00       	mov    $0x803afa,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 09 3b 80 00       	mov    $0x803b09,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 1e 3b 80 00       	mov    $0x803b1e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 33 3b 80 00       	mov    $0x803b33,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 44 3b 80 00       	mov    $0x803b44,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 55 3b 80 00       	mov    $0x803b55,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 66 3b 80 00       	mov    $0x803b66,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 6f 3b 80 00       	mov    $0x803b6f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 79 3b 80 00       	mov    $0x803b79,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 84 3b 80 00       	mov    $0x803b84,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 90 3b 80 00       	mov    $0x803b90,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 9a 3b 80 00       	mov    $0x803b9a,%ebx
  80019b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001a0:	89 c7                	mov    %eax,%edi
  8001a2:	89 de                	mov    %ebx,%esi
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a8:	c7 85 e3 fe ff ff 63 	movl   $0x72656c63,-0x11d(%ebp)
  8001af:	6c 65 72 
  8001b2:	66 c7 85 e7 fe ff ff 	movw   $0x6b,-0x119(%ebp)
  8001b9:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001bb:	8d 85 d5 fe ff ff    	lea    -0x12b(%ebp),%eax
  8001c1:	bb a4 3b 80 00       	mov    $0x803ba4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb b2 3b 80 00       	mov    $0x803bb2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb c1 3b 80 00       	mov    $0x803bc1,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb c8 3b 80 00       	mov    $0x803bc8,%ebx
  80020e:	ba 07 00 00 00       	mov    $0x7,%edx
  800213:	89 c7                	mov    %eax,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	89 d1                	mov    %edx,%ecx
  800219:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	8d 45 ae             	lea    -0x52(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	e8 9c 18 00 00       	call   801ac6 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 87 18 00 00       	call   801ac6 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 72 18 00 00       	call   801ac6 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 5a 18 00 00       	call   801ac6 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 42 18 00 00       	call   801ac6 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 2a 18 00 00       	call   801ac6 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 12 18 00 00       	call   801ac6 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 fa 17 00 00       	call   801ac6 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 e2 17 00 00       	call   801ac6 <sget>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 c0             	mov    %eax,-0x40(%ebp)

	while(1==1)
	{
		int custId;
		//wait for a customer
		sys_waitSemaphore(parentenvID, _cust_ready);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f7:	e8 08 1b 00 00       	call   801e04 <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 f3 1a 00 00       	call   801e04 <sys_waitSemaphore>
  800311:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  800314:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800320:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800323:	01 d0                	add    %edx,%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	89 45 bc             	mov    %eax,-0x44(%ebp)
			*queue_out = *queue_out +1;
  80032a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80032d:	8b 00                	mov    (%eax),%eax
  80032f:	8d 50 01             	lea    0x1(%eax),%edx
  800332:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800335:	89 10                	mov    %edx,(%eax)
		}
		sys_signalSemaphore(parentenvID, _custQueueCS);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800340:	50                   	push   %eax
  800341:	ff 75 e4             	pushl  -0x1c(%ebp)
  800344:	e8 d9 1a 00 00       	call   801e22 <sys_signalSemaphore>
  800349:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80034c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  800360:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800363:	83 f8 02             	cmp    $0x2,%eax
  800366:	0f 84 90 00 00 00    	je     8003fc <_main+0x3c4>
  80036c:	83 f8 03             	cmp    $0x3,%eax
  80036f:	0f 84 05 01 00 00    	je     80047a <_main+0x442>
  800375:	83 f8 01             	cmp    $0x1,%eax
  800378:	0f 85 f8 01 00 00    	jne    800576 <_main+0x53e>
		{
		case 1:
		{
			//Check and update Flight1
			sys_waitSemaphore(parentenvID, _flight1CS);
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800387:	50                   	push   %eax
  800388:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038b:	e8 74 1a 00 00       	call   801e04 <sys_waitSemaphore>
  800390:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  800393:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	7e 46                	jle    8003e2 <_main+0x3aa>
				{
					*flight1Counter = *flight1Counter - 1;
  80039c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8003a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a7:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8003a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8003bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8003d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	8d 50 01             	lea    0x1(%eax),%edx
  8003dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e0:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight1CS);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  8003eb:	50                   	push   %eax
  8003ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ef:	e8 2e 1a 00 00       	call   801e22 <sys_signalSemaphore>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}

		break;
  8003f7:	e9 91 01 00 00       	jmp    80058d <_main+0x555>
		case 2:
		{
			//Check and update Flight2
			sys_waitSemaphore(parentenvID, _flight2CS);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800405:	50                   	push   %eax
  800406:	ff 75 e4             	pushl  -0x1c(%ebp)
  800409:	e8 f6 19 00 00       	call   801e04 <sys_waitSemaphore>
  80040e:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800411:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	85 c0                	test   %eax,%eax
  800418:	7e 46                	jle    800460 <_main+0x428>
				{
					*flight2Counter = *flight2Counter - 1;
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800422:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800427:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80042a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	01 d0                	add    %edx,%eax
  800436:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  80043d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044c:	01 c2                	add    %eax,%edx
  80044e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800451:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  800453:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 50 01             	lea    0x1(%eax),%edx
  80045b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80045e:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046d:	e8 b0 19 00 00       	call   801e22 <sys_signalSemaphore>
  800472:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800475:	e9 13 01 00 00       	jmp    80058d <_main+0x555>
		case 3:
		{
			//Check and update Both Flights
			sys_waitSemaphore(parentenvID, _flight1CS); sys_waitSemaphore(parentenvID, _flight2CS);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800483:	50                   	push   %eax
  800484:	ff 75 e4             	pushl  -0x1c(%ebp)
  800487:	e8 78 19 00 00       	call   801e04 <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 63 19 00 00       	call   801e04 <sys_waitSemaphore>
  8004a1:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	0f 8e 99 00 00 00    	jle    80054a <_main+0x512>
  8004b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	85 c0                	test   %eax,%eax
  8004b8:	0f 8e 8c 00 00 00    	jle    80054a <_main+0x512>
				{
					*flight1Counter = *flight1Counter - 1;
  8004be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f0:	01 c2                	add    %eax,%edx
  8004f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004f5:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 01             	lea    0x1(%eax),%edx
  8004ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80050c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800511:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800514:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800527:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800536:	01 c2                	add    %eax,%edx
  800538:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80053b:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80053d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800548:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS); sys_signalSemaphore(parentenvID, _flight1CS);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800553:	50                   	push   %eax
  800554:	ff 75 e4             	pushl  -0x1c(%ebp)
  800557:	e8 c6 18 00 00       	call   801e22 <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 b1 18 00 00       	call   801e22 <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 a0 3a 80 00       	push   $0x803aa0
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 c0 3a 80 00       	push   $0x803ac0
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb cf 3b 80 00       	mov    $0x803bcf,%ebx
  800598:	ba 0e 00 00 00       	mov    $0xe,%edx
  80059d:	89 c7                	mov    %eax,%edi
  80059f:	89 de                	mov    %ebx,%esi
  8005a1:	89 d1                	mov    %edx,%ecx
  8005a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a5:	8d 95 a8 fe ff ff    	lea    -0x158(%ebp),%edx
  8005ab:	b9 04 00 00 00       	mov    $0x4,%ecx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	89 d7                	mov    %edx,%edi
  8005b7:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8005c6:	e8 6a 0f 00 00       	call   801535 <ltostr>
  8005cb:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8005e5:	50                   	push   %eax
  8005e6:	e8 42 10 00 00       	call   80162d <strcconcat>
  8005eb:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore(parentenvID, sname);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005f7:	50                   	push   %eax
  8005f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005fb:	e8 22 18 00 00       	call   801e22 <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 0d 18 00 00       	call   801e22 <sys_signalSemaphore>
  800615:	83 c4 10             	add    $0x10,%esp
	}
  800618:	e9 cd fc ff ff       	jmp    8002ea <_main+0x2b2>

0080061d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800623:	e8 22 19 00 00       	call   801f4a <sys_getenvindex>
  800628:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	89 d0                	mov    %edx,%eax
  800630:	c1 e0 03             	shl    $0x3,%eax
  800633:	01 d0                	add    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800640:	01 d0                	add    %edx,%eax
  800642:	c1 e0 04             	shl    $0x4,%eax
  800645:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80064a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80064f:	a1 20 50 80 00       	mov    0x805020,%eax
  800654:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80065a:	84 c0                	test   %al,%al
  80065c:	74 0f                	je     80066d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80065e:	a1 20 50 80 00       	mov    0x805020,%eax
  800663:	05 5c 05 00 00       	add    $0x55c,%eax
  800668:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80066d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800671:	7e 0a                	jle    80067d <libmain+0x60>
		binaryname = argv[0];
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	ff 75 08             	pushl  0x8(%ebp)
  800686:	e8 ad f9 ff ff       	call   800038 <_main>
  80068b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80068e:	e8 c4 16 00 00       	call   801d57 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 08 3c 80 00       	push   $0x803c08
  80069b:	e8 6d 03 00 00       	call   800a0d <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	68 30 3c 80 00       	push   $0x803c30
  8006c3:	e8 45 03 00 00       	call   800a0d <cprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8006d0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006e6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006ec:	51                   	push   %ecx
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	68 58 3c 80 00       	push   $0x803c58
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 b0 3c 80 00       	push   $0x803cb0
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 08 3c 80 00       	push   $0x803c08
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 44 16 00 00       	call   801d71 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80072d:	e8 19 00 00 00       	call   80074b <exit>
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80073b:	83 ec 0c             	sub    $0xc,%esp
  80073e:	6a 00                	push   $0x0
  800740:	e8 d1 17 00 00       	call   801f16 <sys_destroy_env>
  800745:	83 c4 10             	add    $0x10,%esp
}
  800748:	90                   	nop
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <exit>:

void
exit(void)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800751:	e8 26 18 00 00       	call   801f7c <sys_exit_env>
}
  800756:	90                   	nop
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80075f:	8d 45 10             	lea    0x10(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800768:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80076d:	85 c0                	test   %eax,%eax
  80076f:	74 16                	je     800787 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800771:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 c4 3c 80 00       	push   $0x803cc4
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 c9 3c 80 00       	push   $0x803cc9
  800798:	e8 70 02 00 00       	call   800a0d <cprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a9:	50                   	push   %eax
  8007aa:	e8 f3 01 00 00       	call   8009a2 <vcprintf>
  8007af:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	6a 00                	push   $0x0
  8007b7:	68 e5 3c 80 00       	push   $0x803ce5
  8007bc:	e8 e1 01 00 00       	call   8009a2 <vcprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007c4:	e8 82 ff ff ff       	call   80074b <exit>

	// should not return here
	while (1) ;
  8007c9:	eb fe                	jmp    8007c9 <_panic+0x70>

008007cb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007d6:	8b 50 74             	mov    0x74(%eax),%edx
  8007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007dc:	39 c2                	cmp    %eax,%edx
  8007de:	74 14                	je     8007f4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e0:	83 ec 04             	sub    $0x4,%esp
  8007e3:	68 e8 3c 80 00       	push   $0x803ce8
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 34 3d 80 00       	push   $0x803d34
  8007ef:	e8 65 ff ff ff       	call   800759 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800802:	e9 c2 00 00 00       	jmp    8008c9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	01 d0                	add    %edx,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	85 c0                	test   %eax,%eax
  80081a:	75 08                	jne    800824 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80081c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80081f:	e9 a2 00 00 00       	jmp    8008c6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800824:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80082b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800832:	eb 69                	jmp    80089d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80083f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800842:	89 d0                	mov    %edx,%eax
  800844:	01 c0                	add    %eax,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	c1 e0 03             	shl    $0x3,%eax
  80084b:	01 c8                	add    %ecx,%eax
  80084d:	8a 40 04             	mov    0x4(%eax),%al
  800850:	84 c0                	test   %al,%al
  800852:	75 46                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800854:	a1 20 50 80 00       	mov    0x805020,%eax
  800859:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	01 c0                	add    %eax,%eax
  800866:	01 d0                	add    %edx,%eax
  800868:	c1 e0 03             	shl    $0x3,%eax
  80086b:	01 c8                	add    %ecx,%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800872:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	01 c8                	add    %ecx,%eax
  80088b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088d:	39 c2                	cmp    %eax,%edx
  80088f:	75 09                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800891:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800898:	eb 12                	jmp    8008ac <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089a:	ff 45 e8             	incl   -0x18(%ebp)
  80089d:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a2:	8b 50 74             	mov    0x74(%eax),%edx
  8008a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a8:	39 c2                	cmp    %eax,%edx
  8008aa:	77 88                	ja     800834 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008b0:	75 14                	jne    8008c6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 40 3d 80 00       	push   $0x803d40
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 34 3d 80 00       	push   $0x803d34
  8008c1:	e8 93 fe ff ff       	call   800759 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c6:	ff 45 f0             	incl   -0x10(%ebp)
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cf:	0f 8c 32 ff ff ff    	jl     800807 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e3:	eb 26                	jmp    80090b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8008ea:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	01 c0                	add    %eax,%eax
  8008f7:	01 d0                	add    %edx,%eax
  8008f9:	c1 e0 03             	shl    $0x3,%eax
  8008fc:	01 c8                	add    %ecx,%eax
  8008fe:	8a 40 04             	mov    0x4(%eax),%al
  800901:	3c 01                	cmp    $0x1,%al
  800903:	75 03                	jne    800908 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800905:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800908:	ff 45 e0             	incl   -0x20(%ebp)
  80090b:	a1 20 50 80 00       	mov    0x805020,%eax
  800910:	8b 50 74             	mov    0x74(%eax),%edx
  800913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	77 cb                	ja     8008e5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80091a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800920:	74 14                	je     800936 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	68 94 3d 80 00       	push   $0x803d94
  80092a:	6a 44                	push   $0x44
  80092c:	68 34 3d 80 00       	push   $0x803d34
  800931:	e8 23 fe ff ff       	call   800759 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800936:	90                   	nop
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 48 01             	lea    0x1(%eax),%ecx
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	89 0a                	mov    %ecx,(%edx)
  80094c:	8b 55 08             	mov    0x8(%ebp),%edx
  80094f:	88 d1                	mov    %dl,%cl
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800962:	75 2c                	jne    800990 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800964:	a0 24 50 80 00       	mov    0x805024,%al
  800969:	0f b6 c0             	movzbl %al,%eax
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096f:	8b 12                	mov    (%edx),%edx
  800971:	89 d1                	mov    %edx,%ecx
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	83 c2 08             	add    $0x8,%edx
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	50                   	push   %eax
  80097d:	51                   	push   %ecx
  80097e:	52                   	push   %edx
  80097f:	e8 25 12 00 00       	call   801ba9 <sys_cputs>
  800984:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 40 04             	mov    0x4(%eax),%eax
  800996:	8d 50 01             	lea    0x1(%eax),%edx
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b2:	00 00 00 
	b.cnt = 0;
  8009b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	ff 75 08             	pushl  0x8(%ebp)
  8009c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 39 09 80 00       	push   $0x800939
  8009d1:	e8 11 02 00 00       	call   800be7 <vprintfmt>
  8009d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d9:	a0 24 50 80 00       	mov    0x805024,%al
  8009de:	0f b6 c0             	movzbl %al,%eax
  8009e1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	50                   	push   %eax
  8009eb:	52                   	push   %edx
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	50                   	push   %eax
  8009f6:	e8 ae 11 00 00       	call   801ba9 <sys_cputs>
  8009fb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009fe:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a05:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <cprintf>:

int cprintf(const char *fmt, ...) {
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a13:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 f4             	pushl  -0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	e8 73 ff ff ff       	call   8009a2 <vcprintf>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a40:	e8 12 13 00 00       	call   801d57 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a45:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	e8 48 ff ff ff       	call   8009a2 <vcprintf>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a60:	e8 0c 13 00 00       	call   801d71 <sys_enable_interrupt>
	return cnt;
  800a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	53                   	push   %ebx
  800a6e:	83 ec 14             	sub    $0x14,%esp
  800a71:	8b 45 10             	mov    0x10(%ebp),%eax
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a7d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a88:	77 55                	ja     800adf <printnum+0x75>
  800a8a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a8d:	72 05                	jb     800a94 <printnum+0x2a>
  800a8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a92:	77 4b                	ja     800adf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a94:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a97:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a9a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa2:	52                   	push   %edx
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aaa:	e8 7d 2d 00 00       	call   80382c <__udivdi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	83 ec 04             	sub    $0x4,%esp
  800ab5:	ff 75 20             	pushl  0x20(%ebp)
  800ab8:	53                   	push   %ebx
  800ab9:	ff 75 18             	pushl  0x18(%ebp)
  800abc:	52                   	push   %edx
  800abd:	50                   	push   %eax
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 a1 ff ff ff       	call   800a6a <printnum>
  800ac9:	83 c4 20             	add    $0x20,%esp
  800acc:	eb 1a                	jmp    800ae8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	ff 75 20             	pushl  0x20(%ebp)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800adf:	ff 4d 1c             	decl   0x1c(%ebp)
  800ae2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae6:	7f e6                	jg     800ace <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	53                   	push   %ebx
  800af7:	51                   	push   %ecx
  800af8:	52                   	push   %edx
  800af9:	50                   	push   %eax
  800afa:	e8 3d 2e 00 00       	call   80393c <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 f4 3f 80 00       	add    $0x803ff4,%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	0f be c0             	movsbl %al,%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	50                   	push   %eax
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
}
  800b1b:	90                   	nop
  800b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b24:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b28:	7e 1c                	jle    800b46 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	8d 50 08             	lea    0x8(%eax),%edx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 10                	mov    %edx,(%eax)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	83 e8 08             	sub    $0x8,%eax
  800b3f:	8b 50 04             	mov    0x4(%eax),%edx
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	eb 40                	jmp    800b86 <getuint+0x65>
	else if (lflag)
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	74 1e                	je     800b6a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	8d 50 04             	lea    0x4(%eax),%edx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 10                	mov    %edx,(%eax)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	83 e8 04             	sub    $0x4,%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	ba 00 00 00 00       	mov    $0x0,%edx
  800b68:	eb 1c                	jmp    800b86 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	8d 50 04             	lea    0x4(%eax),%edx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 10                	mov    %edx,(%eax)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8f:	7e 1c                	jle    800bad <getint+0x25>
		return va_arg(*ap, long long);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 08             	lea    0x8(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 08             	sub    $0x8,%eax
  800ba6:	8b 50 04             	mov    0x4(%eax),%edx
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	eb 38                	jmp    800be5 <getint+0x5d>
	else if (lflag)
  800bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb1:	74 1a                	je     800bcd <getint+0x45>
		return va_arg(*ap, long);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 50 04             	lea    0x4(%eax),%edx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 10                	mov    %edx,(%eax)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	83 e8 04             	sub    $0x4,%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	99                   	cltd   
  800bcb:	eb 18                	jmp    800be5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	99                   	cltd   
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bef:	eb 17                	jmp    800c08 <vprintfmt+0x21>
			if (ch == '\0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	0f 84 af 03 00 00    	je     800fa8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	53                   	push   %ebx
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	83 fb 25             	cmp    $0x25,%ebx
  800c19:	75 d6                	jne    800bf1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c1b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c1f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c26:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c34:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	89 55 10             	mov    %edx,0x10(%ebp)
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f b6 d8             	movzbl %al,%ebx
  800c49:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c4c:	83 f8 55             	cmp    $0x55,%eax
  800c4f:	0f 87 2b 03 00 00    	ja     800f80 <vprintfmt+0x399>
  800c55:	8b 04 85 18 40 80 00 	mov    0x804018(,%eax,4),%eax
  800c5c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c5e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c62:	eb d7                	jmp    800c3b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c64:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c68:	eb d1                	jmp    800c3b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c74:	89 d0                	mov    %edx,%eax
  800c76:	c1 e0 02             	shl    $0x2,%eax
  800c79:	01 d0                	add    %edx,%eax
  800c7b:	01 c0                	add    %eax,%eax
  800c7d:	01 d8                	add    %ebx,%eax
  800c7f:	83 e8 30             	sub    $0x30,%eax
  800c82:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c8d:	83 fb 2f             	cmp    $0x2f,%ebx
  800c90:	7e 3e                	jle    800cd0 <vprintfmt+0xe9>
  800c92:	83 fb 39             	cmp    $0x39,%ebx
  800c95:	7f 39                	jg     800cd0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c97:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c9a:	eb d5                	jmp    800c71 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	83 c0 04             	add    $0x4,%eax
  800ca2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 e8 04             	sub    $0x4,%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cb0:	eb 1f                	jmp    800cd1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb6:	79 83                	jns    800c3b <vprintfmt+0x54>
				width = 0;
  800cb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cbf:	e9 77 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cc4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ccb:	e9 6b ff ff ff       	jmp    800c3b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cd0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd5:	0f 89 60 ff ff ff    	jns    800c3b <vprintfmt+0x54>
				width = precision, precision = -1;
  800cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ce1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce8:	e9 4e ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ced:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cf0:	e9 46 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	83 c0 04             	add    $0x4,%eax
  800cfb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800d01:	83 e8 04             	sub    $0x4,%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	50                   	push   %eax
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	ff d0                	call   *%eax
  800d12:	83 c4 10             	add    $0x10,%esp
			break;
  800d15:	e9 89 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 14             	mov    %eax,0x14(%ebp)
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 e8 04             	sub    $0x4,%eax
  800d29:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	79 02                	jns    800d31 <vprintfmt+0x14a>
				err = -err;
  800d2f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d31:	83 fb 64             	cmp    $0x64,%ebx
  800d34:	7f 0b                	jg     800d41 <vprintfmt+0x15a>
  800d36:	8b 34 9d 60 3e 80 00 	mov    0x803e60(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 05 40 80 00       	push   $0x804005
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	ff 75 08             	pushl  0x8(%ebp)
  800d4d:	e8 5e 02 00 00       	call   800fb0 <printfmt>
  800d52:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d55:	e9 49 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5a:	56                   	push   %esi
  800d5b:	68 0e 40 80 00       	push   $0x80400e
  800d60:	ff 75 0c             	pushl  0xc(%ebp)
  800d63:	ff 75 08             	pushl  0x8(%ebp)
  800d66:	e8 45 02 00 00       	call   800fb0 <printfmt>
  800d6b:	83 c4 10             	add    $0x10,%esp
			break;
  800d6e:	e9 30 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d73:	8b 45 14             	mov    0x14(%ebp),%eax
  800d76:	83 c0 04             	add    $0x4,%eax
  800d79:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7f:	83 e8 04             	sub    $0x4,%eax
  800d82:	8b 30                	mov    (%eax),%esi
  800d84:	85 f6                	test   %esi,%esi
  800d86:	75 05                	jne    800d8d <vprintfmt+0x1a6>
				p = "(null)";
  800d88:	be 11 40 80 00       	mov    $0x804011,%esi
			if (width > 0 && padc != '-')
  800d8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d91:	7e 6d                	jle    800e00 <vprintfmt+0x219>
  800d93:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d97:	74 67                	je     800e00 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	50                   	push   %eax
  800da0:	56                   	push   %esi
  800da1:	e8 0c 03 00 00       	call   8010b2 <strnlen>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dac:	eb 16                	jmp    800dc4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800db2:	83 ec 08             	sub    $0x8,%esp
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	ff d0                	call   *%eax
  800dbe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc1:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc8:	7f e4                	jg     800dae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	eb 34                	jmp    800e00 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dd0:	74 1c                	je     800dee <vprintfmt+0x207>
  800dd2:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd5:	7e 05                	jle    800ddc <vprintfmt+0x1f5>
  800dd7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dda:	7e 12                	jle    800dee <vprintfmt+0x207>
					putch('?', putdat);
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 0c             	pushl  0xc(%ebp)
  800de2:	6a 3f                	push   $0x3f
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	ff d0                	call   *%eax
  800de9:	83 c4 10             	add    $0x10,%esp
  800dec:	eb 0f                	jmp    800dfd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	53                   	push   %ebx
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	ff d0                	call   *%eax
  800dfa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfd:	ff 4d e4             	decl   -0x1c(%ebp)
  800e00:	89 f0                	mov    %esi,%eax
  800e02:	8d 70 01             	lea    0x1(%eax),%esi
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f be d8             	movsbl %al,%ebx
  800e0a:	85 db                	test   %ebx,%ebx
  800e0c:	74 24                	je     800e32 <vprintfmt+0x24b>
  800e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e12:	78 b8                	js     800dcc <vprintfmt+0x1e5>
  800e14:	ff 4d e0             	decl   -0x20(%ebp)
  800e17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e1b:	79 af                	jns    800dcc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1d:	eb 13                	jmp    800e32 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 20                	push   $0x20
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e36:	7f e7                	jg     800e1f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e38:	e9 66 01 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 e8             	pushl  -0x18(%ebp)
  800e43:	8d 45 14             	lea    0x14(%ebp),%eax
  800e46:	50                   	push   %eax
  800e47:	e8 3c fd ff ff       	call   800b88 <getint>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5b:	85 d2                	test   %edx,%edx
  800e5d:	79 23                	jns    800e82 <vprintfmt+0x29b>
				putch('-', putdat);
  800e5f:	83 ec 08             	sub    $0x8,%esp
  800e62:	ff 75 0c             	pushl  0xc(%ebp)
  800e65:	6a 2d                	push   $0x2d
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	ff d0                	call   *%eax
  800e6c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e75:	f7 d8                	neg    %eax
  800e77:	83 d2 00             	adc    $0x0,%edx
  800e7a:	f7 da                	neg    %edx
  800e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e89:	e9 bc 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 e8             	pushl  -0x18(%ebp)
  800e94:	8d 45 14             	lea    0x14(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	e8 84 fc ff ff       	call   800b21 <getuint>
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ead:	e9 98 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 58                	push   $0x58
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 58                	push   $0x58
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	6a 58                	push   $0x58
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	ff d0                	call   *%eax
  800edf:	83 c4 10             	add    $0x10,%esp
			break;
  800ee2:	e9 bc 00 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 30                	push   $0x30
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	6a 78                	push   $0x78
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	83 c0 04             	add    $0x4,%eax
  800f0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 e8 04             	sub    $0x4,%eax
  800f16:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f22:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f29:	eb 1f                	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f31:	8d 45 14             	lea    0x14(%ebp),%eax
  800f34:	50                   	push   %eax
  800f35:	e8 e7 fb ff ff       	call   800b21 <getuint>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f51:	83 ec 04             	sub    $0x4,%esp
  800f54:	52                   	push   %edx
  800f55:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f58:	50                   	push   %eax
  800f59:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	e8 00 fb ff ff       	call   800a6a <printnum>
  800f6a:	83 c4 20             	add    $0x20,%esp
			break;
  800f6d:	eb 34                	jmp    800fa3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	53                   	push   %ebx
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	ff d0                	call   *%eax
  800f7b:	83 c4 10             	add    $0x10,%esp
			break;
  800f7e:	eb 23                	jmp    800fa3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f80:	83 ec 08             	sub    $0x8,%esp
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	6a 25                	push   $0x25
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	ff d0                	call   *%eax
  800f8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f90:	ff 4d 10             	decl   0x10(%ebp)
  800f93:	eb 03                	jmp    800f98 <vprintfmt+0x3b1>
  800f95:	ff 4d 10             	decl   0x10(%ebp)
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	48                   	dec    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 25                	cmp    $0x25,%al
  800fa0:	75 f3                	jne    800f95 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fa2:	90                   	nop
		}
	}
  800fa3:	e9 47 fc ff ff       	jmp    800bef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fa8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb9:	83 c0 04             	add    $0x4,%eax
  800fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	e8 16 fc ff ff       	call   800be7 <vprintfmt>
  800fd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fd4:	90                   	nop
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8b 40 08             	mov    0x8(%eax),%eax
  800fe0:	8d 50 01             	lea    0x1(%eax),%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	8b 10                	mov    (%eax),%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8b 40 04             	mov    0x4(%eax),%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	73 12                	jae    80100a <sprintputch+0x33>
		*b->buf++ = ch;
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	8b 00                	mov    (%eax),%eax
  800ffd:	8d 48 01             	lea    0x1(%eax),%ecx
  801000:	8b 55 0c             	mov    0xc(%ebp),%edx
  801003:	89 0a                	mov    %ecx,(%edx)
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	88 10                	mov    %dl,(%eax)
}
  80100a:	90                   	nop
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80102e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801032:	74 06                	je     80103a <vsnprintf+0x2d>
  801034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801038:	7f 07                	jg     801041 <vsnprintf+0x34>
		return -E_INVAL;
  80103a:	b8 03 00 00 00       	mov    $0x3,%eax
  80103f:	eb 20                	jmp    801061 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801041:	ff 75 14             	pushl  0x14(%ebp)
  801044:	ff 75 10             	pushl  0x10(%ebp)
  801047:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	68 d7 0f 80 00       	push   $0x800fd7
  801050:	e8 92 fb ff ff       	call   800be7 <vprintfmt>
  801055:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80105b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80105e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801069:	8d 45 10             	lea    0x10(%ebp),%eax
  80106c:	83 c0 04             	add    $0x4,%eax
  80106f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	ff 75 f4             	pushl  -0xc(%ebp)
  801078:	50                   	push   %eax
  801079:	ff 75 0c             	pushl  0xc(%ebp)
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 89 ff ff ff       	call   80100d <vsnprintf>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109c:	eb 06                	jmp    8010a4 <strlen+0x15>
		n++;
  80109e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a1:	ff 45 08             	incl   0x8(%ebp)
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 f1                	jne    80109e <strlen+0xf>
		n++;
	return n;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010bf:	eb 09                	jmp    8010ca <strnlen+0x18>
		n++;
  8010c1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	ff 4d 0c             	decl   0xc(%ebp)
  8010ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ce:	74 09                	je     8010d9 <strnlen+0x27>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 e8                	jne    8010c1 <strnlen+0xf>
		n++;
	return n;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010ea:	90                   	nop
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8d 50 01             	lea    0x1(%eax),%edx
  8010f1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fd:	8a 12                	mov    (%edx),%dl
  8010ff:	88 10                	mov    %dl,(%eax)
  801101:	8a 00                	mov    (%eax),%al
  801103:	84 c0                	test   %al,%al
  801105:	75 e4                	jne    8010eb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801107:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80111f:	eb 1f                	jmp    801140 <strncpy+0x34>
		*dst++ = *src;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	89 55 08             	mov    %edx,0x8(%ebp)
  80112a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	74 03                	je     80113d <strncpy+0x31>
			src++;
  80113a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113d:	ff 45 fc             	incl   -0x4(%ebp)
  801140:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801143:	3b 45 10             	cmp    0x10(%ebp),%eax
  801146:	72 d9                	jb     801121 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801148:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801159:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115d:	74 30                	je     80118f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80115f:	eb 16                	jmp    801177 <strlcpy+0x2a>
			*dst++ = *src++;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8d 50 01             	lea    0x1(%eax),%edx
  801167:	89 55 08             	mov    %edx,0x8(%ebp)
  80116a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801170:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801173:	8a 12                	mov    (%edx),%dl
  801175:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801177:	ff 4d 10             	decl   0x10(%ebp)
  80117a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117e:	74 09                	je     801189 <strlcpy+0x3c>
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	84 c0                	test   %al,%al
  801187:	75 d8                	jne    801161 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80118f:	8b 55 08             	mov    0x8(%ebp),%edx
  801192:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801195:	29 c2                	sub    %eax,%edx
  801197:	89 d0                	mov    %edx,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80119e:	eb 06                	jmp    8011a6 <strcmp+0xb>
		p++, q++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0e                	je     8011bd <strcmp+0x22>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 10                	mov    (%eax),%dl
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	38 c2                	cmp    %al,%dl
  8011bb:	74 e3                	je     8011a0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 d0             	movzbl %al,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	0f b6 c0             	movzbl %al,%eax
  8011cd:	29 c2                	sub    %eax,%edx
  8011cf:	89 d0                	mov    %edx,%eax
}
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011d6:	eb 09                	jmp    8011e1 <strncmp+0xe>
		n--, p++, q++;
  8011d8:	ff 4d 10             	decl   0x10(%ebp)
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e5:	74 17                	je     8011fe <strncmp+0x2b>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 0e                	je     8011fe <strncmp+0x2b>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 10                	mov    (%eax),%dl
  8011f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	38 c2                	cmp    %al,%dl
  8011fc:	74 da                	je     8011d8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801202:	75 07                	jne    80120b <strncmp+0x38>
		return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 14                	jmp    80121f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	0f b6 d0             	movzbl %al,%edx
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f b6 c0             	movzbl %al,%eax
  80121b:	29 c2                	sub    %eax,%edx
  80121d:	89 d0                	mov    %edx,%eax
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122d:	eb 12                	jmp    801241 <strchr+0x20>
		if (*s == c)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801237:	75 05                	jne    80123e <strchr+0x1d>
			return (char *) s;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	eb 11                	jmp    80124f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	84 c0                	test   %al,%al
  801248:	75 e5                	jne    80122f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80125d:	eb 0d                	jmp    80126c <strfind+0x1b>
		if (*s == c)
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801267:	74 0e                	je     801277 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	75 ea                	jne    80125f <strfind+0xe>
  801275:	eb 01                	jmp    801278 <strfind+0x27>
		if (*s == c)
			break;
  801277:	90                   	nop
	return (char *) s;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80128f:	eb 0e                	jmp    80129f <memset+0x22>
		*p++ = c;
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	8d 50 01             	lea    0x1(%eax),%edx
  801297:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80129a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80129f:	ff 4d f8             	decl   -0x8(%ebp)
  8012a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012a6:	79 e9                	jns    801291 <memset+0x14>
		*p++ = c;

	return v;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012bf:	eb 16                	jmp    8012d7 <memcpy+0x2a>
		*d++ = *s++;
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	8d 50 01             	lea    0x1(%eax),%edx
  8012c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d3:	8a 12                	mov    (%edx),%dl
  8012d5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 dd                	jne    8012c1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801301:	73 50                	jae    801353 <memmove+0x6a>
  801303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80130e:	76 43                	jbe    801353 <memmove+0x6a>
		s += n;
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80131c:	eb 10                	jmp    80132e <memmove+0x45>
			*--d = *--s;
  80131e:	ff 4d f8             	decl   -0x8(%ebp)
  801321:	ff 4d fc             	decl   -0x4(%ebp)
  801324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801327:	8a 10                	mov    (%eax),%dl
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	8d 50 ff             	lea    -0x1(%eax),%edx
  801334:	89 55 10             	mov    %edx,0x10(%ebp)
  801337:	85 c0                	test   %eax,%eax
  801339:	75 e3                	jne    80131e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80133b:	eb 23                	jmp    801360 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801346:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801349:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80134f:	8a 12                	mov    (%edx),%dl
  801351:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	8d 50 ff             	lea    -0x1(%eax),%edx
  801359:	89 55 10             	mov    %edx,0x10(%ebp)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	75 dd                	jne    80133d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801377:	eb 2a                	jmp    8013a3 <memcmp+0x3e>
		if (*s1 != *s2)
  801379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137c:	8a 10                	mov    (%eax),%dl
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	38 c2                	cmp    %al,%dl
  801385:	74 16                	je     80139d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 c0             	movzbl %al,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	eb 18                	jmp    8013b5 <memcmp+0x50>
		s1++, s2++;
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
  8013a0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 c9                	jne    801379 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013c8:	eb 15                	jmp    8013df <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	0f b6 c0             	movzbl %al,%eax
  8013d8:	39 c2                	cmp    %eax,%edx
  8013da:	74 0d                	je     8013e9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013dc:	ff 45 08             	incl   0x8(%ebp)
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013e5:	72 e3                	jb     8013ca <memfind+0x13>
  8013e7:	eb 01                	jmp    8013ea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e9:	90                   	nop
	return (void *) s;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801403:	eb 03                	jmp    801408 <strtol+0x19>
		s++;
  801405:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 20                	cmp    $0x20,%al
  80140f:	74 f4                	je     801405 <strtol+0x16>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 09                	cmp    $0x9,%al
  801418:	74 eb                	je     801405 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 2b                	cmp    $0x2b,%al
  801421:	75 05                	jne    801428 <strtol+0x39>
		s++;
  801423:	ff 45 08             	incl   0x8(%ebp)
  801426:	eb 13                	jmp    80143b <strtol+0x4c>
	else if (*s == '-')
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 2d                	cmp    $0x2d,%al
  80142f:	75 0a                	jne    80143b <strtol+0x4c>
		s++, neg = 1;
  801431:	ff 45 08             	incl   0x8(%ebp)
  801434:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143f:	74 06                	je     801447 <strtol+0x58>
  801441:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801445:	75 20                	jne    801467 <strtol+0x78>
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	3c 30                	cmp    $0x30,%al
  80144e:	75 17                	jne    801467 <strtol+0x78>
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	40                   	inc    %eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	3c 78                	cmp    $0x78,%al
  801458:	75 0d                	jne    801467 <strtol+0x78>
		s += 2, base = 16;
  80145a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80145e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801465:	eb 28                	jmp    80148f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146b:	75 15                	jne    801482 <strtol+0x93>
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 30                	cmp    $0x30,%al
  801474:	75 0c                	jne    801482 <strtol+0x93>
		s++, base = 8;
  801476:	ff 45 08             	incl   0x8(%ebp)
  801479:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801480:	eb 0d                	jmp    80148f <strtol+0xa0>
	else if (base == 0)
  801482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801486:	75 07                	jne    80148f <strtol+0xa0>
		base = 10;
  801488:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 2f                	cmp    $0x2f,%al
  801496:	7e 19                	jle    8014b1 <strtol+0xc2>
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 39                	cmp    $0x39,%al
  80149f:	7f 10                	jg     8014b1 <strtol+0xc2>
			dig = *s - '0';
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f be c0             	movsbl %al,%eax
  8014a9:	83 e8 30             	sub    $0x30,%eax
  8014ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014af:	eb 42                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	3c 60                	cmp    $0x60,%al
  8014b8:	7e 19                	jle    8014d3 <strtol+0xe4>
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	3c 7a                	cmp    $0x7a,%al
  8014c1:	7f 10                	jg     8014d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	0f be c0             	movsbl %al,%eax
  8014cb:	83 e8 57             	sub    $0x57,%eax
  8014ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d1:	eb 20                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 40                	cmp    $0x40,%al
  8014da:	7e 39                	jle    801515 <strtol+0x126>
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	3c 5a                	cmp    $0x5a,%al
  8014e3:	7f 30                	jg     801515 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	0f be c0             	movsbl %al,%eax
  8014ed:	83 e8 37             	sub    $0x37,%eax
  8014f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f9:	7d 19                	jge    801514 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014fb:	ff 45 08             	incl   0x8(%ebp)
  8014fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801501:	0f af 45 10          	imul   0x10(%ebp),%eax
  801505:	89 c2                	mov    %eax,%edx
  801507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80150f:	e9 7b ff ff ff       	jmp    80148f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801514:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801515:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801519:	74 08                	je     801523 <strtol+0x134>
		*endptr = (char *) s;
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	8b 55 08             	mov    0x8(%ebp),%edx
  801521:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801523:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801527:	74 07                	je     801530 <strtol+0x141>
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	f7 d8                	neg    %eax
  80152e:	eb 03                	jmp    801533 <strtol+0x144>
  801530:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <ltostr>:

void
ltostr(long value, char *str)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80153b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801542:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801549:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80154d:	79 13                	jns    801562 <ltostr+0x2d>
	{
		neg = 1;
  80154f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80155c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80155f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80156a:	99                   	cltd   
  80156b:	f7 f9                	idiv   %ecx
  80156d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801579:	89 c2                	mov    %eax,%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801583:	83 c2 30             	add    $0x30,%edx
  801586:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801588:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801590:	f7 e9                	imul   %ecx
  801592:	c1 fa 02             	sar    $0x2,%edx
  801595:	89 c8                	mov    %ecx,%eax
  801597:	c1 f8 1f             	sar    $0x1f,%eax
  80159a:	29 c2                	sub    %eax,%edx
  80159c:	89 d0                	mov    %edx,%eax
  80159e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a9:	f7 e9                	imul   %ecx
  8015ab:	c1 fa 02             	sar    $0x2,%edx
  8015ae:	89 c8                	mov    %ecx,%eax
  8015b0:	c1 f8 1f             	sar    $0x1f,%eax
  8015b3:	29 c2                	sub    %eax,%edx
  8015b5:	89 d0                	mov    %edx,%eax
  8015b7:	c1 e0 02             	shl    $0x2,%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	01 c0                	add    %eax,%eax
  8015be:	29 c1                	sub    %eax,%ecx
  8015c0:	89 ca                	mov    %ecx,%edx
  8015c2:	85 d2                	test   %edx,%edx
  8015c4:	75 9c                	jne    801562 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	48                   	dec    %eax
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015d8:	74 3d                	je     801617 <ltostr+0xe2>
		start = 1 ;
  8015da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015e1:	eb 34                	jmp    801617 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801604:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	01 c2                	add    %eax,%edx
  80160c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80160f:	88 02                	mov    %al,(%edx)
		start++ ;
  801611:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801614:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161d:	7c c4                	jl     8015e3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80161f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	01 d0                	add    %edx,%eax
  801627:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80162a:	90                   	nop
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801633:	ff 75 08             	pushl  0x8(%ebp)
  801636:	e8 54 fa ff ff       	call   80108f <strlen>
  80163b:	83 c4 04             	add    $0x4,%esp
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	e8 46 fa ff ff       	call   80108f <strlen>
  801649:	83 c4 04             	add    $0x4,%esp
  80164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80164f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80165d:	eb 17                	jmp    801676 <strcconcat+0x49>
		final[s] = str1[s] ;
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 c2                	add    %eax,%edx
  801667:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	01 c8                	add    %ecx,%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801673:	ff 45 fc             	incl   -0x4(%ebp)
  801676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801679:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167c:	7c e1                	jl     80165f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80167e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801685:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80168c:	eb 1f                	jmp    8016ad <strcconcat+0x80>
		final[s++] = str2[i] ;
  80168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801691:	8d 50 01             	lea    0x1(%eax),%edx
  801694:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801697:	89 c2                	mov    %eax,%edx
  801699:	8b 45 10             	mov    0x10(%ebp),%eax
  80169c:	01 c2                	add    %eax,%edx
  80169e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a4:	01 c8                	add    %ecx,%eax
  8016a6:	8a 00                	mov    (%eax),%al
  8016a8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016aa:	ff 45 f8             	incl   -0x8(%ebp)
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b3:	7c d9                	jl     80168e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	c6 00 00             	movb   $0x0,(%eax)
}
  8016c0:	90                   	nop
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d2:	8b 00                	mov    (%eax),%eax
  8016d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e6:	eb 0c                	jmp    8016f4 <strsplit+0x31>
			*string++ = 0;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	84 c0                	test   %al,%al
  8016fb:	74 18                	je     801715 <strsplit+0x52>
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f be c0             	movsbl %al,%eax
  801705:	50                   	push   %eax
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	e8 13 fb ff ff       	call   801221 <strchr>
  80170e:	83 c4 08             	add    $0x8,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	75 d3                	jne    8016e8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 5a                	je     801778 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	83 f8 0f             	cmp    $0xf,%eax
  801726:	75 07                	jne    80172f <strsplit+0x6c>
		{
			return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 66                	jmp    801795 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80172f:	8b 45 14             	mov    0x14(%ebp),%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	8d 48 01             	lea    0x1(%eax),%ecx
  801737:	8b 55 14             	mov    0x14(%ebp),%edx
  80173a:	89 0a                	mov    %ecx,(%edx)
  80173c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	01 c2                	add    %eax,%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80174d:	eb 03                	jmp    801752 <strsplit+0x8f>
			string++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	84 c0                	test   %al,%al
  801759:	74 8b                	je     8016e6 <strsplit+0x23>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	0f be c0             	movsbl %al,%eax
  801763:	50                   	push   %eax
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	e8 b5 fa ff ff       	call   801221 <strchr>
  80176c:	83 c4 08             	add    $0x8,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	74 dc                	je     80174f <strsplit+0x8c>
			string++;
	}
  801773:	e9 6e ff ff ff       	jmp    8016e6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801778:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801779:	8b 45 14             	mov    0x14(%ebp),%eax
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801790:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80179d:	a1 04 50 80 00       	mov    0x805004,%eax
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	74 1f                	je     8017c5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017a6:	e8 1d 00 00 00       	call   8017c8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	68 70 41 80 00       	push   $0x804170
  8017b3:	e8 55 f2 ff ff       	call   800a0d <cprintf>
  8017b8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017bb:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8017c2:	00 00 00 
	}
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8017ce:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8017d5:	00 00 00 
  8017d8:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017df:	00 00 00 
  8017e2:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8017e9:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8017ec:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8017f3:	00 00 00 
  8017f6:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017fd:	00 00 00 
  801800:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801807:	00 00 00 
	uint32 arr_size = 0;
  80180a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801811:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801820:	2d 00 10 00 00       	sub    $0x1000,%eax
  801825:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80182a:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801831:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801834:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80183b:	a1 20 51 80 00       	mov    0x805120,%eax
  801840:	c1 e0 04             	shl    $0x4,%eax
  801843:	89 c2                	mov    %eax,%edx
  801845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801848:	01 d0                	add    %edx,%eax
  80184a:	48                   	dec    %eax
  80184b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80184e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
  801856:	f7 75 ec             	divl   -0x14(%ebp)
  801859:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185c:	29 d0                	sub    %edx,%eax
  80185e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801861:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80186b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801870:	2d 00 10 00 00       	sub    $0x1000,%eax
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	6a 06                	push   $0x6
  80187a:	ff 75 f4             	pushl  -0xc(%ebp)
  80187d:	50                   	push   %eax
  80187e:	e8 6a 04 00 00       	call   801ced <sys_allocate_chunk>
  801883:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801886:	a1 20 51 80 00       	mov    0x805120,%eax
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	50                   	push   %eax
  80188f:	e8 df 0a 00 00       	call   802373 <initialize_MemBlocksList>
  801894:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801897:	a1 48 51 80 00       	mov    0x805148,%eax
  80189c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80189f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a2:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8018a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ac:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8018b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018b7:	75 14                	jne    8018cd <initialize_dyn_block_system+0x105>
  8018b9:	83 ec 04             	sub    $0x4,%esp
  8018bc:	68 95 41 80 00       	push   $0x804195
  8018c1:	6a 33                	push   $0x33
  8018c3:	68 b3 41 80 00       	push   $0x8041b3
  8018c8:	e8 8c ee ff ff       	call   800759 <_panic>
  8018cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d0:	8b 00                	mov    (%eax),%eax
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	74 10                	je     8018e6 <initialize_dyn_block_system+0x11e>
  8018d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d9:	8b 00                	mov    (%eax),%eax
  8018db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018de:	8b 52 04             	mov    0x4(%edx),%edx
  8018e1:	89 50 04             	mov    %edx,0x4(%eax)
  8018e4:	eb 0b                	jmp    8018f1 <initialize_dyn_block_system+0x129>
  8018e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e9:	8b 40 04             	mov    0x4(%eax),%eax
  8018ec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8018f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f4:	8b 40 04             	mov    0x4(%eax),%eax
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	74 0f                	je     80190a <initialize_dyn_block_system+0x142>
  8018fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018fe:	8b 40 04             	mov    0x4(%eax),%eax
  801901:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801904:	8b 12                	mov    (%edx),%edx
  801906:	89 10                	mov    %edx,(%eax)
  801908:	eb 0a                	jmp    801914 <initialize_dyn_block_system+0x14c>
  80190a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80190d:	8b 00                	mov    (%eax),%eax
  80190f:	a3 48 51 80 00       	mov    %eax,0x805148
  801914:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801917:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80191d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801920:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801927:	a1 54 51 80 00       	mov    0x805154,%eax
  80192c:	48                   	dec    %eax
  80192d:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801932:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801936:	75 14                	jne    80194c <initialize_dyn_block_system+0x184>
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	68 c0 41 80 00       	push   $0x8041c0
  801940:	6a 34                	push   $0x34
  801942:	68 b3 41 80 00       	push   $0x8041b3
  801947:	e8 0d ee ff ff       	call   800759 <_panic>
  80194c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801955:	89 10                	mov    %edx,(%eax)
  801957:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195a:	8b 00                	mov    (%eax),%eax
  80195c:	85 c0                	test   %eax,%eax
  80195e:	74 0d                	je     80196d <initialize_dyn_block_system+0x1a5>
  801960:	a1 38 51 80 00       	mov    0x805138,%eax
  801965:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801968:	89 50 04             	mov    %edx,0x4(%eax)
  80196b:	eb 08                	jmp    801975 <initialize_dyn_block_system+0x1ad>
  80196d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801970:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801978:	a3 38 51 80 00       	mov    %eax,0x805138
  80197d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801980:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801987:	a1 44 51 80 00       	mov    0x805144,%eax
  80198c:	40                   	inc    %eax
  80198d:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801992:	90                   	nop
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80199b:	e8 f7 fd ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019a4:	75 07                	jne    8019ad <malloc+0x18>
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ab:	eb 61                	jmp    801a0e <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8019ad:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ba:	01 d0                	add    %edx,%eax
  8019bc:	48                   	dec    %eax
  8019bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c8:	f7 75 f0             	divl   -0x10(%ebp)
  8019cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ce:	29 d0                	sub    %edx,%eax
  8019d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019d3:	e8 e3 06 00 00       	call   8020bb <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	74 11                	je     8019ed <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8019dc:	83 ec 0c             	sub    $0xc,%esp
  8019df:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e2:	e8 4e 0d 00 00       	call   802735 <alloc_block_FF>
  8019e7:	83 c4 10             	add    $0x10,%esp
  8019ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  8019ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f1:	74 16                	je     801a09 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  8019f3:	83 ec 0c             	sub    $0xc,%esp
  8019f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f9:	e8 aa 0a 00 00       	call   8024a8 <insert_sorted_allocList>
  8019fe:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a04:	8b 40 08             	mov    0x8(%eax),%eax
  801a07:	eb 05                	jmp    801a0e <malloc+0x79>
	}

    return NULL;
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	68 e4 41 80 00       	push   $0x8041e4
  801a1e:	6a 6f                	push   $0x6f
  801a20:	68 b3 41 80 00       	push   $0x8041b3
  801a25:	e8 2f ed ff ff       	call   800759 <_panic>

00801a2a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 38             	sub    $0x38,%esp
  801a30:	8b 45 10             	mov    0x10(%ebp),%eax
  801a33:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a36:	e8 5c fd ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a3f:	75 07                	jne    801a48 <smalloc+0x1e>
  801a41:	b8 00 00 00 00       	mov    $0x0,%eax
  801a46:	eb 7c                	jmp    801ac4 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a48:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a55:	01 d0                	add    %edx,%eax
  801a57:	48                   	dec    %eax
  801a58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a63:	f7 75 f0             	divl   -0x10(%ebp)
  801a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a69:	29 d0                	sub    %edx,%eax
  801a6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a6e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a75:	e8 41 06 00 00       	call   8020bb <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	74 11                	je     801a8f <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801a7e:	83 ec 0c             	sub    $0xc,%esp
  801a81:	ff 75 e8             	pushl  -0x18(%ebp)
  801a84:	e8 ac 0c 00 00       	call   802735 <alloc_block_FF>
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a93:	74 2a                	je     801abf <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a98:	8b 40 08             	mov    0x8(%eax),%eax
  801a9b:	89 c2                	mov    %eax,%edx
  801a9d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801aa1:	52                   	push   %edx
  801aa2:	50                   	push   %eax
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	e8 92 03 00 00       	call   801e40 <sys_createSharedObject>
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801ab4:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801ab8:	74 05                	je     801abf <smalloc+0x95>
			return (void*)virtual_address;
  801aba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801abd:	eb 05                	jmp    801ac4 <smalloc+0x9a>
	}
	return NULL;
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801acc:	e8 c6 fc ff ff       	call   801797 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801ad1:	83 ec 04             	sub    $0x4,%esp
  801ad4:	68 08 42 80 00       	push   $0x804208
  801ad9:	68 b0 00 00 00       	push   $0xb0
  801ade:	68 b3 41 80 00       	push   $0x8041b3
  801ae3:	e8 71 ec ff ff       	call   800759 <_panic>

00801ae8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aee:	e8 a4 fc ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	68 2c 42 80 00       	push   $0x80422c
  801afb:	68 f4 00 00 00       	push   $0xf4
  801b00:	68 b3 41 80 00       	push   $0x8041b3
  801b05:	e8 4f ec ff ff       	call   800759 <_panic>

00801b0a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	68 54 42 80 00       	push   $0x804254
  801b18:	68 08 01 00 00       	push   $0x108
  801b1d:	68 b3 41 80 00       	push   $0x8041b3
  801b22:	e8 32 ec ff ff       	call   800759 <_panic>

00801b27 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b2d:	83 ec 04             	sub    $0x4,%esp
  801b30:	68 78 42 80 00       	push   $0x804278
  801b35:	68 13 01 00 00       	push   $0x113
  801b3a:	68 b3 41 80 00       	push   $0x8041b3
  801b3f:	e8 15 ec ff ff       	call   800759 <_panic>

00801b44 <shrink>:

}
void shrink(uint32 newSize)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	68 78 42 80 00       	push   $0x804278
  801b52:	68 18 01 00 00       	push   $0x118
  801b57:	68 b3 41 80 00       	push   $0x8041b3
  801b5c:	e8 f8 eb ff ff       	call   800759 <_panic>

00801b61 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	68 78 42 80 00       	push   $0x804278
  801b6f:	68 1d 01 00 00       	push   $0x11d
  801b74:	68 b3 41 80 00       	push   $0x8041b3
  801b79:	e8 db eb ff ff       	call   800759 <_panic>

00801b7e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	57                   	push   %edi
  801b82:	56                   	push   %esi
  801b83:	53                   	push   %ebx
  801b84:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b90:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b93:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b96:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b99:	cd 30                	int    $0x30
  801b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ba1:	83 c4 10             	add    $0x10,%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5f                   	pop    %edi
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    

00801ba9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 04             	sub    $0x4,%esp
  801baf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bb5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	52                   	push   %edx
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	50                   	push   %eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	e8 b2 ff ff ff       	call   801b7e <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	90                   	nop
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 01                	push   $0x1
  801be1:	e8 98 ff ff ff       	call   801b7e <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	52                   	push   %edx
  801bfb:	50                   	push   %eax
  801bfc:	6a 05                	push   $0x5
  801bfe:	e8 7b ff ff ff       	call   801b7e <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	56                   	push   %esi
  801c0c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c0d:	8b 75 18             	mov    0x18(%ebp),%esi
  801c10:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c13:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	56                   	push   %esi
  801c1d:	53                   	push   %ebx
  801c1e:	51                   	push   %ecx
  801c1f:	52                   	push   %edx
  801c20:	50                   	push   %eax
  801c21:	6a 06                	push   $0x6
  801c23:	e8 56 ff ff ff       	call   801b7e <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5e                   	pop    %esi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    

00801c32 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	52                   	push   %edx
  801c42:	50                   	push   %eax
  801c43:	6a 07                	push   $0x7
  801c45:	e8 34 ff ff ff       	call   801b7e <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	6a 08                	push   $0x8
  801c60:	e8 19 ff ff ff       	call   801b7e <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 09                	push   $0x9
  801c79:	e8 00 ff ff ff       	call   801b7e <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 0a                	push   $0xa
  801c92:	e8 e7 fe ff ff       	call   801b7e <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 0b                	push   $0xb
  801cab:	e8 ce fe ff ff       	call   801b7e <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	ff 75 0c             	pushl  0xc(%ebp)
  801cc1:	ff 75 08             	pushl  0x8(%ebp)
  801cc4:	6a 0f                	push   $0xf
  801cc6:	e8 b3 fe ff ff       	call   801b7e <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
	return;
  801cce:	90                   	nop
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	ff 75 08             	pushl  0x8(%ebp)
  801ce0:	6a 10                	push   $0x10
  801ce2:	e8 97 fe ff ff       	call   801b7e <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cea:	90                   	nop
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	ff 75 10             	pushl  0x10(%ebp)
  801cf7:	ff 75 0c             	pushl  0xc(%ebp)
  801cfa:	ff 75 08             	pushl  0x8(%ebp)
  801cfd:	6a 11                	push   $0x11
  801cff:	e8 7a fe ff ff       	call   801b7e <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
	return ;
  801d07:	90                   	nop
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 0c                	push   $0xc
  801d19:	e8 60 fe ff ff       	call   801b7e <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	6a 0d                	push   $0xd
  801d33:	e8 46 fe ff ff       	call   801b7e <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 0e                	push   $0xe
  801d4c:	e8 2d fe ff ff       	call   801b7e <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	90                   	nop
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 13                	push   $0x13
  801d66:	e8 13 fe ff ff       	call   801b7e <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	90                   	nop
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 14                	push   $0x14
  801d80:	e8 f9 fd ff ff       	call   801b7e <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	90                   	nop
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_cputc>:


void
sys_cputc(const char c)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 04             	sub    $0x4,%esp
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d97:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	50                   	push   %eax
  801da4:	6a 15                	push   $0x15
  801da6:	e8 d3 fd ff ff       	call   801b7e <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	90                   	nop
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 16                	push   $0x16
  801dc0:	e8 b9 fd ff ff       	call   801b7e <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	90                   	nop
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	ff 75 0c             	pushl  0xc(%ebp)
  801dda:	50                   	push   %eax
  801ddb:	6a 17                	push   $0x17
  801ddd:	e8 9c fd ff ff       	call   801b7e <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	52                   	push   %edx
  801df7:	50                   	push   %eax
  801df8:	6a 1a                	push   $0x1a
  801dfa:	e8 7f fd ff ff       	call   801b7e <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	52                   	push   %edx
  801e14:	50                   	push   %eax
  801e15:	6a 18                	push   $0x18
  801e17:	e8 62 fd ff ff       	call   801b7e <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	90                   	nop
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	52                   	push   %edx
  801e32:	50                   	push   %eax
  801e33:	6a 19                	push   $0x19
  801e35:	e8 44 fd ff ff       	call   801b7e <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	90                   	nop
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 04             	sub    $0x4,%esp
  801e46:	8b 45 10             	mov    0x10(%ebp),%eax
  801e49:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e4c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e4f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	6a 00                	push   $0x0
  801e58:	51                   	push   %ecx
  801e59:	52                   	push   %edx
  801e5a:	ff 75 0c             	pushl  0xc(%ebp)
  801e5d:	50                   	push   %eax
  801e5e:	6a 1b                	push   $0x1b
  801e60:	e8 19 fd ff ff       	call   801b7e <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	52                   	push   %edx
  801e7a:	50                   	push   %eax
  801e7b:	6a 1c                	push   $0x1c
  801e7d:	e8 fc fc ff ff       	call   801b7e <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	51                   	push   %ecx
  801e98:	52                   	push   %edx
  801e99:	50                   	push   %eax
  801e9a:	6a 1d                	push   $0x1d
  801e9c:	e8 dd fc ff ff       	call   801b7e <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	52                   	push   %edx
  801eb6:	50                   	push   %eax
  801eb7:	6a 1e                	push   $0x1e
  801eb9:	e8 c0 fc ff ff       	call   801b7e <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 1f                	push   $0x1f
  801ed2:	e8 a7 fc ff ff       	call   801b7e <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	6a 00                	push   $0x0
  801ee4:	ff 75 14             	pushl  0x14(%ebp)
  801ee7:	ff 75 10             	pushl  0x10(%ebp)
  801eea:	ff 75 0c             	pushl  0xc(%ebp)
  801eed:	50                   	push   %eax
  801eee:	6a 20                	push   $0x20
  801ef0:	e8 89 fc ff ff       	call   801b7e <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	50                   	push   %eax
  801f09:	6a 21                	push   $0x21
  801f0b:	e8 6e fc ff ff       	call   801b7e <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
}
  801f13:	90                   	nop
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	50                   	push   %eax
  801f25:	6a 22                	push   $0x22
  801f27:	e8 52 fc ff ff       	call   801b7e <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 02                	push   $0x2
  801f40:	e8 39 fc ff ff       	call   801b7e <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 03                	push   $0x3
  801f59:	e8 20 fc ff ff       	call   801b7e <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 04                	push   $0x4
  801f72:	e8 07 fc ff ff       	call   801b7e <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_exit_env>:


void sys_exit_env(void)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 23                	push   $0x23
  801f8b:	e8 ee fb ff ff       	call   801b7e <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	90                   	nop
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f9c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f9f:	8d 50 04             	lea    0x4(%eax),%edx
  801fa2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	52                   	push   %edx
  801fac:	50                   	push   %eax
  801fad:	6a 24                	push   $0x24
  801faf:	e8 ca fb ff ff       	call   801b7e <syscall>
  801fb4:	83 c4 18             	add    $0x18,%esp
	return result;
  801fb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fc0:	89 01                	mov    %eax,(%ecx)
  801fc2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	c9                   	leave  
  801fc9:	c2 04 00             	ret    $0x4

00801fcc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	ff 75 10             	pushl  0x10(%ebp)
  801fd6:	ff 75 0c             	pushl  0xc(%ebp)
  801fd9:	ff 75 08             	pushl  0x8(%ebp)
  801fdc:	6a 12                	push   $0x12
  801fde:	e8 9b fb ff ff       	call   801b7e <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe6:	90                   	nop
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 25                	push   $0x25
  801ff8:	e8 81 fb ff ff       	call   801b7e <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80200e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	50                   	push   %eax
  80201b:	6a 26                	push   $0x26
  80201d:	e8 5c fb ff ff       	call   801b7e <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
	return ;
  802025:	90                   	nop
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <rsttst>:
void rsttst()
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 28                	push   $0x28
  802037:	e8 42 fb ff ff       	call   801b7e <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
	return ;
  80203f:	90                   	nop
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 04             	sub    $0x4,%esp
  802048:	8b 45 14             	mov    0x14(%ebp),%eax
  80204b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80204e:	8b 55 18             	mov    0x18(%ebp),%edx
  802051:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802055:	52                   	push   %edx
  802056:	50                   	push   %eax
  802057:	ff 75 10             	pushl  0x10(%ebp)
  80205a:	ff 75 0c             	pushl  0xc(%ebp)
  80205d:	ff 75 08             	pushl  0x8(%ebp)
  802060:	6a 27                	push   $0x27
  802062:	e8 17 fb ff ff       	call   801b7e <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
	return ;
  80206a:	90                   	nop
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <chktst>:
void chktst(uint32 n)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	ff 75 08             	pushl  0x8(%ebp)
  80207b:	6a 29                	push   $0x29
  80207d:	e8 fc fa ff ff       	call   801b7e <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
	return ;
  802085:	90                   	nop
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <inctst>:

void inctst()
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 2a                	push   $0x2a
  802097:	e8 e2 fa ff ff       	call   801b7e <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
	return ;
  80209f:	90                   	nop
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <gettst>:
uint32 gettst()
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 2b                	push   $0x2b
  8020b1:	e8 c8 fa ff ff       	call   801b7e <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 2c                	push   $0x2c
  8020cd:	e8 ac fa ff ff       	call   801b7e <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
  8020d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020d8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020dc:	75 07                	jne    8020e5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020de:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e3:	eb 05                	jmp    8020ea <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 2c                	push   $0x2c
  8020fe:	e8 7b fa ff ff       	call   801b7e <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
  802106:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802109:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80210d:	75 07                	jne    802116 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80210f:	b8 01 00 00 00       	mov    $0x1,%eax
  802114:	eb 05                	jmp    80211b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802116:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 2c                	push   $0x2c
  80212f:	e8 4a fa ff ff       	call   801b7e <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
  802137:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80213a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80213e:	75 07                	jne    802147 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802140:	b8 01 00 00 00       	mov    $0x1,%eax
  802145:	eb 05                	jmp    80214c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802147:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 2c                	push   $0x2c
  802160:	e8 19 fa ff ff       	call   801b7e <syscall>
  802165:	83 c4 18             	add    $0x18,%esp
  802168:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80216b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80216f:	75 07                	jne    802178 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802171:	b8 01 00 00 00       	mov    $0x1,%eax
  802176:	eb 05                	jmp    80217d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802178:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	ff 75 08             	pushl  0x8(%ebp)
  80218d:	6a 2d                	push   $0x2d
  80218f:	e8 ea f9 ff ff       	call   801b7e <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
	return ;
  802197:	90                   	nop
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80219e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	6a 00                	push   $0x0
  8021ac:	53                   	push   %ebx
  8021ad:	51                   	push   %ecx
  8021ae:	52                   	push   %edx
  8021af:	50                   	push   %eax
  8021b0:	6a 2e                	push   $0x2e
  8021b2:	e8 c7 f9 ff ff       	call   801b7e <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
}
  8021ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	52                   	push   %edx
  8021cf:	50                   	push   %eax
  8021d0:	6a 2f                	push   $0x2f
  8021d2:	e8 a7 f9 ff ff       	call   801b7e <syscall>
  8021d7:	83 c4 18             	add    $0x18,%esp
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8021e2:	83 ec 0c             	sub    $0xc,%esp
  8021e5:	68 88 42 80 00       	push   $0x804288
  8021ea:	e8 1e e8 ff ff       	call   800a0d <cprintf>
  8021ef:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8021f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8021f9:	83 ec 0c             	sub    $0xc,%esp
  8021fc:	68 b4 42 80 00       	push   $0x8042b4
  802201:	e8 07 e8 ff ff       	call   800a0d <cprintf>
  802206:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802209:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80220d:	a1 38 51 80 00       	mov    0x805138,%eax
  802212:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802215:	eb 56                	jmp    80226d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802217:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80221b:	74 1c                	je     802239 <print_mem_block_lists+0x5d>
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	8b 50 08             	mov    0x8(%eax),%edx
  802223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802226:	8b 48 08             	mov    0x8(%eax),%ecx
  802229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222c:	8b 40 0c             	mov    0xc(%eax),%eax
  80222f:	01 c8                	add    %ecx,%eax
  802231:	39 c2                	cmp    %eax,%edx
  802233:	73 04                	jae    802239 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802235:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	8b 50 08             	mov    0x8(%eax),%edx
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	8b 40 0c             	mov    0xc(%eax),%eax
  802245:	01 c2                	add    %eax,%edx
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	8b 40 08             	mov    0x8(%eax),%eax
  80224d:	83 ec 04             	sub    $0x4,%esp
  802250:	52                   	push   %edx
  802251:	50                   	push   %eax
  802252:	68 c9 42 80 00       	push   $0x8042c9
  802257:	e8 b1 e7 ff ff       	call   800a0d <cprintf>
  80225c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802265:	a1 40 51 80 00       	mov    0x805140,%eax
  80226a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802271:	74 07                	je     80227a <print_mem_block_lists+0x9e>
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	eb 05                	jmp    80227f <print_mem_block_lists+0xa3>
  80227a:	b8 00 00 00 00       	mov    $0x0,%eax
  80227f:	a3 40 51 80 00       	mov    %eax,0x805140
  802284:	a1 40 51 80 00       	mov    0x805140,%eax
  802289:	85 c0                	test   %eax,%eax
  80228b:	75 8a                	jne    802217 <print_mem_block_lists+0x3b>
  80228d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802291:	75 84                	jne    802217 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802293:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802297:	75 10                	jne    8022a9 <print_mem_block_lists+0xcd>
  802299:	83 ec 0c             	sub    $0xc,%esp
  80229c:	68 d8 42 80 00       	push   $0x8042d8
  8022a1:	e8 67 e7 ff ff       	call   800a0d <cprintf>
  8022a6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8022a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8022b0:	83 ec 0c             	sub    $0xc,%esp
  8022b3:	68 fc 42 80 00       	push   $0x8042fc
  8022b8:	e8 50 e7 ff ff       	call   800a0d <cprintf>
  8022bd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8022c0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022c4:	a1 40 50 80 00       	mov    0x805040,%eax
  8022c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022cc:	eb 56                	jmp    802324 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d2:	74 1c                	je     8022f0 <print_mem_block_lists+0x114>
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 50 08             	mov    0x8(%eax),%edx
  8022da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022dd:	8b 48 08             	mov    0x8(%eax),%ecx
  8022e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e6:	01 c8                	add    %ecx,%eax
  8022e8:	39 c2                	cmp    %eax,%edx
  8022ea:	73 04                	jae    8022f0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8022ec:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 50 08             	mov    0x8(%eax),%edx
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fc:	01 c2                	add    %eax,%edx
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	8b 40 08             	mov    0x8(%eax),%eax
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	52                   	push   %edx
  802308:	50                   	push   %eax
  802309:	68 c9 42 80 00       	push   $0x8042c9
  80230e:	e8 fa e6 ff ff       	call   800a0d <cprintf>
  802313:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80231c:	a1 48 50 80 00       	mov    0x805048,%eax
  802321:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802328:	74 07                	je     802331 <print_mem_block_lists+0x155>
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	8b 00                	mov    (%eax),%eax
  80232f:	eb 05                	jmp    802336 <print_mem_block_lists+0x15a>
  802331:	b8 00 00 00 00       	mov    $0x0,%eax
  802336:	a3 48 50 80 00       	mov    %eax,0x805048
  80233b:	a1 48 50 80 00       	mov    0x805048,%eax
  802340:	85 c0                	test   %eax,%eax
  802342:	75 8a                	jne    8022ce <print_mem_block_lists+0xf2>
  802344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802348:	75 84                	jne    8022ce <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80234a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80234e:	75 10                	jne    802360 <print_mem_block_lists+0x184>
  802350:	83 ec 0c             	sub    $0xc,%esp
  802353:	68 14 43 80 00       	push   $0x804314
  802358:	e8 b0 e6 ff ff       	call   800a0d <cprintf>
  80235d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802360:	83 ec 0c             	sub    $0xc,%esp
  802363:	68 88 42 80 00       	push   $0x804288
  802368:	e8 a0 e6 ff ff       	call   800a0d <cprintf>
  80236d:	83 c4 10             	add    $0x10,%esp

}
  802370:	90                   	nop
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802379:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802380:	00 00 00 
  802383:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80238a:	00 00 00 
  80238d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802394:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80239e:	e9 9e 00 00 00       	jmp    802441 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8023a3:	a1 50 50 80 00       	mov    0x805050,%eax
  8023a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ab:	c1 e2 04             	shl    $0x4,%edx
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	85 c0                	test   %eax,%eax
  8023b2:	75 14                	jne    8023c8 <initialize_MemBlocksList+0x55>
  8023b4:	83 ec 04             	sub    $0x4,%esp
  8023b7:	68 3c 43 80 00       	push   $0x80433c
  8023bc:	6a 46                	push   $0x46
  8023be:	68 5f 43 80 00       	push   $0x80435f
  8023c3:	e8 91 e3 ff ff       	call   800759 <_panic>
  8023c8:	a1 50 50 80 00       	mov    0x805050,%eax
  8023cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d0:	c1 e2 04             	shl    $0x4,%edx
  8023d3:	01 d0                	add    %edx,%eax
  8023d5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8023db:	89 10                	mov    %edx,(%eax)
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	74 18                	je     8023fb <initialize_MemBlocksList+0x88>
  8023e3:	a1 48 51 80 00       	mov    0x805148,%eax
  8023e8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8023ee:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023f1:	c1 e1 04             	shl    $0x4,%ecx
  8023f4:	01 ca                	add    %ecx,%edx
  8023f6:	89 50 04             	mov    %edx,0x4(%eax)
  8023f9:	eb 12                	jmp    80240d <initialize_MemBlocksList+0x9a>
  8023fb:	a1 50 50 80 00       	mov    0x805050,%eax
  802400:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802403:	c1 e2 04             	shl    $0x4,%edx
  802406:	01 d0                	add    %edx,%eax
  802408:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80240d:	a1 50 50 80 00       	mov    0x805050,%eax
  802412:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802415:	c1 e2 04             	shl    $0x4,%edx
  802418:	01 d0                	add    %edx,%eax
  80241a:	a3 48 51 80 00       	mov    %eax,0x805148
  80241f:	a1 50 50 80 00       	mov    0x805050,%eax
  802424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802427:	c1 e2 04             	shl    $0x4,%edx
  80242a:	01 d0                	add    %edx,%eax
  80242c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802433:	a1 54 51 80 00       	mov    0x805154,%eax
  802438:	40                   	inc    %eax
  802439:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80243e:	ff 45 f4             	incl   -0xc(%ebp)
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	3b 45 08             	cmp    0x8(%ebp),%eax
  802447:	0f 82 56 ff ff ff    	jb     8023a3 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80244d:	90                   	nop
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	8b 00                	mov    (%eax),%eax
  80245b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80245e:	eb 19                	jmp    802479 <find_block+0x29>
	{
		if(va==point->sva)
  802460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802463:	8b 40 08             	mov    0x8(%eax),%eax
  802466:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802469:	75 05                	jne    802470 <find_block+0x20>
		   return point;
  80246b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80246e:	eb 36                	jmp    8024a6 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	8b 40 08             	mov    0x8(%eax),%eax
  802476:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802479:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80247d:	74 07                	je     802486 <find_block+0x36>
  80247f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802482:	8b 00                	mov    (%eax),%eax
  802484:	eb 05                	jmp    80248b <find_block+0x3b>
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
  80248b:	8b 55 08             	mov    0x8(%ebp),%edx
  80248e:	89 42 08             	mov    %eax,0x8(%edx)
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	8b 40 08             	mov    0x8(%eax),%eax
  802497:	85 c0                	test   %eax,%eax
  802499:	75 c5                	jne    802460 <find_block+0x10>
  80249b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80249f:	75 bf                	jne    802460 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8024a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a6:	c9                   	leave  
  8024a7:	c3                   	ret    

008024a8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8024ae:	a1 40 50 80 00       	mov    0x805040,%eax
  8024b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8024b6:	a1 44 50 80 00       	mov    0x805044,%eax
  8024bb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8024be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024c4:	74 24                	je     8024ea <insert_sorted_allocList+0x42>
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	8b 50 08             	mov    0x8(%eax),%edx
  8024cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cf:	8b 40 08             	mov    0x8(%eax),%eax
  8024d2:	39 c2                	cmp    %eax,%edx
  8024d4:	76 14                	jbe    8024ea <insert_sorted_allocList+0x42>
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	8b 50 08             	mov    0x8(%eax),%edx
  8024dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024df:	8b 40 08             	mov    0x8(%eax),%eax
  8024e2:	39 c2                	cmp    %eax,%edx
  8024e4:	0f 82 60 01 00 00    	jb     80264a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8024ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024ee:	75 65                	jne    802555 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8024f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f4:	75 14                	jne    80250a <insert_sorted_allocList+0x62>
  8024f6:	83 ec 04             	sub    $0x4,%esp
  8024f9:	68 3c 43 80 00       	push   $0x80433c
  8024fe:	6a 6b                	push   $0x6b
  802500:	68 5f 43 80 00       	push   $0x80435f
  802505:	e8 4f e2 ff ff       	call   800759 <_panic>
  80250a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	89 10                	mov    %edx,(%eax)
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	85 c0                	test   %eax,%eax
  80251c:	74 0d                	je     80252b <insert_sorted_allocList+0x83>
  80251e:	a1 40 50 80 00       	mov    0x805040,%eax
  802523:	8b 55 08             	mov    0x8(%ebp),%edx
  802526:	89 50 04             	mov    %edx,0x4(%eax)
  802529:	eb 08                	jmp    802533 <insert_sorted_allocList+0x8b>
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	a3 44 50 80 00       	mov    %eax,0x805044
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	a3 40 50 80 00       	mov    %eax,0x805040
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802545:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80254a:	40                   	inc    %eax
  80254b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802550:	e9 dc 01 00 00       	jmp    802731 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	8b 50 08             	mov    0x8(%eax),%edx
  80255b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255e:	8b 40 08             	mov    0x8(%eax),%eax
  802561:	39 c2                	cmp    %eax,%edx
  802563:	77 6c                	ja     8025d1 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802565:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802569:	74 06                	je     802571 <insert_sorted_allocList+0xc9>
  80256b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80256f:	75 14                	jne    802585 <insert_sorted_allocList+0xdd>
  802571:	83 ec 04             	sub    $0x4,%esp
  802574:	68 78 43 80 00       	push   $0x804378
  802579:	6a 6f                	push   $0x6f
  80257b:	68 5f 43 80 00       	push   $0x80435f
  802580:	e8 d4 e1 ff ff       	call   800759 <_panic>
  802585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802588:	8b 50 04             	mov    0x4(%eax),%edx
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	89 50 04             	mov    %edx,0x4(%eax)
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802597:	89 10                	mov    %edx,(%eax)
  802599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259c:	8b 40 04             	mov    0x4(%eax),%eax
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	74 0d                	je     8025b0 <insert_sorted_allocList+0x108>
  8025a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a6:	8b 40 04             	mov    0x4(%eax),%eax
  8025a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ac:	89 10                	mov    %edx,(%eax)
  8025ae:	eb 08                	jmp    8025b8 <insert_sorted_allocList+0x110>
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	a3 40 50 80 00       	mov    %eax,0x805040
  8025b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8025be:	89 50 04             	mov    %edx,0x4(%eax)
  8025c1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025c6:	40                   	inc    %eax
  8025c7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025cc:	e9 60 01 00 00       	jmp    802731 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	8b 50 08             	mov    0x8(%eax),%edx
  8025d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025da:	8b 40 08             	mov    0x8(%eax),%eax
  8025dd:	39 c2                	cmp    %eax,%edx
  8025df:	0f 82 4c 01 00 00    	jb     802731 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8025e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025e9:	75 14                	jne    8025ff <insert_sorted_allocList+0x157>
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	68 b0 43 80 00       	push   $0x8043b0
  8025f3:	6a 73                	push   $0x73
  8025f5:	68 5f 43 80 00       	push   $0x80435f
  8025fa:	e8 5a e1 ff ff       	call   800759 <_panic>
  8025ff:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802605:	8b 45 08             	mov    0x8(%ebp),%eax
  802608:	89 50 04             	mov    %edx,0x4(%eax)
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	8b 40 04             	mov    0x4(%eax),%eax
  802611:	85 c0                	test   %eax,%eax
  802613:	74 0c                	je     802621 <insert_sorted_allocList+0x179>
  802615:	a1 44 50 80 00       	mov    0x805044,%eax
  80261a:	8b 55 08             	mov    0x8(%ebp),%edx
  80261d:	89 10                	mov    %edx,(%eax)
  80261f:	eb 08                	jmp    802629 <insert_sorted_allocList+0x181>
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	a3 40 50 80 00       	mov    %eax,0x805040
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	a3 44 50 80 00       	mov    %eax,0x805044
  802631:	8b 45 08             	mov    0x8(%ebp),%eax
  802634:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80263f:	40                   	inc    %eax
  802640:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802645:	e9 e7 00 00 00       	jmp    802731 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80264a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802650:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802657:	a1 40 50 80 00       	mov    0x805040,%eax
  80265c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265f:	e9 9d 00 00 00       	jmp    802701 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	8b 50 08             	mov    0x8(%eax),%edx
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 40 08             	mov    0x8(%eax),%eax
  802678:	39 c2                	cmp    %eax,%edx
  80267a:	76 7d                	jbe    8026f9 <insert_sorted_allocList+0x251>
  80267c:	8b 45 08             	mov    0x8(%ebp),%eax
  80267f:	8b 50 08             	mov    0x8(%eax),%edx
  802682:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802685:	8b 40 08             	mov    0x8(%eax),%eax
  802688:	39 c2                	cmp    %eax,%edx
  80268a:	73 6d                	jae    8026f9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80268c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802690:	74 06                	je     802698 <insert_sorted_allocList+0x1f0>
  802692:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802696:	75 14                	jne    8026ac <insert_sorted_allocList+0x204>
  802698:	83 ec 04             	sub    $0x4,%esp
  80269b:	68 d4 43 80 00       	push   $0x8043d4
  8026a0:	6a 7f                	push   $0x7f
  8026a2:	68 5f 43 80 00       	push   $0x80435f
  8026a7:	e8 ad e0 ff ff       	call   800759 <_panic>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 10                	mov    (%eax),%edx
  8026b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b4:	89 10                	mov    %edx,(%eax)
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	8b 00                	mov    (%eax),%eax
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	74 0b                	je     8026ca <insert_sorted_allocList+0x222>
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d0:	89 10                	mov    %edx,(%eax)
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d8:	89 50 04             	mov    %edx,0x4(%eax)
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	8b 00                	mov    (%eax),%eax
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	75 08                	jne    8026ec <insert_sorted_allocList+0x244>
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	a3 44 50 80 00       	mov    %eax,0x805044
  8026ec:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026f1:	40                   	inc    %eax
  8026f2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8026f7:	eb 39                	jmp    802732 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026f9:	a1 48 50 80 00       	mov    0x805048,%eax
  8026fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802701:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802705:	74 07                	je     80270e <insert_sorted_allocList+0x266>
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	eb 05                	jmp    802713 <insert_sorted_allocList+0x26b>
  80270e:	b8 00 00 00 00       	mov    $0x0,%eax
  802713:	a3 48 50 80 00       	mov    %eax,0x805048
  802718:	a1 48 50 80 00       	mov    0x805048,%eax
  80271d:	85 c0                	test   %eax,%eax
  80271f:	0f 85 3f ff ff ff    	jne    802664 <insert_sorted_allocList+0x1bc>
  802725:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802729:	0f 85 35 ff ff ff    	jne    802664 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80272f:	eb 01                	jmp    802732 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802731:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802732:	90                   	nop
  802733:	c9                   	leave  
  802734:	c3                   	ret    

00802735 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
  802738:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80273b:	a1 38 51 80 00       	mov    0x805138,%eax
  802740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802743:	e9 85 01 00 00       	jmp    8028cd <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 40 0c             	mov    0xc(%eax),%eax
  80274e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802751:	0f 82 6e 01 00 00    	jb     8028c5 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 40 0c             	mov    0xc(%eax),%eax
  80275d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802760:	0f 85 8a 00 00 00    	jne    8027f0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802766:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276a:	75 17                	jne    802783 <alloc_block_FF+0x4e>
  80276c:	83 ec 04             	sub    $0x4,%esp
  80276f:	68 08 44 80 00       	push   $0x804408
  802774:	68 93 00 00 00       	push   $0x93
  802779:	68 5f 43 80 00       	push   $0x80435f
  80277e:	e8 d6 df ff ff       	call   800759 <_panic>
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	85 c0                	test   %eax,%eax
  80278a:	74 10                	je     80279c <alloc_block_FF+0x67>
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802794:	8b 52 04             	mov    0x4(%edx),%edx
  802797:	89 50 04             	mov    %edx,0x4(%eax)
  80279a:	eb 0b                	jmp    8027a7 <alloc_block_FF+0x72>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 40 04             	mov    0x4(%eax),%eax
  8027a2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 40 04             	mov    0x4(%eax),%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	74 0f                	je     8027c0 <alloc_block_FF+0x8b>
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 40 04             	mov    0x4(%eax),%eax
  8027b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ba:	8b 12                	mov    (%edx),%edx
  8027bc:	89 10                	mov    %edx,(%eax)
  8027be:	eb 0a                	jmp    8027ca <alloc_block_FF+0x95>
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 00                	mov    (%eax),%eax
  8027c5:	a3 38 51 80 00       	mov    %eax,0x805138
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8027e2:	48                   	dec    %eax
  8027e3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	e9 10 01 00 00       	jmp    802900 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f9:	0f 86 c6 00 00 00    	jbe    8028c5 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027ff:	a1 48 51 80 00       	mov    0x805148,%eax
  802804:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 50 08             	mov    0x8(%eax),%edx
  80280d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802810:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802816:	8b 55 08             	mov    0x8(%ebp),%edx
  802819:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80281c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802820:	75 17                	jne    802839 <alloc_block_FF+0x104>
  802822:	83 ec 04             	sub    $0x4,%esp
  802825:	68 08 44 80 00       	push   $0x804408
  80282a:	68 9b 00 00 00       	push   $0x9b
  80282f:	68 5f 43 80 00       	push   $0x80435f
  802834:	e8 20 df ff ff       	call   800759 <_panic>
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 10                	je     802852 <alloc_block_FF+0x11d>
  802842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284a:	8b 52 04             	mov    0x4(%edx),%edx
  80284d:	89 50 04             	mov    %edx,0x4(%eax)
  802850:	eb 0b                	jmp    80285d <alloc_block_FF+0x128>
  802852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80285d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	74 0f                	je     802876 <alloc_block_FF+0x141>
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802870:	8b 12                	mov    (%edx),%edx
  802872:	89 10                	mov    %edx,(%eax)
  802874:	eb 0a                	jmp    802880 <alloc_block_FF+0x14b>
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	a3 48 51 80 00       	mov    %eax,0x805148
  802880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802893:	a1 54 51 80 00       	mov    0x805154,%eax
  802898:	48                   	dec    %eax
  802899:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 50 08             	mov    0x8(%eax),%edx
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	01 c2                	add    %eax,%edx
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8028b8:	89 c2                	mov    %eax,%edx
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	eb 3b                	jmp    802900 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d1:	74 07                	je     8028da <alloc_block_FF+0x1a5>
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 00                	mov    (%eax),%eax
  8028d8:	eb 05                	jmp    8028df <alloc_block_FF+0x1aa>
  8028da:	b8 00 00 00 00       	mov    $0x0,%eax
  8028df:	a3 40 51 80 00       	mov    %eax,0x805140
  8028e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e9:	85 c0                	test   %eax,%eax
  8028eb:	0f 85 57 fe ff ff    	jne    802748 <alloc_block_FF+0x13>
  8028f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f5:	0f 85 4d fe ff ff    	jne    802748 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8028fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
  802905:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802908:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80290f:	a1 38 51 80 00       	mov    0x805138,%eax
  802914:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802917:	e9 df 00 00 00       	jmp    8029fb <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 40 0c             	mov    0xc(%eax),%eax
  802922:	3b 45 08             	cmp    0x8(%ebp),%eax
  802925:	0f 82 c8 00 00 00    	jb     8029f3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 40 0c             	mov    0xc(%eax),%eax
  802931:	3b 45 08             	cmp    0x8(%ebp),%eax
  802934:	0f 85 8a 00 00 00    	jne    8029c4 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80293a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293e:	75 17                	jne    802957 <alloc_block_BF+0x55>
  802940:	83 ec 04             	sub    $0x4,%esp
  802943:	68 08 44 80 00       	push   $0x804408
  802948:	68 b7 00 00 00       	push   $0xb7
  80294d:	68 5f 43 80 00       	push   $0x80435f
  802952:	e8 02 de ff ff       	call   800759 <_panic>
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	74 10                	je     802970 <alloc_block_BF+0x6e>
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802968:	8b 52 04             	mov    0x4(%edx),%edx
  80296b:	89 50 04             	mov    %edx,0x4(%eax)
  80296e:	eb 0b                	jmp    80297b <alloc_block_BF+0x79>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 04             	mov    0x4(%eax),%eax
  802976:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 04             	mov    0x4(%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	74 0f                	je     802994 <alloc_block_BF+0x92>
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 40 04             	mov    0x4(%eax),%eax
  80298b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298e:	8b 12                	mov    (%edx),%edx
  802990:	89 10                	mov    %edx,(%eax)
  802992:	eb 0a                	jmp    80299e <alloc_block_BF+0x9c>
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	a3 38 51 80 00       	mov    %eax,0x805138
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8029b6:	48                   	dec    %eax
  8029b7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	e9 4d 01 00 00       	jmp    802b11 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cd:	76 24                	jbe    8029f3 <alloc_block_BF+0xf1>
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029d8:	73 19                	jae    8029f3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8029da:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 40 08             	mov    0x8(%eax),%eax
  8029f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ff:	74 07                	je     802a08 <alloc_block_BF+0x106>
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	eb 05                	jmp    802a0d <alloc_block_BF+0x10b>
  802a08:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0d:	a3 40 51 80 00       	mov    %eax,0x805140
  802a12:	a1 40 51 80 00       	mov    0x805140,%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	0f 85 fd fe ff ff    	jne    80291c <alloc_block_BF+0x1a>
  802a1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a23:	0f 85 f3 fe ff ff    	jne    80291c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802a29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a2d:	0f 84 d9 00 00 00    	je     802b0c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a33:	a1 48 51 80 00       	mov    0x805148,%eax
  802a38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a41:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a47:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802a4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a51:	75 17                	jne    802a6a <alloc_block_BF+0x168>
  802a53:	83 ec 04             	sub    $0x4,%esp
  802a56:	68 08 44 80 00       	push   $0x804408
  802a5b:	68 c7 00 00 00       	push   $0xc7
  802a60:	68 5f 43 80 00       	push   $0x80435f
  802a65:	e8 ef dc ff ff       	call   800759 <_panic>
  802a6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	74 10                	je     802a83 <alloc_block_BF+0x181>
  802a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a76:	8b 00                	mov    (%eax),%eax
  802a78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a7b:	8b 52 04             	mov    0x4(%edx),%edx
  802a7e:	89 50 04             	mov    %edx,0x4(%eax)
  802a81:	eb 0b                	jmp    802a8e <alloc_block_BF+0x18c>
  802a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a86:	8b 40 04             	mov    0x4(%eax),%eax
  802a89:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a91:	8b 40 04             	mov    0x4(%eax),%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	74 0f                	je     802aa7 <alloc_block_BF+0x1a5>
  802a98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a9b:	8b 40 04             	mov    0x4(%eax),%eax
  802a9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aa1:	8b 12                	mov    (%edx),%edx
  802aa3:	89 10                	mov    %edx,(%eax)
  802aa5:	eb 0a                	jmp    802ab1 <alloc_block_BF+0x1af>
  802aa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	a3 48 51 80 00       	mov    %eax,0x805148
  802ab1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802abd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac4:	a1 54 51 80 00       	mov    0x805154,%eax
  802ac9:	48                   	dec    %eax
  802aca:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802acf:	83 ec 08             	sub    $0x8,%esp
  802ad2:	ff 75 ec             	pushl  -0x14(%ebp)
  802ad5:	68 38 51 80 00       	push   $0x805138
  802ada:	e8 71 f9 ff ff       	call   802450 <find_block>
  802adf:	83 c4 10             	add    $0x10,%esp
  802ae2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802ae5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae8:	8b 50 08             	mov    0x8(%eax),%edx
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	01 c2                	add    %eax,%edx
  802af0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af9:	8b 40 0c             	mov    0xc(%eax),%eax
  802afc:	2b 45 08             	sub    0x8(%ebp),%eax
  802aff:	89 c2                	mov    %eax,%edx
  802b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b04:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802b07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b0a:	eb 05                	jmp    802b11 <alloc_block_BF+0x20f>
	}
	return NULL;
  802b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b11:	c9                   	leave  
  802b12:	c3                   	ret    

00802b13 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b13:	55                   	push   %ebp
  802b14:	89 e5                	mov    %esp,%ebp
  802b16:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802b19:	a1 28 50 80 00       	mov    0x805028,%eax
  802b1e:	85 c0                	test   %eax,%eax
  802b20:	0f 85 de 01 00 00    	jne    802d04 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b26:	a1 38 51 80 00       	mov    0x805138,%eax
  802b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2e:	e9 9e 01 00 00       	jmp    802cd1 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 40 0c             	mov    0xc(%eax),%eax
  802b39:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3c:	0f 82 87 01 00 00    	jb     802cc9 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 40 0c             	mov    0xc(%eax),%eax
  802b48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4b:	0f 85 95 00 00 00    	jne    802be6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802b51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b55:	75 17                	jne    802b6e <alloc_block_NF+0x5b>
  802b57:	83 ec 04             	sub    $0x4,%esp
  802b5a:	68 08 44 80 00       	push   $0x804408
  802b5f:	68 e0 00 00 00       	push   $0xe0
  802b64:	68 5f 43 80 00       	push   $0x80435f
  802b69:	e8 eb db ff ff       	call   800759 <_panic>
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	74 10                	je     802b87 <alloc_block_NF+0x74>
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7f:	8b 52 04             	mov    0x4(%edx),%edx
  802b82:	89 50 04             	mov    %edx,0x4(%eax)
  802b85:	eb 0b                	jmp    802b92 <alloc_block_NF+0x7f>
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 40 04             	mov    0x4(%eax),%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	74 0f                	je     802bab <alloc_block_NF+0x98>
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba5:	8b 12                	mov    (%edx),%edx
  802ba7:	89 10                	mov    %edx,(%eax)
  802ba9:	eb 0a                	jmp    802bb5 <alloc_block_NF+0xa2>
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 00                	mov    (%eax),%eax
  802bb0:	a3 38 51 80 00       	mov    %eax,0x805138
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc8:	a1 44 51 80 00       	mov    0x805144,%eax
  802bcd:	48                   	dec    %eax
  802bce:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 40 08             	mov    0x8(%eax),%eax
  802bd9:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	e9 f8 04 00 00       	jmp    8030de <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bef:	0f 86 d4 00 00 00    	jbe    802cc9 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bf5:	a1 48 51 80 00       	mov    0x805148,%eax
  802bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 50 08             	mov    0x8(%eax),%edx
  802c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c06:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c16:	75 17                	jne    802c2f <alloc_block_NF+0x11c>
  802c18:	83 ec 04             	sub    $0x4,%esp
  802c1b:	68 08 44 80 00       	push   $0x804408
  802c20:	68 e9 00 00 00       	push   $0xe9
  802c25:	68 5f 43 80 00       	push   $0x80435f
  802c2a:	e8 2a db ff ff       	call   800759 <_panic>
  802c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	85 c0                	test   %eax,%eax
  802c36:	74 10                	je     802c48 <alloc_block_NF+0x135>
  802c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c40:	8b 52 04             	mov    0x4(%edx),%edx
  802c43:	89 50 04             	mov    %edx,0x4(%eax)
  802c46:	eb 0b                	jmp    802c53 <alloc_block_NF+0x140>
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c56:	8b 40 04             	mov    0x4(%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	74 0f                	je     802c6c <alloc_block_NF+0x159>
  802c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c60:	8b 40 04             	mov    0x4(%eax),%eax
  802c63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c66:	8b 12                	mov    (%edx),%edx
  802c68:	89 10                	mov    %edx,(%eax)
  802c6a:	eb 0a                	jmp    802c76 <alloc_block_NF+0x163>
  802c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	a3 48 51 80 00       	mov    %eax,0x805148
  802c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c89:	a1 54 51 80 00       	mov    0x805154,%eax
  802c8e:	48                   	dec    %eax
  802c8f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c97:	8b 40 08             	mov    0x8(%eax),%eax
  802c9a:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 50 08             	mov    0x8(%eax),%edx
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	01 c2                	add    %eax,%edx
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb6:	2b 45 08             	sub    0x8(%ebp),%eax
  802cb9:	89 c2                	mov    %eax,%edx
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	e9 15 04 00 00       	jmp    8030de <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802cc9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd5:	74 07                	je     802cde <alloc_block_NF+0x1cb>
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	eb 05                	jmp    802ce3 <alloc_block_NF+0x1d0>
  802cde:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce3:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ced:	85 c0                	test   %eax,%eax
  802cef:	0f 85 3e fe ff ff    	jne    802b33 <alloc_block_NF+0x20>
  802cf5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf9:	0f 85 34 fe ff ff    	jne    802b33 <alloc_block_NF+0x20>
  802cff:	e9 d5 03 00 00       	jmp    8030d9 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d04:	a1 38 51 80 00       	mov    0x805138,%eax
  802d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d0c:	e9 b1 01 00 00       	jmp    802ec2 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 50 08             	mov    0x8(%eax),%edx
  802d17:	a1 28 50 80 00       	mov    0x805028,%eax
  802d1c:	39 c2                	cmp    %eax,%edx
  802d1e:	0f 82 96 01 00 00    	jb     802eba <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d2d:	0f 82 87 01 00 00    	jb     802eba <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 40 0c             	mov    0xc(%eax),%eax
  802d39:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d3c:	0f 85 95 00 00 00    	jne    802dd7 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d46:	75 17                	jne    802d5f <alloc_block_NF+0x24c>
  802d48:	83 ec 04             	sub    $0x4,%esp
  802d4b:	68 08 44 80 00       	push   $0x804408
  802d50:	68 fc 00 00 00       	push   $0xfc
  802d55:	68 5f 43 80 00       	push   $0x80435f
  802d5a:	e8 fa d9 ff ff       	call   800759 <_panic>
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 00                	mov    (%eax),%eax
  802d64:	85 c0                	test   %eax,%eax
  802d66:	74 10                	je     802d78 <alloc_block_NF+0x265>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d70:	8b 52 04             	mov    0x4(%edx),%edx
  802d73:	89 50 04             	mov    %edx,0x4(%eax)
  802d76:	eb 0b                	jmp    802d83 <alloc_block_NF+0x270>
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 04             	mov    0x4(%eax),%eax
  802d7e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 40 04             	mov    0x4(%eax),%eax
  802d89:	85 c0                	test   %eax,%eax
  802d8b:	74 0f                	je     802d9c <alloc_block_NF+0x289>
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 40 04             	mov    0x4(%eax),%eax
  802d93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d96:	8b 12                	mov    (%edx),%edx
  802d98:	89 10                	mov    %edx,(%eax)
  802d9a:	eb 0a                	jmp    802da6 <alloc_block_NF+0x293>
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 00                	mov    (%eax),%eax
  802da1:	a3 38 51 80 00       	mov    %eax,0x805138
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db9:	a1 44 51 80 00       	mov    0x805144,%eax
  802dbe:	48                   	dec    %eax
  802dbf:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 40 08             	mov    0x8(%eax),%eax
  802dca:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	e9 07 03 00 00       	jmp    8030de <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de0:	0f 86 d4 00 00 00    	jbe    802eba <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802de6:	a1 48 51 80 00       	mov    0x805148,%eax
  802deb:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 50 08             	mov    0x8(%eax),%edx
  802df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802dfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  802e00:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e03:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e07:	75 17                	jne    802e20 <alloc_block_NF+0x30d>
  802e09:	83 ec 04             	sub    $0x4,%esp
  802e0c:	68 08 44 80 00       	push   $0x804408
  802e11:	68 04 01 00 00       	push   $0x104
  802e16:	68 5f 43 80 00       	push   $0x80435f
  802e1b:	e8 39 d9 ff ff       	call   800759 <_panic>
  802e20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e23:	8b 00                	mov    (%eax),%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	74 10                	je     802e39 <alloc_block_NF+0x326>
  802e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e31:	8b 52 04             	mov    0x4(%edx),%edx
  802e34:	89 50 04             	mov    %edx,0x4(%eax)
  802e37:	eb 0b                	jmp    802e44 <alloc_block_NF+0x331>
  802e39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3c:	8b 40 04             	mov    0x4(%eax),%eax
  802e3f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e47:	8b 40 04             	mov    0x4(%eax),%eax
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	74 0f                	je     802e5d <alloc_block_NF+0x34a>
  802e4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e51:	8b 40 04             	mov    0x4(%eax),%eax
  802e54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e57:	8b 12                	mov    (%edx),%edx
  802e59:	89 10                	mov    %edx,(%eax)
  802e5b:	eb 0a                	jmp    802e67 <alloc_block_NF+0x354>
  802e5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	a3 48 51 80 00       	mov    %eax,0x805148
  802e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e7f:	48                   	dec    %eax
  802e80:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e88:	8b 40 08             	mov    0x8(%eax),%eax
  802e8b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 50 08             	mov    0x8(%eax),%edx
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	01 c2                	add    %eax,%edx
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea7:	2b 45 08             	sub    0x8(%ebp),%eax
  802eaa:	89 c2                	mov    %eax,%edx
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb5:	e9 24 02 00 00       	jmp    8030de <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802eba:	a1 40 51 80 00       	mov    0x805140,%eax
  802ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec6:	74 07                	je     802ecf <alloc_block_NF+0x3bc>
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 00                	mov    (%eax),%eax
  802ecd:	eb 05                	jmp    802ed4 <alloc_block_NF+0x3c1>
  802ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed4:	a3 40 51 80 00       	mov    %eax,0x805140
  802ed9:	a1 40 51 80 00       	mov    0x805140,%eax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	0f 85 2b fe ff ff    	jne    802d11 <alloc_block_NF+0x1fe>
  802ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eea:	0f 85 21 fe ff ff    	jne    802d11 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ef0:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef8:	e9 ae 01 00 00       	jmp    8030ab <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 50 08             	mov    0x8(%eax),%edx
  802f03:	a1 28 50 80 00       	mov    0x805028,%eax
  802f08:	39 c2                	cmp    %eax,%edx
  802f0a:	0f 83 93 01 00 00    	jae    8030a3 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 40 0c             	mov    0xc(%eax),%eax
  802f16:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f19:	0f 82 84 01 00 00    	jb     8030a3 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 40 0c             	mov    0xc(%eax),%eax
  802f25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f28:	0f 85 95 00 00 00    	jne    802fc3 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f32:	75 17                	jne    802f4b <alloc_block_NF+0x438>
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	68 08 44 80 00       	push   $0x804408
  802f3c:	68 14 01 00 00       	push   $0x114
  802f41:	68 5f 43 80 00       	push   $0x80435f
  802f46:	e8 0e d8 ff ff       	call   800759 <_panic>
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	74 10                	je     802f64 <alloc_block_NF+0x451>
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5c:	8b 52 04             	mov    0x4(%edx),%edx
  802f5f:	89 50 04             	mov    %edx,0x4(%eax)
  802f62:	eb 0b                	jmp    802f6f <alloc_block_NF+0x45c>
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 40 04             	mov    0x4(%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 0f                	je     802f88 <alloc_block_NF+0x475>
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f82:	8b 12                	mov    (%edx),%edx
  802f84:	89 10                	mov    %edx,(%eax)
  802f86:	eb 0a                	jmp    802f92 <alloc_block_NF+0x47f>
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	a3 38 51 80 00       	mov    %eax,0x805138
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa5:	a1 44 51 80 00       	mov    0x805144,%eax
  802faa:	48                   	dec    %eax
  802fab:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 40 08             	mov    0x8(%eax),%eax
  802fb6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	e9 1b 01 00 00       	jmp    8030de <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fcc:	0f 86 d1 00 00 00    	jbe    8030a3 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fd2:	a1 48 51 80 00       	mov    0x805148,%eax
  802fd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 50 08             	mov    0x8(%eax),%edx
  802fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fec:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ff3:	75 17                	jne    80300c <alloc_block_NF+0x4f9>
  802ff5:	83 ec 04             	sub    $0x4,%esp
  802ff8:	68 08 44 80 00       	push   $0x804408
  802ffd:	68 1c 01 00 00       	push   $0x11c
  803002:	68 5f 43 80 00       	push   $0x80435f
  803007:	e8 4d d7 ff ff       	call   800759 <_panic>
  80300c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	85 c0                	test   %eax,%eax
  803013:	74 10                	je     803025 <alloc_block_NF+0x512>
  803015:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80301d:	8b 52 04             	mov    0x4(%edx),%edx
  803020:	89 50 04             	mov    %edx,0x4(%eax)
  803023:	eb 0b                	jmp    803030 <alloc_block_NF+0x51d>
  803025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803028:	8b 40 04             	mov    0x4(%eax),%eax
  80302b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803033:	8b 40 04             	mov    0x4(%eax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	74 0f                	je     803049 <alloc_block_NF+0x536>
  80303a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303d:	8b 40 04             	mov    0x4(%eax),%eax
  803040:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803043:	8b 12                	mov    (%edx),%edx
  803045:	89 10                	mov    %edx,(%eax)
  803047:	eb 0a                	jmp    803053 <alloc_block_NF+0x540>
  803049:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	a3 48 51 80 00       	mov    %eax,0x805148
  803053:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803056:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803066:	a1 54 51 80 00       	mov    0x805154,%eax
  80306b:	48                   	dec    %eax
  80306c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803071:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803074:	8b 40 08             	mov    0x8(%eax),%eax
  803077:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 50 08             	mov    0x8(%eax),%edx
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	01 c2                	add    %eax,%edx
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803090:	8b 40 0c             	mov    0xc(%eax),%eax
  803093:	2b 45 08             	sub    0x8(%ebp),%eax
  803096:	89 c2                	mov    %eax,%edx
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80309e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a1:	eb 3b                	jmp    8030de <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8030a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030af:	74 07                	je     8030b8 <alloc_block_NF+0x5a5>
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	eb 05                	jmp    8030bd <alloc_block_NF+0x5aa>
  8030b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030bd:	a3 40 51 80 00       	mov    %eax,0x805140
  8030c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8030c7:	85 c0                	test   %eax,%eax
  8030c9:	0f 85 2e fe ff ff    	jne    802efd <alloc_block_NF+0x3ea>
  8030cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d3:	0f 85 24 fe ff ff    	jne    802efd <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8030d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030de:	c9                   	leave  
  8030df:	c3                   	ret    

008030e0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030e0:	55                   	push   %ebp
  8030e1:	89 e5                	mov    %esp,%ebp
  8030e3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8030e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8030eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8030ee:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030f3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8030f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 14                	je     803113 <insert_sorted_with_merge_freeList+0x33>
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	8b 50 08             	mov    0x8(%eax),%edx
  803105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803108:	8b 40 08             	mov    0x8(%eax),%eax
  80310b:	39 c2                	cmp    %eax,%edx
  80310d:	0f 87 9b 01 00 00    	ja     8032ae <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803113:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803117:	75 17                	jne    803130 <insert_sorted_with_merge_freeList+0x50>
  803119:	83 ec 04             	sub    $0x4,%esp
  80311c:	68 3c 43 80 00       	push   $0x80433c
  803121:	68 38 01 00 00       	push   $0x138
  803126:	68 5f 43 80 00       	push   $0x80435f
  80312b:	e8 29 d6 ff ff       	call   800759 <_panic>
  803130:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	89 10                	mov    %edx,(%eax)
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	85 c0                	test   %eax,%eax
  803142:	74 0d                	je     803151 <insert_sorted_with_merge_freeList+0x71>
  803144:	a1 38 51 80 00       	mov    0x805138,%eax
  803149:	8b 55 08             	mov    0x8(%ebp),%edx
  80314c:	89 50 04             	mov    %edx,0x4(%eax)
  80314f:	eb 08                	jmp    803159 <insert_sorted_with_merge_freeList+0x79>
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	a3 38 51 80 00       	mov    %eax,0x805138
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316b:	a1 44 51 80 00       	mov    0x805144,%eax
  803170:	40                   	inc    %eax
  803171:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803176:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80317a:	0f 84 a8 06 00 00    	je     803828 <insert_sorted_with_merge_freeList+0x748>
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	8b 50 08             	mov    0x8(%eax),%edx
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	8b 40 0c             	mov    0xc(%eax),%eax
  80318c:	01 c2                	add    %eax,%edx
  80318e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803191:	8b 40 08             	mov    0x8(%eax),%eax
  803194:	39 c2                	cmp    %eax,%edx
  803196:	0f 85 8c 06 00 00    	jne    803828 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a8:	01 c2                	add    %eax,%edx
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8031b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031b4:	75 17                	jne    8031cd <insert_sorted_with_merge_freeList+0xed>
  8031b6:	83 ec 04             	sub    $0x4,%esp
  8031b9:	68 08 44 80 00       	push   $0x804408
  8031be:	68 3c 01 00 00       	push   $0x13c
  8031c3:	68 5f 43 80 00       	push   $0x80435f
  8031c8:	e8 8c d5 ff ff       	call   800759 <_panic>
  8031cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	85 c0                	test   %eax,%eax
  8031d4:	74 10                	je     8031e6 <insert_sorted_with_merge_freeList+0x106>
  8031d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d9:	8b 00                	mov    (%eax),%eax
  8031db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031de:	8b 52 04             	mov    0x4(%edx),%edx
  8031e1:	89 50 04             	mov    %edx,0x4(%eax)
  8031e4:	eb 0b                	jmp    8031f1 <insert_sorted_with_merge_freeList+0x111>
  8031e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e9:	8b 40 04             	mov    0x4(%eax),%eax
  8031ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f4:	8b 40 04             	mov    0x4(%eax),%eax
  8031f7:	85 c0                	test   %eax,%eax
  8031f9:	74 0f                	je     80320a <insert_sorted_with_merge_freeList+0x12a>
  8031fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fe:	8b 40 04             	mov    0x4(%eax),%eax
  803201:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803204:	8b 12                	mov    (%edx),%edx
  803206:	89 10                	mov    %edx,(%eax)
  803208:	eb 0a                	jmp    803214 <insert_sorted_with_merge_freeList+0x134>
  80320a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320d:	8b 00                	mov    (%eax),%eax
  80320f:	a3 38 51 80 00       	mov    %eax,0x805138
  803214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803217:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803220:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803227:	a1 44 51 80 00       	mov    0x805144,%eax
  80322c:	48                   	dec    %eax
  80322d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803235:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80323c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803246:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80324a:	75 17                	jne    803263 <insert_sorted_with_merge_freeList+0x183>
  80324c:	83 ec 04             	sub    $0x4,%esp
  80324f:	68 3c 43 80 00       	push   $0x80433c
  803254:	68 3f 01 00 00       	push   $0x13f
  803259:	68 5f 43 80 00       	push   $0x80435f
  80325e:	e8 f6 d4 ff ff       	call   800759 <_panic>
  803263:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326c:	89 10                	mov    %edx,(%eax)
  80326e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	85 c0                	test   %eax,%eax
  803275:	74 0d                	je     803284 <insert_sorted_with_merge_freeList+0x1a4>
  803277:	a1 48 51 80 00       	mov    0x805148,%eax
  80327c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80327f:	89 50 04             	mov    %edx,0x4(%eax)
  803282:	eb 08                	jmp    80328c <insert_sorted_with_merge_freeList+0x1ac>
  803284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803287:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80328c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328f:	a3 48 51 80 00       	mov    %eax,0x805148
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329e:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a3:	40                   	inc    %eax
  8032a4:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032a9:	e9 7a 05 00 00       	jmp    803828 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	8b 50 08             	mov    0x8(%eax),%edx
  8032b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b7:	8b 40 08             	mov    0x8(%eax),%eax
  8032ba:	39 c2                	cmp    %eax,%edx
  8032bc:	0f 82 14 01 00 00    	jb     8033d6 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8032c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c5:	8b 50 08             	mov    0x8(%eax),%edx
  8032c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ce:	01 c2                	add    %eax,%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 40 08             	mov    0x8(%eax),%eax
  8032d6:	39 c2                	cmp    %eax,%edx
  8032d8:	0f 85 90 00 00 00    	jne    80336e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8032de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e1:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ea:	01 c2                	add    %eax,%edx
  8032ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ef:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803306:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330a:	75 17                	jne    803323 <insert_sorted_with_merge_freeList+0x243>
  80330c:	83 ec 04             	sub    $0x4,%esp
  80330f:	68 3c 43 80 00       	push   $0x80433c
  803314:	68 49 01 00 00       	push   $0x149
  803319:	68 5f 43 80 00       	push   $0x80435f
  80331e:	e8 36 d4 ff ff       	call   800759 <_panic>
  803323:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803329:	8b 45 08             	mov    0x8(%ebp),%eax
  80332c:	89 10                	mov    %edx,(%eax)
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	8b 00                	mov    (%eax),%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	74 0d                	je     803344 <insert_sorted_with_merge_freeList+0x264>
  803337:	a1 48 51 80 00       	mov    0x805148,%eax
  80333c:	8b 55 08             	mov    0x8(%ebp),%edx
  80333f:	89 50 04             	mov    %edx,0x4(%eax)
  803342:	eb 08                	jmp    80334c <insert_sorted_with_merge_freeList+0x26c>
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	a3 48 51 80 00       	mov    %eax,0x805148
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335e:	a1 54 51 80 00       	mov    0x805154,%eax
  803363:	40                   	inc    %eax
  803364:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803369:	e9 bb 04 00 00       	jmp    803829 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80336e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803372:	75 17                	jne    80338b <insert_sorted_with_merge_freeList+0x2ab>
  803374:	83 ec 04             	sub    $0x4,%esp
  803377:	68 b0 43 80 00       	push   $0x8043b0
  80337c:	68 4c 01 00 00       	push   $0x14c
  803381:	68 5f 43 80 00       	push   $0x80435f
  803386:	e8 ce d3 ff ff       	call   800759 <_panic>
  80338b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	89 50 04             	mov    %edx,0x4(%eax)
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	8b 40 04             	mov    0x4(%eax),%eax
  80339d:	85 c0                	test   %eax,%eax
  80339f:	74 0c                	je     8033ad <insert_sorted_with_merge_freeList+0x2cd>
  8033a1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a9:	89 10                	mov    %edx,(%eax)
  8033ab:	eb 08                	jmp    8033b5 <insert_sorted_with_merge_freeList+0x2d5>
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c6:	a1 44 51 80 00       	mov    0x805144,%eax
  8033cb:	40                   	inc    %eax
  8033cc:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033d1:	e9 53 04 00 00       	jmp    803829 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8033db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033de:	e9 15 04 00 00       	jmp    8037f8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8033e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e6:	8b 00                	mov    (%eax),%eax
  8033e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	8b 50 08             	mov    0x8(%eax),%edx
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	8b 40 08             	mov    0x8(%eax),%eax
  8033f7:	39 c2                	cmp    %eax,%edx
  8033f9:	0f 86 f1 03 00 00    	jbe    8037f0 <insert_sorted_with_merge_freeList+0x710>
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	8b 50 08             	mov    0x8(%eax),%edx
  803405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803408:	8b 40 08             	mov    0x8(%eax),%eax
  80340b:	39 c2                	cmp    %eax,%edx
  80340d:	0f 83 dd 03 00 00    	jae    8037f0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803416:	8b 50 08             	mov    0x8(%eax),%edx
  803419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341c:	8b 40 0c             	mov    0xc(%eax),%eax
  80341f:	01 c2                	add    %eax,%edx
  803421:	8b 45 08             	mov    0x8(%ebp),%eax
  803424:	8b 40 08             	mov    0x8(%eax),%eax
  803427:	39 c2                	cmp    %eax,%edx
  803429:	0f 85 b9 01 00 00    	jne    8035e8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	8b 50 08             	mov    0x8(%eax),%edx
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	8b 40 0c             	mov    0xc(%eax),%eax
  80343b:	01 c2                	add    %eax,%edx
  80343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803440:	8b 40 08             	mov    0x8(%eax),%eax
  803443:	39 c2                	cmp    %eax,%edx
  803445:	0f 85 0d 01 00 00    	jne    803558 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80344b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344e:	8b 50 0c             	mov    0xc(%eax),%edx
  803451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803454:	8b 40 0c             	mov    0xc(%eax),%eax
  803457:	01 c2                	add    %eax,%edx
  803459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80345f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803463:	75 17                	jne    80347c <insert_sorted_with_merge_freeList+0x39c>
  803465:	83 ec 04             	sub    $0x4,%esp
  803468:	68 08 44 80 00       	push   $0x804408
  80346d:	68 5c 01 00 00       	push   $0x15c
  803472:	68 5f 43 80 00       	push   $0x80435f
  803477:	e8 dd d2 ff ff       	call   800759 <_panic>
  80347c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	74 10                	je     803495 <insert_sorted_with_merge_freeList+0x3b5>
  803485:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803488:	8b 00                	mov    (%eax),%eax
  80348a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80348d:	8b 52 04             	mov    0x4(%edx),%edx
  803490:	89 50 04             	mov    %edx,0x4(%eax)
  803493:	eb 0b                	jmp    8034a0 <insert_sorted_with_merge_freeList+0x3c0>
  803495:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803498:	8b 40 04             	mov    0x4(%eax),%eax
  80349b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a3:	8b 40 04             	mov    0x4(%eax),%eax
  8034a6:	85 c0                	test   %eax,%eax
  8034a8:	74 0f                	je     8034b9 <insert_sorted_with_merge_freeList+0x3d9>
  8034aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ad:	8b 40 04             	mov    0x4(%eax),%eax
  8034b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034b3:	8b 12                	mov    (%edx),%edx
  8034b5:	89 10                	mov    %edx,(%eax)
  8034b7:	eb 0a                	jmp    8034c3 <insert_sorted_with_merge_freeList+0x3e3>
  8034b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bc:	8b 00                	mov    (%eax),%eax
  8034be:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d6:	a1 44 51 80 00       	mov    0x805144,%eax
  8034db:	48                   	dec    %eax
  8034dc:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8034e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8034eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034f9:	75 17                	jne    803512 <insert_sorted_with_merge_freeList+0x432>
  8034fb:	83 ec 04             	sub    $0x4,%esp
  8034fe:	68 3c 43 80 00       	push   $0x80433c
  803503:	68 5f 01 00 00       	push   $0x15f
  803508:	68 5f 43 80 00       	push   $0x80435f
  80350d:	e8 47 d2 ff ff       	call   800759 <_panic>
  803512:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803518:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351b:	89 10                	mov    %edx,(%eax)
  80351d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803520:	8b 00                	mov    (%eax),%eax
  803522:	85 c0                	test   %eax,%eax
  803524:	74 0d                	je     803533 <insert_sorted_with_merge_freeList+0x453>
  803526:	a1 48 51 80 00       	mov    0x805148,%eax
  80352b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80352e:	89 50 04             	mov    %edx,0x4(%eax)
  803531:	eb 08                	jmp    80353b <insert_sorted_with_merge_freeList+0x45b>
  803533:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803536:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80353b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353e:	a3 48 51 80 00       	mov    %eax,0x805148
  803543:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803546:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354d:	a1 54 51 80 00       	mov    0x805154,%eax
  803552:	40                   	inc    %eax
  803553:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355b:	8b 50 0c             	mov    0xc(%eax),%edx
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	8b 40 0c             	mov    0xc(%eax),%eax
  803564:	01 c2                	add    %eax,%edx
  803566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803569:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803580:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803584:	75 17                	jne    80359d <insert_sorted_with_merge_freeList+0x4bd>
  803586:	83 ec 04             	sub    $0x4,%esp
  803589:	68 3c 43 80 00       	push   $0x80433c
  80358e:	68 64 01 00 00       	push   $0x164
  803593:	68 5f 43 80 00       	push   $0x80435f
  803598:	e8 bc d1 ff ff       	call   800759 <_panic>
  80359d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	89 10                	mov    %edx,(%eax)
  8035a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ab:	8b 00                	mov    (%eax),%eax
  8035ad:	85 c0                	test   %eax,%eax
  8035af:	74 0d                	je     8035be <insert_sorted_with_merge_freeList+0x4de>
  8035b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8035b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8035b9:	89 50 04             	mov    %edx,0x4(%eax)
  8035bc:	eb 08                	jmp    8035c6 <insert_sorted_with_merge_freeList+0x4e6>
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c9:	a3 48 51 80 00       	mov    %eax,0x805148
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8035dd:	40                   	inc    %eax
  8035de:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035e3:	e9 41 02 00 00       	jmp    803829 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	8b 50 08             	mov    0x8(%eax),%edx
  8035ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f4:	01 c2                	add    %eax,%edx
  8035f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f9:	8b 40 08             	mov    0x8(%eax),%eax
  8035fc:	39 c2                	cmp    %eax,%edx
  8035fe:	0f 85 7c 01 00 00    	jne    803780 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803604:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803608:	74 06                	je     803610 <insert_sorted_with_merge_freeList+0x530>
  80360a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80360e:	75 17                	jne    803627 <insert_sorted_with_merge_freeList+0x547>
  803610:	83 ec 04             	sub    $0x4,%esp
  803613:	68 78 43 80 00       	push   $0x804378
  803618:	68 69 01 00 00       	push   $0x169
  80361d:	68 5f 43 80 00       	push   $0x80435f
  803622:	e8 32 d1 ff ff       	call   800759 <_panic>
  803627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362a:	8b 50 04             	mov    0x4(%eax),%edx
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	89 50 04             	mov    %edx,0x4(%eax)
  803633:	8b 45 08             	mov    0x8(%ebp),%eax
  803636:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803639:	89 10                	mov    %edx,(%eax)
  80363b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363e:	8b 40 04             	mov    0x4(%eax),%eax
  803641:	85 c0                	test   %eax,%eax
  803643:	74 0d                	je     803652 <insert_sorted_with_merge_freeList+0x572>
  803645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803648:	8b 40 04             	mov    0x4(%eax),%eax
  80364b:	8b 55 08             	mov    0x8(%ebp),%edx
  80364e:	89 10                	mov    %edx,(%eax)
  803650:	eb 08                	jmp    80365a <insert_sorted_with_merge_freeList+0x57a>
  803652:	8b 45 08             	mov    0x8(%ebp),%eax
  803655:	a3 38 51 80 00       	mov    %eax,0x805138
  80365a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365d:	8b 55 08             	mov    0x8(%ebp),%edx
  803660:	89 50 04             	mov    %edx,0x4(%eax)
  803663:	a1 44 51 80 00       	mov    0x805144,%eax
  803668:	40                   	inc    %eax
  803669:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	8b 50 0c             	mov    0xc(%eax),%edx
  803674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803677:	8b 40 0c             	mov    0xc(%eax),%eax
  80367a:	01 c2                	add    %eax,%edx
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803682:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803686:	75 17                	jne    80369f <insert_sorted_with_merge_freeList+0x5bf>
  803688:	83 ec 04             	sub    $0x4,%esp
  80368b:	68 08 44 80 00       	push   $0x804408
  803690:	68 6b 01 00 00       	push   $0x16b
  803695:	68 5f 43 80 00       	push   $0x80435f
  80369a:	e8 ba d0 ff ff       	call   800759 <_panic>
  80369f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a2:	8b 00                	mov    (%eax),%eax
  8036a4:	85 c0                	test   %eax,%eax
  8036a6:	74 10                	je     8036b8 <insert_sorted_with_merge_freeList+0x5d8>
  8036a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ab:	8b 00                	mov    (%eax),%eax
  8036ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b0:	8b 52 04             	mov    0x4(%edx),%edx
  8036b3:	89 50 04             	mov    %edx,0x4(%eax)
  8036b6:	eb 0b                	jmp    8036c3 <insert_sorted_with_merge_freeList+0x5e3>
  8036b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bb:	8b 40 04             	mov    0x4(%eax),%eax
  8036be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c6:	8b 40 04             	mov    0x4(%eax),%eax
  8036c9:	85 c0                	test   %eax,%eax
  8036cb:	74 0f                	je     8036dc <insert_sorted_with_merge_freeList+0x5fc>
  8036cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d0:	8b 40 04             	mov    0x4(%eax),%eax
  8036d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036d6:	8b 12                	mov    (%edx),%edx
  8036d8:	89 10                	mov    %edx,(%eax)
  8036da:	eb 0a                	jmp    8036e6 <insert_sorted_with_merge_freeList+0x606>
  8036dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036df:	8b 00                	mov    (%eax),%eax
  8036e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8036e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f9:	a1 44 51 80 00       	mov    0x805144,%eax
  8036fe:	48                   	dec    %eax
  8036ff:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803707:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80370e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803711:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803718:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80371c:	75 17                	jne    803735 <insert_sorted_with_merge_freeList+0x655>
  80371e:	83 ec 04             	sub    $0x4,%esp
  803721:	68 3c 43 80 00       	push   $0x80433c
  803726:	68 6e 01 00 00       	push   $0x16e
  80372b:	68 5f 43 80 00       	push   $0x80435f
  803730:	e8 24 d0 ff ff       	call   800759 <_panic>
  803735:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80373b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373e:	89 10                	mov    %edx,(%eax)
  803740:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803743:	8b 00                	mov    (%eax),%eax
  803745:	85 c0                	test   %eax,%eax
  803747:	74 0d                	je     803756 <insert_sorted_with_merge_freeList+0x676>
  803749:	a1 48 51 80 00       	mov    0x805148,%eax
  80374e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803751:	89 50 04             	mov    %edx,0x4(%eax)
  803754:	eb 08                	jmp    80375e <insert_sorted_with_merge_freeList+0x67e>
  803756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803759:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80375e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803761:	a3 48 51 80 00       	mov    %eax,0x805148
  803766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803769:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803770:	a1 54 51 80 00       	mov    0x805154,%eax
  803775:	40                   	inc    %eax
  803776:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80377b:	e9 a9 00 00 00       	jmp    803829 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803784:	74 06                	je     80378c <insert_sorted_with_merge_freeList+0x6ac>
  803786:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80378a:	75 17                	jne    8037a3 <insert_sorted_with_merge_freeList+0x6c3>
  80378c:	83 ec 04             	sub    $0x4,%esp
  80378f:	68 d4 43 80 00       	push   $0x8043d4
  803794:	68 73 01 00 00       	push   $0x173
  803799:	68 5f 43 80 00       	push   $0x80435f
  80379e:	e8 b6 cf ff ff       	call   800759 <_panic>
  8037a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a6:	8b 10                	mov    (%eax),%edx
  8037a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ab:	89 10                	mov    %edx,(%eax)
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	8b 00                	mov    (%eax),%eax
  8037b2:	85 c0                	test   %eax,%eax
  8037b4:	74 0b                	je     8037c1 <insert_sorted_with_merge_freeList+0x6e1>
  8037b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b9:	8b 00                	mov    (%eax),%eax
  8037bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8037be:	89 50 04             	mov    %edx,0x4(%eax)
  8037c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c7:	89 10                	mov    %edx,(%eax)
  8037c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037cf:	89 50 04             	mov    %edx,0x4(%eax)
  8037d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d5:	8b 00                	mov    (%eax),%eax
  8037d7:	85 c0                	test   %eax,%eax
  8037d9:	75 08                	jne    8037e3 <insert_sorted_with_merge_freeList+0x703>
  8037db:	8b 45 08             	mov    0x8(%ebp),%eax
  8037de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8037e8:	40                   	inc    %eax
  8037e9:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8037ee:	eb 39                	jmp    803829 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8037f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8037f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037fc:	74 07                	je     803805 <insert_sorted_with_merge_freeList+0x725>
  8037fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803801:	8b 00                	mov    (%eax),%eax
  803803:	eb 05                	jmp    80380a <insert_sorted_with_merge_freeList+0x72a>
  803805:	b8 00 00 00 00       	mov    $0x0,%eax
  80380a:	a3 40 51 80 00       	mov    %eax,0x805140
  80380f:	a1 40 51 80 00       	mov    0x805140,%eax
  803814:	85 c0                	test   %eax,%eax
  803816:	0f 85 c7 fb ff ff    	jne    8033e3 <insert_sorted_with_merge_freeList+0x303>
  80381c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803820:	0f 85 bd fb ff ff    	jne    8033e3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803826:	eb 01                	jmp    803829 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803828:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803829:	90                   	nop
  80382a:	c9                   	leave  
  80382b:	c3                   	ret    

0080382c <__udivdi3>:
  80382c:	55                   	push   %ebp
  80382d:	57                   	push   %edi
  80382e:	56                   	push   %esi
  80382f:	53                   	push   %ebx
  803830:	83 ec 1c             	sub    $0x1c,%esp
  803833:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803837:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80383b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80383f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803843:	89 ca                	mov    %ecx,%edx
  803845:	89 f8                	mov    %edi,%eax
  803847:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80384b:	85 f6                	test   %esi,%esi
  80384d:	75 2d                	jne    80387c <__udivdi3+0x50>
  80384f:	39 cf                	cmp    %ecx,%edi
  803851:	77 65                	ja     8038b8 <__udivdi3+0x8c>
  803853:	89 fd                	mov    %edi,%ebp
  803855:	85 ff                	test   %edi,%edi
  803857:	75 0b                	jne    803864 <__udivdi3+0x38>
  803859:	b8 01 00 00 00       	mov    $0x1,%eax
  80385e:	31 d2                	xor    %edx,%edx
  803860:	f7 f7                	div    %edi
  803862:	89 c5                	mov    %eax,%ebp
  803864:	31 d2                	xor    %edx,%edx
  803866:	89 c8                	mov    %ecx,%eax
  803868:	f7 f5                	div    %ebp
  80386a:	89 c1                	mov    %eax,%ecx
  80386c:	89 d8                	mov    %ebx,%eax
  80386e:	f7 f5                	div    %ebp
  803870:	89 cf                	mov    %ecx,%edi
  803872:	89 fa                	mov    %edi,%edx
  803874:	83 c4 1c             	add    $0x1c,%esp
  803877:	5b                   	pop    %ebx
  803878:	5e                   	pop    %esi
  803879:	5f                   	pop    %edi
  80387a:	5d                   	pop    %ebp
  80387b:	c3                   	ret    
  80387c:	39 ce                	cmp    %ecx,%esi
  80387e:	77 28                	ja     8038a8 <__udivdi3+0x7c>
  803880:	0f bd fe             	bsr    %esi,%edi
  803883:	83 f7 1f             	xor    $0x1f,%edi
  803886:	75 40                	jne    8038c8 <__udivdi3+0x9c>
  803888:	39 ce                	cmp    %ecx,%esi
  80388a:	72 0a                	jb     803896 <__udivdi3+0x6a>
  80388c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803890:	0f 87 9e 00 00 00    	ja     803934 <__udivdi3+0x108>
  803896:	b8 01 00 00 00       	mov    $0x1,%eax
  80389b:	89 fa                	mov    %edi,%edx
  80389d:	83 c4 1c             	add    $0x1c,%esp
  8038a0:	5b                   	pop    %ebx
  8038a1:	5e                   	pop    %esi
  8038a2:	5f                   	pop    %edi
  8038a3:	5d                   	pop    %ebp
  8038a4:	c3                   	ret    
  8038a5:	8d 76 00             	lea    0x0(%esi),%esi
  8038a8:	31 ff                	xor    %edi,%edi
  8038aa:	31 c0                	xor    %eax,%eax
  8038ac:	89 fa                	mov    %edi,%edx
  8038ae:	83 c4 1c             	add    $0x1c,%esp
  8038b1:	5b                   	pop    %ebx
  8038b2:	5e                   	pop    %esi
  8038b3:	5f                   	pop    %edi
  8038b4:	5d                   	pop    %ebp
  8038b5:	c3                   	ret    
  8038b6:	66 90                	xchg   %ax,%ax
  8038b8:	89 d8                	mov    %ebx,%eax
  8038ba:	f7 f7                	div    %edi
  8038bc:	31 ff                	xor    %edi,%edi
  8038be:	89 fa                	mov    %edi,%edx
  8038c0:	83 c4 1c             	add    $0x1c,%esp
  8038c3:	5b                   	pop    %ebx
  8038c4:	5e                   	pop    %esi
  8038c5:	5f                   	pop    %edi
  8038c6:	5d                   	pop    %ebp
  8038c7:	c3                   	ret    
  8038c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038cd:	89 eb                	mov    %ebp,%ebx
  8038cf:	29 fb                	sub    %edi,%ebx
  8038d1:	89 f9                	mov    %edi,%ecx
  8038d3:	d3 e6                	shl    %cl,%esi
  8038d5:	89 c5                	mov    %eax,%ebp
  8038d7:	88 d9                	mov    %bl,%cl
  8038d9:	d3 ed                	shr    %cl,%ebp
  8038db:	89 e9                	mov    %ebp,%ecx
  8038dd:	09 f1                	or     %esi,%ecx
  8038df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038e3:	89 f9                	mov    %edi,%ecx
  8038e5:	d3 e0                	shl    %cl,%eax
  8038e7:	89 c5                	mov    %eax,%ebp
  8038e9:	89 d6                	mov    %edx,%esi
  8038eb:	88 d9                	mov    %bl,%cl
  8038ed:	d3 ee                	shr    %cl,%esi
  8038ef:	89 f9                	mov    %edi,%ecx
  8038f1:	d3 e2                	shl    %cl,%edx
  8038f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038f7:	88 d9                	mov    %bl,%cl
  8038f9:	d3 e8                	shr    %cl,%eax
  8038fb:	09 c2                	or     %eax,%edx
  8038fd:	89 d0                	mov    %edx,%eax
  8038ff:	89 f2                	mov    %esi,%edx
  803901:	f7 74 24 0c          	divl   0xc(%esp)
  803905:	89 d6                	mov    %edx,%esi
  803907:	89 c3                	mov    %eax,%ebx
  803909:	f7 e5                	mul    %ebp
  80390b:	39 d6                	cmp    %edx,%esi
  80390d:	72 19                	jb     803928 <__udivdi3+0xfc>
  80390f:	74 0b                	je     80391c <__udivdi3+0xf0>
  803911:	89 d8                	mov    %ebx,%eax
  803913:	31 ff                	xor    %edi,%edi
  803915:	e9 58 ff ff ff       	jmp    803872 <__udivdi3+0x46>
  80391a:	66 90                	xchg   %ax,%ax
  80391c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803920:	89 f9                	mov    %edi,%ecx
  803922:	d3 e2                	shl    %cl,%edx
  803924:	39 c2                	cmp    %eax,%edx
  803926:	73 e9                	jae    803911 <__udivdi3+0xe5>
  803928:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80392b:	31 ff                	xor    %edi,%edi
  80392d:	e9 40 ff ff ff       	jmp    803872 <__udivdi3+0x46>
  803932:	66 90                	xchg   %ax,%ax
  803934:	31 c0                	xor    %eax,%eax
  803936:	e9 37 ff ff ff       	jmp    803872 <__udivdi3+0x46>
  80393b:	90                   	nop

0080393c <__umoddi3>:
  80393c:	55                   	push   %ebp
  80393d:	57                   	push   %edi
  80393e:	56                   	push   %esi
  80393f:	53                   	push   %ebx
  803940:	83 ec 1c             	sub    $0x1c,%esp
  803943:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803947:	8b 74 24 34          	mov    0x34(%esp),%esi
  80394b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80394f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803953:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803957:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80395b:	89 f3                	mov    %esi,%ebx
  80395d:	89 fa                	mov    %edi,%edx
  80395f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803963:	89 34 24             	mov    %esi,(%esp)
  803966:	85 c0                	test   %eax,%eax
  803968:	75 1a                	jne    803984 <__umoddi3+0x48>
  80396a:	39 f7                	cmp    %esi,%edi
  80396c:	0f 86 a2 00 00 00    	jbe    803a14 <__umoddi3+0xd8>
  803972:	89 c8                	mov    %ecx,%eax
  803974:	89 f2                	mov    %esi,%edx
  803976:	f7 f7                	div    %edi
  803978:	89 d0                	mov    %edx,%eax
  80397a:	31 d2                	xor    %edx,%edx
  80397c:	83 c4 1c             	add    $0x1c,%esp
  80397f:	5b                   	pop    %ebx
  803980:	5e                   	pop    %esi
  803981:	5f                   	pop    %edi
  803982:	5d                   	pop    %ebp
  803983:	c3                   	ret    
  803984:	39 f0                	cmp    %esi,%eax
  803986:	0f 87 ac 00 00 00    	ja     803a38 <__umoddi3+0xfc>
  80398c:	0f bd e8             	bsr    %eax,%ebp
  80398f:	83 f5 1f             	xor    $0x1f,%ebp
  803992:	0f 84 ac 00 00 00    	je     803a44 <__umoddi3+0x108>
  803998:	bf 20 00 00 00       	mov    $0x20,%edi
  80399d:	29 ef                	sub    %ebp,%edi
  80399f:	89 fe                	mov    %edi,%esi
  8039a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039a5:	89 e9                	mov    %ebp,%ecx
  8039a7:	d3 e0                	shl    %cl,%eax
  8039a9:	89 d7                	mov    %edx,%edi
  8039ab:	89 f1                	mov    %esi,%ecx
  8039ad:	d3 ef                	shr    %cl,%edi
  8039af:	09 c7                	or     %eax,%edi
  8039b1:	89 e9                	mov    %ebp,%ecx
  8039b3:	d3 e2                	shl    %cl,%edx
  8039b5:	89 14 24             	mov    %edx,(%esp)
  8039b8:	89 d8                	mov    %ebx,%eax
  8039ba:	d3 e0                	shl    %cl,%eax
  8039bc:	89 c2                	mov    %eax,%edx
  8039be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039c2:	d3 e0                	shl    %cl,%eax
  8039c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039cc:	89 f1                	mov    %esi,%ecx
  8039ce:	d3 e8                	shr    %cl,%eax
  8039d0:	09 d0                	or     %edx,%eax
  8039d2:	d3 eb                	shr    %cl,%ebx
  8039d4:	89 da                	mov    %ebx,%edx
  8039d6:	f7 f7                	div    %edi
  8039d8:	89 d3                	mov    %edx,%ebx
  8039da:	f7 24 24             	mull   (%esp)
  8039dd:	89 c6                	mov    %eax,%esi
  8039df:	89 d1                	mov    %edx,%ecx
  8039e1:	39 d3                	cmp    %edx,%ebx
  8039e3:	0f 82 87 00 00 00    	jb     803a70 <__umoddi3+0x134>
  8039e9:	0f 84 91 00 00 00    	je     803a80 <__umoddi3+0x144>
  8039ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039f3:	29 f2                	sub    %esi,%edx
  8039f5:	19 cb                	sbb    %ecx,%ebx
  8039f7:	89 d8                	mov    %ebx,%eax
  8039f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039fd:	d3 e0                	shl    %cl,%eax
  8039ff:	89 e9                	mov    %ebp,%ecx
  803a01:	d3 ea                	shr    %cl,%edx
  803a03:	09 d0                	or     %edx,%eax
  803a05:	89 e9                	mov    %ebp,%ecx
  803a07:	d3 eb                	shr    %cl,%ebx
  803a09:	89 da                	mov    %ebx,%edx
  803a0b:	83 c4 1c             	add    $0x1c,%esp
  803a0e:	5b                   	pop    %ebx
  803a0f:	5e                   	pop    %esi
  803a10:	5f                   	pop    %edi
  803a11:	5d                   	pop    %ebp
  803a12:	c3                   	ret    
  803a13:	90                   	nop
  803a14:	89 fd                	mov    %edi,%ebp
  803a16:	85 ff                	test   %edi,%edi
  803a18:	75 0b                	jne    803a25 <__umoddi3+0xe9>
  803a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a1f:	31 d2                	xor    %edx,%edx
  803a21:	f7 f7                	div    %edi
  803a23:	89 c5                	mov    %eax,%ebp
  803a25:	89 f0                	mov    %esi,%eax
  803a27:	31 d2                	xor    %edx,%edx
  803a29:	f7 f5                	div    %ebp
  803a2b:	89 c8                	mov    %ecx,%eax
  803a2d:	f7 f5                	div    %ebp
  803a2f:	89 d0                	mov    %edx,%eax
  803a31:	e9 44 ff ff ff       	jmp    80397a <__umoddi3+0x3e>
  803a36:	66 90                	xchg   %ax,%ax
  803a38:	89 c8                	mov    %ecx,%eax
  803a3a:	89 f2                	mov    %esi,%edx
  803a3c:	83 c4 1c             	add    $0x1c,%esp
  803a3f:	5b                   	pop    %ebx
  803a40:	5e                   	pop    %esi
  803a41:	5f                   	pop    %edi
  803a42:	5d                   	pop    %ebp
  803a43:	c3                   	ret    
  803a44:	3b 04 24             	cmp    (%esp),%eax
  803a47:	72 06                	jb     803a4f <__umoddi3+0x113>
  803a49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a4d:	77 0f                	ja     803a5e <__umoddi3+0x122>
  803a4f:	89 f2                	mov    %esi,%edx
  803a51:	29 f9                	sub    %edi,%ecx
  803a53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a57:	89 14 24             	mov    %edx,(%esp)
  803a5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a62:	8b 14 24             	mov    (%esp),%edx
  803a65:	83 c4 1c             	add    $0x1c,%esp
  803a68:	5b                   	pop    %ebx
  803a69:	5e                   	pop    %esi
  803a6a:	5f                   	pop    %edi
  803a6b:	5d                   	pop    %ebp
  803a6c:	c3                   	ret    
  803a6d:	8d 76 00             	lea    0x0(%esi),%esi
  803a70:	2b 04 24             	sub    (%esp),%eax
  803a73:	19 fa                	sbb    %edi,%edx
  803a75:	89 d1                	mov    %edx,%ecx
  803a77:	89 c6                	mov    %eax,%esi
  803a79:	e9 71 ff ff ff       	jmp    8039ef <__umoddi3+0xb3>
  803a7e:	66 90                	xchg   %ax,%ax
  803a80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a84:	72 ea                	jb     803a70 <__umoddi3+0x134>
  803a86:	89 d9                	mov    %ebx,%ecx
  803a88:	e9 62 ff ff ff       	jmp    8039ef <__umoddi3+0xb3>
