
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
  800044:	e8 ac 1f 00 00       	call   801ff5 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 75 3b 80 00       	mov    $0x803b75,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 7f 3b 80 00       	mov    $0x803b7f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 8b 3b 80 00       	mov    $0x803b8b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 9a 3b 80 00       	mov    $0x803b9a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb a9 3b 80 00       	mov    $0x803ba9,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb be 3b 80 00       	mov    $0x803bbe,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb d3 3b 80 00       	mov    $0x803bd3,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb e4 3b 80 00       	mov    $0x803be4,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb f5 3b 80 00       	mov    $0x803bf5,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 06 3c 80 00       	mov    $0x803c06,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 0f 3c 80 00       	mov    $0x803c0f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 19 3c 80 00       	mov    $0x803c19,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 24 3c 80 00       	mov    $0x803c24,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 30 3c 80 00       	mov    $0x803c30,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 3a 3c 80 00       	mov    $0x803c3a,%ebx
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
  8001c1:	bb 44 3c 80 00       	mov    $0x803c44,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 52 3c 80 00       	mov    $0x803c52,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 61 3c 80 00       	mov    $0x803c61,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 68 3c 80 00       	mov    $0x803c68,%ebx
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
  800225:	e8 ae 18 00 00       	call   801ad8 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 99 18 00 00       	call   801ad8 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 84 18 00 00       	call   801ad8 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 6c 18 00 00       	call   801ad8 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 54 18 00 00       	call   801ad8 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 3c 18 00 00       	call   801ad8 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 24 18 00 00       	call   801ad8 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 0c 18 00 00       	call   801ad8 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 f4 17 00 00       	call   801ad8 <sget>
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
  8002f7:	e8 9a 1b 00 00       	call   801e96 <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 85 1b 00 00       	call   801e96 <sys_waitSemaphore>
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
  800344:	e8 6b 1b 00 00       	call   801eb4 <sys_signalSemaphore>
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
  80038b:	e8 06 1b 00 00       	call   801e96 <sys_waitSemaphore>
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
  8003ef:	e8 c0 1a 00 00       	call   801eb4 <sys_signalSemaphore>
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
  800409:	e8 88 1a 00 00       	call   801e96 <sys_waitSemaphore>
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
  80046d:	e8 42 1a 00 00       	call   801eb4 <sys_signalSemaphore>
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
  800487:	e8 0a 1a 00 00       	call   801e96 <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 f5 19 00 00       	call   801e96 <sys_waitSemaphore>
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
  800557:	e8 58 19 00 00       	call   801eb4 <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 43 19 00 00       	call   801eb4 <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 40 3b 80 00       	push   $0x803b40
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 60 3b 80 00       	push   $0x803b60
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb 6f 3c 80 00       	mov    $0x803c6f,%ebx
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
  8005fb:	e8 b4 18 00 00       	call   801eb4 <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 9f 18 00 00       	call   801eb4 <sys_signalSemaphore>
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
  800623:	e8 b4 19 00 00       	call   801fdc <sys_getenvindex>
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
  80068e:	e8 56 17 00 00       	call   801de9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 a8 3c 80 00       	push   $0x803ca8
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
  8006be:	68 d0 3c 80 00       	push   $0x803cd0
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
  8006ef:	68 f8 3c 80 00       	push   $0x803cf8
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 50 3d 80 00       	push   $0x803d50
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 a8 3c 80 00       	push   $0x803ca8
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 d6 16 00 00       	call   801e03 <sys_enable_interrupt>

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
  800740:	e8 63 18 00 00       	call   801fa8 <sys_destroy_env>
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
  800751:	e8 b8 18 00 00       	call   80200e <sys_exit_env>
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
  80077a:	68 64 3d 80 00       	push   $0x803d64
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 69 3d 80 00       	push   $0x803d69
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
  8007b7:	68 85 3d 80 00       	push   $0x803d85
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
  8007e3:	68 88 3d 80 00       	push   $0x803d88
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 d4 3d 80 00       	push   $0x803dd4
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
  8008b5:	68 e0 3d 80 00       	push   $0x803de0
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 d4 3d 80 00       	push   $0x803dd4
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
  800925:	68 34 3e 80 00       	push   $0x803e34
  80092a:	6a 44                	push   $0x44
  80092c:	68 d4 3d 80 00       	push   $0x803dd4
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
  80097f:	e8 b7 12 00 00       	call   801c3b <sys_cputs>
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
  8009f6:	e8 40 12 00 00       	call   801c3b <sys_cputs>
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
  800a40:	e8 a4 13 00 00       	call   801de9 <sys_disable_interrupt>
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
  800a60:	e8 9e 13 00 00       	call   801e03 <sys_enable_interrupt>
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
  800aaa:	e8 11 2e 00 00       	call   8038c0 <__udivdi3>
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
  800afa:	e8 d1 2e 00 00       	call   8039d0 <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 94 40 80 00       	add    $0x804094,%eax
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
  800c55:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
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
  800d36:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 a5 40 80 00       	push   $0x8040a5
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
  800d5b:	68 ae 40 80 00       	push   $0x8040ae
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
  800d88:	be b1 40 80 00       	mov    $0x8040b1,%esi
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
  8017ae:	68 10 42 80 00       	push   $0x804210
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
  80187e:	e8 fc 04 00 00       	call   801d7f <sys_allocate_chunk>
  801883:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801886:	a1 20 51 80 00       	mov    0x805120,%eax
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	50                   	push   %eax
  80188f:	e8 71 0b 00 00       	call   802405 <initialize_MemBlocksList>
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
  8018bc:	68 35 42 80 00       	push   $0x804235
  8018c1:	6a 33                	push   $0x33
  8018c3:	68 53 42 80 00       	push   $0x804253
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
  80193b:	68 60 42 80 00       	push   $0x804260
  801940:	6a 34                	push   $0x34
  801942:	68 53 42 80 00       	push   $0x804253
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
  8019d3:	e8 75 07 00 00       	call   80214d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	74 11                	je     8019ed <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8019dc:	83 ec 0c             	sub    $0xc,%esp
  8019df:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e2:	e8 e0 0d 00 00       	call   8027c7 <alloc_block_FF>
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
  8019f9:	e8 3c 0b 00 00       	call   80253a <insert_sorted_allocList>
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
  801a19:	68 84 42 80 00       	push   $0x804284
  801a1e:	6a 6f                	push   $0x6f
  801a20:	68 53 42 80 00       	push   $0x804253
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
  801a3f:	75 0a                	jne    801a4b <smalloc+0x21>
  801a41:	b8 00 00 00 00       	mov    $0x0,%eax
  801a46:	e9 8b 00 00 00       	jmp    801ad6 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a4b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a58:	01 d0                	add    %edx,%eax
  801a5a:	48                   	dec    %eax
  801a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a61:	ba 00 00 00 00       	mov    $0x0,%edx
  801a66:	f7 75 f0             	divl   -0x10(%ebp)
  801a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a6c:	29 d0                	sub    %edx,%eax
  801a6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a71:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a78:	e8 d0 06 00 00       	call   80214d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	74 11                	je     801a92 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801a81:	83 ec 0c             	sub    $0xc,%esp
  801a84:	ff 75 e8             	pushl  -0x18(%ebp)
  801a87:	e8 3b 0d 00 00       	call   8027c7 <alloc_block_FF>
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801a92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a96:	74 39                	je     801ad1 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9b:	8b 40 08             	mov    0x8(%eax),%eax
  801a9e:	89 c2                	mov    %eax,%edx
  801aa0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801aa4:	52                   	push   %edx
  801aa5:	50                   	push   %eax
  801aa6:	ff 75 0c             	pushl  0xc(%ebp)
  801aa9:	ff 75 08             	pushl  0x8(%ebp)
  801aac:	e8 21 04 00 00       	call   801ed2 <sys_createSharedObject>
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801ab7:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801abb:	74 14                	je     801ad1 <smalloc+0xa7>
  801abd:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801ac1:	74 0e                	je     801ad1 <smalloc+0xa7>
  801ac3:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801ac7:	74 08                	je     801ad1 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acc:	8b 40 08             	mov    0x8(%eax),%eax
  801acf:	eb 05                	jmp    801ad6 <smalloc+0xac>
	}
	return NULL;
  801ad1:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ade:	e8 b4 fc ff ff       	call   801797 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ae3:	83 ec 08             	sub    $0x8,%esp
  801ae6:	ff 75 0c             	pushl  0xc(%ebp)
  801ae9:	ff 75 08             	pushl  0x8(%ebp)
  801aec:	e8 0b 04 00 00       	call   801efc <sys_getSizeOfSharedObject>
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801af7:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801afb:	74 76                	je     801b73 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801afd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0a:	01 d0                	add    %edx,%eax
  801b0c:	48                   	dec    %eax
  801b0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b13:	ba 00 00 00 00       	mov    $0x0,%edx
  801b18:	f7 75 ec             	divl   -0x14(%ebp)
  801b1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b1e:	29 d0                	sub    %edx,%eax
  801b20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801b23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b2a:	e8 1e 06 00 00       	call   80214d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	74 11                	je     801b44 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801b33:	83 ec 0c             	sub    $0xc,%esp
  801b36:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b39:	e8 89 0c 00 00       	call   8027c7 <alloc_block_FF>
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801b44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b48:	74 29                	je     801b73 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4d:	8b 40 08             	mov    0x8(%eax),%eax
  801b50:	83 ec 04             	sub    $0x4,%esp
  801b53:	50                   	push   %eax
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	e8 ba 03 00 00       	call   801f19 <sys_getSharedObject>
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801b65:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801b69:	74 08                	je     801b73 <sget+0x9b>
				return (void *)mem_block->sva;
  801b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6e:	8b 40 08             	mov    0x8(%eax),%eax
  801b71:	eb 05                	jmp    801b78 <sget+0xa0>
		}
	}
	return (void *)NULL;
  801b73:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b80:	e8 12 fc ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b85:	83 ec 04             	sub    $0x4,%esp
  801b88:	68 a8 42 80 00       	push   $0x8042a8
  801b8d:	68 f1 00 00 00       	push   $0xf1
  801b92:	68 53 42 80 00       	push   $0x804253
  801b97:	e8 bd eb ff ff       	call   800759 <_panic>

00801b9c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ba2:	83 ec 04             	sub    $0x4,%esp
  801ba5:	68 d0 42 80 00       	push   $0x8042d0
  801baa:	68 05 01 00 00       	push   $0x105
  801baf:	68 53 42 80 00       	push   $0x804253
  801bb4:	e8 a0 eb ff ff       	call   800759 <_panic>

00801bb9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bbf:	83 ec 04             	sub    $0x4,%esp
  801bc2:	68 f4 42 80 00       	push   $0x8042f4
  801bc7:	68 10 01 00 00       	push   $0x110
  801bcc:	68 53 42 80 00       	push   $0x804253
  801bd1:	e8 83 eb ff ff       	call   800759 <_panic>

00801bd6 <shrink>:

}
void shrink(uint32 newSize)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bdc:	83 ec 04             	sub    $0x4,%esp
  801bdf:	68 f4 42 80 00       	push   $0x8042f4
  801be4:	68 15 01 00 00       	push   $0x115
  801be9:	68 53 42 80 00       	push   $0x804253
  801bee:	e8 66 eb ff ff       	call   800759 <_panic>

00801bf3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	68 f4 42 80 00       	push   $0x8042f4
  801c01:	68 1a 01 00 00       	push   $0x11a
  801c06:	68 53 42 80 00       	push   $0x804253
  801c0b:	e8 49 eb ff ff       	call   800759 <_panic>

00801c10 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	57                   	push   %edi
  801c14:	56                   	push   %esi
  801c15:	53                   	push   %ebx
  801c16:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c22:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c25:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c28:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c2b:	cd 30                	int    $0x30
  801c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5e                   	pop    %esi
  801c38:	5f                   	pop    %edi
  801c39:	5d                   	pop    %ebp
  801c3a:	c3                   	ret    

00801c3b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 04             	sub    $0x4,%esp
  801c41:	8b 45 10             	mov    0x10(%ebp),%eax
  801c44:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c47:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	52                   	push   %edx
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	50                   	push   %eax
  801c57:	6a 00                	push   $0x0
  801c59:	e8 b2 ff ff ff       	call   801c10 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	90                   	nop
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 01                	push   $0x1
  801c73:	e8 98 ff ff ff       	call   801c10 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	52                   	push   %edx
  801c8d:	50                   	push   %eax
  801c8e:	6a 05                	push   $0x5
  801c90:	e8 7b ff ff ff       	call   801c10 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	56                   	push   %esi
  801c9e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c9f:	8b 75 18             	mov    0x18(%ebp),%esi
  801ca2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	51                   	push   %ecx
  801cb1:	52                   	push   %edx
  801cb2:	50                   	push   %eax
  801cb3:	6a 06                	push   $0x6
  801cb5:	e8 56 ff ff ff       	call   801c10 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5e                   	pop    %esi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    

