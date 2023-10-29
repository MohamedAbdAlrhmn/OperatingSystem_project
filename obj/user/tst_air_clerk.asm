
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
  800044:	e8 62 20 00 00       	call   8020ab <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 15 3c 80 00       	mov    $0x803c15,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 1f 3c 80 00       	mov    $0x803c1f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 2b 3c 80 00       	mov    $0x803c2b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 3a 3c 80 00       	mov    $0x803c3a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 49 3c 80 00       	mov    $0x803c49,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 5e 3c 80 00       	mov    $0x803c5e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 73 3c 80 00       	mov    $0x803c73,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 84 3c 80 00       	mov    $0x803c84,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 95 3c 80 00       	mov    $0x803c95,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb a6 3c 80 00       	mov    $0x803ca6,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb af 3c 80 00       	mov    $0x803caf,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb b9 3c 80 00       	mov    $0x803cb9,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb c4 3c 80 00       	mov    $0x803cc4,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb d0 3c 80 00       	mov    $0x803cd0,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb da 3c 80 00       	mov    $0x803cda,%ebx
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
  8001c1:	bb e4 3c 80 00       	mov    $0x803ce4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb f2 3c 80 00       	mov    $0x803cf2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 01 3d 80 00       	mov    $0x803d01,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 08 3d 80 00       	mov    $0x803d08,%ebx
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
  800225:	e8 64 19 00 00       	call   801b8e <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 4f 19 00 00       	call   801b8e <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 3a 19 00 00       	call   801b8e <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 22 19 00 00       	call   801b8e <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 0a 19 00 00       	call   801b8e <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 f2 18 00 00       	call   801b8e <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 da 18 00 00       	call   801b8e <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 c2 18 00 00       	call   801b8e <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 aa 18 00 00       	call   801b8e <sget>
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
  8002f7:	e8 50 1c 00 00       	call   801f4c <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 3b 1c 00 00       	call   801f4c <sys_waitSemaphore>
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
  800344:	e8 21 1c 00 00       	call   801f6a <sys_signalSemaphore>
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
  80038b:	e8 bc 1b 00 00       	call   801f4c <sys_waitSemaphore>
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
  8003ef:	e8 76 1b 00 00       	call   801f6a <sys_signalSemaphore>
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
  800409:	e8 3e 1b 00 00       	call   801f4c <sys_waitSemaphore>
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
  80046d:	e8 f8 1a 00 00       	call   801f6a <sys_signalSemaphore>
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
  800487:	e8 c0 1a 00 00       	call   801f4c <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 ab 1a 00 00       	call   801f4c <sys_waitSemaphore>
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
  800557:	e8 0e 1a 00 00       	call   801f6a <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 f9 19 00 00       	call   801f6a <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 e0 3b 80 00       	push   $0x803be0
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 00 3c 80 00       	push   $0x803c00
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb 0f 3d 80 00       	mov    $0x803d0f,%ebx
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
  8005fb:	e8 6a 19 00 00       	call   801f6a <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 55 19 00 00       	call   801f6a <sys_signalSemaphore>
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
  800623:	e8 6a 1a 00 00       	call   802092 <sys_getenvindex>
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
  80068e:	e8 0c 18 00 00       	call   801e9f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 48 3d 80 00       	push   $0x803d48
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
  8006be:	68 70 3d 80 00       	push   $0x803d70
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
  8006ef:	68 98 3d 80 00       	push   $0x803d98
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 f0 3d 80 00       	push   $0x803df0
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 48 3d 80 00       	push   $0x803d48
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 8c 17 00 00       	call   801eb9 <sys_enable_interrupt>

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
  800740:	e8 19 19 00 00       	call   80205e <sys_destroy_env>
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
  800751:	e8 6e 19 00 00       	call   8020c4 <sys_exit_env>
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
  80077a:	68 04 3e 80 00       	push   $0x803e04
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 09 3e 80 00       	push   $0x803e09
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
  8007b7:	68 25 3e 80 00       	push   $0x803e25
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
  8007e3:	68 28 3e 80 00       	push   $0x803e28
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 74 3e 80 00       	push   $0x803e74
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
  8008b5:	68 80 3e 80 00       	push   $0x803e80
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 74 3e 80 00       	push   $0x803e74
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
  800925:	68 d4 3e 80 00       	push   $0x803ed4
  80092a:	6a 44                	push   $0x44
  80092c:	68 74 3e 80 00       	push   $0x803e74
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
  80097f:	e8 6d 13 00 00       	call   801cf1 <sys_cputs>
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
  8009f6:	e8 f6 12 00 00       	call   801cf1 <sys_cputs>
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
  800a40:	e8 5a 14 00 00       	call   801e9f <sys_disable_interrupt>
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
  800a60:	e8 54 14 00 00       	call   801eb9 <sys_enable_interrupt>
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
  800aaa:	e8 c5 2e 00 00       	call   803974 <__udivdi3>
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
  800afa:	e8 85 2f 00 00       	call   803a84 <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 34 41 80 00       	add    $0x804134,%eax
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
  800c55:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
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
  800d36:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 45 41 80 00       	push   $0x804145
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
  800d5b:	68 4e 41 80 00       	push   $0x80414e
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
  800d88:	be 51 41 80 00       	mov    $0x804151,%esi
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
  8017ae:	68 b0 42 80 00       	push   $0x8042b0
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
  80187e:	e8 b2 05 00 00       	call   801e35 <sys_allocate_chunk>
  801883:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801886:	a1 20 51 80 00       	mov    0x805120,%eax
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	50                   	push   %eax
  80188f:	e8 27 0c 00 00       	call   8024bb <initialize_MemBlocksList>
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
  8018bc:	68 d5 42 80 00       	push   $0x8042d5
  8018c1:	6a 33                	push   $0x33
  8018c3:	68 f3 42 80 00       	push   $0x8042f3
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
  80193b:	68 00 43 80 00       	push   $0x804300
  801940:	6a 34                	push   $0x34
  801942:	68 f3 42 80 00       	push   $0x8042f3
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
  8019d3:	e8 2b 08 00 00       	call   802203 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	74 11                	je     8019ed <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8019dc:	83 ec 0c             	sub    $0xc,%esp
  8019df:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e2:	e8 96 0e 00 00       	call   80287d <alloc_block_FF>
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
  8019f9:	e8 f2 0b 00 00       	call   8025f0 <insert_sorted_allocList>
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
  801a13:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	83 ec 08             	sub    $0x8,%esp
  801a1c:	50                   	push   %eax
  801a1d:	68 40 50 80 00       	push   $0x805040
  801a22:	e8 71 0b 00 00       	call   802598 <find_block>
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801a2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a31:	0f 84 a6 00 00 00    	je     801add <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3a:	8b 50 0c             	mov    0xc(%eax),%edx
  801a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a40:	8b 40 08             	mov    0x8(%eax),%eax
  801a43:	83 ec 08             	sub    $0x8,%esp
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	e8 b0 03 00 00       	call   801dfd <sys_free_user_mem>
  801a4d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a54:	75 14                	jne    801a6a <free+0x5a>
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	68 d5 42 80 00       	push   $0x8042d5
  801a5e:	6a 74                	push   $0x74
  801a60:	68 f3 42 80 00       	push   $0x8042f3
  801a65:	e8 ef ec ff ff       	call   800759 <_panic>
  801a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6d:	8b 00                	mov    (%eax),%eax
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	74 10                	je     801a83 <free+0x73>
  801a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a76:	8b 00                	mov    (%eax),%eax
  801a78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7b:	8b 52 04             	mov    0x4(%edx),%edx
  801a7e:	89 50 04             	mov    %edx,0x4(%eax)
  801a81:	eb 0b                	jmp    801a8e <free+0x7e>
  801a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a86:	8b 40 04             	mov    0x4(%eax),%eax
  801a89:	a3 44 50 80 00       	mov    %eax,0x805044
  801a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a91:	8b 40 04             	mov    0x4(%eax),%eax
  801a94:	85 c0                	test   %eax,%eax
  801a96:	74 0f                	je     801aa7 <free+0x97>
  801a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9b:	8b 40 04             	mov    0x4(%eax),%eax
  801a9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa1:	8b 12                	mov    (%edx),%edx
  801aa3:	89 10                	mov    %edx,(%eax)
  801aa5:	eb 0a                	jmp    801ab1 <free+0xa1>
  801aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaa:	8b 00                	mov    (%eax),%eax
  801aac:	a3 40 50 80 00       	mov    %eax,0x805040
  801ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ac4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ac9:	48                   	dec    %eax
  801aca:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801acf:	83 ec 0c             	sub    $0xc,%esp
  801ad2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad5:	e8 4e 17 00 00       	call   803228 <insert_sorted_with_merge_freeList>
  801ada:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	83 ec 08             	sub    $0x8,%esp
  801a1c:	50                   	push   %eax
  801a1d:	68 40 50 80 00       	push   $0x805040
  801a22:	e8 71 0b 00 00       	call   802598 <find_block>
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  801a2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a31:	0f 84 a6 00 00 00    	je     801add <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  801a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3a:	8b 50 0c             	mov    0xc(%eax),%edx
  801a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a40:	8b 40 08             	mov    0x8(%eax),%eax
  801a43:	83 ec 08             	sub    $0x8,%esp
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	e8 b0 03 00 00       	call   801dfd <sys_free_user_mem>
  801a4d:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  801a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a54:	75 14                	jne    801a6a <free+0x5a>
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	68 d5 42 80 00       	push   $0x8042d5
  801a5e:	6a 7a                	push   $0x7a
  801a60:	68 f3 42 80 00       	push   $0x8042f3
  801a65:	e8 ef ec ff ff       	call   800759 <_panic>
  801a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6d:	8b 00                	mov    (%eax),%eax
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	74 10                	je     801a83 <free+0x73>
  801a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a76:	8b 00                	mov    (%eax),%eax
  801a78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7b:	8b 52 04             	mov    0x4(%edx),%edx
  801a7e:	89 50 04             	mov    %edx,0x4(%eax)
  801a81:	eb 0b                	jmp    801a8e <free+0x7e>
  801a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a86:	8b 40 04             	mov    0x4(%eax),%eax
  801a89:	a3 44 50 80 00       	mov    %eax,0x805044
  801a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a91:	8b 40 04             	mov    0x4(%eax),%eax
  801a94:	85 c0                	test   %eax,%eax
  801a96:	74 0f                	je     801aa7 <free+0x97>
  801a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9b:	8b 40 04             	mov    0x4(%eax),%eax
  801a9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa1:	8b 12                	mov    (%edx),%edx
  801aa3:	89 10                	mov    %edx,(%eax)
  801aa5:	eb 0a                	jmp    801ab1 <free+0xa1>
  801aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaa:	8b 00                	mov    (%eax),%eax
  801aac:	a3 40 50 80 00       	mov    %eax,0x805040
  801ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ac4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ac9:	48                   	dec    %eax
  801aca:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  801acf:	83 ec 0c             	sub    $0xc,%esp
  801ad2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad5:	e8 4e 17 00 00       	call   803228 <insert_sorted_with_merge_freeList>
  801ada:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 38             	sub    $0x38,%esp
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aec:	e8 a6 fc ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801af1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801af5:	75 0a                	jne    801b01 <smalloc+0x21>
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	e9 8b 00 00 00       	jmp    801b8c <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b01:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0e:	01 d0                	add    %edx,%eax
  801b10:	48                   	dec    %eax
  801b11:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1c:	f7 75 f0             	divl   -0x10(%ebp)
  801b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b22:	29 d0                	sub    %edx,%eax
  801b24:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801b27:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b2e:	e8 d0 06 00 00       	call   802203 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b33:	85 c0                	test   %eax,%eax
  801b35:	74 11                	je     801b48 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801b37:	83 ec 0c             	sub    $0xc,%esp
  801b3a:	ff 75 e8             	pushl  -0x18(%ebp)
  801b3d:	e8 3b 0d 00 00       	call   80287d <alloc_block_FF>
  801b42:	83 c4 10             	add    $0x10,%esp
  801b45:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801b48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b4c:	74 39                	je     801b87 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b51:	8b 40 08             	mov    0x8(%eax),%eax
  801b54:	89 c2                	mov    %eax,%edx
  801b56:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	ff 75 0c             	pushl  0xc(%ebp)
  801b5f:	ff 75 08             	pushl  0x8(%ebp)
  801b62:	e8 21 04 00 00       	call   801f88 <sys_createSharedObject>
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801b6d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801b71:	74 14                	je     801b87 <smalloc+0xa7>
  801b73:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801b77:	74 0e                	je     801b87 <smalloc+0xa7>
  801b79:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801b7d:	74 08                	je     801b87 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b82:	8b 40 08             	mov    0x8(%eax),%eax
  801b85:	eb 05                	jmp    801b8c <smalloc+0xac>
	}
	return NULL;
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b94:	e8 fe fb ff ff       	call   801797 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	e8 0b 04 00 00       	call   801fb2 <sys_getSizeOfSharedObject>
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801bad:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801bb1:	74 76                	je     801c29 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801bb3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc0:	01 d0                	add    %edx,%eax
  801bc2:	48                   	dec    %eax
  801bc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bc9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bce:	f7 75 ec             	divl   -0x14(%ebp)
  801bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bd4:	29 d0                	sub    %edx,%eax
  801bd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801bd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801be0:	e8 1e 06 00 00       	call   802203 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801be5:	85 c0                	test   %eax,%eax
  801be7:	74 11                	je     801bfa <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801be9:	83 ec 0c             	sub    $0xc,%esp
  801bec:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bef:	e8 89 0c 00 00       	call   80287d <alloc_block_FF>
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801bfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bfe:	74 29                	je     801c29 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c03:	8b 40 08             	mov    0x8(%eax),%eax
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	50                   	push   %eax
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	ff 75 08             	pushl  0x8(%ebp)
  801c10:	e8 ba 03 00 00       	call   801fcf <sys_getSharedObject>
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801c1b:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801c1f:	74 08                	je     801c29 <sget+0x9b>
				return (void *)mem_block->sva;
  801c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c24:	8b 40 08             	mov    0x8(%eax),%eax
  801c27:	eb 05                	jmp    801c2e <sget+0xa0>
		}
	}
	return NULL;
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c36:	e8 5c fb ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c3b:	83 ec 04             	sub    $0x4,%esp
  801c3e:	68 24 43 80 00       	push   $0x804324
