
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
  800044:	e8 65 1e 00 00       	call   801eae <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 15 3a 80 00       	mov    $0x803a15,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 1f 3a 80 00       	mov    $0x803a1f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 2b 3a 80 00       	mov    $0x803a2b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 3a 3a 80 00       	mov    $0x803a3a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 49 3a 80 00       	mov    $0x803a49,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 5e 3a 80 00       	mov    $0x803a5e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 73 3a 80 00       	mov    $0x803a73,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 84 3a 80 00       	mov    $0x803a84,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 95 3a 80 00       	mov    $0x803a95,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb a6 3a 80 00       	mov    $0x803aa6,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb af 3a 80 00       	mov    $0x803aaf,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb b9 3a 80 00       	mov    $0x803ab9,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb c4 3a 80 00       	mov    $0x803ac4,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb d0 3a 80 00       	mov    $0x803ad0,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb da 3a 80 00       	mov    $0x803ada,%ebx
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
  8001c1:	bb e4 3a 80 00       	mov    $0x803ae4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb f2 3a 80 00       	mov    $0x803af2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 01 3b 80 00       	mov    $0x803b01,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 08 3b 80 00       	mov    $0x803b08,%ebx
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
  800225:	e8 e7 17 00 00       	call   801a11 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 d2 17 00 00       	call   801a11 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 bd 17 00 00       	call   801a11 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 a5 17 00 00       	call   801a11 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 8d 17 00 00       	call   801a11 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 75 17 00 00       	call   801a11 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 5d 17 00 00       	call   801a11 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 45 17 00 00       	call   801a11 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 2d 17 00 00       	call   801a11 <sget>
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
  8002f7:	e8 53 1a 00 00       	call   801d4f <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 3e 1a 00 00       	call   801d4f <sys_waitSemaphore>
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
  800344:	e8 24 1a 00 00       	call   801d6d <sys_signalSemaphore>
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
  80038b:	e8 bf 19 00 00       	call   801d4f <sys_waitSemaphore>
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
  8003ef:	e8 79 19 00 00       	call   801d6d <sys_signalSemaphore>
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
  800409:	e8 41 19 00 00       	call   801d4f <sys_waitSemaphore>
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
  80046d:	e8 fb 18 00 00       	call   801d6d <sys_signalSemaphore>
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
  800487:	e8 c3 18 00 00       	call   801d4f <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 ae 18 00 00       	call   801d4f <sys_waitSemaphore>
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
  800557:	e8 11 18 00 00       	call   801d6d <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 fc 17 00 00       	call   801d6d <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 e0 39 80 00       	push   $0x8039e0
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 00 3a 80 00       	push   $0x803a00
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb 0f 3b 80 00       	mov    $0x803b0f,%ebx
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
  8005fb:	e8 6d 17 00 00       	call   801d6d <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 58 17 00 00       	call   801d6d <sys_signalSemaphore>
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
  800623:	e8 6d 18 00 00       	call   801e95 <sys_getenvindex>
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
  80068e:	e8 0f 16 00 00       	call   801ca2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 48 3b 80 00       	push   $0x803b48
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
  8006be:	68 70 3b 80 00       	push   $0x803b70
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
  8006ef:	68 98 3b 80 00       	push   $0x803b98
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 f0 3b 80 00       	push   $0x803bf0
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 48 3b 80 00       	push   $0x803b48
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 8f 15 00 00       	call   801cbc <sys_enable_interrupt>

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
  800740:	e8 1c 17 00 00       	call   801e61 <sys_destroy_env>
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
  800751:	e8 71 17 00 00       	call   801ec7 <sys_exit_env>
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
  80077a:	68 04 3c 80 00       	push   $0x803c04
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 09 3c 80 00       	push   $0x803c09
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
  8007b7:	68 25 3c 80 00       	push   $0x803c25
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
  8007e3:	68 28 3c 80 00       	push   $0x803c28
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 74 3c 80 00       	push   $0x803c74
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
  8008b5:	68 80 3c 80 00       	push   $0x803c80
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 74 3c 80 00       	push   $0x803c74
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
  800925:	68 d4 3c 80 00       	push   $0x803cd4
  80092a:	6a 44                	push   $0x44
  80092c:	68 74 3c 80 00       	push   $0x803c74
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
  80097f:	e8 70 11 00 00       	call   801af4 <sys_cputs>
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
  8009f6:	e8 f9 10 00 00       	call   801af4 <sys_cputs>
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
  800a40:	e8 5d 12 00 00       	call   801ca2 <sys_disable_interrupt>
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
  800a60:	e8 57 12 00 00       	call   801cbc <sys_enable_interrupt>
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
  800aaa:	e8 c9 2c 00 00       	call   803778 <__udivdi3>
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
  800afa:	e8 89 2d 00 00       	call   803888 <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 34 3f 80 00       	add    $0x803f34,%eax
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
  800c55:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
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
  800d36:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 45 3f 80 00       	push   $0x803f45
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
  800d5b:	68 4e 3f 80 00       	push   $0x803f4e
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
  800d88:	be 51 3f 80 00       	mov    $0x803f51,%esi
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
  8017ae:	68 b0 40 80 00       	push   $0x8040b0
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
  80187e:	e8 b5 03 00 00       	call   801c38 <sys_allocate_chunk>
  801883:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801886:	a1 20 51 80 00       	mov    0x805120,%eax
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	50                   	push   %eax
  80188f:	e8 2a 0a 00 00       	call   8022be <initialize_MemBlocksList>
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
  8018bc:	68 d5 40 80 00       	push   $0x8040d5
  8018c1:	6a 33                	push   $0x33
  8018c3:	68 f3 40 80 00       	push   $0x8040f3
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
  80193b:	68 00 41 80 00       	push   $0x804100
  801940:	6a 34                	push   $0x34
  801942:	68 f3 40 80 00       	push   $0x8040f3
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
  8019b0:	68 24 41 80 00       	push   $0x804124
  8019b5:	6a 46                	push   $0x46
  8019b7:	68 f3 40 80 00       	push   $0x8040f3
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
  8019cc:	68 4c 41 80 00       	push   $0x80414c
  8019d1:	6a 61                	push   $0x61
  8019d3:	68 f3 40 80 00       	push   $0x8040f3
  8019d8:	e8 7c ed ff ff       	call   800759 <_panic>

008019dd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 18             	sub    $0x18,%esp
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019e9:	e8 a9 fd ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019f2:	75 07                	jne    8019fb <smalloc+0x1e>
  8019f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f9:	eb 14                	jmp    801a0f <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	68 70 41 80 00       	push   $0x804170
  801a03:	6a 76                	push   $0x76
  801a05:	68 f3 40 80 00       	push   $0x8040f3
  801a0a:	e8 4a ed ff ff       	call   800759 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a17:	e8 7b fd ff ff       	call   801797 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	68 98 41 80 00       	push   $0x804198
  801a24:	68 93 00 00 00       	push   $0x93
  801a29:	68 f3 40 80 00       	push   $0x8040f3
  801a2e:	e8 26 ed ff ff       	call   800759 <_panic>

00801a33 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a39:	e8 59 fd ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	68 bc 41 80 00       	push   $0x8041bc
  801a46:	68 c5 00 00 00       	push   $0xc5
  801a4b:	68 f3 40 80 00       	push   $0x8040f3
  801a50:	e8 04 ed ff ff       	call   800759 <_panic>

00801a55 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	68 e4 41 80 00       	push   $0x8041e4
  801a63:	68 d9 00 00 00       	push   $0xd9
  801a68:	68 f3 40 80 00       	push   $0x8040f3
  801a6d:	e8 e7 ec ff ff       	call   800759 <_panic>

00801a72 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a78:	83 ec 04             	sub    $0x4,%esp
  801a7b:	68 08 42 80 00       	push   $0x804208
  801a80:	68 e4 00 00 00       	push   $0xe4
  801a85:	68 f3 40 80 00       	push   $0x8040f3
  801a8a:	e8 ca ec ff ff       	call   800759 <_panic>

00801a8f <shrink>:

}
void shrink(uint32 newSize)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a95:	83 ec 04             	sub    $0x4,%esp
  801a98:	68 08 42 80 00       	push   $0x804208
  801a9d:	68 e9 00 00 00       	push   $0xe9
  801aa2:	68 f3 40 80 00       	push   $0x8040f3
  801aa7:	e8 ad ec ff ff       	call   800759 <_panic>

00801aac <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	68 08 42 80 00       	push   $0x804208
  801aba:	68 ee 00 00 00       	push   $0xee
  801abf:	68 f3 40 80 00       	push   $0x8040f3
  801ac4:	e8 90 ec ff ff       	call   800759 <_panic>

00801ac9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	57                   	push   %edi
  801acd:	56                   	push   %esi
  801ace:	53                   	push   %ebx
  801acf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801adb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ade:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ae1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ae4:	cd 30                	int    $0x30
  801ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5f                   	pop    %edi
  801af2:	5d                   	pop    %ebp
  801af3:	c3                   	ret    

00801af4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	8b 45 10             	mov    0x10(%ebp),%eax
  801afd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b00:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	52                   	push   %edx
  801b0c:	ff 75 0c             	pushl  0xc(%ebp)
  801b0f:	50                   	push   %eax
  801b10:	6a 00                	push   $0x0
  801b12:	e8 b2 ff ff ff       	call   801ac9 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	90                   	nop
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_cgetc>:

int
sys_cgetc(void)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 01                	push   $0x1
  801b2c:	e8 98 ff ff ff       	call   801ac9 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	6a 05                	push   $0x5
  801b49:	e8 7b ff ff ff       	call   801ac9 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b58:	8b 75 18             	mov    0x18(%ebp),%esi
  801b5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	56                   	push   %esi
  801b68:	53                   	push   %ebx
  801b69:	51                   	push   %ecx
  801b6a:	52                   	push   %edx
  801b6b:	50                   	push   %eax
  801b6c:	6a 06                	push   $0x6
  801b6e:	e8 56 ff ff ff       	call   801ac9 <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b79:	5b                   	pop    %ebx
  801b7a:	5e                   	pop    %esi
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    