00801cc4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	52                   	push   %edx
  801cd4:	50                   	push   %eax
  801cd5:	6a 07                	push   $0x7
  801cd7:	e8 34 ff ff ff       	call   801c10 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	ff 75 0c             	pushl  0xc(%ebp)
  801ced:	ff 75 08             	pushl  0x8(%ebp)
  801cf0:	6a 08                	push   $0x8
  801cf2:	e8 19 ff ff ff       	call   801c10 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 09                	push   $0x9
  801d0b:	e8 00 ff ff ff       	call   801c10 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 0a                	push   $0xa
  801d24:	e8 e7 fe ff ff       	call   801c10 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 0b                	push   $0xb
  801d3d:	e8 ce fe ff ff       	call   801c10 <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	ff 75 0c             	pushl  0xc(%ebp)
  801d53:	ff 75 08             	pushl  0x8(%ebp)
  801d56:	6a 0f                	push   $0xf
  801d58:	e8 b3 fe ff ff       	call   801c10 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
	return;
  801d60:	90                   	nop
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	ff 75 08             	pushl  0x8(%ebp)
  801d72:	6a 10                	push   $0x10
  801d74:	e8 97 fe ff ff       	call   801c10 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7c:	90                   	nop
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	ff 75 10             	pushl  0x10(%ebp)
  801d89:	ff 75 0c             	pushl  0xc(%ebp)
  801d8c:	ff 75 08             	pushl  0x8(%ebp)
  801d8f:	6a 11                	push   $0x11
  801d91:	e8 7a fe ff ff       	call   801c10 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
	return ;
  801d99:	90                   	nop
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 0c                	push   $0xc
  801dab:	e8 60 fe ff ff       	call   801c10 <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	ff 75 08             	pushl  0x8(%ebp)
  801dc3:	6a 0d                	push   $0xd
  801dc5:	e8 46 fe ff ff       	call   801c10 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_scarce_memory>:

void sys_scarce_memory()
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 0e                	push   $0xe
  801dde:	e8 2d fe ff ff       	call   801c10 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	90                   	nop
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 13                	push   $0x13
  801df8:	e8 13 fe ff ff       	call   801c10 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	90                   	nop
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 14                	push   $0x14
  801e12:	e8 f9 fd ff ff       	call   801c10 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	90                   	nop
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_cputc>:


void
sys_cputc(const char c)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 04             	sub    $0x4,%esp
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	50                   	push   %eax
  801e36:	6a 15                	push   $0x15
  801e38:	e8 d3 fd ff ff       	call   801c10 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
}
  801e40:	90                   	nop
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 16                	push   $0x16
  801e52:	e8 b9 fd ff ff       	call   801c10 <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
}
  801e5a:	90                   	nop
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	50                   	push   %eax
  801e6d:	6a 17                	push   $0x17
  801e6f:	e8 9c fd ff ff       	call   801c10 <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	52                   	push   %edx
  801e89:	50                   	push   %eax
  801e8a:	6a 1a                	push   $0x1a
  801e8c:	e8 7f fd ff ff       	call   801c10 <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	52                   	push   %edx
  801ea6:	50                   	push   %eax
  801ea7:	6a 18                	push   $0x18
  801ea9:	e8 62 fd ff ff       	call   801c10 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
}
  801eb1:	90                   	nop
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	52                   	push   %edx
  801ec4:	50                   	push   %eax
  801ec5:	6a 19                	push   $0x19
  801ec7:	e8 44 fd ff ff       	call   801c10 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 04             	sub    $0x4,%esp
  801ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  801edb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ede:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ee1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	6a 00                	push   $0x0
  801eea:	51                   	push   %ecx
  801eeb:	52                   	push   %edx
  801eec:	ff 75 0c             	pushl  0xc(%ebp)
  801eef:	50                   	push   %eax
  801ef0:	6a 1b                	push   $0x1b
  801ef2:	e8 19 fd ff ff       	call   801c10 <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	52                   	push   %edx
  801f0c:	50                   	push   %eax
  801f0d:	6a 1c                	push   $0x1c
  801f0f:	e8 fc fc ff ff       	call   801c10 <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	51                   	push   %ecx
  801f2a:	52                   	push   %edx
  801f2b:	50                   	push   %eax
  801f2c:	6a 1d                	push   $0x1d
  801f2e:	e8 dd fc ff ff       	call   801c10 <syscall>
  801f33:	83 c4 18             	add    $0x18,%esp
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	52                   	push   %edx
  801f48:	50                   	push   %eax
  801f49:	6a 1e                	push   $0x1e
  801f4b:	e8 c0 fc ff ff       	call   801c10 <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 1f                	push   $0x1f
  801f64:	e8 a7 fc ff ff       	call   801c10 <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	6a 00                	push   $0x0
  801f76:	ff 75 14             	pushl  0x14(%ebp)
  801f79:	ff 75 10             	pushl  0x10(%ebp)
  801f7c:	ff 75 0c             	pushl  0xc(%ebp)
  801f7f:	50                   	push   %eax
  801f80:	6a 20                	push   $0x20
  801f82:	e8 89 fc ff ff       	call   801c10 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	50                   	push   %eax
  801f9b:	6a 21                	push   $0x21
  801f9d:	e8 6e fc ff ff       	call   801c10 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	90                   	nop
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	50                   	push   %eax
  801fb7:	6a 22                	push   $0x22
  801fb9:	e8 52 fc ff ff       	call   801c10 <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 02                	push   $0x2
  801fd2:	e8 39 fc ff ff       	call   801c10 <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 03                	push   $0x3
  801feb:	e8 20 fc ff ff       	call   801c10 <syscall>
  801ff0:	83 c4 18             	add    $0x18,%esp
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 04                	push   $0x4
  802004:	e8 07 fc ff ff       	call   801c10 <syscall>
  802009:	83 c4 18             	add    $0x18,%esp
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <sys_exit_env>:


void sys_exit_env(void)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 23                	push   $0x23
  80201d:	e8 ee fb ff ff       	call   801c10 <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
}
  802025:	90                   	nop
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80202e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802031:	8d 50 04             	lea    0x4(%eax),%edx
  802034:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	52                   	push   %edx
  80203e:	50                   	push   %eax
  80203f:	6a 24                	push   $0x24
  802041:	e8 ca fb ff ff       	call   801c10 <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
	return result;
  802049:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80204c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80204f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802052:	89 01                	mov    %eax,(%ecx)
  802054:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	c9                   	leave  
  80205b:	c2 04 00             	ret    $0x4

0080205e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	ff 75 10             	pushl  0x10(%ebp)
  802068:	ff 75 0c             	pushl  0xc(%ebp)
  80206b:	ff 75 08             	pushl  0x8(%ebp)
  80206e:	6a 12                	push   $0x12
  802070:	e8 9b fb ff ff       	call   801c10 <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
	return ;
  802078:	90                   	nop
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_rcr2>:
uint32 sys_rcr2()
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 25                	push   $0x25
  80208a:	e8 81 fb ff ff       	call   801c10 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 04             	sub    $0x4,%esp
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020a0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	50                   	push   %eax
  8020ad:	6a 26                	push   $0x26
  8020af:	e8 5c fb ff ff       	call   801c10 <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b7:	90                   	nop
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <rsttst>:
void rsttst()
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 28                	push   $0x28
  8020c9:	e8 42 fb ff ff       	call   801c10 <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d1:	90                   	nop
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	8b 45 14             	mov    0x14(%ebp),%eax
  8020dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020e0:	8b 55 18             	mov    0x18(%ebp),%edx
  8020e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020e7:	52                   	push   %edx
  8020e8:	50                   	push   %eax
  8020e9:	ff 75 10             	pushl  0x10(%ebp)
  8020ec:	ff 75 0c             	pushl  0xc(%ebp)
  8020ef:	ff 75 08             	pushl  0x8(%ebp)
  8020f2:	6a 27                	push   $0x27
  8020f4:	e8 17 fb ff ff       	call   801c10 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fc:	90                   	nop
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <chktst>:
void chktst(uint32 n)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	ff 75 08             	pushl  0x8(%ebp)
  80210d:	6a 29                	push   $0x29
  80210f:	e8 fc fa ff ff       	call   801c10 <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
	return ;
  802117:	90                   	nop
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <inctst>:

void inctst()
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 2a                	push   $0x2a
  802129:	e8 e2 fa ff ff       	call   801c10 <syscall>
  80212e:	83 c4 18             	add    $0x18,%esp
	return ;
  802131:	90                   	nop
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <gettst>:
uint32 gettst()
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 2b                	push   $0x2b
  802143:	e8 c8 fa ff ff       	call   801c10 <syscall>
  802148:	83 c4 18             	add    $0x18,%esp
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 2c                	push   $0x2c
  80215f:	e8 ac fa ff ff       	call   801c10 <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
  802167:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80216a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80216e:	75 07                	jne    802177 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802170:	b8 01 00 00 00       	mov    $0x1,%eax
  802175:	eb 05                	jmp    80217c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802177:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 2c                	push   $0x2c
  802190:	e8 7b fa ff ff       	call   801c10 <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
  802198:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80219b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80219f:	75 07                	jne    8021a8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a6:	eb 05                	jmp    8021ad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 2c                	push   $0x2c
  8021c1:	e8 4a fa ff ff       	call   801c10 <syscall>
  8021c6:	83 c4 18             	add    $0x18,%esp
  8021c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021cc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021d0:	75 07                	jne    8021d9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d7:	eb 05                	jmp    8021de <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 2c                	push   $0x2c
  8021f2:	e8 19 fa ff ff       	call   801c10 <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
  8021fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021fd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802201:	75 07                	jne    80220a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802203:	b8 01 00 00 00       	mov    $0x1,%eax
  802208:	eb 05                	jmp    80220f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80220a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	6a 2d                	push   $0x2d
  802221:	e8 ea f9 ff ff       	call   801c10 <syscall>
  802226:	83 c4 18             	add    $0x18,%esp
	return ;
  802229:	90                   	nop
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802230:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802233:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802236:	8b 55 0c             	mov    0xc(%ebp),%edx
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	6a 00                	push   $0x0
  80223e:	53                   	push   %ebx
  80223f:	51                   	push   %ecx
  802240:	52                   	push   %edx
  802241:	50                   	push   %eax
  802242:	6a 2e                	push   $0x2e
  802244:	e8 c7 f9 ff ff       	call   801c10 <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
}
  80224c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802254:	8b 55 0c             	mov    0xc(%ebp),%edx
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	52                   	push   %edx
  802261:	50                   	push   %eax
  802262:	6a 2f                	push   $0x2f
  802264:	e8 a7 f9 ff ff       	call   801c10 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802274:	83 ec 0c             	sub    $0xc,%esp
  802277:	68 04 43 80 00       	push   $0x804304
  80227c:	e8 8c e7 ff ff       	call   800a0d <cprintf>
  802281:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802284:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80228b:	83 ec 0c             	sub    $0xc,%esp
  80228e:	68 30 43 80 00       	push   $0x804330
  802293:	e8 75 e7 ff ff       	call   800a0d <cprintf>
  802298:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80229b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80229f:	a1 38 51 80 00       	mov    0x805138,%eax
  8022a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a7:	eb 56                	jmp    8022ff <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022ad:	74 1c                	je     8022cb <print_mem_block_lists+0x5d>
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 50 08             	mov    0x8(%eax),%edx
  8022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b8:	8b 48 08             	mov    0x8(%eax),%ecx
  8022bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022be:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c1:	01 c8                	add    %ecx,%eax
  8022c3:	39 c2                	cmp    %eax,%edx
  8022c5:	73 04                	jae    8022cb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022c7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	8b 50 08             	mov    0x8(%eax),%edx
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d7:	01 c2                	add    %eax,%edx
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 40 08             	mov    0x8(%eax),%eax
  8022df:	83 ec 04             	sub    $0x4,%esp
  8022e2:	52                   	push   %edx
  8022e3:	50                   	push   %eax
  8022e4:	68 45 43 80 00       	push   $0x804345
  8022e9:	e8 1f e7 ff ff       	call   800a0d <cprintf>
  8022ee:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8022fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802303:	74 07                	je     80230c <print_mem_block_lists+0x9e>
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	eb 05                	jmp    802311 <print_mem_block_lists+0xa3>
  80230c:	b8 00 00 00 00       	mov    $0x0,%eax
  802311:	a3 40 51 80 00       	mov    %eax,0x805140
  802316:	a1 40 51 80 00       	mov    0x805140,%eax
  80231b:	85 c0                	test   %eax,%eax
  80231d:	75 8a                	jne    8022a9 <print_mem_block_lists+0x3b>
  80231f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802323:	75 84                	jne    8022a9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802325:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802329:	75 10                	jne    80233b <print_mem_block_lists+0xcd>
  80232b:	83 ec 0c             	sub    $0xc,%esp
  80232e:	68 54 43 80 00       	push   $0x804354
  802333:	e8 d5 e6 ff ff       	call   800a0d <cprintf>
  802338:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80233b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802342:	83 ec 0c             	sub    $0xc,%esp
  802345:	68 78 43 80 00       	push   $0x804378
  80234a:	e8 be e6 ff ff       	call   800a0d <cprintf>
  80234f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802352:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802356:	a1 40 50 80 00       	mov    0x805040,%eax
  80235b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235e:	eb 56                	jmp    8023b6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802360:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802364:	74 1c                	je     802382 <print_mem_block_lists+0x114>
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 50 08             	mov    0x8(%eax),%edx
  80236c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236f:	8b 48 08             	mov    0x8(%eax),%ecx
  802372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802375:	8b 40 0c             	mov    0xc(%eax),%eax
  802378:	01 c8                	add    %ecx,%eax
  80237a:	39 c2                	cmp    %eax,%edx
  80237c:	73 04                	jae    802382 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80237e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 50 08             	mov    0x8(%eax),%edx
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 40 0c             	mov    0xc(%eax),%eax
  80238e:	01 c2                	add    %eax,%edx
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	8b 40 08             	mov    0x8(%eax),%eax
  802396:	83 ec 04             	sub    $0x4,%esp
  802399:	52                   	push   %edx
  80239a:	50                   	push   %eax
  80239b:	68 45 43 80 00       	push   $0x804345
  8023a0:	e8 68 e6 ff ff       	call   800a0d <cprintf>
  8023a5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023ae:	a1 48 50 80 00       	mov    0x805048,%eax
  8023b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ba:	74 07                	je     8023c3 <print_mem_block_lists+0x155>
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 00                	mov    (%eax),%eax
  8023c1:	eb 05                	jmp    8023c8 <print_mem_block_lists+0x15a>
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c8:	a3 48 50 80 00       	mov    %eax,0x805048
  8023cd:	a1 48 50 80 00       	mov    0x805048,%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	75 8a                	jne    802360 <print_mem_block_lists+0xf2>
  8023d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023da:	75 84                	jne    802360 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023dc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023e0:	75 10                	jne    8023f2 <print_mem_block_lists+0x184>
  8023e2:	83 ec 0c             	sub    $0xc,%esp
  8023e5:	68 90 43 80 00       	push   $0x804390
  8023ea:	e8 1e e6 ff ff       	call   800a0d <cprintf>
  8023ef:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8023f2:	83 ec 0c             	sub    $0xc,%esp
  8023f5:	68 04 43 80 00       	push   $0x804304
  8023fa:	e8 0e e6 ff ff       	call   800a0d <cprintf>
  8023ff:	83 c4 10             	add    $0x10,%esp

}
  802402:	90                   	nop
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80240b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802412:	00 00 00 
  802415:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80241c:	00 00 00 
  80241f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802426:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802429:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802430:	e9 9e 00 00 00       	jmp    8024d3 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802435:	a1 50 50 80 00       	mov    0x805050,%eax
  80243a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243d:	c1 e2 04             	shl    $0x4,%edx
  802440:	01 d0                	add    %edx,%eax
  802442:	85 c0                	test   %eax,%eax
  802444:	75 14                	jne    80245a <initialize_MemBlocksList+0x55>
  802446:	83 ec 04             	sub    $0x4,%esp
  802449:	68 b8 43 80 00       	push   $0x8043b8
  80244e:	6a 46                	push   $0x46
  802450:	68 db 43 80 00       	push   $0x8043db
  802455:	e8 ff e2 ff ff       	call   800759 <_panic>
  80245a:	a1 50 50 80 00       	mov    0x805050,%eax
  80245f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802462:	c1 e2 04             	shl    $0x4,%edx
  802465:	01 d0                	add    %edx,%eax
  802467:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80246d:	89 10                	mov    %edx,(%eax)
  80246f:	8b 00                	mov    (%eax),%eax
  802471:	85 c0                	test   %eax,%eax
  802473:	74 18                	je     80248d <initialize_MemBlocksList+0x88>
  802475:	a1 48 51 80 00       	mov    0x805148,%eax
  80247a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802480:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802483:	c1 e1 04             	shl    $0x4,%ecx
  802486:	01 ca                	add    %ecx,%edx
  802488:	89 50 04             	mov    %edx,0x4(%eax)
  80248b:	eb 12                	jmp    80249f <initialize_MemBlocksList+0x9a>
  80248d:	a1 50 50 80 00       	mov    0x805050,%eax
  802492:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802495:	c1 e2 04             	shl    $0x4,%edx
  802498:	01 d0                	add    %edx,%eax
  80249a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80249f:	a1 50 50 80 00       	mov    0x805050,%eax
  8024a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a7:	c1 e2 04             	shl    $0x4,%edx
  8024aa:	01 d0                	add    %edx,%eax
  8024ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8024b1:	a1 50 50 80 00       	mov    0x805050,%eax
  8024b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b9:	c1 e2 04             	shl    $0x4,%edx
  8024bc:	01 d0                	add    %edx,%eax
  8024be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8024ca:	40                   	inc    %eax
  8024cb:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8024d0:	ff 45 f4             	incl   -0xc(%ebp)
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d9:	0f 82 56 ff ff ff    	jb     802435 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8024df:	90                   	nop
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    