<<<<<<< HEAD
  801c43:	68 fc 00 00 00       	push   $0xfc
=======
  801c43:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801c48:	68 f3 42 80 00       	push   $0x8042f3
  801c4d:	e8 07 eb ff ff       	call   800759 <_panic>

00801c52 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c58:	83 ec 04             	sub    $0x4,%esp
  801c5b:	68 4c 43 80 00       	push   $0x80434c
<<<<<<< HEAD
  801c60:	68 10 01 00 00       	push   $0x110
=======
  801c60:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801c65:	68 f3 42 80 00       	push   $0x8042f3
  801c6a:	e8 ea ea ff ff       	call   800759 <_panic>

00801c6f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c75:	83 ec 04             	sub    $0x4,%esp
  801c78:	68 70 43 80 00       	push   $0x804370
<<<<<<< HEAD
  801c7d:	68 1b 01 00 00       	push   $0x11b
=======
  801c7d:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801c82:	68 f3 42 80 00       	push   $0x8042f3
  801c87:	e8 cd ea ff ff       	call   800759 <_panic>

00801c8c <shrink>:

}
void shrink(uint32 newSize)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c92:	83 ec 04             	sub    $0x4,%esp
  801c95:	68 70 43 80 00       	push   $0x804370
<<<<<<< HEAD
  801c9a:	68 20 01 00 00       	push   $0x120
=======
  801c9a:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801c9f:	68 f3 42 80 00       	push   $0x8042f3
  801ca4:	e8 b0 ea ff ff       	call   800759 <_panic>

00801ca9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801caf:	83 ec 04             	sub    $0x4,%esp
  801cb2:	68 70 43 80 00       	push   $0x804370
<<<<<<< HEAD
  801cb7:	68 25 01 00 00       	push   $0x125
=======
  801cb7:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801cbc:	68 f3 42 80 00       	push   $0x8042f3
  801cc1:	e8 93 ea ff ff       	call   800759 <_panic>

00801cc6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	57                   	push   %edi
  801cca:	56                   	push   %esi
  801ccb:	53                   	push   %ebx
  801ccc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cdb:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cde:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ce1:	cd 30                	int    $0x30
  801ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	5b                   	pop    %ebx
  801ced:	5e                   	pop    %esi
  801cee:	5f                   	pop    %edi
  801cef:	5d                   	pop    %ebp
  801cf0:	c3                   	ret    

00801cf1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 04             	sub    $0x4,%esp
  801cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cfd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	52                   	push   %edx
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	50                   	push   %eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	e8 b2 ff ff ff       	call   801cc6 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	90                   	nop
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_cgetc>:

int
sys_cgetc(void)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 01                	push   $0x1
  801d29:	e8 98 ff ff ff       	call   801cc6 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	52                   	push   %edx
  801d43:	50                   	push   %eax
  801d44:	6a 05                	push   $0x5
  801d46:	e8 7b ff ff ff       	call   801cc6 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	56                   	push   %esi
  801d54:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d55:	8b 75 18             	mov    0x18(%ebp),%esi
  801d58:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	56                   	push   %esi
  801d65:	53                   	push   %ebx
  801d66:	51                   	push   %ecx
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	6a 06                	push   $0x6
  801d6b:	e8 56 ff ff ff       	call   801cc6 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d76:	5b                   	pop    %ebx
  801d77:	5e                   	pop    %esi
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    

00801d7a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 07                	push   $0x7
  801d8d:	e8 34 ff ff ff       	call   801cc6 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	ff 75 08             	pushl  0x8(%ebp)
  801da6:	6a 08                	push   $0x8
  801da8:	e8 19 ff ff ff       	call   801cc6 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 09                	push   $0x9
  801dc1:	e8 00 ff ff ff       	call   801cc6 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 0a                	push   $0xa
  801dda:	e8 e7 fe ff ff       	call   801cc6 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 0b                	push   $0xb
  801df3:	e8 ce fe ff ff       	call   801cc6 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	ff 75 0c             	pushl  0xc(%ebp)
  801e09:	ff 75 08             	pushl  0x8(%ebp)
  801e0c:	6a 0f                	push   $0xf
  801e0e:	e8 b3 fe ff ff       	call   801cc6 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
	return;
  801e16:	90                   	nop
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	ff 75 0c             	pushl  0xc(%ebp)
  801e25:	ff 75 08             	pushl  0x8(%ebp)
  801e28:	6a 10                	push   $0x10
  801e2a:	e8 97 fe ff ff       	call   801cc6 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e32:	90                   	nop
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	ff 75 10             	pushl  0x10(%ebp)
  801e3f:	ff 75 0c             	pushl  0xc(%ebp)
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	6a 11                	push   $0x11
  801e47:	e8 7a fe ff ff       	call   801cc6 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4f:	90                   	nop
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 0c                	push   $0xc
  801e61:	e8 60 fe ff ff       	call   801cc6 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	ff 75 08             	pushl  0x8(%ebp)
  801e79:	6a 0d                	push   $0xd
  801e7b:	e8 46 fe ff ff       	call   801cc6 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 0e                	push   $0xe
  801e94:	e8 2d fe ff ff       	call   801cc6 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
}
  801e9c:	90                   	nop
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 13                	push   $0x13
  801eae:	e8 13 fe ff ff       	call   801cc6 <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
}
  801eb6:	90                   	nop
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 14                	push   $0x14
  801ec8:	e8 f9 fd ff ff       	call   801cc6 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	90                   	nop
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 04             	sub    $0x4,%esp
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801edf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	50                   	push   %eax
  801eec:	6a 15                	push   $0x15
  801eee:	e8 d3 fd ff ff       	call   801cc6 <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
}
  801ef6:	90                   	nop
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 16                	push   $0x16
  801f08:	e8 b9 fd ff ff       	call   801cc6 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	90                   	nop
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	ff 75 0c             	pushl  0xc(%ebp)
  801f22:	50                   	push   %eax
  801f23:	6a 17                	push   $0x17
  801f25:	e8 9c fd ff ff       	call   801cc6 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	52                   	push   %edx
  801f3f:	50                   	push   %eax
  801f40:	6a 1a                	push   $0x1a
  801f42:	e8 7f fd ff ff       	call   801cc6 <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	52                   	push   %edx
  801f5c:	50                   	push   %eax
  801f5d:	6a 18                	push   $0x18
  801f5f:	e8 62 fd ff ff       	call   801cc6 <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
}
  801f67:	90                   	nop
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	52                   	push   %edx
  801f7a:	50                   	push   %eax
  801f7b:	6a 19                	push   $0x19
  801f7d:	e8 44 fd ff ff       	call   801cc6 <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
}
  801f85:	90                   	nop
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 04             	sub    $0x4,%esp
  801f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f91:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f94:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f97:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	6a 00                	push   $0x0
  801fa0:	51                   	push   %ecx
  801fa1:	52                   	push   %edx
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	50                   	push   %eax
  801fa6:	6a 1b                	push   $0x1b
  801fa8:	e8 19 fd ff ff       	call   801cc6 <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	52                   	push   %edx
  801fc2:	50                   	push   %eax
  801fc3:	6a 1c                	push   $0x1c
  801fc5:	e8 fc fc ff ff       	call   801cc6 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	51                   	push   %ecx
  801fe0:	52                   	push   %edx
  801fe1:	50                   	push   %eax
  801fe2:	6a 1d                	push   $0x1d
  801fe4:	e8 dd fc ff ff       	call   801cc6 <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ff1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	52                   	push   %edx
  801ffe:	50                   	push   %eax
  801fff:	6a 1e                	push   $0x1e
  802001:	e8 c0 fc ff ff       	call   801cc6 <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 1f                	push   $0x1f
  80201a:	e8 a7 fc ff ff       	call   801cc6 <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	6a 00                	push   $0x0
  80202c:	ff 75 14             	pushl  0x14(%ebp)
  80202f:	ff 75 10             	pushl  0x10(%ebp)
  802032:	ff 75 0c             	pushl  0xc(%ebp)
  802035:	50                   	push   %eax
  802036:	6a 20                	push   $0x20
  802038:	e8 89 fc ff ff       	call   801cc6 <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	50                   	push   %eax
  802051:	6a 21                	push   $0x21
  802053:	e8 6e fc ff ff       	call   801cc6 <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
}
  80205b:	90                   	nop
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	50                   	push   %eax
  80206d:	6a 22                	push   $0x22
  80206f:	e8 52 fc ff ff       	call   801cc6 <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 02                	push   $0x2
  802088:	e8 39 fc ff ff       	call   801cc6 <syscall>
  80208d:	83 c4 18             	add    $0x18,%esp
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 03                	push   $0x3
  8020a1:	e8 20 fc ff ff       	call   801cc6 <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 04                	push   $0x4
  8020ba:	e8 07 fc ff ff       	call   801cc6 <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <sys_exit_env>:


void sys_exit_env(void)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 23                	push   $0x23
  8020d3:	e8 ee fb ff ff       	call   801cc6 <syscall>
  8020d8:	83 c4 18             	add    $0x18,%esp
}
  8020db:	90                   	nop
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e7:	8d 50 04             	lea    0x4(%eax),%edx
  8020ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	52                   	push   %edx
  8020f4:	50                   	push   %eax
  8020f5:	6a 24                	push   $0x24
  8020f7:	e8 ca fb ff ff       	call   801cc6 <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
	return result;
  8020ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802102:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802105:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802108:	89 01                	mov    %eax,(%ecx)
  80210a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	c9                   	leave  
  802111:	c2 04 00             	ret    $0x4

00802114 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	ff 75 10             	pushl  0x10(%ebp)
  80211e:	ff 75 0c             	pushl  0xc(%ebp)
  802121:	ff 75 08             	pushl  0x8(%ebp)
  802124:	6a 12                	push   $0x12
  802126:	e8 9b fb ff ff       	call   801cc6 <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
	return ;
  80212e:	90                   	nop
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_rcr2>:
uint32 sys_rcr2()
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 25                	push   $0x25
  802140:	e8 81 fb ff ff       	call   801cc6 <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 04             	sub    $0x4,%esp
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802156:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	50                   	push   %eax
  802163:	6a 26                	push   $0x26
  802165:	e8 5c fb ff ff       	call   801cc6 <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
	return ;
  80216d:	90                   	nop
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <rsttst>:
void rsttst()
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 28                	push   $0x28
  80217f:	e8 42 fb ff ff       	call   801cc6 <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
	return ;
  802187:	90                   	nop
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	83 ec 04             	sub    $0x4,%esp
  802190:	8b 45 14             	mov    0x14(%ebp),%eax
  802193:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802196:	8b 55 18             	mov    0x18(%ebp),%edx
  802199:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80219d:	52                   	push   %edx
  80219e:	50                   	push   %eax
  80219f:	ff 75 10             	pushl  0x10(%ebp)
  8021a2:	ff 75 0c             	pushl  0xc(%ebp)
  8021a5:	ff 75 08             	pushl  0x8(%ebp)
  8021a8:	6a 27                	push   $0x27
  8021aa:	e8 17 fb ff ff       	call   801cc6 <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b2:	90                   	nop
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <chktst>:
void chktst(uint32 n)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	ff 75 08             	pushl  0x8(%ebp)
  8021c3:	6a 29                	push   $0x29
  8021c5:	e8 fc fa ff ff       	call   801cc6 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cd:	90                   	nop
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <inctst>:

