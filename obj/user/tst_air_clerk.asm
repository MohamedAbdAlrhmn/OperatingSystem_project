
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
  800044:	e8 cd 1e 00 00       	call   801f16 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 95 3a 80 00       	mov    $0x803a95,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 9f 3a 80 00       	mov    $0x803a9f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb ab 3a 80 00       	mov    $0x803aab,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb ba 3a 80 00       	mov    $0x803aba,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb c9 3a 80 00       	mov    $0x803ac9,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb de 3a 80 00       	mov    $0x803ade,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb f3 3a 80 00       	mov    $0x803af3,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 04 3b 80 00       	mov    $0x803b04,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 15 3b 80 00       	mov    $0x803b15,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 26 3b 80 00       	mov    $0x803b26,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 2f 3b 80 00       	mov    $0x803b2f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 39 3b 80 00       	mov    $0x803b39,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 44 3b 80 00       	mov    $0x803b44,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 50 3b 80 00       	mov    $0x803b50,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 5a 3b 80 00       	mov    $0x803b5a,%ebx
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
  8001c1:	bb 64 3b 80 00       	mov    $0x803b64,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 72 3b 80 00       	mov    $0x803b72,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 81 3b 80 00       	mov    $0x803b81,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 88 3b 80 00       	mov    $0x803b88,%ebx
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
  800225:	e8 4f 18 00 00       	call   801a79 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 3a 18 00 00       	call   801a79 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 25 18 00 00       	call   801a79 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 0d 18 00 00       	call   801a79 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 f5 17 00 00       	call   801a79 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 dd 17 00 00       	call   801a79 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 c5 17 00 00       	call   801a79 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 ad 17 00 00       	call   801a79 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 95 17 00 00       	call   801a79 <sget>
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
  8002f7:	e8 bb 1a 00 00       	call   801db7 <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 a6 1a 00 00       	call   801db7 <sys_waitSemaphore>
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
  800344:	e8 8c 1a 00 00       	call   801dd5 <sys_signalSemaphore>
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
  80038b:	e8 27 1a 00 00       	call   801db7 <sys_waitSemaphore>
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
  8003ef:	e8 e1 19 00 00       	call   801dd5 <sys_signalSemaphore>
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
  800409:	e8 a9 19 00 00       	call   801db7 <sys_waitSemaphore>
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
  80046d:	e8 63 19 00 00       	call   801dd5 <sys_signalSemaphore>
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
  800487:	e8 2b 19 00 00       	call   801db7 <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 16 19 00 00       	call   801db7 <sys_waitSemaphore>
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
  800557:	e8 79 18 00 00       	call   801dd5 <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 64 18 00 00       	call   801dd5 <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 60 3a 80 00       	push   $0x803a60
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 80 3a 80 00       	push   $0x803a80
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb 8f 3b 80 00       	mov    $0x803b8f,%ebx
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
  8005fb:	e8 d5 17 00 00       	call   801dd5 <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 c0 17 00 00       	call   801dd5 <sys_signalSemaphore>
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
  800623:	e8 d5 18 00 00       	call   801efd <sys_getenvindex>
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
  80068e:	e8 77 16 00 00       	call   801d0a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 c8 3b 80 00       	push   $0x803bc8
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
  8006be:	68 f0 3b 80 00       	push   $0x803bf0
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
  8006ef:	68 18 3c 80 00       	push   $0x803c18
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 70 3c 80 00       	push   $0x803c70
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 c8 3b 80 00       	push   $0x803bc8
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 f7 15 00 00       	call   801d24 <sys_enable_interrupt>

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
  800740:	e8 84 17 00 00       	call   801ec9 <sys_destroy_env>
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
  800751:	e8 d9 17 00 00       	call   801f2f <sys_exit_env>
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
  80077a:	68 84 3c 80 00       	push   $0x803c84
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 89 3c 80 00       	push   $0x803c89
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
  8007b7:	68 a5 3c 80 00       	push   $0x803ca5
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
  8007e3:	68 a8 3c 80 00       	push   $0x803ca8
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 f4 3c 80 00       	push   $0x803cf4
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
  8008b5:	68 00 3d 80 00       	push   $0x803d00
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 f4 3c 80 00       	push   $0x803cf4
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
  800925:	68 54 3d 80 00       	push   $0x803d54
  80092a:	6a 44                	push   $0x44
  80092c:	68 f4 3c 80 00       	push   $0x803cf4
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
  80097f:	e8 d8 11 00 00       	call   801b5c <sys_cputs>
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
  8009f6:	e8 61 11 00 00       	call   801b5c <sys_cputs>
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
  800a40:	e8 c5 12 00 00       	call   801d0a <sys_disable_interrupt>
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
  800a60:	e8 bf 12 00 00       	call   801d24 <sys_enable_interrupt>
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
  800aaa:	e8 31 2d 00 00       	call   8037e0 <__udivdi3>
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
  800afa:	e8 f1 2d 00 00       	call   8038f0 <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 b4 3f 80 00       	add    $0x803fb4,%eax
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
  800c55:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
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
  800d36:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 c5 3f 80 00       	push   $0x803fc5
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
  800d5b:	68 ce 3f 80 00       	push   $0x803fce
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
  800d88:	be d1 3f 80 00       	mov    $0x803fd1,%esi
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
  8017ae:	68 30 41 80 00       	push   $0x804130
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
  80187e:	e8 1d 04 00 00       	call   801ca0 <sys_allocate_chunk>
  801883:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801886:	a1 20 51 80 00       	mov    0x805120,%eax
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	50                   	push   %eax
  80188f:	e8 92 0a 00 00       	call   802326 <initialize_MemBlocksList>
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
  8018bc:	68 55 41 80 00       	push   $0x804155
  8018c1:	6a 33                	push   $0x33
  8018c3:	68 73 41 80 00       	push   $0x804173
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
  80193b:	68 80 41 80 00       	push   $0x804180
  801940:	6a 34                	push   $0x34
  801942:	68 73 41 80 00       	push   $0x804173
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
  8019b0:	68 a4 41 80 00       	push   $0x8041a4
  8019b5:	6a 46                	push   $0x46
  8019b7:	68 73 41 80 00       	push   $0x804173
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
  8019cc:	68 cc 41 80 00       	push   $0x8041cc
  8019d1:	6a 61                	push   $0x61
  8019d3:	68 73 41 80 00       	push   $0x804173
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
  8019f2:	75 07                	jne    8019fb <smalloc+0x1e>
  8019f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f9:	eb 7c                	jmp    801a77 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019fb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a08:	01 d0                	add    %edx,%eax
  801a0a:	48                   	dec    %eax
  801a0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a11:	ba 00 00 00 00       	mov    $0x0,%edx
  801a16:	f7 75 f0             	divl   -0x10(%ebp)
  801a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1c:	29 d0                	sub    %edx,%eax
  801a1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a21:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a28:	e8 41 06 00 00       	call   80206e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	74 11                	je     801a42 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801a31:	83 ec 0c             	sub    $0xc,%esp
  801a34:	ff 75 e8             	pushl  -0x18(%ebp)
  801a37:	e8 ac 0c 00 00       	call   8026e8 <alloc_block_FF>
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a46:	74 2a                	je     801a72 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	8b 40 08             	mov    0x8(%eax),%eax
  801a4e:	89 c2                	mov    %eax,%edx
  801a50:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a54:	52                   	push   %edx
  801a55:	50                   	push   %eax
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	e8 92 03 00 00       	call   801df3 <sys_createSharedObject>
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801a67:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801a6b:	74 05                	je     801a72 <smalloc+0x95>
			return (void*)virtual_address;
  801a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a70:	eb 05                	jmp    801a77 <smalloc+0x9a>
	}
	return NULL;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a7f:	e8 13 fd ff ff       	call   801797 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	68 f0 41 80 00       	push   $0x8041f0
  801a8c:	68 a2 00 00 00       	push   $0xa2
  801a91:	68 73 41 80 00       	push   $0x804173
  801a96:	e8 be ec ff ff       	call   800759 <_panic>

00801a9b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aa1:	e8 f1 fc ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	68 14 42 80 00       	push   $0x804214
  801aae:	68 e6 00 00 00       	push   $0xe6
  801ab3:	68 73 41 80 00       	push   $0x804173
  801ab8:	e8 9c ec ff ff       	call   800759 <_panic>

00801abd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	68 3c 42 80 00       	push   $0x80423c
  801acb:	68 fa 00 00 00       	push   $0xfa
  801ad0:	68 73 41 80 00       	push   $0x804173
  801ad5:	e8 7f ec ff ff       	call   800759 <_panic>

00801ada <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae0:	83 ec 04             	sub    $0x4,%esp
  801ae3:	68 60 42 80 00       	push   $0x804260
  801ae8:	68 05 01 00 00       	push   $0x105
  801aed:	68 73 41 80 00       	push   $0x804173
  801af2:	e8 62 ec ff ff       	call   800759 <_panic>

00801af7 <shrink>:

}
void shrink(uint32 newSize)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	68 60 42 80 00       	push   $0x804260
  801b05:	68 0a 01 00 00       	push   $0x10a
  801b0a:	68 73 41 80 00       	push   $0x804173
  801b0f:	e8 45 ec ff ff       	call   800759 <_panic>

00801b14 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b1a:	83 ec 04             	sub    $0x4,%esp
  801b1d:	68 60 42 80 00       	push   $0x804260
  801b22:	68 0f 01 00 00       	push   $0x10f
  801b27:	68 73 41 80 00       	push   $0x804173
  801b2c:	e8 28 ec ff ff       	call   800759 <_panic>

00801b31 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	57                   	push   %edi
  801b35:	56                   	push   %esi
  801b36:	53                   	push   %ebx
  801b37:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b46:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b49:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b4c:	cd 30                	int    $0x30
  801b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    

00801b5c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	83 ec 04             	sub    $0x4,%esp
  801b62:	8b 45 10             	mov    0x10(%ebp),%eax
  801b65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b68:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	52                   	push   %edx
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	50                   	push   %eax
  801b78:	6a 00                	push   $0x0
  801b7a:	e8 b2 ff ff ff       	call   801b31 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	90                   	nop
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 01                	push   $0x1
  801b94:	e8 98 ff ff ff       	call   801b31 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	52                   	push   %edx
  801bae:	50                   	push   %eax
  801baf:	6a 05                	push   $0x5
  801bb1:	e8 7b ff ff ff       	call   801b31 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bc0:	8b 75 18             	mov    0x18(%ebp),%esi
  801bc3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	56                   	push   %esi
  801bd0:	53                   	push   %ebx
  801bd1:	51                   	push   %ecx
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 06                	push   $0x6
  801bd6:	e8 56 ff ff ff       	call   801b31 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be1:	5b                   	pop    %ebx
  801be2:	5e                   	pop    %esi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    

00801be5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801be8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	52                   	push   %edx
  801bf5:	50                   	push   %eax
  801bf6:	6a 07                	push   $0x7
  801bf8:	e8 34 ff ff ff       	call   801b31 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	ff 75 0c             	pushl  0xc(%ebp)
  801c0e:	ff 75 08             	pushl  0x8(%ebp)
  801c11:	6a 08                	push   $0x8
  801c13:	e8 19 ff ff ff       	call   801b31 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 09                	push   $0x9
  801c2c:	e8 00 ff ff ff       	call   801b31 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 0a                	push   $0xa
  801c45:	e8 e7 fe ff ff       	call   801b31 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 0b                	push   $0xb
  801c5e:	e8 ce fe ff ff       	call   801b31 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	ff 75 0c             	pushl  0xc(%ebp)
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	6a 0f                	push   $0xf
  801c79:	e8 b3 fe ff ff       	call   801b31 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
	return;
  801c81:	90                   	nop
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	6a 10                	push   $0x10
  801c95:	e8 97 fe ff ff       	call   801b31 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	ff 75 10             	pushl  0x10(%ebp)
  801caa:	ff 75 0c             	pushl  0xc(%ebp)
  801cad:	ff 75 08             	pushl  0x8(%ebp)
  801cb0:	6a 11                	push   $0x11
  801cb2:	e8 7a fe ff ff       	call   801b31 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cba:	90                   	nop
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 0c                	push   $0xc
  801ccc:	e8 60 fe ff ff       	call   801b31 <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	ff 75 08             	pushl  0x8(%ebp)
  801ce4:	6a 0d                	push   $0xd
  801ce6:	e8 46 fe ff ff       	call   801b31 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 0e                	push   $0xe
  801cff:	e8 2d fe ff ff       	call   801b31 <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	90                   	nop
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 13                	push   $0x13
  801d19:	e8 13 fe ff ff       	call   801b31 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	90                   	nop
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 14                	push   $0x14
  801d33:	e8 f9 fd ff ff       	call   801b31 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	90                   	nop
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_cputc>:


void
sys_cputc(const char c)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 04             	sub    $0x4,%esp
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d4a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	50                   	push   %eax
  801d57:	6a 15                	push   $0x15
  801d59:	e8 d3 fd ff ff       	call   801b31 <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
}
  801d61:	90                   	nop
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 16                	push   $0x16
  801d73:	e8 b9 fd ff ff       	call   801b31 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	90                   	nop
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	ff 75 0c             	pushl  0xc(%ebp)
  801d8d:	50                   	push   %eax
  801d8e:	6a 17                	push   $0x17
  801d90:	e8 9c fd ff ff       	call   801b31 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	52                   	push   %edx
  801daa:	50                   	push   %eax
  801dab:	6a 1a                	push   $0x1a
  801dad:	e8 7f fd ff ff       	call   801b31 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	52                   	push   %edx
  801dc7:	50                   	push   %eax
  801dc8:	6a 18                	push   $0x18
  801dca:	e8 62 fd ff ff       	call   801b31 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	90                   	nop
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	52                   	push   %edx
  801de5:	50                   	push   %eax
  801de6:	6a 19                	push   $0x19
  801de8:	e8 44 fd ff ff       	call   801b31 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	90                   	nop
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e02:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	51                   	push   %ecx
  801e0c:	52                   	push   %edx
  801e0d:	ff 75 0c             	pushl  0xc(%ebp)
  801e10:	50                   	push   %eax
  801e11:	6a 1b                	push   $0x1b
  801e13:	e8 19 fd ff ff       	call   801b31 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	52                   	push   %edx
  801e2d:	50                   	push   %eax
  801e2e:	6a 1c                	push   $0x1c
  801e30:	e8 fc fc ff ff       	call   801b31 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	51                   	push   %ecx
  801e4b:	52                   	push   %edx
  801e4c:	50                   	push   %eax
  801e4d:	6a 1d                	push   $0x1d
  801e4f:	e8 dd fc ff ff       	call   801b31 <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	52                   	push   %edx
  801e69:	50                   	push   %eax
  801e6a:	6a 1e                	push   $0x1e
  801e6c:	e8 c0 fc ff ff       	call   801b31 <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 1f                	push   $0x1f
  801e85:	e8 a7 fc ff ff       	call   801b31 <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	ff 75 14             	pushl  0x14(%ebp)
  801e9a:	ff 75 10             	pushl  0x10(%ebp)
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	50                   	push   %eax
  801ea1:	6a 20                	push   $0x20
  801ea3:	e8 89 fc ff ff       	call   801b31 <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	50                   	push   %eax
  801ebc:	6a 21                	push   $0x21
  801ebe:	e8 6e fc ff ff       	call   801b31 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	90                   	nop
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	50                   	push   %eax
  801ed8:	6a 22                	push   $0x22
  801eda:	e8 52 fc ff ff       	call   801b31 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 02                	push   $0x2
  801ef3:	e8 39 fc ff ff       	call   801b31 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 03                	push   $0x3
  801f0c:	e8 20 fc ff ff       	call   801b31 <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 04                	push   $0x4
  801f25:	e8 07 fc ff ff       	call   801b31 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_exit_env>:


void sys_exit_env(void)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 23                	push   $0x23
  801f3e:	e8 ee fb ff ff       	call   801b31 <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	90                   	nop
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f4f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f52:	8d 50 04             	lea    0x4(%eax),%edx
  801f55:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	52                   	push   %edx
  801f5f:	50                   	push   %eax
  801f60:	6a 24                	push   $0x24
  801f62:	e8 ca fb ff ff       	call   801b31 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
	return result;
  801f6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f70:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f73:	89 01                	mov    %eax,(%ecx)
  801f75:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	c9                   	leave  
  801f7c:	c2 04 00             	ret    $0x4

00801f7f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	ff 75 10             	pushl  0x10(%ebp)
  801f89:	ff 75 0c             	pushl  0xc(%ebp)
  801f8c:	ff 75 08             	pushl  0x8(%ebp)
  801f8f:	6a 12                	push   $0x12
  801f91:	e8 9b fb ff ff       	call   801b31 <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
	return ;
  801f99:	90                   	nop
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <sys_rcr2>:
uint32 sys_rcr2()
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 25                	push   $0x25
  801fab:	e8 81 fb ff ff       	call   801b31 <syscall>
  801fb0:	83 c4 18             	add    $0x18,%esp
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fc1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	50                   	push   %eax
  801fce:	6a 26                	push   $0x26
  801fd0:	e8 5c fb ff ff       	call   801b31 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd8:	90                   	nop
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <rsttst>:
void rsttst()
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 28                	push   $0x28
  801fea:	e8 42 fb ff ff       	call   801b31 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff2:	90                   	nop
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ffe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802001:	8b 55 18             	mov    0x18(%ebp),%edx
  802004:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802008:	52                   	push   %edx
  802009:	50                   	push   %eax
  80200a:	ff 75 10             	pushl  0x10(%ebp)
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	ff 75 08             	pushl  0x8(%ebp)
  802013:	6a 27                	push   $0x27
  802015:	e8 17 fb ff ff       	call   801b31 <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
	return ;
  80201d:	90                   	nop
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <chktst>:
void chktst(uint32 n)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	ff 75 08             	pushl  0x8(%ebp)
  80202e:	6a 29                	push   $0x29
  802030:	e8 fc fa ff ff       	call   801b31 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
	return ;
  802038:	90                   	nop
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <inctst>:

void inctst()
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 2a                	push   $0x2a
  80204a:	e8 e2 fa ff ff       	call   801b31 <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
	return ;
  802052:	90                   	nop
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <gettst>:
uint32 gettst()
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 2b                	push   $0x2b
  802064:	e8 c8 fa ff ff       	call   801b31 <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 2c                	push   $0x2c
  802080:	e8 ac fa ff ff       	call   801b31 <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
  802088:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80208b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80208f:	75 07                	jne    802098 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802091:	b8 01 00 00 00       	mov    $0x1,%eax
  802096:	eb 05                	jmp    80209d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 2c                	push   $0x2c
  8020b1:	e8 7b fa ff ff       	call   801b31 <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
  8020b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020bc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020c0:	75 07                	jne    8020c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c7:	eb 05                	jmp    8020ce <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 2c                	push   $0x2c
  8020e2:	e8 4a fa ff ff       	call   801b31 <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
  8020ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020ed:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020f1:	75 07                	jne    8020fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f8:	eb 05                	jmp    8020ff <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 2c                	push   $0x2c
  802113:	e8 19 fa ff ff       	call   801b31 <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
  80211b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80211e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802122:	75 07                	jne    80212b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802124:	b8 01 00 00 00       	mov    $0x1,%eax
  802129:	eb 05                	jmp    802130 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80212b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	ff 75 08             	pushl  0x8(%ebp)
  802140:	6a 2d                	push   $0x2d
  802142:	e8 ea f9 ff ff       	call   801b31 <syscall>
  802147:	83 c4 18             	add    $0x18,%esp
	return ;
  80214a:	90                   	nop
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802151:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802154:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	6a 00                	push   $0x0
  80215f:	53                   	push   %ebx
  802160:	51                   	push   %ecx
  802161:	52                   	push   %edx
  802162:	50                   	push   %eax
  802163:	6a 2e                	push   $0x2e
  802165:	e8 c7 f9 ff ff       	call   801b31 <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
}
  80216d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802175:	8b 55 0c             	mov    0xc(%ebp),%edx
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	52                   	push   %edx
  802182:	50                   	push   %eax
  802183:	6a 2f                	push   $0x2f
  802185:	e8 a7 f9 ff ff       	call   801b31 <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802195:	83 ec 0c             	sub    $0xc,%esp
  802198:	68 70 42 80 00       	push   $0x804270
  80219d:	e8 6b e8 ff ff       	call   800a0d <cprintf>
  8021a2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8021a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8021ac:	83 ec 0c             	sub    $0xc,%esp
  8021af:	68 9c 42 80 00       	push   $0x80429c
  8021b4:	e8 54 e8 ff ff       	call   800a0d <cprintf>
  8021b9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021bc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8021c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c8:	eb 56                	jmp    802220 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ce:	74 1c                	je     8021ec <print_mem_block_lists+0x5d>
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	8b 50 08             	mov    0x8(%eax),%edx
  8021d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d9:	8b 48 08             	mov    0x8(%eax),%ecx
  8021dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021df:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e2:	01 c8                	add    %ecx,%eax
  8021e4:	39 c2                	cmp    %eax,%edx
  8021e6:	73 04                	jae    8021ec <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021e8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	8b 50 08             	mov    0x8(%eax),%edx
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f8:	01 c2                	add    %eax,%edx
  8021fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fd:	8b 40 08             	mov    0x8(%eax),%eax
  802200:	83 ec 04             	sub    $0x4,%esp
  802203:	52                   	push   %edx
  802204:	50                   	push   %eax
  802205:	68 b1 42 80 00       	push   $0x8042b1
  80220a:	e8 fe e7 ff ff       	call   800a0d <cprintf>
  80220f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802215:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802218:	a1 40 51 80 00       	mov    0x805140,%eax
  80221d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802220:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802224:	74 07                	je     80222d <print_mem_block_lists+0x9e>
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	8b 00                	mov    (%eax),%eax
  80222b:	eb 05                	jmp    802232 <print_mem_block_lists+0xa3>
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
  802232:	a3 40 51 80 00       	mov    %eax,0x805140
  802237:	a1 40 51 80 00       	mov    0x805140,%eax
  80223c:	85 c0                	test   %eax,%eax
  80223e:	75 8a                	jne    8021ca <print_mem_block_lists+0x3b>
  802240:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802244:	75 84                	jne    8021ca <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802246:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80224a:	75 10                	jne    80225c <print_mem_block_lists+0xcd>
  80224c:	83 ec 0c             	sub    $0xc,%esp
  80224f:	68 c0 42 80 00       	push   $0x8042c0
  802254:	e8 b4 e7 ff ff       	call   800a0d <cprintf>
  802259:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80225c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802263:	83 ec 0c             	sub    $0xc,%esp
  802266:	68 e4 42 80 00       	push   $0x8042e4
  80226b:	e8 9d e7 ff ff       	call   800a0d <cprintf>
  802270:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802273:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802277:	a1 40 50 80 00       	mov    0x805040,%eax
  80227c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227f:	eb 56                	jmp    8022d7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802281:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802285:	74 1c                	je     8022a3 <print_mem_block_lists+0x114>
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	8b 50 08             	mov    0x8(%eax),%edx
  80228d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802290:	8b 48 08             	mov    0x8(%eax),%ecx
  802293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802296:	8b 40 0c             	mov    0xc(%eax),%eax
  802299:	01 c8                	add    %ecx,%eax
  80229b:	39 c2                	cmp    %eax,%edx
  80229d:	73 04                	jae    8022a3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80229f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 50 08             	mov    0x8(%eax),%edx
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8022af:	01 c2                	add    %eax,%edx
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 40 08             	mov    0x8(%eax),%eax
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	52                   	push   %edx
  8022bb:	50                   	push   %eax
  8022bc:	68 b1 42 80 00       	push   $0x8042b1
  8022c1:	e8 47 e7 ff ff       	call   800a0d <cprintf>
  8022c6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022cf:	a1 48 50 80 00       	mov    0x805048,%eax
  8022d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022db:	74 07                	je     8022e4 <print_mem_block_lists+0x155>
  8022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e0:	8b 00                	mov    (%eax),%eax
  8022e2:	eb 05                	jmp    8022e9 <print_mem_block_lists+0x15a>
  8022e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e9:	a3 48 50 80 00       	mov    %eax,0x805048
  8022ee:	a1 48 50 80 00       	mov    0x805048,%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	75 8a                	jne    802281 <print_mem_block_lists+0xf2>
  8022f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fb:	75 84                	jne    802281 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022fd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802301:	75 10                	jne    802313 <print_mem_block_lists+0x184>
  802303:	83 ec 0c             	sub    $0xc,%esp
  802306:	68 fc 42 80 00       	push   $0x8042fc
  80230b:	e8 fd e6 ff ff       	call   800a0d <cprintf>
  802310:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802313:	83 ec 0c             	sub    $0xc,%esp
  802316:	68 70 42 80 00       	push   $0x804270
  80231b:	e8 ed e6 ff ff       	call   800a0d <cprintf>
  802320:	83 c4 10             	add    $0x10,%esp

}
  802323:	90                   	nop
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80232c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802333:	00 00 00 
  802336:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80233d:	00 00 00 
  802340:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802347:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80234a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802351:	e9 9e 00 00 00       	jmp    8023f4 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802356:	a1 50 50 80 00       	mov    0x805050,%eax
  80235b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235e:	c1 e2 04             	shl    $0x4,%edx
  802361:	01 d0                	add    %edx,%eax
  802363:	85 c0                	test   %eax,%eax
  802365:	75 14                	jne    80237b <initialize_MemBlocksList+0x55>
  802367:	83 ec 04             	sub    $0x4,%esp
  80236a:	68 24 43 80 00       	push   $0x804324
  80236f:	6a 46                	push   $0x46
  802371:	68 47 43 80 00       	push   $0x804347
  802376:	e8 de e3 ff ff       	call   800759 <_panic>
  80237b:	a1 50 50 80 00       	mov    0x805050,%eax
  802380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802383:	c1 e2 04             	shl    $0x4,%edx
  802386:	01 d0                	add    %edx,%eax
  802388:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80238e:	89 10                	mov    %edx,(%eax)
  802390:	8b 00                	mov    (%eax),%eax
  802392:	85 c0                	test   %eax,%eax
  802394:	74 18                	je     8023ae <initialize_MemBlocksList+0x88>
  802396:	a1 48 51 80 00       	mov    0x805148,%eax
  80239b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8023a1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023a4:	c1 e1 04             	shl    $0x4,%ecx
  8023a7:	01 ca                	add    %ecx,%edx
  8023a9:	89 50 04             	mov    %edx,0x4(%eax)
  8023ac:	eb 12                	jmp    8023c0 <initialize_MemBlocksList+0x9a>
  8023ae:	a1 50 50 80 00       	mov    0x805050,%eax
  8023b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b6:	c1 e2 04             	shl    $0x4,%edx
  8023b9:	01 d0                	add    %edx,%eax
  8023bb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023c0:	a1 50 50 80 00       	mov    0x805050,%eax
  8023c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c8:	c1 e2 04             	shl    $0x4,%edx
  8023cb:	01 d0                	add    %edx,%eax
  8023cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8023d2:	a1 50 50 80 00       	mov    0x805050,%eax
  8023d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023da:	c1 e2 04             	shl    $0x4,%edx
  8023dd:	01 d0                	add    %edx,%eax
  8023df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8023eb:	40                   	inc    %eax
  8023ec:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8023f1:	ff 45 f4             	incl   -0xc(%ebp)
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023fa:	0f 82 56 ff ff ff    	jb     802356 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802400:	90                   	nop
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	8b 00                	mov    (%eax),%eax
  80240e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802411:	eb 19                	jmp    80242c <find_block+0x29>
	{
		if(va==point->sva)
  802413:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802416:	8b 40 08             	mov    0x8(%eax),%eax
  802419:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80241c:	75 05                	jne    802423 <find_block+0x20>
		   return point;
  80241e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802421:	eb 36                	jmp    802459 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	8b 40 08             	mov    0x8(%eax),%eax
  802429:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80242c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802430:	74 07                	je     802439 <find_block+0x36>
  802432:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802435:	8b 00                	mov    (%eax),%eax
  802437:	eb 05                	jmp    80243e <find_block+0x3b>
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
  80243e:	8b 55 08             	mov    0x8(%ebp),%edx
  802441:	89 42 08             	mov    %eax,0x8(%edx)
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	8b 40 08             	mov    0x8(%eax),%eax
  80244a:	85 c0                	test   %eax,%eax
  80244c:	75 c5                	jne    802413 <find_block+0x10>
  80244e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802452:	75 bf                	jne    802413 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802454:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802461:	a1 40 50 80 00       	mov    0x805040,%eax
  802466:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802469:	a1 44 50 80 00       	mov    0x805044,%eax
  80246e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802474:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802477:	74 24                	je     80249d <insert_sorted_allocList+0x42>
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	8b 50 08             	mov    0x8(%eax),%edx
  80247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802482:	8b 40 08             	mov    0x8(%eax),%eax
  802485:	39 c2                	cmp    %eax,%edx
  802487:	76 14                	jbe    80249d <insert_sorted_allocList+0x42>
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	8b 50 08             	mov    0x8(%eax),%edx
  80248f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802492:	8b 40 08             	mov    0x8(%eax),%eax
  802495:	39 c2                	cmp    %eax,%edx
  802497:	0f 82 60 01 00 00    	jb     8025fd <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80249d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024a1:	75 65                	jne    802508 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8024a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024a7:	75 14                	jne    8024bd <insert_sorted_allocList+0x62>
  8024a9:	83 ec 04             	sub    $0x4,%esp
  8024ac:	68 24 43 80 00       	push   $0x804324
  8024b1:	6a 6b                	push   $0x6b
  8024b3:	68 47 43 80 00       	push   $0x804347
  8024b8:	e8 9c e2 ff ff       	call   800759 <_panic>
  8024bd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	89 10                	mov    %edx,(%eax)
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	74 0d                	je     8024de <insert_sorted_allocList+0x83>
  8024d1:	a1 40 50 80 00       	mov    0x805040,%eax
  8024d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d9:	89 50 04             	mov    %edx,0x4(%eax)
  8024dc:	eb 08                	jmp    8024e6 <insert_sorted_allocList+0x8b>
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	a3 44 50 80 00       	mov    %eax,0x805044
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	a3 40 50 80 00       	mov    %eax,0x805040
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024fd:	40                   	inc    %eax
  8024fe:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802503:	e9 dc 01 00 00       	jmp    8026e4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802508:	8b 45 08             	mov    0x8(%ebp),%eax
  80250b:	8b 50 08             	mov    0x8(%eax),%edx
  80250e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802511:	8b 40 08             	mov    0x8(%eax),%eax
  802514:	39 c2                	cmp    %eax,%edx
  802516:	77 6c                	ja     802584 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802518:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80251c:	74 06                	je     802524 <insert_sorted_allocList+0xc9>
  80251e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802522:	75 14                	jne    802538 <insert_sorted_allocList+0xdd>
  802524:	83 ec 04             	sub    $0x4,%esp
  802527:	68 60 43 80 00       	push   $0x804360
  80252c:	6a 6f                	push   $0x6f
  80252e:	68 47 43 80 00       	push   $0x804347
  802533:	e8 21 e2 ff ff       	call   800759 <_panic>
  802538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253b:	8b 50 04             	mov    0x4(%eax),%edx
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	89 50 04             	mov    %edx,0x4(%eax)
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80254a:	89 10                	mov    %edx,(%eax)
  80254c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254f:	8b 40 04             	mov    0x4(%eax),%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	74 0d                	je     802563 <insert_sorted_allocList+0x108>
  802556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802559:	8b 40 04             	mov    0x4(%eax),%eax
  80255c:	8b 55 08             	mov    0x8(%ebp),%edx
  80255f:	89 10                	mov    %edx,(%eax)
  802561:	eb 08                	jmp    80256b <insert_sorted_allocList+0x110>
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	a3 40 50 80 00       	mov    %eax,0x805040
  80256b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256e:	8b 55 08             	mov    0x8(%ebp),%edx
  802571:	89 50 04             	mov    %edx,0x4(%eax)
  802574:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802579:	40                   	inc    %eax
  80257a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80257f:	e9 60 01 00 00       	jmp    8026e4 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	8b 50 08             	mov    0x8(%eax),%edx
  80258a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258d:	8b 40 08             	mov    0x8(%eax),%eax
  802590:	39 c2                	cmp    %eax,%edx
  802592:	0f 82 4c 01 00 00    	jb     8026e4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802598:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80259c:	75 14                	jne    8025b2 <insert_sorted_allocList+0x157>
  80259e:	83 ec 04             	sub    $0x4,%esp
  8025a1:	68 98 43 80 00       	push   $0x804398
  8025a6:	6a 73                	push   $0x73
  8025a8:	68 47 43 80 00       	push   $0x804347
  8025ad:	e8 a7 e1 ff ff       	call   800759 <_panic>
  8025b2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	89 50 04             	mov    %edx,0x4(%eax)
  8025be:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c1:	8b 40 04             	mov    0x4(%eax),%eax
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	74 0c                	je     8025d4 <insert_sorted_allocList+0x179>
  8025c8:	a1 44 50 80 00       	mov    0x805044,%eax
  8025cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d0:	89 10                	mov    %edx,(%eax)
  8025d2:	eb 08                	jmp    8025dc <insert_sorted_allocList+0x181>
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	a3 40 50 80 00       	mov    %eax,0x805040
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	a3 44 50 80 00       	mov    %eax,0x805044
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025f2:	40                   	inc    %eax
  8025f3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025f8:	e9 e7 00 00 00       	jmp    8026e4 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8025fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802600:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802603:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80260a:	a1 40 50 80 00       	mov    0x805040,%eax
  80260f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802612:	e9 9d 00 00 00       	jmp    8026b4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	8b 50 08             	mov    0x8(%eax),%edx
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 40 08             	mov    0x8(%eax),%eax
  80262b:	39 c2                	cmp    %eax,%edx
  80262d:	76 7d                	jbe    8026ac <insert_sorted_allocList+0x251>
  80262f:	8b 45 08             	mov    0x8(%ebp),%eax
  802632:	8b 50 08             	mov    0x8(%eax),%edx
  802635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802638:	8b 40 08             	mov    0x8(%eax),%eax
  80263b:	39 c2                	cmp    %eax,%edx
  80263d:	73 6d                	jae    8026ac <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80263f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802643:	74 06                	je     80264b <insert_sorted_allocList+0x1f0>
  802645:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802649:	75 14                	jne    80265f <insert_sorted_allocList+0x204>
  80264b:	83 ec 04             	sub    $0x4,%esp
  80264e:	68 bc 43 80 00       	push   $0x8043bc
  802653:	6a 7f                	push   $0x7f
  802655:	68 47 43 80 00       	push   $0x804347
  80265a:	e8 fa e0 ff ff       	call   800759 <_panic>
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 10                	mov    (%eax),%edx
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	89 10                	mov    %edx,(%eax)
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	8b 00                	mov    (%eax),%eax
  80266e:	85 c0                	test   %eax,%eax
  802670:	74 0b                	je     80267d <insert_sorted_allocList+0x222>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 00                	mov    (%eax),%eax
  802677:	8b 55 08             	mov    0x8(%ebp),%edx
  80267a:	89 50 04             	mov    %edx,0x4(%eax)
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 55 08             	mov    0x8(%ebp),%edx
  802683:	89 10                	mov    %edx,(%eax)
  802685:	8b 45 08             	mov    0x8(%ebp),%eax
  802688:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268b:	89 50 04             	mov    %edx,0x4(%eax)
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	8b 00                	mov    (%eax),%eax
  802693:	85 c0                	test   %eax,%eax
  802695:	75 08                	jne    80269f <insert_sorted_allocList+0x244>
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	a3 44 50 80 00       	mov    %eax,0x805044
  80269f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026a4:	40                   	inc    %eax
  8026a5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8026aa:	eb 39                	jmp    8026e5 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026ac:	a1 48 50 80 00       	mov    0x805048,%eax
  8026b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b8:	74 07                	je     8026c1 <insert_sorted_allocList+0x266>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	eb 05                	jmp    8026c6 <insert_sorted_allocList+0x26b>
  8026c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c6:	a3 48 50 80 00       	mov    %eax,0x805048
  8026cb:	a1 48 50 80 00       	mov    0x805048,%eax
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	0f 85 3f ff ff ff    	jne    802617 <insert_sorted_allocList+0x1bc>
  8026d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dc:	0f 85 35 ff ff ff    	jne    802617 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026e2:	eb 01                	jmp    8026e5 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026e4:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026e5:	90                   	nop
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
  8026eb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026ee:	a1 38 51 80 00       	mov    0x805138,%eax
  8026f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f6:	e9 85 01 00 00       	jmp    802880 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802701:	3b 45 08             	cmp    0x8(%ebp),%eax
  802704:	0f 82 6e 01 00 00    	jb     802878 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 40 0c             	mov    0xc(%eax),%eax
  802710:	3b 45 08             	cmp    0x8(%ebp),%eax
  802713:	0f 85 8a 00 00 00    	jne    8027a3 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802719:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271d:	75 17                	jne    802736 <alloc_block_FF+0x4e>
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	68 f0 43 80 00       	push   $0x8043f0
  802727:	68 93 00 00 00       	push   $0x93
  80272c:	68 47 43 80 00       	push   $0x804347
  802731:	e8 23 e0 ff ff       	call   800759 <_panic>
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	74 10                	je     80274f <alloc_block_FF+0x67>
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 00                	mov    (%eax),%eax
  802744:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802747:	8b 52 04             	mov    0x4(%edx),%edx
  80274a:	89 50 04             	mov    %edx,0x4(%eax)
  80274d:	eb 0b                	jmp    80275a <alloc_block_FF+0x72>
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 40 04             	mov    0x4(%eax),%eax
  802755:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	85 c0                	test   %eax,%eax
  802762:	74 0f                	je     802773 <alloc_block_FF+0x8b>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 40 04             	mov    0x4(%eax),%eax
  80276a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276d:	8b 12                	mov    (%edx),%edx
  80276f:	89 10                	mov    %edx,(%eax)
  802771:	eb 0a                	jmp    80277d <alloc_block_FF+0x95>
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 00                	mov    (%eax),%eax
  802778:	a3 38 51 80 00       	mov    %eax,0x805138
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802790:	a1 44 51 80 00       	mov    0x805144,%eax
  802795:	48                   	dec    %eax
  802796:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	e9 10 01 00 00       	jmp    8028b3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ac:	0f 86 c6 00 00 00    	jbe    802878 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8027b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	8b 50 08             	mov    0x8(%eax),%edx
  8027c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8027c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027cc:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d3:	75 17                	jne    8027ec <alloc_block_FF+0x104>
  8027d5:	83 ec 04             	sub    $0x4,%esp
  8027d8:	68 f0 43 80 00       	push   $0x8043f0
  8027dd:	68 9b 00 00 00       	push   $0x9b
  8027e2:	68 47 43 80 00       	push   $0x804347
  8027e7:	e8 6d df ff ff       	call   800759 <_panic>
  8027ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ef:	8b 00                	mov    (%eax),%eax
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	74 10                	je     802805 <alloc_block_FF+0x11d>
  8027f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fd:	8b 52 04             	mov    0x4(%edx),%edx
  802800:	89 50 04             	mov    %edx,0x4(%eax)
  802803:	eb 0b                	jmp    802810 <alloc_block_FF+0x128>
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	8b 40 04             	mov    0x4(%eax),%eax
  80280b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802813:	8b 40 04             	mov    0x4(%eax),%eax
  802816:	85 c0                	test   %eax,%eax
  802818:	74 0f                	je     802829 <alloc_block_FF+0x141>
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	8b 40 04             	mov    0x4(%eax),%eax
  802820:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802823:	8b 12                	mov    (%edx),%edx
  802825:	89 10                	mov    %edx,(%eax)
  802827:	eb 0a                	jmp    802833 <alloc_block_FF+0x14b>
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282c:	8b 00                	mov    (%eax),%eax
  80282e:	a3 48 51 80 00       	mov    %eax,0x805148
  802833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802836:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802846:	a1 54 51 80 00       	mov    0x805154,%eax
  80284b:	48                   	dec    %eax
  80284c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 50 08             	mov    0x8(%eax),%edx
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	01 c2                	add    %eax,%edx
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 40 0c             	mov    0xc(%eax),%eax
  802868:	2b 45 08             	sub    0x8(%ebp),%eax
  80286b:	89 c2                	mov    %eax,%edx
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802876:	eb 3b                	jmp    8028b3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802878:	a1 40 51 80 00       	mov    0x805140,%eax
  80287d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802880:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802884:	74 07                	je     80288d <alloc_block_FF+0x1a5>
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	eb 05                	jmp    802892 <alloc_block_FF+0x1aa>
  80288d:	b8 00 00 00 00       	mov    $0x0,%eax
  802892:	a3 40 51 80 00       	mov    %eax,0x805140
  802897:	a1 40 51 80 00       	mov    0x805140,%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	0f 85 57 fe ff ff    	jne    8026fb <alloc_block_FF+0x13>
  8028a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a8:	0f 85 4d fe ff ff    	jne    8026fb <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8028ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b3:	c9                   	leave  
  8028b4:	c3                   	ret    

008028b5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028b5:	55                   	push   %ebp
  8028b6:	89 e5                	mov    %esp,%ebp
  8028b8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8028bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028c2:	a1 38 51 80 00       	mov    0x805138,%eax
  8028c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ca:	e9 df 00 00 00       	jmp    8029ae <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d8:	0f 82 c8 00 00 00    	jb     8029a6 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e7:	0f 85 8a 00 00 00    	jne    802977 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8028ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f1:	75 17                	jne    80290a <alloc_block_BF+0x55>
  8028f3:	83 ec 04             	sub    $0x4,%esp
  8028f6:	68 f0 43 80 00       	push   $0x8043f0
  8028fb:	68 b7 00 00 00       	push   $0xb7
  802900:	68 47 43 80 00       	push   $0x804347
  802905:	e8 4f de ff ff       	call   800759 <_panic>
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	85 c0                	test   %eax,%eax
  802911:	74 10                	je     802923 <alloc_block_BF+0x6e>
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291b:	8b 52 04             	mov    0x4(%edx),%edx
  80291e:	89 50 04             	mov    %edx,0x4(%eax)
  802921:	eb 0b                	jmp    80292e <alloc_block_BF+0x79>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 40 04             	mov    0x4(%eax),%eax
  802929:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 40 04             	mov    0x4(%eax),%eax
  802934:	85 c0                	test   %eax,%eax
  802936:	74 0f                	je     802947 <alloc_block_BF+0x92>
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 40 04             	mov    0x4(%eax),%eax
  80293e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802941:	8b 12                	mov    (%edx),%edx
  802943:	89 10                	mov    %edx,(%eax)
  802945:	eb 0a                	jmp    802951 <alloc_block_BF+0x9c>
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	a3 38 51 80 00       	mov    %eax,0x805138
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802964:	a1 44 51 80 00       	mov    0x805144,%eax
  802969:	48                   	dec    %eax
  80296a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	e9 4d 01 00 00       	jmp    802ac4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 40 0c             	mov    0xc(%eax),%eax
  80297d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802980:	76 24                	jbe    8029a6 <alloc_block_BF+0xf1>
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 40 0c             	mov    0xc(%eax),%eax
  802988:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80298b:	73 19                	jae    8029a6 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80298d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 0c             	mov    0xc(%eax),%eax
  80299a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 40 08             	mov    0x8(%eax),%eax
  8029a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b2:	74 07                	je     8029bb <alloc_block_BF+0x106>
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	eb 05                	jmp    8029c0 <alloc_block_BF+0x10b>
  8029bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c0:	a3 40 51 80 00       	mov    %eax,0x805140
  8029c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	0f 85 fd fe ff ff    	jne    8028cf <alloc_block_BF+0x1a>
  8029d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d6:	0f 85 f3 fe ff ff    	jne    8028cf <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8029dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029e0:	0f 84 d9 00 00 00    	je     802abf <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8029eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8029ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f4:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8029f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fd:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a04:	75 17                	jne    802a1d <alloc_block_BF+0x168>
  802a06:	83 ec 04             	sub    $0x4,%esp
  802a09:	68 f0 43 80 00       	push   $0x8043f0
  802a0e:	68 c7 00 00 00       	push   $0xc7
  802a13:	68 47 43 80 00       	push   $0x804347
  802a18:	e8 3c dd ff ff       	call   800759 <_panic>
  802a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a20:	8b 00                	mov    (%eax),%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	74 10                	je     802a36 <alloc_block_BF+0x181>
  802a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a2e:	8b 52 04             	mov    0x4(%edx),%edx
  802a31:	89 50 04             	mov    %edx,0x4(%eax)
  802a34:	eb 0b                	jmp    802a41 <alloc_block_BF+0x18c>
  802a36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a39:	8b 40 04             	mov    0x4(%eax),%eax
  802a3c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 0f                	je     802a5a <alloc_block_BF+0x1a5>
  802a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a54:	8b 12                	mov    (%edx),%edx
  802a56:	89 10                	mov    %edx,(%eax)
  802a58:	eb 0a                	jmp    802a64 <alloc_block_BF+0x1af>
  802a5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	a3 48 51 80 00       	mov    %eax,0x805148
  802a64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a77:	a1 54 51 80 00       	mov    0x805154,%eax
  802a7c:	48                   	dec    %eax
  802a7d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a82:	83 ec 08             	sub    $0x8,%esp
  802a85:	ff 75 ec             	pushl  -0x14(%ebp)
  802a88:	68 38 51 80 00       	push   $0x805138
  802a8d:	e8 71 f9 ff ff       	call   802403 <find_block>
  802a92:	83 c4 10             	add    $0x10,%esp
  802a95:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9b:	8b 50 08             	mov    0x8(%eax),%edx
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	01 c2                	add    %eax,%edx
  802aa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa6:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aac:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaf:	2b 45 08             	sub    0x8(%ebp),%eax
  802ab2:	89 c2                	mov    %eax,%edx
  802ab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802aba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802abd:	eb 05                	jmp    802ac4 <alloc_block_BF+0x20f>
	}
	return NULL;
  802abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ac4:	c9                   	leave  
  802ac5:	c3                   	ret    