008024e2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	8b 00                	mov    (%eax),%eax
  8024ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024f0:	eb 19                	jmp    80250b <find_block+0x29>
	{
		if(va==point->sva)
  8024f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f5:	8b 40 08             	mov    0x8(%eax),%eax
  8024f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024fb:	75 05                	jne    802502 <find_block+0x20>
		   return point;
  8024fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802500:	eb 36                	jmp    802538 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	8b 40 08             	mov    0x8(%eax),%eax
  802508:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80250f:	74 07                	je     802518 <find_block+0x36>
  802511:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802514:	8b 00                	mov    (%eax),%eax
  802516:	eb 05                	jmp    80251d <find_block+0x3b>
  802518:	b8 00 00 00 00       	mov    $0x0,%eax
  80251d:	8b 55 08             	mov    0x8(%ebp),%edx
  802520:	89 42 08             	mov    %eax,0x8(%edx)
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	8b 40 08             	mov    0x8(%eax),%eax
  802529:	85 c0                	test   %eax,%eax
  80252b:	75 c5                	jne    8024f2 <find_block+0x10>
  80252d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802531:	75 bf                	jne    8024f2 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802540:	a1 40 50 80 00       	mov    0x805040,%eax
  802545:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802548:	a1 44 50 80 00       	mov    0x805044,%eax
  80254d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802553:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802556:	74 24                	je     80257c <insert_sorted_allocList+0x42>
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	8b 50 08             	mov    0x8(%eax),%edx
  80255e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802561:	8b 40 08             	mov    0x8(%eax),%eax
  802564:	39 c2                	cmp    %eax,%edx
  802566:	76 14                	jbe    80257c <insert_sorted_allocList+0x42>
  802568:	8b 45 08             	mov    0x8(%ebp),%eax
  80256b:	8b 50 08             	mov    0x8(%eax),%edx
  80256e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802571:	8b 40 08             	mov    0x8(%eax),%eax
  802574:	39 c2                	cmp    %eax,%edx
  802576:	0f 82 60 01 00 00    	jb     8026dc <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80257c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802580:	75 65                	jne    8025e7 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802582:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802586:	75 14                	jne    80259c <insert_sorted_allocList+0x62>
  802588:	83 ec 04             	sub    $0x4,%esp
  80258b:	68 b8 43 80 00       	push   $0x8043b8
  802590:	6a 6b                	push   $0x6b
  802592:	68 db 43 80 00       	push   $0x8043db
  802597:	e8 bd e1 ff ff       	call   800759 <_panic>
  80259c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	89 10                	mov    %edx,(%eax)
  8025a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	74 0d                	je     8025bd <insert_sorted_allocList+0x83>
  8025b0:	a1 40 50 80 00       	mov    0x805040,%eax
  8025b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b8:	89 50 04             	mov    %edx,0x4(%eax)
  8025bb:	eb 08                	jmp    8025c5 <insert_sorted_allocList+0x8b>
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	a3 44 50 80 00       	mov    %eax,0x805044
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	a3 40 50 80 00       	mov    %eax,0x805040
  8025cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025dc:	40                   	inc    %eax
  8025dd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025e2:	e9 dc 01 00 00       	jmp    8027c3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8025e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ea:	8b 50 08             	mov    0x8(%eax),%edx
  8025ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f0:	8b 40 08             	mov    0x8(%eax),%eax
  8025f3:	39 c2                	cmp    %eax,%edx
  8025f5:	77 6c                	ja     802663 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8025f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025fb:	74 06                	je     802603 <insert_sorted_allocList+0xc9>
  8025fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802601:	75 14                	jne    802617 <insert_sorted_allocList+0xdd>
  802603:	83 ec 04             	sub    $0x4,%esp
  802606:	68 f4 43 80 00       	push   $0x8043f4
  80260b:	6a 6f                	push   $0x6f
  80260d:	68 db 43 80 00       	push   $0x8043db
  802612:	e8 42 e1 ff ff       	call   800759 <_panic>
  802617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261a:	8b 50 04             	mov    0x4(%eax),%edx
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	89 50 04             	mov    %edx,0x4(%eax)
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802629:	89 10                	mov    %edx,(%eax)
  80262b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262e:	8b 40 04             	mov    0x4(%eax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	74 0d                	je     802642 <insert_sorted_allocList+0x108>
  802635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802638:	8b 40 04             	mov    0x4(%eax),%eax
  80263b:	8b 55 08             	mov    0x8(%ebp),%edx
  80263e:	89 10                	mov    %edx,(%eax)
  802640:	eb 08                	jmp    80264a <insert_sorted_allocList+0x110>
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	a3 40 50 80 00       	mov    %eax,0x805040
  80264a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264d:	8b 55 08             	mov    0x8(%ebp),%edx
  802650:	89 50 04             	mov    %edx,0x4(%eax)
  802653:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802658:	40                   	inc    %eax
  802659:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80265e:	e9 60 01 00 00       	jmp    8027c3 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	8b 50 08             	mov    0x8(%eax),%edx
  802669:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266c:	8b 40 08             	mov    0x8(%eax),%eax
  80266f:	39 c2                	cmp    %eax,%edx
  802671:	0f 82 4c 01 00 00    	jb     8027c3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802677:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267b:	75 14                	jne    802691 <insert_sorted_allocList+0x157>
  80267d:	83 ec 04             	sub    $0x4,%esp
  802680:	68 2c 44 80 00       	push   $0x80442c
  802685:	6a 73                	push   $0x73
  802687:	68 db 43 80 00       	push   $0x8043db
  80268c:	e8 c8 e0 ff ff       	call   800759 <_panic>
  802691:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	89 50 04             	mov    %edx,0x4(%eax)
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	8b 40 04             	mov    0x4(%eax),%eax
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	74 0c                	je     8026b3 <insert_sorted_allocList+0x179>
  8026a7:	a1 44 50 80 00       	mov    0x805044,%eax
  8026ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8026af:	89 10                	mov    %edx,(%eax)
  8026b1:	eb 08                	jmp    8026bb <insert_sorted_allocList+0x181>
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	a3 40 50 80 00       	mov    %eax,0x805040
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	a3 44 50 80 00       	mov    %eax,0x805044
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d1:	40                   	inc    %eax
  8026d2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026d7:	e9 e7 00 00 00       	jmp    8027c3 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8026dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8026e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026e9:	a1 40 50 80 00       	mov    0x805040,%eax
  8026ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f1:	e9 9d 00 00 00       	jmp    802793 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	8b 50 08             	mov    0x8(%eax),%edx
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 08             	mov    0x8(%eax),%eax
  80270a:	39 c2                	cmp    %eax,%edx
  80270c:	76 7d                	jbe    80278b <insert_sorted_allocList+0x251>
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	8b 50 08             	mov    0x8(%eax),%edx
  802714:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802717:	8b 40 08             	mov    0x8(%eax),%eax
  80271a:	39 c2                	cmp    %eax,%edx
  80271c:	73 6d                	jae    80278b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80271e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802722:	74 06                	je     80272a <insert_sorted_allocList+0x1f0>
  802724:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802728:	75 14                	jne    80273e <insert_sorted_allocList+0x204>
  80272a:	83 ec 04             	sub    $0x4,%esp
  80272d:	68 50 44 80 00       	push   $0x804450
  802732:	6a 7f                	push   $0x7f
  802734:	68 db 43 80 00       	push   $0x8043db
  802739:	e8 1b e0 ff ff       	call   800759 <_panic>
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	8b 10                	mov    (%eax),%edx
  802743:	8b 45 08             	mov    0x8(%ebp),%eax
  802746:	89 10                	mov    %edx,(%eax)
  802748:	8b 45 08             	mov    0x8(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	74 0b                	je     80275c <insert_sorted_allocList+0x222>
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	8b 55 08             	mov    0x8(%ebp),%edx
  802759:	89 50 04             	mov    %edx,0x4(%eax)
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	8b 55 08             	mov    0x8(%ebp),%edx
  802762:	89 10                	mov    %edx,(%eax)
  802764:	8b 45 08             	mov    0x8(%ebp),%eax
  802767:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276a:	89 50 04             	mov    %edx,0x4(%eax)
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	8b 00                	mov    (%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	75 08                	jne    80277e <insert_sorted_allocList+0x244>
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	a3 44 50 80 00       	mov    %eax,0x805044
  80277e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802783:	40                   	inc    %eax
  802784:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802789:	eb 39                	jmp    8027c4 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80278b:	a1 48 50 80 00       	mov    0x805048,%eax
  802790:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802797:	74 07                	je     8027a0 <insert_sorted_allocList+0x266>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	eb 05                	jmp    8027a5 <insert_sorted_allocList+0x26b>
  8027a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a5:	a3 48 50 80 00       	mov    %eax,0x805048
  8027aa:	a1 48 50 80 00       	mov    0x805048,%eax
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	0f 85 3f ff ff ff    	jne    8026f6 <insert_sorted_allocList+0x1bc>
  8027b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bb:	0f 85 35 ff ff ff    	jne    8026f6 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8027c1:	eb 01                	jmp    8027c4 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027c3:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8027c4:	90                   	nop
  8027c5:	c9                   	leave  
  8027c6:	c3                   	ret    

008027c7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027c7:	55                   	push   %ebp
  8027c8:	89 e5                	mov    %esp,%ebp
  8027ca:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8027cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8027d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d5:	e9 85 01 00 00       	jmp    80295f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e3:	0f 82 6e 01 00 00    	jb     802957 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f2:	0f 85 8a 00 00 00    	jne    802882 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	75 17                	jne    802815 <alloc_block_FF+0x4e>
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	68 84 44 80 00       	push   $0x804484
  802806:	68 93 00 00 00       	push   $0x93
  80280b:	68 db 43 80 00       	push   $0x8043db
  802810:	e8 44 df ff ff       	call   800759 <_panic>
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 10                	je     80282e <alloc_block_FF+0x67>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802826:	8b 52 04             	mov    0x4(%edx),%edx
  802829:	89 50 04             	mov    %edx,0x4(%eax)
  80282c:	eb 0b                	jmp    802839 <alloc_block_FF+0x72>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	74 0f                	je     802852 <alloc_block_FF+0x8b>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284c:	8b 12                	mov    (%edx),%edx
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	eb 0a                	jmp    80285c <alloc_block_FF+0x95>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	a3 38 51 80 00       	mov    %eax,0x805138
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286f:	a1 44 51 80 00       	mov    0x805144,%eax
  802874:	48                   	dec    %eax
  802875:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	e9 10 01 00 00       	jmp    802992 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	8b 40 0c             	mov    0xc(%eax),%eax
  802888:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288b:	0f 86 c6 00 00 00    	jbe    802957 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802891:	a1 48 51 80 00       	mov    0x805148,%eax
  802896:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 50 08             	mov    0x8(%eax),%edx
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8028a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ab:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b2:	75 17                	jne    8028cb <alloc_block_FF+0x104>
  8028b4:	83 ec 04             	sub    $0x4,%esp
  8028b7:	68 84 44 80 00       	push   $0x804484
  8028bc:	68 9b 00 00 00       	push   $0x9b
  8028c1:	68 db 43 80 00       	push   $0x8043db
  8028c6:	e8 8e de ff ff       	call   800759 <_panic>
  8028cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ce:	8b 00                	mov    (%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 10                	je     8028e4 <alloc_block_FF+0x11d>
  8028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028dc:	8b 52 04             	mov    0x4(%edx),%edx
  8028df:	89 50 04             	mov    %edx,0x4(%eax)
  8028e2:	eb 0b                	jmp    8028ef <alloc_block_FF+0x128>
  8028e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0f                	je     802908 <alloc_block_FF+0x141>
  8028f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fc:	8b 40 04             	mov    0x4(%eax),%eax
  8028ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802902:	8b 12                	mov    (%edx),%edx
  802904:	89 10                	mov    %edx,(%eax)
  802906:	eb 0a                	jmp    802912 <alloc_block_FF+0x14b>
  802908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	a3 48 51 80 00       	mov    %eax,0x805148
  802912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802915:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802925:	a1 54 51 80 00       	mov    0x805154,%eax
  80292a:	48                   	dec    %eax
  80292b:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 50 08             	mov    0x8(%eax),%edx
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	01 c2                	add    %eax,%edx
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 40 0c             	mov    0xc(%eax),%eax
  802947:	2b 45 08             	sub    0x8(%ebp),%eax
  80294a:	89 c2                	mov    %eax,%edx
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	eb 3b                	jmp    802992 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802957:	a1 40 51 80 00       	mov    0x805140,%eax
  80295c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802963:	74 07                	je     80296c <alloc_block_FF+0x1a5>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	eb 05                	jmp    802971 <alloc_block_FF+0x1aa>
  80296c:	b8 00 00 00 00       	mov    $0x0,%eax
  802971:	a3 40 51 80 00       	mov    %eax,0x805140
  802976:	a1 40 51 80 00       	mov    0x805140,%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	0f 85 57 fe ff ff    	jne    8027da <alloc_block_FF+0x13>
  802983:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802987:	0f 85 4d fe ff ff    	jne    8027da <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80298d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802992:	c9                   	leave  
  802993:	c3                   	ret    

00802994 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802994:	55                   	push   %ebp
  802995:	89 e5                	mov    %esp,%ebp
  802997:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80299a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8029a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a9:	e9 df 00 00 00       	jmp    802a8d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b7:	0f 82 c8 00 00 00    	jb     802a85 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c6:	0f 85 8a 00 00 00    	jne    802a56 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8029cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d0:	75 17                	jne    8029e9 <alloc_block_BF+0x55>
  8029d2:	83 ec 04             	sub    $0x4,%esp
  8029d5:	68 84 44 80 00       	push   $0x804484
  8029da:	68 b7 00 00 00       	push   $0xb7
  8029df:	68 db 43 80 00       	push   $0x8043db
  8029e4:	e8 70 dd ff ff       	call   800759 <_panic>
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 00                	mov    (%eax),%eax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	74 10                	je     802a02 <alloc_block_BF+0x6e>
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fa:	8b 52 04             	mov    0x4(%edx),%edx
  8029fd:	89 50 04             	mov    %edx,0x4(%eax)
  802a00:	eb 0b                	jmp    802a0d <alloc_block_BF+0x79>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 40 04             	mov    0x4(%eax),%eax
  802a08:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 40 04             	mov    0x4(%eax),%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	74 0f                	je     802a26 <alloc_block_BF+0x92>
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 40 04             	mov    0x4(%eax),%eax
  802a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a20:	8b 12                	mov    (%edx),%edx
  802a22:	89 10                	mov    %edx,(%eax)
  802a24:	eb 0a                	jmp    802a30 <alloc_block_BF+0x9c>
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	a3 38 51 80 00       	mov    %eax,0x805138
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a43:	a1 44 51 80 00       	mov    0x805144,%eax
  802a48:	48                   	dec    %eax
  802a49:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	e9 4d 01 00 00       	jmp    802ba3 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5f:	76 24                	jbe    802a85 <alloc_block_BF+0xf1>
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 40 0c             	mov    0xc(%eax),%eax
  802a67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a6a:	73 19                	jae    802a85 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802a6c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 40 0c             	mov    0xc(%eax),%eax
  802a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 08             	mov    0x8(%eax),%eax
  802a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a85:	a1 40 51 80 00       	mov    0x805140,%eax
  802a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a91:	74 07                	je     802a9a <alloc_block_BF+0x106>
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 00                	mov    (%eax),%eax
  802a98:	eb 05                	jmp    802a9f <alloc_block_BF+0x10b>
  802a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9f:	a3 40 51 80 00       	mov    %eax,0x805140
  802aa4:	a1 40 51 80 00       	mov    0x805140,%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	0f 85 fd fe ff ff    	jne    8029ae <alloc_block_BF+0x1a>
  802ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab5:	0f 85 f3 fe ff ff    	jne    8029ae <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802abb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802abf:	0f 84 d9 00 00 00    	je     802b9e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ac5:	a1 48 51 80 00       	mov    0x805148,%eax
  802aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802acd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad3:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802ad6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad9:	8b 55 08             	mov    0x8(%ebp),%edx
  802adc:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802adf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ae3:	75 17                	jne    802afc <alloc_block_BF+0x168>
  802ae5:	83 ec 04             	sub    $0x4,%esp
  802ae8:	68 84 44 80 00       	push   $0x804484
  802aed:	68 c7 00 00 00       	push   $0xc7
  802af2:	68 db 43 80 00       	push   $0x8043db
  802af7:	e8 5d dc ff ff       	call   800759 <_panic>
  802afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aff:	8b 00                	mov    (%eax),%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	74 10                	je     802b15 <alloc_block_BF+0x181>
  802b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b0d:	8b 52 04             	mov    0x4(%edx),%edx
  802b10:	89 50 04             	mov    %edx,0x4(%eax)
  802b13:	eb 0b                	jmp    802b20 <alloc_block_BF+0x18c>
  802b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b18:	8b 40 04             	mov    0x4(%eax),%eax
  802b1b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b23:	8b 40 04             	mov    0x4(%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 0f                	je     802b39 <alloc_block_BF+0x1a5>
  802b2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b2d:	8b 40 04             	mov    0x4(%eax),%eax
  802b30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b33:	8b 12                	mov    (%edx),%edx
  802b35:	89 10                	mov    %edx,(%eax)
  802b37:	eb 0a                	jmp    802b43 <alloc_block_BF+0x1af>
  802b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	a3 48 51 80 00       	mov    %eax,0x805148
  802b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b56:	a1 54 51 80 00       	mov    0x805154,%eax
  802b5b:	48                   	dec    %eax
  802b5c:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802b61:	83 ec 08             	sub    $0x8,%esp
  802b64:	ff 75 ec             	pushl  -0x14(%ebp)
  802b67:	68 38 51 80 00       	push   $0x805138
  802b6c:	e8 71 f9 ff ff       	call   8024e2 <find_block>
  802b71:	83 c4 10             	add    $0x10,%esp
  802b74:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7a:	8b 50 08             	mov    0x8(%eax),%edx
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	01 c2                	add    %eax,%edx
  802b82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b85:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802b88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8e:	2b 45 08             	sub    0x8(%ebp),%eax
  802b91:	89 c2                	mov    %eax,%edx
  802b93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b96:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802b99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b9c:	eb 05                	jmp    802ba3 <alloc_block_BF+0x20f>
	}
	return NULL;
  802b9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba3:	c9                   	leave  
  802ba4:	c3                   	ret    

00802ba5 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ba5:	55                   	push   %ebp
  802ba6:	89 e5                	mov    %esp,%ebp
  802ba8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802bab:	a1 28 50 80 00       	mov    0x805028,%eax
  802bb0:	85 c0                	test   %eax,%eax
  802bb2:	0f 85 de 01 00 00    	jne    802d96 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802bb8:	a1 38 51 80 00       	mov    0x805138,%eax
  802bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc0:	e9 9e 01 00 00       	jmp    802d63 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bce:	0f 82 87 01 00 00    	jb     802d5b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bda:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bdd:	0f 85 95 00 00 00    	jne    802c78 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802be3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be7:	75 17                	jne    802c00 <alloc_block_NF+0x5b>
  802be9:	83 ec 04             	sub    $0x4,%esp
  802bec:	68 84 44 80 00       	push   $0x804484
  802bf1:	68 e0 00 00 00       	push   $0xe0
  802bf6:	68 db 43 80 00       	push   $0x8043db
  802bfb:	e8 59 db ff ff       	call   800759 <_panic>
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	85 c0                	test   %eax,%eax
  802c07:	74 10                	je     802c19 <alloc_block_NF+0x74>
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c11:	8b 52 04             	mov    0x4(%edx),%edx
  802c14:	89 50 04             	mov    %edx,0x4(%eax)
  802c17:	eb 0b                	jmp    802c24 <alloc_block_NF+0x7f>
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 40 04             	mov    0x4(%eax),%eax
  802c1f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 40 04             	mov    0x4(%eax),%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	74 0f                	je     802c3d <alloc_block_NF+0x98>
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 40 04             	mov    0x4(%eax),%eax
  802c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c37:	8b 12                	mov    (%edx),%edx
  802c39:	89 10                	mov    %edx,(%eax)
  802c3b:	eb 0a                	jmp    802c47 <alloc_block_NF+0xa2>
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	a3 38 51 80 00       	mov    %eax,0x805138
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c5f:	48                   	dec    %eax
  802c60:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 40 08             	mov    0x8(%eax),%eax
  802c6b:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	e9 f8 04 00 00       	jmp    803170 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c81:	0f 86 d4 00 00 00    	jbe    802d5b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c87:	a1 48 51 80 00       	mov    0x805148,%eax
  802c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 50 08             	mov    0x8(%eax),%edx
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca1:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ca4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca8:	75 17                	jne    802cc1 <alloc_block_NF+0x11c>
  802caa:	83 ec 04             	sub    $0x4,%esp
  802cad:	68 84 44 80 00       	push   $0x804484
  802cb2:	68 e9 00 00 00       	push   $0xe9
  802cb7:	68 db 43 80 00       	push   $0x8043db
  802cbc:	e8 98 da ff ff       	call   800759 <_panic>
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	74 10                	je     802cda <alloc_block_NF+0x135>
  802cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd2:	8b 52 04             	mov    0x4(%edx),%edx
  802cd5:	89 50 04             	mov    %edx,0x4(%eax)
  802cd8:	eb 0b                	jmp    802ce5 <alloc_block_NF+0x140>
  802cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	8b 40 04             	mov    0x4(%eax),%eax
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	74 0f                	je     802cfe <alloc_block_NF+0x159>
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf8:	8b 12                	mov    (%edx),%edx
  802cfa:	89 10                	mov    %edx,(%eax)
  802cfc:	eb 0a                	jmp    802d08 <alloc_block_NF+0x163>
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	a3 48 51 80 00       	mov    %eax,0x805148
  802d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1b:	a1 54 51 80 00       	mov    0x805154,%eax
  802d20:	48                   	dec    %eax
  802d21:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d29:	8b 40 08             	mov    0x8(%eax),%eax
  802d2c:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	8b 50 08             	mov    0x8(%eax),%edx
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	01 c2                	add    %eax,%edx
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 0c             	mov    0xc(%eax),%eax
  802d48:	2b 45 08             	sub    0x8(%ebp),%eax
  802d4b:	89 c2                	mov    %eax,%edx
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	e9 15 04 00 00       	jmp    803170 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d5b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d67:	74 07                	je     802d70 <alloc_block_NF+0x1cb>
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 00                	mov    (%eax),%eax
  802d6e:	eb 05                	jmp    802d75 <alloc_block_NF+0x1d0>
  802d70:	b8 00 00 00 00       	mov    $0x0,%eax
  802d75:	a3 40 51 80 00       	mov    %eax,0x805140
  802d7a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	0f 85 3e fe ff ff    	jne    802bc5 <alloc_block_NF+0x20>
  802d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8b:	0f 85 34 fe ff ff    	jne    802bc5 <alloc_block_NF+0x20>
  802d91:	e9 d5 03 00 00       	jmp    80316b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d96:	a1 38 51 80 00       	mov    0x805138,%eax
  802d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d9e:	e9 b1 01 00 00       	jmp    802f54 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 50 08             	mov    0x8(%eax),%edx
  802da9:	a1 28 50 80 00       	mov    0x805028,%eax
  802dae:	39 c2                	cmp    %eax,%edx
  802db0:	0f 82 96 01 00 00    	jb     802f4c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dbf:	0f 82 87 01 00 00    	jb     802f4c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dce:	0f 85 95 00 00 00    	jne    802e69 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802dd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd8:	75 17                	jne    802df1 <alloc_block_NF+0x24c>
  802dda:	83 ec 04             	sub    $0x4,%esp
  802ddd:	68 84 44 80 00       	push   $0x804484
  802de2:	68 fc 00 00 00       	push   $0xfc
  802de7:	68 db 43 80 00       	push   $0x8043db
  802dec:	e8 68 d9 ff ff       	call   800759 <_panic>
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	85 c0                	test   %eax,%eax
  802df8:	74 10                	je     802e0a <alloc_block_NF+0x265>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e02:	8b 52 04             	mov    0x4(%edx),%edx
  802e05:	89 50 04             	mov    %edx,0x4(%eax)
  802e08:	eb 0b                	jmp    802e15 <alloc_block_NF+0x270>
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 40 04             	mov    0x4(%eax),%eax
  802e10:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 40 04             	mov    0x4(%eax),%eax
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	74 0f                	je     802e2e <alloc_block_NF+0x289>
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 40 04             	mov    0x4(%eax),%eax
  802e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e28:	8b 12                	mov    (%edx),%edx
  802e2a:	89 10                	mov    %edx,(%eax)
  802e2c:	eb 0a                	jmp    802e38 <alloc_block_NF+0x293>
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	a3 38 51 80 00       	mov    %eax,0x805138
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4b:	a1 44 51 80 00       	mov    0x805144,%eax
  802e50:	48                   	dec    %eax
  802e51:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 40 08             	mov    0x8(%eax),%eax
  802e5c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	e9 07 03 00 00       	jmp    803170 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e72:	0f 86 d4 00 00 00    	jbe    802f4c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e78:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 50 08             	mov    0x8(%eax),%edx
  802e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e89:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e92:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e95:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e99:	75 17                	jne    802eb2 <alloc_block_NF+0x30d>
  802e9b:	83 ec 04             	sub    $0x4,%esp
  802e9e:	68 84 44 80 00       	push   $0x804484
  802ea3:	68 04 01 00 00       	push   $0x104
  802ea8:	68 db 43 80 00       	push   $0x8043db
  802ead:	e8 a7 d8 ff ff       	call   800759 <_panic>
  802eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb5:	8b 00                	mov    (%eax),%eax
  802eb7:	85 c0                	test   %eax,%eax
  802eb9:	74 10                	je     802ecb <alloc_block_NF+0x326>
  802ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebe:	8b 00                	mov    (%eax),%eax
  802ec0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ec3:	8b 52 04             	mov    0x4(%edx),%edx
  802ec6:	89 50 04             	mov    %edx,0x4(%eax)
  802ec9:	eb 0b                	jmp    802ed6 <alloc_block_NF+0x331>
  802ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed9:	8b 40 04             	mov    0x4(%eax),%eax
  802edc:	85 c0                	test   %eax,%eax
  802ede:	74 0f                	je     802eef <alloc_block_NF+0x34a>
  802ee0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee3:	8b 40 04             	mov    0x4(%eax),%eax
  802ee6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ee9:	8b 12                	mov    (%edx),%edx
  802eeb:	89 10                	mov    %edx,(%eax)
  802eed:	eb 0a                	jmp    802ef9 <alloc_block_NF+0x354>
  802eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef2:	8b 00                	mov    (%eax),%eax
  802ef4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0c:	a1 54 51 80 00       	mov    0x805154,%eax
  802f11:	48                   	dec    %eax
  802f12:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1a:	8b 40 08             	mov    0x8(%eax),%eax
  802f1d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 50 08             	mov    0x8(%eax),%edx
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	01 c2                	add    %eax,%edx
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 40 0c             	mov    0xc(%eax),%eax
  802f39:	2b 45 08             	sub    0x8(%ebp),%eax
  802f3c:	89 c2                	mov    %eax,%edx
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f47:	e9 24 02 00 00       	jmp    803170 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f4c:	a1 40 51 80 00       	mov    0x805140,%eax
  802f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f58:	74 07                	je     802f61 <alloc_block_NF+0x3bc>
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	eb 05                	jmp    802f66 <alloc_block_NF+0x3c1>
  802f61:	b8 00 00 00 00       	mov    $0x0,%eax
  802f66:	a3 40 51 80 00       	mov    %eax,0x805140
  802f6b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f70:	85 c0                	test   %eax,%eax
  802f72:	0f 85 2b fe ff ff    	jne    802da3 <alloc_block_NF+0x1fe>
  802f78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7c:	0f 85 21 fe ff ff    	jne    802da3 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f82:	a1 38 51 80 00       	mov    0x805138,%eax
  802f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f8a:	e9 ae 01 00 00       	jmp    80313d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 50 08             	mov    0x8(%eax),%edx
  802f95:	a1 28 50 80 00       	mov    0x805028,%eax
  802f9a:	39 c2                	cmp    %eax,%edx
  802f9c:	0f 83 93 01 00 00    	jae    803135 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fab:	0f 82 84 01 00 00    	jb     803135 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fba:	0f 85 95 00 00 00    	jne    803055 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802fc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc4:	75 17                	jne    802fdd <alloc_block_NF+0x438>
  802fc6:	83 ec 04             	sub    $0x4,%esp
  802fc9:	68 84 44 80 00       	push   $0x804484
  802fce:	68 14 01 00 00       	push   $0x114
  802fd3:	68 db 43 80 00       	push   $0x8043db
  802fd8:	e8 7c d7 ff ff       	call   800759 <_panic>
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 00                	mov    (%eax),%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	74 10                	je     802ff6 <alloc_block_NF+0x451>
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fee:	8b 52 04             	mov    0x4(%edx),%edx
  802ff1:	89 50 04             	mov    %edx,0x4(%eax)
  802ff4:	eb 0b                	jmp    803001 <alloc_block_NF+0x45c>
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 40 04             	mov    0x4(%eax),%eax
  802ffc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	8b 40 04             	mov    0x4(%eax),%eax
  803007:	85 c0                	test   %eax,%eax
  803009:	74 0f                	je     80301a <alloc_block_NF+0x475>
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	8b 40 04             	mov    0x4(%eax),%eax
  803011:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803014:	8b 12                	mov    (%edx),%edx
  803016:	89 10                	mov    %edx,(%eax)
  803018:	eb 0a                	jmp    803024 <alloc_block_NF+0x47f>
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	a3 38 51 80 00       	mov    %eax,0x805138
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803037:	a1 44 51 80 00       	mov    0x805144,%eax
  80303c:	48                   	dec    %eax
  80303d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 40 08             	mov    0x8(%eax),%eax
  803048:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	e9 1b 01 00 00       	jmp    803170 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803058:	8b 40 0c             	mov    0xc(%eax),%eax
  80305b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80305e:	0f 86 d1 00 00 00    	jbe    803135 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803064:	a1 48 51 80 00       	mov    0x805148,%eax
  803069:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	8b 50 08             	mov    0x8(%eax),%edx
  803072:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803075:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307b:	8b 55 08             	mov    0x8(%ebp),%edx
  80307e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803081:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803085:	75 17                	jne    80309e <alloc_block_NF+0x4f9>
  803087:	83 ec 04             	sub    $0x4,%esp
  80308a:	68 84 44 80 00       	push   $0x804484
  80308f:	68 1c 01 00 00       	push   $0x11c
  803094:	68 db 43 80 00       	push   $0x8043db
  803099:	e8 bb d6 ff ff       	call   800759 <_panic>
  80309e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 10                	je     8030b7 <alloc_block_NF+0x512>
  8030a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030af:	8b 52 04             	mov    0x4(%edx),%edx
  8030b2:	89 50 04             	mov    %edx,0x4(%eax)
  8030b5:	eb 0b                	jmp    8030c2 <alloc_block_NF+0x51d>
  8030b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ba:	8b 40 04             	mov    0x4(%eax),%eax
  8030bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c5:	8b 40 04             	mov    0x4(%eax),%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	74 0f                	je     8030db <alloc_block_NF+0x536>
  8030cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cf:	8b 40 04             	mov    0x4(%eax),%eax
  8030d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030d5:	8b 12                	mov    (%edx),%edx
  8030d7:	89 10                	mov    %edx,(%eax)
  8030d9:	eb 0a                	jmp    8030e5 <alloc_block_NF+0x540>
  8030db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8030fd:	48                   	dec    %eax
  8030fe:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803106:	8b 40 08             	mov    0x8(%eax),%eax
  803109:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 50 08             	mov    0x8(%eax),%edx
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	01 c2                	add    %eax,%edx
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	8b 40 0c             	mov    0xc(%eax),%eax
  803125:	2b 45 08             	sub    0x8(%ebp),%eax
  803128:	89 c2                	mov    %eax,%edx
  80312a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803133:	eb 3b                	jmp    803170 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803135:	a1 40 51 80 00       	mov    0x805140,%eax
  80313a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803141:	74 07                	je     80314a <alloc_block_NF+0x5a5>
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	eb 05                	jmp    80314f <alloc_block_NF+0x5aa>
  80314a:	b8 00 00 00 00       	mov    $0x0,%eax
  80314f:	a3 40 51 80 00       	mov    %eax,0x805140
  803154:	a1 40 51 80 00       	mov    0x805140,%eax
  803159:	85 c0                	test   %eax,%eax
  80315b:	0f 85 2e fe ff ff    	jne    802f8f <alloc_block_NF+0x3ea>
  803161:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803165:	0f 85 24 fe ff ff    	jne    802f8f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80316b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803170:	c9                   	leave  
  803171:	c3                   	ret    

00803172 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803172:	55                   	push   %ebp
  803173:	89 e5                	mov    %esp,%ebp
  803175:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803178:	a1 38 51 80 00       	mov    0x805138,%eax
  80317d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803180:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803185:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803188:	a1 38 51 80 00       	mov    0x805138,%eax
  80318d:	85 c0                	test   %eax,%eax
  80318f:	74 14                	je     8031a5 <insert_sorted_with_merge_freeList+0x33>
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	8b 50 08             	mov    0x8(%eax),%edx
  803197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319a:	8b 40 08             	mov    0x8(%eax),%eax
  80319d:	39 c2                	cmp    %eax,%edx
  80319f:	0f 87 9b 01 00 00    	ja     803340 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8031a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a9:	75 17                	jne    8031c2 <insert_sorted_with_merge_freeList+0x50>
  8031ab:	83 ec 04             	sub    $0x4,%esp
  8031ae:	68 b8 43 80 00       	push   $0x8043b8
  8031b3:	68 38 01 00 00       	push   $0x138
  8031b8:	68 db 43 80 00       	push   $0x8043db
  8031bd:	e8 97 d5 ff ff       	call   800759 <_panic>
  8031c2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	89 10                	mov    %edx,(%eax)
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	85 c0                	test   %eax,%eax
  8031d4:	74 0d                	je     8031e3 <insert_sorted_with_merge_freeList+0x71>
  8031d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8031db:	8b 55 08             	mov    0x8(%ebp),%edx
  8031de:	89 50 04             	mov    %edx,0x4(%eax)
  8031e1:	eb 08                	jmp    8031eb <insert_sorted_with_merge_freeList+0x79>
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fd:	a1 44 51 80 00       	mov    0x805144,%eax
  803202:	40                   	inc    %eax
  803203:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803208:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80320c:	0f 84 a8 06 00 00    	je     8038ba <insert_sorted_with_merge_freeList+0x748>
  803212:	8b 45 08             	mov    0x8(%ebp),%eax
  803215:	8b 50 08             	mov    0x8(%eax),%edx
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	8b 40 0c             	mov    0xc(%eax),%eax
  80321e:	01 c2                	add    %eax,%edx
  803220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803223:	8b 40 08             	mov    0x8(%eax),%eax
  803226:	39 c2                	cmp    %eax,%edx
  803228:	0f 85 8c 06 00 00    	jne    8038ba <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	8b 50 0c             	mov    0xc(%eax),%edx
  803234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803237:	8b 40 0c             	mov    0xc(%eax),%eax
  80323a:	01 c2                	add    %eax,%edx
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803242:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803246:	75 17                	jne    80325f <insert_sorted_with_merge_freeList+0xed>
  803248:	83 ec 04             	sub    $0x4,%esp
  80324b:	68 84 44 80 00       	push   $0x804484
  803250:	68 3c 01 00 00       	push   $0x13c
  803255:	68 db 43 80 00       	push   $0x8043db
  80325a:	e8 fa d4 ff ff       	call   800759 <_panic>
  80325f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	85 c0                	test   %eax,%eax
  803266:	74 10                	je     803278 <insert_sorted_with_merge_freeList+0x106>
  803268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803270:	8b 52 04             	mov    0x4(%edx),%edx
  803273:	89 50 04             	mov    %edx,0x4(%eax)
  803276:	eb 0b                	jmp    803283 <insert_sorted_with_merge_freeList+0x111>
  803278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327b:	8b 40 04             	mov    0x4(%eax),%eax
  80327e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803286:	8b 40 04             	mov    0x4(%eax),%eax
  803289:	85 c0                	test   %eax,%eax
  80328b:	74 0f                	je     80329c <insert_sorted_with_merge_freeList+0x12a>
  80328d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803290:	8b 40 04             	mov    0x4(%eax),%eax
  803293:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803296:	8b 12                	mov    (%edx),%edx
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	eb 0a                	jmp    8032a6 <insert_sorted_with_merge_freeList+0x134>
  80329c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032be:	48                   	dec    %eax
  8032bf:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8032c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8032ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8032d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032dc:	75 17                	jne    8032f5 <insert_sorted_with_merge_freeList+0x183>
  8032de:	83 ec 04             	sub    $0x4,%esp
  8032e1:	68 b8 43 80 00       	push   $0x8043b8
  8032e6:	68 3f 01 00 00       	push   $0x13f
  8032eb:	68 db 43 80 00       	push   $0x8043db
  8032f0:	e8 64 d4 ff ff       	call   800759 <_panic>
  8032f5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fe:	89 10                	mov    %edx,(%eax)
  803300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803303:	8b 00                	mov    (%eax),%eax
  803305:	85 c0                	test   %eax,%eax
  803307:	74 0d                	je     803316 <insert_sorted_with_merge_freeList+0x1a4>
  803309:	a1 48 51 80 00       	mov    0x805148,%eax
  80330e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803311:	89 50 04             	mov    %edx,0x4(%eax)
  803314:	eb 08                	jmp    80331e <insert_sorted_with_merge_freeList+0x1ac>
  803316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803319:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80331e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803321:	a3 48 51 80 00       	mov    %eax,0x805148
  803326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803329:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803330:	a1 54 51 80 00       	mov    0x805154,%eax
  803335:	40                   	inc    %eax
  803336:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80333b:	e9 7a 05 00 00       	jmp    8038ba <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	8b 50 08             	mov    0x8(%eax),%edx
  803346:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803349:	8b 40 08             	mov    0x8(%eax),%eax
  80334c:	39 c2                	cmp    %eax,%edx
  80334e:	0f 82 14 01 00 00    	jb     803468 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803357:	8b 50 08             	mov    0x8(%eax),%edx
  80335a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335d:	8b 40 0c             	mov    0xc(%eax),%eax
  803360:	01 c2                	add    %eax,%edx
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	8b 40 08             	mov    0x8(%eax),%eax
  803368:	39 c2                	cmp    %eax,%edx
  80336a:	0f 85 90 00 00 00    	jne    803400 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803370:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803373:	8b 50 0c             	mov    0xc(%eax),%edx
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	8b 40 0c             	mov    0xc(%eax),%eax
  80337c:	01 c2                	add    %eax,%edx
  80337e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803381:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339c:	75 17                	jne    8033b5 <insert_sorted_with_merge_freeList+0x243>
  80339e:	83 ec 04             	sub    $0x4,%esp
  8033a1:	68 b8 43 80 00       	push   $0x8043b8
  8033a6:	68 49 01 00 00       	push   $0x149
  8033ab:	68 db 43 80 00       	push   $0x8043db
  8033b0:	e8 a4 d3 ff ff       	call   800759 <_panic>
  8033b5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	89 10                	mov    %edx,(%eax)
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	85 c0                	test   %eax,%eax
  8033c7:	74 0d                	je     8033d6 <insert_sorted_with_merge_freeList+0x264>
  8033c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d1:	89 50 04             	mov    %edx,0x4(%eax)
  8033d4:	eb 08                	jmp    8033de <insert_sorted_with_merge_freeList+0x26c>
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8033f5:	40                   	inc    %eax
  8033f6:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033fb:	e9 bb 04 00 00       	jmp    8038bb <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803400:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803404:	75 17                	jne    80341d <insert_sorted_with_merge_freeList+0x2ab>
  803406:	83 ec 04             	sub    $0x4,%esp
  803409:	68 2c 44 80 00       	push   $0x80442c
  80340e:	68 4c 01 00 00       	push   $0x14c
  803413:	68 db 43 80 00       	push   $0x8043db
  803418:	e8 3c d3 ff ff       	call   800759 <_panic>
  80341d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	89 50 04             	mov    %edx,0x4(%eax)
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	8b 40 04             	mov    0x4(%eax),%eax
  80342f:	85 c0                	test   %eax,%eax
  803431:	74 0c                	je     80343f <insert_sorted_with_merge_freeList+0x2cd>
  803433:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803438:	8b 55 08             	mov    0x8(%ebp),%edx
  80343b:	89 10                	mov    %edx,(%eax)
  80343d:	eb 08                	jmp    803447 <insert_sorted_with_merge_freeList+0x2d5>
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	a3 38 51 80 00       	mov    %eax,0x805138
  803447:	8b 45 08             	mov    0x8(%ebp),%eax
  80344a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803458:	a1 44 51 80 00       	mov    0x805144,%eax
  80345d:	40                   	inc    %eax
  80345e:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803463:	e9 53 04 00 00       	jmp    8038bb <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803468:	a1 38 51 80 00       	mov    0x805138,%eax
  80346d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803470:	e9 15 04 00 00       	jmp    80388a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803478:	8b 00                	mov    (%eax),%eax
  80347a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	8b 50 08             	mov    0x8(%eax),%edx
  803483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803486:	8b 40 08             	mov    0x8(%eax),%eax
  803489:	39 c2                	cmp    %eax,%edx
  80348b:	0f 86 f1 03 00 00    	jbe    803882 <insert_sorted_with_merge_freeList+0x710>
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	8b 50 08             	mov    0x8(%eax),%edx
  803497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349a:	8b 40 08             	mov    0x8(%eax),%eax
  80349d:	39 c2                	cmp    %eax,%edx
  80349f:	0f 83 dd 03 00 00    	jae    803882 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8034a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a8:	8b 50 08             	mov    0x8(%eax),%edx
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b1:	01 c2                	add    %eax,%edx
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	8b 40 08             	mov    0x8(%eax),%eax
  8034b9:	39 c2                	cmp    %eax,%edx
  8034bb:	0f 85 b9 01 00 00    	jne    80367a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	8b 50 08             	mov    0x8(%eax),%edx
  8034c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8034cd:	01 c2                	add    %eax,%edx
  8034cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d2:	8b 40 08             	mov    0x8(%eax),%eax
  8034d5:	39 c2                	cmp    %eax,%edx
  8034d7:	0f 85 0d 01 00 00    	jne    8035ea <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8034dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e0:	8b 50 0c             	mov    0xc(%eax),%edx
  8034e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e9:	01 c2                	add    %eax,%edx
  8034eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ee:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8034f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034f5:	75 17                	jne    80350e <insert_sorted_with_merge_freeList+0x39c>
  8034f7:	83 ec 04             	sub    $0x4,%esp
  8034fa:	68 84 44 80 00       	push   $0x804484
  8034ff:	68 5c 01 00 00       	push   $0x15c
  803504:	68 db 43 80 00       	push   $0x8043db
  803509:	e8 4b d2 ff ff       	call   800759 <_panic>
  80350e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803511:	8b 00                	mov    (%eax),%eax
  803513:	85 c0                	test   %eax,%eax
  803515:	74 10                	je     803527 <insert_sorted_with_merge_freeList+0x3b5>
  803517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351a:	8b 00                	mov    (%eax),%eax
  80351c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80351f:	8b 52 04             	mov    0x4(%edx),%edx
  803522:	89 50 04             	mov    %edx,0x4(%eax)
  803525:	eb 0b                	jmp    803532 <insert_sorted_with_merge_freeList+0x3c0>
  803527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352a:	8b 40 04             	mov    0x4(%eax),%eax
  80352d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803535:	8b 40 04             	mov    0x4(%eax),%eax
  803538:	85 c0                	test   %eax,%eax
  80353a:	74 0f                	je     80354b <insert_sorted_with_merge_freeList+0x3d9>
  80353c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353f:	8b 40 04             	mov    0x4(%eax),%eax
  803542:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803545:	8b 12                	mov    (%edx),%edx
  803547:	89 10                	mov    %edx,(%eax)
  803549:	eb 0a                	jmp    803555 <insert_sorted_with_merge_freeList+0x3e3>
  80354b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354e:	8b 00                	mov    (%eax),%eax
  803550:	a3 38 51 80 00       	mov    %eax,0x805138
  803555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803561:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803568:	a1 44 51 80 00       	mov    0x805144,%eax
  80356d:	48                   	dec    %eax
  80356e:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803573:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803576:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80357d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803580:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803587:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80358b:	75 17                	jne    8035a4 <insert_sorted_with_merge_freeList+0x432>
  80358d:	83 ec 04             	sub    $0x4,%esp
  803590:	68 b8 43 80 00       	push   $0x8043b8
  803595:	68 5f 01 00 00       	push   $0x15f
  80359a:	68 db 43 80 00       	push   $0x8043db
  80359f:	e8 b5 d1 ff ff       	call   800759 <_panic>
  8035a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ad:	89 10                	mov    %edx,(%eax)
  8035af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	85 c0                	test   %eax,%eax
  8035b6:	74 0d                	je     8035c5 <insert_sorted_with_merge_freeList+0x453>
  8035b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8035bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035c0:	89 50 04             	mov    %edx,0x4(%eax)
  8035c3:	eb 08                	jmp    8035cd <insert_sorted_with_merge_freeList+0x45b>
  8035c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8035d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035df:	a1 54 51 80 00       	mov    0x805154,%eax
  8035e4:	40                   	inc    %eax
  8035e5:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8035ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ed:	8b 50 0c             	mov    0xc(%eax),%edx
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f6:	01 c2                	add    %eax,%edx
  8035f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fb:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803601:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803608:	8b 45 08             	mov    0x8(%ebp),%eax
  80360b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803612:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803616:	75 17                	jne    80362f <insert_sorted_with_merge_freeList+0x4bd>
  803618:	83 ec 04             	sub    $0x4,%esp
  80361b:	68 b8 43 80 00       	push   $0x8043b8
  803620:	68 64 01 00 00       	push   $0x164
  803625:	68 db 43 80 00       	push   $0x8043db
  80362a:	e8 2a d1 ff ff       	call   800759 <_panic>
  80362f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	89 10                	mov    %edx,(%eax)
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	8b 00                	mov    (%eax),%eax
  80363f:	85 c0                	test   %eax,%eax
  803641:	74 0d                	je     803650 <insert_sorted_with_merge_freeList+0x4de>
  803643:	a1 48 51 80 00       	mov    0x805148,%eax
  803648:	8b 55 08             	mov    0x8(%ebp),%edx
  80364b:	89 50 04             	mov    %edx,0x4(%eax)
  80364e:	eb 08                	jmp    803658 <insert_sorted_with_merge_freeList+0x4e6>
  803650:	8b 45 08             	mov    0x8(%ebp),%eax
  803653:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803658:	8b 45 08             	mov    0x8(%ebp),%eax
  80365b:	a3 48 51 80 00       	mov    %eax,0x805148
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366a:	a1 54 51 80 00       	mov    0x805154,%eax
  80366f:	40                   	inc    %eax
  803670:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803675:	e9 41 02 00 00       	jmp    8038bb <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	8b 50 08             	mov    0x8(%eax),%edx
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	8b 40 0c             	mov    0xc(%eax),%eax
  803686:	01 c2                	add    %eax,%edx
  803688:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368b:	8b 40 08             	mov    0x8(%eax),%eax
  80368e:	39 c2                	cmp    %eax,%edx
  803690:	0f 85 7c 01 00 00    	jne    803812 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803696:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80369a:	74 06                	je     8036a2 <insert_sorted_with_merge_freeList+0x530>
  80369c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a0:	75 17                	jne    8036b9 <insert_sorted_with_merge_freeList+0x547>
  8036a2:	83 ec 04             	sub    $0x4,%esp
  8036a5:	68 f4 43 80 00       	push   $0x8043f4
  8036aa:	68 69 01 00 00       	push   $0x169
  8036af:	68 db 43 80 00       	push   $0x8043db
  8036b4:	e8 a0 d0 ff ff       	call   800759 <_panic>
  8036b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bc:	8b 50 04             	mov    0x4(%eax),%edx
  8036bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c2:	89 50 04             	mov    %edx,0x4(%eax)
  8036c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036cb:	89 10                	mov    %edx,(%eax)
  8036cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d0:	8b 40 04             	mov    0x4(%eax),%eax
  8036d3:	85 c0                	test   %eax,%eax
  8036d5:	74 0d                	je     8036e4 <insert_sorted_with_merge_freeList+0x572>
  8036d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036da:	8b 40 04             	mov    0x4(%eax),%eax
  8036dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e0:	89 10                	mov    %edx,(%eax)
  8036e2:	eb 08                	jmp    8036ec <insert_sorted_with_merge_freeList+0x57a>
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f2:	89 50 04             	mov    %edx,0x4(%eax)
  8036f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8036fa:	40                   	inc    %eax
  8036fb:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	8b 50 0c             	mov    0xc(%eax),%edx
  803706:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803709:	8b 40 0c             	mov    0xc(%eax),%eax
  80370c:	01 c2                	add    %eax,%edx
  80370e:	8b 45 08             	mov    0x8(%ebp),%eax
  803711:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803714:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803718:	75 17                	jne    803731 <insert_sorted_with_merge_freeList+0x5bf>
  80371a:	83 ec 04             	sub    $0x4,%esp
  80371d:	68 84 44 80 00       	push   $0x804484
  803722:	68 6b 01 00 00       	push   $0x16b
  803727:	68 db 43 80 00       	push   $0x8043db
  80372c:	e8 28 d0 ff ff       	call   800759 <_panic>
  803731:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803734:	8b 00                	mov    (%eax),%eax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 10                	je     80374a <insert_sorted_with_merge_freeList+0x5d8>
  80373a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373d:	8b 00                	mov    (%eax),%eax
  80373f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803742:	8b 52 04             	mov    0x4(%edx),%edx
  803745:	89 50 04             	mov    %edx,0x4(%eax)
  803748:	eb 0b                	jmp    803755 <insert_sorted_with_merge_freeList+0x5e3>
  80374a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374d:	8b 40 04             	mov    0x4(%eax),%eax
  803750:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803758:	8b 40 04             	mov    0x4(%eax),%eax
  80375b:	85 c0                	test   %eax,%eax
  80375d:	74 0f                	je     80376e <insert_sorted_with_merge_freeList+0x5fc>
  80375f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803762:	8b 40 04             	mov    0x4(%eax),%eax
  803765:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803768:	8b 12                	mov    (%edx),%edx
  80376a:	89 10                	mov    %edx,(%eax)
  80376c:	eb 0a                	jmp    803778 <insert_sorted_with_merge_freeList+0x606>
  80376e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803771:	8b 00                	mov    (%eax),%eax
  803773:	a3 38 51 80 00       	mov    %eax,0x805138
  803778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803781:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803784:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80378b:	a1 44 51 80 00       	mov    0x805144,%eax
  803790:	48                   	dec    %eax
  803791:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803796:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803799:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8037a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037ae:	75 17                	jne    8037c7 <insert_sorted_with_merge_freeList+0x655>
  8037b0:	83 ec 04             	sub    $0x4,%esp
  8037b3:	68 b8 43 80 00       	push   $0x8043b8
  8037b8:	68 6e 01 00 00       	push   $0x16e
  8037bd:	68 db 43 80 00       	push   $0x8043db
  8037c2:	e8 92 cf ff ff       	call   800759 <_panic>
  8037c7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d0:	89 10                	mov    %edx,(%eax)
  8037d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d5:	8b 00                	mov    (%eax),%eax
  8037d7:	85 c0                	test   %eax,%eax
  8037d9:	74 0d                	je     8037e8 <insert_sorted_with_merge_freeList+0x676>
  8037db:	a1 48 51 80 00       	mov    0x805148,%eax
  8037e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037e3:	89 50 04             	mov    %edx,0x4(%eax)
  8037e6:	eb 08                	jmp    8037f0 <insert_sorted_with_merge_freeList+0x67e>
  8037e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8037f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803802:	a1 54 51 80 00       	mov    0x805154,%eax
  803807:	40                   	inc    %eax
  803808:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80380d:	e9 a9 00 00 00       	jmp    8038bb <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803816:	74 06                	je     80381e <insert_sorted_with_merge_freeList+0x6ac>
  803818:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80381c:	75 17                	jne    803835 <insert_sorted_with_merge_freeList+0x6c3>
  80381e:	83 ec 04             	sub    $0x4,%esp
  803821:	68 50 44 80 00       	push   $0x804450
  803826:	68 73 01 00 00       	push   $0x173
  80382b:	68 db 43 80 00       	push   $0x8043db
  803830:	e8 24 cf ff ff       	call   800759 <_panic>
  803835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803838:	8b 10                	mov    (%eax),%edx
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	89 10                	mov    %edx,(%eax)
  80383f:	8b 45 08             	mov    0x8(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	74 0b                	je     803853 <insert_sorted_with_merge_freeList+0x6e1>
  803848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384b:	8b 00                	mov    (%eax),%eax
  80384d:	8b 55 08             	mov    0x8(%ebp),%edx
  803850:	89 50 04             	mov    %edx,0x4(%eax)
  803853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803856:	8b 55 08             	mov    0x8(%ebp),%edx
  803859:	89 10                	mov    %edx,(%eax)
  80385b:	8b 45 08             	mov    0x8(%ebp),%eax
  80385e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803861:	89 50 04             	mov    %edx,0x4(%eax)
  803864:	8b 45 08             	mov    0x8(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	85 c0                	test   %eax,%eax
  80386b:	75 08                	jne    803875 <insert_sorted_with_merge_freeList+0x703>
  80386d:	8b 45 08             	mov    0x8(%ebp),%eax
  803870:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803875:	a1 44 51 80 00       	mov    0x805144,%eax
  80387a:	40                   	inc    %eax
  80387b:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803880:	eb 39                	jmp    8038bb <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803882:	a1 40 51 80 00       	mov    0x805140,%eax
  803887:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80388a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80388e:	74 07                	je     803897 <insert_sorted_with_merge_freeList+0x725>
  803890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803893:	8b 00                	mov    (%eax),%eax
  803895:	eb 05                	jmp    80389c <insert_sorted_with_merge_freeList+0x72a>
  803897:	b8 00 00 00 00       	mov    $0x0,%eax
  80389c:	a3 40 51 80 00       	mov    %eax,0x805140
  8038a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8038a6:	85 c0                	test   %eax,%eax
  8038a8:	0f 85 c7 fb ff ff    	jne    803475 <insert_sorted_with_merge_freeList+0x303>
  8038ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038b2:	0f 85 bd fb ff ff    	jne    803475 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038b8:	eb 01                	jmp    8038bb <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8038ba:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038bb:	90                   	nop
  8038bc:	c9                   	leave  
  8038bd:	c3                   	ret    
  8038be:	66 90                	xchg   %ax,%ax

008038c0 <__udivdi3>:
  8038c0:	55                   	push   %ebp
  8038c1:	57                   	push   %edi
  8038c2:	56                   	push   %esi
  8038c3:	53                   	push   %ebx
  8038c4:	83 ec 1c             	sub    $0x1c,%esp
  8038c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038d7:	89 ca                	mov    %ecx,%edx
  8038d9:	89 f8                	mov    %edi,%eax
  8038db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038df:	85 f6                	test   %esi,%esi
  8038e1:	75 2d                	jne    803910 <__udivdi3+0x50>
  8038e3:	39 cf                	cmp    %ecx,%edi
  8038e5:	77 65                	ja     80394c <__udivdi3+0x8c>
  8038e7:	89 fd                	mov    %edi,%ebp
  8038e9:	85 ff                	test   %edi,%edi
  8038eb:	75 0b                	jne    8038f8 <__udivdi3+0x38>
  8038ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8038f2:	31 d2                	xor    %edx,%edx
  8038f4:	f7 f7                	div    %edi
  8038f6:	89 c5                	mov    %eax,%ebp
  8038f8:	31 d2                	xor    %edx,%edx
  8038fa:	89 c8                	mov    %ecx,%eax
  8038fc:	f7 f5                	div    %ebp
  8038fe:	89 c1                	mov    %eax,%ecx
  803900:	89 d8                	mov    %ebx,%eax
  803902:	f7 f5                	div    %ebp
  803904:	89 cf                	mov    %ecx,%edi
  803906:	89 fa                	mov    %edi,%edx
  803908:	83 c4 1c             	add    $0x1c,%esp
  80390b:	5b                   	pop    %ebx
  80390c:	5e                   	pop    %esi
  80390d:	5f                   	pop    %edi
  80390e:	5d                   	pop    %ebp
  80390f:	c3                   	ret    
  803910:	39 ce                	cmp    %ecx,%esi
  803912:	77 28                	ja     80393c <__udivdi3+0x7c>
  803914:	0f bd fe             	bsr    %esi,%edi
  803917:	83 f7 1f             	xor    $0x1f,%edi
  80391a:	75 40                	jne    80395c <__udivdi3+0x9c>
  80391c:	39 ce                	cmp    %ecx,%esi
  80391e:	72 0a                	jb     80392a <__udivdi3+0x6a>
  803920:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803924:	0f 87 9e 00 00 00    	ja     8039c8 <__udivdi3+0x108>
  80392a:	b8 01 00 00 00       	mov    $0x1,%eax
  80392f:	89 fa                	mov    %edi,%edx
  803931:	83 c4 1c             	add    $0x1c,%esp
  803934:	5b                   	pop    %ebx
  803935:	5e                   	pop    %esi
  803936:	5f                   	pop    %edi
  803937:	5d                   	pop    %ebp
  803938:	c3                   	ret    
  803939:	8d 76 00             	lea    0x0(%esi),%esi
  80393c:	31 ff                	xor    %edi,%edi
  80393e:	31 c0                	xor    %eax,%eax
  803940:	89 fa                	mov    %edi,%edx
  803942:	83 c4 1c             	add    $0x1c,%esp
  803945:	5b                   	pop    %ebx
  803946:	5e                   	pop    %esi
  803947:	5f                   	pop    %edi
  803948:	5d                   	pop    %ebp
  803949:	c3                   	ret    
  80394a:	66 90                	xchg   %ax,%ax
  80394c:	89 d8                	mov    %ebx,%eax
  80394e:	f7 f7                	div    %edi
  803950:	31 ff                	xor    %edi,%edi
  803952:	89 fa                	mov    %edi,%edx
  803954:	83 c4 1c             	add    $0x1c,%esp
  803957:	5b                   	pop    %ebx
  803958:	5e                   	pop    %esi
  803959:	5f                   	pop    %edi
  80395a:	5d                   	pop    %ebp
  80395b:	c3                   	ret    
  80395c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803961:	89 eb                	mov    %ebp,%ebx
  803963:	29 fb                	sub    %edi,%ebx
  803965:	89 f9                	mov    %edi,%ecx
  803967:	d3 e6                	shl    %cl,%esi
  803969:	89 c5                	mov    %eax,%ebp
  80396b:	88 d9                	mov    %bl,%cl
  80396d:	d3 ed                	shr    %cl,%ebp
  80396f:	89 e9                	mov    %ebp,%ecx
  803971:	09 f1                	or     %esi,%ecx
  803973:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803977:	89 f9                	mov    %edi,%ecx
  803979:	d3 e0                	shl    %cl,%eax
  80397b:	89 c5                	mov    %eax,%ebp
  80397d:	89 d6                	mov    %edx,%esi
  80397f:	88 d9                	mov    %bl,%cl
  803981:	d3 ee                	shr    %cl,%esi
  803983:	89 f9                	mov    %edi,%ecx
  803985:	d3 e2                	shl    %cl,%edx
  803987:	8b 44 24 08          	mov    0x8(%esp),%eax
  80398b:	88 d9                	mov    %bl,%cl
  80398d:	d3 e8                	shr    %cl,%eax
  80398f:	09 c2                	or     %eax,%edx
  803991:	89 d0                	mov    %edx,%eax
  803993:	89 f2                	mov    %esi,%edx
  803995:	f7 74 24 0c          	divl   0xc(%esp)
  803999:	89 d6                	mov    %edx,%esi
  80399b:	89 c3                	mov    %eax,%ebx
  80399d:	f7 e5                	mul    %ebp
  80399f:	39 d6                	cmp    %edx,%esi
  8039a1:	72 19                	jb     8039bc <__udivdi3+0xfc>
  8039a3:	74 0b                	je     8039b0 <__udivdi3+0xf0>
  8039a5:	89 d8                	mov    %ebx,%eax
  8039a7:	31 ff                	xor    %edi,%edi
  8039a9:	e9 58 ff ff ff       	jmp    803906 <__udivdi3+0x46>
  8039ae:	66 90                	xchg   %ax,%ax
  8039b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039b4:	89 f9                	mov    %edi,%ecx
  8039b6:	d3 e2                	shl    %cl,%edx
  8039b8:	39 c2                	cmp    %eax,%edx
  8039ba:	73 e9                	jae    8039a5 <__udivdi3+0xe5>
  8039bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039bf:	31 ff                	xor    %edi,%edi
  8039c1:	e9 40 ff ff ff       	jmp    803906 <__udivdi3+0x46>
  8039c6:	66 90                	xchg   %ax,%ax
  8039c8:	31 c0                	xor    %eax,%eax
  8039ca:	e9 37 ff ff ff       	jmp    803906 <__udivdi3+0x46>
  8039cf:	90                   	nop

008039d0 <__umoddi3>:
  8039d0:	55                   	push   %ebp
  8039d1:	57                   	push   %edi
  8039d2:	56                   	push   %esi
  8039d3:	53                   	push   %ebx
  8039d4:	83 ec 1c             	sub    $0x1c,%esp
  8039d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039ef:	89 f3                	mov    %esi,%ebx
  8039f1:	89 fa                	mov    %edi,%edx
  8039f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039f7:	89 34 24             	mov    %esi,(%esp)
  8039fa:	85 c0                	test   %eax,%eax
  8039fc:	75 1a                	jne    803a18 <__umoddi3+0x48>
  8039fe:	39 f7                	cmp    %esi,%edi
  803a00:	0f 86 a2 00 00 00    	jbe    803aa8 <__umoddi3+0xd8>
  803a06:	89 c8                	mov    %ecx,%eax
  803a08:	89 f2                	mov    %esi,%edx
  803a0a:	f7 f7                	div    %edi
  803a0c:	89 d0                	mov    %edx,%eax
  803a0e:	31 d2                	xor    %edx,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	39 f0                	cmp    %esi,%eax
  803a1a:	0f 87 ac 00 00 00    	ja     803acc <__umoddi3+0xfc>
  803a20:	0f bd e8             	bsr    %eax,%ebp
  803a23:	83 f5 1f             	xor    $0x1f,%ebp
  803a26:	0f 84 ac 00 00 00    	je     803ad8 <__umoddi3+0x108>
  803a2c:	bf 20 00 00 00       	mov    $0x20,%edi
  803a31:	29 ef                	sub    %ebp,%edi
  803a33:	89 fe                	mov    %edi,%esi
  803a35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a39:	89 e9                	mov    %ebp,%ecx
  803a3b:	d3 e0                	shl    %cl,%eax
  803a3d:	89 d7                	mov    %edx,%edi
  803a3f:	89 f1                	mov    %esi,%ecx
  803a41:	d3 ef                	shr    %cl,%edi
  803a43:	09 c7                	or     %eax,%edi
  803a45:	89 e9                	mov    %ebp,%ecx
  803a47:	d3 e2                	shl    %cl,%edx
  803a49:	89 14 24             	mov    %edx,(%esp)
  803a4c:	89 d8                	mov    %ebx,%eax
  803a4e:	d3 e0                	shl    %cl,%eax
  803a50:	89 c2                	mov    %eax,%edx
  803a52:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a56:	d3 e0                	shl    %cl,%eax
  803a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a5c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a60:	89 f1                	mov    %esi,%ecx
  803a62:	d3 e8                	shr    %cl,%eax
  803a64:	09 d0                	or     %edx,%eax
  803a66:	d3 eb                	shr    %cl,%ebx
  803a68:	89 da                	mov    %ebx,%edx
  803a6a:	f7 f7                	div    %edi
  803a6c:	89 d3                	mov    %edx,%ebx
  803a6e:	f7 24 24             	mull   (%esp)
  803a71:	89 c6                	mov    %eax,%esi
  803a73:	89 d1                	mov    %edx,%ecx
  803a75:	39 d3                	cmp    %edx,%ebx
  803a77:	0f 82 87 00 00 00    	jb     803b04 <__umoddi3+0x134>
  803a7d:	0f 84 91 00 00 00    	je     803b14 <__umoddi3+0x144>
  803a83:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a87:	29 f2                	sub    %esi,%edx
  803a89:	19 cb                	sbb    %ecx,%ebx
  803a8b:	89 d8                	mov    %ebx,%eax
  803a8d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a91:	d3 e0                	shl    %cl,%eax
  803a93:	89 e9                	mov    %ebp,%ecx
  803a95:	d3 ea                	shr    %cl,%edx
  803a97:	09 d0                	or     %edx,%eax
  803a99:	89 e9                	mov    %ebp,%ecx
  803a9b:	d3 eb                	shr    %cl,%ebx
  803a9d:	89 da                	mov    %ebx,%edx
  803a9f:	83 c4 1c             	add    $0x1c,%esp
  803aa2:	5b                   	pop    %ebx
  803aa3:	5e                   	pop    %esi
  803aa4:	5f                   	pop    %edi
  803aa5:	5d                   	pop    %ebp
  803aa6:	c3                   	ret    
  803aa7:	90                   	nop
  803aa8:	89 fd                	mov    %edi,%ebp
  803aaa:	85 ff                	test   %edi,%edi
  803aac:	75 0b                	jne    803ab9 <__umoddi3+0xe9>
  803aae:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab3:	31 d2                	xor    %edx,%edx
  803ab5:	f7 f7                	div    %edi
  803ab7:	89 c5                	mov    %eax,%ebp
  803ab9:	89 f0                	mov    %esi,%eax
  803abb:	31 d2                	xor    %edx,%edx
  803abd:	f7 f5                	div    %ebp
  803abf:	89 c8                	mov    %ecx,%eax
  803ac1:	f7 f5                	div    %ebp
  803ac3:	89 d0                	mov    %edx,%eax
  803ac5:	e9 44 ff ff ff       	jmp    803a0e <__umoddi3+0x3e>
  803aca:	66 90                	xchg   %ax,%ax
  803acc:	89 c8                	mov    %ecx,%eax
  803ace:	89 f2                	mov    %esi,%edx
  803ad0:	83 c4 1c             	add    $0x1c,%esp
  803ad3:	5b                   	pop    %ebx
  803ad4:	5e                   	pop    %esi
  803ad5:	5f                   	pop    %edi
  803ad6:	5d                   	pop    %ebp
  803ad7:	c3                   	ret    
  803ad8:	3b 04 24             	cmp    (%esp),%eax
  803adb:	72 06                	jb     803ae3 <__umoddi3+0x113>
  803add:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ae1:	77 0f                	ja     803af2 <__umoddi3+0x122>
  803ae3:	89 f2                	mov    %esi,%edx
  803ae5:	29 f9                	sub    %edi,%ecx
  803ae7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aeb:	89 14 24             	mov    %edx,(%esp)
  803aee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803af2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803af6:	8b 14 24             	mov    (%esp),%edx
  803af9:	83 c4 1c             	add    $0x1c,%esp
  803afc:	5b                   	pop    %ebx
  803afd:	5e                   	pop    %esi
  803afe:	5f                   	pop    %edi
  803aff:	5d                   	pop    %ebp
  803b00:	c3                   	ret    
  803b01:	8d 76 00             	lea    0x0(%esi),%esi
  803b04:	2b 04 24             	sub    (%esp),%eax
  803b07:	19 fa                	sbb    %edi,%edx
  803b09:	89 d1                	mov    %edx,%ecx
  803b0b:	89 c6                	mov    %eax,%esi
  803b0d:	e9 71 ff ff ff       	jmp    803a83 <__umoddi3+0xb3>
  803b12:	66 90                	xchg   %ax,%ax
  803b14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b18:	72 ea                	jb     803b04 <__umoddi3+0x134>
  803b1a:	89 d9                	mov    %ebx,%ecx
  803b1c:	e9 62 ff ff ff       	jmp    803a83 <__umoddi3+0xb3>
