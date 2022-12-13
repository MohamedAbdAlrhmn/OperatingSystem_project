
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
  800044:	e8 f2 1e 00 00       	call   801f3b <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb b5 3a 80 00       	mov    $0x803ab5,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb bf 3a 80 00       	mov    $0x803abf,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb cb 3a 80 00       	mov    $0x803acb,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb da 3a 80 00       	mov    $0x803ada,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb e9 3a 80 00       	mov    $0x803ae9,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb fe 3a 80 00       	mov    $0x803afe,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 13 3b 80 00       	mov    $0x803b13,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 24 3b 80 00       	mov    $0x803b24,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 35 3b 80 00       	mov    $0x803b35,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 46 3b 80 00       	mov    $0x803b46,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 4f 3b 80 00       	mov    $0x803b4f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 59 3b 80 00       	mov    $0x803b59,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 64 3b 80 00       	mov    $0x803b64,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 70 3b 80 00       	mov    $0x803b70,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 7a 3b 80 00       	mov    $0x803b7a,%ebx
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
  8001c1:	bb 84 3b 80 00       	mov    $0x803b84,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 92 3b 80 00       	mov    $0x803b92,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb a1 3b 80 00       	mov    $0x803ba1,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb a8 3b 80 00       	mov    $0x803ba8,%ebx
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
  800225:	e8 74 18 00 00       	call   801a9e <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 5f 18 00 00       	call   801a9e <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 4a 18 00 00       	call   801a9e <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 32 18 00 00       	call   801a9e <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 1a 18 00 00       	call   801a9e <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 02 18 00 00       	call   801a9e <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 ea 17 00 00       	call   801a9e <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 d2 17 00 00       	call   801a9e <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 ba 17 00 00       	call   801a9e <sget>
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
  8002f7:	e8 e0 1a 00 00       	call   801ddc <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 cb 1a 00 00       	call   801ddc <sys_waitSemaphore>
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
  800344:	e8 b1 1a 00 00       	call   801dfa <sys_signalSemaphore>
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
  80038b:	e8 4c 1a 00 00       	call   801ddc <sys_waitSemaphore>
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
  8003ef:	e8 06 1a 00 00       	call   801dfa <sys_signalSemaphore>
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
  800409:	e8 ce 19 00 00       	call   801ddc <sys_waitSemaphore>
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
  80046d:	e8 88 19 00 00       	call   801dfa <sys_signalSemaphore>
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
  800487:	e8 50 19 00 00       	call   801ddc <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 3b 19 00 00       	call   801ddc <sys_waitSemaphore>
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
  800557:	e8 9e 18 00 00       	call   801dfa <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 89 18 00 00       	call   801dfa <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 80 3a 80 00       	push   $0x803a80
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 a0 3a 80 00       	push   $0x803aa0
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb af 3b 80 00       	mov    $0x803baf,%ebx
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
  8005fb:	e8 fa 17 00 00       	call   801dfa <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 e5 17 00 00       	call   801dfa <sys_signalSemaphore>
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
  800623:	e8 fa 18 00 00       	call   801f22 <sys_getenvindex>
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
  80068e:	e8 9c 16 00 00       	call   801d2f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 e8 3b 80 00       	push   $0x803be8
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
  8006be:	68 10 3c 80 00       	push   $0x803c10
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
  8006ef:	68 38 3c 80 00       	push   $0x803c38
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 90 3c 80 00       	push   $0x803c90
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 e8 3b 80 00       	push   $0x803be8
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 1c 16 00 00       	call   801d49 <sys_enable_interrupt>

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
  800740:	e8 a9 17 00 00       	call   801eee <sys_destroy_env>
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
  800751:	e8 fe 17 00 00       	call   801f54 <sys_exit_env>
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
  80077a:	68 a4 3c 80 00       	push   $0x803ca4
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 a9 3c 80 00       	push   $0x803ca9
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
  8007b7:	68 c5 3c 80 00       	push   $0x803cc5
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
  8007e3:	68 c8 3c 80 00       	push   $0x803cc8
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 14 3d 80 00       	push   $0x803d14
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
  8008b5:	68 20 3d 80 00       	push   $0x803d20
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 14 3d 80 00       	push   $0x803d14
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
  800925:	68 74 3d 80 00       	push   $0x803d74
  80092a:	6a 44                	push   $0x44
  80092c:	68 14 3d 80 00       	push   $0x803d14
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
  80097f:	e8 fd 11 00 00       	call   801b81 <sys_cputs>
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
  8009f6:	e8 86 11 00 00       	call   801b81 <sys_cputs>
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
  800a40:	e8 ea 12 00 00       	call   801d2f <sys_disable_interrupt>
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
  800a60:	e8 e4 12 00 00       	call   801d49 <sys_enable_interrupt>
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
  800aaa:	e8 55 2d 00 00       	call   803804 <__udivdi3>
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
  800afa:	e8 15 2e 00 00       	call   803914 <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 d4 3f 80 00       	add    $0x803fd4,%eax
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
  800c55:	8b 04 85 f8 3f 80 00 	mov    0x803ff8(,%eax,4),%eax
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
  800d36:	8b 34 9d 40 3e 80 00 	mov    0x803e40(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 e5 3f 80 00       	push   $0x803fe5
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
  800d5b:	68 ee 3f 80 00       	push   $0x803fee
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
  800d88:	be f1 3f 80 00       	mov    $0x803ff1,%esi
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
  8017ae:	68 50 41 80 00       	push   $0x804150
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
  80187e:	e8 42 04 00 00       	call   801cc5 <sys_allocate_chunk>
  801883:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801886:	a1 20 51 80 00       	mov    0x805120,%eax
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	50                   	push   %eax
  80188f:	e8 b7 0a 00 00       	call   80234b <initialize_MemBlocksList>
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
  8018bc:	68 75 41 80 00       	push   $0x804175
  8018c1:	6a 33                	push   $0x33
  8018c3:	68 93 41 80 00       	push   $0x804193
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
  80193b:	68 a0 41 80 00       	push   $0x8041a0
  801940:	6a 34                	push   $0x34
  801942:	68 93 41 80 00       	push   $0x804193
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
  801998:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80199b:	e8 f7 fd ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019a4:	75 07                	jne    8019ad <malloc+0x18>
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ab:	eb 14                	jmp    8019c1 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8019ad:	83 ec 04             	sub    $0x4,%esp
  8019b0:	68 c4 41 80 00       	push   $0x8041c4
  8019b5:	6a 46                	push   $0x46
  8019b7:	68 93 41 80 00       	push   $0x804193
  8019bc:	e8 98 ed ff ff       	call   800759 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8019c9:	83 ec 04             	sub    $0x4,%esp
  8019cc:	68 ec 41 80 00       	push   $0x8041ec
  8019d1:	6a 61                	push   $0x61
  8019d3:	68 93 41 80 00       	push   $0x804193
  8019d8:	e8 7c ed ff ff       	call   800759 <_panic>

008019dd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 38             	sub    $0x38,%esp
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019e9:	e8 a9 fd ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019f2:	75 0a                	jne    8019fe <smalloc+0x21>
  8019f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f9:	e9 9e 00 00 00       	jmp    801a9c <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019fe:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0b:	01 d0                	add    %edx,%eax
  801a0d:	48                   	dec    %eax
  801a0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a14:	ba 00 00 00 00       	mov    $0x0,%edx
  801a19:	f7 75 f0             	divl   -0x10(%ebp)
  801a1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1f:	29 d0                	sub    %edx,%eax
  801a21:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a24:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a2b:	e8 63 06 00 00       	call   802093 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a30:	85 c0                	test   %eax,%eax
  801a32:	74 11                	je     801a45 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801a34:	83 ec 0c             	sub    $0xc,%esp
  801a37:	ff 75 e8             	pushl  -0x18(%ebp)
  801a3a:	e8 ce 0c 00 00       	call   80270d <alloc_block_FF>
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801a45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a49:	74 4c                	je     801a97 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4e:	8b 40 08             	mov    0x8(%eax),%eax
  801a51:	89 c2                	mov    %eax,%edx
  801a53:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a57:	52                   	push   %edx
  801a58:	50                   	push   %eax
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	ff 75 08             	pushl  0x8(%ebp)
  801a5f:	e8 b4 03 00 00       	call   801e18 <sys_createSharedObject>
  801a64:	83 c4 10             	add    $0x10,%esp
  801a67:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801a6a:	83 ec 08             	sub    $0x8,%esp
  801a6d:	ff 75 e0             	pushl  -0x20(%ebp)
  801a70:	68 0f 42 80 00       	push   $0x80420f
  801a75:	e8 93 ef ff ff       	call   800a0d <cprintf>
  801a7a:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801a7d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801a81:	74 14                	je     801a97 <smalloc+0xba>
  801a83:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801a87:	74 0e                	je     801a97 <smalloc+0xba>
  801a89:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801a8d:	74 08                	je     801a97 <smalloc+0xba>
			return (void*) mem_block->sva;
  801a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a92:	8b 40 08             	mov    0x8(%eax),%eax
  801a95:	eb 05                	jmp    801a9c <smalloc+0xbf>
	}
	return NULL;
  801a97:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aa4:	e8 ee fc ff ff       	call   801797 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	68 24 42 80 00       	push   $0x804224
  801ab1:	68 ab 00 00 00       	push   $0xab
  801ab6:	68 93 41 80 00       	push   $0x804193
  801abb:	e8 99 ec ff ff       	call   800759 <_panic>

00801ac0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ac6:	e8 cc fc ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	68 48 42 80 00       	push   $0x804248
  801ad3:	68 ef 00 00 00       	push   $0xef
  801ad8:	68 93 41 80 00       	push   $0x804193
  801add:	e8 77 ec ff ff       	call   800759 <_panic>

00801ae2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	68 70 42 80 00       	push   $0x804270
  801af0:	68 03 01 00 00       	push   $0x103
  801af5:	68 93 41 80 00       	push   $0x804193
  801afa:	e8 5a ec ff ff       	call   800759 <_panic>

00801aff <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	68 94 42 80 00       	push   $0x804294
  801b0d:	68 0e 01 00 00       	push   $0x10e
  801b12:	68 93 41 80 00       	push   $0x804193
  801b17:	e8 3d ec ff ff       	call   800759 <_panic>

00801b1c <shrink>:

}
void shrink(uint32 newSize)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	68 94 42 80 00       	push   $0x804294
  801b2a:	68 13 01 00 00       	push   $0x113
  801b2f:	68 93 41 80 00       	push   $0x804193
  801b34:	e8 20 ec ff ff       	call   800759 <_panic>

00801b39 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b3f:	83 ec 04             	sub    $0x4,%esp
  801b42:	68 94 42 80 00       	push   $0x804294
  801b47:	68 18 01 00 00       	push   $0x118
  801b4c:	68 93 41 80 00       	push   $0x804193
  801b51:	e8 03 ec ff ff       	call   800759 <_panic>

00801b56 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	57                   	push   %edi
  801b5a:	56                   	push   %esi
  801b5b:	53                   	push   %ebx
  801b5c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b6b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b6e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b71:	cd 30                	int    $0x30
  801b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	5b                   	pop    %ebx
  801b7d:	5e                   	pop    %esi
  801b7e:	5f                   	pop    %edi
  801b7f:	5d                   	pop    %ebp
  801b80:	c3                   	ret    

00801b81 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b8d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	52                   	push   %edx
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	50                   	push   %eax
  801b9d:	6a 00                	push   $0x0
  801b9f:	e8 b2 ff ff ff       	call   801b56 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	90                   	nop
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_cgetc>:

int
sys_cgetc(void)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 01                	push   $0x1
  801bb9:	e8 98 ff ff ff       	call   801b56 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 05                	push   $0x5
  801bd6:	e8 7b ff ff ff       	call   801b56 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	56                   	push   %esi
  801be4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801be5:	8b 75 18             	mov    0x18(%ebp),%esi
  801be8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801beb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	56                   	push   %esi
  801bf5:	53                   	push   %ebx
  801bf6:	51                   	push   %ecx
  801bf7:	52                   	push   %edx
  801bf8:	50                   	push   %eax
  801bf9:	6a 06                	push   $0x6
  801bfb:	e8 56 ff ff ff       	call   801b56 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c06:	5b                   	pop    %ebx
  801c07:	5e                   	pop    %esi
  801c08:	5d                   	pop    %ebp
  801c09:	c3                   	ret    