00801b7d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	52                   	push   %edx
  801b8d:	50                   	push   %eax
  801b8e:	6a 07                	push   $0x7
  801b90:	e8 34 ff ff ff       	call   801ac9 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	ff 75 0c             	pushl  0xc(%ebp)
  801ba6:	ff 75 08             	pushl  0x8(%ebp)
  801ba9:	6a 08                	push   $0x8
  801bab:	e8 19 ff ff ff       	call   801ac9 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 09                	push   $0x9
  801bc4:	e8 00 ff ff ff       	call   801ac9 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 0a                	push   $0xa
  801bdd:	e8 e7 fe ff ff       	call   801ac9 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 0b                	push   $0xb
  801bf6:	e8 ce fe ff ff       	call   801ac9 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	6a 0f                	push   $0xf
  801c11:	e8 b3 fe ff ff       	call   801ac9 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
	return;
  801c19:	90                   	nop
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	ff 75 0c             	pushl  0xc(%ebp)
  801c28:	ff 75 08             	pushl  0x8(%ebp)
  801c2b:	6a 10                	push   $0x10
  801c2d:	e8 97 fe ff ff       	call   801ac9 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
	return ;
  801c35:	90                   	nop
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	ff 75 10             	pushl  0x10(%ebp)
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	ff 75 08             	pushl  0x8(%ebp)
  801c48:	6a 11                	push   $0x11
  801c4a:	e8 7a fe ff ff       	call   801ac9 <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c52:	90                   	nop
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 0c                	push   $0xc
  801c64:	e8 60 fe ff ff       	call   801ac9 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	6a 0d                	push   $0xd
  801c7e:	e8 46 fe ff ff       	call   801ac9 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 0e                	push   $0xe
  801c97:	e8 2d fe ff ff       	call   801ac9 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	90                   	nop
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 13                	push   $0x13
  801cb1:	e8 13 fe ff ff       	call   801ac9 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	90                   	nop
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 14                	push   $0x14
  801ccb:	e8 f9 fd ff ff       	call   801ac9 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	90                   	nop
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 04             	sub    $0x4,%esp
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ce2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	50                   	push   %eax
  801cef:	6a 15                	push   $0x15
  801cf1:	e8 d3 fd ff ff       	call   801ac9 <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	90                   	nop
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 16                	push   $0x16
  801d0b:	e8 b9 fd ff ff       	call   801ac9 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	90                   	nop
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	50                   	push   %eax
  801d26:	6a 17                	push   $0x17
  801d28:	e8 9c fd ff ff       	call   801ac9 <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	52                   	push   %edx
  801d42:	50                   	push   %eax
  801d43:	6a 1a                	push   $0x1a
  801d45:	e8 7f fd ff ff       	call   801ac9 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	52                   	push   %edx
  801d5f:	50                   	push   %eax
  801d60:	6a 18                	push   $0x18
  801d62:	e8 62 fd ff ff       	call   801ac9 <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	90                   	nop
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	52                   	push   %edx
  801d7d:	50                   	push   %eax
  801d7e:	6a 19                	push   $0x19
  801d80:	e8 44 fd ff ff       	call   801ac9 <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	90                   	nop
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 04             	sub    $0x4,%esp
  801d91:	8b 45 10             	mov    0x10(%ebp),%eax
  801d94:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d97:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d9a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	6a 00                	push   $0x0
  801da3:	51                   	push   %ecx
  801da4:	52                   	push   %edx
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	50                   	push   %eax
  801da9:	6a 1b                	push   $0x1b
  801dab:	e8 19 fd ff ff       	call   801ac9 <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	52                   	push   %edx
  801dc5:	50                   	push   %eax
  801dc6:	6a 1c                	push   $0x1c
  801dc8:	e8 fc fc ff ff       	call   801ac9 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	51                   	push   %ecx
  801de3:	52                   	push   %edx
  801de4:	50                   	push   %eax
  801de5:	6a 1d                	push   $0x1d
  801de7:	e8 dd fc ff ff       	call   801ac9 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801df4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	52                   	push   %edx
  801e01:	50                   	push   %eax
  801e02:	6a 1e                	push   $0x1e
  801e04:	e8 c0 fc ff ff       	call   801ac9 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 1f                	push   $0x1f
  801e1d:	e8 a7 fc ff ff       	call   801ac9 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	6a 00                	push   $0x0
  801e2f:	ff 75 14             	pushl  0x14(%ebp)
  801e32:	ff 75 10             	pushl  0x10(%ebp)
  801e35:	ff 75 0c             	pushl  0xc(%ebp)
  801e38:	50                   	push   %eax
  801e39:	6a 20                	push   $0x20
  801e3b:	e8 89 fc ff ff       	call   801ac9 <syscall>
  801e40:	83 c4 18             	add    $0x18,%esp
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	50                   	push   %eax
  801e54:	6a 21                	push   $0x21
  801e56:	e8 6e fc ff ff       	call   801ac9 <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
}
  801e5e:	90                   	nop
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	50                   	push   %eax
  801e70:	6a 22                	push   $0x22
  801e72:	e8 52 fc ff ff       	call   801ac9 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 02                	push   $0x2
  801e8b:	e8 39 fc ff ff       	call   801ac9 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 03                	push   $0x3
  801ea4:	e8 20 fc ff ff       	call   801ac9 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 04                	push   $0x4
  801ebd:	e8 07 fc ff ff       	call   801ac9 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_exit_env>:


void sys_exit_env(void)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 23                	push   $0x23
  801ed6:	e8 ee fb ff ff       	call   801ac9 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	90                   	nop
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ee7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eea:	8d 50 04             	lea    0x4(%eax),%edx
  801eed:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	52                   	push   %edx
  801ef7:	50                   	push   %eax
  801ef8:	6a 24                	push   $0x24
  801efa:	e8 ca fb ff ff       	call   801ac9 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
	return result;
  801f02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f0b:	89 01                	mov    %eax,(%ecx)
  801f0d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	c9                   	leave  
  801f14:	c2 04 00             	ret    $0x4

00801f17 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	ff 75 10             	pushl  0x10(%ebp)
  801f21:	ff 75 0c             	pushl  0xc(%ebp)
  801f24:	ff 75 08             	pushl  0x8(%ebp)
  801f27:	6a 12                	push   $0x12
  801f29:	e8 9b fb ff ff       	call   801ac9 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f31:	90                   	nop
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 25                	push   $0x25
  801f43:	e8 81 fb ff ff       	call   801ac9 <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 04             	sub    $0x4,%esp
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f59:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	50                   	push   %eax
  801f66:	6a 26                	push   $0x26
  801f68:	e8 5c fb ff ff       	call   801ac9 <syscall>
  801f6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f70:	90                   	nop
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <rsttst>:
void rsttst()
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 28                	push   $0x28
  801f82:	e8 42 fb ff ff       	call   801ac9 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8a:	90                   	nop
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 04             	sub    $0x4,%esp
  801f93:	8b 45 14             	mov    0x14(%ebp),%eax
  801f96:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f99:	8b 55 18             	mov    0x18(%ebp),%edx
  801f9c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fa0:	52                   	push   %edx
  801fa1:	50                   	push   %eax
  801fa2:	ff 75 10             	pushl  0x10(%ebp)
  801fa5:	ff 75 0c             	pushl  0xc(%ebp)
  801fa8:	ff 75 08             	pushl  0x8(%ebp)
  801fab:	6a 27                	push   $0x27
  801fad:	e8 17 fb ff ff       	call   801ac9 <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb5:	90                   	nop
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <chktst>:
void chktst(uint32 n)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	ff 75 08             	pushl  0x8(%ebp)
  801fc6:	6a 29                	push   $0x29
  801fc8:	e8 fc fa ff ff       	call   801ac9 <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd0:	90                   	nop
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <inctst>:

void inctst()
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 2a                	push   $0x2a
  801fe2:	e8 e2 fa ff ff       	call   801ac9 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
	return ;
  801fea:	90                   	nop
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <gettst>:
uint32 gettst()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 2b                	push   $0x2b
  801ffc:	e8 c8 fa ff ff       	call   801ac9 <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 2c                	push   $0x2c
  802018:	e8 ac fa ff ff       	call   801ac9 <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
  802020:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802023:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802027:	75 07                	jne    802030 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802029:	b8 01 00 00 00       	mov    $0x1,%eax
  80202e:	eb 05                	jmp    802035 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 2c                	push   $0x2c
  802049:	e8 7b fa ff ff       	call   801ac9 <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
  802051:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802054:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802058:	75 07                	jne    802061 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80205a:	b8 01 00 00 00       	mov    $0x1,%eax
  80205f:	eb 05                	jmp    802066 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 2c                	push   $0x2c
  80207a:	e8 4a fa ff ff       	call   801ac9 <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
  802082:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802085:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802089:	75 07                	jne    802092 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80208b:	b8 01 00 00 00       	mov    $0x1,%eax
  802090:	eb 05                	jmp    802097 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 2c                	push   $0x2c
  8020ab:	e8 19 fa ff ff       	call   801ac9 <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
  8020b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020b6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020ba:	75 07                	jne    8020c3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c1:	eb 05                	jmp    8020c8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	ff 75 08             	pushl  0x8(%ebp)
  8020d8:	6a 2d                	push   $0x2d
  8020da:	e8 ea f9 ff ff       	call   801ac9 <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e2:	90                   	nop
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	6a 00                	push   $0x0
  8020f7:	53                   	push   %ebx
  8020f8:	51                   	push   %ecx
  8020f9:	52                   	push   %edx
  8020fa:	50                   	push   %eax
  8020fb:	6a 2e                	push   $0x2e
  8020fd:	e8 c7 f9 ff ff       	call   801ac9 <syscall>
  802102:	83 c4 18             	add    $0x18,%esp
}
  802105:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80210d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	52                   	push   %edx
  80211a:	50                   	push   %eax
  80211b:	6a 2f                	push   $0x2f
  80211d:	e8 a7 f9 ff ff       	call   801ac9 <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	68 18 42 80 00       	push   $0x804218
  802135:	e8 d3 e8 ff ff       	call   800a0d <cprintf>
  80213a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80213d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802144:	83 ec 0c             	sub    $0xc,%esp
  802147:	68 44 42 80 00       	push   $0x804244
  80214c:	e8 bc e8 ff ff       	call   800a0d <cprintf>
  802151:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802154:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802158:	a1 38 51 80 00       	mov    0x805138,%eax
  80215d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802160:	eb 56                	jmp    8021b8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802166:	74 1c                	je     802184 <print_mem_block_lists+0x5d>
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	8b 50 08             	mov    0x8(%eax),%edx
  80216e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802171:	8b 48 08             	mov    0x8(%eax),%ecx
  802174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802177:	8b 40 0c             	mov    0xc(%eax),%eax
  80217a:	01 c8                	add    %ecx,%eax
  80217c:	39 c2                	cmp    %eax,%edx
  80217e:	73 04                	jae    802184 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802180:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802187:	8b 50 08             	mov    0x8(%eax),%edx
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 40 0c             	mov    0xc(%eax),%eax
  802190:	01 c2                	add    %eax,%edx
  802192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802195:	8b 40 08             	mov    0x8(%eax),%eax
  802198:	83 ec 04             	sub    $0x4,%esp
  80219b:	52                   	push   %edx
  80219c:	50                   	push   %eax
  80219d:	68 59 42 80 00       	push   $0x804259
  8021a2:	e8 66 e8 ff ff       	call   800a0d <cprintf>
  8021a7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8021b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bc:	74 07                	je     8021c5 <print_mem_block_lists+0x9e>
  8021be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c1:	8b 00                	mov    (%eax),%eax
  8021c3:	eb 05                	jmp    8021ca <print_mem_block_lists+0xa3>
  8021c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ca:	a3 40 51 80 00       	mov    %eax,0x805140
  8021cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	75 8a                	jne    802162 <print_mem_block_lists+0x3b>
  8021d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021dc:	75 84                	jne    802162 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021de:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021e2:	75 10                	jne    8021f4 <print_mem_block_lists+0xcd>
  8021e4:	83 ec 0c             	sub    $0xc,%esp
  8021e7:	68 68 42 80 00       	push   $0x804268
  8021ec:	e8 1c e8 ff ff       	call   800a0d <cprintf>
  8021f1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021fb:	83 ec 0c             	sub    $0xc,%esp
  8021fe:	68 8c 42 80 00       	push   $0x80428c
  802203:	e8 05 e8 ff ff       	call   800a0d <cprintf>
  802208:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80220b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80220f:	a1 40 50 80 00       	mov    0x805040,%eax
  802214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802217:	eb 56                	jmp    80226f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802219:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80221d:	74 1c                	je     80223b <print_mem_block_lists+0x114>
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 50 08             	mov    0x8(%eax),%edx
  802225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802228:	8b 48 08             	mov    0x8(%eax),%ecx
  80222b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222e:	8b 40 0c             	mov    0xc(%eax),%eax
  802231:	01 c8                	add    %ecx,%eax
  802233:	39 c2                	cmp    %eax,%edx
  802235:	73 04                	jae    80223b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802237:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	8b 50 08             	mov    0x8(%eax),%edx
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 40 0c             	mov    0xc(%eax),%eax
  802247:	01 c2                	add    %eax,%edx
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	8b 40 08             	mov    0x8(%eax),%eax
  80224f:	83 ec 04             	sub    $0x4,%esp
  802252:	52                   	push   %edx
  802253:	50                   	push   %eax
  802254:	68 59 42 80 00       	push   $0x804259
  802259:	e8 af e7 ff ff       	call   800a0d <cprintf>
  80225e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802267:	a1 48 50 80 00       	mov    0x805048,%eax
  80226c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802273:	74 07                	je     80227c <print_mem_block_lists+0x155>
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	8b 00                	mov    (%eax),%eax
  80227a:	eb 05                	jmp    802281 <print_mem_block_lists+0x15a>
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
  802281:	a3 48 50 80 00       	mov    %eax,0x805048
  802286:	a1 48 50 80 00       	mov    0x805048,%eax
  80228b:	85 c0                	test   %eax,%eax
  80228d:	75 8a                	jne    802219 <print_mem_block_lists+0xf2>
  80228f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802293:	75 84                	jne    802219 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802295:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802299:	75 10                	jne    8022ab <print_mem_block_lists+0x184>
  80229b:	83 ec 0c             	sub    $0xc,%esp
  80229e:	68 a4 42 80 00       	push   $0x8042a4
  8022a3:	e8 65 e7 ff ff       	call   800a0d <cprintf>
  8022a8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022ab:	83 ec 0c             	sub    $0xc,%esp
  8022ae:	68 18 42 80 00       	push   $0x804218
  8022b3:	e8 55 e7 ff ff       	call   800a0d <cprintf>
  8022b8:	83 c4 10             	add    $0x10,%esp

}
  8022bb:	90                   	nop
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8022c4:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022cb:	00 00 00 
  8022ce:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022d5:	00 00 00 
  8022d8:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022df:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8022e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022e9:	e9 9e 00 00 00       	jmp    80238c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8022ee:	a1 50 50 80 00       	mov    0x805050,%eax
  8022f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f6:	c1 e2 04             	shl    $0x4,%edx
  8022f9:	01 d0                	add    %edx,%eax
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	75 14                	jne    802313 <initialize_MemBlocksList+0x55>
  8022ff:	83 ec 04             	sub    $0x4,%esp
  802302:	68 cc 42 80 00       	push   $0x8042cc
  802307:	6a 46                	push   $0x46
  802309:	68 ef 42 80 00       	push   $0x8042ef
  80230e:	e8 46 e4 ff ff       	call   800759 <_panic>
  802313:	a1 50 50 80 00       	mov    0x805050,%eax
  802318:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231b:	c1 e2 04             	shl    $0x4,%edx
  80231e:	01 d0                	add    %edx,%eax
  802320:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802326:	89 10                	mov    %edx,(%eax)
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	85 c0                	test   %eax,%eax
  80232c:	74 18                	je     802346 <initialize_MemBlocksList+0x88>
  80232e:	a1 48 51 80 00       	mov    0x805148,%eax
  802333:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802339:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80233c:	c1 e1 04             	shl    $0x4,%ecx
  80233f:	01 ca                	add    %ecx,%edx
  802341:	89 50 04             	mov    %edx,0x4(%eax)
  802344:	eb 12                	jmp    802358 <initialize_MemBlocksList+0x9a>
  802346:	a1 50 50 80 00       	mov    0x805050,%eax
  80234b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234e:	c1 e2 04             	shl    $0x4,%edx
  802351:	01 d0                	add    %edx,%eax
  802353:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802358:	a1 50 50 80 00       	mov    0x805050,%eax
  80235d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802360:	c1 e2 04             	shl    $0x4,%edx
  802363:	01 d0                	add    %edx,%eax
  802365:	a3 48 51 80 00       	mov    %eax,0x805148
  80236a:	a1 50 50 80 00       	mov    0x805050,%eax
  80236f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802372:	c1 e2 04             	shl    $0x4,%edx
  802375:	01 d0                	add    %edx,%eax
  802377:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80237e:	a1 54 51 80 00       	mov    0x805154,%eax
  802383:	40                   	inc    %eax
  802384:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802389:	ff 45 f4             	incl   -0xc(%ebp)
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802392:	0f 82 56 ff ff ff    	jb     8022ee <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802398:	90                   	nop
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	8b 00                	mov    (%eax),%eax
  8023a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023a9:	eb 19                	jmp    8023c4 <find_block+0x29>
	{
		if(va==point->sva)
  8023ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023ae:	8b 40 08             	mov    0x8(%eax),%eax
  8023b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023b4:	75 05                	jne    8023bb <find_block+0x20>
		   return point;
  8023b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b9:	eb 36                	jmp    8023f1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	8b 40 08             	mov    0x8(%eax),%eax
  8023c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023c8:	74 07                	je     8023d1 <find_block+0x36>
  8023ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023cd:	8b 00                	mov    (%eax),%eax
  8023cf:	eb 05                	jmp    8023d6 <find_block+0x3b>
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d9:	89 42 08             	mov    %eax,0x8(%edx)
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	8b 40 08             	mov    0x8(%eax),%eax
  8023e2:	85 c0                	test   %eax,%eax
  8023e4:	75 c5                	jne    8023ab <find_block+0x10>
  8023e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023ea:	75 bf                	jne    8023ab <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8023ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8023f9:	a1 40 50 80 00       	mov    0x805040,%eax
  8023fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802401:	a1 44 50 80 00       	mov    0x805044,%eax
  802406:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80240f:	74 24                	je     802435 <insert_sorted_allocList+0x42>
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	8b 50 08             	mov    0x8(%eax),%edx
  802417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241a:	8b 40 08             	mov    0x8(%eax),%eax
  80241d:	39 c2                	cmp    %eax,%edx
  80241f:	76 14                	jbe    802435 <insert_sorted_allocList+0x42>
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	8b 50 08             	mov    0x8(%eax),%edx
  802427:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242a:	8b 40 08             	mov    0x8(%eax),%eax
  80242d:	39 c2                	cmp    %eax,%edx
  80242f:	0f 82 60 01 00 00    	jb     802595 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802435:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802439:	75 65                	jne    8024a0 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80243b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80243f:	75 14                	jne    802455 <insert_sorted_allocList+0x62>
  802441:	83 ec 04             	sub    $0x4,%esp
  802444:	68 cc 42 80 00       	push   $0x8042cc
  802449:	6a 6b                	push   $0x6b
  80244b:	68 ef 42 80 00       	push   $0x8042ef
  802450:	e8 04 e3 ff ff       	call   800759 <_panic>
  802455:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80245b:	8b 45 08             	mov    0x8(%ebp),%eax
  80245e:	89 10                	mov    %edx,(%eax)
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	8b 00                	mov    (%eax),%eax
  802465:	85 c0                	test   %eax,%eax
  802467:	74 0d                	je     802476 <insert_sorted_allocList+0x83>
  802469:	a1 40 50 80 00       	mov    0x805040,%eax
  80246e:	8b 55 08             	mov    0x8(%ebp),%edx
  802471:	89 50 04             	mov    %edx,0x4(%eax)
  802474:	eb 08                	jmp    80247e <insert_sorted_allocList+0x8b>
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	a3 44 50 80 00       	mov    %eax,0x805044
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	a3 40 50 80 00       	mov    %eax,0x805040
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802490:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802495:	40                   	inc    %eax
  802496:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80249b:	e9 dc 01 00 00       	jmp    80267c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	8b 50 08             	mov    0x8(%eax),%edx
  8024a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a9:	8b 40 08             	mov    0x8(%eax),%eax
  8024ac:	39 c2                	cmp    %eax,%edx
  8024ae:	77 6c                	ja     80251c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8024b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024b4:	74 06                	je     8024bc <insert_sorted_allocList+0xc9>
  8024b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024ba:	75 14                	jne    8024d0 <insert_sorted_allocList+0xdd>
  8024bc:	83 ec 04             	sub    $0x4,%esp
  8024bf:	68 08 43 80 00       	push   $0x804308
  8024c4:	6a 6f                	push   $0x6f
  8024c6:	68 ef 42 80 00       	push   $0x8042ef
  8024cb:	e8 89 e2 ff ff       	call   800759 <_panic>
  8024d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d3:	8b 50 04             	mov    0x4(%eax),%edx
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	89 50 04             	mov    %edx,0x4(%eax)
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e2:	89 10                	mov    %edx,(%eax)
  8024e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	74 0d                	je     8024fb <insert_sorted_allocList+0x108>
  8024ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f1:	8b 40 04             	mov    0x4(%eax),%eax
  8024f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f7:	89 10                	mov    %edx,(%eax)
  8024f9:	eb 08                	jmp    802503 <insert_sorted_allocList+0x110>
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	a3 40 50 80 00       	mov    %eax,0x805040
  802503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802506:	8b 55 08             	mov    0x8(%ebp),%edx
  802509:	89 50 04             	mov    %edx,0x4(%eax)
  80250c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802511:	40                   	inc    %eax
  802512:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802517:	e9 60 01 00 00       	jmp    80267c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80251c:	8b 45 08             	mov    0x8(%ebp),%eax
  80251f:	8b 50 08             	mov    0x8(%eax),%edx
  802522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802525:	8b 40 08             	mov    0x8(%eax),%eax
  802528:	39 c2                	cmp    %eax,%edx
  80252a:	0f 82 4c 01 00 00    	jb     80267c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802530:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802534:	75 14                	jne    80254a <insert_sorted_allocList+0x157>
  802536:	83 ec 04             	sub    $0x4,%esp
  802539:	68 40 43 80 00       	push   $0x804340
  80253e:	6a 73                	push   $0x73
  802540:	68 ef 42 80 00       	push   $0x8042ef
  802545:	e8 0f e2 ff ff       	call   800759 <_panic>
  80254a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	89 50 04             	mov    %edx,0x4(%eax)
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	8b 40 04             	mov    0x4(%eax),%eax
  80255c:	85 c0                	test   %eax,%eax
  80255e:	74 0c                	je     80256c <insert_sorted_allocList+0x179>
  802560:	a1 44 50 80 00       	mov    0x805044,%eax
  802565:	8b 55 08             	mov    0x8(%ebp),%edx
  802568:	89 10                	mov    %edx,(%eax)
  80256a:	eb 08                	jmp    802574 <insert_sorted_allocList+0x181>
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	a3 40 50 80 00       	mov    %eax,0x805040
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	a3 44 50 80 00       	mov    %eax,0x805044
  80257c:	8b 45 08             	mov    0x8(%ebp),%eax
  80257f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802585:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80258a:	40                   	inc    %eax
  80258b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802590:	e9 e7 00 00 00       	jmp    80267c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802598:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80259b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025a2:	a1 40 50 80 00       	mov    0x805040,%eax
  8025a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025aa:	e9 9d 00 00 00       	jmp    80264c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8025b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ba:	8b 50 08             	mov    0x8(%eax),%edx
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 40 08             	mov    0x8(%eax),%eax
  8025c3:	39 c2                	cmp    %eax,%edx
  8025c5:	76 7d                	jbe    802644 <insert_sorted_allocList+0x251>
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	8b 50 08             	mov    0x8(%eax),%edx
  8025cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025d0:	8b 40 08             	mov    0x8(%eax),%eax
  8025d3:	39 c2                	cmp    %eax,%edx
  8025d5:	73 6d                	jae    802644 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8025d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025db:	74 06                	je     8025e3 <insert_sorted_allocList+0x1f0>
  8025dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025e1:	75 14                	jne    8025f7 <insert_sorted_allocList+0x204>
  8025e3:	83 ec 04             	sub    $0x4,%esp
  8025e6:	68 64 43 80 00       	push   $0x804364
  8025eb:	6a 7f                	push   $0x7f
  8025ed:	68 ef 42 80 00       	push   $0x8042ef
  8025f2:	e8 62 e1 ff ff       	call   800759 <_panic>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 10                	mov    (%eax),%edx
  8025fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ff:	89 10                	mov    %edx,(%eax)
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	85 c0                	test   %eax,%eax
  802608:	74 0b                	je     802615 <insert_sorted_allocList+0x222>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	8b 55 08             	mov    0x8(%ebp),%edx
  802612:	89 50 04             	mov    %edx,0x4(%eax)
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 55 08             	mov    0x8(%ebp),%edx
  80261b:	89 10                	mov    %edx,(%eax)
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802623:	89 50 04             	mov    %edx,0x4(%eax)
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	75 08                	jne    802637 <insert_sorted_allocList+0x244>
  80262f:	8b 45 08             	mov    0x8(%ebp),%eax
  802632:	a3 44 50 80 00       	mov    %eax,0x805044
  802637:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80263c:	40                   	inc    %eax
  80263d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802642:	eb 39                	jmp    80267d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802644:	a1 48 50 80 00       	mov    0x805048,%eax
  802649:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802650:	74 07                	je     802659 <insert_sorted_allocList+0x266>
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	eb 05                	jmp    80265e <insert_sorted_allocList+0x26b>
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
  80265e:	a3 48 50 80 00       	mov    %eax,0x805048
  802663:	a1 48 50 80 00       	mov    0x805048,%eax
  802668:	85 c0                	test   %eax,%eax
  80266a:	0f 85 3f ff ff ff    	jne    8025af <insert_sorted_allocList+0x1bc>
  802670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802674:	0f 85 35 ff ff ff    	jne    8025af <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80267a:	eb 01                	jmp    80267d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80267c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80267d:	90                   	nop
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802686:	a1 38 51 80 00       	mov    0x805138,%eax
  80268b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268e:	e9 85 01 00 00       	jmp    802818 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 0c             	mov    0xc(%eax),%eax
  802699:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269c:	0f 82 6e 01 00 00    	jb     802810 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ab:	0f 85 8a 00 00 00    	jne    80273b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8026b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b5:	75 17                	jne    8026ce <alloc_block_FF+0x4e>
  8026b7:	83 ec 04             	sub    $0x4,%esp
  8026ba:	68 98 43 80 00       	push   $0x804398
  8026bf:	68 93 00 00 00       	push   $0x93
  8026c4:	68 ef 42 80 00       	push   $0x8042ef
  8026c9:	e8 8b e0 ff ff       	call   800759 <_panic>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	74 10                	je     8026e7 <alloc_block_FF+0x67>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026df:	8b 52 04             	mov    0x4(%edx),%edx
  8026e2:	89 50 04             	mov    %edx,0x4(%eax)
  8026e5:	eb 0b                	jmp    8026f2 <alloc_block_FF+0x72>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 40 04             	mov    0x4(%eax),%eax
  8026ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 04             	mov    0x4(%eax),%eax
  8026f8:	85 c0                	test   %eax,%eax
  8026fa:	74 0f                	je     80270b <alloc_block_FF+0x8b>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 04             	mov    0x4(%eax),%eax
  802702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802705:	8b 12                	mov    (%edx),%edx
  802707:	89 10                	mov    %edx,(%eax)
  802709:	eb 0a                	jmp    802715 <alloc_block_FF+0x95>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	a3 38 51 80 00       	mov    %eax,0x805138
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802728:	a1 44 51 80 00       	mov    0x805144,%eax
  80272d:	48                   	dec    %eax
  80272e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	e9 10 01 00 00       	jmp    80284b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 40 0c             	mov    0xc(%eax),%eax
  802741:	3b 45 08             	cmp    0x8(%ebp),%eax
  802744:	0f 86 c6 00 00 00    	jbe    802810 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80274a:	a1 48 51 80 00       	mov    0x805148,%eax
  80274f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 50 08             	mov    0x8(%eax),%edx
  802758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80275e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802761:	8b 55 08             	mov    0x8(%ebp),%edx
  802764:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802767:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80276b:	75 17                	jne    802784 <alloc_block_FF+0x104>
  80276d:	83 ec 04             	sub    $0x4,%esp
  802770:	68 98 43 80 00       	push   $0x804398
  802775:	68 9b 00 00 00       	push   $0x9b
  80277a:	68 ef 42 80 00       	push   $0x8042ef
  80277f:	e8 d5 df ff ff       	call   800759 <_panic>
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 00                	mov    (%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 10                	je     80279d <alloc_block_FF+0x11d>
  80278d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802795:	8b 52 04             	mov    0x4(%edx),%edx
  802798:	89 50 04             	mov    %edx,0x4(%eax)
  80279b:	eb 0b                	jmp    8027a8 <alloc_block_FF+0x128>
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	8b 40 04             	mov    0x4(%eax),%eax
  8027a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ab:	8b 40 04             	mov    0x4(%eax),%eax
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	74 0f                	je     8027c1 <alloc_block_FF+0x141>
  8027b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b5:	8b 40 04             	mov    0x4(%eax),%eax
  8027b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027bb:	8b 12                	mov    (%edx),%edx
  8027bd:	89 10                	mov    %edx,(%eax)
  8027bf:	eb 0a                	jmp    8027cb <alloc_block_FF+0x14b>
  8027c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8027cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027de:	a1 54 51 80 00       	mov    0x805154,%eax
  8027e3:	48                   	dec    %eax
  8027e4:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 50 08             	mov    0x8(%eax),%edx
  8027ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f2:	01 c2                	add    %eax,%edx
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802800:	2b 45 08             	sub    0x8(%ebp),%eax
  802803:	89 c2                	mov    %eax,%edx
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	eb 3b                	jmp    80284b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802810:	a1 40 51 80 00       	mov    0x805140,%eax
  802815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802818:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281c:	74 07                	je     802825 <alloc_block_FF+0x1a5>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	eb 05                	jmp    80282a <alloc_block_FF+0x1aa>
  802825:	b8 00 00 00 00       	mov    $0x0,%eax
  80282a:	a3 40 51 80 00       	mov    %eax,0x805140
  80282f:	a1 40 51 80 00       	mov    0x805140,%eax
  802834:	85 c0                	test   %eax,%eax
  802836:	0f 85 57 fe ff ff    	jne    802693 <alloc_block_FF+0x13>
  80283c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802840:	0f 85 4d fe ff ff    	jne    802693 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802846:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80284b:	c9                   	leave  
  80284c:	c3                   	ret    

0080284d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80284d:	55                   	push   %ebp
  80284e:	89 e5                	mov    %esp,%ebp
  802850:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802853:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80285a:	a1 38 51 80 00       	mov    0x805138,%eax
  80285f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802862:	e9 df 00 00 00       	jmp    802946 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 40 0c             	mov    0xc(%eax),%eax
  80286d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802870:	0f 82 c8 00 00 00    	jb     80293e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 0c             	mov    0xc(%eax),%eax
  80287c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287f:	0f 85 8a 00 00 00    	jne    80290f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802889:	75 17                	jne    8028a2 <alloc_block_BF+0x55>
  80288b:	83 ec 04             	sub    $0x4,%esp
  80288e:	68 98 43 80 00       	push   $0x804398
  802893:	68 b7 00 00 00       	push   $0xb7
  802898:	68 ef 42 80 00       	push   $0x8042ef
  80289d:	e8 b7 de ff ff       	call   800759 <_panic>
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 00                	mov    (%eax),%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	74 10                	je     8028bb <alloc_block_BF+0x6e>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b3:	8b 52 04             	mov    0x4(%edx),%edx
  8028b6:	89 50 04             	mov    %edx,0x4(%eax)
  8028b9:	eb 0b                	jmp    8028c6 <alloc_block_BF+0x79>
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 40 04             	mov    0x4(%eax),%eax
  8028c1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 40 04             	mov    0x4(%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 0f                	je     8028df <alloc_block_BF+0x92>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d9:	8b 12                	mov    (%edx),%edx
  8028db:	89 10                	mov    %edx,(%eax)
  8028dd:	eb 0a                	jmp    8028e9 <alloc_block_BF+0x9c>
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	a3 38 51 80 00       	mov    %eax,0x805138
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fc:	a1 44 51 80 00       	mov    0x805144,%eax
  802901:	48                   	dec    %eax
  802902:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	e9 4d 01 00 00       	jmp    802a5c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 40 0c             	mov    0xc(%eax),%eax
  802915:	3b 45 08             	cmp    0x8(%ebp),%eax
  802918:	76 24                	jbe    80293e <alloc_block_BF+0xf1>
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 40 0c             	mov    0xc(%eax),%eax
  802920:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802923:	73 19                	jae    80293e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802925:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 40 0c             	mov    0xc(%eax),%eax
  802932:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 08             	mov    0x8(%eax),%eax
  80293b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80293e:	a1 40 51 80 00       	mov    0x805140,%eax
  802943:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294a:	74 07                	je     802953 <alloc_block_BF+0x106>
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	eb 05                	jmp    802958 <alloc_block_BF+0x10b>
  802953:	b8 00 00 00 00       	mov    $0x0,%eax
  802958:	a3 40 51 80 00       	mov    %eax,0x805140
  80295d:	a1 40 51 80 00       	mov    0x805140,%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	0f 85 fd fe ff ff    	jne    802867 <alloc_block_BF+0x1a>
  80296a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296e:	0f 85 f3 fe ff ff    	jne    802867 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802974:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802978:	0f 84 d9 00 00 00    	je     802a57 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80297e:	a1 48 51 80 00       	mov    0x805148,%eax
  802983:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802989:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80298c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80298f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802992:	8b 55 08             	mov    0x8(%ebp),%edx
  802995:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802998:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80299c:	75 17                	jne    8029b5 <alloc_block_BF+0x168>
  80299e:	83 ec 04             	sub    $0x4,%esp
  8029a1:	68 98 43 80 00       	push   $0x804398
  8029a6:	68 c7 00 00 00       	push   $0xc7
  8029ab:	68 ef 42 80 00       	push   $0x8042ef
  8029b0:	e8 a4 dd ff ff       	call   800759 <_panic>
  8029b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	74 10                	je     8029ce <alloc_block_BF+0x181>
  8029be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029c6:	8b 52 04             	mov    0x4(%edx),%edx
  8029c9:	89 50 04             	mov    %edx,0x4(%eax)
  8029cc:	eb 0b                	jmp    8029d9 <alloc_block_BF+0x18c>
  8029ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d1:	8b 40 04             	mov    0x4(%eax),%eax
  8029d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	74 0f                	je     8029f2 <alloc_block_BF+0x1a5>
  8029e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e6:	8b 40 04             	mov    0x4(%eax),%eax
  8029e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029ec:	8b 12                	mov    (%edx),%edx
  8029ee:	89 10                	mov    %edx,(%eax)
  8029f0:	eb 0a                	jmp    8029fc <alloc_block_BF+0x1af>
  8029f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	a3 48 51 80 00       	mov    %eax,0x805148
  8029fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0f:	a1 54 51 80 00       	mov    0x805154,%eax
  802a14:	48                   	dec    %eax
  802a15:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a1a:	83 ec 08             	sub    $0x8,%esp
  802a1d:	ff 75 ec             	pushl  -0x14(%ebp)
  802a20:	68 38 51 80 00       	push   $0x805138
  802a25:	e8 71 f9 ff ff       	call   80239b <find_block>
  802a2a:	83 c4 10             	add    $0x10,%esp
  802a2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a33:	8b 50 08             	mov    0x8(%eax),%edx
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	01 c2                	add    %eax,%edx
  802a3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a44:	8b 40 0c             	mov    0xc(%eax),%eax
  802a47:	2b 45 08             	sub    0x8(%ebp),%eax
  802a4a:	89 c2                	mov    %eax,%edx
  802a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a4f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a55:	eb 05                	jmp    802a5c <alloc_block_BF+0x20f>
	}
	return NULL;
  802a57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a5c:	c9                   	leave  
  802a5d:	c3                   	ret    

00802a5e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a5e:	55                   	push   %ebp
  802a5f:	89 e5                	mov    %esp,%ebp
  802a61:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a64:	a1 28 50 80 00       	mov    0x805028,%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	0f 85 de 01 00 00    	jne    802c4f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a71:	a1 38 51 80 00       	mov    0x805138,%eax
  802a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a79:	e9 9e 01 00 00       	jmp    802c1c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 40 0c             	mov    0xc(%eax),%eax
  802a84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a87:	0f 82 87 01 00 00    	jb     802c14 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 0c             	mov    0xc(%eax),%eax
  802a93:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a96:	0f 85 95 00 00 00    	jne    802b31 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa0:	75 17                	jne    802ab9 <alloc_block_NF+0x5b>
  802aa2:	83 ec 04             	sub    $0x4,%esp
  802aa5:	68 98 43 80 00       	push   $0x804398
  802aaa:	68 e0 00 00 00       	push   $0xe0
  802aaf:	68 ef 42 80 00       	push   $0x8042ef
  802ab4:	e8 a0 dc ff ff       	call   800759 <_panic>
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 10                	je     802ad2 <alloc_block_NF+0x74>
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aca:	8b 52 04             	mov    0x4(%edx),%edx
  802acd:	89 50 04             	mov    %edx,0x4(%eax)
  802ad0:	eb 0b                	jmp    802add <alloc_block_NF+0x7f>
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 40 04             	mov    0x4(%eax),%eax
  802ad8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 40 04             	mov    0x4(%eax),%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	74 0f                	je     802af6 <alloc_block_NF+0x98>
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af0:	8b 12                	mov    (%edx),%edx
  802af2:	89 10                	mov    %edx,(%eax)
  802af4:	eb 0a                	jmp    802b00 <alloc_block_NF+0xa2>
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	a3 38 51 80 00       	mov    %eax,0x805138
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b13:	a1 44 51 80 00       	mov    0x805144,%eax
  802b18:	48                   	dec    %eax
  802b19:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 40 08             	mov    0x8(%eax),%eax
  802b24:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	e9 f8 04 00 00       	jmp    803029 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 40 0c             	mov    0xc(%eax),%eax
  802b37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3a:	0f 86 d4 00 00 00    	jbe    802c14 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b40:	a1 48 51 80 00       	mov    0x805148,%eax
  802b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 50 08             	mov    0x8(%eax),%edx
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b61:	75 17                	jne    802b7a <alloc_block_NF+0x11c>
  802b63:	83 ec 04             	sub    $0x4,%esp
  802b66:	68 98 43 80 00       	push   $0x804398
  802b6b:	68 e9 00 00 00       	push   $0xe9
  802b70:	68 ef 42 80 00       	push   $0x8042ef
  802b75:	e8 df db ff ff       	call   800759 <_panic>
  802b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7d:	8b 00                	mov    (%eax),%eax
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	74 10                	je     802b93 <alloc_block_NF+0x135>
  802b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b86:	8b 00                	mov    (%eax),%eax
  802b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8b:	8b 52 04             	mov    0x4(%edx),%edx
  802b8e:	89 50 04             	mov    %edx,0x4(%eax)
  802b91:	eb 0b                	jmp    802b9e <alloc_block_NF+0x140>
  802b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0f                	je     802bb7 <alloc_block_NF+0x159>
  802ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bab:	8b 40 04             	mov    0x4(%eax),%eax
  802bae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb1:	8b 12                	mov    (%edx),%edx
  802bb3:	89 10                	mov    %edx,(%eax)
  802bb5:	eb 0a                	jmp    802bc1 <alloc_block_NF+0x163>
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	8b 00                	mov    (%eax),%eax
  802bbc:	a3 48 51 80 00       	mov    %eax,0x805148
  802bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd4:	a1 54 51 80 00       	mov    0x805154,%eax
  802bd9:	48                   	dec    %eax
  802bda:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	8b 40 08             	mov    0x8(%eax),%eax
  802be5:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 50 08             	mov    0x8(%eax),%edx
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	01 c2                	add    %eax,%edx
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802c01:	2b 45 08             	sub    0x8(%ebp),%eax
  802c04:	89 c2                	mov    %eax,%edx
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0f:	e9 15 04 00 00       	jmp    803029 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c14:	a1 40 51 80 00       	mov    0x805140,%eax
  802c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c20:	74 07                	je     802c29 <alloc_block_NF+0x1cb>
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 00                	mov    (%eax),%eax
  802c27:	eb 05                	jmp    802c2e <alloc_block_NF+0x1d0>
  802c29:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2e:	a3 40 51 80 00       	mov    %eax,0x805140
  802c33:	a1 40 51 80 00       	mov    0x805140,%eax
  802c38:	85 c0                	test   %eax,%eax
  802c3a:	0f 85 3e fe ff ff    	jne    802a7e <alloc_block_NF+0x20>
  802c40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c44:	0f 85 34 fe ff ff    	jne    802a7e <alloc_block_NF+0x20>
  802c4a:	e9 d5 03 00 00       	jmp    803024 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c4f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c57:	e9 b1 01 00 00       	jmp    802e0d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 50 08             	mov    0x8(%eax),%edx
  802c62:	a1 28 50 80 00       	mov    0x805028,%eax
  802c67:	39 c2                	cmp    %eax,%edx
  802c69:	0f 82 96 01 00 00    	jb     802e05 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 40 0c             	mov    0xc(%eax),%eax
  802c75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c78:	0f 82 87 01 00 00    	jb     802e05 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 40 0c             	mov    0xc(%eax),%eax
  802c84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c87:	0f 85 95 00 00 00    	jne    802d22 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c91:	75 17                	jne    802caa <alloc_block_NF+0x24c>
  802c93:	83 ec 04             	sub    $0x4,%esp
  802c96:	68 98 43 80 00       	push   $0x804398
  802c9b:	68 fc 00 00 00       	push   $0xfc
  802ca0:	68 ef 42 80 00       	push   $0x8042ef
  802ca5:	e8 af da ff ff       	call   800759 <_panic>
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	74 10                	je     802cc3 <alloc_block_NF+0x265>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbb:	8b 52 04             	mov    0x4(%edx),%edx
  802cbe:	89 50 04             	mov    %edx,0x4(%eax)
  802cc1:	eb 0b                	jmp    802cce <alloc_block_NF+0x270>
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	8b 40 04             	mov    0x4(%eax),%eax
  802cc9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 40 04             	mov    0x4(%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 0f                	je     802ce7 <alloc_block_NF+0x289>
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 40 04             	mov    0x4(%eax),%eax
  802cde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce1:	8b 12                	mov    (%edx),%edx
  802ce3:	89 10                	mov    %edx,(%eax)
  802ce5:	eb 0a                	jmp    802cf1 <alloc_block_NF+0x293>
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 00                	mov    (%eax),%eax
  802cec:	a3 38 51 80 00       	mov    %eax,0x805138
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d04:	a1 44 51 80 00       	mov    0x805144,%eax
  802d09:	48                   	dec    %eax
  802d0a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	8b 40 08             	mov    0x8(%eax),%eax
  802d15:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	e9 07 03 00 00       	jmp    803029 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 40 0c             	mov    0xc(%eax),%eax
  802d28:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d2b:	0f 86 d4 00 00 00    	jbe    802e05 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d31:	a1 48 51 80 00       	mov    0x805148,%eax
  802d36:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	8b 50 08             	mov    0x8(%eax),%edx
  802d3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d42:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d48:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d4e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d52:	75 17                	jne    802d6b <alloc_block_NF+0x30d>
  802d54:	83 ec 04             	sub    $0x4,%esp
  802d57:	68 98 43 80 00       	push   $0x804398
  802d5c:	68 04 01 00 00       	push   $0x104
  802d61:	68 ef 42 80 00       	push   $0x8042ef
  802d66:	e8 ee d9 ff ff       	call   800759 <_panic>
  802d6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	85 c0                	test   %eax,%eax
  802d72:	74 10                	je     802d84 <alloc_block_NF+0x326>
  802d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d77:	8b 00                	mov    (%eax),%eax
  802d79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d7c:	8b 52 04             	mov    0x4(%edx),%edx
  802d7f:	89 50 04             	mov    %edx,0x4(%eax)
  802d82:	eb 0b                	jmp    802d8f <alloc_block_NF+0x331>
  802d84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d87:	8b 40 04             	mov    0x4(%eax),%eax
  802d8a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d92:	8b 40 04             	mov    0x4(%eax),%eax
  802d95:	85 c0                	test   %eax,%eax
  802d97:	74 0f                	je     802da8 <alloc_block_NF+0x34a>
  802d99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9c:	8b 40 04             	mov    0x4(%eax),%eax
  802d9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802da2:	8b 12                	mov    (%edx),%edx
  802da4:	89 10                	mov    %edx,(%eax)
  802da6:	eb 0a                	jmp    802db2 <alloc_block_NF+0x354>
  802da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	a3 48 51 80 00       	mov    %eax,0x805148
  802db2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc5:	a1 54 51 80 00       	mov    0x805154,%eax
  802dca:	48                   	dec    %eax
  802dcb:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd3:	8b 40 08             	mov    0x8(%eax),%eax
  802dd6:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 50 08             	mov    0x8(%eax),%edx
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	01 c2                	add    %eax,%edx
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 40 0c             	mov    0xc(%eax),%eax
  802df2:	2b 45 08             	sub    0x8(%ebp),%eax
  802df5:	89 c2                	mov    %eax,%edx
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e00:	e9 24 02 00 00       	jmp    803029 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e05:	a1 40 51 80 00       	mov    0x805140,%eax
  802e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e11:	74 07                	je     802e1a <alloc_block_NF+0x3bc>
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	eb 05                	jmp    802e1f <alloc_block_NF+0x3c1>
  802e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1f:	a3 40 51 80 00       	mov    %eax,0x805140
  802e24:	a1 40 51 80 00       	mov    0x805140,%eax
  802e29:	85 c0                	test   %eax,%eax
  802e2b:	0f 85 2b fe ff ff    	jne    802c5c <alloc_block_NF+0x1fe>
  802e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e35:	0f 85 21 fe ff ff    	jne    802c5c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e3b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e43:	e9 ae 01 00 00       	jmp    802ff6 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	8b 50 08             	mov    0x8(%eax),%edx
  802e4e:	a1 28 50 80 00       	mov    0x805028,%eax
  802e53:	39 c2                	cmp    %eax,%edx
  802e55:	0f 83 93 01 00 00    	jae    802fee <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e61:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e64:	0f 82 84 01 00 00    	jb     802fee <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e73:	0f 85 95 00 00 00    	jne    802f0e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7d:	75 17                	jne    802e96 <alloc_block_NF+0x438>
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	68 98 43 80 00       	push   $0x804398
  802e87:	68 14 01 00 00       	push   $0x114
  802e8c:	68 ef 42 80 00       	push   $0x8042ef
  802e91:	e8 c3 d8 ff ff       	call   800759 <_panic>
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 10                	je     802eaf <alloc_block_NF+0x451>
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea7:	8b 52 04             	mov    0x4(%edx),%edx
  802eaa:	89 50 04             	mov    %edx,0x4(%eax)
  802ead:	eb 0b                	jmp    802eba <alloc_block_NF+0x45c>
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 40 04             	mov    0x4(%eax),%eax
  802eb5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 40 04             	mov    0x4(%eax),%eax
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	74 0f                	je     802ed3 <alloc_block_NF+0x475>
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	8b 40 04             	mov    0x4(%eax),%eax
  802eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ecd:	8b 12                	mov    (%edx),%edx
  802ecf:	89 10                	mov    %edx,(%eax)
  802ed1:	eb 0a                	jmp    802edd <alloc_block_NF+0x47f>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	a3 38 51 80 00       	mov    %eax,0x805138
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ef5:	48                   	dec    %eax
  802ef6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 40 08             	mov    0x8(%eax),%eax
  802f01:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	e9 1b 01 00 00       	jmp    803029 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 40 0c             	mov    0xc(%eax),%eax
  802f14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f17:	0f 86 d1 00 00 00    	jbe    802fee <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f1d:	a1 48 51 80 00       	mov    0x805148,%eax
  802f22:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 50 08             	mov    0x8(%eax),%edx
  802f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	8b 55 08             	mov    0x8(%ebp),%edx
  802f37:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f3e:	75 17                	jne    802f57 <alloc_block_NF+0x4f9>
  802f40:	83 ec 04             	sub    $0x4,%esp
  802f43:	68 98 43 80 00       	push   $0x804398
  802f48:	68 1c 01 00 00       	push   $0x11c
  802f4d:	68 ef 42 80 00       	push   $0x8042ef
  802f52:	e8 02 d8 ff ff       	call   800759 <_panic>
  802f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5a:	8b 00                	mov    (%eax),%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	74 10                	je     802f70 <alloc_block_NF+0x512>
  802f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f68:	8b 52 04             	mov    0x4(%edx),%edx
  802f6b:	89 50 04             	mov    %edx,0x4(%eax)
  802f6e:	eb 0b                	jmp    802f7b <alloc_block_NF+0x51d>
  802f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7e:	8b 40 04             	mov    0x4(%eax),%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	74 0f                	je     802f94 <alloc_block_NF+0x536>
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	8b 40 04             	mov    0x4(%eax),%eax
  802f8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f8e:	8b 12                	mov    (%edx),%edx
  802f90:	89 10                	mov    %edx,(%eax)
  802f92:	eb 0a                	jmp    802f9e <alloc_block_NF+0x540>
  802f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	a3 48 51 80 00       	mov    %eax,0x805148
  802f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb1:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb6:	48                   	dec    %eax
  802fb7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbf:	8b 40 08             	mov    0x8(%eax),%eax
  802fc2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fca:	8b 50 08             	mov    0x8(%eax),%edx
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	01 c2                	add    %eax,%edx
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fde:	2b 45 08             	sub    0x8(%ebp),%eax
  802fe1:	89 c2                	mov    %eax,%edx
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fec:	eb 3b                	jmp    803029 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fee:	a1 40 51 80 00       	mov    0x805140,%eax
  802ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ffa:	74 07                	je     803003 <alloc_block_NF+0x5a5>
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	eb 05                	jmp    803008 <alloc_block_NF+0x5aa>
  803003:	b8 00 00 00 00       	mov    $0x0,%eax
  803008:	a3 40 51 80 00       	mov    %eax,0x805140
  80300d:	a1 40 51 80 00       	mov    0x805140,%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	0f 85 2e fe ff ff    	jne    802e48 <alloc_block_NF+0x3ea>
  80301a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301e:	0f 85 24 fe ff ff    	jne    802e48 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803024:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803029:	c9                   	leave  
  80302a:	c3                   	ret    

0080302b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80302b:	55                   	push   %ebp
  80302c:	89 e5                	mov    %esp,%ebp
  80302e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803031:	a1 38 51 80 00       	mov    0x805138,%eax
  803036:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803039:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80303e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803041:	a1 38 51 80 00       	mov    0x805138,%eax
  803046:	85 c0                	test   %eax,%eax
  803048:	74 14                	je     80305e <insert_sorted_with_merge_freeList+0x33>
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	8b 50 08             	mov    0x8(%eax),%edx
  803050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803053:	8b 40 08             	mov    0x8(%eax),%eax
  803056:	39 c2                	cmp    %eax,%edx
  803058:	0f 87 9b 01 00 00    	ja     8031f9 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80305e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803062:	75 17                	jne    80307b <insert_sorted_with_merge_freeList+0x50>
  803064:	83 ec 04             	sub    $0x4,%esp
  803067:	68 cc 42 80 00       	push   $0x8042cc
  80306c:	68 38 01 00 00       	push   $0x138
  803071:	68 ef 42 80 00       	push   $0x8042ef
  803076:	e8 de d6 ff ff       	call   800759 <_panic>
  80307b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	89 10                	mov    %edx,(%eax)
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	85 c0                	test   %eax,%eax
  80308d:	74 0d                	je     80309c <insert_sorted_with_merge_freeList+0x71>
  80308f:	a1 38 51 80 00       	mov    0x805138,%eax
  803094:	8b 55 08             	mov    0x8(%ebp),%edx
  803097:	89 50 04             	mov    %edx,0x4(%eax)
  80309a:	eb 08                	jmp    8030a4 <insert_sorted_with_merge_freeList+0x79>
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b6:	a1 44 51 80 00       	mov    0x805144,%eax
  8030bb:	40                   	inc    %eax
  8030bc:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030c5:	0f 84 a8 06 00 00    	je     803773 <insert_sorted_with_merge_freeList+0x748>
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	8b 50 08             	mov    0x8(%eax),%edx
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d7:	01 c2                	add    %eax,%edx
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	8b 40 08             	mov    0x8(%eax),%eax
  8030df:	39 c2                	cmp    %eax,%edx
  8030e1:	0f 85 8c 06 00 00    	jne    803773 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f3:	01 c2                	add    %eax,%edx
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8030fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ff:	75 17                	jne    803118 <insert_sorted_with_merge_freeList+0xed>
  803101:	83 ec 04             	sub    $0x4,%esp
  803104:	68 98 43 80 00       	push   $0x804398
  803109:	68 3c 01 00 00       	push   $0x13c
  80310e:	68 ef 42 80 00       	push   $0x8042ef
  803113:	e8 41 d6 ff ff       	call   800759 <_panic>
  803118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311b:	8b 00                	mov    (%eax),%eax
  80311d:	85 c0                	test   %eax,%eax
  80311f:	74 10                	je     803131 <insert_sorted_with_merge_freeList+0x106>
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803129:	8b 52 04             	mov    0x4(%edx),%edx
  80312c:	89 50 04             	mov    %edx,0x4(%eax)
  80312f:	eb 0b                	jmp    80313c <insert_sorted_with_merge_freeList+0x111>
  803131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803134:	8b 40 04             	mov    0x4(%eax),%eax
  803137:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80313c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313f:	8b 40 04             	mov    0x4(%eax),%eax
  803142:	85 c0                	test   %eax,%eax
  803144:	74 0f                	je     803155 <insert_sorted_with_merge_freeList+0x12a>
  803146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803149:	8b 40 04             	mov    0x4(%eax),%eax
  80314c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80314f:	8b 12                	mov    (%edx),%edx
  803151:	89 10                	mov    %edx,(%eax)
  803153:	eb 0a                	jmp    80315f <insert_sorted_with_merge_freeList+0x134>
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	a3 38 51 80 00       	mov    %eax,0x805138
  80315f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803162:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803172:	a1 44 51 80 00       	mov    0x805144,%eax
  803177:	48                   	dec    %eax
  803178:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80317d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803180:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803187:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803191:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803195:	75 17                	jne    8031ae <insert_sorted_with_merge_freeList+0x183>
  803197:	83 ec 04             	sub    $0x4,%esp
  80319a:	68 cc 42 80 00       	push   $0x8042cc
  80319f:	68 3f 01 00 00       	push   $0x13f
  8031a4:	68 ef 42 80 00       	push   $0x8042ef
  8031a9:	e8 ab d5 ff ff       	call   800759 <_panic>
  8031ae:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b7:	89 10                	mov    %edx,(%eax)
  8031b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bc:	8b 00                	mov    (%eax),%eax
  8031be:	85 c0                	test   %eax,%eax
  8031c0:	74 0d                	je     8031cf <insert_sorted_with_merge_freeList+0x1a4>
  8031c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ca:	89 50 04             	mov    %edx,0x4(%eax)
  8031cd:	eb 08                	jmp    8031d7 <insert_sorted_with_merge_freeList+0x1ac>
  8031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031da:	a3 48 51 80 00       	mov    %eax,0x805148
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e9:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ee:	40                   	inc    %eax
  8031ef:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031f4:	e9 7a 05 00 00       	jmp    803773 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	8b 50 08             	mov    0x8(%eax),%edx
  8031ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803202:	8b 40 08             	mov    0x8(%eax),%eax
  803205:	39 c2                	cmp    %eax,%edx
  803207:	0f 82 14 01 00 00    	jb     803321 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80320d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803210:	8b 50 08             	mov    0x8(%eax),%edx
  803213:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803216:	8b 40 0c             	mov    0xc(%eax),%eax
  803219:	01 c2                	add    %eax,%edx
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	8b 40 08             	mov    0x8(%eax),%eax
  803221:	39 c2                	cmp    %eax,%edx
  803223:	0f 85 90 00 00 00    	jne    8032b9 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322c:	8b 50 0c             	mov    0xc(%eax),%edx
  80322f:	8b 45 08             	mov    0x8(%ebp),%eax
  803232:	8b 40 0c             	mov    0xc(%eax),%eax
  803235:	01 c2                	add    %eax,%edx
  803237:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803255:	75 17                	jne    80326e <insert_sorted_with_merge_freeList+0x243>
  803257:	83 ec 04             	sub    $0x4,%esp
  80325a:	68 cc 42 80 00       	push   $0x8042cc
  80325f:	68 49 01 00 00       	push   $0x149
  803264:	68 ef 42 80 00       	push   $0x8042ef
  803269:	e8 eb d4 ff ff       	call   800759 <_panic>
  80326e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	89 10                	mov    %edx,(%eax)
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 0d                	je     80328f <insert_sorted_with_merge_freeList+0x264>
  803282:	a1 48 51 80 00       	mov    0x805148,%eax
  803287:	8b 55 08             	mov    0x8(%ebp),%edx
  80328a:	89 50 04             	mov    %edx,0x4(%eax)
  80328d:	eb 08                	jmp    803297 <insert_sorted_with_merge_freeList+0x26c>
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	a3 48 51 80 00       	mov    %eax,0x805148
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ae:	40                   	inc    %eax
  8032af:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032b4:	e9 bb 04 00 00       	jmp    803774 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032bd:	75 17                	jne    8032d6 <insert_sorted_with_merge_freeList+0x2ab>
  8032bf:	83 ec 04             	sub    $0x4,%esp
  8032c2:	68 40 43 80 00       	push   $0x804340
  8032c7:	68 4c 01 00 00       	push   $0x14c
  8032cc:	68 ef 42 80 00       	push   $0x8042ef
  8032d1:	e8 83 d4 ff ff       	call   800759 <_panic>
  8032d6:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	8b 40 04             	mov    0x4(%eax),%eax
  8032e8:	85 c0                	test   %eax,%eax
  8032ea:	74 0c                	je     8032f8 <insert_sorted_with_merge_freeList+0x2cd>
  8032ec:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f4:	89 10                	mov    %edx,(%eax)
  8032f6:	eb 08                	jmp    803300 <insert_sorted_with_merge_freeList+0x2d5>
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	a3 38 51 80 00       	mov    %eax,0x805138
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803311:	a1 44 51 80 00       	mov    0x805144,%eax
  803316:	40                   	inc    %eax
  803317:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80331c:	e9 53 04 00 00       	jmp    803774 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803321:	a1 38 51 80 00       	mov    0x805138,%eax
  803326:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803329:	e9 15 04 00 00       	jmp    803743 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	8b 00                	mov    (%eax),%eax
  803333:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	8b 50 08             	mov    0x8(%eax),%edx
  80333c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333f:	8b 40 08             	mov    0x8(%eax),%eax
  803342:	39 c2                	cmp    %eax,%edx
  803344:	0f 86 f1 03 00 00    	jbe    80373b <insert_sorted_with_merge_freeList+0x710>
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	8b 50 08             	mov    0x8(%eax),%edx
  803350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803353:	8b 40 08             	mov    0x8(%eax),%eax
  803356:	39 c2                	cmp    %eax,%edx
  803358:	0f 83 dd 03 00 00    	jae    80373b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 50 08             	mov    0x8(%eax),%edx
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	8b 40 0c             	mov    0xc(%eax),%eax
  80336a:	01 c2                	add    %eax,%edx
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	8b 40 08             	mov    0x8(%eax),%eax
  803372:	39 c2                	cmp    %eax,%edx
  803374:	0f 85 b9 01 00 00    	jne    803533 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	8b 50 08             	mov    0x8(%eax),%edx
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	8b 40 0c             	mov    0xc(%eax),%eax
  803386:	01 c2                	add    %eax,%edx
  803388:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338b:	8b 40 08             	mov    0x8(%eax),%eax
  80338e:	39 c2                	cmp    %eax,%edx
  803390:	0f 85 0d 01 00 00    	jne    8034a3 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803399:	8b 50 0c             	mov    0xc(%eax),%edx
  80339c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339f:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a2:	01 c2                	add    %eax,%edx
  8033a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a7:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033ae:	75 17                	jne    8033c7 <insert_sorted_with_merge_freeList+0x39c>
  8033b0:	83 ec 04             	sub    $0x4,%esp
  8033b3:	68 98 43 80 00       	push   $0x804398
  8033b8:	68 5c 01 00 00       	push   $0x15c
  8033bd:	68 ef 42 80 00       	push   $0x8042ef
  8033c2:	e8 92 d3 ff ff       	call   800759 <_panic>
  8033c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	85 c0                	test   %eax,%eax
  8033ce:	74 10                	je     8033e0 <insert_sorted_with_merge_freeList+0x3b5>
  8033d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d8:	8b 52 04             	mov    0x4(%edx),%edx
  8033db:	89 50 04             	mov    %edx,0x4(%eax)
  8033de:	eb 0b                	jmp    8033eb <insert_sorted_with_merge_freeList+0x3c0>
  8033e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e3:	8b 40 04             	mov    0x4(%eax),%eax
  8033e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ee:	8b 40 04             	mov    0x4(%eax),%eax
  8033f1:	85 c0                	test   %eax,%eax
  8033f3:	74 0f                	je     803404 <insert_sorted_with_merge_freeList+0x3d9>
  8033f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f8:	8b 40 04             	mov    0x4(%eax),%eax
  8033fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033fe:	8b 12                	mov    (%edx),%edx
  803400:	89 10                	mov    %edx,(%eax)
  803402:	eb 0a                	jmp    80340e <insert_sorted_with_merge_freeList+0x3e3>
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	a3 38 51 80 00       	mov    %eax,0x805138
  80340e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803417:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803421:	a1 44 51 80 00       	mov    0x805144,%eax
  803426:	48                   	dec    %eax
  803427:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80342c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803439:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803440:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803444:	75 17                	jne    80345d <insert_sorted_with_merge_freeList+0x432>
  803446:	83 ec 04             	sub    $0x4,%esp
  803449:	68 cc 42 80 00       	push   $0x8042cc
  80344e:	68 5f 01 00 00       	push   $0x15f
  803453:	68 ef 42 80 00       	push   $0x8042ef
  803458:	e8 fc d2 ff ff       	call   800759 <_panic>
  80345d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803466:	89 10                	mov    %edx,(%eax)
  803468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	85 c0                	test   %eax,%eax
  80346f:	74 0d                	je     80347e <insert_sorted_with_merge_freeList+0x453>
  803471:	a1 48 51 80 00       	mov    0x805148,%eax
  803476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803479:	89 50 04             	mov    %edx,0x4(%eax)
  80347c:	eb 08                	jmp    803486 <insert_sorted_with_merge_freeList+0x45b>
  80347e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803481:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803486:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803489:	a3 48 51 80 00       	mov    %eax,0x805148
  80348e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803491:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803498:	a1 54 51 80 00       	mov    0x805154,%eax
  80349d:	40                   	inc    %eax
  80349e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8034a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a6:	8b 50 0c             	mov    0xc(%eax),%edx
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8034af:	01 c2                	add    %eax,%edx
  8034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034cf:	75 17                	jne    8034e8 <insert_sorted_with_merge_freeList+0x4bd>
  8034d1:	83 ec 04             	sub    $0x4,%esp
  8034d4:	68 cc 42 80 00       	push   $0x8042cc
  8034d9:	68 64 01 00 00       	push   $0x164
  8034de:	68 ef 42 80 00       	push   $0x8042ef
  8034e3:	e8 71 d2 ff ff       	call   800759 <_panic>
  8034e8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	89 10                	mov    %edx,(%eax)
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	8b 00                	mov    (%eax),%eax
  8034f8:	85 c0                	test   %eax,%eax
  8034fa:	74 0d                	je     803509 <insert_sorted_with_merge_freeList+0x4de>
  8034fc:	a1 48 51 80 00       	mov    0x805148,%eax
  803501:	8b 55 08             	mov    0x8(%ebp),%edx
  803504:	89 50 04             	mov    %edx,0x4(%eax)
  803507:	eb 08                	jmp    803511 <insert_sorted_with_merge_freeList+0x4e6>
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	a3 48 51 80 00       	mov    %eax,0x805148
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803523:	a1 54 51 80 00       	mov    0x805154,%eax
  803528:	40                   	inc    %eax
  803529:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80352e:	e9 41 02 00 00       	jmp    803774 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	8b 50 08             	mov    0x8(%eax),%edx
  803539:	8b 45 08             	mov    0x8(%ebp),%eax
  80353c:	8b 40 0c             	mov    0xc(%eax),%eax
  80353f:	01 c2                	add    %eax,%edx
  803541:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803544:	8b 40 08             	mov    0x8(%eax),%eax
  803547:	39 c2                	cmp    %eax,%edx
  803549:	0f 85 7c 01 00 00    	jne    8036cb <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80354f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803553:	74 06                	je     80355b <insert_sorted_with_merge_freeList+0x530>
  803555:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803559:	75 17                	jne    803572 <insert_sorted_with_merge_freeList+0x547>
  80355b:	83 ec 04             	sub    $0x4,%esp
  80355e:	68 08 43 80 00       	push   $0x804308
  803563:	68 69 01 00 00       	push   $0x169
  803568:	68 ef 42 80 00       	push   $0x8042ef
  80356d:	e8 e7 d1 ff ff       	call   800759 <_panic>
  803572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803575:	8b 50 04             	mov    0x4(%eax),%edx
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	89 50 04             	mov    %edx,0x4(%eax)
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803584:	89 10                	mov    %edx,(%eax)
  803586:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803589:	8b 40 04             	mov    0x4(%eax),%eax
  80358c:	85 c0                	test   %eax,%eax
  80358e:	74 0d                	je     80359d <insert_sorted_with_merge_freeList+0x572>
  803590:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803593:	8b 40 04             	mov    0x4(%eax),%eax
  803596:	8b 55 08             	mov    0x8(%ebp),%edx
  803599:	89 10                	mov    %edx,(%eax)
  80359b:	eb 08                	jmp    8035a5 <insert_sorted_with_merge_freeList+0x57a>
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	a3 38 51 80 00       	mov    %eax,0x805138
  8035a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ab:	89 50 04             	mov    %edx,0x4(%eax)
  8035ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8035b3:	40                   	inc    %eax
  8035b4:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bc:	8b 50 0c             	mov    0xc(%eax),%edx
  8035bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c5:	01 c2                	add    %eax,%edx
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035d1:	75 17                	jne    8035ea <insert_sorted_with_merge_freeList+0x5bf>
  8035d3:	83 ec 04             	sub    $0x4,%esp
  8035d6:	68 98 43 80 00       	push   $0x804398
  8035db:	68 6b 01 00 00       	push   $0x16b
  8035e0:	68 ef 42 80 00       	push   $0x8042ef
  8035e5:	e8 6f d1 ff ff       	call   800759 <_panic>
  8035ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ed:	8b 00                	mov    (%eax),%eax
  8035ef:	85 c0                	test   %eax,%eax
  8035f1:	74 10                	je     803603 <insert_sorted_with_merge_freeList+0x5d8>
  8035f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f6:	8b 00                	mov    (%eax),%eax
  8035f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035fb:	8b 52 04             	mov    0x4(%edx),%edx
  8035fe:	89 50 04             	mov    %edx,0x4(%eax)
  803601:	eb 0b                	jmp    80360e <insert_sorted_with_merge_freeList+0x5e3>
  803603:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803606:	8b 40 04             	mov    0x4(%eax),%eax
  803609:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80360e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803611:	8b 40 04             	mov    0x4(%eax),%eax
  803614:	85 c0                	test   %eax,%eax
  803616:	74 0f                	je     803627 <insert_sorted_with_merge_freeList+0x5fc>
  803618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361b:	8b 40 04             	mov    0x4(%eax),%eax
  80361e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803621:	8b 12                	mov    (%edx),%edx
  803623:	89 10                	mov    %edx,(%eax)
  803625:	eb 0a                	jmp    803631 <insert_sorted_with_merge_freeList+0x606>
  803627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	a3 38 51 80 00       	mov    %eax,0x805138
  803631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803634:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80363a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803644:	a1 44 51 80 00       	mov    0x805144,%eax
  803649:	48                   	dec    %eax
  80364a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80364f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803652:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803659:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803663:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803667:	75 17                	jne    803680 <insert_sorted_with_merge_freeList+0x655>
  803669:	83 ec 04             	sub    $0x4,%esp
  80366c:	68 cc 42 80 00       	push   $0x8042cc
  803671:	68 6e 01 00 00       	push   $0x16e
  803676:	68 ef 42 80 00       	push   $0x8042ef
  80367b:	e8 d9 d0 ff ff       	call   800759 <_panic>
  803680:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803686:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803689:	89 10                	mov    %edx,(%eax)
  80368b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368e:	8b 00                	mov    (%eax),%eax
  803690:	85 c0                	test   %eax,%eax
  803692:	74 0d                	je     8036a1 <insert_sorted_with_merge_freeList+0x676>
  803694:	a1 48 51 80 00       	mov    0x805148,%eax
  803699:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80369c:	89 50 04             	mov    %edx,0x4(%eax)
  80369f:	eb 08                	jmp    8036a9 <insert_sorted_with_merge_freeList+0x67e>
  8036a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8036c0:	40                   	inc    %eax
  8036c1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036c6:	e9 a9 00 00 00       	jmp    803774 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8036cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036cf:	74 06                	je     8036d7 <insert_sorted_with_merge_freeList+0x6ac>
  8036d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036d5:	75 17                	jne    8036ee <insert_sorted_with_merge_freeList+0x6c3>
  8036d7:	83 ec 04             	sub    $0x4,%esp
  8036da:	68 64 43 80 00       	push   $0x804364
  8036df:	68 73 01 00 00       	push   $0x173
  8036e4:	68 ef 42 80 00       	push   $0x8042ef
  8036e9:	e8 6b d0 ff ff       	call   800759 <_panic>
  8036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f1:	8b 10                	mov    (%eax),%edx
  8036f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f6:	89 10                	mov    %edx,(%eax)
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fb:	8b 00                	mov    (%eax),%eax
  8036fd:	85 c0                	test   %eax,%eax
  8036ff:	74 0b                	je     80370c <insert_sorted_with_merge_freeList+0x6e1>
  803701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803704:	8b 00                	mov    (%eax),%eax
  803706:	8b 55 08             	mov    0x8(%ebp),%edx
  803709:	89 50 04             	mov    %edx,0x4(%eax)
  80370c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370f:	8b 55 08             	mov    0x8(%ebp),%edx
  803712:	89 10                	mov    %edx,(%eax)
  803714:	8b 45 08             	mov    0x8(%ebp),%eax
  803717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80371a:	89 50 04             	mov    %edx,0x4(%eax)
  80371d:	8b 45 08             	mov    0x8(%ebp),%eax
  803720:	8b 00                	mov    (%eax),%eax
  803722:	85 c0                	test   %eax,%eax
  803724:	75 08                	jne    80372e <insert_sorted_with_merge_freeList+0x703>
  803726:	8b 45 08             	mov    0x8(%ebp),%eax
  803729:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80372e:	a1 44 51 80 00       	mov    0x805144,%eax
  803733:	40                   	inc    %eax
  803734:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803739:	eb 39                	jmp    803774 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80373b:	a1 40 51 80 00       	mov    0x805140,%eax
  803740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803747:	74 07                	je     803750 <insert_sorted_with_merge_freeList+0x725>
  803749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374c:	8b 00                	mov    (%eax),%eax
  80374e:	eb 05                	jmp    803755 <insert_sorted_with_merge_freeList+0x72a>
  803750:	b8 00 00 00 00       	mov    $0x0,%eax
  803755:	a3 40 51 80 00       	mov    %eax,0x805140
  80375a:	a1 40 51 80 00       	mov    0x805140,%eax
  80375f:	85 c0                	test   %eax,%eax
  803761:	0f 85 c7 fb ff ff    	jne    80332e <insert_sorted_with_merge_freeList+0x303>
  803767:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80376b:	0f 85 bd fb ff ff    	jne    80332e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803771:	eb 01                	jmp    803774 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803773:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803774:	90                   	nop
  803775:	c9                   	leave  
  803776:	c3                   	ret    
  803777:	90                   	nop

00803778 <__udivdi3>:
  803778:	55                   	push   %ebp
  803779:	57                   	push   %edi
  80377a:	56                   	push   %esi
  80377b:	53                   	push   %ebx
  80377c:	83 ec 1c             	sub    $0x1c,%esp
  80377f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803783:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803787:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80378b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80378f:	89 ca                	mov    %ecx,%edx
  803791:	89 f8                	mov    %edi,%eax
  803793:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803797:	85 f6                	test   %esi,%esi
  803799:	75 2d                	jne    8037c8 <__udivdi3+0x50>
  80379b:	39 cf                	cmp    %ecx,%edi
  80379d:	77 65                	ja     803804 <__udivdi3+0x8c>
  80379f:	89 fd                	mov    %edi,%ebp
  8037a1:	85 ff                	test   %edi,%edi
  8037a3:	75 0b                	jne    8037b0 <__udivdi3+0x38>
  8037a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8037aa:	31 d2                	xor    %edx,%edx
  8037ac:	f7 f7                	div    %edi
  8037ae:	89 c5                	mov    %eax,%ebp
  8037b0:	31 d2                	xor    %edx,%edx
  8037b2:	89 c8                	mov    %ecx,%eax
  8037b4:	f7 f5                	div    %ebp
  8037b6:	89 c1                	mov    %eax,%ecx
  8037b8:	89 d8                	mov    %ebx,%eax
  8037ba:	f7 f5                	div    %ebp
  8037bc:	89 cf                	mov    %ecx,%edi
  8037be:	89 fa                	mov    %edi,%edx
  8037c0:	83 c4 1c             	add    $0x1c,%esp
  8037c3:	5b                   	pop    %ebx
  8037c4:	5e                   	pop    %esi
  8037c5:	5f                   	pop    %edi
  8037c6:	5d                   	pop    %ebp
  8037c7:	c3                   	ret    
  8037c8:	39 ce                	cmp    %ecx,%esi
  8037ca:	77 28                	ja     8037f4 <__udivdi3+0x7c>
  8037cc:	0f bd fe             	bsr    %esi,%edi
  8037cf:	83 f7 1f             	xor    $0x1f,%edi
  8037d2:	75 40                	jne    803814 <__udivdi3+0x9c>
  8037d4:	39 ce                	cmp    %ecx,%esi
  8037d6:	72 0a                	jb     8037e2 <__udivdi3+0x6a>
  8037d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037dc:	0f 87 9e 00 00 00    	ja     803880 <__udivdi3+0x108>
  8037e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8037e7:	89 fa                	mov    %edi,%edx
  8037e9:	83 c4 1c             	add    $0x1c,%esp
  8037ec:	5b                   	pop    %ebx
  8037ed:	5e                   	pop    %esi
  8037ee:	5f                   	pop    %edi
  8037ef:	5d                   	pop    %ebp
  8037f0:	c3                   	ret    
  8037f1:	8d 76 00             	lea    0x0(%esi),%esi
  8037f4:	31 ff                	xor    %edi,%edi
  8037f6:	31 c0                	xor    %eax,%eax
  8037f8:	89 fa                	mov    %edi,%edx
  8037fa:	83 c4 1c             	add    $0x1c,%esp
  8037fd:	5b                   	pop    %ebx
  8037fe:	5e                   	pop    %esi
  8037ff:	5f                   	pop    %edi
  803800:	5d                   	pop    %ebp
  803801:	c3                   	ret    
  803802:	66 90                	xchg   %ax,%ax
  803804:	89 d8                	mov    %ebx,%eax
  803806:	f7 f7                	div    %edi
  803808:	31 ff                	xor    %edi,%edi
  80380a:	89 fa                	mov    %edi,%edx
  80380c:	83 c4 1c             	add    $0x1c,%esp
  80380f:	5b                   	pop    %ebx
  803810:	5e                   	pop    %esi
  803811:	5f                   	pop    %edi
  803812:	5d                   	pop    %ebp
  803813:	c3                   	ret    
  803814:	bd 20 00 00 00       	mov    $0x20,%ebp
  803819:	89 eb                	mov    %ebp,%ebx
  80381b:	29 fb                	sub    %edi,%ebx
  80381d:	89 f9                	mov    %edi,%ecx
  80381f:	d3 e6                	shl    %cl,%esi
  803821:	89 c5                	mov    %eax,%ebp
  803823:	88 d9                	mov    %bl,%cl
  803825:	d3 ed                	shr    %cl,%ebp
  803827:	89 e9                	mov    %ebp,%ecx
  803829:	09 f1                	or     %esi,%ecx
  80382b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80382f:	89 f9                	mov    %edi,%ecx
  803831:	d3 e0                	shl    %cl,%eax
  803833:	89 c5                	mov    %eax,%ebp
  803835:	89 d6                	mov    %edx,%esi
  803837:	88 d9                	mov    %bl,%cl
  803839:	d3 ee                	shr    %cl,%esi
  80383b:	89 f9                	mov    %edi,%ecx
  80383d:	d3 e2                	shl    %cl,%edx
  80383f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803843:	88 d9                	mov    %bl,%cl
  803845:	d3 e8                	shr    %cl,%eax
  803847:	09 c2                	or     %eax,%edx
  803849:	89 d0                	mov    %edx,%eax
  80384b:	89 f2                	mov    %esi,%edx
  80384d:	f7 74 24 0c          	divl   0xc(%esp)
  803851:	89 d6                	mov    %edx,%esi
  803853:	89 c3                	mov    %eax,%ebx
  803855:	f7 e5                	mul    %ebp
  803857:	39 d6                	cmp    %edx,%esi
  803859:	72 19                	jb     803874 <__udivdi3+0xfc>
  80385b:	74 0b                	je     803868 <__udivdi3+0xf0>
  80385d:	89 d8                	mov    %ebx,%eax
  80385f:	31 ff                	xor    %edi,%edi
  803861:	e9 58 ff ff ff       	jmp    8037be <__udivdi3+0x46>
  803866:	66 90                	xchg   %ax,%ax
  803868:	8b 54 24 08          	mov    0x8(%esp),%edx
  80386c:	89 f9                	mov    %edi,%ecx
  80386e:	d3 e2                	shl    %cl,%edx
  803870:	39 c2                	cmp    %eax,%edx
  803872:	73 e9                	jae    80385d <__udivdi3+0xe5>
  803874:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803877:	31 ff                	xor    %edi,%edi
  803879:	e9 40 ff ff ff       	jmp    8037be <__udivdi3+0x46>
  80387e:	66 90                	xchg   %ax,%ax
  803880:	31 c0                	xor    %eax,%eax
  803882:	e9 37 ff ff ff       	jmp    8037be <__udivdi3+0x46>
  803887:	90                   	nop

00803888 <__umoddi3>:
  803888:	55                   	push   %ebp
  803889:	57                   	push   %edi
  80388a:	56                   	push   %esi
  80388b:	53                   	push   %ebx
  80388c:	83 ec 1c             	sub    $0x1c,%esp
  80388f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803893:	8b 74 24 34          	mov    0x34(%esp),%esi
  803897:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80389b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80389f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038a7:	89 f3                	mov    %esi,%ebx
  8038a9:	89 fa                	mov    %edi,%edx
  8038ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038af:	89 34 24             	mov    %esi,(%esp)
  8038b2:	85 c0                	test   %eax,%eax
  8038b4:	75 1a                	jne    8038d0 <__umoddi3+0x48>
  8038b6:	39 f7                	cmp    %esi,%edi
  8038b8:	0f 86 a2 00 00 00    	jbe    803960 <__umoddi3+0xd8>
  8038be:	89 c8                	mov    %ecx,%eax
  8038c0:	89 f2                	mov    %esi,%edx
  8038c2:	f7 f7                	div    %edi
  8038c4:	89 d0                	mov    %edx,%eax
  8038c6:	31 d2                	xor    %edx,%edx
  8038c8:	83 c4 1c             	add    $0x1c,%esp
  8038cb:	5b                   	pop    %ebx
  8038cc:	5e                   	pop    %esi
  8038cd:	5f                   	pop    %edi
  8038ce:	5d                   	pop    %ebp
  8038cf:	c3                   	ret    
  8038d0:	39 f0                	cmp    %esi,%eax
  8038d2:	0f 87 ac 00 00 00    	ja     803984 <__umoddi3+0xfc>
  8038d8:	0f bd e8             	bsr    %eax,%ebp
  8038db:	83 f5 1f             	xor    $0x1f,%ebp
  8038de:	0f 84 ac 00 00 00    	je     803990 <__umoddi3+0x108>
  8038e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8038e9:	29 ef                	sub    %ebp,%edi
  8038eb:	89 fe                	mov    %edi,%esi
  8038ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038f1:	89 e9                	mov    %ebp,%ecx
  8038f3:	d3 e0                	shl    %cl,%eax
  8038f5:	89 d7                	mov    %edx,%edi
  8038f7:	89 f1                	mov    %esi,%ecx
  8038f9:	d3 ef                	shr    %cl,%edi
  8038fb:	09 c7                	or     %eax,%edi
  8038fd:	89 e9                	mov    %ebp,%ecx
  8038ff:	d3 e2                	shl    %cl,%edx
  803901:	89 14 24             	mov    %edx,(%esp)
  803904:	89 d8                	mov    %ebx,%eax
  803906:	d3 e0                	shl    %cl,%eax
  803908:	89 c2                	mov    %eax,%edx
  80390a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80390e:	d3 e0                	shl    %cl,%eax
  803910:	89 44 24 04          	mov    %eax,0x4(%esp)
  803914:	8b 44 24 08          	mov    0x8(%esp),%eax
  803918:	89 f1                	mov    %esi,%ecx
  80391a:	d3 e8                	shr    %cl,%eax
  80391c:	09 d0                	or     %edx,%eax
  80391e:	d3 eb                	shr    %cl,%ebx
  803920:	89 da                	mov    %ebx,%edx
  803922:	f7 f7                	div    %edi
  803924:	89 d3                	mov    %edx,%ebx
  803926:	f7 24 24             	mull   (%esp)
  803929:	89 c6                	mov    %eax,%esi
  80392b:	89 d1                	mov    %edx,%ecx
  80392d:	39 d3                	cmp    %edx,%ebx
  80392f:	0f 82 87 00 00 00    	jb     8039bc <__umoddi3+0x134>
  803935:	0f 84 91 00 00 00    	je     8039cc <__umoddi3+0x144>
  80393b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80393f:	29 f2                	sub    %esi,%edx
  803941:	19 cb                	sbb    %ecx,%ebx
  803943:	89 d8                	mov    %ebx,%eax
  803945:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803949:	d3 e0                	shl    %cl,%eax
  80394b:	89 e9                	mov    %ebp,%ecx
  80394d:	d3 ea                	shr    %cl,%edx
  80394f:	09 d0                	or     %edx,%eax
  803951:	89 e9                	mov    %ebp,%ecx
  803953:	d3 eb                	shr    %cl,%ebx
  803955:	89 da                	mov    %ebx,%edx
  803957:	83 c4 1c             	add    $0x1c,%esp
  80395a:	5b                   	pop    %ebx
  80395b:	5e                   	pop    %esi
  80395c:	5f                   	pop    %edi
  80395d:	5d                   	pop    %ebp
  80395e:	c3                   	ret    
  80395f:	90                   	nop
  803960:	89 fd                	mov    %edi,%ebp
  803962:	85 ff                	test   %edi,%edi
  803964:	75 0b                	jne    803971 <__umoddi3+0xe9>
  803966:	b8 01 00 00 00       	mov    $0x1,%eax
  80396b:	31 d2                	xor    %edx,%edx
  80396d:	f7 f7                	div    %edi
  80396f:	89 c5                	mov    %eax,%ebp
  803971:	89 f0                	mov    %esi,%eax
  803973:	31 d2                	xor    %edx,%edx
  803975:	f7 f5                	div    %ebp
  803977:	89 c8                	mov    %ecx,%eax
  803979:	f7 f5                	div    %ebp
  80397b:	89 d0                	mov    %edx,%eax
  80397d:	e9 44 ff ff ff       	jmp    8038c6 <__umoddi3+0x3e>
  803982:	66 90                	xchg   %ax,%ax
  803984:	89 c8                	mov    %ecx,%eax
  803986:	89 f2                	mov    %esi,%edx
  803988:	83 c4 1c             	add    $0x1c,%esp
  80398b:	5b                   	pop    %ebx
  80398c:	5e                   	pop    %esi
  80398d:	5f                   	pop    %edi
  80398e:	5d                   	pop    %ebp
  80398f:	c3                   	ret    
  803990:	3b 04 24             	cmp    (%esp),%eax
  803993:	72 06                	jb     80399b <__umoddi3+0x113>
  803995:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803999:	77 0f                	ja     8039aa <__umoddi3+0x122>
  80399b:	89 f2                	mov    %esi,%edx
  80399d:	29 f9                	sub    %edi,%ecx
  80399f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039a3:	89 14 24             	mov    %edx,(%esp)
  8039a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039ae:	8b 14 24             	mov    (%esp),%edx
  8039b1:	83 c4 1c             	add    $0x1c,%esp
  8039b4:	5b                   	pop    %ebx
  8039b5:	5e                   	pop    %esi
  8039b6:	5f                   	pop    %edi
  8039b7:	5d                   	pop    %ebp
  8039b8:	c3                   	ret    
  8039b9:	8d 76 00             	lea    0x0(%esi),%esi
  8039bc:	2b 04 24             	sub    (%esp),%eax
  8039bf:	19 fa                	sbb    %edi,%edx
  8039c1:	89 d1                	mov    %edx,%ecx
  8039c3:	89 c6                	mov    %eax,%esi
  8039c5:	e9 71 ff ff ff       	jmp    80393b <__umoddi3+0xb3>
  8039ca:	66 90                	xchg   %ax,%ax
  8039cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039d0:	72 ea                	jb     8039bc <__umoddi3+0x134>
  8039d2:	89 d9                	mov    %ebx,%ecx
  8039d4:	e9 62 ff ff ff       	jmp    80393b <__umoddi3+0xb3>