void inctst()
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 2a                	push   $0x2a
  8021df:	e8 e2 fa ff ff       	call   801cc6 <syscall>
  8021e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e7:	90                   	nop
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <gettst>:
uint32 gettst()
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 2b                	push   $0x2b
  8021f9:	e8 c8 fa ff ff       	call   801cc6 <syscall>
  8021fe:	83 c4 18             	add    $0x18,%esp
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 2c                	push   $0x2c
  802215:	e8 ac fa ff ff       	call   801cc6 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
  80221d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802220:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802224:	75 07                	jne    80222d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802226:	b8 01 00 00 00       	mov    $0x1,%eax
  80222b:	eb 05                	jmp    802232 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 2c                	push   $0x2c
  802246:	e8 7b fa ff ff       	call   801cc6 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
  80224e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802251:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802255:	75 07                	jne    80225e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802257:	b8 01 00 00 00       	mov    $0x1,%eax
  80225c:	eb 05                	jmp    802263 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80225e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 2c                	push   $0x2c
  802277:	e8 4a fa ff ff       	call   801cc6 <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
  80227f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802282:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802286:	75 07                	jne    80228f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802288:	b8 01 00 00 00       	mov    $0x1,%eax
  80228d:	eb 05                	jmp    802294 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 2c                	push   $0x2c
  8022a8:	e8 19 fa ff ff       	call   801cc6 <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
  8022b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022b3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022b7:	75 07                	jne    8022c0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022be:	eb 05                	jmp    8022c5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	ff 75 08             	pushl  0x8(%ebp)
  8022d5:	6a 2d                	push   $0x2d
  8022d7:	e8 ea f9 ff ff       	call   801cc6 <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8022df:	90                   	nop
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	6a 00                	push   $0x0
  8022f4:	53                   	push   %ebx
  8022f5:	51                   	push   %ecx
  8022f6:	52                   	push   %edx
  8022f7:	50                   	push   %eax
  8022f8:	6a 2e                	push   $0x2e
  8022fa:	e8 c7 f9 ff ff       	call   801cc6 <syscall>
  8022ff:	83 c4 18             	add    $0x18,%esp
}
  802302:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80230a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	52                   	push   %edx
  802317:	50                   	push   %eax
  802318:	6a 2f                	push   $0x2f
  80231a:	e8 a7 f9 ff ff       	call   801cc6 <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80232a:	83 ec 0c             	sub    $0xc,%esp
  80232d:	68 80 43 80 00       	push   $0x804380
  802332:	e8 d6 e6 ff ff       	call   800a0d <cprintf>
  802337:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80233a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802341:	83 ec 0c             	sub    $0xc,%esp
  802344:	68 ac 43 80 00       	push   $0x8043ac
  802349:	e8 bf e6 ff ff       	call   800a0d <cprintf>
  80234e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802351:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802355:	a1 38 51 80 00       	mov    0x805138,%eax
  80235a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235d:	eb 56                	jmp    8023b5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80235f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802363:	74 1c                	je     802381 <print_mem_block_lists+0x5d>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 50 08             	mov    0x8(%eax),%edx
  80236b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236e:	8b 48 08             	mov    0x8(%eax),%ecx
  802371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802374:	8b 40 0c             	mov    0xc(%eax),%eax
  802377:	01 c8                	add    %ecx,%eax
  802379:	39 c2                	cmp    %eax,%edx
  80237b:	73 04                	jae    802381 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80237d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 50 08             	mov    0x8(%eax),%edx
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 40 0c             	mov    0xc(%eax),%eax
  80238d:	01 c2                	add    %eax,%edx
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	8b 40 08             	mov    0x8(%eax),%eax
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	52                   	push   %edx
  802399:	50                   	push   %eax
  80239a:	68 c1 43 80 00       	push   $0x8043c1
  80239f:	e8 69 e6 ff ff       	call   800a0d <cprintf>
  8023a4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8023b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b9:	74 07                	je     8023c2 <print_mem_block_lists+0x9e>
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	8b 00                	mov    (%eax),%eax
  8023c0:	eb 05                	jmp    8023c7 <print_mem_block_lists+0xa3>
  8023c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c7:	a3 40 51 80 00       	mov    %eax,0x805140
  8023cc:	a1 40 51 80 00       	mov    0x805140,%eax
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	75 8a                	jne    80235f <print_mem_block_lists+0x3b>
  8023d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d9:	75 84                	jne    80235f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023db:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023df:	75 10                	jne    8023f1 <print_mem_block_lists+0xcd>
  8023e1:	83 ec 0c             	sub    $0xc,%esp
  8023e4:	68 d0 43 80 00       	push   $0x8043d0
  8023e9:	e8 1f e6 ff ff       	call   800a0d <cprintf>
  8023ee:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023f8:	83 ec 0c             	sub    $0xc,%esp
  8023fb:	68 f4 43 80 00       	push   $0x8043f4
  802400:	e8 08 e6 ff ff       	call   800a0d <cprintf>
  802405:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802408:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80240c:	a1 40 50 80 00       	mov    0x805040,%eax
  802411:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802414:	eb 56                	jmp    80246c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802416:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80241a:	74 1c                	je     802438 <print_mem_block_lists+0x114>
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	8b 50 08             	mov    0x8(%eax),%edx
  802422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802425:	8b 48 08             	mov    0x8(%eax),%ecx
  802428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242b:	8b 40 0c             	mov    0xc(%eax),%eax
  80242e:	01 c8                	add    %ecx,%eax
  802430:	39 c2                	cmp    %eax,%edx
  802432:	73 04                	jae    802438 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802434:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 50 08             	mov    0x8(%eax),%edx
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 40 0c             	mov    0xc(%eax),%eax
  802444:	01 c2                	add    %eax,%edx
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 40 08             	mov    0x8(%eax),%eax
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	52                   	push   %edx
  802450:	50                   	push   %eax
  802451:	68 c1 43 80 00       	push   $0x8043c1
  802456:	e8 b2 e5 ff ff       	call   800a0d <cprintf>
  80245b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802464:	a1 48 50 80 00       	mov    0x805048,%eax
  802469:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802470:	74 07                	je     802479 <print_mem_block_lists+0x155>
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8b 00                	mov    (%eax),%eax
  802477:	eb 05                	jmp    80247e <print_mem_block_lists+0x15a>
  802479:	b8 00 00 00 00       	mov    $0x0,%eax
  80247e:	a3 48 50 80 00       	mov    %eax,0x805048
  802483:	a1 48 50 80 00       	mov    0x805048,%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	75 8a                	jne    802416 <print_mem_block_lists+0xf2>
  80248c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802490:	75 84                	jne    802416 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802492:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802496:	75 10                	jne    8024a8 <print_mem_block_lists+0x184>
  802498:	83 ec 0c             	sub    $0xc,%esp
  80249b:	68 0c 44 80 00       	push   $0x80440c
  8024a0:	e8 68 e5 ff ff       	call   800a0d <cprintf>
  8024a5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024a8:	83 ec 0c             	sub    $0xc,%esp
  8024ab:	68 80 43 80 00       	push   $0x804380
  8024b0:	e8 58 e5 ff ff       	call   800a0d <cprintf>
  8024b5:	83 c4 10             	add    $0x10,%esp

}
  8024b8:	90                   	nop
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8024c1:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024c8:	00 00 00 
  8024cb:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024d2:	00 00 00 
  8024d5:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024dc:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8024df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024e6:	e9 9e 00 00 00       	jmp    802589 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8024eb:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f3:	c1 e2 04             	shl    $0x4,%edx
  8024f6:	01 d0                	add    %edx,%eax
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	75 14                	jne    802510 <initialize_MemBlocksList+0x55>
  8024fc:	83 ec 04             	sub    $0x4,%esp
  8024ff:	68 34 44 80 00       	push   $0x804434
  802504:	6a 46                	push   $0x46
  802506:	68 57 44 80 00       	push   $0x804457
  80250b:	e8 49 e2 ff ff       	call   800759 <_panic>
  802510:	a1 50 50 80 00       	mov    0x805050,%eax
  802515:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802518:	c1 e2 04             	shl    $0x4,%edx
  80251b:	01 d0                	add    %edx,%eax
  80251d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802523:	89 10                	mov    %edx,(%eax)
  802525:	8b 00                	mov    (%eax),%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	74 18                	je     802543 <initialize_MemBlocksList+0x88>
  80252b:	a1 48 51 80 00       	mov    0x805148,%eax
  802530:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802536:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802539:	c1 e1 04             	shl    $0x4,%ecx
  80253c:	01 ca                	add    %ecx,%edx
  80253e:	89 50 04             	mov    %edx,0x4(%eax)
  802541:	eb 12                	jmp    802555 <initialize_MemBlocksList+0x9a>
  802543:	a1 50 50 80 00       	mov    0x805050,%eax
  802548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254b:	c1 e2 04             	shl    $0x4,%edx
  80254e:	01 d0                	add    %edx,%eax
  802550:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802555:	a1 50 50 80 00       	mov    0x805050,%eax
  80255a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255d:	c1 e2 04             	shl    $0x4,%edx
  802560:	01 d0                	add    %edx,%eax
  802562:	a3 48 51 80 00       	mov    %eax,0x805148
  802567:	a1 50 50 80 00       	mov    0x805050,%eax
  80256c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256f:	c1 e2 04             	shl    $0x4,%edx
  802572:	01 d0                	add    %edx,%eax
  802574:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257b:	a1 54 51 80 00       	mov    0x805154,%eax
  802580:	40                   	inc    %eax
  802581:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802586:	ff 45 f4             	incl   -0xc(%ebp)
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80258f:	0f 82 56 ff ff ff    	jb     8024eb <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802595:	90                   	nop
  802596:	c9                   	leave  
  802597:	c3                   	ret    