00801c0a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	52                   	push   %edx
  801c1a:	50                   	push   %eax
  801c1b:	6a 07                	push   $0x7
  801c1d:	e8 34 ff ff ff       	call   801b56 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	ff 75 08             	pushl  0x8(%ebp)
  801c36:	6a 08                	push   $0x8
  801c38:	e8 19 ff ff ff       	call   801b56 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 09                	push   $0x9
  801c51:	e8 00 ff ff ff       	call   801b56 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 0a                	push   $0xa
  801c6a:	e8 e7 fe ff ff       	call   801b56 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 0b                	push   $0xb
  801c83:	e8 ce fe ff ff       	call   801b56 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	6a 0f                	push   $0xf
  801c9e:	e8 b3 fe ff ff       	call   801b56 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
	return;
  801ca6:	90                   	nop
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	ff 75 0c             	pushl  0xc(%ebp)
  801cb5:	ff 75 08             	pushl  0x8(%ebp)
  801cb8:	6a 10                	push   $0x10
  801cba:	e8 97 fe ff ff       	call   801b56 <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc2:	90                   	nop
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	ff 75 10             	pushl  0x10(%ebp)
  801ccf:	ff 75 0c             	pushl  0xc(%ebp)
  801cd2:	ff 75 08             	pushl  0x8(%ebp)
  801cd5:	6a 11                	push   $0x11
  801cd7:	e8 7a fe ff ff       	call   801b56 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdf:	90                   	nop
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 0c                	push   $0xc
  801cf1:	e8 60 fe ff ff       	call   801b56 <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	ff 75 08             	pushl  0x8(%ebp)
  801d09:	6a 0d                	push   $0xd
  801d0b:	e8 46 fe ff ff       	call   801b56 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 0e                	push   $0xe
  801d24:	e8 2d fe ff ff       	call   801b56 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	90                   	nop
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 13                	push   $0x13
  801d3e:	e8 13 fe ff ff       	call   801b56 <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	90                   	nop
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 14                	push   $0x14
  801d58:	e8 f9 fd ff ff       	call   801b56 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	90                   	nop
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 04             	sub    $0x4,%esp
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d6f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	50                   	push   %eax
  801d7c:	6a 15                	push   $0x15
  801d7e:	e8 d3 fd ff ff       	call   801b56 <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
}
  801d86:	90                   	nop
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 16                	push   $0x16
  801d98:	e8 b9 fd ff ff       	call   801b56 <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	90                   	nop
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	50                   	push   %eax
  801db3:	6a 17                	push   $0x17
  801db5:	e8 9c fd ff ff       	call   801b56 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	52                   	push   %edx
  801dcf:	50                   	push   %eax
  801dd0:	6a 1a                	push   $0x1a
  801dd2:	e8 7f fd ff ff       	call   801b56 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	52                   	push   %edx
  801dec:	50                   	push   %eax
  801ded:	6a 18                	push   $0x18
  801def:	e8 62 fd ff ff       	call   801b56 <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
}
  801df7:	90                   	nop
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	52                   	push   %edx
  801e0a:	50                   	push   %eax
  801e0b:	6a 19                	push   $0x19
  801e0d:	e8 44 fd ff ff       	call   801b56 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	90                   	nop
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 04             	sub    $0x4,%esp
  801e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e21:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e24:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e27:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	6a 00                	push   $0x0
  801e30:	51                   	push   %ecx
  801e31:	52                   	push   %edx
  801e32:	ff 75 0c             	pushl  0xc(%ebp)
  801e35:	50                   	push   %eax
  801e36:	6a 1b                	push   $0x1b
  801e38:	e8 19 fd ff ff       	call   801b56 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	52                   	push   %edx
  801e52:	50                   	push   %eax
  801e53:	6a 1c                	push   $0x1c
  801e55:	e8 fc fc ff ff       	call   801b56 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	51                   	push   %ecx
  801e70:	52                   	push   %edx
  801e71:	50                   	push   %eax
  801e72:	6a 1d                	push   $0x1d
  801e74:	e8 dd fc ff ff       	call   801b56 <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	52                   	push   %edx
  801e8e:	50                   	push   %eax
  801e8f:	6a 1e                	push   $0x1e
  801e91:	e8 c0 fc ff ff       	call   801b56 <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 1f                	push   $0x1f
  801eaa:	e8 a7 fc ff ff       	call   801b56 <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	6a 00                	push   $0x0
  801ebc:	ff 75 14             	pushl  0x14(%ebp)
  801ebf:	ff 75 10             	pushl  0x10(%ebp)
  801ec2:	ff 75 0c             	pushl  0xc(%ebp)
  801ec5:	50                   	push   %eax
  801ec6:	6a 20                	push   $0x20
  801ec8:	e8 89 fc ff ff       	call   801b56 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	50                   	push   %eax
  801ee1:	6a 21                	push   $0x21
  801ee3:	e8 6e fc ff ff       	call   801b56 <syscall>
  801ee8:	83 c4 18             	add    $0x18,%esp
}
  801eeb:	90                   	nop
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	50                   	push   %eax
  801efd:	6a 22                	push   $0x22
  801eff:	e8 52 fc ff ff       	call   801b56 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 02                	push   $0x2
  801f18:	e8 39 fc ff ff       	call   801b56 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 03                	push   $0x3
  801f31:	e8 20 fc ff ff       	call   801b56 <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 04                	push   $0x4
  801f4a:	e8 07 fc ff ff       	call   801b56 <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
}
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

00801f54 <sys_exit_env>:


void sys_exit_env(void)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 23                	push   $0x23
  801f63:	e8 ee fb ff ff       	call   801b56 <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
}
  801f6b:	90                   	nop
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f77:	8d 50 04             	lea    0x4(%eax),%edx
  801f7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	52                   	push   %edx
  801f84:	50                   	push   %eax
  801f85:	6a 24                	push   $0x24
  801f87:	e8 ca fb ff ff       	call   801b56 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
	return result;
  801f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f98:	89 01                	mov    %eax,(%ecx)
  801f9a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	c9                   	leave  
  801fa1:	c2 04 00             	ret    $0x4

00801fa4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	ff 75 10             	pushl  0x10(%ebp)
  801fae:	ff 75 0c             	pushl  0xc(%ebp)
  801fb1:	ff 75 08             	pushl  0x8(%ebp)
  801fb4:	6a 12                	push   $0x12
  801fb6:	e8 9b fb ff ff       	call   801b56 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801fbe:	90                   	nop
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 25                	push   $0x25
  801fd0:	e8 81 fb ff ff       	call   801b56 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 04             	sub    $0x4,%esp
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fe6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	50                   	push   %eax
  801ff3:	6a 26                	push   $0x26
  801ff5:	e8 5c fb ff ff       	call   801b56 <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffd:	90                   	nop
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <rsttst>:
void rsttst()
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 28                	push   $0x28
  80200f:	e8 42 fb ff ff       	call   801b56 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
	return ;
  802017:	90                   	nop
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 04             	sub    $0x4,%esp
  802020:	8b 45 14             	mov    0x14(%ebp),%eax
  802023:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802026:	8b 55 18             	mov    0x18(%ebp),%edx
  802029:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	ff 75 10             	pushl  0x10(%ebp)
  802032:	ff 75 0c             	pushl  0xc(%ebp)
  802035:	ff 75 08             	pushl  0x8(%ebp)
  802038:	6a 27                	push   $0x27
  80203a:	e8 17 fb ff ff       	call   801b56 <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
	return ;
  802042:	90                   	nop
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <chktst>:
void chktst(uint32 n)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	ff 75 08             	pushl  0x8(%ebp)
  802053:	6a 29                	push   $0x29
  802055:	e8 fc fa ff ff       	call   801b56 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
	return ;
  80205d:	90                   	nop
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <inctst>:

void inctst()
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 2a                	push   $0x2a
  80206f:	e8 e2 fa ff ff       	call   801b56 <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
	return ;
  802077:	90                   	nop
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <gettst>:
uint32 gettst()
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 2b                	push   $0x2b
  802089:	e8 c8 fa ff ff       	call   801b56 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 2c                	push   $0x2c
  8020a5:	e8 ac fa ff ff       	call   801b56 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
  8020ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020b0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020b4:	75 07                	jne    8020bd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020bb:	eb 05                	jmp    8020c2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 2c                	push   $0x2c
  8020d6:	e8 7b fa ff ff       	call   801b56 <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
  8020de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020e1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020e5:	75 07                	jne    8020ee <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ec:	eb 05                	jmp    8020f3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 2c                	push   $0x2c
  802107:	e8 4a fa ff ff       	call   801b56 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
  80210f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802112:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802116:	75 07                	jne    80211f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802118:	b8 01 00 00 00       	mov    $0x1,%eax
  80211d:	eb 05                	jmp    802124 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 2c                	push   $0x2c
  802138:	e8 19 fa ff ff       	call   801b56 <syscall>
  80213d:	83 c4 18             	add    $0x18,%esp
  802140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802143:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802147:	75 07                	jne    802150 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802149:	b8 01 00 00 00       	mov    $0x1,%eax
  80214e:	eb 05                	jmp    802155 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802150:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	ff 75 08             	pushl  0x8(%ebp)
  802165:	6a 2d                	push   $0x2d
  802167:	e8 ea f9 ff ff       	call   801b56 <syscall>
  80216c:	83 c4 18             	add    $0x18,%esp
	return ;
  80216f:	90                   	nop
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802176:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802179:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80217c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	6a 00                	push   $0x0
  802184:	53                   	push   %ebx
  802185:	51                   	push   %ecx
  802186:	52                   	push   %edx
  802187:	50                   	push   %eax
  802188:	6a 2e                	push   $0x2e
  80218a:	e8 c7 f9 ff ff       	call   801b56 <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
}
  802192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80219a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	52                   	push   %edx
  8021a7:	50                   	push   %eax
  8021a8:	6a 2f                	push   $0x2f
  8021aa:	e8 a7 f9 ff ff       	call   801b56 <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8021ba:	83 ec 0c             	sub    $0xc,%esp
  8021bd:	68 a4 42 80 00       	push   $0x8042a4
  8021c2:	e8 46 e8 ff ff       	call   800a0d <cprintf>
  8021c7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8021ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8021d1:	83 ec 0c             	sub    $0xc,%esp
  8021d4:	68 d0 42 80 00       	push   $0x8042d0
  8021d9:	e8 2f e8 ff ff       	call   800a0d <cprintf>
  8021de:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021e1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021e5:	a1 38 51 80 00       	mov    0x805138,%eax
  8021ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ed:	eb 56                	jmp    802245 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021f3:	74 1c                	je     802211 <print_mem_block_lists+0x5d>
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	8b 50 08             	mov    0x8(%eax),%edx
  8021fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fe:	8b 48 08             	mov    0x8(%eax),%ecx
  802201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802204:	8b 40 0c             	mov    0xc(%eax),%eax
  802207:	01 c8                	add    %ecx,%eax
  802209:	39 c2                	cmp    %eax,%edx
  80220b:	73 04                	jae    802211 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80220d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802214:	8b 50 08             	mov    0x8(%eax),%edx
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	8b 40 0c             	mov    0xc(%eax),%eax
  80221d:	01 c2                	add    %eax,%edx
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 40 08             	mov    0x8(%eax),%eax
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	52                   	push   %edx
  802229:	50                   	push   %eax
  80222a:	68 e5 42 80 00       	push   $0x8042e5
  80222f:	e8 d9 e7 ff ff       	call   800a0d <cprintf>
  802234:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80223d:	a1 40 51 80 00       	mov    0x805140,%eax
  802242:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802245:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802249:	74 07                	je     802252 <print_mem_block_lists+0x9e>
  80224b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224e:	8b 00                	mov    (%eax),%eax
  802250:	eb 05                	jmp    802257 <print_mem_block_lists+0xa3>
  802252:	b8 00 00 00 00       	mov    $0x0,%eax
  802257:	a3 40 51 80 00       	mov    %eax,0x805140
  80225c:	a1 40 51 80 00       	mov    0x805140,%eax
  802261:	85 c0                	test   %eax,%eax
  802263:	75 8a                	jne    8021ef <print_mem_block_lists+0x3b>
  802265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802269:	75 84                	jne    8021ef <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80226b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80226f:	75 10                	jne    802281 <print_mem_block_lists+0xcd>
  802271:	83 ec 0c             	sub    $0xc,%esp
  802274:	68 f4 42 80 00       	push   $0x8042f4
  802279:	e8 8f e7 ff ff       	call   800a0d <cprintf>
  80227e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802281:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802288:	83 ec 0c             	sub    $0xc,%esp
  80228b:	68 18 43 80 00       	push   $0x804318
  802290:	e8 78 e7 ff ff       	call   800a0d <cprintf>
  802295:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802298:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80229c:	a1 40 50 80 00       	mov    0x805040,%eax
  8022a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a4:	eb 56                	jmp    8022fc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022aa:	74 1c                	je     8022c8 <print_mem_block_lists+0x114>
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	8b 50 08             	mov    0x8(%eax),%edx
  8022b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b5:	8b 48 08             	mov    0x8(%eax),%ecx
  8022b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8022be:	01 c8                	add    %ecx,%eax
  8022c0:	39 c2                	cmp    %eax,%edx
  8022c2:	73 04                	jae    8022c8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8022c4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 50 08             	mov    0x8(%eax),%edx
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d4:	01 c2                	add    %eax,%edx
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8b 40 08             	mov    0x8(%eax),%eax
  8022dc:	83 ec 04             	sub    $0x4,%esp
  8022df:	52                   	push   %edx
  8022e0:	50                   	push   %eax
  8022e1:	68 e5 42 80 00       	push   $0x8042e5
  8022e6:	e8 22 e7 ff ff       	call   800a0d <cprintf>
  8022eb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022f4:	a1 48 50 80 00       	mov    0x805048,%eax
  8022f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802300:	74 07                	je     802309 <print_mem_block_lists+0x155>
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	eb 05                	jmp    80230e <print_mem_block_lists+0x15a>
  802309:	b8 00 00 00 00       	mov    $0x0,%eax
  80230e:	a3 48 50 80 00       	mov    %eax,0x805048
  802313:	a1 48 50 80 00       	mov    0x805048,%eax
  802318:	85 c0                	test   %eax,%eax
  80231a:	75 8a                	jne    8022a6 <print_mem_block_lists+0xf2>
  80231c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802320:	75 84                	jne    8022a6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802322:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802326:	75 10                	jne    802338 <print_mem_block_lists+0x184>
  802328:	83 ec 0c             	sub    $0xc,%esp
  80232b:	68 30 43 80 00       	push   $0x804330
  802330:	e8 d8 e6 ff ff       	call   800a0d <cprintf>
  802335:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802338:	83 ec 0c             	sub    $0xc,%esp
  80233b:	68 a4 42 80 00       	push   $0x8042a4
  802340:	e8 c8 e6 ff ff       	call   800a0d <cprintf>
  802345:	83 c4 10             	add    $0x10,%esp

}
  802348:	90                   	nop
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802351:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802358:	00 00 00 
  80235b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802362:	00 00 00 
  802365:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80236c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80236f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802376:	e9 9e 00 00 00       	jmp    802419 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80237b:	a1 50 50 80 00       	mov    0x805050,%eax
  802380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802383:	c1 e2 04             	shl    $0x4,%edx
  802386:	01 d0                	add    %edx,%eax
  802388:	85 c0                	test   %eax,%eax
  80238a:	75 14                	jne    8023a0 <initialize_MemBlocksList+0x55>
  80238c:	83 ec 04             	sub    $0x4,%esp
  80238f:	68 58 43 80 00       	push   $0x804358
  802394:	6a 46                	push   $0x46
  802396:	68 7b 43 80 00       	push   $0x80437b
  80239b:	e8 b9 e3 ff ff       	call   800759 <_panic>
  8023a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8023a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a8:	c1 e2 04             	shl    $0x4,%edx
  8023ab:	01 d0                	add    %edx,%eax
  8023ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8023b3:	89 10                	mov    %edx,(%eax)
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	74 18                	je     8023d3 <initialize_MemBlocksList+0x88>
  8023bb:	a1 48 51 80 00       	mov    0x805148,%eax
  8023c0:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8023c6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023c9:	c1 e1 04             	shl    $0x4,%ecx
  8023cc:	01 ca                	add    %ecx,%edx
  8023ce:	89 50 04             	mov    %edx,0x4(%eax)
  8023d1:	eb 12                	jmp    8023e5 <initialize_MemBlocksList+0x9a>
  8023d3:	a1 50 50 80 00       	mov    0x805050,%eax
  8023d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023db:	c1 e2 04             	shl    $0x4,%edx
  8023de:	01 d0                	add    %edx,%eax
  8023e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023e5:	a1 50 50 80 00       	mov    0x805050,%eax
  8023ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ed:	c1 e2 04             	shl    $0x4,%edx
  8023f0:	01 d0                	add    %edx,%eax
  8023f2:	a3 48 51 80 00       	mov    %eax,0x805148
  8023f7:	a1 50 50 80 00       	mov    0x805050,%eax
  8023fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ff:	c1 e2 04             	shl    $0x4,%edx
  802402:	01 d0                	add    %edx,%eax
  802404:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80240b:	a1 54 51 80 00       	mov    0x805154,%eax
  802410:	40                   	inc    %eax
  802411:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802416:	ff 45 f4             	incl   -0xc(%ebp)
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241f:	0f 82 56 ff ff ff    	jb     80237b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802425:	90                   	nop
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	8b 00                	mov    (%eax),%eax
  802433:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802436:	eb 19                	jmp    802451 <find_block+0x29>
	{
		if(va==point->sva)
  802438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80243b:	8b 40 08             	mov    0x8(%eax),%eax
  80243e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802441:	75 05                	jne    802448 <find_block+0x20>
		   return point;
  802443:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802446:	eb 36                	jmp    80247e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	8b 40 08             	mov    0x8(%eax),%eax
  80244e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802451:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802455:	74 07                	je     80245e <find_block+0x36>
  802457:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	eb 05                	jmp    802463 <find_block+0x3b>
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
  802463:	8b 55 08             	mov    0x8(%ebp),%edx
  802466:	89 42 08             	mov    %eax,0x8(%edx)
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	8b 40 08             	mov    0x8(%eax),%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	75 c5                	jne    802438 <find_block+0x10>
  802473:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802477:	75 bf                	jne    802438 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802479:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802486:	a1 40 50 80 00       	mov    0x805040,%eax
  80248b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80248e:	a1 44 50 80 00       	mov    0x805044,%eax
  802493:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802499:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80249c:	74 24                	je     8024c2 <insert_sorted_allocList+0x42>
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	8b 50 08             	mov    0x8(%eax),%edx
  8024a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a7:	8b 40 08             	mov    0x8(%eax),%eax
  8024aa:	39 c2                	cmp    %eax,%edx
  8024ac:	76 14                	jbe    8024c2 <insert_sorted_allocList+0x42>
  8024ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b1:	8b 50 08             	mov    0x8(%eax),%edx
  8024b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b7:	8b 40 08             	mov    0x8(%eax),%eax
  8024ba:	39 c2                	cmp    %eax,%edx
  8024bc:	0f 82 60 01 00 00    	jb     802622 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8024c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c6:	75 65                	jne    80252d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8024c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024cc:	75 14                	jne    8024e2 <insert_sorted_allocList+0x62>
  8024ce:	83 ec 04             	sub    $0x4,%esp
  8024d1:	68 58 43 80 00       	push   $0x804358
  8024d6:	6a 6b                	push   $0x6b
  8024d8:	68 7b 43 80 00       	push   $0x80437b
  8024dd:	e8 77 e2 ff ff       	call   800759 <_panic>
  8024e2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	89 10                	mov    %edx,(%eax)
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	74 0d                	je     802503 <insert_sorted_allocList+0x83>
  8024f6:	a1 40 50 80 00       	mov    0x805040,%eax
  8024fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fe:	89 50 04             	mov    %edx,0x4(%eax)
  802501:	eb 08                	jmp    80250b <insert_sorted_allocList+0x8b>
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	a3 44 50 80 00       	mov    %eax,0x805044
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	a3 40 50 80 00       	mov    %eax,0x805040
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802522:	40                   	inc    %eax
  802523:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802528:	e9 dc 01 00 00       	jmp    802709 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80252d:	8b 45 08             	mov    0x8(%ebp),%eax
  802530:	8b 50 08             	mov    0x8(%eax),%edx
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	8b 40 08             	mov    0x8(%eax),%eax
  802539:	39 c2                	cmp    %eax,%edx
  80253b:	77 6c                	ja     8025a9 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80253d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802541:	74 06                	je     802549 <insert_sorted_allocList+0xc9>
  802543:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802547:	75 14                	jne    80255d <insert_sorted_allocList+0xdd>
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	68 94 43 80 00       	push   $0x804394
  802551:	6a 6f                	push   $0x6f
  802553:	68 7b 43 80 00       	push   $0x80437b
  802558:	e8 fc e1 ff ff       	call   800759 <_panic>
  80255d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802560:	8b 50 04             	mov    0x4(%eax),%edx
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	89 50 04             	mov    %edx,0x4(%eax)
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80256f:	89 10                	mov    %edx,(%eax)
  802571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802574:	8b 40 04             	mov    0x4(%eax),%eax
  802577:	85 c0                	test   %eax,%eax
  802579:	74 0d                	je     802588 <insert_sorted_allocList+0x108>
  80257b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257e:	8b 40 04             	mov    0x4(%eax),%eax
  802581:	8b 55 08             	mov    0x8(%ebp),%edx
  802584:	89 10                	mov    %edx,(%eax)
  802586:	eb 08                	jmp    802590 <insert_sorted_allocList+0x110>
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	a3 40 50 80 00       	mov    %eax,0x805040
  802590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802593:	8b 55 08             	mov    0x8(%ebp),%edx
  802596:	89 50 04             	mov    %edx,0x4(%eax)
  802599:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80259e:	40                   	inc    %eax
  80259f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025a4:	e9 60 01 00 00       	jmp    802709 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	8b 50 08             	mov    0x8(%eax),%edx
  8025af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b2:	8b 40 08             	mov    0x8(%eax),%eax
  8025b5:	39 c2                	cmp    %eax,%edx
  8025b7:	0f 82 4c 01 00 00    	jb     802709 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8025bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025c1:	75 14                	jne    8025d7 <insert_sorted_allocList+0x157>
  8025c3:	83 ec 04             	sub    $0x4,%esp
  8025c6:	68 cc 43 80 00       	push   $0x8043cc
  8025cb:	6a 73                	push   $0x73
  8025cd:	68 7b 43 80 00       	push   $0x80437b
  8025d2:	e8 82 e1 ff ff       	call   800759 <_panic>
  8025d7:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8025dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e0:	89 50 04             	mov    %edx,0x4(%eax)
  8025e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e6:	8b 40 04             	mov    0x4(%eax),%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	74 0c                	je     8025f9 <insert_sorted_allocList+0x179>
  8025ed:	a1 44 50 80 00       	mov    0x805044,%eax
  8025f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f5:	89 10                	mov    %edx,(%eax)
  8025f7:	eb 08                	jmp    802601 <insert_sorted_allocList+0x181>
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	a3 40 50 80 00       	mov    %eax,0x805040
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	a3 44 50 80 00       	mov    %eax,0x805044
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
  80260c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802612:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802617:	40                   	inc    %eax
  802618:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80261d:	e9 e7 00 00 00       	jmp    802709 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802625:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802628:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80262f:	a1 40 50 80 00       	mov    0x805040,%eax
  802634:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802637:	e9 9d 00 00 00       	jmp    8026d9 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 00                	mov    (%eax),%eax
  802641:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	8b 50 08             	mov    0x8(%eax),%edx
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 08             	mov    0x8(%eax),%eax
  802650:	39 c2                	cmp    %eax,%edx
  802652:	76 7d                	jbe    8026d1 <insert_sorted_allocList+0x251>
  802654:	8b 45 08             	mov    0x8(%ebp),%eax
  802657:	8b 50 08             	mov    0x8(%eax),%edx
  80265a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265d:	8b 40 08             	mov    0x8(%eax),%eax
  802660:	39 c2                	cmp    %eax,%edx
  802662:	73 6d                	jae    8026d1 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802664:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802668:	74 06                	je     802670 <insert_sorted_allocList+0x1f0>
  80266a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80266e:	75 14                	jne    802684 <insert_sorted_allocList+0x204>
  802670:	83 ec 04             	sub    $0x4,%esp
  802673:	68 f0 43 80 00       	push   $0x8043f0
  802678:	6a 7f                	push   $0x7f
  80267a:	68 7b 43 80 00       	push   $0x80437b
  80267f:	e8 d5 e0 ff ff       	call   800759 <_panic>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 10                	mov    (%eax),%edx
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	89 10                	mov    %edx,(%eax)
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	8b 00                	mov    (%eax),%eax
  802693:	85 c0                	test   %eax,%eax
  802695:	74 0b                	je     8026a2 <insert_sorted_allocList+0x222>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 00                	mov    (%eax),%eax
  80269c:	8b 55 08             	mov    0x8(%ebp),%edx
  80269f:	89 50 04             	mov    %edx,0x4(%eax)
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a8:	89 10                	mov    %edx,(%eax)
  8026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b0:	89 50 04             	mov    %edx,0x4(%eax)
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	85 c0                	test   %eax,%eax
  8026ba:	75 08                	jne    8026c4 <insert_sorted_allocList+0x244>
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	a3 44 50 80 00       	mov    %eax,0x805044
  8026c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026c9:	40                   	inc    %eax
  8026ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8026cf:	eb 39                	jmp    80270a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026d1:	a1 48 50 80 00       	mov    0x805048,%eax
  8026d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dd:	74 07                	je     8026e6 <insert_sorted_allocList+0x266>
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 00                	mov    (%eax),%eax
  8026e4:	eb 05                	jmp    8026eb <insert_sorted_allocList+0x26b>
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026eb:	a3 48 50 80 00       	mov    %eax,0x805048
  8026f0:	a1 48 50 80 00       	mov    0x805048,%eax
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	0f 85 3f ff ff ff    	jne    80263c <insert_sorted_allocList+0x1bc>
  8026fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802701:	0f 85 35 ff ff ff    	jne    80263c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802707:	eb 01                	jmp    80270a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802709:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80270a:	90                   	nop
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
  802710:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802713:	a1 38 51 80 00       	mov    0x805138,%eax
  802718:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271b:	e9 85 01 00 00       	jmp    8028a5 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 40 0c             	mov    0xc(%eax),%eax
  802726:	3b 45 08             	cmp    0x8(%ebp),%eax
  802729:	0f 82 6e 01 00 00    	jb     80289d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 40 0c             	mov    0xc(%eax),%eax
  802735:	3b 45 08             	cmp    0x8(%ebp),%eax
  802738:	0f 85 8a 00 00 00    	jne    8027c8 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80273e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802742:	75 17                	jne    80275b <alloc_block_FF+0x4e>
  802744:	83 ec 04             	sub    $0x4,%esp
  802747:	68 24 44 80 00       	push   $0x804424
  80274c:	68 93 00 00 00       	push   $0x93
  802751:	68 7b 43 80 00       	push   $0x80437b
  802756:	e8 fe df ff ff       	call   800759 <_panic>
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	85 c0                	test   %eax,%eax
  802762:	74 10                	je     802774 <alloc_block_FF+0x67>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276c:	8b 52 04             	mov    0x4(%edx),%edx
  80276f:	89 50 04             	mov    %edx,0x4(%eax)
  802772:	eb 0b                	jmp    80277f <alloc_block_FF+0x72>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 40 04             	mov    0x4(%eax),%eax
  80277a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 40 04             	mov    0x4(%eax),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	74 0f                	je     802798 <alloc_block_FF+0x8b>
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 40 04             	mov    0x4(%eax),%eax
  80278f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802792:	8b 12                	mov    (%edx),%edx
  802794:	89 10                	mov    %edx,(%eax)
  802796:	eb 0a                	jmp    8027a2 <alloc_block_FF+0x95>
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	a3 38 51 80 00       	mov    %eax,0x805138
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b5:	a1 44 51 80 00       	mov    0x805144,%eax
  8027ba:	48                   	dec    %eax
  8027bb:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	e9 10 01 00 00       	jmp    8028d8 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d1:	0f 86 c6 00 00 00    	jbe    80289d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8027dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 50 08             	mov    0x8(%eax),%edx
  8027e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e8:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f1:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027f8:	75 17                	jne    802811 <alloc_block_FF+0x104>
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	68 24 44 80 00       	push   $0x804424
  802802:	68 9b 00 00 00       	push   $0x9b
  802807:	68 7b 43 80 00       	push   $0x80437b
  80280c:	e8 48 df ff ff       	call   800759 <_panic>
  802811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	85 c0                	test   %eax,%eax
  802818:	74 10                	je     80282a <alloc_block_FF+0x11d>
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802822:	8b 52 04             	mov    0x4(%edx),%edx
  802825:	89 50 04             	mov    %edx,0x4(%eax)
  802828:	eb 0b                	jmp    802835 <alloc_block_FF+0x128>
  80282a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282d:	8b 40 04             	mov    0x4(%eax),%eax
  802830:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802838:	8b 40 04             	mov    0x4(%eax),%eax
  80283b:	85 c0                	test   %eax,%eax
  80283d:	74 0f                	je     80284e <alloc_block_FF+0x141>
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	8b 40 04             	mov    0x4(%eax),%eax
  802845:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802848:	8b 12                	mov    (%edx),%edx
  80284a:	89 10                	mov    %edx,(%eax)
  80284c:	eb 0a                	jmp    802858 <alloc_block_FF+0x14b>
  80284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	a3 48 51 80 00       	mov    %eax,0x805148
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802864:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286b:	a1 54 51 80 00       	mov    0x805154,%eax
  802870:	48                   	dec    %eax
  802871:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 50 08             	mov    0x8(%eax),%edx
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	01 c2                	add    %eax,%edx
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 40 0c             	mov    0xc(%eax),%eax
  80288d:	2b 45 08             	sub    0x8(%ebp),%eax
  802890:	89 c2                	mov    %eax,%edx
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289b:	eb 3b                	jmp    8028d8 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80289d:	a1 40 51 80 00       	mov    0x805140,%eax
  8028a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a9:	74 07                	je     8028b2 <alloc_block_FF+0x1a5>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	eb 05                	jmp    8028b7 <alloc_block_FF+0x1aa>
  8028b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b7:	a3 40 51 80 00       	mov    %eax,0x805140
  8028bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	0f 85 57 fe ff ff    	jne    802720 <alloc_block_FF+0x13>
  8028c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cd:	0f 85 4d fe ff ff    	jne    802720 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8028d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
  8028dd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8028e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ef:	e9 df 00 00 00       	jmp    8029d3 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fd:	0f 82 c8 00 00 00    	jb     8029cb <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 40 0c             	mov    0xc(%eax),%eax
  802909:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290c:	0f 85 8a 00 00 00    	jne    80299c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802912:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802916:	75 17                	jne    80292f <alloc_block_BF+0x55>
  802918:	83 ec 04             	sub    $0x4,%esp
  80291b:	68 24 44 80 00       	push   $0x804424
  802920:	68 b7 00 00 00       	push   $0xb7
  802925:	68 7b 43 80 00       	push   $0x80437b
  80292a:	e8 2a de ff ff       	call   800759 <_panic>
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	8b 00                	mov    (%eax),%eax
  802934:	85 c0                	test   %eax,%eax
  802936:	74 10                	je     802948 <alloc_block_BF+0x6e>
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802940:	8b 52 04             	mov    0x4(%edx),%edx
  802943:	89 50 04             	mov    %edx,0x4(%eax)
  802946:	eb 0b                	jmp    802953 <alloc_block_BF+0x79>
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 40 04             	mov    0x4(%eax),%eax
  80294e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	8b 40 04             	mov    0x4(%eax),%eax
  802959:	85 c0                	test   %eax,%eax
  80295b:	74 0f                	je     80296c <alloc_block_BF+0x92>
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 40 04             	mov    0x4(%eax),%eax
  802963:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802966:	8b 12                	mov    (%edx),%edx
  802968:	89 10                	mov    %edx,(%eax)
  80296a:	eb 0a                	jmp    802976 <alloc_block_BF+0x9c>
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	a3 38 51 80 00       	mov    %eax,0x805138
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802989:	a1 44 51 80 00       	mov    0x805144,%eax
  80298e:	48                   	dec    %eax
  80298f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	e9 4d 01 00 00       	jmp    802ae9 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a5:	76 24                	jbe    8029cb <alloc_block_BF+0xf1>
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029b0:	73 19                	jae    8029cb <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8029b2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	8b 40 08             	mov    0x8(%eax),%eax
  8029c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8029d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d7:	74 07                	je     8029e0 <alloc_block_BF+0x106>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	eb 05                	jmp    8029e5 <alloc_block_BF+0x10b>
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e5:	a3 40 51 80 00       	mov    %eax,0x805140
  8029ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	0f 85 fd fe ff ff    	jne    8028f4 <alloc_block_BF+0x1a>
  8029f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fb:	0f 85 f3 fe ff ff    	jne    8028f4 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802a01:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a05:	0f 84 d9 00 00 00    	je     802ae4 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a0b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a19:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a22:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802a25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a29:	75 17                	jne    802a42 <alloc_block_BF+0x168>
  802a2b:	83 ec 04             	sub    $0x4,%esp
  802a2e:	68 24 44 80 00       	push   $0x804424
  802a33:	68 c7 00 00 00       	push   $0xc7
  802a38:	68 7b 43 80 00       	push   $0x80437b
  802a3d:	e8 17 dd ff ff       	call   800759 <_panic>
  802a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 10                	je     802a5b <alloc_block_BF+0x181>
  802a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a53:	8b 52 04             	mov    0x4(%edx),%edx
  802a56:	89 50 04             	mov    %edx,0x4(%eax)
  802a59:	eb 0b                	jmp    802a66 <alloc_block_BF+0x18c>
  802a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5e:	8b 40 04             	mov    0x4(%eax),%eax
  802a61:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a69:	8b 40 04             	mov    0x4(%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 0f                	je     802a7f <alloc_block_BF+0x1a5>
  802a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a79:	8b 12                	mov    (%edx),%edx
  802a7b:	89 10                	mov    %edx,(%eax)
  802a7d:	eb 0a                	jmp    802a89 <alloc_block_BF+0x1af>
  802a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	a3 48 51 80 00       	mov    %eax,0x805148
  802a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9c:	a1 54 51 80 00       	mov    0x805154,%eax
  802aa1:	48                   	dec    %eax
  802aa2:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802aa7:	83 ec 08             	sub    $0x8,%esp
  802aaa:	ff 75 ec             	pushl  -0x14(%ebp)
  802aad:	68 38 51 80 00       	push   $0x805138
  802ab2:	e8 71 f9 ff ff       	call   802428 <find_block>
  802ab7:	83 c4 10             	add    $0x10,%esp
  802aba:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802abd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac0:	8b 50 08             	mov    0x8(%eax),%edx
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	01 c2                	add    %eax,%edx
  802ac8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acb:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ad7:	89 c2                	mov    %eax,%edx
  802ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802adc:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802adf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae2:	eb 05                	jmp    802ae9 <alloc_block_BF+0x20f>
	}
	return NULL;
  802ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae9:	c9                   	leave  
  802aea:	c3                   	ret    

00802aeb <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802aeb:	55                   	push   %ebp
  802aec:	89 e5                	mov    %esp,%ebp
  802aee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802af1:	a1 28 50 80 00       	mov    0x805028,%eax
  802af6:	85 c0                	test   %eax,%eax
  802af8:	0f 85 de 01 00 00    	jne    802cdc <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802afe:	a1 38 51 80 00       	mov    0x805138,%eax
  802b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b06:	e9 9e 01 00 00       	jmp    802ca9 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b11:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b14:	0f 82 87 01 00 00    	jb     802ca1 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b20:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b23:	0f 85 95 00 00 00    	jne    802bbe <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802b29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2d:	75 17                	jne    802b46 <alloc_block_NF+0x5b>
  802b2f:	83 ec 04             	sub    $0x4,%esp
  802b32:	68 24 44 80 00       	push   $0x804424
  802b37:	68 e0 00 00 00       	push   $0xe0
  802b3c:	68 7b 43 80 00       	push   $0x80437b
  802b41:	e8 13 dc ff ff       	call   800759 <_panic>
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 10                	je     802b5f <alloc_block_NF+0x74>
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	8b 00                	mov    (%eax),%eax
  802b54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b57:	8b 52 04             	mov    0x4(%edx),%edx
  802b5a:	89 50 04             	mov    %edx,0x4(%eax)
  802b5d:	eb 0b                	jmp    802b6a <alloc_block_NF+0x7f>
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 40 04             	mov    0x4(%eax),%eax
  802b65:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 40 04             	mov    0x4(%eax),%eax
  802b70:	85 c0                	test   %eax,%eax
  802b72:	74 0f                	je     802b83 <alloc_block_NF+0x98>
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7d:	8b 12                	mov    (%edx),%edx
  802b7f:	89 10                	mov    %edx,(%eax)
  802b81:	eb 0a                	jmp    802b8d <alloc_block_NF+0xa2>
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 00                	mov    (%eax),%eax
  802b88:	a3 38 51 80 00       	mov    %eax,0x805138
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba5:	48                   	dec    %eax
  802ba6:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 40 08             	mov    0x8(%eax),%eax
  802bb1:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	e9 f8 04 00 00       	jmp    8030b6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc7:	0f 86 d4 00 00 00    	jbe    802ca1 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bcd:	a1 48 51 80 00       	mov    0x805148,%eax
  802bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 50 08             	mov    0x8(%eax),%edx
  802bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bde:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be4:	8b 55 08             	mov    0x8(%ebp),%edx
  802be7:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bee:	75 17                	jne    802c07 <alloc_block_NF+0x11c>
  802bf0:	83 ec 04             	sub    $0x4,%esp
  802bf3:	68 24 44 80 00       	push   $0x804424
  802bf8:	68 e9 00 00 00       	push   $0xe9
  802bfd:	68 7b 43 80 00       	push   $0x80437b
  802c02:	e8 52 db ff ff       	call   800759 <_panic>
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 10                	je     802c20 <alloc_block_NF+0x135>
  802c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c18:	8b 52 04             	mov    0x4(%edx),%edx
  802c1b:	89 50 04             	mov    %edx,0x4(%eax)
  802c1e:	eb 0b                	jmp    802c2b <alloc_block_NF+0x140>
  802c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c23:	8b 40 04             	mov    0x4(%eax),%eax
  802c26:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2e:	8b 40 04             	mov    0x4(%eax),%eax
  802c31:	85 c0                	test   %eax,%eax
  802c33:	74 0f                	je     802c44 <alloc_block_NF+0x159>
  802c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c38:	8b 40 04             	mov    0x4(%eax),%eax
  802c3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3e:	8b 12                	mov    (%edx),%edx
  802c40:	89 10                	mov    %edx,(%eax)
  802c42:	eb 0a                	jmp    802c4e <alloc_block_NF+0x163>
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	a3 48 51 80 00       	mov    %eax,0x805148
  802c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c61:	a1 54 51 80 00       	mov    0x805154,%eax
  802c66:	48                   	dec    %eax
  802c67:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6f:	8b 40 08             	mov    0x8(%eax),%eax
  802c72:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 50 08             	mov    0x8(%eax),%edx
  802c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c80:	01 c2                	add    %eax,%edx
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8e:	2b 45 08             	sub    0x8(%ebp),%eax
  802c91:	89 c2                	mov    %eax,%edx
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	e9 15 04 00 00       	jmp    8030b6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ca1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cad:	74 07                	je     802cb6 <alloc_block_NF+0x1cb>
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	eb 05                	jmp    802cbb <alloc_block_NF+0x1d0>
  802cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbb:	a3 40 51 80 00       	mov    %eax,0x805140
  802cc0:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	0f 85 3e fe ff ff    	jne    802b0b <alloc_block_NF+0x20>
  802ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd1:	0f 85 34 fe ff ff    	jne    802b0b <alloc_block_NF+0x20>
  802cd7:	e9 d5 03 00 00       	jmp    8030b1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cdc:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce4:	e9 b1 01 00 00       	jmp    802e9a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 50 08             	mov    0x8(%eax),%edx
  802cef:	a1 28 50 80 00       	mov    0x805028,%eax
  802cf4:	39 c2                	cmp    %eax,%edx
  802cf6:	0f 82 96 01 00 00    	jb     802e92 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 40 0c             	mov    0xc(%eax),%eax
  802d02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d05:	0f 82 87 01 00 00    	jb     802e92 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d11:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d14:	0f 85 95 00 00 00    	jne    802daf <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1e:	75 17                	jne    802d37 <alloc_block_NF+0x24c>
  802d20:	83 ec 04             	sub    $0x4,%esp
  802d23:	68 24 44 80 00       	push   $0x804424
  802d28:	68 fc 00 00 00       	push   $0xfc
  802d2d:	68 7b 43 80 00       	push   $0x80437b
  802d32:	e8 22 da ff ff       	call   800759 <_panic>
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	85 c0                	test   %eax,%eax
  802d3e:	74 10                	je     802d50 <alloc_block_NF+0x265>
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	8b 00                	mov    (%eax),%eax
  802d45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d48:	8b 52 04             	mov    0x4(%edx),%edx
  802d4b:	89 50 04             	mov    %edx,0x4(%eax)
  802d4e:	eb 0b                	jmp    802d5b <alloc_block_NF+0x270>
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 40 04             	mov    0x4(%eax),%eax
  802d56:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	74 0f                	je     802d74 <alloc_block_NF+0x289>
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	8b 40 04             	mov    0x4(%eax),%eax
  802d6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6e:	8b 12                	mov    (%edx),%edx
  802d70:	89 10                	mov    %edx,(%eax)
  802d72:	eb 0a                	jmp    802d7e <alloc_block_NF+0x293>
  802d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d77:	8b 00                	mov    (%eax),%eax
  802d79:	a3 38 51 80 00       	mov    %eax,0x805138
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d91:	a1 44 51 80 00       	mov    0x805144,%eax
  802d96:	48                   	dec    %eax
  802d97:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 40 08             	mov    0x8(%eax),%eax
  802da2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	e9 07 03 00 00       	jmp    8030b6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	8b 40 0c             	mov    0xc(%eax),%eax
  802db5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802db8:	0f 86 d4 00 00 00    	jbe    802e92 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dbe:	a1 48 51 80 00       	mov    0x805148,%eax
  802dc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 50 08             	mov    0x8(%eax),%edx
  802dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dcf:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ddb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ddf:	75 17                	jne    802df8 <alloc_block_NF+0x30d>
  802de1:	83 ec 04             	sub    $0x4,%esp
  802de4:	68 24 44 80 00       	push   $0x804424
  802de9:	68 04 01 00 00       	push   $0x104
  802dee:	68 7b 43 80 00       	push   $0x80437b
  802df3:	e8 61 d9 ff ff       	call   800759 <_panic>
  802df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	85 c0                	test   %eax,%eax
  802dff:	74 10                	je     802e11 <alloc_block_NF+0x326>
  802e01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e04:	8b 00                	mov    (%eax),%eax
  802e06:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e09:	8b 52 04             	mov    0x4(%edx),%edx
  802e0c:	89 50 04             	mov    %edx,0x4(%eax)
  802e0f:	eb 0b                	jmp    802e1c <alloc_block_NF+0x331>
  802e11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e14:	8b 40 04             	mov    0x4(%eax),%eax
  802e17:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1f:	8b 40 04             	mov    0x4(%eax),%eax
  802e22:	85 c0                	test   %eax,%eax
  802e24:	74 0f                	je     802e35 <alloc_block_NF+0x34a>
  802e26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e29:	8b 40 04             	mov    0x4(%eax),%eax
  802e2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e2f:	8b 12                	mov    (%edx),%edx
  802e31:	89 10                	mov    %edx,(%eax)
  802e33:	eb 0a                	jmp    802e3f <alloc_block_NF+0x354>
  802e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e52:	a1 54 51 80 00       	mov    0x805154,%eax
  802e57:	48                   	dec    %eax
  802e58:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e60:	8b 40 08             	mov    0x8(%eax),%eax
  802e63:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 50 08             	mov    0x8(%eax),%edx
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	01 c2                	add    %eax,%edx
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7f:	2b 45 08             	sub    0x8(%ebp),%eax
  802e82:	89 c2                	mov    %eax,%edx
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8d:	e9 24 02 00 00       	jmp    8030b6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e92:	a1 40 51 80 00       	mov    0x805140,%eax
  802e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9e:	74 07                	je     802ea7 <alloc_block_NF+0x3bc>
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	eb 05                	jmp    802eac <alloc_block_NF+0x3c1>
  802ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  802eac:	a3 40 51 80 00       	mov    %eax,0x805140
  802eb1:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	0f 85 2b fe ff ff    	jne    802ce9 <alloc_block_NF+0x1fe>
  802ebe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec2:	0f 85 21 fe ff ff    	jne    802ce9 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ec8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed0:	e9 ae 01 00 00       	jmp    803083 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 50 08             	mov    0x8(%eax),%edx
  802edb:	a1 28 50 80 00       	mov    0x805028,%eax
  802ee0:	39 c2                	cmp    %eax,%edx
  802ee2:	0f 83 93 01 00 00    	jae    80307b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802eee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ef1:	0f 82 84 01 00 00    	jb     80307b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 40 0c             	mov    0xc(%eax),%eax
  802efd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f00:	0f 85 95 00 00 00    	jne    802f9b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0a:	75 17                	jne    802f23 <alloc_block_NF+0x438>
  802f0c:	83 ec 04             	sub    $0x4,%esp
  802f0f:	68 24 44 80 00       	push   $0x804424
  802f14:	68 14 01 00 00       	push   $0x114
  802f19:	68 7b 43 80 00       	push   $0x80437b
  802f1e:	e8 36 d8 ff ff       	call   800759 <_panic>
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 00                	mov    (%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 10                	je     802f3c <alloc_block_NF+0x451>
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f34:	8b 52 04             	mov    0x4(%edx),%edx
  802f37:	89 50 04             	mov    %edx,0x4(%eax)
  802f3a:	eb 0b                	jmp    802f47 <alloc_block_NF+0x45c>
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 40 04             	mov    0x4(%eax),%eax
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	74 0f                	je     802f60 <alloc_block_NF+0x475>
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 40 04             	mov    0x4(%eax),%eax
  802f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5a:	8b 12                	mov    (%edx),%edx
  802f5c:	89 10                	mov    %edx,(%eax)
  802f5e:	eb 0a                	jmp    802f6a <alloc_block_NF+0x47f>
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	a3 38 51 80 00       	mov    %eax,0x805138
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7d:	a1 44 51 80 00       	mov    0x805144,%eax
  802f82:	48                   	dec    %eax
  802f83:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 40 08             	mov    0x8(%eax),%eax
  802f8e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	e9 1b 01 00 00       	jmp    8030b6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fa4:	0f 86 d1 00 00 00    	jbe    80307b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802faa:	a1 48 51 80 00       	mov    0x805148,%eax
  802faf:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 50 08             	mov    0x8(%eax),%edx
  802fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fcb:	75 17                	jne    802fe4 <alloc_block_NF+0x4f9>
  802fcd:	83 ec 04             	sub    $0x4,%esp
  802fd0:	68 24 44 80 00       	push   $0x804424
  802fd5:	68 1c 01 00 00       	push   $0x11c
  802fda:	68 7b 43 80 00       	push   $0x80437b
  802fdf:	e8 75 d7 ff ff       	call   800759 <_panic>
  802fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	74 10                	je     802ffd <alloc_block_NF+0x512>
  802fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ff5:	8b 52 04             	mov    0x4(%edx),%edx
  802ff8:	89 50 04             	mov    %edx,0x4(%eax)
  802ffb:	eb 0b                	jmp    803008 <alloc_block_NF+0x51d>
  802ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803000:	8b 40 04             	mov    0x4(%eax),%eax
  803003:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803008:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	74 0f                	je     803021 <alloc_block_NF+0x536>
  803012:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803015:	8b 40 04             	mov    0x4(%eax),%eax
  803018:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80301b:	8b 12                	mov    (%edx),%edx
  80301d:	89 10                	mov    %edx,(%eax)
  80301f:	eb 0a                	jmp    80302b <alloc_block_NF+0x540>
  803021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803024:	8b 00                	mov    (%eax),%eax
  803026:	a3 48 51 80 00       	mov    %eax,0x805148
  80302b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803034:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803037:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303e:	a1 54 51 80 00       	mov    0x805154,%eax
  803043:	48                   	dec    %eax
  803044:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803049:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304c:	8b 40 08             	mov    0x8(%eax),%eax
  80304f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	8b 50 08             	mov    0x8(%eax),%edx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	01 c2                	add    %eax,%edx
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803068:	8b 40 0c             	mov    0xc(%eax),%eax
  80306b:	2b 45 08             	sub    0x8(%ebp),%eax
  80306e:	89 c2                	mov    %eax,%edx
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803076:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803079:	eb 3b                	jmp    8030b6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80307b:	a1 40 51 80 00       	mov    0x805140,%eax
  803080:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803083:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803087:	74 07                	je     803090 <alloc_block_NF+0x5a5>
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	8b 00                	mov    (%eax),%eax
  80308e:	eb 05                	jmp    803095 <alloc_block_NF+0x5aa>
  803090:	b8 00 00 00 00       	mov    $0x0,%eax
  803095:	a3 40 51 80 00       	mov    %eax,0x805140
  80309a:	a1 40 51 80 00       	mov    0x805140,%eax
  80309f:	85 c0                	test   %eax,%eax
  8030a1:	0f 85 2e fe ff ff    	jne    802ed5 <alloc_block_NF+0x3ea>
  8030a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ab:	0f 85 24 fe ff ff    	jne    802ed5 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8030b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b6:	c9                   	leave  
  8030b7:	c3                   	ret    

008030b8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
  8030bb:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8030be:	a1 38 51 80 00       	mov    0x805138,%eax
  8030c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8030c6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030cb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8030ce:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	74 14                	je     8030eb <insert_sorted_with_merge_freeList+0x33>
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	8b 50 08             	mov    0x8(%eax),%edx
  8030dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e0:	8b 40 08             	mov    0x8(%eax),%eax
  8030e3:	39 c2                	cmp    %eax,%edx
  8030e5:	0f 87 9b 01 00 00    	ja     803286 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8030eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ef:	75 17                	jne    803108 <insert_sorted_with_merge_freeList+0x50>
  8030f1:	83 ec 04             	sub    $0x4,%esp
  8030f4:	68 58 43 80 00       	push   $0x804358
  8030f9:	68 38 01 00 00       	push   $0x138
  8030fe:	68 7b 43 80 00       	push   $0x80437b
  803103:	e8 51 d6 ff ff       	call   800759 <_panic>
  803108:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	89 10                	mov    %edx,(%eax)
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	85 c0                	test   %eax,%eax
  80311a:	74 0d                	je     803129 <insert_sorted_with_merge_freeList+0x71>
  80311c:	a1 38 51 80 00       	mov    0x805138,%eax
  803121:	8b 55 08             	mov    0x8(%ebp),%edx
  803124:	89 50 04             	mov    %edx,0x4(%eax)
  803127:	eb 08                	jmp    803131 <insert_sorted_with_merge_freeList+0x79>
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	a3 38 51 80 00       	mov    %eax,0x805138
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803143:	a1 44 51 80 00       	mov    0x805144,%eax
  803148:	40                   	inc    %eax
  803149:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80314e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803152:	0f 84 a8 06 00 00    	je     803800 <insert_sorted_with_merge_freeList+0x748>
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 50 08             	mov    0x8(%eax),%edx
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	8b 40 0c             	mov    0xc(%eax),%eax
  803164:	01 c2                	add    %eax,%edx
  803166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803169:	8b 40 08             	mov    0x8(%eax),%eax
  80316c:	39 c2                	cmp    %eax,%edx
  80316e:	0f 85 8c 06 00 00    	jne    803800 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	8b 50 0c             	mov    0xc(%eax),%edx
  80317a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317d:	8b 40 0c             	mov    0xc(%eax),%eax
  803180:	01 c2                	add    %eax,%edx
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803188:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80318c:	75 17                	jne    8031a5 <insert_sorted_with_merge_freeList+0xed>
  80318e:	83 ec 04             	sub    $0x4,%esp
  803191:	68 24 44 80 00       	push   $0x804424
  803196:	68 3c 01 00 00       	push   $0x13c
  80319b:	68 7b 43 80 00       	push   $0x80437b
  8031a0:	e8 b4 d5 ff ff       	call   800759 <_panic>
  8031a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a8:	8b 00                	mov    (%eax),%eax
  8031aa:	85 c0                	test   %eax,%eax
  8031ac:	74 10                	je     8031be <insert_sorted_with_merge_freeList+0x106>
  8031ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b1:	8b 00                	mov    (%eax),%eax
  8031b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b6:	8b 52 04             	mov    0x4(%edx),%edx
  8031b9:	89 50 04             	mov    %edx,0x4(%eax)
  8031bc:	eb 0b                	jmp    8031c9 <insert_sorted_with_merge_freeList+0x111>
  8031be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c1:	8b 40 04             	mov    0x4(%eax),%eax
  8031c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	8b 40 04             	mov    0x4(%eax),%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 0f                	je     8031e2 <insert_sorted_with_merge_freeList+0x12a>
  8031d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d6:	8b 40 04             	mov    0x4(%eax),%eax
  8031d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031dc:	8b 12                	mov    (%edx),%edx
  8031de:	89 10                	mov    %edx,(%eax)
  8031e0:	eb 0a                	jmp    8031ec <insert_sorted_with_merge_freeList+0x134>
  8031e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ff:	a1 44 51 80 00       	mov    0x805144,%eax
  803204:	48                   	dec    %eax
  803205:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80320a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803217:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80321e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803222:	75 17                	jne    80323b <insert_sorted_with_merge_freeList+0x183>
  803224:	83 ec 04             	sub    $0x4,%esp
  803227:	68 58 43 80 00       	push   $0x804358
  80322c:	68 3f 01 00 00       	push   $0x13f
  803231:	68 7b 43 80 00       	push   $0x80437b
  803236:	e8 1e d5 ff ff       	call   800759 <_panic>
  80323b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803244:	89 10                	mov    %edx,(%eax)
  803246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803249:	8b 00                	mov    (%eax),%eax
  80324b:	85 c0                	test   %eax,%eax
  80324d:	74 0d                	je     80325c <insert_sorted_with_merge_freeList+0x1a4>
  80324f:	a1 48 51 80 00       	mov    0x805148,%eax
  803254:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803257:	89 50 04             	mov    %edx,0x4(%eax)
  80325a:	eb 08                	jmp    803264 <insert_sorted_with_merge_freeList+0x1ac>
  80325c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803267:	a3 48 51 80 00       	mov    %eax,0x805148
  80326c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803276:	a1 54 51 80 00       	mov    0x805154,%eax
  80327b:	40                   	inc    %eax
  80327c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803281:	e9 7a 05 00 00       	jmp    803800 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	8b 50 08             	mov    0x8(%eax),%edx
  80328c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328f:	8b 40 08             	mov    0x8(%eax),%eax
  803292:	39 c2                	cmp    %eax,%edx
  803294:	0f 82 14 01 00 00    	jb     8033ae <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80329a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80329d:	8b 50 08             	mov    0x8(%eax),%edx
  8032a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a6:	01 c2                	add    %eax,%edx
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	8b 40 08             	mov    0x8(%eax),%eax
  8032ae:	39 c2                	cmp    %eax,%edx
  8032b0:	0f 85 90 00 00 00    	jne    803346 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8032b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c2:	01 c2                	add    %eax,%edx
  8032c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c7:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e2:	75 17                	jne    8032fb <insert_sorted_with_merge_freeList+0x243>
  8032e4:	83 ec 04             	sub    $0x4,%esp
  8032e7:	68 58 43 80 00       	push   $0x804358
  8032ec:	68 49 01 00 00       	push   $0x149
  8032f1:	68 7b 43 80 00       	push   $0x80437b
  8032f6:	e8 5e d4 ff ff       	call   800759 <_panic>
  8032fb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803301:	8b 45 08             	mov    0x8(%ebp),%eax
  803304:	89 10                	mov    %edx,(%eax)
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	8b 00                	mov    (%eax),%eax
  80330b:	85 c0                	test   %eax,%eax
  80330d:	74 0d                	je     80331c <insert_sorted_with_merge_freeList+0x264>
  80330f:	a1 48 51 80 00       	mov    0x805148,%eax
  803314:	8b 55 08             	mov    0x8(%ebp),%edx
  803317:	89 50 04             	mov    %edx,0x4(%eax)
  80331a:	eb 08                	jmp    803324 <insert_sorted_with_merge_freeList+0x26c>
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803324:	8b 45 08             	mov    0x8(%ebp),%eax
  803327:	a3 48 51 80 00       	mov    %eax,0x805148
  80332c:	8b 45 08             	mov    0x8(%ebp),%eax
  80332f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803336:	a1 54 51 80 00       	mov    0x805154,%eax
  80333b:	40                   	inc    %eax
  80333c:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803341:	e9 bb 04 00 00       	jmp    803801 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803346:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334a:	75 17                	jne    803363 <insert_sorted_with_merge_freeList+0x2ab>
  80334c:	83 ec 04             	sub    $0x4,%esp
  80334f:	68 cc 43 80 00       	push   $0x8043cc
  803354:	68 4c 01 00 00       	push   $0x14c
  803359:	68 7b 43 80 00       	push   $0x80437b
  80335e:	e8 f6 d3 ff ff       	call   800759 <_panic>
  803363:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	89 50 04             	mov    %edx,0x4(%eax)
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	8b 40 04             	mov    0x4(%eax),%eax
  803375:	85 c0                	test   %eax,%eax
  803377:	74 0c                	je     803385 <insert_sorted_with_merge_freeList+0x2cd>
  803379:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80337e:	8b 55 08             	mov    0x8(%ebp),%edx
  803381:	89 10                	mov    %edx,(%eax)
  803383:	eb 08                	jmp    80338d <insert_sorted_with_merge_freeList+0x2d5>
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	a3 38 51 80 00       	mov    %eax,0x805138
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803395:	8b 45 08             	mov    0x8(%ebp),%eax
  803398:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339e:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a3:	40                   	inc    %eax
  8033a4:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033a9:	e9 53 04 00 00       	jmp    803801 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033ae:	a1 38 51 80 00       	mov    0x805138,%eax
  8033b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b6:	e9 15 04 00 00       	jmp    8037d0 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	8b 50 08             	mov    0x8(%eax),%edx
  8033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cc:	8b 40 08             	mov    0x8(%eax),%eax
  8033cf:	39 c2                	cmp    %eax,%edx
  8033d1:	0f 86 f1 03 00 00    	jbe    8037c8 <insert_sorted_with_merge_freeList+0x710>
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	8b 50 08             	mov    0x8(%eax),%edx
  8033dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e0:	8b 40 08             	mov    0x8(%eax),%eax
  8033e3:	39 c2                	cmp    %eax,%edx
  8033e5:	0f 83 dd 03 00 00    	jae    8037c8 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	8b 50 08             	mov    0x8(%eax),%edx
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f7:	01 c2                	add    %eax,%edx
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	8b 40 08             	mov    0x8(%eax),%eax
  8033ff:	39 c2                	cmp    %eax,%edx
  803401:	0f 85 b9 01 00 00    	jne    8035c0 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	8b 50 08             	mov    0x8(%eax),%edx
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	8b 40 0c             	mov    0xc(%eax),%eax
  803413:	01 c2                	add    %eax,%edx
  803415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803418:	8b 40 08             	mov    0x8(%eax),%eax
  80341b:	39 c2                	cmp    %eax,%edx
  80341d:	0f 85 0d 01 00 00    	jne    803530 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	8b 50 0c             	mov    0xc(%eax),%edx
  803429:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342c:	8b 40 0c             	mov    0xc(%eax),%eax
  80342f:	01 c2                	add    %eax,%edx
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803437:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80343b:	75 17                	jne    803454 <insert_sorted_with_merge_freeList+0x39c>
  80343d:	83 ec 04             	sub    $0x4,%esp
  803440:	68 24 44 80 00       	push   $0x804424
  803445:	68 5c 01 00 00       	push   $0x15c
  80344a:	68 7b 43 80 00       	push   $0x80437b
  80344f:	e8 05 d3 ff ff       	call   800759 <_panic>
  803454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803457:	8b 00                	mov    (%eax),%eax
  803459:	85 c0                	test   %eax,%eax
  80345b:	74 10                	je     80346d <insert_sorted_with_merge_freeList+0x3b5>
  80345d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803460:	8b 00                	mov    (%eax),%eax
  803462:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803465:	8b 52 04             	mov    0x4(%edx),%edx
  803468:	89 50 04             	mov    %edx,0x4(%eax)
  80346b:	eb 0b                	jmp    803478 <insert_sorted_with_merge_freeList+0x3c0>
  80346d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803470:	8b 40 04             	mov    0x4(%eax),%eax
  803473:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803478:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347b:	8b 40 04             	mov    0x4(%eax),%eax
  80347e:	85 c0                	test   %eax,%eax
  803480:	74 0f                	je     803491 <insert_sorted_with_merge_freeList+0x3d9>
  803482:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803485:	8b 40 04             	mov    0x4(%eax),%eax
  803488:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80348b:	8b 12                	mov    (%edx),%edx
  80348d:	89 10                	mov    %edx,(%eax)
  80348f:	eb 0a                	jmp    80349b <insert_sorted_with_merge_freeList+0x3e3>
  803491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803494:	8b 00                	mov    (%eax),%eax
  803496:	a3 38 51 80 00       	mov    %eax,0x805138
  80349b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8034b3:	48                   	dec    %eax
  8034b4:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8034b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8034c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034d1:	75 17                	jne    8034ea <insert_sorted_with_merge_freeList+0x432>
  8034d3:	83 ec 04             	sub    $0x4,%esp
  8034d6:	68 58 43 80 00       	push   $0x804358
  8034db:	68 5f 01 00 00       	push   $0x15f
  8034e0:	68 7b 43 80 00       	push   $0x80437b
  8034e5:	e8 6f d2 ff ff       	call   800759 <_panic>
  8034ea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f3:	89 10                	mov    %edx,(%eax)
  8034f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f8:	8b 00                	mov    (%eax),%eax
  8034fa:	85 c0                	test   %eax,%eax
  8034fc:	74 0d                	je     80350b <insert_sorted_with_merge_freeList+0x453>
  8034fe:	a1 48 51 80 00       	mov    0x805148,%eax
  803503:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803506:	89 50 04             	mov    %edx,0x4(%eax)
  803509:	eb 08                	jmp    803513 <insert_sorted_with_merge_freeList+0x45b>
  80350b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803513:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803516:	a3 48 51 80 00       	mov    %eax,0x805148
  80351b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803525:	a1 54 51 80 00       	mov    0x805154,%eax
  80352a:	40                   	inc    %eax
  80352b:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803533:	8b 50 0c             	mov    0xc(%eax),%edx
  803536:	8b 45 08             	mov    0x8(%ebp),%eax
  803539:	8b 40 0c             	mov    0xc(%eax),%eax
  80353c:	01 c2                	add    %eax,%edx
  80353e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803541:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803558:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80355c:	75 17                	jne    803575 <insert_sorted_with_merge_freeList+0x4bd>
  80355e:	83 ec 04             	sub    $0x4,%esp
  803561:	68 58 43 80 00       	push   $0x804358
  803566:	68 64 01 00 00       	push   $0x164
  80356b:	68 7b 43 80 00       	push   $0x80437b
  803570:	e8 e4 d1 ff ff       	call   800759 <_panic>
  803575:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80357b:	8b 45 08             	mov    0x8(%ebp),%eax
  80357e:	89 10                	mov    %edx,(%eax)
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	8b 00                	mov    (%eax),%eax
  803585:	85 c0                	test   %eax,%eax
  803587:	74 0d                	je     803596 <insert_sorted_with_merge_freeList+0x4de>
  803589:	a1 48 51 80 00       	mov    0x805148,%eax
  80358e:	8b 55 08             	mov    0x8(%ebp),%edx
  803591:	89 50 04             	mov    %edx,0x4(%eax)
  803594:	eb 08                	jmp    80359e <insert_sorted_with_merge_freeList+0x4e6>
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	a3 48 51 80 00       	mov    %eax,0x805148
  8035a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8035b5:	40                   	inc    %eax
  8035b6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035bb:	e9 41 02 00 00       	jmp    803801 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	8b 50 08             	mov    0x8(%eax),%edx
  8035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035cc:	01 c2                	add    %eax,%edx
  8035ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d1:	8b 40 08             	mov    0x8(%eax),%eax
  8035d4:	39 c2                	cmp    %eax,%edx
  8035d6:	0f 85 7c 01 00 00    	jne    803758 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8035dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035e0:	74 06                	je     8035e8 <insert_sorted_with_merge_freeList+0x530>
  8035e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e6:	75 17                	jne    8035ff <insert_sorted_with_merge_freeList+0x547>
  8035e8:	83 ec 04             	sub    $0x4,%esp
  8035eb:	68 94 43 80 00       	push   $0x804394
  8035f0:	68 69 01 00 00       	push   $0x169
  8035f5:	68 7b 43 80 00       	push   $0x80437b
  8035fa:	e8 5a d1 ff ff       	call   800759 <_panic>
  8035ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803602:	8b 50 04             	mov    0x4(%eax),%edx
  803605:	8b 45 08             	mov    0x8(%ebp),%eax
  803608:	89 50 04             	mov    %edx,0x4(%eax)
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803611:	89 10                	mov    %edx,(%eax)
  803613:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803616:	8b 40 04             	mov    0x4(%eax),%eax
  803619:	85 c0                	test   %eax,%eax
  80361b:	74 0d                	je     80362a <insert_sorted_with_merge_freeList+0x572>
  80361d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803620:	8b 40 04             	mov    0x4(%eax),%eax
  803623:	8b 55 08             	mov    0x8(%ebp),%edx
  803626:	89 10                	mov    %edx,(%eax)
  803628:	eb 08                	jmp    803632 <insert_sorted_with_merge_freeList+0x57a>
  80362a:	8b 45 08             	mov    0x8(%ebp),%eax
  80362d:	a3 38 51 80 00       	mov    %eax,0x805138
  803632:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803635:	8b 55 08             	mov    0x8(%ebp),%edx
  803638:	89 50 04             	mov    %edx,0x4(%eax)
  80363b:	a1 44 51 80 00       	mov    0x805144,%eax
  803640:	40                   	inc    %eax
  803641:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803646:	8b 45 08             	mov    0x8(%ebp),%eax
  803649:	8b 50 0c             	mov    0xc(%eax),%edx
  80364c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364f:	8b 40 0c             	mov    0xc(%eax),%eax
  803652:	01 c2                	add    %eax,%edx
  803654:	8b 45 08             	mov    0x8(%ebp),%eax
  803657:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80365a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80365e:	75 17                	jne    803677 <insert_sorted_with_merge_freeList+0x5bf>
  803660:	83 ec 04             	sub    $0x4,%esp
  803663:	68 24 44 80 00       	push   $0x804424
  803668:	68 6b 01 00 00       	push   $0x16b
  80366d:	68 7b 43 80 00       	push   $0x80437b
  803672:	e8 e2 d0 ff ff       	call   800759 <_panic>
  803677:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367a:	8b 00                	mov    (%eax),%eax
  80367c:	85 c0                	test   %eax,%eax
  80367e:	74 10                	je     803690 <insert_sorted_with_merge_freeList+0x5d8>
  803680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803683:	8b 00                	mov    (%eax),%eax
  803685:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803688:	8b 52 04             	mov    0x4(%edx),%edx
  80368b:	89 50 04             	mov    %edx,0x4(%eax)
  80368e:	eb 0b                	jmp    80369b <insert_sorted_with_merge_freeList+0x5e3>
  803690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803693:	8b 40 04             	mov    0x4(%eax),%eax
  803696:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80369b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369e:	8b 40 04             	mov    0x4(%eax),%eax
  8036a1:	85 c0                	test   %eax,%eax
  8036a3:	74 0f                	je     8036b4 <insert_sorted_with_merge_freeList+0x5fc>
  8036a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a8:	8b 40 04             	mov    0x4(%eax),%eax
  8036ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ae:	8b 12                	mov    (%edx),%edx
  8036b0:	89 10                	mov    %edx,(%eax)
  8036b2:	eb 0a                	jmp    8036be <insert_sorted_with_merge_freeList+0x606>
  8036b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b7:	8b 00                	mov    (%eax),%eax
  8036b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8036be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8036d6:	48                   	dec    %eax
  8036d7:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8036dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8036e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036f4:	75 17                	jne    80370d <insert_sorted_with_merge_freeList+0x655>
  8036f6:	83 ec 04             	sub    $0x4,%esp
  8036f9:	68 58 43 80 00       	push   $0x804358
  8036fe:	68 6e 01 00 00       	push   $0x16e
  803703:	68 7b 43 80 00       	push   $0x80437b
  803708:	e8 4c d0 ff ff       	call   800759 <_panic>
  80370d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803713:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803716:	89 10                	mov    %edx,(%eax)
  803718:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371b:	8b 00                	mov    (%eax),%eax
  80371d:	85 c0                	test   %eax,%eax
  80371f:	74 0d                	je     80372e <insert_sorted_with_merge_freeList+0x676>
  803721:	a1 48 51 80 00       	mov    0x805148,%eax
  803726:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803729:	89 50 04             	mov    %edx,0x4(%eax)
  80372c:	eb 08                	jmp    803736 <insert_sorted_with_merge_freeList+0x67e>
  80372e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803731:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803736:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803739:	a3 48 51 80 00       	mov    %eax,0x805148
  80373e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803741:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803748:	a1 54 51 80 00       	mov    0x805154,%eax
  80374d:	40                   	inc    %eax
  80374e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803753:	e9 a9 00 00 00       	jmp    803801 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80375c:	74 06                	je     803764 <insert_sorted_with_merge_freeList+0x6ac>
  80375e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803762:	75 17                	jne    80377b <insert_sorted_with_merge_freeList+0x6c3>
  803764:	83 ec 04             	sub    $0x4,%esp
  803767:	68 f0 43 80 00       	push   $0x8043f0
  80376c:	68 73 01 00 00       	push   $0x173
  803771:	68 7b 43 80 00       	push   $0x80437b
  803776:	e8 de cf ff ff       	call   800759 <_panic>
  80377b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377e:	8b 10                	mov    (%eax),%edx
  803780:	8b 45 08             	mov    0x8(%ebp),%eax
  803783:	89 10                	mov    %edx,(%eax)
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	8b 00                	mov    (%eax),%eax
  80378a:	85 c0                	test   %eax,%eax
  80378c:	74 0b                	je     803799 <insert_sorted_with_merge_freeList+0x6e1>
  80378e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803791:	8b 00                	mov    (%eax),%eax
  803793:	8b 55 08             	mov    0x8(%ebp),%edx
  803796:	89 50 04             	mov    %edx,0x4(%eax)
  803799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379c:	8b 55 08             	mov    0x8(%ebp),%edx
  80379f:	89 10                	mov    %edx,(%eax)
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a7:	89 50 04             	mov    %edx,0x4(%eax)
  8037aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ad:	8b 00                	mov    (%eax),%eax
  8037af:	85 c0                	test   %eax,%eax
  8037b1:	75 08                	jne    8037bb <insert_sorted_with_merge_freeList+0x703>
  8037b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8037c0:	40                   	inc    %eax
  8037c1:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8037c6:	eb 39                	jmp    803801 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8037c8:	a1 40 51 80 00       	mov    0x805140,%eax
  8037cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d4:	74 07                	je     8037dd <insert_sorted_with_merge_freeList+0x725>
  8037d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	eb 05                	jmp    8037e2 <insert_sorted_with_merge_freeList+0x72a>
  8037dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e2:	a3 40 51 80 00       	mov    %eax,0x805140
  8037e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8037ec:	85 c0                	test   %eax,%eax
  8037ee:	0f 85 c7 fb ff ff    	jne    8033bb <insert_sorted_with_merge_freeList+0x303>
  8037f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f8:	0f 85 bd fb ff ff    	jne    8033bb <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037fe:	eb 01                	jmp    803801 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803800:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803801:	90                   	nop
  803802:	c9                   	leave  
  803803:	c3                   	ret    

00803804 <__udivdi3>:
  803804:	55                   	push   %ebp
  803805:	57                   	push   %edi
  803806:	56                   	push   %esi
  803807:	53                   	push   %ebx
  803808:	83 ec 1c             	sub    $0x1c,%esp
  80380b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80380f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803813:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803817:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80381b:	89 ca                	mov    %ecx,%edx
  80381d:	89 f8                	mov    %edi,%eax
  80381f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803823:	85 f6                	test   %esi,%esi
  803825:	75 2d                	jne    803854 <__udivdi3+0x50>
  803827:	39 cf                	cmp    %ecx,%edi
  803829:	77 65                	ja     803890 <__udivdi3+0x8c>
  80382b:	89 fd                	mov    %edi,%ebp
  80382d:	85 ff                	test   %edi,%edi
  80382f:	75 0b                	jne    80383c <__udivdi3+0x38>
  803831:	b8 01 00 00 00       	mov    $0x1,%eax
  803836:	31 d2                	xor    %edx,%edx
  803838:	f7 f7                	div    %edi
  80383a:	89 c5                	mov    %eax,%ebp
  80383c:	31 d2                	xor    %edx,%edx
  80383e:	89 c8                	mov    %ecx,%eax
  803840:	f7 f5                	div    %ebp
  803842:	89 c1                	mov    %eax,%ecx
  803844:	89 d8                	mov    %ebx,%eax
  803846:	f7 f5                	div    %ebp
  803848:	89 cf                	mov    %ecx,%edi
  80384a:	89 fa                	mov    %edi,%edx
  80384c:	83 c4 1c             	add    $0x1c,%esp
  80384f:	5b                   	pop    %ebx
  803850:	5e                   	pop    %esi
  803851:	5f                   	pop    %edi
  803852:	5d                   	pop    %ebp
  803853:	c3                   	ret    
  803854:	39 ce                	cmp    %ecx,%esi
  803856:	77 28                	ja     803880 <__udivdi3+0x7c>
  803858:	0f bd fe             	bsr    %esi,%edi
  80385b:	83 f7 1f             	xor    $0x1f,%edi
  80385e:	75 40                	jne    8038a0 <__udivdi3+0x9c>
  803860:	39 ce                	cmp    %ecx,%esi
  803862:	72 0a                	jb     80386e <__udivdi3+0x6a>
  803864:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803868:	0f 87 9e 00 00 00    	ja     80390c <__udivdi3+0x108>
  80386e:	b8 01 00 00 00       	mov    $0x1,%eax
  803873:	89 fa                	mov    %edi,%edx
  803875:	83 c4 1c             	add    $0x1c,%esp
  803878:	5b                   	pop    %ebx
  803879:	5e                   	pop    %esi
  80387a:	5f                   	pop    %edi
  80387b:	5d                   	pop    %ebp
  80387c:	c3                   	ret    
  80387d:	8d 76 00             	lea    0x0(%esi),%esi
  803880:	31 ff                	xor    %edi,%edi
  803882:	31 c0                	xor    %eax,%eax
  803884:	89 fa                	mov    %edi,%edx
  803886:	83 c4 1c             	add    $0x1c,%esp
  803889:	5b                   	pop    %ebx
  80388a:	5e                   	pop    %esi
  80388b:	5f                   	pop    %edi
  80388c:	5d                   	pop    %ebp
  80388d:	c3                   	ret    
  80388e:	66 90                	xchg   %ax,%ax
  803890:	89 d8                	mov    %ebx,%eax
  803892:	f7 f7                	div    %edi
  803894:	31 ff                	xor    %edi,%edi
  803896:	89 fa                	mov    %edi,%edx
  803898:	83 c4 1c             	add    $0x1c,%esp
  80389b:	5b                   	pop    %ebx
  80389c:	5e                   	pop    %esi
  80389d:	5f                   	pop    %edi
  80389e:	5d                   	pop    %ebp
  80389f:	c3                   	ret    
  8038a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038a5:	89 eb                	mov    %ebp,%ebx
  8038a7:	29 fb                	sub    %edi,%ebx
  8038a9:	89 f9                	mov    %edi,%ecx
  8038ab:	d3 e6                	shl    %cl,%esi
  8038ad:	89 c5                	mov    %eax,%ebp
  8038af:	88 d9                	mov    %bl,%cl
  8038b1:	d3 ed                	shr    %cl,%ebp
  8038b3:	89 e9                	mov    %ebp,%ecx
  8038b5:	09 f1                	or     %esi,%ecx
  8038b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038bb:	89 f9                	mov    %edi,%ecx
  8038bd:	d3 e0                	shl    %cl,%eax
  8038bf:	89 c5                	mov    %eax,%ebp
  8038c1:	89 d6                	mov    %edx,%esi
  8038c3:	88 d9                	mov    %bl,%cl
  8038c5:	d3 ee                	shr    %cl,%esi
  8038c7:	89 f9                	mov    %edi,%ecx
  8038c9:	d3 e2                	shl    %cl,%edx
  8038cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038cf:	88 d9                	mov    %bl,%cl
  8038d1:	d3 e8                	shr    %cl,%eax
  8038d3:	09 c2                	or     %eax,%edx
  8038d5:	89 d0                	mov    %edx,%eax
  8038d7:	89 f2                	mov    %esi,%edx
  8038d9:	f7 74 24 0c          	divl   0xc(%esp)
  8038dd:	89 d6                	mov    %edx,%esi
  8038df:	89 c3                	mov    %eax,%ebx
  8038e1:	f7 e5                	mul    %ebp
  8038e3:	39 d6                	cmp    %edx,%esi
  8038e5:	72 19                	jb     803900 <__udivdi3+0xfc>
  8038e7:	74 0b                	je     8038f4 <__udivdi3+0xf0>
  8038e9:	89 d8                	mov    %ebx,%eax
  8038eb:	31 ff                	xor    %edi,%edi
  8038ed:	e9 58 ff ff ff       	jmp    80384a <__udivdi3+0x46>
  8038f2:	66 90                	xchg   %ax,%ax
  8038f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038f8:	89 f9                	mov    %edi,%ecx
  8038fa:	d3 e2                	shl    %cl,%edx
  8038fc:	39 c2                	cmp    %eax,%edx
  8038fe:	73 e9                	jae    8038e9 <__udivdi3+0xe5>
  803900:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803903:	31 ff                	xor    %edi,%edi
  803905:	e9 40 ff ff ff       	jmp    80384a <__udivdi3+0x46>
  80390a:	66 90                	xchg   %ax,%ax
  80390c:	31 c0                	xor    %eax,%eax
  80390e:	e9 37 ff ff ff       	jmp    80384a <__udivdi3+0x46>
  803913:	90                   	nop

00803914 <__umoddi3>:
  803914:	55                   	push   %ebp
  803915:	57                   	push   %edi
  803916:	56                   	push   %esi
  803917:	53                   	push   %ebx
  803918:	83 ec 1c             	sub    $0x1c,%esp
  80391b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80391f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803923:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803927:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80392b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80392f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803933:	89 f3                	mov    %esi,%ebx
  803935:	89 fa                	mov    %edi,%edx
  803937:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80393b:	89 34 24             	mov    %esi,(%esp)
  80393e:	85 c0                	test   %eax,%eax
  803940:	75 1a                	jne    80395c <__umoddi3+0x48>
  803942:	39 f7                	cmp    %esi,%edi
  803944:	0f 86 a2 00 00 00    	jbe    8039ec <__umoddi3+0xd8>
  80394a:	89 c8                	mov    %ecx,%eax
  80394c:	89 f2                	mov    %esi,%edx
  80394e:	f7 f7                	div    %edi
  803950:	89 d0                	mov    %edx,%eax
  803952:	31 d2                	xor    %edx,%edx
  803954:	83 c4 1c             	add    $0x1c,%esp
  803957:	5b                   	pop    %ebx
  803958:	5e                   	pop    %esi
  803959:	5f                   	pop    %edi
  80395a:	5d                   	pop    %ebp
  80395b:	c3                   	ret    
  80395c:	39 f0                	cmp    %esi,%eax
  80395e:	0f 87 ac 00 00 00    	ja     803a10 <__umoddi3+0xfc>
  803964:	0f bd e8             	bsr    %eax,%ebp
  803967:	83 f5 1f             	xor    $0x1f,%ebp
  80396a:	0f 84 ac 00 00 00    	je     803a1c <__umoddi3+0x108>
  803970:	bf 20 00 00 00       	mov    $0x20,%edi
  803975:	29 ef                	sub    %ebp,%edi
  803977:	89 fe                	mov    %edi,%esi
  803979:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80397d:	89 e9                	mov    %ebp,%ecx
  80397f:	d3 e0                	shl    %cl,%eax
  803981:	89 d7                	mov    %edx,%edi
  803983:	89 f1                	mov    %esi,%ecx
  803985:	d3 ef                	shr    %cl,%edi
  803987:	09 c7                	or     %eax,%edi
  803989:	89 e9                	mov    %ebp,%ecx
  80398b:	d3 e2                	shl    %cl,%edx
  80398d:	89 14 24             	mov    %edx,(%esp)
  803990:	89 d8                	mov    %ebx,%eax
  803992:	d3 e0                	shl    %cl,%eax
  803994:	89 c2                	mov    %eax,%edx
  803996:	8b 44 24 08          	mov    0x8(%esp),%eax
  80399a:	d3 e0                	shl    %cl,%eax
  80399c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039a4:	89 f1                	mov    %esi,%ecx
  8039a6:	d3 e8                	shr    %cl,%eax
  8039a8:	09 d0                	or     %edx,%eax
  8039aa:	d3 eb                	shr    %cl,%ebx
  8039ac:	89 da                	mov    %ebx,%edx
  8039ae:	f7 f7                	div    %edi
  8039b0:	89 d3                	mov    %edx,%ebx
  8039b2:	f7 24 24             	mull   (%esp)
  8039b5:	89 c6                	mov    %eax,%esi
  8039b7:	89 d1                	mov    %edx,%ecx
  8039b9:	39 d3                	cmp    %edx,%ebx
  8039bb:	0f 82 87 00 00 00    	jb     803a48 <__umoddi3+0x134>
  8039c1:	0f 84 91 00 00 00    	je     803a58 <__umoddi3+0x144>
  8039c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039cb:	29 f2                	sub    %esi,%edx
  8039cd:	19 cb                	sbb    %ecx,%ebx
  8039cf:	89 d8                	mov    %ebx,%eax
  8039d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039d5:	d3 e0                	shl    %cl,%eax
  8039d7:	89 e9                	mov    %ebp,%ecx
  8039d9:	d3 ea                	shr    %cl,%edx
  8039db:	09 d0                	or     %edx,%eax
  8039dd:	89 e9                	mov    %ebp,%ecx
  8039df:	d3 eb                	shr    %cl,%ebx
  8039e1:	89 da                	mov    %ebx,%edx
  8039e3:	83 c4 1c             	add    $0x1c,%esp
  8039e6:	5b                   	pop    %ebx
  8039e7:	5e                   	pop    %esi
  8039e8:	5f                   	pop    %edi
  8039e9:	5d                   	pop    %ebp
  8039ea:	c3                   	ret    
  8039eb:	90                   	nop
  8039ec:	89 fd                	mov    %edi,%ebp
  8039ee:	85 ff                	test   %edi,%edi
  8039f0:	75 0b                	jne    8039fd <__umoddi3+0xe9>
  8039f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8039f7:	31 d2                	xor    %edx,%edx
  8039f9:	f7 f7                	div    %edi
  8039fb:	89 c5                	mov    %eax,%ebp
  8039fd:	89 f0                	mov    %esi,%eax
  8039ff:	31 d2                	xor    %edx,%edx
  803a01:	f7 f5                	div    %ebp
  803a03:	89 c8                	mov    %ecx,%eax
  803a05:	f7 f5                	div    %ebp
  803a07:	89 d0                	mov    %edx,%eax
  803a09:	e9 44 ff ff ff       	jmp    803952 <__umoddi3+0x3e>
  803a0e:	66 90                	xchg   %ax,%ax
  803a10:	89 c8                	mov    %ecx,%eax
  803a12:	89 f2                	mov    %esi,%edx
  803a14:	83 c4 1c             	add    $0x1c,%esp
  803a17:	5b                   	pop    %ebx
  803a18:	5e                   	pop    %esi
  803a19:	5f                   	pop    %edi
  803a1a:	5d                   	pop    %ebp
  803a1b:	c3                   	ret    
  803a1c:	3b 04 24             	cmp    (%esp),%eax
  803a1f:	72 06                	jb     803a27 <__umoddi3+0x113>
  803a21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a25:	77 0f                	ja     803a36 <__umoddi3+0x122>
  803a27:	89 f2                	mov    %esi,%edx
  803a29:	29 f9                	sub    %edi,%ecx
  803a2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a2f:	89 14 24             	mov    %edx,(%esp)
  803a32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a36:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a3a:	8b 14 24             	mov    (%esp),%edx
  803a3d:	83 c4 1c             	add    $0x1c,%esp
  803a40:	5b                   	pop    %ebx
  803a41:	5e                   	pop    %esi
  803a42:	5f                   	pop    %edi
  803a43:	5d                   	pop    %ebp
  803a44:	c3                   	ret    
  803a45:	8d 76 00             	lea    0x0(%esi),%esi
  803a48:	2b 04 24             	sub    (%esp),%eax
  803a4b:	19 fa                	sbb    %edi,%edx
  803a4d:	89 d1                	mov    %edx,%ecx
  803a4f:	89 c6                	mov    %eax,%esi
  803a51:	e9 71 ff ff ff       	jmp    8039c7 <__umoddi3+0xb3>
  803a56:	66 90                	xchg   %ax,%ax
  803a58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a5c:	72 ea                	jb     803a48 <__umoddi3+0x134>
  803a5e:	89 d9                	mov    %ebx,%ecx
  803a60:	e9 62 ff ff ff       	jmp    8039c7 <__umoddi3+0xb3>