00802ac6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ac6:	55                   	push   %ebp
  802ac7:	89 e5                	mov    %esp,%ebp
  802ac9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802acc:	a1 28 50 80 00       	mov    0x805028,%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	0f 85 de 01 00 00    	jne    802cb7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ad9:	a1 38 51 80 00       	mov    0x805138,%eax
  802ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae1:	e9 9e 01 00 00       	jmp    802c84 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 40 0c             	mov    0xc(%eax),%eax
  802aec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aef:	0f 82 87 01 00 00    	jb     802c7c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	8b 40 0c             	mov    0xc(%eax),%eax
  802afb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802afe:	0f 85 95 00 00 00    	jne    802b99 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b08:	75 17                	jne    802b21 <alloc_block_NF+0x5b>
  802b0a:	83 ec 04             	sub    $0x4,%esp
  802b0d:	68 f0 43 80 00       	push   $0x8043f0
  802b12:	68 e0 00 00 00       	push   $0xe0
  802b17:	68 47 43 80 00       	push   $0x804347
  802b1c:	e8 38 dc ff ff       	call   800759 <_panic>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 10                	je     802b3a <alloc_block_NF+0x74>
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b32:	8b 52 04             	mov    0x4(%edx),%edx
  802b35:	89 50 04             	mov    %edx,0x4(%eax)
  802b38:	eb 0b                	jmp    802b45 <alloc_block_NF+0x7f>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 0f                	je     802b5e <alloc_block_NF+0x98>
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b58:	8b 12                	mov    (%edx),%edx
  802b5a:	89 10                	mov    %edx,(%eax)
  802b5c:	eb 0a                	jmp    802b68 <alloc_block_NF+0xa2>
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	a3 38 51 80 00       	mov    %eax,0x805138
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7b:	a1 44 51 80 00       	mov    0x805144,%eax
  802b80:	48                   	dec    %eax
  802b81:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	8b 40 08             	mov    0x8(%eax),%eax
  802b8c:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	e9 f8 04 00 00       	jmp    803091 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba2:	0f 86 d4 00 00 00    	jbe    802c7c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ba8:	a1 48 51 80 00       	mov    0x805148,%eax
  802bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 50 08             	mov    0x8(%eax),%edx
  802bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc9:	75 17                	jne    802be2 <alloc_block_NF+0x11c>
  802bcb:	83 ec 04             	sub    $0x4,%esp
  802bce:	68 f0 43 80 00       	push   $0x8043f0
  802bd3:	68 e9 00 00 00       	push   $0xe9
  802bd8:	68 47 43 80 00       	push   $0x804347
  802bdd:	e8 77 db ff ff       	call   800759 <_panic>
  802be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	74 10                	je     802bfb <alloc_block_NF+0x135>
  802beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf3:	8b 52 04             	mov    0x4(%edx),%edx
  802bf6:	89 50 04             	mov    %edx,0x4(%eax)
  802bf9:	eb 0b                	jmp    802c06 <alloc_block_NF+0x140>
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c09:	8b 40 04             	mov    0x4(%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0f                	je     802c1f <alloc_block_NF+0x159>
  802c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c19:	8b 12                	mov    (%edx),%edx
  802c1b:	89 10                	mov    %edx,(%eax)
  802c1d:	eb 0a                	jmp    802c29 <alloc_block_NF+0x163>
  802c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	a3 48 51 80 00       	mov    %eax,0x805148
  802c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c41:	48                   	dec    %eax
  802c42:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4a:	8b 40 08             	mov    0x8(%eax),%eax
  802c4d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 50 08             	mov    0x8(%eax),%edx
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	01 c2                	add    %eax,%edx
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 40 0c             	mov    0xc(%eax),%eax
  802c69:	2b 45 08             	sub    0x8(%ebp),%eax
  802c6c:	89 c2                	mov    %eax,%edx
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	e9 15 04 00 00       	jmp    803091 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c7c:	a1 40 51 80 00       	mov    0x805140,%eax
  802c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c88:	74 07                	je     802c91 <alloc_block_NF+0x1cb>
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 00                	mov    (%eax),%eax
  802c8f:	eb 05                	jmp    802c96 <alloc_block_NF+0x1d0>
  802c91:	b8 00 00 00 00       	mov    $0x0,%eax
  802c96:	a3 40 51 80 00       	mov    %eax,0x805140
  802c9b:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	0f 85 3e fe ff ff    	jne    802ae6 <alloc_block_NF+0x20>
  802ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cac:	0f 85 34 fe ff ff    	jne    802ae6 <alloc_block_NF+0x20>
  802cb2:	e9 d5 03 00 00       	jmp    80308c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cb7:	a1 38 51 80 00       	mov    0x805138,%eax
  802cbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cbf:	e9 b1 01 00 00       	jmp    802e75 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 50 08             	mov    0x8(%eax),%edx
  802cca:	a1 28 50 80 00       	mov    0x805028,%eax
  802ccf:	39 c2                	cmp    %eax,%edx
  802cd1:	0f 82 96 01 00 00    	jb     802e6d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce0:	0f 82 87 01 00 00    	jb     802e6d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cef:	0f 85 95 00 00 00    	jne    802d8a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cf5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf9:	75 17                	jne    802d12 <alloc_block_NF+0x24c>
  802cfb:	83 ec 04             	sub    $0x4,%esp
  802cfe:	68 f0 43 80 00       	push   $0x8043f0
  802d03:	68 fc 00 00 00       	push   $0xfc
  802d08:	68 47 43 80 00       	push   $0x804347
  802d0d:	e8 47 da ff ff       	call   800759 <_panic>
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	74 10                	je     802d2b <alloc_block_NF+0x265>
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 00                	mov    (%eax),%eax
  802d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d23:	8b 52 04             	mov    0x4(%edx),%edx
  802d26:	89 50 04             	mov    %edx,0x4(%eax)
  802d29:	eb 0b                	jmp    802d36 <alloc_block_NF+0x270>
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 40 04             	mov    0x4(%eax),%eax
  802d31:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	8b 40 04             	mov    0x4(%eax),%eax
  802d3c:	85 c0                	test   %eax,%eax
  802d3e:	74 0f                	je     802d4f <alloc_block_NF+0x289>
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	8b 40 04             	mov    0x4(%eax),%eax
  802d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d49:	8b 12                	mov    (%edx),%edx
  802d4b:	89 10                	mov    %edx,(%eax)
  802d4d:	eb 0a                	jmp    802d59 <alloc_block_NF+0x293>
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	a3 38 51 80 00       	mov    %eax,0x805138
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6c:	a1 44 51 80 00       	mov    0x805144,%eax
  802d71:	48                   	dec    %eax
  802d72:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 40 08             	mov    0x8(%eax),%eax
  802d7d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	e9 07 03 00 00       	jmp    803091 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d90:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d93:	0f 86 d4 00 00 00    	jbe    802e6d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d99:	a1 48 51 80 00       	mov    0x805148,%eax
  802d9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 50 08             	mov    0x8(%eax),%edx
  802da7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802daa:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802dad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db0:	8b 55 08             	mov    0x8(%ebp),%edx
  802db3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802db6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dba:	75 17                	jne    802dd3 <alloc_block_NF+0x30d>
  802dbc:	83 ec 04             	sub    $0x4,%esp
  802dbf:	68 f0 43 80 00       	push   $0x8043f0
  802dc4:	68 04 01 00 00       	push   $0x104
  802dc9:	68 47 43 80 00       	push   $0x804347
  802dce:	e8 86 d9 ff ff       	call   800759 <_panic>
  802dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	74 10                	je     802dec <alloc_block_NF+0x326>
  802ddc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de4:	8b 52 04             	mov    0x4(%edx),%edx
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
  802dea:	eb 0b                	jmp    802df7 <alloc_block_NF+0x331>
  802dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802def:	8b 40 04             	mov    0x4(%eax),%eax
  802df2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfa:	8b 40 04             	mov    0x4(%eax),%eax
  802dfd:	85 c0                	test   %eax,%eax
  802dff:	74 0f                	je     802e10 <alloc_block_NF+0x34a>
  802e01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e04:	8b 40 04             	mov    0x4(%eax),%eax
  802e07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e0a:	8b 12                	mov    (%edx),%edx
  802e0c:	89 10                	mov    %edx,(%eax)
  802e0e:	eb 0a                	jmp    802e1a <alloc_block_NF+0x354>
  802e10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e13:	8b 00                	mov    (%eax),%eax
  802e15:	a3 48 51 80 00       	mov    %eax,0x805148
  802e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2d:	a1 54 51 80 00       	mov    0x805154,%eax
  802e32:	48                   	dec    %eax
  802e33:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3b:	8b 40 08             	mov    0x8(%eax),%eax
  802e3e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 50 08             	mov    0x8(%eax),%edx
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	01 c2                	add    %eax,%edx
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5a:	2b 45 08             	sub    0x8(%ebp),%eax
  802e5d:	89 c2                	mov    %eax,%edx
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e68:	e9 24 02 00 00       	jmp    803091 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e6d:	a1 40 51 80 00       	mov    0x805140,%eax
  802e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e79:	74 07                	je     802e82 <alloc_block_NF+0x3bc>
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	eb 05                	jmp    802e87 <alloc_block_NF+0x3c1>
  802e82:	b8 00 00 00 00       	mov    $0x0,%eax
  802e87:	a3 40 51 80 00       	mov    %eax,0x805140
  802e8c:	a1 40 51 80 00       	mov    0x805140,%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	0f 85 2b fe ff ff    	jne    802cc4 <alloc_block_NF+0x1fe>
  802e99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9d:	0f 85 21 fe ff ff    	jne    802cc4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ea3:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eab:	e9 ae 01 00 00       	jmp    80305e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 50 08             	mov    0x8(%eax),%edx
  802eb6:	a1 28 50 80 00       	mov    0x805028,%eax
  802ebb:	39 c2                	cmp    %eax,%edx
  802ebd:	0f 83 93 01 00 00    	jae    803056 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ecc:	0f 82 84 01 00 00    	jb     803056 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802edb:	0f 85 95 00 00 00    	jne    802f76 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ee1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee5:	75 17                	jne    802efe <alloc_block_NF+0x438>
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 f0 43 80 00       	push   $0x8043f0
  802eef:	68 14 01 00 00       	push   $0x114
  802ef4:	68 47 43 80 00       	push   $0x804347
  802ef9:	e8 5b d8 ff ff       	call   800759 <_panic>
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 10                	je     802f17 <alloc_block_NF+0x451>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0f:	8b 52 04             	mov    0x4(%edx),%edx
  802f12:	89 50 04             	mov    %edx,0x4(%eax)
  802f15:	eb 0b                	jmp    802f22 <alloc_block_NF+0x45c>
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 0f                	je     802f3b <alloc_block_NF+0x475>
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 40 04             	mov    0x4(%eax),%eax
  802f32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f35:	8b 12                	mov    (%edx),%edx
  802f37:	89 10                	mov    %edx,(%eax)
  802f39:	eb 0a                	jmp    802f45 <alloc_block_NF+0x47f>
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	a3 38 51 80 00       	mov    %eax,0x805138
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f58:	a1 44 51 80 00       	mov    0x805144,%eax
  802f5d:	48                   	dec    %eax
  802f5e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 40 08             	mov    0x8(%eax),%eax
  802f69:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	e9 1b 01 00 00       	jmp    803091 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f7f:	0f 86 d1 00 00 00    	jbe    803056 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f85:	a1 48 51 80 00       	mov    0x805148,%eax
  802f8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	8b 50 08             	mov    0x8(%eax),%edx
  802f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f96:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fa2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fa6:	75 17                	jne    802fbf <alloc_block_NF+0x4f9>
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	68 f0 43 80 00       	push   $0x8043f0
  802fb0:	68 1c 01 00 00       	push   $0x11c
  802fb5:	68 47 43 80 00       	push   $0x804347
  802fba:	e8 9a d7 ff ff       	call   800759 <_panic>
  802fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc2:	8b 00                	mov    (%eax),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	74 10                	je     802fd8 <alloc_block_NF+0x512>
  802fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fd0:	8b 52 04             	mov    0x4(%edx),%edx
  802fd3:	89 50 04             	mov    %edx,0x4(%eax)
  802fd6:	eb 0b                	jmp    802fe3 <alloc_block_NF+0x51d>
  802fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdb:	8b 40 04             	mov    0x4(%eax),%eax
  802fde:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fe3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	74 0f                	je     802ffc <alloc_block_NF+0x536>
  802fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff0:	8b 40 04             	mov    0x4(%eax),%eax
  802ff3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ff6:	8b 12                	mov    (%edx),%edx
  802ff8:	89 10                	mov    %edx,(%eax)
  802ffa:	eb 0a                	jmp    803006 <alloc_block_NF+0x540>
  802ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	a3 48 51 80 00       	mov    %eax,0x805148
  803006:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803009:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803012:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803019:	a1 54 51 80 00       	mov    0x805154,%eax
  80301e:	48                   	dec    %eax
  80301f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803024:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803027:	8b 40 08             	mov    0x8(%eax),%eax
  80302a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	8b 50 08             	mov    0x8(%eax),%edx
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	01 c2                	add    %eax,%edx
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 40 0c             	mov    0xc(%eax),%eax
  803046:	2b 45 08             	sub    0x8(%ebp),%eax
  803049:	89 c2                	mov    %eax,%edx
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803054:	eb 3b                	jmp    803091 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803056:	a1 40 51 80 00       	mov    0x805140,%eax
  80305b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80305e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803062:	74 07                	je     80306b <alloc_block_NF+0x5a5>
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 00                	mov    (%eax),%eax
  803069:	eb 05                	jmp    803070 <alloc_block_NF+0x5aa>
  80306b:	b8 00 00 00 00       	mov    $0x0,%eax
  803070:	a3 40 51 80 00       	mov    %eax,0x805140
  803075:	a1 40 51 80 00       	mov    0x805140,%eax
  80307a:	85 c0                	test   %eax,%eax
  80307c:	0f 85 2e fe ff ff    	jne    802eb0 <alloc_block_NF+0x3ea>
  803082:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803086:	0f 85 24 fe ff ff    	jne    802eb0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80308c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803091:	c9                   	leave  
  803092:	c3                   	ret    

00803093 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803093:	55                   	push   %ebp
  803094:	89 e5                	mov    %esp,%ebp
  803096:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803099:	a1 38 51 80 00       	mov    0x805138,%eax
  80309e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8030a1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030a6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8030a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	74 14                	je     8030c6 <insert_sorted_with_merge_freeList+0x33>
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	8b 50 08             	mov    0x8(%eax),%edx
  8030b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bb:	8b 40 08             	mov    0x8(%eax),%eax
  8030be:	39 c2                	cmp    %eax,%edx
  8030c0:	0f 87 9b 01 00 00    	ja     803261 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8030c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ca:	75 17                	jne    8030e3 <insert_sorted_with_merge_freeList+0x50>
  8030cc:	83 ec 04             	sub    $0x4,%esp
  8030cf:	68 24 43 80 00       	push   $0x804324
  8030d4:	68 38 01 00 00       	push   $0x138
  8030d9:	68 47 43 80 00       	push   $0x804347
  8030de:	e8 76 d6 ff ff       	call   800759 <_panic>
  8030e3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	89 10                	mov    %edx,(%eax)
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	8b 00                	mov    (%eax),%eax
  8030f3:	85 c0                	test   %eax,%eax
  8030f5:	74 0d                	je     803104 <insert_sorted_with_merge_freeList+0x71>
  8030f7:	a1 38 51 80 00       	mov    0x805138,%eax
  8030fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ff:	89 50 04             	mov    %edx,0x4(%eax)
  803102:	eb 08                	jmp    80310c <insert_sorted_with_merge_freeList+0x79>
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	a3 38 51 80 00       	mov    %eax,0x805138
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311e:	a1 44 51 80 00       	mov    0x805144,%eax
  803123:	40                   	inc    %eax
  803124:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803129:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80312d:	0f 84 a8 06 00 00    	je     8037db <insert_sorted_with_merge_freeList+0x748>
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	8b 50 08             	mov    0x8(%eax),%edx
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 40 0c             	mov    0xc(%eax),%eax
  80313f:	01 c2                	add    %eax,%edx
  803141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803144:	8b 40 08             	mov    0x8(%eax),%eax
  803147:	39 c2                	cmp    %eax,%edx
  803149:	0f 85 8c 06 00 00    	jne    8037db <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	8b 50 0c             	mov    0xc(%eax),%edx
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	8b 40 0c             	mov    0xc(%eax),%eax
  80315b:	01 c2                	add    %eax,%edx
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803163:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803167:	75 17                	jne    803180 <insert_sorted_with_merge_freeList+0xed>
  803169:	83 ec 04             	sub    $0x4,%esp
  80316c:	68 f0 43 80 00       	push   $0x8043f0
  803171:	68 3c 01 00 00       	push   $0x13c
  803176:	68 47 43 80 00       	push   $0x804347
  80317b:	e8 d9 d5 ff ff       	call   800759 <_panic>
  803180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	74 10                	je     803199 <insert_sorted_with_merge_freeList+0x106>
  803189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803191:	8b 52 04             	mov    0x4(%edx),%edx
  803194:	89 50 04             	mov    %edx,0x4(%eax)
  803197:	eb 0b                	jmp    8031a4 <insert_sorted_with_merge_freeList+0x111>
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	8b 40 04             	mov    0x4(%eax),%eax
  80319f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a7:	8b 40 04             	mov    0x4(%eax),%eax
  8031aa:	85 c0                	test   %eax,%eax
  8031ac:	74 0f                	je     8031bd <insert_sorted_with_merge_freeList+0x12a>
  8031ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b1:	8b 40 04             	mov    0x4(%eax),%eax
  8031b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b7:	8b 12                	mov    (%edx),%edx
  8031b9:	89 10                	mov    %edx,(%eax)
  8031bb:	eb 0a                	jmp    8031c7 <insert_sorted_with_merge_freeList+0x134>
  8031bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c0:	8b 00                	mov    (%eax),%eax
  8031c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031da:	a1 44 51 80 00       	mov    0x805144,%eax
  8031df:	48                   	dec    %eax
  8031e0:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8031e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8031ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8031f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031fd:	75 17                	jne    803216 <insert_sorted_with_merge_freeList+0x183>
  8031ff:	83 ec 04             	sub    $0x4,%esp
  803202:	68 24 43 80 00       	push   $0x804324
  803207:	68 3f 01 00 00       	push   $0x13f
  80320c:	68 47 43 80 00       	push   $0x804347
  803211:	e8 43 d5 ff ff       	call   800759 <_panic>
  803216:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80321c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321f:	89 10                	mov    %edx,(%eax)
  803221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	74 0d                	je     803237 <insert_sorted_with_merge_freeList+0x1a4>
  80322a:	a1 48 51 80 00       	mov    0x805148,%eax
  80322f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803232:	89 50 04             	mov    %edx,0x4(%eax)
  803235:	eb 08                	jmp    80323f <insert_sorted_with_merge_freeList+0x1ac>
  803237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80323f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803242:	a3 48 51 80 00       	mov    %eax,0x805148
  803247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803251:	a1 54 51 80 00       	mov    0x805154,%eax
  803256:	40                   	inc    %eax
  803257:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80325c:	e9 7a 05 00 00       	jmp    8037db <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	8b 50 08             	mov    0x8(%eax),%edx
  803267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326a:	8b 40 08             	mov    0x8(%eax),%eax
  80326d:	39 c2                	cmp    %eax,%edx
  80326f:	0f 82 14 01 00 00    	jb     803389 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803278:	8b 50 08             	mov    0x8(%eax),%edx
  80327b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327e:	8b 40 0c             	mov    0xc(%eax),%eax
  803281:	01 c2                	add    %eax,%edx
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	8b 40 08             	mov    0x8(%eax),%eax
  803289:	39 c2                	cmp    %eax,%edx
  80328b:	0f 85 90 00 00 00    	jne    803321 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803291:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803294:	8b 50 0c             	mov    0xc(%eax),%edx
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	8b 40 0c             	mov    0xc(%eax),%eax
  80329d:	01 c2                	add    %eax,%edx
  80329f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a2:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032bd:	75 17                	jne    8032d6 <insert_sorted_with_merge_freeList+0x243>
  8032bf:	83 ec 04             	sub    $0x4,%esp
  8032c2:	68 24 43 80 00       	push   $0x804324
  8032c7:	68 49 01 00 00       	push   $0x149
  8032cc:	68 47 43 80 00       	push   $0x804347
  8032d1:	e8 83 d4 ff ff       	call   800759 <_panic>
  8032d6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	89 10                	mov    %edx,(%eax)
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	74 0d                	je     8032f7 <insert_sorted_with_merge_freeList+0x264>
  8032ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f2:	89 50 04             	mov    %edx,0x4(%eax)
  8032f5:	eb 08                	jmp    8032ff <insert_sorted_with_merge_freeList+0x26c>
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803302:	a3 48 51 80 00       	mov    %eax,0x805148
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803311:	a1 54 51 80 00       	mov    0x805154,%eax
  803316:	40                   	inc    %eax
  803317:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80331c:	e9 bb 04 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803325:	75 17                	jne    80333e <insert_sorted_with_merge_freeList+0x2ab>
  803327:	83 ec 04             	sub    $0x4,%esp
  80332a:	68 98 43 80 00       	push   $0x804398
  80332f:	68 4c 01 00 00       	push   $0x14c
  803334:	68 47 43 80 00       	push   $0x804347
  803339:	e8 1b d4 ff ff       	call   800759 <_panic>
  80333e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	89 50 04             	mov    %edx,0x4(%eax)
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	8b 40 04             	mov    0x4(%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 0c                	je     803360 <insert_sorted_with_merge_freeList+0x2cd>
  803354:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803359:	8b 55 08             	mov    0x8(%ebp),%edx
  80335c:	89 10                	mov    %edx,(%eax)
  80335e:	eb 08                	jmp    803368 <insert_sorted_with_merge_freeList+0x2d5>
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	a3 38 51 80 00       	mov    %eax,0x805138
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803370:	8b 45 08             	mov    0x8(%ebp),%eax
  803373:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803379:	a1 44 51 80 00       	mov    0x805144,%eax
  80337e:	40                   	inc    %eax
  80337f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803384:	e9 53 04 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803389:	a1 38 51 80 00       	mov    0x805138,%eax
  80338e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803391:	e9 15 04 00 00       	jmp    8037ab <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	8b 50 08             	mov    0x8(%eax),%edx
  8033a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a7:	8b 40 08             	mov    0x8(%eax),%eax
  8033aa:	39 c2                	cmp    %eax,%edx
  8033ac:	0f 86 f1 03 00 00    	jbe    8037a3 <insert_sorted_with_merge_freeList+0x710>
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	8b 50 08             	mov    0x8(%eax),%edx
  8033b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bb:	8b 40 08             	mov    0x8(%eax),%eax
  8033be:	39 c2                	cmp    %eax,%edx
  8033c0:	0f 83 dd 03 00 00    	jae    8037a3 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	8b 50 08             	mov    0x8(%eax),%edx
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d2:	01 c2                	add    %eax,%edx
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	8b 40 08             	mov    0x8(%eax),%eax
  8033da:	39 c2                	cmp    %eax,%edx
  8033dc:	0f 85 b9 01 00 00    	jne    80359b <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e5:	8b 50 08             	mov    0x8(%eax),%edx
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ee:	01 c2                	add    %eax,%edx
  8033f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f3:	8b 40 08             	mov    0x8(%eax),%eax
  8033f6:	39 c2                	cmp    %eax,%edx
  8033f8:	0f 85 0d 01 00 00    	jne    80350b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8033fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803401:	8b 50 0c             	mov    0xc(%eax),%edx
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	8b 40 0c             	mov    0xc(%eax),%eax
  80340a:	01 c2                	add    %eax,%edx
  80340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803412:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803416:	75 17                	jne    80342f <insert_sorted_with_merge_freeList+0x39c>
  803418:	83 ec 04             	sub    $0x4,%esp
  80341b:	68 f0 43 80 00       	push   $0x8043f0
  803420:	68 5c 01 00 00       	push   $0x15c
  803425:	68 47 43 80 00       	push   $0x804347
  80342a:	e8 2a d3 ff ff       	call   800759 <_panic>
  80342f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	85 c0                	test   %eax,%eax
  803436:	74 10                	je     803448 <insert_sorted_with_merge_freeList+0x3b5>
  803438:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343b:	8b 00                	mov    (%eax),%eax
  80343d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803440:	8b 52 04             	mov    0x4(%edx),%edx
  803443:	89 50 04             	mov    %edx,0x4(%eax)
  803446:	eb 0b                	jmp    803453 <insert_sorted_with_merge_freeList+0x3c0>
  803448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344b:	8b 40 04             	mov    0x4(%eax),%eax
  80344e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803453:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803456:	8b 40 04             	mov    0x4(%eax),%eax
  803459:	85 c0                	test   %eax,%eax
  80345b:	74 0f                	je     80346c <insert_sorted_with_merge_freeList+0x3d9>
  80345d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803460:	8b 40 04             	mov    0x4(%eax),%eax
  803463:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803466:	8b 12                	mov    (%edx),%edx
  803468:	89 10                	mov    %edx,(%eax)
  80346a:	eb 0a                	jmp    803476 <insert_sorted_with_merge_freeList+0x3e3>
  80346c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346f:	8b 00                	mov    (%eax),%eax
  803471:	a3 38 51 80 00       	mov    %eax,0x805138
  803476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803482:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803489:	a1 44 51 80 00       	mov    0x805144,%eax
  80348e:	48                   	dec    %eax
  80348f:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803494:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803497:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80349e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034ac:	75 17                	jne    8034c5 <insert_sorted_with_merge_freeList+0x432>
  8034ae:	83 ec 04             	sub    $0x4,%esp
  8034b1:	68 24 43 80 00       	push   $0x804324
  8034b6:	68 5f 01 00 00       	push   $0x15f
  8034bb:	68 47 43 80 00       	push   $0x804347
  8034c0:	e8 94 d2 ff ff       	call   800759 <_panic>
  8034c5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ce:	89 10                	mov    %edx,(%eax)
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	8b 00                	mov    (%eax),%eax
  8034d5:	85 c0                	test   %eax,%eax
  8034d7:	74 0d                	je     8034e6 <insert_sorted_with_merge_freeList+0x453>
  8034d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8034de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034e1:	89 50 04             	mov    %edx,0x4(%eax)
  8034e4:	eb 08                	jmp    8034ee <insert_sorted_with_merge_freeList+0x45b>
  8034e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8034f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803500:	a1 54 51 80 00       	mov    0x805154,%eax
  803505:	40                   	inc    %eax
  803506:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	8b 50 0c             	mov    0xc(%eax),%edx
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	8b 40 0c             	mov    0xc(%eax),%eax
  803517:	01 c2                	add    %eax,%edx
  803519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803533:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803537:	75 17                	jne    803550 <insert_sorted_with_merge_freeList+0x4bd>
  803539:	83 ec 04             	sub    $0x4,%esp
  80353c:	68 24 43 80 00       	push   $0x804324
  803541:	68 64 01 00 00       	push   $0x164
  803546:	68 47 43 80 00       	push   $0x804347
  80354b:	e8 09 d2 ff ff       	call   800759 <_panic>
  803550:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	89 10                	mov    %edx,(%eax)
  80355b:	8b 45 08             	mov    0x8(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 0d                	je     803571 <insert_sorted_with_merge_freeList+0x4de>
  803564:	a1 48 51 80 00       	mov    0x805148,%eax
  803569:	8b 55 08             	mov    0x8(%ebp),%edx
  80356c:	89 50 04             	mov    %edx,0x4(%eax)
  80356f:	eb 08                	jmp    803579 <insert_sorted_with_merge_freeList+0x4e6>
  803571:	8b 45 08             	mov    0x8(%ebp),%eax
  803574:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803579:	8b 45 08             	mov    0x8(%ebp),%eax
  80357c:	a3 48 51 80 00       	mov    %eax,0x805148
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358b:	a1 54 51 80 00       	mov    0x805154,%eax
  803590:	40                   	inc    %eax
  803591:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803596:	e9 41 02 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80359b:	8b 45 08             	mov    0x8(%ebp),%eax
  80359e:	8b 50 08             	mov    0x8(%eax),%edx
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a7:	01 c2                	add    %eax,%edx
  8035a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ac:	8b 40 08             	mov    0x8(%eax),%eax
  8035af:	39 c2                	cmp    %eax,%edx
  8035b1:	0f 85 7c 01 00 00    	jne    803733 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8035b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035bb:	74 06                	je     8035c3 <insert_sorted_with_merge_freeList+0x530>
  8035bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035c1:	75 17                	jne    8035da <insert_sorted_with_merge_freeList+0x547>
  8035c3:	83 ec 04             	sub    $0x4,%esp
  8035c6:	68 60 43 80 00       	push   $0x804360
  8035cb:	68 69 01 00 00       	push   $0x169
  8035d0:	68 47 43 80 00       	push   $0x804347
  8035d5:	e8 7f d1 ff ff       	call   800759 <_panic>
  8035da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dd:	8b 50 04             	mov    0x4(%eax),%edx
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	89 50 04             	mov    %edx,0x4(%eax)
  8035e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035ec:	89 10                	mov    %edx,(%eax)
  8035ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f1:	8b 40 04             	mov    0x4(%eax),%eax
  8035f4:	85 c0                	test   %eax,%eax
  8035f6:	74 0d                	je     803605 <insert_sorted_with_merge_freeList+0x572>
  8035f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fb:	8b 40 04             	mov    0x4(%eax),%eax
  8035fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803601:	89 10                	mov    %edx,(%eax)
  803603:	eb 08                	jmp    80360d <insert_sorted_with_merge_freeList+0x57a>
  803605:	8b 45 08             	mov    0x8(%ebp),%eax
  803608:	a3 38 51 80 00       	mov    %eax,0x805138
  80360d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803610:	8b 55 08             	mov    0x8(%ebp),%edx
  803613:	89 50 04             	mov    %edx,0x4(%eax)
  803616:	a1 44 51 80 00       	mov    0x805144,%eax
  80361b:	40                   	inc    %eax
  80361c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803621:	8b 45 08             	mov    0x8(%ebp),%eax
  803624:	8b 50 0c             	mov    0xc(%eax),%edx
  803627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362a:	8b 40 0c             	mov    0xc(%eax),%eax
  80362d:	01 c2                	add    %eax,%edx
  80362f:	8b 45 08             	mov    0x8(%ebp),%eax
  803632:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803635:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803639:	75 17                	jne    803652 <insert_sorted_with_merge_freeList+0x5bf>
  80363b:	83 ec 04             	sub    $0x4,%esp
  80363e:	68 f0 43 80 00       	push   $0x8043f0
  803643:	68 6b 01 00 00       	push   $0x16b
  803648:	68 47 43 80 00       	push   $0x804347
  80364d:	e8 07 d1 ff ff       	call   800759 <_panic>
  803652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803655:	8b 00                	mov    (%eax),%eax
  803657:	85 c0                	test   %eax,%eax
  803659:	74 10                	je     80366b <insert_sorted_with_merge_freeList+0x5d8>
  80365b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365e:	8b 00                	mov    (%eax),%eax
  803660:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803663:	8b 52 04             	mov    0x4(%edx),%edx
  803666:	89 50 04             	mov    %edx,0x4(%eax)
  803669:	eb 0b                	jmp    803676 <insert_sorted_with_merge_freeList+0x5e3>
  80366b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366e:	8b 40 04             	mov    0x4(%eax),%eax
  803671:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803679:	8b 40 04             	mov    0x4(%eax),%eax
  80367c:	85 c0                	test   %eax,%eax
  80367e:	74 0f                	je     80368f <insert_sorted_with_merge_freeList+0x5fc>
  803680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803683:	8b 40 04             	mov    0x4(%eax),%eax
  803686:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803689:	8b 12                	mov    (%edx),%edx
  80368b:	89 10                	mov    %edx,(%eax)
  80368d:	eb 0a                	jmp    803699 <insert_sorted_with_merge_freeList+0x606>
  80368f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803692:	8b 00                	mov    (%eax),%eax
  803694:	a3 38 51 80 00       	mov    %eax,0x805138
  803699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8036b1:	48                   	dec    %eax
  8036b2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8036b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8036c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036cf:	75 17                	jne    8036e8 <insert_sorted_with_merge_freeList+0x655>
  8036d1:	83 ec 04             	sub    $0x4,%esp
  8036d4:	68 24 43 80 00       	push   $0x804324
  8036d9:	68 6e 01 00 00       	push   $0x16e
  8036de:	68 47 43 80 00       	push   $0x804347
  8036e3:	e8 71 d0 ff ff       	call   800759 <_panic>
  8036e8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f1:	89 10                	mov    %edx,(%eax)
  8036f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f6:	8b 00                	mov    (%eax),%eax
  8036f8:	85 c0                	test   %eax,%eax
  8036fa:	74 0d                	je     803709 <insert_sorted_with_merge_freeList+0x676>
  8036fc:	a1 48 51 80 00       	mov    0x805148,%eax
  803701:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803704:	89 50 04             	mov    %edx,0x4(%eax)
  803707:	eb 08                	jmp    803711 <insert_sorted_with_merge_freeList+0x67e>
  803709:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803711:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803714:	a3 48 51 80 00       	mov    %eax,0x805148
  803719:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803723:	a1 54 51 80 00       	mov    0x805154,%eax
  803728:	40                   	inc    %eax
  803729:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80372e:	e9 a9 00 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803733:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803737:	74 06                	je     80373f <insert_sorted_with_merge_freeList+0x6ac>
  803739:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80373d:	75 17                	jne    803756 <insert_sorted_with_merge_freeList+0x6c3>
  80373f:	83 ec 04             	sub    $0x4,%esp
  803742:	68 bc 43 80 00       	push   $0x8043bc
  803747:	68 73 01 00 00       	push   $0x173
  80374c:	68 47 43 80 00       	push   $0x804347
  803751:	e8 03 d0 ff ff       	call   800759 <_panic>
  803756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803759:	8b 10                	mov    (%eax),%edx
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	89 10                	mov    %edx,(%eax)
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	8b 00                	mov    (%eax),%eax
  803765:	85 c0                	test   %eax,%eax
  803767:	74 0b                	je     803774 <insert_sorted_with_merge_freeList+0x6e1>
  803769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376c:	8b 00                	mov    (%eax),%eax
  80376e:	8b 55 08             	mov    0x8(%ebp),%edx
  803771:	89 50 04             	mov    %edx,0x4(%eax)
  803774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803777:	8b 55 08             	mov    0x8(%ebp),%edx
  80377a:	89 10                	mov    %edx,(%eax)
  80377c:	8b 45 08             	mov    0x8(%ebp),%eax
  80377f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803782:	89 50 04             	mov    %edx,0x4(%eax)
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	8b 00                	mov    (%eax),%eax
  80378a:	85 c0                	test   %eax,%eax
  80378c:	75 08                	jne    803796 <insert_sorted_with_merge_freeList+0x703>
  80378e:	8b 45 08             	mov    0x8(%ebp),%eax
  803791:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803796:	a1 44 51 80 00       	mov    0x805144,%eax
  80379b:	40                   	inc    %eax
  80379c:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8037a1:	eb 39                	jmp    8037dc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8037a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8037a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037af:	74 07                	je     8037b8 <insert_sorted_with_merge_freeList+0x725>
  8037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b4:	8b 00                	mov    (%eax),%eax
  8037b6:	eb 05                	jmp    8037bd <insert_sorted_with_merge_freeList+0x72a>
  8037b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8037bd:	a3 40 51 80 00       	mov    %eax,0x805140
  8037c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8037c7:	85 c0                	test   %eax,%eax
  8037c9:	0f 85 c7 fb ff ff    	jne    803396 <insert_sorted_with_merge_freeList+0x303>
  8037cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d3:	0f 85 bd fb ff ff    	jne    803396 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037d9:	eb 01                	jmp    8037dc <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037db:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037dc:	90                   	nop
  8037dd:	c9                   	leave  
  8037de:	c3                   	ret    
  8037df:	90                   	nop

008037e0 <__udivdi3>:
  8037e0:	55                   	push   %ebp
  8037e1:	57                   	push   %edi
  8037e2:	56                   	push   %esi
  8037e3:	53                   	push   %ebx
  8037e4:	83 ec 1c             	sub    $0x1c,%esp
  8037e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037f7:	89 ca                	mov    %ecx,%edx
  8037f9:	89 f8                	mov    %edi,%eax
  8037fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037ff:	85 f6                	test   %esi,%esi
  803801:	75 2d                	jne    803830 <__udivdi3+0x50>
  803803:	39 cf                	cmp    %ecx,%edi
  803805:	77 65                	ja     80386c <__udivdi3+0x8c>
  803807:	89 fd                	mov    %edi,%ebp
  803809:	85 ff                	test   %edi,%edi
  80380b:	75 0b                	jne    803818 <__udivdi3+0x38>
  80380d:	b8 01 00 00 00       	mov    $0x1,%eax
  803812:	31 d2                	xor    %edx,%edx
  803814:	f7 f7                	div    %edi
  803816:	89 c5                	mov    %eax,%ebp
  803818:	31 d2                	xor    %edx,%edx
  80381a:	89 c8                	mov    %ecx,%eax
  80381c:	f7 f5                	div    %ebp
  80381e:	89 c1                	mov    %eax,%ecx
  803820:	89 d8                	mov    %ebx,%eax
  803822:	f7 f5                	div    %ebp
  803824:	89 cf                	mov    %ecx,%edi
  803826:	89 fa                	mov    %edi,%edx
  803828:	83 c4 1c             	add    $0x1c,%esp
  80382b:	5b                   	pop    %ebx
  80382c:	5e                   	pop    %esi
  80382d:	5f                   	pop    %edi
  80382e:	5d                   	pop    %ebp
  80382f:	c3                   	ret    
  803830:	39 ce                	cmp    %ecx,%esi
  803832:	77 28                	ja     80385c <__udivdi3+0x7c>
  803834:	0f bd fe             	bsr    %esi,%edi
  803837:	83 f7 1f             	xor    $0x1f,%edi
  80383a:	75 40                	jne    80387c <__udivdi3+0x9c>
  80383c:	39 ce                	cmp    %ecx,%esi
  80383e:	72 0a                	jb     80384a <__udivdi3+0x6a>
  803840:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803844:	0f 87 9e 00 00 00    	ja     8038e8 <__udivdi3+0x108>
  80384a:	b8 01 00 00 00       	mov    $0x1,%eax
  80384f:	89 fa                	mov    %edi,%edx
  803851:	83 c4 1c             	add    $0x1c,%esp
  803854:	5b                   	pop    %ebx
  803855:	5e                   	pop    %esi
  803856:	5f                   	pop    %edi
  803857:	5d                   	pop    %ebp
  803858:	c3                   	ret    
  803859:	8d 76 00             	lea    0x0(%esi),%esi
  80385c:	31 ff                	xor    %edi,%edi
  80385e:	31 c0                	xor    %eax,%eax
  803860:	89 fa                	mov    %edi,%edx
  803862:	83 c4 1c             	add    $0x1c,%esp
  803865:	5b                   	pop    %ebx
  803866:	5e                   	pop    %esi
  803867:	5f                   	pop    %edi
  803868:	5d                   	pop    %ebp
  803869:	c3                   	ret    
  80386a:	66 90                	xchg   %ax,%ax
  80386c:	89 d8                	mov    %ebx,%eax
  80386e:	f7 f7                	div    %edi
  803870:	31 ff                	xor    %edi,%edi
  803872:	89 fa                	mov    %edi,%edx
  803874:	83 c4 1c             	add    $0x1c,%esp
  803877:	5b                   	pop    %ebx
  803878:	5e                   	pop    %esi
  803879:	5f                   	pop    %edi
  80387a:	5d                   	pop    %ebp
  80387b:	c3                   	ret    
  80387c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803881:	89 eb                	mov    %ebp,%ebx
  803883:	29 fb                	sub    %edi,%ebx
  803885:	89 f9                	mov    %edi,%ecx
  803887:	d3 e6                	shl    %cl,%esi
  803889:	89 c5                	mov    %eax,%ebp
  80388b:	88 d9                	mov    %bl,%cl
  80388d:	d3 ed                	shr    %cl,%ebp
  80388f:	89 e9                	mov    %ebp,%ecx
  803891:	09 f1                	or     %esi,%ecx
  803893:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803897:	89 f9                	mov    %edi,%ecx
  803899:	d3 e0                	shl    %cl,%eax
  80389b:	89 c5                	mov    %eax,%ebp
  80389d:	89 d6                	mov    %edx,%esi
  80389f:	88 d9                	mov    %bl,%cl
  8038a1:	d3 ee                	shr    %cl,%esi
  8038a3:	89 f9                	mov    %edi,%ecx
  8038a5:	d3 e2                	shl    %cl,%edx
  8038a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ab:	88 d9                	mov    %bl,%cl
  8038ad:	d3 e8                	shr    %cl,%eax
  8038af:	09 c2                	or     %eax,%edx
  8038b1:	89 d0                	mov    %edx,%eax
  8038b3:	89 f2                	mov    %esi,%edx
  8038b5:	f7 74 24 0c          	divl   0xc(%esp)
  8038b9:	89 d6                	mov    %edx,%esi
  8038bb:	89 c3                	mov    %eax,%ebx
  8038bd:	f7 e5                	mul    %ebp
  8038bf:	39 d6                	cmp    %edx,%esi
  8038c1:	72 19                	jb     8038dc <__udivdi3+0xfc>
  8038c3:	74 0b                	je     8038d0 <__udivdi3+0xf0>
  8038c5:	89 d8                	mov    %ebx,%eax
  8038c7:	31 ff                	xor    %edi,%edi
  8038c9:	e9 58 ff ff ff       	jmp    803826 <__udivdi3+0x46>
  8038ce:	66 90                	xchg   %ax,%ax
  8038d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038d4:	89 f9                	mov    %edi,%ecx
  8038d6:	d3 e2                	shl    %cl,%edx
  8038d8:	39 c2                	cmp    %eax,%edx
  8038da:	73 e9                	jae    8038c5 <__udivdi3+0xe5>
  8038dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038df:	31 ff                	xor    %edi,%edi
  8038e1:	e9 40 ff ff ff       	jmp    803826 <__udivdi3+0x46>
  8038e6:	66 90                	xchg   %ax,%ax
  8038e8:	31 c0                	xor    %eax,%eax
  8038ea:	e9 37 ff ff ff       	jmp    803826 <__udivdi3+0x46>
  8038ef:	90                   	nop

008038f0 <__umoddi3>:
  8038f0:	55                   	push   %ebp
  8038f1:	57                   	push   %edi
  8038f2:	56                   	push   %esi
  8038f3:	53                   	push   %ebx
  8038f4:	83 ec 1c             	sub    $0x1c,%esp
  8038f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803903:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803907:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80390b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80390f:	89 f3                	mov    %esi,%ebx
  803911:	89 fa                	mov    %edi,%edx
  803913:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803917:	89 34 24             	mov    %esi,(%esp)
  80391a:	85 c0                	test   %eax,%eax
  80391c:	75 1a                	jne    803938 <__umoddi3+0x48>
  80391e:	39 f7                	cmp    %esi,%edi
  803920:	0f 86 a2 00 00 00    	jbe    8039c8 <__umoddi3+0xd8>
  803926:	89 c8                	mov    %ecx,%eax
  803928:	89 f2                	mov    %esi,%edx
  80392a:	f7 f7                	div    %edi
  80392c:	89 d0                	mov    %edx,%eax
  80392e:	31 d2                	xor    %edx,%edx
  803930:	83 c4 1c             	add    $0x1c,%esp
  803933:	5b                   	pop    %ebx
  803934:	5e                   	pop    %esi
  803935:	5f                   	pop    %edi
  803936:	5d                   	pop    %ebp
  803937:	c3                   	ret    
  803938:	39 f0                	cmp    %esi,%eax
  80393a:	0f 87 ac 00 00 00    	ja     8039ec <__umoddi3+0xfc>
  803940:	0f bd e8             	bsr    %eax,%ebp
  803943:	83 f5 1f             	xor    $0x1f,%ebp
  803946:	0f 84 ac 00 00 00    	je     8039f8 <__umoddi3+0x108>
  80394c:	bf 20 00 00 00       	mov    $0x20,%edi
  803951:	29 ef                	sub    %ebp,%edi
  803953:	89 fe                	mov    %edi,%esi
  803955:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803959:	89 e9                	mov    %ebp,%ecx
  80395b:	d3 e0                	shl    %cl,%eax
  80395d:	89 d7                	mov    %edx,%edi
  80395f:	89 f1                	mov    %esi,%ecx
  803961:	d3 ef                	shr    %cl,%edi
  803963:	09 c7                	or     %eax,%edi
  803965:	89 e9                	mov    %ebp,%ecx
  803967:	d3 e2                	shl    %cl,%edx
  803969:	89 14 24             	mov    %edx,(%esp)
  80396c:	89 d8                	mov    %ebx,%eax
  80396e:	d3 e0                	shl    %cl,%eax
  803970:	89 c2                	mov    %eax,%edx
  803972:	8b 44 24 08          	mov    0x8(%esp),%eax
  803976:	d3 e0                	shl    %cl,%eax
  803978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80397c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803980:	89 f1                	mov    %esi,%ecx
  803982:	d3 e8                	shr    %cl,%eax
  803984:	09 d0                	or     %edx,%eax
  803986:	d3 eb                	shr    %cl,%ebx
  803988:	89 da                	mov    %ebx,%edx
  80398a:	f7 f7                	div    %edi
  80398c:	89 d3                	mov    %edx,%ebx
  80398e:	f7 24 24             	mull   (%esp)
  803991:	89 c6                	mov    %eax,%esi
  803993:	89 d1                	mov    %edx,%ecx
  803995:	39 d3                	cmp    %edx,%ebx
  803997:	0f 82 87 00 00 00    	jb     803a24 <__umoddi3+0x134>
  80399d:	0f 84 91 00 00 00    	je     803a34 <__umoddi3+0x144>
  8039a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039a7:	29 f2                	sub    %esi,%edx
  8039a9:	19 cb                	sbb    %ecx,%ebx
  8039ab:	89 d8                	mov    %ebx,%eax
  8039ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039b1:	d3 e0                	shl    %cl,%eax
  8039b3:	89 e9                	mov    %ebp,%ecx
  8039b5:	d3 ea                	shr    %cl,%edx
  8039b7:	09 d0                	or     %edx,%eax
  8039b9:	89 e9                	mov    %ebp,%ecx
  8039bb:	d3 eb                	shr    %cl,%ebx
  8039bd:	89 da                	mov    %ebx,%edx
  8039bf:	83 c4 1c             	add    $0x1c,%esp
  8039c2:	5b                   	pop    %ebx
  8039c3:	5e                   	pop    %esi
  8039c4:	5f                   	pop    %edi
  8039c5:	5d                   	pop    %ebp
  8039c6:	c3                   	ret    
  8039c7:	90                   	nop
  8039c8:	89 fd                	mov    %edi,%ebp
  8039ca:	85 ff                	test   %edi,%edi
  8039cc:	75 0b                	jne    8039d9 <__umoddi3+0xe9>
  8039ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8039d3:	31 d2                	xor    %edx,%edx
  8039d5:	f7 f7                	div    %edi
  8039d7:	89 c5                	mov    %eax,%ebp
  8039d9:	89 f0                	mov    %esi,%eax
  8039db:	31 d2                	xor    %edx,%edx
  8039dd:	f7 f5                	div    %ebp
  8039df:	89 c8                	mov    %ecx,%eax
  8039e1:	f7 f5                	div    %ebp
  8039e3:	89 d0                	mov    %edx,%eax
  8039e5:	e9 44 ff ff ff       	jmp    80392e <__umoddi3+0x3e>
  8039ea:	66 90                	xchg   %ax,%ax
  8039ec:	89 c8                	mov    %ecx,%eax
  8039ee:	89 f2                	mov    %esi,%edx
  8039f0:	83 c4 1c             	add    $0x1c,%esp
  8039f3:	5b                   	pop    %ebx
  8039f4:	5e                   	pop    %esi
  8039f5:	5f                   	pop    %edi
  8039f6:	5d                   	pop    %ebp
  8039f7:	c3                   	ret    
  8039f8:	3b 04 24             	cmp    (%esp),%eax
  8039fb:	72 06                	jb     803a03 <__umoddi3+0x113>
  8039fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a01:	77 0f                	ja     803a12 <__umoddi3+0x122>
  803a03:	89 f2                	mov    %esi,%edx
  803a05:	29 f9                	sub    %edi,%ecx
  803a07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a0b:	89 14 24             	mov    %edx,(%esp)
  803a0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a12:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a16:	8b 14 24             	mov    (%esp),%edx
  803a19:	83 c4 1c             	add    $0x1c,%esp
  803a1c:	5b                   	pop    %ebx
  803a1d:	5e                   	pop    %esi
  803a1e:	5f                   	pop    %edi
  803a1f:	5d                   	pop    %ebp
  803a20:	c3                   	ret    
  803a21:	8d 76 00             	lea    0x0(%esi),%esi
  803a24:	2b 04 24             	sub    (%esp),%eax
  803a27:	19 fa                	sbb    %edi,%edx
  803a29:	89 d1                	mov    %edx,%ecx
  803a2b:	89 c6                	mov    %eax,%esi
  803a2d:	e9 71 ff ff ff       	jmp    8039a3 <__umoddi3+0xb3>
  803a32:	66 90                	xchg   %ax,%ax
  803a34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a38:	72 ea                	jb     803a24 <__umoddi3+0x134>
  803a3a:	89 d9                	mov    %ebx,%ecx
  803a3c:	e9 62 ff ff ff       	jmp    8039a3 <__umoddi3+0xb3>