00802598 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
  80259b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025a6:	eb 19                	jmp    8025c1 <find_block+0x29>
	{
		if(va==point->sva)
  8025a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ab:	8b 40 08             	mov    0x8(%eax),%eax
  8025ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025b1:	75 05                	jne    8025b8 <find_block+0x20>
		   return point;
  8025b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025b6:	eb 36                	jmp    8025ee <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	8b 40 08             	mov    0x8(%eax),%eax
  8025be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025c5:	74 07                	je     8025ce <find_block+0x36>
  8025c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ca:	8b 00                	mov    (%eax),%eax
  8025cc:	eb 05                	jmp    8025d3 <find_block+0x3b>
  8025ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d6:	89 42 08             	mov    %eax,0x8(%edx)
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	8b 40 08             	mov    0x8(%eax),%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	75 c5                	jne    8025a8 <find_block+0x10>
  8025e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025e7:	75 bf                	jne    8025a8 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8025e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8025f6:	a1 40 50 80 00       	mov    0x805040,%eax
  8025fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8025fe:	a1 44 50 80 00       	mov    0x805044,%eax
  802603:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802609:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80260c:	74 24                	je     802632 <insert_sorted_allocList+0x42>
  80260e:	8b 45 08             	mov    0x8(%ebp),%eax
  802611:	8b 50 08             	mov    0x8(%eax),%edx
  802614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802617:	8b 40 08             	mov    0x8(%eax),%eax
  80261a:	39 c2                	cmp    %eax,%edx
  80261c:	76 14                	jbe    802632 <insert_sorted_allocList+0x42>
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	8b 50 08             	mov    0x8(%eax),%edx
  802624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802627:	8b 40 08             	mov    0x8(%eax),%eax
  80262a:	39 c2                	cmp    %eax,%edx
  80262c:	0f 82 60 01 00 00    	jb     802792 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802632:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802636:	75 65                	jne    80269d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802638:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80263c:	75 14                	jne    802652 <insert_sorted_allocList+0x62>
  80263e:	83 ec 04             	sub    $0x4,%esp
  802641:	68 34 44 80 00       	push   $0x804434
  802646:	6a 6b                	push   $0x6b
  802648:	68 57 44 80 00       	push   $0x804457
  80264d:	e8 07 e1 ff ff       	call   800759 <_panic>
  802652:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802658:	8b 45 08             	mov    0x8(%ebp),%eax
  80265b:	89 10                	mov    %edx,(%eax)
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	8b 00                	mov    (%eax),%eax
  802662:	85 c0                	test   %eax,%eax
  802664:	74 0d                	je     802673 <insert_sorted_allocList+0x83>
  802666:	a1 40 50 80 00       	mov    0x805040,%eax
  80266b:	8b 55 08             	mov    0x8(%ebp),%edx
  80266e:	89 50 04             	mov    %edx,0x4(%eax)
  802671:	eb 08                	jmp    80267b <insert_sorted_allocList+0x8b>
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	a3 44 50 80 00       	mov    %eax,0x805044
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	a3 40 50 80 00       	mov    %eax,0x805040
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802692:	40                   	inc    %eax
  802693:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802698:	e9 dc 01 00 00       	jmp    802879 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	8b 50 08             	mov    0x8(%eax),%edx
  8026a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a6:	8b 40 08             	mov    0x8(%eax),%eax
  8026a9:	39 c2                	cmp    %eax,%edx
  8026ab:	77 6c                	ja     802719 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8026ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b1:	74 06                	je     8026b9 <insert_sorted_allocList+0xc9>
  8026b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026b7:	75 14                	jne    8026cd <insert_sorted_allocList+0xdd>
  8026b9:	83 ec 04             	sub    $0x4,%esp
  8026bc:	68 70 44 80 00       	push   $0x804470
  8026c1:	6a 6f                	push   $0x6f
  8026c3:	68 57 44 80 00       	push   $0x804457
  8026c8:	e8 8c e0 ff ff       	call   800759 <_panic>
  8026cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d0:	8b 50 04             	mov    0x4(%eax),%edx
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	89 50 04             	mov    %edx,0x4(%eax)
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026df:	89 10                	mov    %edx,(%eax)
  8026e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e4:	8b 40 04             	mov    0x4(%eax),%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	74 0d                	je     8026f8 <insert_sorted_allocList+0x108>
  8026eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ee:	8b 40 04             	mov    0x4(%eax),%eax
  8026f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f4:	89 10                	mov    %edx,(%eax)
  8026f6:	eb 08                	jmp    802700 <insert_sorted_allocList+0x110>
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	a3 40 50 80 00       	mov    %eax,0x805040
  802700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802703:	8b 55 08             	mov    0x8(%ebp),%edx
  802706:	89 50 04             	mov    %edx,0x4(%eax)
  802709:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80270e:	40                   	inc    %eax
  80270f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802714:	e9 60 01 00 00       	jmp    802879 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802719:	8b 45 08             	mov    0x8(%ebp),%eax
  80271c:	8b 50 08             	mov    0x8(%eax),%edx
  80271f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802722:	8b 40 08             	mov    0x8(%eax),%eax
  802725:	39 c2                	cmp    %eax,%edx
  802727:	0f 82 4c 01 00 00    	jb     802879 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80272d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802731:	75 14                	jne    802747 <insert_sorted_allocList+0x157>
  802733:	83 ec 04             	sub    $0x4,%esp
  802736:	68 a8 44 80 00       	push   $0x8044a8
  80273b:	6a 73                	push   $0x73
  80273d:	68 57 44 80 00       	push   $0x804457
  802742:	e8 12 e0 ff ff       	call   800759 <_panic>
  802747:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	89 50 04             	mov    %edx,0x4(%eax)
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	8b 40 04             	mov    0x4(%eax),%eax
  802759:	85 c0                	test   %eax,%eax
  80275b:	74 0c                	je     802769 <insert_sorted_allocList+0x179>
  80275d:	a1 44 50 80 00       	mov    0x805044,%eax
  802762:	8b 55 08             	mov    0x8(%ebp),%edx
  802765:	89 10                	mov    %edx,(%eax)
  802767:	eb 08                	jmp    802771 <insert_sorted_allocList+0x181>
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	a3 40 50 80 00       	mov    %eax,0x805040
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	a3 44 50 80 00       	mov    %eax,0x805044
  802779:	8b 45 08             	mov    0x8(%ebp),%eax
  80277c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802782:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802787:	40                   	inc    %eax
  802788:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80278d:	e9 e7 00 00 00       	jmp    802879 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802795:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802798:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80279f:	a1 40 50 80 00       	mov    0x805040,%eax
  8027a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a7:	e9 9d 00 00 00       	jmp    802849 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	8b 50 08             	mov    0x8(%eax),%edx
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	8b 40 08             	mov    0x8(%eax),%eax
  8027c0:	39 c2                	cmp    %eax,%edx
  8027c2:	76 7d                	jbe    802841 <insert_sorted_allocList+0x251>
  8027c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c7:	8b 50 08             	mov    0x8(%eax),%edx
  8027ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027cd:	8b 40 08             	mov    0x8(%eax),%eax
  8027d0:	39 c2                	cmp    %eax,%edx
  8027d2:	73 6d                	jae    802841 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8027d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d8:	74 06                	je     8027e0 <insert_sorted_allocList+0x1f0>
  8027da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027de:	75 14                	jne    8027f4 <insert_sorted_allocList+0x204>
  8027e0:	83 ec 04             	sub    $0x4,%esp
  8027e3:	68 cc 44 80 00       	push   $0x8044cc
  8027e8:	6a 7f                	push   $0x7f
  8027ea:	68 57 44 80 00       	push   $0x804457
  8027ef:	e8 65 df ff ff       	call   800759 <_panic>
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 10                	mov    (%eax),%edx
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	89 10                	mov    %edx,(%eax)
  8027fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802801:	8b 00                	mov    (%eax),%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	74 0b                	je     802812 <insert_sorted_allocList+0x222>
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	8b 55 08             	mov    0x8(%ebp),%edx
  80280f:	89 50 04             	mov    %edx,0x4(%eax)
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 55 08             	mov    0x8(%ebp),%edx
  802818:	89 10                	mov    %edx,(%eax)
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802820:	89 50 04             	mov    %edx,0x4(%eax)
  802823:	8b 45 08             	mov    0x8(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	85 c0                	test   %eax,%eax
  80282a:	75 08                	jne    802834 <insert_sorted_allocList+0x244>
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	a3 44 50 80 00       	mov    %eax,0x805044
  802834:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802839:	40                   	inc    %eax
  80283a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80283f:	eb 39                	jmp    80287a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802841:	a1 48 50 80 00       	mov    0x805048,%eax
  802846:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284d:	74 07                	je     802856 <insert_sorted_allocList+0x266>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	eb 05                	jmp    80285b <insert_sorted_allocList+0x26b>
  802856:	b8 00 00 00 00       	mov    $0x0,%eax
  80285b:	a3 48 50 80 00       	mov    %eax,0x805048
  802860:	a1 48 50 80 00       	mov    0x805048,%eax
  802865:	85 c0                	test   %eax,%eax
  802867:	0f 85 3f ff ff ff    	jne    8027ac <insert_sorted_allocList+0x1bc>
  80286d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802871:	0f 85 35 ff ff ff    	jne    8027ac <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802877:	eb 01                	jmp    80287a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802879:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80287a:	90                   	nop
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    

0080287d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
  802880:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802883:	a1 38 51 80 00       	mov    0x805138,%eax
  802888:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288b:	e9 85 01 00 00       	jmp    802a15 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 0c             	mov    0xc(%eax),%eax
  802896:	3b 45 08             	cmp    0x8(%ebp),%eax
  802899:	0f 82 6e 01 00 00    	jb     802a0d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a8:	0f 85 8a 00 00 00    	jne    802938 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8028ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b2:	75 17                	jne    8028cb <alloc_block_FF+0x4e>
  8028b4:	83 ec 04             	sub    $0x4,%esp
  8028b7:	68 00 45 80 00       	push   $0x804500
  8028bc:	68 93 00 00 00       	push   $0x93
  8028c1:	68 57 44 80 00       	push   $0x804457
  8028c6:	e8 8e de ff ff       	call   800759 <_panic>
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 00                	mov    (%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 10                	je     8028e4 <alloc_block_FF+0x67>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028dc:	8b 52 04             	mov    0x4(%edx),%edx
  8028df:	89 50 04             	mov    %edx,0x4(%eax)
  8028e2:	eb 0b                	jmp    8028ef <alloc_block_FF+0x72>
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0f                	je     802908 <alloc_block_FF+0x8b>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 40 04             	mov    0x4(%eax),%eax
  8028ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802902:	8b 12                	mov    (%edx),%edx
  802904:	89 10                	mov    %edx,(%eax)
  802906:	eb 0a                	jmp    802912 <alloc_block_FF+0x95>
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	a3 38 51 80 00       	mov    %eax,0x805138
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802925:	a1 44 51 80 00       	mov    0x805144,%eax
  80292a:	48                   	dec    %eax
  80292b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	e9 10 01 00 00       	jmp    802a48 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 40 0c             	mov    0xc(%eax),%eax
  80293e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802941:	0f 86 c6 00 00 00    	jbe    802a0d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802947:	a1 48 51 80 00       	mov    0x805148,%eax
  80294c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 50 08             	mov    0x8(%eax),%edx
  802955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802958:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80295b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295e:	8b 55 08             	mov    0x8(%ebp),%edx
  802961:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802964:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802968:	75 17                	jne    802981 <alloc_block_FF+0x104>
  80296a:	83 ec 04             	sub    $0x4,%esp
  80296d:	68 00 45 80 00       	push   $0x804500
  802972:	68 9b 00 00 00       	push   $0x9b
  802977:	68 57 44 80 00       	push   $0x804457
  80297c:	e8 d8 dd ff ff       	call   800759 <_panic>
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	74 10                	je     80299a <alloc_block_FF+0x11d>
  80298a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802992:	8b 52 04             	mov    0x4(%edx),%edx
  802995:	89 50 04             	mov    %edx,0x4(%eax)
  802998:	eb 0b                	jmp    8029a5 <alloc_block_FF+0x128>
  80299a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299d:	8b 40 04             	mov    0x4(%eax),%eax
  8029a0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	8b 40 04             	mov    0x4(%eax),%eax
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	74 0f                	je     8029be <alloc_block_FF+0x141>
  8029af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b2:	8b 40 04             	mov    0x4(%eax),%eax
  8029b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b8:	8b 12                	mov    (%edx),%edx
  8029ba:	89 10                	mov    %edx,(%eax)
  8029bc:	eb 0a                	jmp    8029c8 <alloc_block_FF+0x14b>
  8029be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029db:	a1 54 51 80 00       	mov    0x805154,%eax
  8029e0:	48                   	dec    %eax
  8029e1:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 50 08             	mov    0x8(%eax),%edx
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	01 c2                	add    %eax,%edx
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8029fd:	2b 45 08             	sub    0x8(%ebp),%eax
  802a00:	89 c2                	mov    %eax,%edx
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	eb 3b                	jmp    802a48 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a0d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a19:	74 07                	je     802a22 <alloc_block_FF+0x1a5>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	eb 05                	jmp    802a27 <alloc_block_FF+0x1aa>
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
  802a27:	a3 40 51 80 00       	mov    %eax,0x805140
  802a2c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a31:	85 c0                	test   %eax,%eax
  802a33:	0f 85 57 fe ff ff    	jne    802890 <alloc_block_FF+0x13>
  802a39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3d:	0f 85 4d fe ff ff    	jne    802890 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802a43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a48:	c9                   	leave  
  802a49:	c3                   	ret    

00802a4a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a4a:	55                   	push   %ebp
  802a4b:	89 e5                	mov    %esp,%ebp
  802a4d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802a50:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a57:	a1 38 51 80 00       	mov    0x805138,%eax
  802a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5f:	e9 df 00 00 00       	jmp    802b43 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6d:	0f 82 c8 00 00 00    	jb     802b3b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 40 0c             	mov    0xc(%eax),%eax
  802a79:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7c:	0f 85 8a 00 00 00    	jne    802b0c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a86:	75 17                	jne    802a9f <alloc_block_BF+0x55>
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	68 00 45 80 00       	push   $0x804500
  802a90:	68 b7 00 00 00       	push   $0xb7
  802a95:	68 57 44 80 00       	push   $0x804457
  802a9a:	e8 ba dc ff ff       	call   800759 <_panic>
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	85 c0                	test   %eax,%eax
  802aa6:	74 10                	je     802ab8 <alloc_block_BF+0x6e>
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 00                	mov    (%eax),%eax
  802aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab0:	8b 52 04             	mov    0x4(%edx),%edx
  802ab3:	89 50 04             	mov    %edx,0x4(%eax)
  802ab6:	eb 0b                	jmp    802ac3 <alloc_block_BF+0x79>
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 40 04             	mov    0x4(%eax),%eax
  802abe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 40 04             	mov    0x4(%eax),%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	74 0f                	je     802adc <alloc_block_BF+0x92>
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 40 04             	mov    0x4(%eax),%eax
  802ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad6:	8b 12                	mov    (%edx),%edx
  802ad8:	89 10                	mov    %edx,(%eax)
  802ada:	eb 0a                	jmp    802ae6 <alloc_block_BF+0x9c>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af9:	a1 44 51 80 00       	mov    0x805144,%eax
  802afe:	48                   	dec    %eax
  802aff:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	e9 4d 01 00 00       	jmp    802c59 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b12:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b15:	76 24                	jbe    802b3b <alloc_block_BF+0xf1>
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b20:	73 19                	jae    802b3b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802b22:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 40 08             	mov    0x8(%eax),%eax
  802b38:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b3b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b47:	74 07                	je     802b50 <alloc_block_BF+0x106>
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	eb 05                	jmp    802b55 <alloc_block_BF+0x10b>
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
  802b55:	a3 40 51 80 00       	mov    %eax,0x805140
  802b5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	0f 85 fd fe ff ff    	jne    802a64 <alloc_block_BF+0x1a>
  802b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6b:	0f 85 f3 fe ff ff    	jne    802a64 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802b71:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b75:	0f 84 d9 00 00 00    	je     802c54 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b7b:	a1 48 51 80 00       	mov    0x805148,%eax
  802b80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b89:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b92:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802b95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b99:	75 17                	jne    802bb2 <alloc_block_BF+0x168>
  802b9b:	83 ec 04             	sub    $0x4,%esp
  802b9e:	68 00 45 80 00       	push   $0x804500
  802ba3:	68 c7 00 00 00       	push   $0xc7
  802ba8:	68 57 44 80 00       	push   $0x804457
  802bad:	e8 a7 db ff ff       	call   800759 <_panic>
  802bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb5:	8b 00                	mov    (%eax),%eax
  802bb7:	85 c0                	test   %eax,%eax
  802bb9:	74 10                	je     802bcb <alloc_block_BF+0x181>
  802bbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbe:	8b 00                	mov    (%eax),%eax
  802bc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bc3:	8b 52 04             	mov    0x4(%edx),%edx
  802bc6:	89 50 04             	mov    %edx,0x4(%eax)
  802bc9:	eb 0b                	jmp    802bd6 <alloc_block_BF+0x18c>
  802bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bce:	8b 40 04             	mov    0x4(%eax),%eax
  802bd1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd9:	8b 40 04             	mov    0x4(%eax),%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	74 0f                	je     802bef <alloc_block_BF+0x1a5>
  802be0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802be9:	8b 12                	mov    (%edx),%edx
  802beb:	89 10                	mov    %edx,(%eax)
  802bed:	eb 0a                	jmp    802bf9 <alloc_block_BF+0x1af>
  802bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	a3 48 51 80 00       	mov    %eax,0x805148
  802bf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c11:	48                   	dec    %eax
  802c12:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802c17:	83 ec 08             	sub    $0x8,%esp
  802c1a:	ff 75 ec             	pushl  -0x14(%ebp)
  802c1d:	68 38 51 80 00       	push   $0x805138
  802c22:	e8 71 f9 ff ff       	call   802598 <find_block>
  802c27:	83 c4 10             	add    $0x10,%esp
  802c2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802c2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c30:	8b 50 08             	mov    0x8(%eax),%edx
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	01 c2                	add    %eax,%edx
  802c38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802c3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c41:	8b 40 0c             	mov    0xc(%eax),%eax
  802c44:	2b 45 08             	sub    0x8(%ebp),%eax
  802c47:	89 c2                	mov    %eax,%edx
  802c49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c4c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c52:	eb 05                	jmp    802c59 <alloc_block_BF+0x20f>
	}
	return NULL;
  802c54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c59:	c9                   	leave  
  802c5a:	c3                   	ret    

00802c5b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c5b:	55                   	push   %ebp
  802c5c:	89 e5                	mov    %esp,%ebp
  802c5e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802c61:	a1 28 50 80 00       	mov    0x805028,%eax
  802c66:	85 c0                	test   %eax,%eax
  802c68:	0f 85 de 01 00 00    	jne    802e4c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c6e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c76:	e9 9e 01 00 00       	jmp    802e19 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c81:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c84:	0f 82 87 01 00 00    	jb     802e11 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c93:	0f 85 95 00 00 00    	jne    802d2e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9d:	75 17                	jne    802cb6 <alloc_block_NF+0x5b>
  802c9f:	83 ec 04             	sub    $0x4,%esp
  802ca2:	68 00 45 80 00       	push   $0x804500
  802ca7:	68 e0 00 00 00       	push   $0xe0
  802cac:	68 57 44 80 00       	push   $0x804457
  802cb1:	e8 a3 da ff ff       	call   800759 <_panic>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	74 10                	je     802ccf <alloc_block_NF+0x74>
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc7:	8b 52 04             	mov    0x4(%edx),%edx
  802cca:	89 50 04             	mov    %edx,0x4(%eax)
  802ccd:	eb 0b                	jmp    802cda <alloc_block_NF+0x7f>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 0f                	je     802cf3 <alloc_block_NF+0x98>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ced:	8b 12                	mov    (%edx),%edx
  802cef:	89 10                	mov    %edx,(%eax)
  802cf1:	eb 0a                	jmp    802cfd <alloc_block_NF+0xa2>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	a3 38 51 80 00       	mov    %eax,0x805138
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d10:	a1 44 51 80 00       	mov    0x805144,%eax
  802d15:	48                   	dec    %eax
  802d16:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 40 08             	mov    0x8(%eax),%eax
  802d21:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	e9 f8 04 00 00       	jmp    803226 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 40 0c             	mov    0xc(%eax),%eax
  802d34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d37:	0f 86 d4 00 00 00    	jbe    802e11 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d3d:	a1 48 51 80 00       	mov    0x805148,%eax
  802d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 50 08             	mov    0x8(%eax),%edx
  802d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d54:	8b 55 08             	mov    0x8(%ebp),%edx
  802d57:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5e:	75 17                	jne    802d77 <alloc_block_NF+0x11c>
  802d60:	83 ec 04             	sub    $0x4,%esp
  802d63:	68 00 45 80 00       	push   $0x804500
  802d68:	68 e9 00 00 00       	push   $0xe9
  802d6d:	68 57 44 80 00       	push   $0x804457
  802d72:	e8 e2 d9 ff ff       	call   800759 <_panic>
  802d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7a:	8b 00                	mov    (%eax),%eax
  802d7c:	85 c0                	test   %eax,%eax
  802d7e:	74 10                	je     802d90 <alloc_block_NF+0x135>
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d88:	8b 52 04             	mov    0x4(%edx),%edx
  802d8b:	89 50 04             	mov    %edx,0x4(%eax)
  802d8e:	eb 0b                	jmp    802d9b <alloc_block_NF+0x140>
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9e:	8b 40 04             	mov    0x4(%eax),%eax
  802da1:	85 c0                	test   %eax,%eax
  802da3:	74 0f                	je     802db4 <alloc_block_NF+0x159>
  802da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da8:	8b 40 04             	mov    0x4(%eax),%eax
  802dab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dae:	8b 12                	mov    (%edx),%edx
  802db0:	89 10                	mov    %edx,(%eax)
  802db2:	eb 0a                	jmp    802dbe <alloc_block_NF+0x163>
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	a3 48 51 80 00       	mov    %eax,0x805148
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd1:	a1 54 51 80 00       	mov    0x805154,%eax
  802dd6:	48                   	dec    %eax
  802dd7:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	8b 40 08             	mov    0x8(%eax),%eax
  802de2:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dea:	8b 50 08             	mov    0x8(%eax),%edx
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	01 c2                	add    %eax,%edx
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfe:	2b 45 08             	sub    0x8(%ebp),%eax
  802e01:	89 c2                	mov    %eax,%edx
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	e9 15 04 00 00       	jmp    803226 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e11:	a1 40 51 80 00       	mov    0x805140,%eax
  802e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1d:	74 07                	je     802e26 <alloc_block_NF+0x1cb>
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	eb 05                	jmp    802e2b <alloc_block_NF+0x1d0>
  802e26:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2b:	a3 40 51 80 00       	mov    %eax,0x805140
  802e30:	a1 40 51 80 00       	mov    0x805140,%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	0f 85 3e fe ff ff    	jne    802c7b <alloc_block_NF+0x20>
  802e3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e41:	0f 85 34 fe ff ff    	jne    802c7b <alloc_block_NF+0x20>
  802e47:	e9 d5 03 00 00       	jmp    803221 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e4c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e54:	e9 b1 01 00 00       	jmp    80300a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 50 08             	mov    0x8(%eax),%edx
  802e5f:	a1 28 50 80 00       	mov    0x805028,%eax
  802e64:	39 c2                	cmp    %eax,%edx
  802e66:	0f 82 96 01 00 00    	jb     803002 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e72:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e75:	0f 82 87 01 00 00    	jb     803002 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e81:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e84:	0f 85 95 00 00 00    	jne    802f1f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8e:	75 17                	jne    802ea7 <alloc_block_NF+0x24c>
  802e90:	83 ec 04             	sub    $0x4,%esp
  802e93:	68 00 45 80 00       	push   $0x804500
  802e98:	68 fc 00 00 00       	push   $0xfc
  802e9d:	68 57 44 80 00       	push   $0x804457
  802ea2:	e8 b2 d8 ff ff       	call   800759 <_panic>
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	85 c0                	test   %eax,%eax
  802eae:	74 10                	je     802ec0 <alloc_block_NF+0x265>
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb8:	8b 52 04             	mov    0x4(%edx),%edx
  802ebb:	89 50 04             	mov    %edx,0x4(%eax)
  802ebe:	eb 0b                	jmp    802ecb <alloc_block_NF+0x270>
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 40 04             	mov    0x4(%eax),%eax
  802ec6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	74 0f                	je     802ee4 <alloc_block_NF+0x289>
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ede:	8b 12                	mov    (%edx),%edx
  802ee0:	89 10                	mov    %edx,(%eax)
  802ee2:	eb 0a                	jmp    802eee <alloc_block_NF+0x293>
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 00                	mov    (%eax),%eax
  802ee9:	a3 38 51 80 00       	mov    %eax,0x805138
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f01:	a1 44 51 80 00       	mov    0x805144,%eax
  802f06:	48                   	dec    %eax
  802f07:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 40 08             	mov    0x8(%eax),%eax
  802f12:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	e9 07 03 00 00       	jmp    803226 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 40 0c             	mov    0xc(%eax),%eax
  802f25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f28:	0f 86 d4 00 00 00    	jbe    803002 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f2e:	a1 48 51 80 00       	mov    0x805148,%eax
  802f33:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f39:	8b 50 08             	mov    0x8(%eax),%edx
  802f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f45:	8b 55 08             	mov    0x8(%ebp),%edx
  802f48:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f4f:	75 17                	jne    802f68 <alloc_block_NF+0x30d>
  802f51:	83 ec 04             	sub    $0x4,%esp
  802f54:	68 00 45 80 00       	push   $0x804500
  802f59:	68 04 01 00 00       	push   $0x104
  802f5e:	68 57 44 80 00       	push   $0x804457
  802f63:	e8 f1 d7 ff ff       	call   800759 <_panic>
  802f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6b:	8b 00                	mov    (%eax),%eax
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	74 10                	je     802f81 <alloc_block_NF+0x326>
  802f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f74:	8b 00                	mov    (%eax),%eax
  802f76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f79:	8b 52 04             	mov    0x4(%edx),%edx
  802f7c:	89 50 04             	mov    %edx,0x4(%eax)
  802f7f:	eb 0b                	jmp    802f8c <alloc_block_NF+0x331>
  802f81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f84:	8b 40 04             	mov    0x4(%eax),%eax
  802f87:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8f:	8b 40 04             	mov    0x4(%eax),%eax
  802f92:	85 c0                	test   %eax,%eax
  802f94:	74 0f                	je     802fa5 <alloc_block_NF+0x34a>
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	8b 40 04             	mov    0x4(%eax),%eax
  802f9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f9f:	8b 12                	mov    (%edx),%edx
  802fa1:	89 10                	mov    %edx,(%eax)
  802fa3:	eb 0a                	jmp    802faf <alloc_block_NF+0x354>
  802fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	a3 48 51 80 00       	mov    %eax,0x805148
  802faf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc2:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc7:	48                   	dec    %eax
  802fc8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802fcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd0:	8b 40 08             	mov    0x8(%eax),%eax
  802fd3:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdb:	8b 50 08             	mov    0x8(%eax),%edx
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	01 c2                	add    %eax,%edx
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 40 0c             	mov    0xc(%eax),%eax
  802fef:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff2:	89 c2                	mov    %eax,%edx
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffd:	e9 24 02 00 00       	jmp    803226 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803002:	a1 40 51 80 00       	mov    0x805140,%eax
  803007:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300e:	74 07                	je     803017 <alloc_block_NF+0x3bc>
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	eb 05                	jmp    80301c <alloc_block_NF+0x3c1>
  803017:	b8 00 00 00 00       	mov    $0x0,%eax
  80301c:	a3 40 51 80 00       	mov    %eax,0x805140
  803021:	a1 40 51 80 00       	mov    0x805140,%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	0f 85 2b fe ff ff    	jne    802e59 <alloc_block_NF+0x1fe>
  80302e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803032:	0f 85 21 fe ff ff    	jne    802e59 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803038:	a1 38 51 80 00       	mov    0x805138,%eax
  80303d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803040:	e9 ae 01 00 00       	jmp    8031f3 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	8b 50 08             	mov    0x8(%eax),%edx
  80304b:	a1 28 50 80 00       	mov    0x805028,%eax
  803050:	39 c2                	cmp    %eax,%edx
  803052:	0f 83 93 01 00 00    	jae    8031eb <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 40 0c             	mov    0xc(%eax),%eax
  80305e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803061:	0f 82 84 01 00 00    	jb     8031eb <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 40 0c             	mov    0xc(%eax),%eax
  80306d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803070:	0f 85 95 00 00 00    	jne    80310b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803076:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307a:	75 17                	jne    803093 <alloc_block_NF+0x438>
  80307c:	83 ec 04             	sub    $0x4,%esp
  80307f:	68 00 45 80 00       	push   $0x804500
  803084:	68 14 01 00 00       	push   $0x114
  803089:	68 57 44 80 00       	push   $0x804457
  80308e:	e8 c6 d6 ff ff       	call   800759 <_panic>
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	74 10                	je     8030ac <alloc_block_NF+0x451>
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 00                	mov    (%eax),%eax
  8030a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a4:	8b 52 04             	mov    0x4(%edx),%edx
  8030a7:	89 50 04             	mov    %edx,0x4(%eax)
  8030aa:	eb 0b                	jmp    8030b7 <alloc_block_NF+0x45c>
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 40 04             	mov    0x4(%eax),%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	74 0f                	je     8030d0 <alloc_block_NF+0x475>
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 40 04             	mov    0x4(%eax),%eax
  8030c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ca:	8b 12                	mov    (%edx),%edx
  8030cc:	89 10                	mov    %edx,(%eax)
  8030ce:	eb 0a                	jmp    8030da <alloc_block_NF+0x47f>
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f2:	48                   	dec    %eax
  8030f3:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 40 08             	mov    0x8(%eax),%eax
  8030fe:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	e9 1b 01 00 00       	jmp    803226 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	8b 40 0c             	mov    0xc(%eax),%eax
  803111:	3b 45 08             	cmp    0x8(%ebp),%eax
  803114:	0f 86 d1 00 00 00    	jbe    8031eb <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80311a:	a1 48 51 80 00       	mov    0x805148,%eax
  80311f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 50 08             	mov    0x8(%eax),%edx
  803128:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80312e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803131:	8b 55 08             	mov    0x8(%ebp),%edx
  803134:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803137:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80313b:	75 17                	jne    803154 <alloc_block_NF+0x4f9>
  80313d:	83 ec 04             	sub    $0x4,%esp
  803140:	68 00 45 80 00       	push   $0x804500
  803145:	68 1c 01 00 00       	push   $0x11c
  80314a:	68 57 44 80 00       	push   $0x804457
  80314f:	e8 05 d6 ff ff       	call   800759 <_panic>
  803154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803157:	8b 00                	mov    (%eax),%eax
  803159:	85 c0                	test   %eax,%eax
  80315b:	74 10                	je     80316d <alloc_block_NF+0x512>
  80315d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803165:	8b 52 04             	mov    0x4(%edx),%edx
  803168:	89 50 04             	mov    %edx,0x4(%eax)
  80316b:	eb 0b                	jmp    803178 <alloc_block_NF+0x51d>
  80316d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803170:	8b 40 04             	mov    0x4(%eax),%eax
  803173:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317b:	8b 40 04             	mov    0x4(%eax),%eax
  80317e:	85 c0                	test   %eax,%eax
  803180:	74 0f                	je     803191 <alloc_block_NF+0x536>
  803182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803185:	8b 40 04             	mov    0x4(%eax),%eax
  803188:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80318b:	8b 12                	mov    (%edx),%edx
  80318d:	89 10                	mov    %edx,(%eax)
  80318f:	eb 0a                	jmp    80319b <alloc_block_NF+0x540>
  803191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	a3 48 51 80 00       	mov    %eax,0x805148
  80319b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b3:	48                   	dec    %eax
  8031b4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031bc:	8b 40 08             	mov    0x8(%eax),%eax
  8031bf:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	01 c2                	add    %eax,%edx
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031db:	2b 45 08             	sub    0x8(%ebp),%eax
  8031de:	89 c2                	mov    %eax,%edx
  8031e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e9:	eb 3b                	jmp    803226 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031eb:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f7:	74 07                	je     803200 <alloc_block_NF+0x5a5>
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	eb 05                	jmp    803205 <alloc_block_NF+0x5aa>
  803200:	b8 00 00 00 00       	mov    $0x0,%eax
  803205:	a3 40 51 80 00       	mov    %eax,0x805140
  80320a:	a1 40 51 80 00       	mov    0x805140,%eax
  80320f:	85 c0                	test   %eax,%eax
  803211:	0f 85 2e fe ff ff    	jne    803045 <alloc_block_NF+0x3ea>
  803217:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80321b:	0f 85 24 fe ff ff    	jne    803045 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803226:	c9                   	leave  
  803227:	c3                   	ret    

00803228 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803228:	55                   	push   %ebp
  803229:	89 e5                	mov    %esp,%ebp
  80322b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80322e:	a1 38 51 80 00       	mov    0x805138,%eax
  803233:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803236:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80323b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80323e:	a1 38 51 80 00       	mov    0x805138,%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	74 14                	je     80325b <insert_sorted_with_merge_freeList+0x33>
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	8b 50 08             	mov    0x8(%eax),%edx
  80324d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803250:	8b 40 08             	mov    0x8(%eax),%eax
  803253:	39 c2                	cmp    %eax,%edx
  803255:	0f 87 9b 01 00 00    	ja     8033f6 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80325b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325f:	75 17                	jne    803278 <insert_sorted_with_merge_freeList+0x50>
  803261:	83 ec 04             	sub    $0x4,%esp
  803264:	68 34 44 80 00       	push   $0x804434
  803269:	68 38 01 00 00       	push   $0x138
  80326e:	68 57 44 80 00       	push   $0x804457
  803273:	e8 e1 d4 ff ff       	call   800759 <_panic>
  803278:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	89 10                	mov    %edx,(%eax)
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	8b 00                	mov    (%eax),%eax
  803288:	85 c0                	test   %eax,%eax
  80328a:	74 0d                	je     803299 <insert_sorted_with_merge_freeList+0x71>
  80328c:	a1 38 51 80 00       	mov    0x805138,%eax
  803291:	8b 55 08             	mov    0x8(%ebp),%edx
  803294:	89 50 04             	mov    %edx,0x4(%eax)
  803297:	eb 08                	jmp    8032a1 <insert_sorted_with_merge_freeList+0x79>
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b3:	a1 44 51 80 00       	mov    0x805144,%eax
  8032b8:	40                   	inc    %eax
  8032b9:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032c2:	0f 84 a8 06 00 00    	je     803970 <insert_sorted_with_merge_freeList+0x748>
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	8b 50 08             	mov    0x8(%eax),%edx
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d4:	01 c2                	add    %eax,%edx
  8032d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d9:	8b 40 08             	mov    0x8(%eax),%eax
  8032dc:	39 c2                	cmp    %eax,%edx
  8032de:	0f 85 8c 06 00 00    	jne    803970 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f0:	01 c2                	add    %eax,%edx
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8032f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032fc:	75 17                	jne    803315 <insert_sorted_with_merge_freeList+0xed>
  8032fe:	83 ec 04             	sub    $0x4,%esp
  803301:	68 00 45 80 00       	push   $0x804500
  803306:	68 3c 01 00 00       	push   $0x13c
  80330b:	68 57 44 80 00       	push   $0x804457
  803310:	e8 44 d4 ff ff       	call   800759 <_panic>
  803315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	85 c0                	test   %eax,%eax
  80331c:	74 10                	je     80332e <insert_sorted_with_merge_freeList+0x106>
  80331e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803326:	8b 52 04             	mov    0x4(%edx),%edx
  803329:	89 50 04             	mov    %edx,0x4(%eax)
  80332c:	eb 0b                	jmp    803339 <insert_sorted_with_merge_freeList+0x111>
  80332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803331:	8b 40 04             	mov    0x4(%eax),%eax
  803334:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333c:	8b 40 04             	mov    0x4(%eax),%eax
  80333f:	85 c0                	test   %eax,%eax
  803341:	74 0f                	je     803352 <insert_sorted_with_merge_freeList+0x12a>
  803343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803346:	8b 40 04             	mov    0x4(%eax),%eax
  803349:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80334c:	8b 12                	mov    (%edx),%edx
  80334e:	89 10                	mov    %edx,(%eax)
  803350:	eb 0a                	jmp    80335c <insert_sorted_with_merge_freeList+0x134>
  803352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803355:	8b 00                	mov    (%eax),%eax
  803357:	a3 38 51 80 00       	mov    %eax,0x805138
  80335c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803368:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336f:	a1 44 51 80 00       	mov    0x805144,%eax
  803374:	48                   	dec    %eax
  803375:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80337a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803387:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80338e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803392:	75 17                	jne    8033ab <insert_sorted_with_merge_freeList+0x183>
  803394:	83 ec 04             	sub    $0x4,%esp
  803397:	68 34 44 80 00       	push   $0x804434
  80339c:	68 3f 01 00 00       	push   $0x13f
  8033a1:	68 57 44 80 00       	push   $0x804457
  8033a6:	e8 ae d3 ff ff       	call   800759 <_panic>
  8033ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b4:	89 10                	mov    %edx,(%eax)
  8033b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b9:	8b 00                	mov    (%eax),%eax
  8033bb:	85 c0                	test   %eax,%eax
  8033bd:	74 0d                	je     8033cc <insert_sorted_with_merge_freeList+0x1a4>
  8033bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033c7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ca:	eb 08                	jmp    8033d4 <insert_sorted_with_merge_freeList+0x1ac>
  8033cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033eb:	40                   	inc    %eax
  8033ec:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033f1:	e9 7a 05 00 00       	jmp    803970 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	8b 50 08             	mov    0x8(%eax),%edx
  8033fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ff:	8b 40 08             	mov    0x8(%eax),%eax
  803402:	39 c2                	cmp    %eax,%edx
  803404:	0f 82 14 01 00 00    	jb     80351e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80340a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340d:	8b 50 08             	mov    0x8(%eax),%edx
  803410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803413:	8b 40 0c             	mov    0xc(%eax),%eax
  803416:	01 c2                	add    %eax,%edx
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	8b 40 08             	mov    0x8(%eax),%eax
  80341e:	39 c2                	cmp    %eax,%edx
  803420:	0f 85 90 00 00 00    	jne    8034b6 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803429:	8b 50 0c             	mov    0xc(%eax),%edx
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	8b 40 0c             	mov    0xc(%eax),%eax
  803432:	01 c2                	add    %eax,%edx
  803434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803437:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80344e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803452:	75 17                	jne    80346b <insert_sorted_with_merge_freeList+0x243>
  803454:	83 ec 04             	sub    $0x4,%esp
  803457:	68 34 44 80 00       	push   $0x804434
  80345c:	68 49 01 00 00       	push   $0x149
  803461:	68 57 44 80 00       	push   $0x804457
  803466:	e8 ee d2 ff ff       	call   800759 <_panic>
  80346b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803471:	8b 45 08             	mov    0x8(%ebp),%eax
  803474:	89 10                	mov    %edx,(%eax)
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	8b 00                	mov    (%eax),%eax
  80347b:	85 c0                	test   %eax,%eax
  80347d:	74 0d                	je     80348c <insert_sorted_with_merge_freeList+0x264>
  80347f:	a1 48 51 80 00       	mov    0x805148,%eax
  803484:	8b 55 08             	mov    0x8(%ebp),%edx
  803487:	89 50 04             	mov    %edx,0x4(%eax)
  80348a:	eb 08                	jmp    803494 <insert_sorted_with_merge_freeList+0x26c>
  80348c:	8b 45 08             	mov    0x8(%ebp),%eax
  80348f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803494:	8b 45 08             	mov    0x8(%ebp),%eax
  803497:	a3 48 51 80 00       	mov    %eax,0x805148
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ab:	40                   	inc    %eax
  8034ac:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034b1:	e9 bb 04 00 00       	jmp    803971 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8034b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ba:	75 17                	jne    8034d3 <insert_sorted_with_merge_freeList+0x2ab>
  8034bc:	83 ec 04             	sub    $0x4,%esp
  8034bf:	68 a8 44 80 00       	push   $0x8044a8
  8034c4:	68 4c 01 00 00       	push   $0x14c
  8034c9:	68 57 44 80 00       	push   $0x804457
  8034ce:	e8 86 d2 ff ff       	call   800759 <_panic>
  8034d3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8034d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dc:	89 50 04             	mov    %edx,0x4(%eax)
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	8b 40 04             	mov    0x4(%eax),%eax
  8034e5:	85 c0                	test   %eax,%eax
  8034e7:	74 0c                	je     8034f5 <insert_sorted_with_merge_freeList+0x2cd>
  8034e9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f1:	89 10                	mov    %edx,(%eax)
  8034f3:	eb 08                	jmp    8034fd <insert_sorted_with_merge_freeList+0x2d5>
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	a3 38 51 80 00       	mov    %eax,0x805138
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803505:	8b 45 08             	mov    0x8(%ebp),%eax
  803508:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350e:	a1 44 51 80 00       	mov    0x805144,%eax
  803513:	40                   	inc    %eax
  803514:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803519:	e9 53 04 00 00       	jmp    803971 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80351e:	a1 38 51 80 00       	mov    0x805138,%eax
  803523:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803526:	e9 15 04 00 00       	jmp    803940 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80352b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352e:	8b 00                	mov    (%eax),%eax
  803530:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	8b 50 08             	mov    0x8(%eax),%edx
  803539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353c:	8b 40 08             	mov    0x8(%eax),%eax
  80353f:	39 c2                	cmp    %eax,%edx
  803541:	0f 86 f1 03 00 00    	jbe    803938 <insert_sorted_with_merge_freeList+0x710>
  803547:	8b 45 08             	mov    0x8(%ebp),%eax
  80354a:	8b 50 08             	mov    0x8(%eax),%edx
  80354d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803550:	8b 40 08             	mov    0x8(%eax),%eax
  803553:	39 c2                	cmp    %eax,%edx
  803555:	0f 83 dd 03 00 00    	jae    803938 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	8b 50 08             	mov    0x8(%eax),%edx
  803561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803564:	8b 40 0c             	mov    0xc(%eax),%eax
  803567:	01 c2                	add    %eax,%edx
  803569:	8b 45 08             	mov    0x8(%ebp),%eax
  80356c:	8b 40 08             	mov    0x8(%eax),%eax
  80356f:	39 c2                	cmp    %eax,%edx
  803571:	0f 85 b9 01 00 00    	jne    803730 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803577:	8b 45 08             	mov    0x8(%ebp),%eax
  80357a:	8b 50 08             	mov    0x8(%eax),%edx
  80357d:	8b 45 08             	mov    0x8(%ebp),%eax
  803580:	8b 40 0c             	mov    0xc(%eax),%eax
  803583:	01 c2                	add    %eax,%edx
  803585:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803588:	8b 40 08             	mov    0x8(%eax),%eax
  80358b:	39 c2                	cmp    %eax,%edx
  80358d:	0f 85 0d 01 00 00    	jne    8036a0 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803596:	8b 50 0c             	mov    0xc(%eax),%edx
  803599:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359c:	8b 40 0c             	mov    0xc(%eax),%eax
  80359f:	01 c2                	add    %eax,%edx
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035ab:	75 17                	jne    8035c4 <insert_sorted_with_merge_freeList+0x39c>
  8035ad:	83 ec 04             	sub    $0x4,%esp
  8035b0:	68 00 45 80 00       	push   $0x804500
  8035b5:	68 5c 01 00 00       	push   $0x15c
  8035ba:	68 57 44 80 00       	push   $0x804457
  8035bf:	e8 95 d1 ff ff       	call   800759 <_panic>
  8035c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c7:	8b 00                	mov    (%eax),%eax
  8035c9:	85 c0                	test   %eax,%eax
  8035cb:	74 10                	je     8035dd <insert_sorted_with_merge_freeList+0x3b5>
  8035cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d0:	8b 00                	mov    (%eax),%eax
  8035d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035d5:	8b 52 04             	mov    0x4(%edx),%edx
  8035d8:	89 50 04             	mov    %edx,0x4(%eax)
  8035db:	eb 0b                	jmp    8035e8 <insert_sorted_with_merge_freeList+0x3c0>
  8035dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e0:	8b 40 04             	mov    0x4(%eax),%eax
  8035e3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035eb:	8b 40 04             	mov    0x4(%eax),%eax
  8035ee:	85 c0                	test   %eax,%eax
  8035f0:	74 0f                	je     803601 <insert_sorted_with_merge_freeList+0x3d9>
  8035f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f5:	8b 40 04             	mov    0x4(%eax),%eax
  8035f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035fb:	8b 12                	mov    (%edx),%edx
  8035fd:	89 10                	mov    %edx,(%eax)
  8035ff:	eb 0a                	jmp    80360b <insert_sorted_with_merge_freeList+0x3e3>
  803601:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803604:	8b 00                	mov    (%eax),%eax
  803606:	a3 38 51 80 00       	mov    %eax,0x805138
  80360b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803614:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803617:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361e:	a1 44 51 80 00       	mov    0x805144,%eax
  803623:	48                   	dec    %eax
  803624:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803629:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803633:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803636:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80363d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803641:	75 17                	jne    80365a <insert_sorted_with_merge_freeList+0x432>
  803643:	83 ec 04             	sub    $0x4,%esp
  803646:	68 34 44 80 00       	push   $0x804434
  80364b:	68 5f 01 00 00       	push   $0x15f
  803650:	68 57 44 80 00       	push   $0x804457
  803655:	e8 ff d0 ff ff       	call   800759 <_panic>
  80365a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803660:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803663:	89 10                	mov    %edx,(%eax)
  803665:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	85 c0                	test   %eax,%eax
  80366c:	74 0d                	je     80367b <insert_sorted_with_merge_freeList+0x453>
  80366e:	a1 48 51 80 00       	mov    0x805148,%eax
  803673:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803676:	89 50 04             	mov    %edx,0x4(%eax)
  803679:	eb 08                	jmp    803683 <insert_sorted_with_merge_freeList+0x45b>
  80367b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803683:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803686:	a3 48 51 80 00       	mov    %eax,0x805148
  80368b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803695:	a1 54 51 80 00       	mov    0x805154,%eax
  80369a:	40                   	inc    %eax
  80369b:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8036a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8036a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ac:	01 c2                	add    %eax,%edx
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8036be:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8036c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036cc:	75 17                	jne    8036e5 <insert_sorted_with_merge_freeList+0x4bd>
  8036ce:	83 ec 04             	sub    $0x4,%esp
  8036d1:	68 34 44 80 00       	push   $0x804434
  8036d6:	68 64 01 00 00       	push   $0x164
  8036db:	68 57 44 80 00       	push   $0x804457
  8036e0:	e8 74 d0 ff ff       	call   800759 <_panic>
  8036e5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ee:	89 10                	mov    %edx,(%eax)
  8036f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f3:	8b 00                	mov    (%eax),%eax
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	74 0d                	je     803706 <insert_sorted_with_merge_freeList+0x4de>
  8036f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8036fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803701:	89 50 04             	mov    %edx,0x4(%eax)
  803704:	eb 08                	jmp    80370e <insert_sorted_with_merge_freeList+0x4e6>
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80370e:	8b 45 08             	mov    0x8(%ebp),%eax
  803711:	a3 48 51 80 00       	mov    %eax,0x805148
  803716:	8b 45 08             	mov    0x8(%ebp),%eax
  803719:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803720:	a1 54 51 80 00       	mov    0x805154,%eax
  803725:	40                   	inc    %eax
  803726:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80372b:	e9 41 02 00 00       	jmp    803971 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	8b 50 08             	mov    0x8(%eax),%edx
  803736:	8b 45 08             	mov    0x8(%ebp),%eax
  803739:	8b 40 0c             	mov    0xc(%eax),%eax
  80373c:	01 c2                	add    %eax,%edx
  80373e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803741:	8b 40 08             	mov    0x8(%eax),%eax
  803744:	39 c2                	cmp    %eax,%edx
  803746:	0f 85 7c 01 00 00    	jne    8038c8 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80374c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803750:	74 06                	je     803758 <insert_sorted_with_merge_freeList+0x530>
  803752:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803756:	75 17                	jne    80376f <insert_sorted_with_merge_freeList+0x547>
  803758:	83 ec 04             	sub    $0x4,%esp
  80375b:	68 70 44 80 00       	push   $0x804470
  803760:	68 69 01 00 00       	push   $0x169
  803765:	68 57 44 80 00       	push   $0x804457
  80376a:	e8 ea cf ff ff       	call   800759 <_panic>
  80376f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803772:	8b 50 04             	mov    0x4(%eax),%edx
  803775:	8b 45 08             	mov    0x8(%ebp),%eax
  803778:	89 50 04             	mov    %edx,0x4(%eax)
  80377b:	8b 45 08             	mov    0x8(%ebp),%eax
  80377e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803781:	89 10                	mov    %edx,(%eax)
  803783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803786:	8b 40 04             	mov    0x4(%eax),%eax
  803789:	85 c0                	test   %eax,%eax
  80378b:	74 0d                	je     80379a <insert_sorted_with_merge_freeList+0x572>
  80378d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803790:	8b 40 04             	mov    0x4(%eax),%eax
  803793:	8b 55 08             	mov    0x8(%ebp),%edx
  803796:	89 10                	mov    %edx,(%eax)
  803798:	eb 08                	jmp    8037a2 <insert_sorted_with_merge_freeList+0x57a>
  80379a:	8b 45 08             	mov    0x8(%ebp),%eax
  80379d:	a3 38 51 80 00       	mov    %eax,0x805138
  8037a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8037a8:	89 50 04             	mov    %edx,0x4(%eax)
  8037ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8037b0:	40                   	inc    %eax
  8037b1:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8037b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b9:	8b 50 0c             	mov    0xc(%eax),%edx
  8037bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c2:	01 c2                	add    %eax,%edx
  8037c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c7:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037ce:	75 17                	jne    8037e7 <insert_sorted_with_merge_freeList+0x5bf>
  8037d0:	83 ec 04             	sub    $0x4,%esp
  8037d3:	68 00 45 80 00       	push   $0x804500
  8037d8:	68 6b 01 00 00       	push   $0x16b
  8037dd:	68 57 44 80 00       	push   $0x804457
  8037e2:	e8 72 cf ff ff       	call   800759 <_panic>
  8037e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ea:	8b 00                	mov    (%eax),%eax
  8037ec:	85 c0                	test   %eax,%eax
  8037ee:	74 10                	je     803800 <insert_sorted_with_merge_freeList+0x5d8>
  8037f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f3:	8b 00                	mov    (%eax),%eax
  8037f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037f8:	8b 52 04             	mov    0x4(%edx),%edx
  8037fb:	89 50 04             	mov    %edx,0x4(%eax)
  8037fe:	eb 0b                	jmp    80380b <insert_sorted_with_merge_freeList+0x5e3>
  803800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803803:	8b 40 04             	mov    0x4(%eax),%eax
  803806:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80380b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380e:	8b 40 04             	mov    0x4(%eax),%eax
  803811:	85 c0                	test   %eax,%eax
  803813:	74 0f                	je     803824 <insert_sorted_with_merge_freeList+0x5fc>
  803815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803818:	8b 40 04             	mov    0x4(%eax),%eax
  80381b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80381e:	8b 12                	mov    (%edx),%edx
  803820:	89 10                	mov    %edx,(%eax)
  803822:	eb 0a                	jmp    80382e <insert_sorted_with_merge_freeList+0x606>
  803824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803827:	8b 00                	mov    (%eax),%eax
  803829:	a3 38 51 80 00       	mov    %eax,0x805138
  80382e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803831:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803837:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803841:	a1 44 51 80 00       	mov    0x805144,%eax
  803846:	48                   	dec    %eax
  803847:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80384c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803856:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803859:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803860:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803864:	75 17                	jne    80387d <insert_sorted_with_merge_freeList+0x655>
  803866:	83 ec 04             	sub    $0x4,%esp
  803869:	68 34 44 80 00       	push   $0x804434
  80386e:	68 6e 01 00 00       	push   $0x16e
  803873:	68 57 44 80 00       	push   $0x804457
  803878:	e8 dc ce ff ff       	call   800759 <_panic>
  80387d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803883:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803886:	89 10                	mov    %edx,(%eax)
  803888:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388b:	8b 00                	mov    (%eax),%eax
  80388d:	85 c0                	test   %eax,%eax
  80388f:	74 0d                	je     80389e <insert_sorted_with_merge_freeList+0x676>
  803891:	a1 48 51 80 00       	mov    0x805148,%eax
  803896:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803899:	89 50 04             	mov    %edx,0x4(%eax)
  80389c:	eb 08                	jmp    8038a6 <insert_sorted_with_merge_freeList+0x67e>
  80389e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8038ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8038bd:	40                   	inc    %eax
  8038be:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038c3:	e9 a9 00 00 00       	jmp    803971 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8038c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038cc:	74 06                	je     8038d4 <insert_sorted_with_merge_freeList+0x6ac>
  8038ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038d2:	75 17                	jne    8038eb <insert_sorted_with_merge_freeList+0x6c3>
  8038d4:	83 ec 04             	sub    $0x4,%esp
  8038d7:	68 cc 44 80 00       	push   $0x8044cc
  8038dc:	68 73 01 00 00       	push   $0x173
  8038e1:	68 57 44 80 00       	push   $0x804457
  8038e6:	e8 6e ce ff ff       	call   800759 <_panic>
  8038eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ee:	8b 10                	mov    (%eax),%edx
  8038f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f3:	89 10                	mov    %edx,(%eax)
  8038f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f8:	8b 00                	mov    (%eax),%eax
  8038fa:	85 c0                	test   %eax,%eax
  8038fc:	74 0b                	je     803909 <insert_sorted_with_merge_freeList+0x6e1>
  8038fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803901:	8b 00                	mov    (%eax),%eax
  803903:	8b 55 08             	mov    0x8(%ebp),%edx
  803906:	89 50 04             	mov    %edx,0x4(%eax)
  803909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390c:	8b 55 08             	mov    0x8(%ebp),%edx
  80390f:	89 10                	mov    %edx,(%eax)
  803911:	8b 45 08             	mov    0x8(%ebp),%eax
  803914:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803917:	89 50 04             	mov    %edx,0x4(%eax)
  80391a:	8b 45 08             	mov    0x8(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	85 c0                	test   %eax,%eax
  803921:	75 08                	jne    80392b <insert_sorted_with_merge_freeList+0x703>
  803923:	8b 45 08             	mov    0x8(%ebp),%eax
  803926:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80392b:	a1 44 51 80 00       	mov    0x805144,%eax
  803930:	40                   	inc    %eax
  803931:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803936:	eb 39                	jmp    803971 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803938:	a1 40 51 80 00       	mov    0x805140,%eax
  80393d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803940:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803944:	74 07                	je     80394d <insert_sorted_with_merge_freeList+0x725>
  803946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803949:	8b 00                	mov    (%eax),%eax
  80394b:	eb 05                	jmp    803952 <insert_sorted_with_merge_freeList+0x72a>
  80394d:	b8 00 00 00 00       	mov    $0x0,%eax
  803952:	a3 40 51 80 00       	mov    %eax,0x805140
  803957:	a1 40 51 80 00       	mov    0x805140,%eax
  80395c:	85 c0                	test   %eax,%eax
  80395e:	0f 85 c7 fb ff ff    	jne    80352b <insert_sorted_with_merge_freeList+0x303>
  803964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803968:	0f 85 bd fb ff ff    	jne    80352b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80396e:	eb 01                	jmp    803971 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803970:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803971:	90                   	nop
  803972:	c9                   	leave  
  803973:	c3                   	ret    

00803974 <__udivdi3>:
  803974:	55                   	push   %ebp
  803975:	57                   	push   %edi
  803976:	56                   	push   %esi
  803977:	53                   	push   %ebx
  803978:	83 ec 1c             	sub    $0x1c,%esp
  80397b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80397f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803983:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803987:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80398b:	89 ca                	mov    %ecx,%edx
  80398d:	89 f8                	mov    %edi,%eax
  80398f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803993:	85 f6                	test   %esi,%esi
  803995:	75 2d                	jne    8039c4 <__udivdi3+0x50>
  803997:	39 cf                	cmp    %ecx,%edi
  803999:	77 65                	ja     803a00 <__udivdi3+0x8c>
  80399b:	89 fd                	mov    %edi,%ebp
  80399d:	85 ff                	test   %edi,%edi
  80399f:	75 0b                	jne    8039ac <__udivdi3+0x38>
  8039a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8039a6:	31 d2                	xor    %edx,%edx
  8039a8:	f7 f7                	div    %edi
  8039aa:	89 c5                	mov    %eax,%ebp
  8039ac:	31 d2                	xor    %edx,%edx
  8039ae:	89 c8                	mov    %ecx,%eax
  8039b0:	f7 f5                	div    %ebp
  8039b2:	89 c1                	mov    %eax,%ecx
  8039b4:	89 d8                	mov    %ebx,%eax
  8039b6:	f7 f5                	div    %ebp
  8039b8:	89 cf                	mov    %ecx,%edi
  8039ba:	89 fa                	mov    %edi,%edx
  8039bc:	83 c4 1c             	add    $0x1c,%esp
  8039bf:	5b                   	pop    %ebx
  8039c0:	5e                   	pop    %esi
  8039c1:	5f                   	pop    %edi
  8039c2:	5d                   	pop    %ebp
  8039c3:	c3                   	ret    
  8039c4:	39 ce                	cmp    %ecx,%esi
  8039c6:	77 28                	ja     8039f0 <__udivdi3+0x7c>
  8039c8:	0f bd fe             	bsr    %esi,%edi
  8039cb:	83 f7 1f             	xor    $0x1f,%edi
  8039ce:	75 40                	jne    803a10 <__udivdi3+0x9c>
  8039d0:	39 ce                	cmp    %ecx,%esi
  8039d2:	72 0a                	jb     8039de <__udivdi3+0x6a>
  8039d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039d8:	0f 87 9e 00 00 00    	ja     803a7c <__udivdi3+0x108>
  8039de:	b8 01 00 00 00       	mov    $0x1,%eax
  8039e3:	89 fa                	mov    %edi,%edx
  8039e5:	83 c4 1c             	add    $0x1c,%esp
  8039e8:	5b                   	pop    %ebx
  8039e9:	5e                   	pop    %esi
  8039ea:	5f                   	pop    %edi
  8039eb:	5d                   	pop    %ebp
  8039ec:	c3                   	ret    
  8039ed:	8d 76 00             	lea    0x0(%esi),%esi
  8039f0:	31 ff                	xor    %edi,%edi
  8039f2:	31 c0                	xor    %eax,%eax
  8039f4:	89 fa                	mov    %edi,%edx
  8039f6:	83 c4 1c             	add    $0x1c,%esp
  8039f9:	5b                   	pop    %ebx
  8039fa:	5e                   	pop    %esi
  8039fb:	5f                   	pop    %edi
  8039fc:	5d                   	pop    %ebp
  8039fd:	c3                   	ret    
  8039fe:	66 90                	xchg   %ax,%ax
  803a00:	89 d8                	mov    %ebx,%eax
  803a02:	f7 f7                	div    %edi
  803a04:	31 ff                	xor    %edi,%edi
  803a06:	89 fa                	mov    %edi,%edx
  803a08:	83 c4 1c             	add    $0x1c,%esp
  803a0b:	5b                   	pop    %ebx
  803a0c:	5e                   	pop    %esi
  803a0d:	5f                   	pop    %edi
  803a0e:	5d                   	pop    %ebp
  803a0f:	c3                   	ret    
  803a10:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a15:	89 eb                	mov    %ebp,%ebx
  803a17:	29 fb                	sub    %edi,%ebx
  803a19:	89 f9                	mov    %edi,%ecx
  803a1b:	d3 e6                	shl    %cl,%esi
  803a1d:	89 c5                	mov    %eax,%ebp
  803a1f:	88 d9                	mov    %bl,%cl
  803a21:	d3 ed                	shr    %cl,%ebp
  803a23:	89 e9                	mov    %ebp,%ecx
  803a25:	09 f1                	or     %esi,%ecx
  803a27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a2b:	89 f9                	mov    %edi,%ecx
  803a2d:	d3 e0                	shl    %cl,%eax
  803a2f:	89 c5                	mov    %eax,%ebp
  803a31:	89 d6                	mov    %edx,%esi
  803a33:	88 d9                	mov    %bl,%cl
  803a35:	d3 ee                	shr    %cl,%esi
  803a37:	89 f9                	mov    %edi,%ecx
  803a39:	d3 e2                	shl    %cl,%edx
  803a3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a3f:	88 d9                	mov    %bl,%cl
  803a41:	d3 e8                	shr    %cl,%eax
  803a43:	09 c2                	or     %eax,%edx
  803a45:	89 d0                	mov    %edx,%eax
  803a47:	89 f2                	mov    %esi,%edx
  803a49:	f7 74 24 0c          	divl   0xc(%esp)
  803a4d:	89 d6                	mov    %edx,%esi
  803a4f:	89 c3                	mov    %eax,%ebx
  803a51:	f7 e5                	mul    %ebp
  803a53:	39 d6                	cmp    %edx,%esi
  803a55:	72 19                	jb     803a70 <__udivdi3+0xfc>
  803a57:	74 0b                	je     803a64 <__udivdi3+0xf0>
  803a59:	89 d8                	mov    %ebx,%eax
  803a5b:	31 ff                	xor    %edi,%edi
  803a5d:	e9 58 ff ff ff       	jmp    8039ba <__udivdi3+0x46>
  803a62:	66 90                	xchg   %ax,%ax
  803a64:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a68:	89 f9                	mov    %edi,%ecx
  803a6a:	d3 e2                	shl    %cl,%edx
  803a6c:	39 c2                	cmp    %eax,%edx
  803a6e:	73 e9                	jae    803a59 <__udivdi3+0xe5>
  803a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a73:	31 ff                	xor    %edi,%edi
  803a75:	e9 40 ff ff ff       	jmp    8039ba <__udivdi3+0x46>
  803a7a:	66 90                	xchg   %ax,%ax
  803a7c:	31 c0                	xor    %eax,%eax
  803a7e:	e9 37 ff ff ff       	jmp    8039ba <__udivdi3+0x46>
  803a83:	90                   	nop

00803a84 <__umoddi3>:
  803a84:	55                   	push   %ebp
  803a85:	57                   	push   %edi
  803a86:	56                   	push   %esi
  803a87:	53                   	push   %ebx
  803a88:	83 ec 1c             	sub    $0x1c,%esp
  803a8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803aa3:	89 f3                	mov    %esi,%ebx
  803aa5:	89 fa                	mov    %edi,%edx
  803aa7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aab:	89 34 24             	mov    %esi,(%esp)
  803aae:	85 c0                	test   %eax,%eax
  803ab0:	75 1a                	jne    803acc <__umoddi3+0x48>
  803ab2:	39 f7                	cmp    %esi,%edi
  803ab4:	0f 86 a2 00 00 00    	jbe    803b5c <__umoddi3+0xd8>
  803aba:	89 c8                	mov    %ecx,%eax
  803abc:	89 f2                	mov    %esi,%edx
  803abe:	f7 f7                	div    %edi
  803ac0:	89 d0                	mov    %edx,%eax
  803ac2:	31 d2                	xor    %edx,%edx
  803ac4:	83 c4 1c             	add    $0x1c,%esp
  803ac7:	5b                   	pop    %ebx
  803ac8:	5e                   	pop    %esi
  803ac9:	5f                   	pop    %edi
  803aca:	5d                   	pop    %ebp
  803acb:	c3                   	ret    
  803acc:	39 f0                	cmp    %esi,%eax
  803ace:	0f 87 ac 00 00 00    	ja     803b80 <__umoddi3+0xfc>
  803ad4:	0f bd e8             	bsr    %eax,%ebp
  803ad7:	83 f5 1f             	xor    $0x1f,%ebp
  803ada:	0f 84 ac 00 00 00    	je     803b8c <__umoddi3+0x108>
  803ae0:	bf 20 00 00 00       	mov    $0x20,%edi
  803ae5:	29 ef                	sub    %ebp,%edi
  803ae7:	89 fe                	mov    %edi,%esi
  803ae9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803aed:	89 e9                	mov    %ebp,%ecx
  803aef:	d3 e0                	shl    %cl,%eax
  803af1:	89 d7                	mov    %edx,%edi
  803af3:	89 f1                	mov    %esi,%ecx
  803af5:	d3 ef                	shr    %cl,%edi
  803af7:	09 c7                	or     %eax,%edi
  803af9:	89 e9                	mov    %ebp,%ecx
  803afb:	d3 e2                	shl    %cl,%edx
  803afd:	89 14 24             	mov    %edx,(%esp)
  803b00:	89 d8                	mov    %ebx,%eax
  803b02:	d3 e0                	shl    %cl,%eax
  803b04:	89 c2                	mov    %eax,%edx
  803b06:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b0a:	d3 e0                	shl    %cl,%eax
  803b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b10:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b14:	89 f1                	mov    %esi,%ecx
  803b16:	d3 e8                	shr    %cl,%eax
  803b18:	09 d0                	or     %edx,%eax
  803b1a:	d3 eb                	shr    %cl,%ebx
  803b1c:	89 da                	mov    %ebx,%edx
  803b1e:	f7 f7                	div    %edi
  803b20:	89 d3                	mov    %edx,%ebx
  803b22:	f7 24 24             	mull   (%esp)
  803b25:	89 c6                	mov    %eax,%esi
  803b27:	89 d1                	mov    %edx,%ecx
  803b29:	39 d3                	cmp    %edx,%ebx
  803b2b:	0f 82 87 00 00 00    	jb     803bb8 <__umoddi3+0x134>
  803b31:	0f 84 91 00 00 00    	je     803bc8 <__umoddi3+0x144>
  803b37:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b3b:	29 f2                	sub    %esi,%edx
  803b3d:	19 cb                	sbb    %ecx,%ebx
  803b3f:	89 d8                	mov    %ebx,%eax
  803b41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b45:	d3 e0                	shl    %cl,%eax
  803b47:	89 e9                	mov    %ebp,%ecx
  803b49:	d3 ea                	shr    %cl,%edx
  803b4b:	09 d0                	or     %edx,%eax
  803b4d:	89 e9                	mov    %ebp,%ecx
  803b4f:	d3 eb                	shr    %cl,%ebx
  803b51:	89 da                	mov    %ebx,%edx
  803b53:	83 c4 1c             	add    $0x1c,%esp
  803b56:	5b                   	pop    %ebx
  803b57:	5e                   	pop    %esi
  803b58:	5f                   	pop    %edi
  803b59:	5d                   	pop    %ebp
  803b5a:	c3                   	ret    
  803b5b:	90                   	nop
  803b5c:	89 fd                	mov    %edi,%ebp
  803b5e:	85 ff                	test   %edi,%edi
  803b60:	75 0b                	jne    803b6d <__umoddi3+0xe9>
  803b62:	b8 01 00 00 00       	mov    $0x1,%eax
  803b67:	31 d2                	xor    %edx,%edx
  803b69:	f7 f7                	div    %edi
  803b6b:	89 c5                	mov    %eax,%ebp
  803b6d:	89 f0                	mov    %esi,%eax
  803b6f:	31 d2                	xor    %edx,%edx
  803b71:	f7 f5                	div    %ebp
  803b73:	89 c8                	mov    %ecx,%eax
  803b75:	f7 f5                	div    %ebp
  803b77:	89 d0                	mov    %edx,%eax
  803b79:	e9 44 ff ff ff       	jmp    803ac2 <__umoddi3+0x3e>
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	89 c8                	mov    %ecx,%eax
  803b82:	89 f2                	mov    %esi,%edx
  803b84:	83 c4 1c             	add    $0x1c,%esp
  803b87:	5b                   	pop    %ebx
  803b88:	5e                   	pop    %esi
  803b89:	5f                   	pop    %edi
  803b8a:	5d                   	pop    %ebp
  803b8b:	c3                   	ret    
  803b8c:	3b 04 24             	cmp    (%esp),%eax
  803b8f:	72 06                	jb     803b97 <__umoddi3+0x113>
  803b91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b95:	77 0f                	ja     803ba6 <__umoddi3+0x122>
  803b97:	89 f2                	mov    %esi,%edx
  803b99:	29 f9                	sub    %edi,%ecx
  803b9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b9f:	89 14 24             	mov    %edx,(%esp)
  803ba2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ba6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803baa:	8b 14 24             	mov    (%esp),%edx
  803bad:	83 c4 1c             	add    $0x1c,%esp
  803bb0:	5b                   	pop    %ebx
  803bb1:	5e                   	pop    %esi
  803bb2:	5f                   	pop    %edi
  803bb3:	5d                   	pop    %ebp
  803bb4:	c3                   	ret    
  803bb5:	8d 76 00             	lea    0x0(%esi),%esi
  803bb8:	2b 04 24             	sub    (%esp),%eax
  803bbb:	19 fa                	sbb    %edi,%edx
  803bbd:	89 d1                	mov    %edx,%ecx
  803bbf:	89 c6                	mov    %eax,%esi
  803bc1:	e9 71 ff ff ff       	jmp    803b37 <__umoddi3+0xb3>
  803bc6:	66 90                	xchg   %ax,%ax
  803bc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bcc:	72 ea                	jb     803bb8 <__umoddi3+0x134>
  803bce:	89 d9                	mov    %ebx,%ecx
  803bd0:	e9 62 ff ff ff       	jmp    803b37 <__umoddi3+0xb3>
