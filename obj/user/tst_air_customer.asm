
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 dc 03 00 00       	call   800412 <libmain>
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
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 77 1c 00 00       	call   801cc0 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 29 3a 80 00       	mov    $0x803a29,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 33 3a 80 00       	mov    $0x803a33,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 3f 3a 80 00       	mov    $0x803a3f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 4e 3a 80 00       	mov    $0x803a4e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 5d 3a 80 00       	mov    $0x803a5d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 72 3a 80 00       	mov    $0x803a72,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 87 3a 80 00       	mov    $0x803a87,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 98 3a 80 00       	mov    $0x803a98,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb a9 3a 80 00       	mov    $0x803aa9,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb ba 3a 80 00       	mov    $0x803aba,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb c3 3a 80 00       	mov    $0x803ac3,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb cd 3a 80 00       	mov    $0x803acd,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb d8 3a 80 00       	mov    $0x803ad8,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb e4 3a 80 00       	mov    $0x803ae4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ee 3a 80 00       	mov    $0x803aee,%ebx
  800198:	ba 0a 00 00 00       	mov    $0xa,%edx
  80019d:	89 c7                	mov    %eax,%edi
  80019f:	89 de                	mov    %ebx,%esi
  8001a1:	89 d1                	mov    %edx,%ecx
  8001a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a5:	c7 85 f7 fe ff ff 63 	movl   $0x72656c63,-0x109(%ebp)
  8001ac:	6c 65 72 
  8001af:	66 c7 85 fb fe ff ff 	movw   $0x6b,-0x105(%ebp)
  8001b6:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001b8:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8001be:	bb f8 3a 80 00       	mov    $0x803af8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 06 3b 80 00       	mov    $0x803b06,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 15 3b 80 00       	mov    $0x803b15,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 1c 3b 80 00       	mov    $0x803b1c,%ebx
  80020b:	ba 07 00 00 00       	mov    $0x7,%edx
  800210:	89 c7                	mov    %eax,%edi
  800212:	89 de                	mov    %ebx,%esi
  800214:	89 d1                	mov    %edx,%ecx
  800216:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800222:	e8 7c 15 00 00       	call   8017a3 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 67 15 00 00       	call   8017a3 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 4f 15 00 00       	call   8017a3 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 37 15 00 00       	call   8017a3 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 dd 18 00 00       	call   801b61 <sys_waitSemaphore>
  800284:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  800287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80028a:	8b 00                	mov    (%eax),%eax
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  80028f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	8d 50 01             	lea    0x1(%eax),%edx
  800297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029a:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custCounterCS);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a9:	e8 d1 18 00 00       	call   801b7f <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 9e 18 00 00       	call   801b61 <sys_waitSemaphore>
  8002c3:	83 c4 10             	add    $0x10,%esp

	//enqueue the request
	flightType = customers[custId].flightType;
  8002c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	sys_waitSemaphore(parentenvID, _custQueueCS);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	e8 75 18 00 00       	call   801b61 <sys_waitSemaphore>
  8002ec:	83 c4 10             	add    $0x10,%esp
	{
		cust_ready_queue[*queue_in] = custId;
  8002ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002fe:	01 c2                	add    %eax,%edx
  800300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800303:	89 02                	mov    %eax,(%edx)
		*queue_in = *queue_in +1;
  800305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	8d 50 01             	lea    0x1(%eax),%edx
  80030d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800310:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custQueueCS);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 5b 18 00 00       	call   801b7f <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 46 18 00 00       	call   801b7f <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb 23 3b 80 00       	mov    $0x803b23,%ebx
  800347:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	89 de                	mov    %ebx,%esi
  800350:	89 d1                	mov    %edx,%ecx
  800352:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800354:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  80035a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	89 d7                	mov    %edx,%edi
  800366:	f3 ab                	rep stos %eax,%es:(%edi)
	char id[5]; char sname[50];
	ltostr(custId, id);
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800371:	50                   	push   %eax
  800372:	ff 75 d0             	pushl  -0x30(%ebp)
  800375:	e8 d0 0d 00 00       	call   80114a <ltostr>
  80037a:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 a8 0e 00 00       	call   801242 <strcconcat>
  80039a:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(parentenvID, sname);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8003a6:	50                   	push   %eax
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	e8 b2 17 00 00       	call   801b61 <sys_waitSemaphore>
  8003af:	83 c4 10             	add    $0x10,%esp

	//print the customer status
	if(customers[custId].booked == 1)
  8003b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bf:	01 d0                	add    %edx,%eax
  8003c1:	8b 40 04             	mov    0x4(%eax),%eax
  8003c4:	83 f8 01             	cmp    $0x1,%eax
  8003c7:	75 18                	jne    8003e1 <_main+0x3a9>
	{
		cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	ff 75 cc             	pushl  -0x34(%ebp)
  8003cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d2:	68 e0 39 80 00       	push   $0x8039e0
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 08 3a 80 00       	push   $0x803a08
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 79 17 00 00       	call   801b7f <sys_signalSemaphore>
  800406:	83 c4 10             	add    $0x10,%esp

	return;
  800409:	90                   	nop
}
  80040a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80040d:	5b                   	pop    %ebx
  80040e:	5e                   	pop    %esi
  80040f:	5f                   	pop    %edi
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800418:	e8 8a 18 00 00       	call   801ca7 <sys_getenvindex>
  80041d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800435:	01 d0                	add    %edx,%eax
  800437:	c1 e0 04             	shl    $0x4,%eax
  80043a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800444:	a1 20 50 80 00       	mov    0x805020,%eax
  800449:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044f:	84 c0                	test   %al,%al
  800451:	74 0f                	je     800462 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800453:	a1 20 50 80 00       	mov    0x805020,%eax
  800458:	05 5c 05 00 00       	add    $0x55c,%eax
  80045d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800466:	7e 0a                	jle    800472 <libmain+0x60>
		binaryname = argv[0];
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	ff 75 08             	pushl  0x8(%ebp)
  80047b:	e8 b8 fb ff ff       	call   800038 <_main>
  800480:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800483:	e8 2c 16 00 00       	call   801ab4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 5c 3b 80 00       	push   $0x803b5c
  800490:	e8 8d 01 00 00       	call   800622 <cprintf>
  800495:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800498:	a1 20 50 80 00       	mov    0x805020,%eax
  80049d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8004a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004ae:	83 ec 04             	sub    $0x4,%esp
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	68 84 3b 80 00       	push   $0x803b84
  8004b8:	e8 65 01 00 00       	call   800622 <cprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8004db:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	50                   	push   %eax
  8004e4:	68 ac 3b 80 00       	push   $0x803bac
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 04 3c 80 00       	push   $0x803c04
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 5c 3b 80 00       	push   $0x803b5c
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 ac 15 00 00       	call   801ace <sys_enable_interrupt>

	// exit gracefully
	exit();
  800522:	e8 19 00 00 00       	call   800540 <exit>
}
  800527:	90                   	nop
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	6a 00                	push   $0x0
  800535:	e8 39 17 00 00       	call   801c73 <sys_destroy_env>
  80053a:	83 c4 10             	add    $0x10,%esp
}
  80053d:	90                   	nop
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <exit>:

void
exit(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800546:	e8 8e 17 00 00       	call   801cd9 <sys_exit_env>
}
  80054b:	90                   	nop
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	8d 48 01             	lea    0x1(%eax),%ecx
  80055c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055f:	89 0a                	mov    %ecx,(%edx)
  800561:	8b 55 08             	mov    0x8(%ebp),%edx
  800564:	88 d1                	mov    %dl,%cl
  800566:	8b 55 0c             	mov    0xc(%ebp),%edx
  800569:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800579:	a0 24 50 80 00       	mov    0x805024,%al
  80057e:	0f b6 c0             	movzbl %al,%eax
  800581:	8b 55 0c             	mov    0xc(%ebp),%edx
  800584:	8b 12                	mov    (%edx),%edx
  800586:	89 d1                	mov    %edx,%ecx
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	83 c2 08             	add    $0x8,%edx
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	50                   	push   %eax
  800592:	51                   	push   %ecx
  800593:	52                   	push   %edx
  800594:	e8 6d 13 00 00       	call   801906 <sys_cputs>
  800599:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	8b 40 04             	mov    0x4(%eax),%eax
  8005ab:	8d 50 01             	lea    0x1(%eax),%edx
  8005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b4:	90                   	nop
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c7:	00 00 00 
	b.cnt = 0;
  8005ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e0:	50                   	push   %eax
  8005e1:	68 4e 05 80 00       	push   $0x80054e
  8005e6:	e8 11 02 00 00       	call   8007fc <vprintfmt>
  8005eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ee:	a0 24 50 80 00       	mov    0x805024,%al
  8005f3:	0f b6 c0             	movzbl %al,%eax
  8005f6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005fc:	83 ec 04             	sub    $0x4,%esp
  8005ff:	50                   	push   %eax
  800600:	52                   	push   %edx
  800601:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800607:	83 c0 08             	add    $0x8,%eax
  80060a:	50                   	push   %eax
  80060b:	e8 f6 12 00 00       	call   801906 <sys_cputs>
  800610:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800613:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80061a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <cprintf>:

int cprintf(const char *fmt, ...) {
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800628:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80062f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800632:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 f4             	pushl  -0xc(%ebp)
  80063e:	50                   	push   %eax
  80063f:	e8 73 ff ff ff       	call   8005b7 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800655:	e8 5a 14 00 00       	call   801ab4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80065a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 f4             	pushl  -0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	e8 48 ff ff ff       	call   8005b7 <vcprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800675:	e8 54 14 00 00       	call   801ace <sys_enable_interrupt>
	return cnt;
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 14             	sub    $0x14,%esp
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800692:	8b 45 18             	mov    0x18(%ebp),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069d:	77 55                	ja     8006f4 <printnum+0x75>
  80069f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a2:	72 05                	jb     8006a9 <printnum+0x2a>
  8006a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a7:	77 4b                	ja     8006f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006af:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bf:	e8 a8 30 00 00       	call   80376c <__udivdi3>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	ff 75 20             	pushl  0x20(%ebp)
  8006cd:	53                   	push   %ebx
  8006ce:	ff 75 18             	pushl  0x18(%ebp)
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 a1 ff ff ff       	call   80067f <printnum>
  8006de:	83 c4 20             	add    $0x20,%esp
  8006e1:	eb 1a                	jmp    8006fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 20             	pushl  0x20(%ebp)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fb:	7f e6                	jg     8006e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800700:	bb 00 00 00 00       	mov    $0x0,%ebx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070b:	53                   	push   %ebx
  80070c:	51                   	push   %ecx
  80070d:	52                   	push   %edx
  80070e:	50                   	push   %eax
  80070f:	e8 68 31 00 00       	call   80387c <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 34 3e 80 00       	add    $0x803e34,%eax
  80071c:	8a 00                	mov    (%eax),%al
  80071e:	0f be c0             	movsbl %al,%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
}
  800730:	90                   	nop
  800731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800739:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073d:	7e 1c                	jle    80075b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	8d 50 08             	lea    0x8(%eax),%edx
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	89 10                	mov    %edx,(%eax)
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	83 e8 08             	sub    $0x8,%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	eb 40                	jmp    80079b <getuint+0x65>
	else if (lflag)
  80075b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075f:	74 1e                	je     80077f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 04             	lea    0x4(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	eb 1c                	jmp    80079b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 04             	lea    0x4(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 04             	sub    $0x4,%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a4:	7e 1c                	jle    8007c2 <getint+0x25>
		return va_arg(*ap, long long);
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	8d 50 08             	lea    0x8(%eax),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	89 10                	mov    %edx,(%eax)
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	83 e8 08             	sub    $0x8,%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	eb 38                	jmp    8007fa <getint+0x5d>
	else if (lflag)
  8007c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c6:	74 1a                	je     8007e2 <getint+0x45>
		return va_arg(*ap, long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 04             	lea    0x4(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	99                   	cltd   
  8007e0:	eb 18                	jmp    8007fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	89 10                	mov    %edx,(%eax)
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	99                   	cltd   
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	56                   	push   %esi
  800800:	53                   	push   %ebx
  800801:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800804:	eb 17                	jmp    80081d <vprintfmt+0x21>
			if (ch == '\0')
  800806:	85 db                	test   %ebx,%ebx
  800808:	0f 84 af 03 00 00    	je     800bbd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	53                   	push   %ebx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	8d 50 01             	lea    0x1(%eax),%edx
  800823:	89 55 10             	mov    %edx,0x10(%ebp)
  800826:	8a 00                	mov    (%eax),%al
  800828:	0f b6 d8             	movzbl %al,%ebx
  80082b:	83 fb 25             	cmp    $0x25,%ebx
  80082e:	75 d6                	jne    800806 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800830:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800834:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800842:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800849:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	89 55 10             	mov    %edx,0x10(%ebp)
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f b6 d8             	movzbl %al,%ebx
  80085e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800861:	83 f8 55             	cmp    $0x55,%eax
  800864:	0f 87 2b 03 00 00    	ja     800b95 <vprintfmt+0x399>
  80086a:	8b 04 85 58 3e 80 00 	mov    0x803e58(,%eax,4),%eax
  800871:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800873:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800877:	eb d7                	jmp    800850 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800879:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80087d:	eb d1                	jmp    800850 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	c1 e0 02             	shl    $0x2,%eax
  80088e:	01 d0                	add    %edx,%eax
  800890:	01 c0                	add    %eax,%eax
  800892:	01 d8                	add    %ebx,%eax
  800894:	83 e8 30             	sub    $0x30,%eax
  800897:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	8a 00                	mov    (%eax),%al
  80089f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a5:	7e 3e                	jle    8008e5 <vprintfmt+0xe9>
  8008a7:	83 fb 39             	cmp    $0x39,%ebx
  8008aa:	7f 39                	jg     8008e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008af:	eb d5                	jmp    800886 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c5:	eb 1f                	jmp    8008e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cb:	79 83                	jns    800850 <vprintfmt+0x54>
				width = 0;
  8008cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d4:	e9 77 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008e0:	e9 6b ff ff ff       	jmp    800850 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	0f 89 60 ff ff ff    	jns    800850 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008fd:	e9 4e ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800902:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800905:	e9 46 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	83 c0 04             	add    $0x4,%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	83 e8 04             	sub    $0x4,%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	50                   	push   %eax
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 89 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800940:	85 db                	test   %ebx,%ebx
  800942:	79 02                	jns    800946 <vprintfmt+0x14a>
				err = -err;
  800944:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800946:	83 fb 64             	cmp    $0x64,%ebx
  800949:	7f 0b                	jg     800956 <vprintfmt+0x15a>
  80094b:	8b 34 9d a0 3c 80 00 	mov    0x803ca0(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 45 3e 80 00       	push   $0x803e45
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 5e 02 00 00       	call   800bc5 <printfmt>
  800967:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80096a:	e9 49 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096f:	56                   	push   %esi
  800970:	68 4e 3e 80 00       	push   $0x803e4e
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	e8 45 02 00 00       	call   800bc5 <printfmt>
  800980:	83 c4 10             	add    $0x10,%esp
			break;
  800983:	e9 30 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 30                	mov    (%eax),%esi
  800999:	85 f6                	test   %esi,%esi
  80099b:	75 05                	jne    8009a2 <vprintfmt+0x1a6>
				p = "(null)";
  80099d:	be 51 3e 80 00       	mov    $0x803e51,%esi
			if (width > 0 && padc != '-')
  8009a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a6:	7e 6d                	jle    800a15 <vprintfmt+0x219>
  8009a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ac:	74 67                	je     800a15 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b1:	83 ec 08             	sub    $0x8,%esp
  8009b4:	50                   	push   %eax
  8009b5:	56                   	push   %esi
  8009b6:	e8 0c 03 00 00       	call   800cc7 <strnlen>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c1:	eb 16                	jmp    8009d9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	50                   	push   %eax
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7f e4                	jg     8009c3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009df:	eb 34                	jmp    800a15 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e5:	74 1c                	je     800a03 <vprintfmt+0x207>
  8009e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ea:	7e 05                	jle    8009f1 <vprintfmt+0x1f5>
  8009ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ef:	7e 12                	jle    800a03 <vprintfmt+0x207>
					putch('?', putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	6a 3f                	push   $0x3f
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
  800a01:	eb 0f                	jmp    800a12 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a12:	ff 4d e4             	decl   -0x1c(%ebp)
  800a15:	89 f0                	mov    %esi,%eax
  800a17:	8d 70 01             	lea    0x1(%eax),%esi
  800a1a:	8a 00                	mov    (%eax),%al
  800a1c:	0f be d8             	movsbl %al,%ebx
  800a1f:	85 db                	test   %ebx,%ebx
  800a21:	74 24                	je     800a47 <vprintfmt+0x24b>
  800a23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a27:	78 b8                	js     8009e1 <vprintfmt+0x1e5>
  800a29:	ff 4d e0             	decl   -0x20(%ebp)
  800a2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a30:	79 af                	jns    8009e1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	eb 13                	jmp    800a47 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 20                	push   $0x20
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a44:	ff 4d e4             	decl   -0x1c(%ebp)
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4b:	7f e7                	jg     800a34 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a4d:	e9 66 01 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 3c fd ff ff       	call   80079d <getint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a70:	85 d2                	test   %edx,%edx
  800a72:	79 23                	jns    800a97 <vprintfmt+0x29b>
				putch('-', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 2d                	push   $0x2d
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8a:	f7 d8                	neg    %eax
  800a8c:	83 d2 00             	adc    $0x0,%edx
  800a8f:	f7 da                	neg    %edx
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 84 fc ff ff       	call   800736 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800abb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac2:	e9 98 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	6a 58                	push   $0x58
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			break;
  800af7:	e9 bc 00 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 30                	push   $0x30
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 78                	push   $0x78
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3e:	eb 1f                	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 e8             	pushl  -0x18(%ebp)
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 e7 fb ff ff       	call   800736 <getuint>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	52                   	push   %edx
  800b6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	ff 75 f0             	pushl  -0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 00 fb ff ff       	call   80067f <printnum>
  800b7f:	83 c4 20             	add    $0x20,%esp
			break;
  800b82:	eb 34                	jmp    800bb8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			break;
  800b93:	eb 23                	jmp    800bb8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 25                	push   $0x25
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x3b1>
  800baa:	ff 4d 10             	decl   0x10(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	48                   	dec    %eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3c 25                	cmp    $0x25,%al
  800bb5:	75 f3                	jne    800baa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb7:	90                   	nop
		}
	}
  800bb8:	e9 47 fc ff ff       	jmp    800804 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 16 fc ff ff       	call   8007fc <vprintfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be9:	90                   	nop
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 08             	mov    0x8(%eax),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8b 40 04             	mov    0x4(%eax),%eax
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	73 12                	jae    800c1f <sprintputch+0x33>
		*b->buf++ = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 10                	mov    %dl,(%eax)
}
  800c1f:	90                   	nop
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c47:	74 06                	je     800c4f <vsnprintf+0x2d>
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	7f 07                	jg     800c56 <vsnprintf+0x34>
		return -E_INVAL;
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	eb 20                	jmp    800c76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c56:	ff 75 14             	pushl  0x14(%ebp)
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	68 ec 0b 80 00       	push   $0x800bec
  800c65:	e8 92 fb ff ff       	call   8007fc <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 89 ff ff ff       	call   800c22 <vsnprintf>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb1:	eb 06                	jmp    800cb9 <strlen+0x15>
		n++;
  800cb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 f1                	jne    800cb3 <strlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd4:	eb 09                	jmp    800cdf <strnlen+0x18>
		n++;
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 4d 0c             	decl   0xc(%ebp)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 09                	je     800cee <strnlen+0x27>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 e8                	jne    800cd6 <strnlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cff:	90                   	nop
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e4                	jne    800d00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 1f                	jmp    800d55 <strncpy+0x34>
		*dst++ = *src;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 03                	je     800d52 <strncpy+0x31>
			src++;
  800d4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5b:	72 d9                	jb     800d36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 30                	je     800da4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d74:	eb 16                	jmp    800d8c <strlcpy+0x2a>
			*dst++ = *src++;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 09                	je     800d9e <strlcpy+0x3c>
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 d8                	jne    800d76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0xb>
		p++, q++;
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	74 0e                	je     800dd2 <strcmp+0x22>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 e3                	je     800db5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800deb:	eb 09                	jmp    800df6 <strncmp+0xe>
		n--, p++, q++;
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	ff 45 08             	incl   0x8(%ebp)
  800df3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 17                	je     800e13 <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	74 0e                	je     800e13 <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 10                	mov    (%eax),%dl
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	38 c2                	cmp    %al,%dl
  800e11:	74 da                	je     800ded <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	75 07                	jne    800e20 <strncmp+0x38>
		return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 14                	jmp    800e34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 12                	jmp    800e56 <strchr+0x20>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	75 05                	jne    800e53 <strchr+0x1d>
			return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	eb 11                	jmp    800e64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e5                	jne    800e44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e72:	eb 0d                	jmp    800e81 <strfind+0x1b>
		if (*s == c)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7c:	74 0e                	je     800e8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ea                	jne    800e74 <strfind+0xe>
  800e8a:	eb 01                	jmp    800e8d <strfind+0x27>
		if (*s == c)
			break;
  800e8c:	90                   	nop
	return (char *) s;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea4:	eb 0e                	jmp    800eb4 <memset+0x22>
		*p++ = c;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb4:	ff 4d f8             	decl   -0x8(%ebp)
  800eb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ebb:	79 e9                	jns    800ea6 <memset+0x14>
		*p++ = c;

	return v;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed4:	eb 16                	jmp    800eec <memcpy+0x2a>
		*d++ = *s++;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee8:	8a 12                	mov    (%edx),%dl
  800eea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 dd                	jne    800ed6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f16:	73 50                	jae    800f68 <memmove+0x6a>
  800f18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f23:	76 43                	jbe    800f68 <memmove+0x6a>
		s += n;
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f31:	eb 10                	jmp    800f43 <memmove+0x45>
			*--d = *--s;
  800f33:	ff 4d f8             	decl   -0x8(%ebp)
  800f36:	ff 4d fc             	decl   -0x4(%ebp)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	8a 10                	mov    (%eax),%dl
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 e3                	jne    800f33 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f50:	eb 23                	jmp    800f75 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 dd                	jne    800f52 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f8c:	eb 2a                	jmp    800fb8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f91:	8a 10                	mov    (%eax),%dl
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	38 c2                	cmp    %al,%dl
  800f9a:	74 16                	je     800fb2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	eb 18                	jmp    800fca <memcmp+0x50>
		s1++, s2++;
  800fb2:	ff 45 fc             	incl   -0x4(%ebp)
  800fb5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	75 c9                	jne    800f8e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fdd:	eb 15                	jmp    800ff4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f b6 d0             	movzbl %al,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	0f b6 c0             	movzbl %al,%eax
  800fed:	39 c2                	cmp    %eax,%edx
  800fef:	74 0d                	je     800ffe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ffa:	72 e3                	jb     800fdf <memfind+0x13>
  800ffc:	eb 01                	jmp    800fff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffe:	90                   	nop
	return (void *) s;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801011:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801018:	eb 03                	jmp    80101d <strtol+0x19>
		s++;
  80101a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 20                	cmp    $0x20,%al
  801024:	74 f4                	je     80101a <strtol+0x16>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 09                	cmp    $0x9,%al
  80102d:	74 eb                	je     80101a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 2b                	cmp    $0x2b,%al
  801036:	75 05                	jne    80103d <strtol+0x39>
		s++;
  801038:	ff 45 08             	incl   0x8(%ebp)
  80103b:	eb 13                	jmp    801050 <strtol+0x4c>
	else if (*s == '-')
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3c 2d                	cmp    $0x2d,%al
  801044:	75 0a                	jne    801050 <strtol+0x4c>
		s++, neg = 1;
  801046:	ff 45 08             	incl   0x8(%ebp)
  801049:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	74 06                	je     80105c <strtol+0x58>
  801056:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80105a:	75 20                	jne    80107c <strtol+0x78>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 30                	cmp    $0x30,%al
  801063:	75 17                	jne    80107c <strtol+0x78>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	40                   	inc    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 78                	cmp    $0x78,%al
  80106d:	75 0d                	jne    80107c <strtol+0x78>
		s += 2, base = 16;
  80106f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801073:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80107a:	eb 28                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80107c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801080:	75 15                	jne    801097 <strtol+0x93>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 30                	cmp    $0x30,%al
  801089:	75 0c                	jne    801097 <strtol+0x93>
		s++, base = 8;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801095:	eb 0d                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0)
  801097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109b:	75 07                	jne    8010a4 <strtol+0xa0>
		base = 10;
  80109d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 2f                	cmp    $0x2f,%al
  8010ab:	7e 19                	jle    8010c6 <strtol+0xc2>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 39                	cmp    $0x39,%al
  8010b4:	7f 10                	jg     8010c6 <strtol+0xc2>
			dig = *s - '0';
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f be c0             	movsbl %al,%eax
  8010be:	83 e8 30             	sub    $0x30,%eax
  8010c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c4:	eb 42                	jmp    801108 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 60                	cmp    $0x60,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xe4>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 7a                	cmp    $0x7a,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 57             	sub    $0x57,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 20                	jmp    801108 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 40                	cmp    $0x40,%al
  8010ef:	7e 39                	jle    80112a <strtol+0x126>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 5a                	cmp    $0x5a,%al
  8010f8:	7f 30                	jg     80112a <strtol+0x126>
			dig = *s - 'A' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 37             	sub    $0x37,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110e:	7d 19                	jge    801129 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801110:	ff 45 08             	incl   0x8(%ebp)
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	0f af 45 10          	imul   0x10(%ebp),%eax
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801124:	e9 7b ff ff ff       	jmp    8010a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801129:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80112a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112e:	74 08                	je     801138 <strtol+0x134>
		*endptr = (char *) s;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 07                	je     801145 <strtol+0x141>
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	f7 d8                	neg    %eax
  801143:	eb 03                	jmp    801148 <strtol+0x144>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <ltostr>:

void
ltostr(long value, char *str)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801162:	79 13                	jns    801177 <ltostr+0x2d>
	{
		neg = 1;
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801171:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801174:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117f:	99                   	cltd   
  801180:	f7 f9                	idiv   %ecx
  801182:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801198:	83 c2 30             	add    $0x30,%edx
  80119b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a5:	f7 e9                	imul   %ecx
  8011a7:	c1 fa 02             	sar    $0x2,%edx
  8011aa:	89 c8                	mov    %ecx,%eax
  8011ac:	c1 f8 1f             	sar    $0x1f,%eax
  8011af:	29 c2                	sub    %eax,%edx
  8011b1:	89 d0                	mov    %edx,%eax
  8011b3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011be:	f7 e9                	imul   %ecx
  8011c0:	c1 fa 02             	sar    $0x2,%edx
  8011c3:	89 c8                	mov    %ecx,%eax
  8011c5:	c1 f8 1f             	sar    $0x1f,%eax
  8011c8:	29 c2                	sub    %eax,%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	c1 e0 02             	shl    $0x2,%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	01 c0                	add    %eax,%eax
  8011d3:	29 c1                	sub    %eax,%ecx
  8011d5:	89 ca                	mov    %ecx,%edx
  8011d7:	85 d2                	test   %edx,%edx
  8011d9:	75 9c                	jne    801177 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	48                   	dec    %eax
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ed:	74 3d                	je     80122c <ltostr+0xe2>
		start = 1 ;
  8011ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f6:	eb 34                	jmp    80122c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 c2                	add    %eax,%edx
  80120d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c8                	add    %ecx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	01 c2                	add    %eax,%edx
  801221:	8a 45 eb             	mov    -0x15(%ebp),%al
  801224:	88 02                	mov    %al,(%edx)
		start++ ;
  801226:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801229:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7c c4                	jl     8011f8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801234:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801248:	ff 75 08             	pushl  0x8(%ebp)
  80124b:	e8 54 fa ff ff       	call   800ca4 <strlen>
  801250:	83 c4 04             	add    $0x4,%esp
  801253:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	e8 46 fa ff ff       	call   800ca4 <strlen>
  80125e:	83 c4 04             	add    $0x4,%esp
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 17                	jmp    80128b <strcconcat+0x49>
		final[s] = str1[s] ;
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 c2                	add    %eax,%edx
  80127c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	01 c8                	add    %ecx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801288:	ff 45 fc             	incl   -0x4(%ebp)
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801291:	7c e1                	jl     801274 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801293:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80129a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012a1:	eb 1f                	jmp    8012c2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a6:	8d 50 01             	lea    0x1(%eax),%edx
  8012a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ac:	89 c2                	mov    %eax,%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 c8                	add    %ecx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bf:	ff 45 f8             	incl   -0x8(%ebp)
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c8:	7c d9                	jl     8012a3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d5:	90                   	nop
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fb:	eb 0c                	jmp    801309 <strsplit+0x31>
			*string++ = 0;
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8d 50 01             	lea    0x1(%eax),%edx
  801303:	89 55 08             	mov    %edx,0x8(%ebp)
  801306:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	84 c0                	test   %al,%al
  801310:	74 18                	je     80132a <strsplit+0x52>
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f be c0             	movsbl %al,%eax
  80131a:	50                   	push   %eax
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	e8 13 fb ff ff       	call   800e36 <strchr>
  801323:	83 c4 08             	add    $0x8,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	75 d3                	jne    8012fd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	84 c0                	test   %al,%al
  801331:	74 5a                	je     80138d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801333:	8b 45 14             	mov    0x14(%ebp),%eax
  801336:	8b 00                	mov    (%eax),%eax
  801338:	83 f8 0f             	cmp    $0xf,%eax
  80133b:	75 07                	jne    801344 <strsplit+0x6c>
		{
			return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	eb 66                	jmp    8013aa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801344:	8b 45 14             	mov    0x14(%ebp),%eax
  801347:	8b 00                	mov    (%eax),%eax
  801349:	8d 48 01             	lea    0x1(%eax),%ecx
  80134c:	8b 55 14             	mov    0x14(%ebp),%edx
  80134f:	89 0a                	mov    %ecx,(%edx)
  801351:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 c2                	add    %eax,%edx
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801362:	eb 03                	jmp    801367 <strsplit+0x8f>
			string++;
  801364:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 8b                	je     8012fb <strsplit+0x23>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f be c0             	movsbl %al,%eax
  801378:	50                   	push   %eax
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	e8 b5 fa ff ff       	call   800e36 <strchr>
  801381:	83 c4 08             	add    $0x8,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	74 dc                	je     801364 <strsplit+0x8c>
			string++;
	}
  801388:	e9 6e ff ff ff       	jmp    8012fb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80138d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138e:	8b 45 14             	mov    0x14(%ebp),%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013b2:	a1 04 50 80 00       	mov    0x805004,%eax
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	74 1f                	je     8013da <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013bb:	e8 1d 00 00 00       	call   8013dd <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	68 b0 3f 80 00       	push   $0x803fb0
  8013c8:	e8 55 f2 ff ff       	call   800622 <cprintf>
  8013cd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013d0:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8013d7:	00 00 00 
	}
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8013e3:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8013ea:	00 00 00 
  8013ed:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8013f4:	00 00 00 
  8013f7:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8013fe:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801401:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801408:	00 00 00 
  80140b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801412:	00 00 00 
  801415:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80141c:	00 00 00 
	uint32 arr_size = 0;
  80141f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801426:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80142d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801430:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801435:	2d 00 10 00 00       	sub    $0x1000,%eax
  80143a:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80143f:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801446:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801449:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801450:	a1 20 51 80 00       	mov    0x805120,%eax
  801455:	c1 e0 04             	shl    $0x4,%eax
  801458:	89 c2                	mov    %eax,%edx
  80145a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145d:	01 d0                	add    %edx,%eax
  80145f:	48                   	dec    %eax
  801460:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801466:	ba 00 00 00 00       	mov    $0x0,%edx
  80146b:	f7 75 ec             	divl   -0x14(%ebp)
  80146e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801471:	29 d0                	sub    %edx,%eax
  801473:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801476:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80147d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801480:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801485:	2d 00 10 00 00       	sub    $0x1000,%eax
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	6a 06                	push   $0x6
  80148f:	ff 75 f4             	pushl  -0xc(%ebp)
  801492:	50                   	push   %eax
  801493:	e8 b2 05 00 00       	call   801a4a <sys_allocate_chunk>
  801498:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80149b:	a1 20 51 80 00       	mov    0x805120,%eax
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	50                   	push   %eax
  8014a4:	e8 27 0c 00 00       	call   8020d0 <initialize_MemBlocksList>
  8014a9:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8014ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8014b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8014b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8014be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8014c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014cc:	75 14                	jne    8014e2 <initialize_dyn_block_system+0x105>
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 d5 3f 80 00       	push   $0x803fd5
  8014d6:	6a 33                	push   $0x33
  8014d8:	68 f3 3f 80 00       	push   $0x803ff3
  8014dd:	e8 a7 20 00 00       	call   803589 <_panic>
  8014e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e5:	8b 00                	mov    (%eax),%eax
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	74 10                	je     8014fb <initialize_dyn_block_system+0x11e>
  8014eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ee:	8b 00                	mov    (%eax),%eax
  8014f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014f3:	8b 52 04             	mov    0x4(%edx),%edx
  8014f6:	89 50 04             	mov    %edx,0x4(%eax)
  8014f9:	eb 0b                	jmp    801506 <initialize_dyn_block_system+0x129>
  8014fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014fe:	8b 40 04             	mov    0x4(%eax),%eax
  801501:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801506:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801509:	8b 40 04             	mov    0x4(%eax),%eax
  80150c:	85 c0                	test   %eax,%eax
  80150e:	74 0f                	je     80151f <initialize_dyn_block_system+0x142>
  801510:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801513:	8b 40 04             	mov    0x4(%eax),%eax
  801516:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801519:	8b 12                	mov    (%edx),%edx
  80151b:	89 10                	mov    %edx,(%eax)
  80151d:	eb 0a                	jmp    801529 <initialize_dyn_block_system+0x14c>
  80151f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801522:	8b 00                	mov    (%eax),%eax
  801524:	a3 48 51 80 00       	mov    %eax,0x805148
  801529:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801535:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80153c:	a1 54 51 80 00       	mov    0x805154,%eax
  801541:	48                   	dec    %eax
  801542:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801547:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80154b:	75 14                	jne    801561 <initialize_dyn_block_system+0x184>
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 00 40 80 00       	push   $0x804000
  801555:	6a 34                	push   $0x34
  801557:	68 f3 3f 80 00       	push   $0x803ff3
  80155c:	e8 28 20 00 00       	call   803589 <_panic>
  801561:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156a:	89 10                	mov    %edx,(%eax)
  80156c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156f:	8b 00                	mov    (%eax),%eax
  801571:	85 c0                	test   %eax,%eax
  801573:	74 0d                	je     801582 <initialize_dyn_block_system+0x1a5>
  801575:	a1 38 51 80 00       	mov    0x805138,%eax
  80157a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80157d:	89 50 04             	mov    %edx,0x4(%eax)
  801580:	eb 08                	jmp    80158a <initialize_dyn_block_system+0x1ad>
  801582:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801585:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80158a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158d:	a3 38 51 80 00       	mov    %eax,0x805138
  801592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801595:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80159c:	a1 44 51 80 00       	mov    0x805144,%eax
  8015a1:	40                   	inc    %eax
  8015a2:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8015a7:	90                   	nop
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b0:	e8 f7 fd ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b9:	75 07                	jne    8015c2 <malloc+0x18>
  8015bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c0:	eb 61                	jmp    801623 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8015c2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	48                   	dec    %eax
  8015d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015dd:	f7 75 f0             	divl   -0x10(%ebp)
  8015e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e3:	29 d0                	sub    %edx,%eax
  8015e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015e8:	e8 2b 08 00 00       	call   801e18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	74 11                	je     801602 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f7:	e8 96 0e 00 00       	call   802492 <alloc_block_FF>
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801606:	74 16                	je     80161e <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	ff 75 f4             	pushl  -0xc(%ebp)
  80160e:	e8 f2 0b 00 00       	call   802205 <insert_sorted_allocList>
  801613:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801619:	8b 40 08             	mov    0x8(%eax),%eax
  80161c:	eb 05                	jmp    801623 <malloc+0x79>
	}

    return NULL;
  80161e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	50                   	push   %eax
  801632:	68 40 50 80 00       	push   $0x805040
  801637:	e8 71 0b 00 00       	call   8021ad <find_block>
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801646:	0f 84 a6 00 00 00    	je     8016f2 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  80164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164f:	8b 50 0c             	mov    0xc(%eax),%edx
  801652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801655:	8b 40 08             	mov    0x8(%eax),%eax
  801658:	83 ec 08             	sub    $0x8,%esp
  80165b:	52                   	push   %edx
  80165c:	50                   	push   %eax
  80165d:	e8 b0 03 00 00       	call   801a12 <sys_free_user_mem>
  801662:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801665:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801669:	75 14                	jne    80167f <free+0x5a>
  80166b:	83 ec 04             	sub    $0x4,%esp
  80166e:	68 d5 3f 80 00       	push   $0x803fd5
  801673:	6a 74                	push   $0x74
  801675:	68 f3 3f 80 00       	push   $0x803ff3
  80167a:	e8 0a 1f 00 00       	call   803589 <_panic>
  80167f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801682:	8b 00                	mov    (%eax),%eax
  801684:	85 c0                	test   %eax,%eax
  801686:	74 10                	je     801698 <free+0x73>
  801688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801690:	8b 52 04             	mov    0x4(%edx),%edx
  801693:	89 50 04             	mov    %edx,0x4(%eax)
  801696:	eb 0b                	jmp    8016a3 <free+0x7e>
  801698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169b:	8b 40 04             	mov    0x4(%eax),%eax
  80169e:	a3 44 50 80 00       	mov    %eax,0x805044
  8016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a6:	8b 40 04             	mov    0x4(%eax),%eax
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	74 0f                	je     8016bc <free+0x97>
  8016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b0:	8b 40 04             	mov    0x4(%eax),%eax
  8016b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b6:	8b 12                	mov    (%edx),%edx
  8016b8:	89 10                	mov    %edx,(%eax)
  8016ba:	eb 0a                	jmp    8016c6 <free+0xa1>
  8016bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bf:	8b 00                	mov    (%eax),%eax
  8016c1:	a3 40 50 80 00       	mov    %eax,0x805040
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016d9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8016de:	48                   	dec    %eax
  8016df:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  8016e4:	83 ec 0c             	sub    $0xc,%esp
  8016e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ea:	e8 4e 17 00 00       	call   802e3d <insert_sorted_with_merge_freeList>
  8016ef:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016f2:	90                   	nop
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 38             	sub    $0x38,%esp
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801701:	e8 a6 fc ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  801706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80170a:	75 0a                	jne    801716 <smalloc+0x21>
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
  801711:	e9 8b 00 00 00       	jmp    8017a1 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801716:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80171d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801723:	01 d0                	add    %edx,%eax
  801725:	48                   	dec    %eax
  801726:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172c:	ba 00 00 00 00       	mov    $0x0,%edx
  801731:	f7 75 f0             	divl   -0x10(%ebp)
  801734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801737:	29 d0                	sub    %edx,%eax
  801739:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80173c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801743:	e8 d0 06 00 00       	call   801e18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801748:	85 c0                	test   %eax,%eax
  80174a:	74 11                	je     80175d <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	ff 75 e8             	pushl  -0x18(%ebp)
  801752:	e8 3b 0d 00 00       	call   802492 <alloc_block_FF>
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80175d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801761:	74 39                	je     80179c <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801766:	8b 40 08             	mov    0x8(%eax),%eax
  801769:	89 c2                	mov    %eax,%edx
  80176b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80176f:	52                   	push   %edx
  801770:	50                   	push   %eax
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	ff 75 08             	pushl  0x8(%ebp)
  801777:	e8 21 04 00 00       	call   801b9d <sys_createSharedObject>
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801782:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801786:	74 14                	je     80179c <smalloc+0xa7>
  801788:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80178c:	74 0e                	je     80179c <smalloc+0xa7>
  80178e:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801792:	74 08                	je     80179c <smalloc+0xa7>
			return (void*) mem_block->sva;
  801794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801797:	8b 40 08             	mov    0x8(%eax),%eax
  80179a:	eb 05                	jmp    8017a1 <smalloc+0xac>
	}
	return NULL;
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a9:	e8 fe fb ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	ff 75 0c             	pushl  0xc(%ebp)
  8017b4:	ff 75 08             	pushl  0x8(%ebp)
  8017b7:	e8 0b 04 00 00       	call   801bc7 <sys_getSizeOfSharedObject>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8017c2:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8017c6:	74 76                	je     80183e <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017c8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d5:	01 d0                	add    %edx,%eax
  8017d7:	48                   	dec    %eax
  8017d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017de:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e3:	f7 75 ec             	divl   -0x14(%ebp)
  8017e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e9:	29 d0                	sub    %edx,%eax
  8017eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8017ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017f5:	e8 1e 06 00 00       	call   801e18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	74 11                	je     80180f <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8017fe:	83 ec 0c             	sub    $0xc,%esp
  801801:	ff 75 e4             	pushl  -0x1c(%ebp)
  801804:	e8 89 0c 00 00       	call   802492 <alloc_block_FF>
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80180f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801813:	74 29                	je     80183e <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801818:	8b 40 08             	mov    0x8(%eax),%eax
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	50                   	push   %eax
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	e8 ba 03 00 00       	call   801be4 <sys_getSharedObject>
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801830:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801834:	74 08                	je     80183e <sget+0x9b>
				return (void *)mem_block->sva;
  801836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801839:	8b 40 08             	mov    0x8(%eax),%eax
  80183c:	eb 05                	jmp    801843 <sget+0xa0>
		}
	}
	return NULL;
  80183e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80184b:	e8 5c fb ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	68 24 40 80 00       	push   $0x804024
  801858:	68 f7 00 00 00       	push   $0xf7
  80185d:	68 f3 3f 80 00       	push   $0x803ff3
  801862:	e8 22 1d 00 00       	call   803589 <_panic>

00801867 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	68 4c 40 80 00       	push   $0x80404c
  801875:	68 0b 01 00 00       	push   $0x10b
  80187a:	68 f3 3f 80 00       	push   $0x803ff3
  80187f:	e8 05 1d 00 00       	call   803589 <_panic>

00801884 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	68 70 40 80 00       	push   $0x804070
  801892:	68 16 01 00 00       	push   $0x116
  801897:	68 f3 3f 80 00       	push   $0x803ff3
  80189c:	e8 e8 1c 00 00       	call   803589 <_panic>

008018a1 <shrink>:

}
void shrink(uint32 newSize)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a7:	83 ec 04             	sub    $0x4,%esp
  8018aa:	68 70 40 80 00       	push   $0x804070
  8018af:	68 1b 01 00 00       	push   $0x11b
  8018b4:	68 f3 3f 80 00       	push   $0x803ff3
  8018b9:	e8 cb 1c 00 00       	call   803589 <_panic>

008018be <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c4:	83 ec 04             	sub    $0x4,%esp
  8018c7:	68 70 40 80 00       	push   $0x804070
  8018cc:	68 20 01 00 00       	push   $0x120
  8018d1:	68 f3 3f 80 00       	push   $0x803ff3
  8018d6:	e8 ae 1c 00 00       	call   803589 <_panic>

008018db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	57                   	push   %edi
  8018df:	56                   	push   %esi
  8018e0:	53                   	push   %ebx
  8018e1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018f3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018f6:	cd 30                	int    $0x30
  8018f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5f                   	pop    %edi
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    

00801906 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 04             	sub    $0x4,%esp
  80190c:	8b 45 10             	mov    0x10(%ebp),%eax
  80190f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801912:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	52                   	push   %edx
  80191e:	ff 75 0c             	pushl  0xc(%ebp)
  801921:	50                   	push   %eax
  801922:	6a 00                	push   $0x0
  801924:	e8 b2 ff ff ff       	call   8018db <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	90                   	nop
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_cgetc>:

int
sys_cgetc(void)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 01                	push   $0x1
  80193e:	e8 98 ff ff ff       	call   8018db <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80194b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	52                   	push   %edx
  801958:	50                   	push   %eax
  801959:	6a 05                	push   $0x5
  80195b:	e8 7b ff ff ff       	call   8018db <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	56                   	push   %esi
  801969:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80196a:	8b 75 18             	mov    0x18(%ebp),%esi
  80196d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801970:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
  80197b:	51                   	push   %ecx
  80197c:	52                   	push   %edx
  80197d:	50                   	push   %eax
  80197e:	6a 06                	push   $0x6
  801980:	e8 56 ff ff ff       	call   8018db <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198b:	5b                   	pop    %ebx
  80198c:	5e                   	pop    %esi
  80198d:	5d                   	pop    %ebp
  80198e:	c3                   	ret    

0080198f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801992:	8b 55 0c             	mov    0xc(%ebp),%edx
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	52                   	push   %edx
  80199f:	50                   	push   %eax
  8019a0:	6a 07                	push   $0x7
  8019a2:	e8 34 ff ff ff       	call   8018db <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	ff 75 08             	pushl  0x8(%ebp)
  8019bb:	6a 08                	push   $0x8
  8019bd:	e8 19 ff ff ff       	call   8018db <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 09                	push   $0x9
  8019d6:	e8 00 ff ff ff       	call   8018db <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 0a                	push   $0xa
  8019ef:	e8 e7 fe ff ff       	call   8018db <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 0b                	push   $0xb
  801a08:	e8 ce fe ff ff       	call   8018db <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	ff 75 08             	pushl  0x8(%ebp)
  801a21:	6a 0f                	push   $0xf
  801a23:	e8 b3 fe ff ff       	call   8018db <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
	return;
  801a2b:	90                   	nop
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	ff 75 0c             	pushl  0xc(%ebp)
  801a3a:	ff 75 08             	pushl  0x8(%ebp)
  801a3d:	6a 10                	push   $0x10
  801a3f:	e8 97 fe ff ff       	call   8018db <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
	return ;
  801a47:	90                   	nop
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	ff 75 10             	pushl  0x10(%ebp)
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	ff 75 08             	pushl  0x8(%ebp)
  801a5a:	6a 11                	push   $0x11
  801a5c:	e8 7a fe ff ff       	call   8018db <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
	return ;
  801a64:	90                   	nop
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 0c                	push   $0xc
  801a76:	e8 60 fe ff ff       	call   8018db <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	ff 75 08             	pushl  0x8(%ebp)
  801a8e:	6a 0d                	push   $0xd
  801a90:	e8 46 fe ff ff       	call   8018db <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 0e                	push   $0xe
  801aa9:	e8 2d fe ff ff       	call   8018db <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	90                   	nop
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 13                	push   $0x13
  801ac3:	e8 13 fe ff ff       	call   8018db <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	90                   	nop
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 14                	push   $0x14
  801add:	e8 f9 fd ff ff       	call   8018db <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	90                   	nop
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801af4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	50                   	push   %eax
  801b01:	6a 15                	push   $0x15
  801b03:	e8 d3 fd ff ff       	call   8018db <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	90                   	nop
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 16                	push   $0x16
  801b1d:	e8 b9 fd ff ff       	call   8018db <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	50                   	push   %eax
  801b38:	6a 17                	push   $0x17
  801b3a:	e8 9c fd ff ff       	call   8018db <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	6a 1a                	push   $0x1a
  801b57:	e8 7f fd ff ff       	call   8018db <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 18                	push   $0x18
  801b74:	e8 62 fd ff ff       	call   8018db <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	90                   	nop
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	52                   	push   %edx
  801b8f:	50                   	push   %eax
  801b90:	6a 19                	push   $0x19
  801b92:	e8 44 fd ff ff       	call   8018db <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	90                   	nop
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ba9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	51                   	push   %ecx
  801bb6:	52                   	push   %edx
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	50                   	push   %eax
  801bbb:	6a 1b                	push   $0x1b
  801bbd:	e8 19 fd ff ff       	call   8018db <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	52                   	push   %edx
  801bd7:	50                   	push   %eax
  801bd8:	6a 1c                	push   $0x1c
  801bda:	e8 fc fc ff ff       	call   8018db <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801be7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	51                   	push   %ecx
  801bf5:	52                   	push   %edx
  801bf6:	50                   	push   %eax
  801bf7:	6a 1d                	push   $0x1d
  801bf9:	e8 dd fc ff ff       	call   8018db <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	52                   	push   %edx
  801c13:	50                   	push   %eax
  801c14:	6a 1e                	push   $0x1e
  801c16:	e8 c0 fc ff ff       	call   8018db <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 1f                	push   $0x1f
  801c2f:	e8 a7 fc ff ff       	call   8018db <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	6a 00                	push   $0x0
  801c41:	ff 75 14             	pushl  0x14(%ebp)
  801c44:	ff 75 10             	pushl  0x10(%ebp)
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	50                   	push   %eax
  801c4b:	6a 20                	push   $0x20
  801c4d:	e8 89 fc ff ff       	call   8018db <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	50                   	push   %eax
  801c66:	6a 21                	push   $0x21
  801c68:	e8 6e fc ff ff       	call   8018db <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	90                   	nop
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	50                   	push   %eax
  801c82:	6a 22                	push   $0x22
  801c84:	e8 52 fc ff ff       	call   8018db <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 02                	push   $0x2
  801c9d:	e8 39 fc ff ff       	call   8018db <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 03                	push   $0x3
  801cb6:	e8 20 fc ff ff       	call   8018db <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 04                	push   $0x4
  801ccf:	e8 07 fc ff ff       	call   8018db <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_exit_env>:


void sys_exit_env(void)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 23                	push   $0x23
  801ce8:	e8 ee fb ff ff       	call   8018db <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	90                   	nop
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cf9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cfc:	8d 50 04             	lea    0x4(%eax),%edx
  801cff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	52                   	push   %edx
  801d09:	50                   	push   %eax
  801d0a:	6a 24                	push   $0x24
  801d0c:	e8 ca fb ff ff       	call   8018db <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
	return result;
  801d14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d1d:	89 01                	mov    %eax,(%ecx)
  801d1f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	c9                   	leave  
  801d26:	c2 04 00             	ret    $0x4

00801d29 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	ff 75 10             	pushl  0x10(%ebp)
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	6a 12                	push   $0x12
  801d3b:	e8 9b fb ff ff       	call   8018db <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
	return ;
  801d43:	90                   	nop
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 25                	push   $0x25
  801d55:	e8 81 fb ff ff       	call   8018db <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 04             	sub    $0x4,%esp
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d6b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	50                   	push   %eax
  801d78:	6a 26                	push   $0x26
  801d7a:	e8 5c fb ff ff       	call   8018db <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <rsttst>:
void rsttst()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 28                	push   $0x28
  801d94:	e8 42 fb ff ff       	call   8018db <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9c:	90                   	nop
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	8b 45 14             	mov    0x14(%ebp),%eax
  801da8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dab:	8b 55 18             	mov    0x18(%ebp),%edx
  801dae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801db2:	52                   	push   %edx
  801db3:	50                   	push   %eax
  801db4:	ff 75 10             	pushl  0x10(%ebp)
  801db7:	ff 75 0c             	pushl  0xc(%ebp)
  801dba:	ff 75 08             	pushl  0x8(%ebp)
  801dbd:	6a 27                	push   $0x27
  801dbf:	e8 17 fb ff ff       	call   8018db <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc7:	90                   	nop
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <chktst>:
void chktst(uint32 n)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	ff 75 08             	pushl  0x8(%ebp)
  801dd8:	6a 29                	push   $0x29
  801dda:	e8 fc fa ff ff       	call   8018db <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
	return ;
  801de2:	90                   	nop
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <inctst>:

void inctst()
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 2a                	push   $0x2a
  801df4:	e8 e2 fa ff ff       	call   8018db <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfc:	90                   	nop
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <gettst>:
uint32 gettst()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 2b                	push   $0x2b
  801e0e:	e8 c8 fa ff ff       	call   8018db <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 2c                	push   $0x2c
  801e2a:	e8 ac fa ff ff       	call   8018db <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
  801e32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e35:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e39:	75 07                	jne    801e42 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e40:	eb 05                	jmp    801e47 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 2c                	push   $0x2c
  801e5b:	e8 7b fa ff ff       	call   8018db <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
  801e63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e66:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e6a:	75 07                	jne    801e73 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e71:	eb 05                	jmp    801e78 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 2c                	push   $0x2c
  801e8c:	e8 4a fa ff ff       	call   8018db <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
  801e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e97:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e9b:	75 07                	jne    801ea4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea2:	eb 05                	jmp    801ea9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 2c                	push   $0x2c
  801ebd:	e8 19 fa ff ff       	call   8018db <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
  801ec5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ec8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ecc:	75 07                	jne    801ed5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ece:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed3:	eb 05                	jmp    801eda <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	ff 75 08             	pushl  0x8(%ebp)
  801eea:	6a 2d                	push   $0x2d
  801eec:	e8 ea f9 ff ff       	call   8018db <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef4:	90                   	nop
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801efb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801efe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	6a 00                	push   $0x0
  801f09:	53                   	push   %ebx
  801f0a:	51                   	push   %ecx
  801f0b:	52                   	push   %edx
  801f0c:	50                   	push   %eax
  801f0d:	6a 2e                	push   $0x2e
  801f0f:	e8 c7 f9 ff ff       	call   8018db <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
}
  801f17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	52                   	push   %edx
  801f2c:	50                   	push   %eax
  801f2d:	6a 2f                	push   $0x2f
  801f2f:	e8 a7 f9 ff ff       	call   8018db <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f3f:	83 ec 0c             	sub    $0xc,%esp
  801f42:	68 80 40 80 00       	push   $0x804080
  801f47:	e8 d6 e6 ff ff       	call   800622 <cprintf>
  801f4c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f56:	83 ec 0c             	sub    $0xc,%esp
  801f59:	68 ac 40 80 00       	push   $0x8040ac
  801f5e:	e8 bf e6 ff ff       	call   800622 <cprintf>
  801f63:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f66:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f6a:	a1 38 51 80 00       	mov    0x805138,%eax
  801f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f72:	eb 56                	jmp    801fca <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f78:	74 1c                	je     801f96 <print_mem_block_lists+0x5d>
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	8b 50 08             	mov    0x8(%eax),%edx
  801f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f83:	8b 48 08             	mov    0x8(%eax),%ecx
  801f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f89:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8c:	01 c8                	add    %ecx,%eax
  801f8e:	39 c2                	cmp    %eax,%edx
  801f90:	73 04                	jae    801f96 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f92:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f99:	8b 50 08             	mov    0x8(%eax),%edx
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa2:	01 c2                	add    %eax,%edx
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	8b 40 08             	mov    0x8(%eax),%eax
  801faa:	83 ec 04             	sub    $0x4,%esp
  801fad:	52                   	push   %edx
  801fae:	50                   	push   %eax
  801faf:	68 c1 40 80 00       	push   $0x8040c1
  801fb4:	e8 69 e6 ff ff       	call   800622 <cprintf>
  801fb9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fc2:	a1 40 51 80 00       	mov    0x805140,%eax
  801fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fce:	74 07                	je     801fd7 <print_mem_block_lists+0x9e>
  801fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd3:	8b 00                	mov    (%eax),%eax
  801fd5:	eb 05                	jmp    801fdc <print_mem_block_lists+0xa3>
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdc:	a3 40 51 80 00       	mov    %eax,0x805140
  801fe1:	a1 40 51 80 00       	mov    0x805140,%eax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	75 8a                	jne    801f74 <print_mem_block_lists+0x3b>
  801fea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fee:	75 84                	jne    801f74 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ff0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ff4:	75 10                	jne    802006 <print_mem_block_lists+0xcd>
  801ff6:	83 ec 0c             	sub    $0xc,%esp
  801ff9:	68 d0 40 80 00       	push   $0x8040d0
  801ffe:	e8 1f e6 ff ff       	call   800622 <cprintf>
  802003:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802006:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	68 f4 40 80 00       	push   $0x8040f4
  802015:	e8 08 e6 ff ff       	call   800622 <cprintf>
  80201a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80201d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802021:	a1 40 50 80 00       	mov    0x805040,%eax
  802026:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802029:	eb 56                	jmp    802081 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80202b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80202f:	74 1c                	je     80204d <print_mem_block_lists+0x114>
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	8b 50 08             	mov    0x8(%eax),%edx
  802037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203a:	8b 48 08             	mov    0x8(%eax),%ecx
  80203d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802040:	8b 40 0c             	mov    0xc(%eax),%eax
  802043:	01 c8                	add    %ecx,%eax
  802045:	39 c2                	cmp    %eax,%edx
  802047:	73 04                	jae    80204d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802049:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80204d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802050:	8b 50 08             	mov    0x8(%eax),%edx
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	8b 40 0c             	mov    0xc(%eax),%eax
  802059:	01 c2                	add    %eax,%edx
  80205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205e:	8b 40 08             	mov    0x8(%eax),%eax
  802061:	83 ec 04             	sub    $0x4,%esp
  802064:	52                   	push   %edx
  802065:	50                   	push   %eax
  802066:	68 c1 40 80 00       	push   $0x8040c1
  80206b:	e8 b2 e5 ff ff       	call   800622 <cprintf>
  802070:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802079:	a1 48 50 80 00       	mov    0x805048,%eax
  80207e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802085:	74 07                	je     80208e <print_mem_block_lists+0x155>
  802087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208a:	8b 00                	mov    (%eax),%eax
  80208c:	eb 05                	jmp    802093 <print_mem_block_lists+0x15a>
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	a3 48 50 80 00       	mov    %eax,0x805048
  802098:	a1 48 50 80 00       	mov    0x805048,%eax
  80209d:	85 c0                	test   %eax,%eax
  80209f:	75 8a                	jne    80202b <print_mem_block_lists+0xf2>
  8020a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a5:	75 84                	jne    80202b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020a7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ab:	75 10                	jne    8020bd <print_mem_block_lists+0x184>
  8020ad:	83 ec 0c             	sub    $0xc,%esp
  8020b0:	68 0c 41 80 00       	push   $0x80410c
  8020b5:	e8 68 e5 ff ff       	call   800622 <cprintf>
  8020ba:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020bd:	83 ec 0c             	sub    $0xc,%esp
  8020c0:	68 80 40 80 00       	push   $0x804080
  8020c5:	e8 58 e5 ff ff       	call   800622 <cprintf>
  8020ca:	83 c4 10             	add    $0x10,%esp

}
  8020cd:	90                   	nop
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020d6:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020dd:	00 00 00 
  8020e0:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020e7:	00 00 00 
  8020ea:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020f1:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020fb:	e9 9e 00 00 00       	jmp    80219e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802100:	a1 50 50 80 00       	mov    0x805050,%eax
  802105:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802108:	c1 e2 04             	shl    $0x4,%edx
  80210b:	01 d0                	add    %edx,%eax
  80210d:	85 c0                	test   %eax,%eax
  80210f:	75 14                	jne    802125 <initialize_MemBlocksList+0x55>
  802111:	83 ec 04             	sub    $0x4,%esp
  802114:	68 34 41 80 00       	push   $0x804134
  802119:	6a 46                	push   $0x46
  80211b:	68 57 41 80 00       	push   $0x804157
  802120:	e8 64 14 00 00       	call   803589 <_panic>
  802125:	a1 50 50 80 00       	mov    0x805050,%eax
  80212a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212d:	c1 e2 04             	shl    $0x4,%edx
  802130:	01 d0                	add    %edx,%eax
  802132:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802138:	89 10                	mov    %edx,(%eax)
  80213a:	8b 00                	mov    (%eax),%eax
  80213c:	85 c0                	test   %eax,%eax
  80213e:	74 18                	je     802158 <initialize_MemBlocksList+0x88>
  802140:	a1 48 51 80 00       	mov    0x805148,%eax
  802145:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80214b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80214e:	c1 e1 04             	shl    $0x4,%ecx
  802151:	01 ca                	add    %ecx,%edx
  802153:	89 50 04             	mov    %edx,0x4(%eax)
  802156:	eb 12                	jmp    80216a <initialize_MemBlocksList+0x9a>
  802158:	a1 50 50 80 00       	mov    0x805050,%eax
  80215d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802160:	c1 e2 04             	shl    $0x4,%edx
  802163:	01 d0                	add    %edx,%eax
  802165:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80216a:	a1 50 50 80 00       	mov    0x805050,%eax
  80216f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802172:	c1 e2 04             	shl    $0x4,%edx
  802175:	01 d0                	add    %edx,%eax
  802177:	a3 48 51 80 00       	mov    %eax,0x805148
  80217c:	a1 50 50 80 00       	mov    0x805050,%eax
  802181:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802184:	c1 e2 04             	shl    $0x4,%edx
  802187:	01 d0                	add    %edx,%eax
  802189:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802190:	a1 54 51 80 00       	mov    0x805154,%eax
  802195:	40                   	inc    %eax
  802196:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80219b:	ff 45 f4             	incl   -0xc(%ebp)
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021a4:	0f 82 56 ff ff ff    	jb     802100 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021aa:	90                   	nop
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	8b 00                	mov    (%eax),%eax
  8021b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021bb:	eb 19                	jmp    8021d6 <find_block+0x29>
	{
		if(va==point->sva)
  8021bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c0:	8b 40 08             	mov    0x8(%eax),%eax
  8021c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021c6:	75 05                	jne    8021cd <find_block+0x20>
		   return point;
  8021c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021cb:	eb 36                	jmp    802203 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	8b 40 08             	mov    0x8(%eax),%eax
  8021d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021da:	74 07                	je     8021e3 <find_block+0x36>
  8021dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021df:	8b 00                	mov    (%eax),%eax
  8021e1:	eb 05                	jmp    8021e8 <find_block+0x3b>
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021eb:	89 42 08             	mov    %eax,0x8(%edx)
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	8b 40 08             	mov    0x8(%eax),%eax
  8021f4:	85 c0                	test   %eax,%eax
  8021f6:	75 c5                	jne    8021bd <find_block+0x10>
  8021f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021fc:	75 bf                	jne    8021bd <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80220b:	a1 40 50 80 00       	mov    0x805040,%eax
  802210:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802213:	a1 44 50 80 00       	mov    0x805044,%eax
  802218:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80221b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802221:	74 24                	je     802247 <insert_sorted_allocList+0x42>
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	8b 50 08             	mov    0x8(%eax),%edx
  802229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222c:	8b 40 08             	mov    0x8(%eax),%eax
  80222f:	39 c2                	cmp    %eax,%edx
  802231:	76 14                	jbe    802247 <insert_sorted_allocList+0x42>
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	8b 50 08             	mov    0x8(%eax),%edx
  802239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223c:	8b 40 08             	mov    0x8(%eax),%eax
  80223f:	39 c2                	cmp    %eax,%edx
  802241:	0f 82 60 01 00 00    	jb     8023a7 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802247:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80224b:	75 65                	jne    8022b2 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80224d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802251:	75 14                	jne    802267 <insert_sorted_allocList+0x62>
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	68 34 41 80 00       	push   $0x804134
  80225b:	6a 6b                	push   $0x6b
  80225d:	68 57 41 80 00       	push   $0x804157
  802262:	e8 22 13 00 00       	call   803589 <_panic>
  802267:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
  802270:	89 10                	mov    %edx,(%eax)
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	8b 00                	mov    (%eax),%eax
  802277:	85 c0                	test   %eax,%eax
  802279:	74 0d                	je     802288 <insert_sorted_allocList+0x83>
  80227b:	a1 40 50 80 00       	mov    0x805040,%eax
  802280:	8b 55 08             	mov    0x8(%ebp),%edx
  802283:	89 50 04             	mov    %edx,0x4(%eax)
  802286:	eb 08                	jmp    802290 <insert_sorted_allocList+0x8b>
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	a3 44 50 80 00       	mov    %eax,0x805044
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	a3 40 50 80 00       	mov    %eax,0x805040
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022a7:	40                   	inc    %eax
  8022a8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022ad:	e9 dc 01 00 00       	jmp    80248e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	8b 50 08             	mov    0x8(%eax),%edx
  8022b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bb:	8b 40 08             	mov    0x8(%eax),%eax
  8022be:	39 c2                	cmp    %eax,%edx
  8022c0:	77 6c                	ja     80232e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022c6:	74 06                	je     8022ce <insert_sorted_allocList+0xc9>
  8022c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022cc:	75 14                	jne    8022e2 <insert_sorted_allocList+0xdd>
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	68 70 41 80 00       	push   $0x804170
  8022d6:	6a 6f                	push   $0x6f
  8022d8:	68 57 41 80 00       	push   $0x804157
  8022dd:	e8 a7 12 00 00       	call   803589 <_panic>
  8022e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e5:	8b 50 04             	mov    0x4(%eax),%edx
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	89 50 04             	mov    %edx,0x4(%eax)
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f4:	89 10                	mov    %edx,(%eax)
  8022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f9:	8b 40 04             	mov    0x4(%eax),%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	74 0d                	je     80230d <insert_sorted_allocList+0x108>
  802300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802303:	8b 40 04             	mov    0x4(%eax),%eax
  802306:	8b 55 08             	mov    0x8(%ebp),%edx
  802309:	89 10                	mov    %edx,(%eax)
  80230b:	eb 08                	jmp    802315 <insert_sorted_allocList+0x110>
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	a3 40 50 80 00       	mov    %eax,0x805040
  802315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802318:	8b 55 08             	mov    0x8(%ebp),%edx
  80231b:	89 50 04             	mov    %edx,0x4(%eax)
  80231e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802323:	40                   	inc    %eax
  802324:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802329:	e9 60 01 00 00       	jmp    80248e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	8b 50 08             	mov    0x8(%eax),%edx
  802334:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802337:	8b 40 08             	mov    0x8(%eax),%eax
  80233a:	39 c2                	cmp    %eax,%edx
  80233c:	0f 82 4c 01 00 00    	jb     80248e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802342:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802346:	75 14                	jne    80235c <insert_sorted_allocList+0x157>
  802348:	83 ec 04             	sub    $0x4,%esp
  80234b:	68 a8 41 80 00       	push   $0x8041a8
  802350:	6a 73                	push   $0x73
  802352:	68 57 41 80 00       	push   $0x804157
  802357:	e8 2d 12 00 00       	call   803589 <_panic>
  80235c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	89 50 04             	mov    %edx,0x4(%eax)
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	8b 40 04             	mov    0x4(%eax),%eax
  80236e:	85 c0                	test   %eax,%eax
  802370:	74 0c                	je     80237e <insert_sorted_allocList+0x179>
  802372:	a1 44 50 80 00       	mov    0x805044,%eax
  802377:	8b 55 08             	mov    0x8(%ebp),%edx
  80237a:	89 10                	mov    %edx,(%eax)
  80237c:	eb 08                	jmp    802386 <insert_sorted_allocList+0x181>
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	a3 40 50 80 00       	mov    %eax,0x805040
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	a3 44 50 80 00       	mov    %eax,0x805044
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802397:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80239c:	40                   	inc    %eax
  80239d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023a2:	e9 e7 00 00 00       	jmp    80248e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023ad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023b4:	a1 40 50 80 00       	mov    0x805040,%eax
  8023b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bc:	e9 9d 00 00 00       	jmp    80245e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 00                	mov    (%eax),%eax
  8023c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	8b 50 08             	mov    0x8(%eax),%edx
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 40 08             	mov    0x8(%eax),%eax
  8023d5:	39 c2                	cmp    %eax,%edx
  8023d7:	76 7d                	jbe    802456 <insert_sorted_allocList+0x251>
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	8b 50 08             	mov    0x8(%eax),%edx
  8023df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023e2:	8b 40 08             	mov    0x8(%eax),%eax
  8023e5:	39 c2                	cmp    %eax,%edx
  8023e7:	73 6d                	jae    802456 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ed:	74 06                	je     8023f5 <insert_sorted_allocList+0x1f0>
  8023ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f3:	75 14                	jne    802409 <insert_sorted_allocList+0x204>
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	68 cc 41 80 00       	push   $0x8041cc
  8023fd:	6a 7f                	push   $0x7f
  8023ff:	68 57 41 80 00       	push   $0x804157
  802404:	e8 80 11 00 00       	call   803589 <_panic>
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	8b 10                	mov    (%eax),%edx
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	89 10                	mov    %edx,(%eax)
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	8b 00                	mov    (%eax),%eax
  802418:	85 c0                	test   %eax,%eax
  80241a:	74 0b                	je     802427 <insert_sorted_allocList+0x222>
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	8b 55 08             	mov    0x8(%ebp),%edx
  802424:	89 50 04             	mov    %edx,0x4(%eax)
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 55 08             	mov    0x8(%ebp),%edx
  80242d:	89 10                	mov    %edx,(%eax)
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802435:	89 50 04             	mov    %edx,0x4(%eax)
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	85 c0                	test   %eax,%eax
  80243f:	75 08                	jne    802449 <insert_sorted_allocList+0x244>
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	a3 44 50 80 00       	mov    %eax,0x805044
  802449:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80244e:	40                   	inc    %eax
  80244f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802454:	eb 39                	jmp    80248f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802456:	a1 48 50 80 00       	mov    0x805048,%eax
  80245b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802462:	74 07                	je     80246b <insert_sorted_allocList+0x266>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	eb 05                	jmp    802470 <insert_sorted_allocList+0x26b>
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
  802470:	a3 48 50 80 00       	mov    %eax,0x805048
  802475:	a1 48 50 80 00       	mov    0x805048,%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	0f 85 3f ff ff ff    	jne    8023c1 <insert_sorted_allocList+0x1bc>
  802482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802486:	0f 85 35 ff ff ff    	jne    8023c1 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80248c:	eb 01                	jmp    80248f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80248e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80248f:	90                   	nop
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802498:	a1 38 51 80 00       	mov    0x805138,%eax
  80249d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a0:	e9 85 01 00 00       	jmp    80262a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ae:	0f 82 6e 01 00 00    	jb     802622 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024bd:	0f 85 8a 00 00 00    	jne    80254d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c7:	75 17                	jne    8024e0 <alloc_block_FF+0x4e>
  8024c9:	83 ec 04             	sub    $0x4,%esp
  8024cc:	68 00 42 80 00       	push   $0x804200
  8024d1:	68 93 00 00 00       	push   $0x93
  8024d6:	68 57 41 80 00       	push   $0x804157
  8024db:	e8 a9 10 00 00       	call   803589 <_panic>
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 00                	mov    (%eax),%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	74 10                	je     8024f9 <alloc_block_FF+0x67>
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 00                	mov    (%eax),%eax
  8024ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f1:	8b 52 04             	mov    0x4(%edx),%edx
  8024f4:	89 50 04             	mov    %edx,0x4(%eax)
  8024f7:	eb 0b                	jmp    802504 <alloc_block_FF+0x72>
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 40 04             	mov    0x4(%eax),%eax
  8024ff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 40 04             	mov    0x4(%eax),%eax
  80250a:	85 c0                	test   %eax,%eax
  80250c:	74 0f                	je     80251d <alloc_block_FF+0x8b>
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 40 04             	mov    0x4(%eax),%eax
  802514:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802517:	8b 12                	mov    (%edx),%edx
  802519:	89 10                	mov    %edx,(%eax)
  80251b:	eb 0a                	jmp    802527 <alloc_block_FF+0x95>
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	a3 38 51 80 00       	mov    %eax,0x805138
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253a:	a1 44 51 80 00       	mov    0x805144,%eax
  80253f:	48                   	dec    %eax
  802540:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	e9 10 01 00 00       	jmp    80265d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 40 0c             	mov    0xc(%eax),%eax
  802553:	3b 45 08             	cmp    0x8(%ebp),%eax
  802556:	0f 86 c6 00 00 00    	jbe    802622 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80255c:	a1 48 51 80 00       	mov    0x805148,%eax
  802561:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 50 08             	mov    0x8(%eax),%edx
  80256a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802573:	8b 55 08             	mov    0x8(%ebp),%edx
  802576:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802579:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80257d:	75 17                	jne    802596 <alloc_block_FF+0x104>
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	68 00 42 80 00       	push   $0x804200
  802587:	68 9b 00 00 00       	push   $0x9b
  80258c:	68 57 41 80 00       	push   $0x804157
  802591:	e8 f3 0f 00 00       	call   803589 <_panic>
  802596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	85 c0                	test   %eax,%eax
  80259d:	74 10                	je     8025af <alloc_block_FF+0x11d>
  80259f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a7:	8b 52 04             	mov    0x4(%edx),%edx
  8025aa:	89 50 04             	mov    %edx,0x4(%eax)
  8025ad:	eb 0b                	jmp    8025ba <alloc_block_FF+0x128>
  8025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b2:	8b 40 04             	mov    0x4(%eax),%eax
  8025b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bd:	8b 40 04             	mov    0x4(%eax),%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	74 0f                	je     8025d3 <alloc_block_FF+0x141>
  8025c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025cd:	8b 12                	mov    (%edx),%edx
  8025cf:	89 10                	mov    %edx,(%eax)
  8025d1:	eb 0a                	jmp    8025dd <alloc_block_FF+0x14b>
  8025d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8025dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8025f5:	48                   	dec    %eax
  8025f6:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 50 08             	mov    0x8(%eax),%edx
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	01 c2                	add    %eax,%edx
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 40 0c             	mov    0xc(%eax),%eax
  802612:	2b 45 08             	sub    0x8(%ebp),%eax
  802615:	89 c2                	mov    %eax,%edx
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80261d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802620:	eb 3b                	jmp    80265d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802622:	a1 40 51 80 00       	mov    0x805140,%eax
  802627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262e:	74 07                	je     802637 <alloc_block_FF+0x1a5>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	eb 05                	jmp    80263c <alloc_block_FF+0x1aa>
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
  80263c:	a3 40 51 80 00       	mov    %eax,0x805140
  802641:	a1 40 51 80 00       	mov    0x805140,%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	0f 85 57 fe ff ff    	jne    8024a5 <alloc_block_FF+0x13>
  80264e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802652:	0f 85 4d fe ff ff    	jne    8024a5 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802658:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265d:	c9                   	leave  
  80265e:	c3                   	ret    

0080265f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80265f:	55                   	push   %ebp
  802660:	89 e5                	mov    %esp,%ebp
  802662:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802665:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80266c:	a1 38 51 80 00       	mov    0x805138,%eax
  802671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802674:	e9 df 00 00 00       	jmp    802758 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 40 0c             	mov    0xc(%eax),%eax
  80267f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802682:	0f 82 c8 00 00 00    	jb     802750 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 40 0c             	mov    0xc(%eax),%eax
  80268e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802691:	0f 85 8a 00 00 00    	jne    802721 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269b:	75 17                	jne    8026b4 <alloc_block_BF+0x55>
  80269d:	83 ec 04             	sub    $0x4,%esp
  8026a0:	68 00 42 80 00       	push   $0x804200
  8026a5:	68 b7 00 00 00       	push   $0xb7
  8026aa:	68 57 41 80 00       	push   $0x804157
  8026af:	e8 d5 0e 00 00       	call   803589 <_panic>
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	8b 00                	mov    (%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 10                	je     8026cd <alloc_block_BF+0x6e>
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c5:	8b 52 04             	mov    0x4(%edx),%edx
  8026c8:	89 50 04             	mov    %edx,0x4(%eax)
  8026cb:	eb 0b                	jmp    8026d8 <alloc_block_BF+0x79>
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 40 04             	mov    0x4(%eax),%eax
  8026d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 40 04             	mov    0x4(%eax),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	74 0f                	je     8026f1 <alloc_block_BF+0x92>
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 40 04             	mov    0x4(%eax),%eax
  8026e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026eb:	8b 12                	mov    (%edx),%edx
  8026ed:	89 10                	mov    %edx,(%eax)
  8026ef:	eb 0a                	jmp    8026fb <alloc_block_BF+0x9c>
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 00                	mov    (%eax),%eax
  8026f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270e:	a1 44 51 80 00       	mov    0x805144,%eax
  802713:	48                   	dec    %eax
  802714:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	e9 4d 01 00 00       	jmp    80286e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 40 0c             	mov    0xc(%eax),%eax
  802727:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272a:	76 24                	jbe    802750 <alloc_block_BF+0xf1>
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 0c             	mov    0xc(%eax),%eax
  802732:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802735:	73 19                	jae    802750 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802737:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	8b 40 0c             	mov    0xc(%eax),%eax
  802744:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 40 08             	mov    0x8(%eax),%eax
  80274d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802750:	a1 40 51 80 00       	mov    0x805140,%eax
  802755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275c:	74 07                	je     802765 <alloc_block_BF+0x106>
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	eb 05                	jmp    80276a <alloc_block_BF+0x10b>
  802765:	b8 00 00 00 00       	mov    $0x0,%eax
  80276a:	a3 40 51 80 00       	mov    %eax,0x805140
  80276f:	a1 40 51 80 00       	mov    0x805140,%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	0f 85 fd fe ff ff    	jne    802679 <alloc_block_BF+0x1a>
  80277c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802780:	0f 85 f3 fe ff ff    	jne    802679 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802786:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80278a:	0f 84 d9 00 00 00    	je     802869 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802790:	a1 48 51 80 00       	mov    0x805148,%eax
  802795:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80279e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a7:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027ae:	75 17                	jne    8027c7 <alloc_block_BF+0x168>
  8027b0:	83 ec 04             	sub    $0x4,%esp
  8027b3:	68 00 42 80 00       	push   $0x804200
  8027b8:	68 c7 00 00 00       	push   $0xc7
  8027bd:	68 57 41 80 00       	push   $0x804157
  8027c2:	e8 c2 0d 00 00       	call   803589 <_panic>
  8027c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	85 c0                	test   %eax,%eax
  8027ce:	74 10                	je     8027e0 <alloc_block_BF+0x181>
  8027d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d3:	8b 00                	mov    (%eax),%eax
  8027d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d8:	8b 52 04             	mov    0x4(%edx),%edx
  8027db:	89 50 04             	mov    %edx,0x4(%eax)
  8027de:	eb 0b                	jmp    8027eb <alloc_block_BF+0x18c>
  8027e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e3:	8b 40 04             	mov    0x4(%eax),%eax
  8027e6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ee:	8b 40 04             	mov    0x4(%eax),%eax
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	74 0f                	je     802804 <alloc_block_BF+0x1a5>
  8027f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027fe:	8b 12                	mov    (%edx),%edx
  802800:	89 10                	mov    %edx,(%eax)
  802802:	eb 0a                	jmp    80280e <alloc_block_BF+0x1af>
  802804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802807:	8b 00                	mov    (%eax),%eax
  802809:	a3 48 51 80 00       	mov    %eax,0x805148
  80280e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802811:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802821:	a1 54 51 80 00       	mov    0x805154,%eax
  802826:	48                   	dec    %eax
  802827:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80282c:	83 ec 08             	sub    $0x8,%esp
  80282f:	ff 75 ec             	pushl  -0x14(%ebp)
  802832:	68 38 51 80 00       	push   $0x805138
  802837:	e8 71 f9 ff ff       	call   8021ad <find_block>
  80283c:	83 c4 10             	add    $0x10,%esp
  80283f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802842:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802845:	8b 50 08             	mov    0x8(%eax),%edx
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	01 c2                	add    %eax,%edx
  80284d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802850:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802856:	8b 40 0c             	mov    0xc(%eax),%eax
  802859:	2b 45 08             	sub    0x8(%ebp),%eax
  80285c:	89 c2                	mov    %eax,%edx
  80285e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802861:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802867:	eb 05                	jmp    80286e <alloc_block_BF+0x20f>
	}
	return NULL;
  802869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80286e:	c9                   	leave  
  80286f:	c3                   	ret    

00802870 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
  802873:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802876:	a1 28 50 80 00       	mov    0x805028,%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	0f 85 de 01 00 00    	jne    802a61 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802883:	a1 38 51 80 00       	mov    0x805138,%eax
  802888:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288b:	e9 9e 01 00 00       	jmp    802a2e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 0c             	mov    0xc(%eax),%eax
  802896:	3b 45 08             	cmp    0x8(%ebp),%eax
  802899:	0f 82 87 01 00 00    	jb     802a26 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a8:	0f 85 95 00 00 00    	jne    802943 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b2:	75 17                	jne    8028cb <alloc_block_NF+0x5b>
  8028b4:	83 ec 04             	sub    $0x4,%esp
  8028b7:	68 00 42 80 00       	push   $0x804200
  8028bc:	68 e0 00 00 00       	push   $0xe0
  8028c1:	68 57 41 80 00       	push   $0x804157
  8028c6:	e8 be 0c 00 00       	call   803589 <_panic>
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 00                	mov    (%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 10                	je     8028e4 <alloc_block_NF+0x74>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028dc:	8b 52 04             	mov    0x4(%edx),%edx
  8028df:	89 50 04             	mov    %edx,0x4(%eax)
  8028e2:	eb 0b                	jmp    8028ef <alloc_block_NF+0x7f>
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0f                	je     802908 <alloc_block_NF+0x98>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 40 04             	mov    0x4(%eax),%eax
  8028ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802902:	8b 12                	mov    (%edx),%edx
  802904:	89 10                	mov    %edx,(%eax)
  802906:	eb 0a                	jmp    802912 <alloc_block_NF+0xa2>
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
				   svaOfNF = point->sva;
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 40 08             	mov    0x8(%eax),%eax
  802936:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	e9 f8 04 00 00       	jmp    802e3b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 40 0c             	mov    0xc(%eax),%eax
  802949:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294c:	0f 86 d4 00 00 00    	jbe    802a26 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802952:	a1 48 51 80 00       	mov    0x805148,%eax
  802957:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 50 08             	mov    0x8(%eax),%edx
  802960:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802963:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802969:	8b 55 08             	mov    0x8(%ebp),%edx
  80296c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80296f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802973:	75 17                	jne    80298c <alloc_block_NF+0x11c>
  802975:	83 ec 04             	sub    $0x4,%esp
  802978:	68 00 42 80 00       	push   $0x804200
  80297d:	68 e9 00 00 00       	push   $0xe9
  802982:	68 57 41 80 00       	push   $0x804157
  802987:	e8 fd 0b 00 00       	call   803589 <_panic>
  80298c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298f:	8b 00                	mov    (%eax),%eax
  802991:	85 c0                	test   %eax,%eax
  802993:	74 10                	je     8029a5 <alloc_block_NF+0x135>
  802995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802998:	8b 00                	mov    (%eax),%eax
  80299a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80299d:	8b 52 04             	mov    0x4(%edx),%edx
  8029a0:	89 50 04             	mov    %edx,0x4(%eax)
  8029a3:	eb 0b                	jmp    8029b0 <alloc_block_NF+0x140>
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	8b 40 04             	mov    0x4(%eax),%eax
  8029ab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b3:	8b 40 04             	mov    0x4(%eax),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	74 0f                	je     8029c9 <alloc_block_NF+0x159>
  8029ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bd:	8b 40 04             	mov    0x4(%eax),%eax
  8029c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c3:	8b 12                	mov    (%edx),%edx
  8029c5:	89 10                	mov    %edx,(%eax)
  8029c7:	eb 0a                	jmp    8029d3 <alloc_block_NF+0x163>
  8029c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cc:	8b 00                	mov    (%eax),%eax
  8029ce:	a3 48 51 80 00       	mov    %eax,0x805148
  8029d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8029eb:	48                   	dec    %eax
  8029ec:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f4:	8b 40 08             	mov    0x8(%eax),%eax
  8029f7:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 50 08             	mov    0x8(%eax),%edx
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	01 c2                	add    %eax,%edx
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 40 0c             	mov    0xc(%eax),%eax
  802a13:	2b 45 08             	sub    0x8(%ebp),%eax
  802a16:	89 c2                	mov    %eax,%edx
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a21:	e9 15 04 00 00       	jmp    802e3b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a26:	a1 40 51 80 00       	mov    0x805140,%eax
  802a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a32:	74 07                	je     802a3b <alloc_block_NF+0x1cb>
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 00                	mov    (%eax),%eax
  802a39:	eb 05                	jmp    802a40 <alloc_block_NF+0x1d0>
  802a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a40:	a3 40 51 80 00       	mov    %eax,0x805140
  802a45:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	0f 85 3e fe ff ff    	jne    802890 <alloc_block_NF+0x20>
  802a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a56:	0f 85 34 fe ff ff    	jne    802890 <alloc_block_NF+0x20>
  802a5c:	e9 d5 03 00 00       	jmp    802e36 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a61:	a1 38 51 80 00       	mov    0x805138,%eax
  802a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a69:	e9 b1 01 00 00       	jmp    802c1f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	8b 50 08             	mov    0x8(%eax),%edx
  802a74:	a1 28 50 80 00       	mov    0x805028,%eax
  802a79:	39 c2                	cmp    %eax,%edx
  802a7b:	0f 82 96 01 00 00    	jb     802c17 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 0c             	mov    0xc(%eax),%eax
  802a87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8a:	0f 82 87 01 00 00    	jb     802c17 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 0c             	mov    0xc(%eax),%eax
  802a96:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a99:	0f 85 95 00 00 00    	jne    802b34 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa3:	75 17                	jne    802abc <alloc_block_NF+0x24c>
  802aa5:	83 ec 04             	sub    $0x4,%esp
  802aa8:	68 00 42 80 00       	push   $0x804200
  802aad:	68 fc 00 00 00       	push   $0xfc
  802ab2:	68 57 41 80 00       	push   $0x804157
  802ab7:	e8 cd 0a 00 00       	call   803589 <_panic>
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	8b 00                	mov    (%eax),%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	74 10                	je     802ad5 <alloc_block_NF+0x265>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acd:	8b 52 04             	mov    0x4(%edx),%edx
  802ad0:	89 50 04             	mov    %edx,0x4(%eax)
  802ad3:	eb 0b                	jmp    802ae0 <alloc_block_NF+0x270>
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 40 04             	mov    0x4(%eax),%eax
  802adb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 04             	mov    0x4(%eax),%eax
  802ae6:	85 c0                	test   %eax,%eax
  802ae8:	74 0f                	je     802af9 <alloc_block_NF+0x289>
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 40 04             	mov    0x4(%eax),%eax
  802af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af3:	8b 12                	mov    (%edx),%edx
  802af5:	89 10                	mov    %edx,(%eax)
  802af7:	eb 0a                	jmp    802b03 <alloc_block_NF+0x293>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 00                	mov    (%eax),%eax
  802afe:	a3 38 51 80 00       	mov    %eax,0x805138
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b16:	a1 44 51 80 00       	mov    0x805144,%eax
  802b1b:	48                   	dec    %eax
  802b1c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 40 08             	mov    0x8(%eax),%eax
  802b27:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	e9 07 03 00 00       	jmp    802e3b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3d:	0f 86 d4 00 00 00    	jbe    802c17 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b43:	a1 48 51 80 00       	mov    0x805148,%eax
  802b48:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 50 08             	mov    0x8(%eax),%edx
  802b51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b54:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b60:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b64:	75 17                	jne    802b7d <alloc_block_NF+0x30d>
  802b66:	83 ec 04             	sub    $0x4,%esp
  802b69:	68 00 42 80 00       	push   $0x804200
  802b6e:	68 04 01 00 00       	push   $0x104
  802b73:	68 57 41 80 00       	push   $0x804157
  802b78:	e8 0c 0a 00 00       	call   803589 <_panic>
  802b7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b80:	8b 00                	mov    (%eax),%eax
  802b82:	85 c0                	test   %eax,%eax
  802b84:	74 10                	je     802b96 <alloc_block_NF+0x326>
  802b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b89:	8b 00                	mov    (%eax),%eax
  802b8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b8e:	8b 52 04             	mov    0x4(%edx),%edx
  802b91:	89 50 04             	mov    %edx,0x4(%eax)
  802b94:	eb 0b                	jmp    802ba1 <alloc_block_NF+0x331>
  802b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b99:	8b 40 04             	mov    0x4(%eax),%eax
  802b9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba4:	8b 40 04             	mov    0x4(%eax),%eax
  802ba7:	85 c0                	test   %eax,%eax
  802ba9:	74 0f                	je     802bba <alloc_block_NF+0x34a>
  802bab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bae:	8b 40 04             	mov    0x4(%eax),%eax
  802bb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb4:	8b 12                	mov    (%edx),%edx
  802bb6:	89 10                	mov    %edx,(%eax)
  802bb8:	eb 0a                	jmp    802bc4 <alloc_block_NF+0x354>
  802bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbd:	8b 00                	mov    (%eax),%eax
  802bbf:	a3 48 51 80 00       	mov    %eax,0x805148
  802bc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd7:	a1 54 51 80 00       	mov    0x805154,%eax
  802bdc:	48                   	dec    %eax
  802bdd:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be5:	8b 40 08             	mov    0x8(%eax),%eax
  802be8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 50 08             	mov    0x8(%eax),%edx
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	01 c2                	add    %eax,%edx
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 40 0c             	mov    0xc(%eax),%eax
  802c04:	2b 45 08             	sub    0x8(%ebp),%eax
  802c07:	89 c2                	mov    %eax,%edx
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c12:	e9 24 02 00 00       	jmp    802e3b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c17:	a1 40 51 80 00       	mov    0x805140,%eax
  802c1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c23:	74 07                	je     802c2c <alloc_block_NF+0x3bc>
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	eb 05                	jmp    802c31 <alloc_block_NF+0x3c1>
  802c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c31:	a3 40 51 80 00       	mov    %eax,0x805140
  802c36:	a1 40 51 80 00       	mov    0x805140,%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	0f 85 2b fe ff ff    	jne    802a6e <alloc_block_NF+0x1fe>
  802c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c47:	0f 85 21 fe ff ff    	jne    802a6e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c55:	e9 ae 01 00 00       	jmp    802e08 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 50 08             	mov    0x8(%eax),%edx
  802c60:	a1 28 50 80 00       	mov    0x805028,%eax
  802c65:	39 c2                	cmp    %eax,%edx
  802c67:	0f 83 93 01 00 00    	jae    802e00 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 0c             	mov    0xc(%eax),%eax
  802c73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c76:	0f 82 84 01 00 00    	jb     802e00 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c82:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c85:	0f 85 95 00 00 00    	jne    802d20 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8f:	75 17                	jne    802ca8 <alloc_block_NF+0x438>
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 00 42 80 00       	push   $0x804200
  802c99:	68 14 01 00 00       	push   $0x114
  802c9e:	68 57 41 80 00       	push   $0x804157
  802ca3:	e8 e1 08 00 00       	call   803589 <_panic>
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 10                	je     802cc1 <alloc_block_NF+0x451>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb9:	8b 52 04             	mov    0x4(%edx),%edx
  802cbc:	89 50 04             	mov    %edx,0x4(%eax)
  802cbf:	eb 0b                	jmp    802ccc <alloc_block_NF+0x45c>
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 40 04             	mov    0x4(%eax),%eax
  802cc7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	74 0f                	je     802ce5 <alloc_block_NF+0x475>
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 40 04             	mov    0x4(%eax),%eax
  802cdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdf:	8b 12                	mov    (%edx),%edx
  802ce1:	89 10                	mov    %edx,(%eax)
  802ce3:	eb 0a                	jmp    802cef <alloc_block_NF+0x47f>
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	a3 38 51 80 00       	mov    %eax,0x805138
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d02:	a1 44 51 80 00       	mov    0x805144,%eax
  802d07:	48                   	dec    %eax
  802d08:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	8b 40 08             	mov    0x8(%eax),%eax
  802d13:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	e9 1b 01 00 00       	jmp    802e3b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 40 0c             	mov    0xc(%eax),%eax
  802d26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d29:	0f 86 d1 00 00 00    	jbe    802e00 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d2f:	a1 48 51 80 00       	mov    0x805148,%eax
  802d34:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 50 08             	mov    0x8(%eax),%edx
  802d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d40:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d46:	8b 55 08             	mov    0x8(%ebp),%edx
  802d49:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d50:	75 17                	jne    802d69 <alloc_block_NF+0x4f9>
  802d52:	83 ec 04             	sub    $0x4,%esp
  802d55:	68 00 42 80 00       	push   $0x804200
  802d5a:	68 1c 01 00 00       	push   $0x11c
  802d5f:	68 57 41 80 00       	push   $0x804157
  802d64:	e8 20 08 00 00       	call   803589 <_panic>
  802d69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6c:	8b 00                	mov    (%eax),%eax
  802d6e:	85 c0                	test   %eax,%eax
  802d70:	74 10                	je     802d82 <alloc_block_NF+0x512>
  802d72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d7a:	8b 52 04             	mov    0x4(%edx),%edx
  802d7d:	89 50 04             	mov    %edx,0x4(%eax)
  802d80:	eb 0b                	jmp    802d8d <alloc_block_NF+0x51d>
  802d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d85:	8b 40 04             	mov    0x4(%eax),%eax
  802d88:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d90:	8b 40 04             	mov    0x4(%eax),%eax
  802d93:	85 c0                	test   %eax,%eax
  802d95:	74 0f                	je     802da6 <alloc_block_NF+0x536>
  802d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9a:	8b 40 04             	mov    0x4(%eax),%eax
  802d9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802da0:	8b 12                	mov    (%edx),%edx
  802da2:	89 10                	mov    %edx,(%eax)
  802da4:	eb 0a                	jmp    802db0 <alloc_block_NF+0x540>
  802da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da9:	8b 00                	mov    (%eax),%eax
  802dab:	a3 48 51 80 00       	mov    %eax,0x805148
  802db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc3:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc8:	48                   	dec    %eax
  802dc9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	8b 40 08             	mov    0x8(%eax),%eax
  802dd4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 50 08             	mov    0x8(%eax),%edx
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	01 c2                	add    %eax,%edx
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 40 0c             	mov    0xc(%eax),%eax
  802df0:	2b 45 08             	sub    0x8(%ebp),%eax
  802df3:	89 c2                	mov    %eax,%edx
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfe:	eb 3b                	jmp    802e3b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e00:	a1 40 51 80 00       	mov    0x805140,%eax
  802e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0c:	74 07                	je     802e15 <alloc_block_NF+0x5a5>
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 00                	mov    (%eax),%eax
  802e13:	eb 05                	jmp    802e1a <alloc_block_NF+0x5aa>
  802e15:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1a:	a3 40 51 80 00       	mov    %eax,0x805140
  802e1f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	0f 85 2e fe ff ff    	jne    802c5a <alloc_block_NF+0x3ea>
  802e2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e30:	0f 85 24 fe ff ff    	jne    802c5a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e3b:	c9                   	leave  
  802e3c:	c3                   	ret    

00802e3d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e3d:	55                   	push   %ebp
  802e3e:	89 e5                	mov    %esp,%ebp
  802e40:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e43:	a1 38 51 80 00       	mov    0x805138,%eax
  802e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e4b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e50:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e53:	a1 38 51 80 00       	mov    0x805138,%eax
  802e58:	85 c0                	test   %eax,%eax
  802e5a:	74 14                	je     802e70 <insert_sorted_with_merge_freeList+0x33>
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 50 08             	mov    0x8(%eax),%edx
  802e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e65:	8b 40 08             	mov    0x8(%eax),%eax
  802e68:	39 c2                	cmp    %eax,%edx
  802e6a:	0f 87 9b 01 00 00    	ja     80300b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e74:	75 17                	jne    802e8d <insert_sorted_with_merge_freeList+0x50>
  802e76:	83 ec 04             	sub    $0x4,%esp
  802e79:	68 34 41 80 00       	push   $0x804134
  802e7e:	68 38 01 00 00       	push   $0x138
  802e83:	68 57 41 80 00       	push   $0x804157
  802e88:	e8 fc 06 00 00       	call   803589 <_panic>
  802e8d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	89 10                	mov    %edx,(%eax)
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	85 c0                	test   %eax,%eax
  802e9f:	74 0d                	je     802eae <insert_sorted_with_merge_freeList+0x71>
  802ea1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea9:	89 50 04             	mov    %edx,0x4(%eax)
  802eac:	eb 08                	jmp    802eb6 <insert_sorted_with_merge_freeList+0x79>
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	a3 38 51 80 00       	mov    %eax,0x805138
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec8:	a1 44 51 80 00       	mov    0x805144,%eax
  802ecd:	40                   	inc    %eax
  802ece:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ed3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed7:	0f 84 a8 06 00 00    	je     803585 <insert_sorted_with_merge_freeList+0x748>
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	8b 50 08             	mov    0x8(%eax),%edx
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee9:	01 c2                	add    %eax,%edx
  802eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eee:	8b 40 08             	mov    0x8(%eax),%eax
  802ef1:	39 c2                	cmp    %eax,%edx
  802ef3:	0f 85 8c 06 00 00    	jne    803585 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	8b 50 0c             	mov    0xc(%eax),%edx
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	8b 40 0c             	mov    0xc(%eax),%eax
  802f05:	01 c2                	add    %eax,%edx
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f11:	75 17                	jne    802f2a <insert_sorted_with_merge_freeList+0xed>
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 00 42 80 00       	push   $0x804200
  802f1b:	68 3c 01 00 00       	push   $0x13c
  802f20:	68 57 41 80 00       	push   $0x804157
  802f25:	e8 5f 06 00 00       	call   803589 <_panic>
  802f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 10                	je     802f43 <insert_sorted_with_merge_freeList+0x106>
  802f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f3b:	8b 52 04             	mov    0x4(%edx),%edx
  802f3e:	89 50 04             	mov    %edx,0x4(%eax)
  802f41:	eb 0b                	jmp    802f4e <insert_sorted_with_merge_freeList+0x111>
  802f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f46:	8b 40 04             	mov    0x4(%eax),%eax
  802f49:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	74 0f                	je     802f67 <insert_sorted_with_merge_freeList+0x12a>
  802f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f61:	8b 12                	mov    (%edx),%edx
  802f63:	89 10                	mov    %edx,(%eax)
  802f65:	eb 0a                	jmp    802f71 <insert_sorted_with_merge_freeList+0x134>
  802f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f84:	a1 44 51 80 00       	mov    0x805144,%eax
  802f89:	48                   	dec    %eax
  802f8a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f92:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fa3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fa7:	75 17                	jne    802fc0 <insert_sorted_with_merge_freeList+0x183>
  802fa9:	83 ec 04             	sub    $0x4,%esp
  802fac:	68 34 41 80 00       	push   $0x804134
  802fb1:	68 3f 01 00 00       	push   $0x13f
  802fb6:	68 57 41 80 00       	push   $0x804157
  802fbb:	e8 c9 05 00 00       	call   803589 <_panic>
  802fc0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc9:	89 10                	mov    %edx,(%eax)
  802fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fce:	8b 00                	mov    (%eax),%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	74 0d                	je     802fe1 <insert_sorted_with_merge_freeList+0x1a4>
  802fd4:	a1 48 51 80 00       	mov    0x805148,%eax
  802fd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fdc:	89 50 04             	mov    %edx,0x4(%eax)
  802fdf:	eb 08                	jmp    802fe9 <insert_sorted_with_merge_freeList+0x1ac>
  802fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fec:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffb:	a1 54 51 80 00       	mov    0x805154,%eax
  803000:	40                   	inc    %eax
  803001:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803006:	e9 7a 05 00 00       	jmp    803585 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	8b 50 08             	mov    0x8(%eax),%edx
  803011:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803014:	8b 40 08             	mov    0x8(%eax),%eax
  803017:	39 c2                	cmp    %eax,%edx
  803019:	0f 82 14 01 00 00    	jb     803133 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80301f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803022:	8b 50 08             	mov    0x8(%eax),%edx
  803025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803028:	8b 40 0c             	mov    0xc(%eax),%eax
  80302b:	01 c2                	add    %eax,%edx
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	8b 40 08             	mov    0x8(%eax),%eax
  803033:	39 c2                	cmp    %eax,%edx
  803035:	0f 85 90 00 00 00    	jne    8030cb <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80303b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303e:	8b 50 0c             	mov    0xc(%eax),%edx
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	8b 40 0c             	mov    0xc(%eax),%eax
  803047:	01 c2                	add    %eax,%edx
  803049:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803063:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803067:	75 17                	jne    803080 <insert_sorted_with_merge_freeList+0x243>
  803069:	83 ec 04             	sub    $0x4,%esp
  80306c:	68 34 41 80 00       	push   $0x804134
  803071:	68 49 01 00 00       	push   $0x149
  803076:	68 57 41 80 00       	push   $0x804157
  80307b:	e8 09 05 00 00       	call   803589 <_panic>
  803080:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	89 10                	mov    %edx,(%eax)
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	74 0d                	je     8030a1 <insert_sorted_with_merge_freeList+0x264>
  803094:	a1 48 51 80 00       	mov    0x805148,%eax
  803099:	8b 55 08             	mov    0x8(%ebp),%edx
  80309c:	89 50 04             	mov    %edx,0x4(%eax)
  80309f:	eb 08                	jmp    8030a9 <insert_sorted_with_merge_freeList+0x26c>
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c0:	40                   	inc    %eax
  8030c1:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030c6:	e9 bb 04 00 00       	jmp    803586 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030cf:	75 17                	jne    8030e8 <insert_sorted_with_merge_freeList+0x2ab>
  8030d1:	83 ec 04             	sub    $0x4,%esp
  8030d4:	68 a8 41 80 00       	push   $0x8041a8
  8030d9:	68 4c 01 00 00       	push   $0x14c
  8030de:	68 57 41 80 00       	push   $0x804157
  8030e3:	e8 a1 04 00 00       	call   803589 <_panic>
  8030e8:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	89 50 04             	mov    %edx,0x4(%eax)
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	85 c0                	test   %eax,%eax
  8030fc:	74 0c                	je     80310a <insert_sorted_with_merge_freeList+0x2cd>
  8030fe:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803103:	8b 55 08             	mov    0x8(%ebp),%edx
  803106:	89 10                	mov    %edx,(%eax)
  803108:	eb 08                	jmp    803112 <insert_sorted_with_merge_freeList+0x2d5>
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	a3 38 51 80 00       	mov    %eax,0x805138
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803123:	a1 44 51 80 00       	mov    0x805144,%eax
  803128:	40                   	inc    %eax
  803129:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80312e:	e9 53 04 00 00       	jmp    803586 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803133:	a1 38 51 80 00       	mov    0x805138,%eax
  803138:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313b:	e9 15 04 00 00       	jmp    803555 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	8b 50 08             	mov    0x8(%eax),%edx
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 40 08             	mov    0x8(%eax),%eax
  803154:	39 c2                	cmp    %eax,%edx
  803156:	0f 86 f1 03 00 00    	jbe    80354d <insert_sorted_with_merge_freeList+0x710>
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	8b 50 08             	mov    0x8(%eax),%edx
  803162:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803165:	8b 40 08             	mov    0x8(%eax),%eax
  803168:	39 c2                	cmp    %eax,%edx
  80316a:	0f 83 dd 03 00 00    	jae    80354d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803173:	8b 50 08             	mov    0x8(%eax),%edx
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	8b 40 0c             	mov    0xc(%eax),%eax
  80317c:	01 c2                	add    %eax,%edx
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	8b 40 08             	mov    0x8(%eax),%eax
  803184:	39 c2                	cmp    %eax,%edx
  803186:	0f 85 b9 01 00 00    	jne    803345 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	8b 50 08             	mov    0x8(%eax),%edx
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	8b 40 0c             	mov    0xc(%eax),%eax
  803198:	01 c2                	add    %eax,%edx
  80319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319d:	8b 40 08             	mov    0x8(%eax),%eax
  8031a0:	39 c2                	cmp    %eax,%edx
  8031a2:	0f 85 0d 01 00 00    	jne    8032b5 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b4:	01 c2                	add    %eax,%edx
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c0:	75 17                	jne    8031d9 <insert_sorted_with_merge_freeList+0x39c>
  8031c2:	83 ec 04             	sub    $0x4,%esp
  8031c5:	68 00 42 80 00       	push   $0x804200
  8031ca:	68 5c 01 00 00       	push   $0x15c
  8031cf:	68 57 41 80 00       	push   $0x804157
  8031d4:	e8 b0 03 00 00       	call   803589 <_panic>
  8031d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dc:	8b 00                	mov    (%eax),%eax
  8031de:	85 c0                	test   %eax,%eax
  8031e0:	74 10                	je     8031f2 <insert_sorted_with_merge_freeList+0x3b5>
  8031e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ea:	8b 52 04             	mov    0x4(%edx),%edx
  8031ed:	89 50 04             	mov    %edx,0x4(%eax)
  8031f0:	eb 0b                	jmp    8031fd <insert_sorted_with_merge_freeList+0x3c0>
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	8b 40 04             	mov    0x4(%eax),%eax
  8031f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803200:	8b 40 04             	mov    0x4(%eax),%eax
  803203:	85 c0                	test   %eax,%eax
  803205:	74 0f                	je     803216 <insert_sorted_with_merge_freeList+0x3d9>
  803207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320a:	8b 40 04             	mov    0x4(%eax),%eax
  80320d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803210:	8b 12                	mov    (%edx),%edx
  803212:	89 10                	mov    %edx,(%eax)
  803214:	eb 0a                	jmp    803220 <insert_sorted_with_merge_freeList+0x3e3>
  803216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803219:	8b 00                	mov    (%eax),%eax
  80321b:	a3 38 51 80 00       	mov    %eax,0x805138
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803229:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803233:	a1 44 51 80 00       	mov    0x805144,%eax
  803238:	48                   	dec    %eax
  803239:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80323e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803241:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803252:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803256:	75 17                	jne    80326f <insert_sorted_with_merge_freeList+0x432>
  803258:	83 ec 04             	sub    $0x4,%esp
  80325b:	68 34 41 80 00       	push   $0x804134
  803260:	68 5f 01 00 00       	push   $0x15f
  803265:	68 57 41 80 00       	push   $0x804157
  80326a:	e8 1a 03 00 00       	call   803589 <_panic>
  80326f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803275:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803278:	89 10                	mov    %edx,(%eax)
  80327a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	85 c0                	test   %eax,%eax
  803281:	74 0d                	je     803290 <insert_sorted_with_merge_freeList+0x453>
  803283:	a1 48 51 80 00       	mov    0x805148,%eax
  803288:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80328b:	89 50 04             	mov    %edx,0x4(%eax)
  80328e:	eb 08                	jmp    803298 <insert_sorted_with_merge_freeList+0x45b>
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329b:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8032af:	40                   	inc    %eax
  8032b0:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b8:	8b 50 0c             	mov    0xc(%eax),%edx
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c1:	01 c2                	add    %eax,%edx
  8032c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e1:	75 17                	jne    8032fa <insert_sorted_with_merge_freeList+0x4bd>
  8032e3:	83 ec 04             	sub    $0x4,%esp
  8032e6:	68 34 41 80 00       	push   $0x804134
  8032eb:	68 64 01 00 00       	push   $0x164
  8032f0:	68 57 41 80 00       	push   $0x804157
  8032f5:	e8 8f 02 00 00       	call   803589 <_panic>
  8032fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	89 10                	mov    %edx,(%eax)
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	85 c0                	test   %eax,%eax
  80330c:	74 0d                	je     80331b <insert_sorted_with_merge_freeList+0x4de>
  80330e:	a1 48 51 80 00       	mov    0x805148,%eax
  803313:	8b 55 08             	mov    0x8(%ebp),%edx
  803316:	89 50 04             	mov    %edx,0x4(%eax)
  803319:	eb 08                	jmp    803323 <insert_sorted_with_merge_freeList+0x4e6>
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	a3 48 51 80 00       	mov    %eax,0x805148
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803335:	a1 54 51 80 00       	mov    0x805154,%eax
  80333a:	40                   	inc    %eax
  80333b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803340:	e9 41 02 00 00       	jmp    803586 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	8b 50 08             	mov    0x8(%eax),%edx
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	8b 40 0c             	mov    0xc(%eax),%eax
  803351:	01 c2                	add    %eax,%edx
  803353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803356:	8b 40 08             	mov    0x8(%eax),%eax
  803359:	39 c2                	cmp    %eax,%edx
  80335b:	0f 85 7c 01 00 00    	jne    8034dd <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803361:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803365:	74 06                	je     80336d <insert_sorted_with_merge_freeList+0x530>
  803367:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336b:	75 17                	jne    803384 <insert_sorted_with_merge_freeList+0x547>
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	68 70 41 80 00       	push   $0x804170
  803375:	68 69 01 00 00       	push   $0x169
  80337a:	68 57 41 80 00       	push   $0x804157
  80337f:	e8 05 02 00 00       	call   803589 <_panic>
  803384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803387:	8b 50 04             	mov    0x4(%eax),%edx
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	89 50 04             	mov    %edx,0x4(%eax)
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803396:	89 10                	mov    %edx,(%eax)
  803398:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339b:	8b 40 04             	mov    0x4(%eax),%eax
  80339e:	85 c0                	test   %eax,%eax
  8033a0:	74 0d                	je     8033af <insert_sorted_with_merge_freeList+0x572>
  8033a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a5:	8b 40 04             	mov    0x4(%eax),%eax
  8033a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ab:	89 10                	mov    %edx,(%eax)
  8033ad:	eb 08                	jmp    8033b7 <insert_sorted_with_merge_freeList+0x57a>
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8033b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bd:	89 50 04             	mov    %edx,0x4(%eax)
  8033c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c5:	40                   	inc    %eax
  8033c6:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	8b 50 0c             	mov    0xc(%eax),%edx
  8033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d7:	01 c2                	add    %eax,%edx
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033e3:	75 17                	jne    8033fc <insert_sorted_with_merge_freeList+0x5bf>
  8033e5:	83 ec 04             	sub    $0x4,%esp
  8033e8:	68 00 42 80 00       	push   $0x804200
  8033ed:	68 6b 01 00 00       	push   $0x16b
  8033f2:	68 57 41 80 00       	push   $0x804157
  8033f7:	e8 8d 01 00 00       	call   803589 <_panic>
  8033fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ff:	8b 00                	mov    (%eax),%eax
  803401:	85 c0                	test   %eax,%eax
  803403:	74 10                	je     803415 <insert_sorted_with_merge_freeList+0x5d8>
  803405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803408:	8b 00                	mov    (%eax),%eax
  80340a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80340d:	8b 52 04             	mov    0x4(%edx),%edx
  803410:	89 50 04             	mov    %edx,0x4(%eax)
  803413:	eb 0b                	jmp    803420 <insert_sorted_with_merge_freeList+0x5e3>
  803415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803418:	8b 40 04             	mov    0x4(%eax),%eax
  80341b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803420:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803423:	8b 40 04             	mov    0x4(%eax),%eax
  803426:	85 c0                	test   %eax,%eax
  803428:	74 0f                	je     803439 <insert_sorted_with_merge_freeList+0x5fc>
  80342a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342d:	8b 40 04             	mov    0x4(%eax),%eax
  803430:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803433:	8b 12                	mov    (%edx),%edx
  803435:	89 10                	mov    %edx,(%eax)
  803437:	eb 0a                	jmp    803443 <insert_sorted_with_merge_freeList+0x606>
  803439:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343c:	8b 00                	mov    (%eax),%eax
  80343e:	a3 38 51 80 00       	mov    %eax,0x805138
  803443:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80344c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803456:	a1 44 51 80 00       	mov    0x805144,%eax
  80345b:	48                   	dec    %eax
  80345c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803464:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80346b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803475:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803479:	75 17                	jne    803492 <insert_sorted_with_merge_freeList+0x655>
  80347b:	83 ec 04             	sub    $0x4,%esp
  80347e:	68 34 41 80 00       	push   $0x804134
  803483:	68 6e 01 00 00       	push   $0x16e
  803488:	68 57 41 80 00       	push   $0x804157
  80348d:	e8 f7 00 00 00       	call   803589 <_panic>
  803492:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803498:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349b:	89 10                	mov    %edx,(%eax)
  80349d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a0:	8b 00                	mov    (%eax),%eax
  8034a2:	85 c0                	test   %eax,%eax
  8034a4:	74 0d                	je     8034b3 <insert_sorted_with_merge_freeList+0x676>
  8034a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8034ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034ae:	89 50 04             	mov    %edx,0x4(%eax)
  8034b1:	eb 08                	jmp    8034bb <insert_sorted_with_merge_freeList+0x67e>
  8034b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034be:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cd:	a1 54 51 80 00       	mov    0x805154,%eax
  8034d2:	40                   	inc    %eax
  8034d3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034d8:	e9 a9 00 00 00       	jmp    803586 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e1:	74 06                	je     8034e9 <insert_sorted_with_merge_freeList+0x6ac>
  8034e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034e7:	75 17                	jne    803500 <insert_sorted_with_merge_freeList+0x6c3>
  8034e9:	83 ec 04             	sub    $0x4,%esp
  8034ec:	68 cc 41 80 00       	push   $0x8041cc
  8034f1:	68 73 01 00 00       	push   $0x173
  8034f6:	68 57 41 80 00       	push   $0x804157
  8034fb:	e8 89 00 00 00       	call   803589 <_panic>
  803500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803503:	8b 10                	mov    (%eax),%edx
  803505:	8b 45 08             	mov    0x8(%ebp),%eax
  803508:	89 10                	mov    %edx,(%eax)
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	8b 00                	mov    (%eax),%eax
  80350f:	85 c0                	test   %eax,%eax
  803511:	74 0b                	je     80351e <insert_sorted_with_merge_freeList+0x6e1>
  803513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803516:	8b 00                	mov    (%eax),%eax
  803518:	8b 55 08             	mov    0x8(%ebp),%edx
  80351b:	89 50 04             	mov    %edx,0x4(%eax)
  80351e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803521:	8b 55 08             	mov    0x8(%ebp),%edx
  803524:	89 10                	mov    %edx,(%eax)
  803526:	8b 45 08             	mov    0x8(%ebp),%eax
  803529:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80352c:	89 50 04             	mov    %edx,0x4(%eax)
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	8b 00                	mov    (%eax),%eax
  803534:	85 c0                	test   %eax,%eax
  803536:	75 08                	jne    803540 <insert_sorted_with_merge_freeList+0x703>
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803540:	a1 44 51 80 00       	mov    0x805144,%eax
  803545:	40                   	inc    %eax
  803546:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80354b:	eb 39                	jmp    803586 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80354d:	a1 40 51 80 00       	mov    0x805140,%eax
  803552:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803555:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803559:	74 07                	je     803562 <insert_sorted_with_merge_freeList+0x725>
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	eb 05                	jmp    803567 <insert_sorted_with_merge_freeList+0x72a>
  803562:	b8 00 00 00 00       	mov    $0x0,%eax
  803567:	a3 40 51 80 00       	mov    %eax,0x805140
  80356c:	a1 40 51 80 00       	mov    0x805140,%eax
  803571:	85 c0                	test   %eax,%eax
  803573:	0f 85 c7 fb ff ff    	jne    803140 <insert_sorted_with_merge_freeList+0x303>
  803579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80357d:	0f 85 bd fb ff ff    	jne    803140 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803583:	eb 01                	jmp    803586 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803585:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803586:	90                   	nop
  803587:	c9                   	leave  
  803588:	c3                   	ret    

00803589 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803589:	55                   	push   %ebp
  80358a:	89 e5                	mov    %esp,%ebp
  80358c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80358f:	8d 45 10             	lea    0x10(%ebp),%eax
  803592:	83 c0 04             	add    $0x4,%eax
  803595:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803598:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80359d:	85 c0                	test   %eax,%eax
  80359f:	74 16                	je     8035b7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8035a1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8035a6:	83 ec 08             	sub    $0x8,%esp
  8035a9:	50                   	push   %eax
  8035aa:	68 20 42 80 00       	push   $0x804220
  8035af:	e8 6e d0 ff ff       	call   800622 <cprintf>
  8035b4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8035b7:	a1 00 50 80 00       	mov    0x805000,%eax
  8035bc:	ff 75 0c             	pushl  0xc(%ebp)
  8035bf:	ff 75 08             	pushl  0x8(%ebp)
  8035c2:	50                   	push   %eax
  8035c3:	68 25 42 80 00       	push   $0x804225
  8035c8:	e8 55 d0 ff ff       	call   800622 <cprintf>
  8035cd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8035d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8035d3:	83 ec 08             	sub    $0x8,%esp
  8035d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8035d9:	50                   	push   %eax
  8035da:	e8 d8 cf ff ff       	call   8005b7 <vcprintf>
  8035df:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8035e2:	83 ec 08             	sub    $0x8,%esp
  8035e5:	6a 00                	push   $0x0
  8035e7:	68 41 42 80 00       	push   $0x804241
  8035ec:	e8 c6 cf ff ff       	call   8005b7 <vcprintf>
  8035f1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8035f4:	e8 47 cf ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  8035f9:	eb fe                	jmp    8035f9 <_panic+0x70>

008035fb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8035fb:	55                   	push   %ebp
  8035fc:	89 e5                	mov    %esp,%ebp
  8035fe:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803601:	a1 20 50 80 00       	mov    0x805020,%eax
  803606:	8b 50 74             	mov    0x74(%eax),%edx
  803609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360c:	39 c2                	cmp    %eax,%edx
  80360e:	74 14                	je     803624 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803610:	83 ec 04             	sub    $0x4,%esp
  803613:	68 44 42 80 00       	push   $0x804244
  803618:	6a 26                	push   $0x26
  80361a:	68 90 42 80 00       	push   $0x804290
  80361f:	e8 65 ff ff ff       	call   803589 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803624:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80362b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803632:	e9 c2 00 00 00       	jmp    8036f9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80363a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	01 d0                	add    %edx,%eax
  803646:	8b 00                	mov    (%eax),%eax
  803648:	85 c0                	test   %eax,%eax
  80364a:	75 08                	jne    803654 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80364c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80364f:	e9 a2 00 00 00       	jmp    8036f6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803654:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80365b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803662:	eb 69                	jmp    8036cd <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803664:	a1 20 50 80 00       	mov    0x805020,%eax
  803669:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80366f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803672:	89 d0                	mov    %edx,%eax
  803674:	01 c0                	add    %eax,%eax
  803676:	01 d0                	add    %edx,%eax
  803678:	c1 e0 03             	shl    $0x3,%eax
  80367b:	01 c8                	add    %ecx,%eax
  80367d:	8a 40 04             	mov    0x4(%eax),%al
  803680:	84 c0                	test   %al,%al
  803682:	75 46                	jne    8036ca <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803684:	a1 20 50 80 00       	mov    0x805020,%eax
  803689:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80368f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803692:	89 d0                	mov    %edx,%eax
  803694:	01 c0                	add    %eax,%eax
  803696:	01 d0                	add    %edx,%eax
  803698:	c1 e0 03             	shl    $0x3,%eax
  80369b:	01 c8                	add    %ecx,%eax
  80369d:	8b 00                	mov    (%eax),%eax
  80369f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8036a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8036aa:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8036ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036af:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8036b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b9:	01 c8                	add    %ecx,%eax
  8036bb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8036bd:	39 c2                	cmp    %eax,%edx
  8036bf:	75 09                	jne    8036ca <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8036c1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8036c8:	eb 12                	jmp    8036dc <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036ca:	ff 45 e8             	incl   -0x18(%ebp)
  8036cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8036d2:	8b 50 74             	mov    0x74(%eax),%edx
  8036d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d8:	39 c2                	cmp    %eax,%edx
  8036da:	77 88                	ja     803664 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8036dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036e0:	75 14                	jne    8036f6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8036e2:	83 ec 04             	sub    $0x4,%esp
  8036e5:	68 9c 42 80 00       	push   $0x80429c
  8036ea:	6a 3a                	push   $0x3a
  8036ec:	68 90 42 80 00       	push   $0x804290
  8036f1:	e8 93 fe ff ff       	call   803589 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8036f6:	ff 45 f0             	incl   -0x10(%ebp)
  8036f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036ff:	0f 8c 32 ff ff ff    	jl     803637 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80370c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803713:	eb 26                	jmp    80373b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803715:	a1 20 50 80 00       	mov    0x805020,%eax
  80371a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803720:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803723:	89 d0                	mov    %edx,%eax
  803725:	01 c0                	add    %eax,%eax
  803727:	01 d0                	add    %edx,%eax
  803729:	c1 e0 03             	shl    $0x3,%eax
  80372c:	01 c8                	add    %ecx,%eax
  80372e:	8a 40 04             	mov    0x4(%eax),%al
  803731:	3c 01                	cmp    $0x1,%al
  803733:	75 03                	jne    803738 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803735:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803738:	ff 45 e0             	incl   -0x20(%ebp)
  80373b:	a1 20 50 80 00       	mov    0x805020,%eax
  803740:	8b 50 74             	mov    0x74(%eax),%edx
  803743:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803746:	39 c2                	cmp    %eax,%edx
  803748:	77 cb                	ja     803715 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80374a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803750:	74 14                	je     803766 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803752:	83 ec 04             	sub    $0x4,%esp
  803755:	68 f0 42 80 00       	push   $0x8042f0
  80375a:	6a 44                	push   $0x44
  80375c:	68 90 42 80 00       	push   $0x804290
  803761:	e8 23 fe ff ff       	call   803589 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803766:	90                   	nop
  803767:	c9                   	leave  
  803768:	c3                   	ret    
  803769:	66 90                	xchg   %ax,%ax
  80376b:	90                   	nop

0080376c <__udivdi3>:
  80376c:	55                   	push   %ebp
  80376d:	57                   	push   %edi
  80376e:	56                   	push   %esi
  80376f:	53                   	push   %ebx
  803770:	83 ec 1c             	sub    $0x1c,%esp
  803773:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803777:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80377b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80377f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803783:	89 ca                	mov    %ecx,%edx
  803785:	89 f8                	mov    %edi,%eax
  803787:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80378b:	85 f6                	test   %esi,%esi
  80378d:	75 2d                	jne    8037bc <__udivdi3+0x50>
  80378f:	39 cf                	cmp    %ecx,%edi
  803791:	77 65                	ja     8037f8 <__udivdi3+0x8c>
  803793:	89 fd                	mov    %edi,%ebp
  803795:	85 ff                	test   %edi,%edi
  803797:	75 0b                	jne    8037a4 <__udivdi3+0x38>
  803799:	b8 01 00 00 00       	mov    $0x1,%eax
  80379e:	31 d2                	xor    %edx,%edx
  8037a0:	f7 f7                	div    %edi
  8037a2:	89 c5                	mov    %eax,%ebp
  8037a4:	31 d2                	xor    %edx,%edx
  8037a6:	89 c8                	mov    %ecx,%eax
  8037a8:	f7 f5                	div    %ebp
  8037aa:	89 c1                	mov    %eax,%ecx
  8037ac:	89 d8                	mov    %ebx,%eax
  8037ae:	f7 f5                	div    %ebp
  8037b0:	89 cf                	mov    %ecx,%edi
  8037b2:	89 fa                	mov    %edi,%edx
  8037b4:	83 c4 1c             	add    $0x1c,%esp
  8037b7:	5b                   	pop    %ebx
  8037b8:	5e                   	pop    %esi
  8037b9:	5f                   	pop    %edi
  8037ba:	5d                   	pop    %ebp
  8037bb:	c3                   	ret    
  8037bc:	39 ce                	cmp    %ecx,%esi
  8037be:	77 28                	ja     8037e8 <__udivdi3+0x7c>
  8037c0:	0f bd fe             	bsr    %esi,%edi
  8037c3:	83 f7 1f             	xor    $0x1f,%edi
  8037c6:	75 40                	jne    803808 <__udivdi3+0x9c>
  8037c8:	39 ce                	cmp    %ecx,%esi
  8037ca:	72 0a                	jb     8037d6 <__udivdi3+0x6a>
  8037cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037d0:	0f 87 9e 00 00 00    	ja     803874 <__udivdi3+0x108>
  8037d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037db:	89 fa                	mov    %edi,%edx
  8037dd:	83 c4 1c             	add    $0x1c,%esp
  8037e0:	5b                   	pop    %ebx
  8037e1:	5e                   	pop    %esi
  8037e2:	5f                   	pop    %edi
  8037e3:	5d                   	pop    %ebp
  8037e4:	c3                   	ret    
  8037e5:	8d 76 00             	lea    0x0(%esi),%esi
  8037e8:	31 ff                	xor    %edi,%edi
  8037ea:	31 c0                	xor    %eax,%eax
  8037ec:	89 fa                	mov    %edi,%edx
  8037ee:	83 c4 1c             	add    $0x1c,%esp
  8037f1:	5b                   	pop    %ebx
  8037f2:	5e                   	pop    %esi
  8037f3:	5f                   	pop    %edi
  8037f4:	5d                   	pop    %ebp
  8037f5:	c3                   	ret    
  8037f6:	66 90                	xchg   %ax,%ax
  8037f8:	89 d8                	mov    %ebx,%eax
  8037fa:	f7 f7                	div    %edi
  8037fc:	31 ff                	xor    %edi,%edi
  8037fe:	89 fa                	mov    %edi,%edx
  803800:	83 c4 1c             	add    $0x1c,%esp
  803803:	5b                   	pop    %ebx
  803804:	5e                   	pop    %esi
  803805:	5f                   	pop    %edi
  803806:	5d                   	pop    %ebp
  803807:	c3                   	ret    
  803808:	bd 20 00 00 00       	mov    $0x20,%ebp
  80380d:	89 eb                	mov    %ebp,%ebx
  80380f:	29 fb                	sub    %edi,%ebx
  803811:	89 f9                	mov    %edi,%ecx
  803813:	d3 e6                	shl    %cl,%esi
  803815:	89 c5                	mov    %eax,%ebp
  803817:	88 d9                	mov    %bl,%cl
  803819:	d3 ed                	shr    %cl,%ebp
  80381b:	89 e9                	mov    %ebp,%ecx
  80381d:	09 f1                	or     %esi,%ecx
  80381f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803823:	89 f9                	mov    %edi,%ecx
  803825:	d3 e0                	shl    %cl,%eax
  803827:	89 c5                	mov    %eax,%ebp
  803829:	89 d6                	mov    %edx,%esi
  80382b:	88 d9                	mov    %bl,%cl
  80382d:	d3 ee                	shr    %cl,%esi
  80382f:	89 f9                	mov    %edi,%ecx
  803831:	d3 e2                	shl    %cl,%edx
  803833:	8b 44 24 08          	mov    0x8(%esp),%eax
  803837:	88 d9                	mov    %bl,%cl
  803839:	d3 e8                	shr    %cl,%eax
  80383b:	09 c2                	or     %eax,%edx
  80383d:	89 d0                	mov    %edx,%eax
  80383f:	89 f2                	mov    %esi,%edx
  803841:	f7 74 24 0c          	divl   0xc(%esp)
  803845:	89 d6                	mov    %edx,%esi
  803847:	89 c3                	mov    %eax,%ebx
  803849:	f7 e5                	mul    %ebp
  80384b:	39 d6                	cmp    %edx,%esi
  80384d:	72 19                	jb     803868 <__udivdi3+0xfc>
  80384f:	74 0b                	je     80385c <__udivdi3+0xf0>
  803851:	89 d8                	mov    %ebx,%eax
  803853:	31 ff                	xor    %edi,%edi
  803855:	e9 58 ff ff ff       	jmp    8037b2 <__udivdi3+0x46>
  80385a:	66 90                	xchg   %ax,%ax
  80385c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803860:	89 f9                	mov    %edi,%ecx
  803862:	d3 e2                	shl    %cl,%edx
  803864:	39 c2                	cmp    %eax,%edx
  803866:	73 e9                	jae    803851 <__udivdi3+0xe5>
  803868:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80386b:	31 ff                	xor    %edi,%edi
  80386d:	e9 40 ff ff ff       	jmp    8037b2 <__udivdi3+0x46>
  803872:	66 90                	xchg   %ax,%ax
  803874:	31 c0                	xor    %eax,%eax
  803876:	e9 37 ff ff ff       	jmp    8037b2 <__udivdi3+0x46>
  80387b:	90                   	nop

0080387c <__umoddi3>:
  80387c:	55                   	push   %ebp
  80387d:	57                   	push   %edi
  80387e:	56                   	push   %esi
  80387f:	53                   	push   %ebx
  803880:	83 ec 1c             	sub    $0x1c,%esp
  803883:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803887:	8b 74 24 34          	mov    0x34(%esp),%esi
  80388b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80388f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803893:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803897:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80389b:	89 f3                	mov    %esi,%ebx
  80389d:	89 fa                	mov    %edi,%edx
  80389f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038a3:	89 34 24             	mov    %esi,(%esp)
  8038a6:	85 c0                	test   %eax,%eax
  8038a8:	75 1a                	jne    8038c4 <__umoddi3+0x48>
  8038aa:	39 f7                	cmp    %esi,%edi
  8038ac:	0f 86 a2 00 00 00    	jbe    803954 <__umoddi3+0xd8>
  8038b2:	89 c8                	mov    %ecx,%eax
  8038b4:	89 f2                	mov    %esi,%edx
  8038b6:	f7 f7                	div    %edi
  8038b8:	89 d0                	mov    %edx,%eax
  8038ba:	31 d2                	xor    %edx,%edx
  8038bc:	83 c4 1c             	add    $0x1c,%esp
  8038bf:	5b                   	pop    %ebx
  8038c0:	5e                   	pop    %esi
  8038c1:	5f                   	pop    %edi
  8038c2:	5d                   	pop    %ebp
  8038c3:	c3                   	ret    
  8038c4:	39 f0                	cmp    %esi,%eax
  8038c6:	0f 87 ac 00 00 00    	ja     803978 <__umoddi3+0xfc>
  8038cc:	0f bd e8             	bsr    %eax,%ebp
  8038cf:	83 f5 1f             	xor    $0x1f,%ebp
  8038d2:	0f 84 ac 00 00 00    	je     803984 <__umoddi3+0x108>
  8038d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8038dd:	29 ef                	sub    %ebp,%edi
  8038df:	89 fe                	mov    %edi,%esi
  8038e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038e5:	89 e9                	mov    %ebp,%ecx
  8038e7:	d3 e0                	shl    %cl,%eax
  8038e9:	89 d7                	mov    %edx,%edi
  8038eb:	89 f1                	mov    %esi,%ecx
  8038ed:	d3 ef                	shr    %cl,%edi
  8038ef:	09 c7                	or     %eax,%edi
  8038f1:	89 e9                	mov    %ebp,%ecx
  8038f3:	d3 e2                	shl    %cl,%edx
  8038f5:	89 14 24             	mov    %edx,(%esp)
  8038f8:	89 d8                	mov    %ebx,%eax
  8038fa:	d3 e0                	shl    %cl,%eax
  8038fc:	89 c2                	mov    %eax,%edx
  8038fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803902:	d3 e0                	shl    %cl,%eax
  803904:	89 44 24 04          	mov    %eax,0x4(%esp)
  803908:	8b 44 24 08          	mov    0x8(%esp),%eax
  80390c:	89 f1                	mov    %esi,%ecx
  80390e:	d3 e8                	shr    %cl,%eax
  803910:	09 d0                	or     %edx,%eax
  803912:	d3 eb                	shr    %cl,%ebx
  803914:	89 da                	mov    %ebx,%edx
  803916:	f7 f7                	div    %edi
  803918:	89 d3                	mov    %edx,%ebx
  80391a:	f7 24 24             	mull   (%esp)
  80391d:	89 c6                	mov    %eax,%esi
  80391f:	89 d1                	mov    %edx,%ecx
  803921:	39 d3                	cmp    %edx,%ebx
  803923:	0f 82 87 00 00 00    	jb     8039b0 <__umoddi3+0x134>
  803929:	0f 84 91 00 00 00    	je     8039c0 <__umoddi3+0x144>
  80392f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803933:	29 f2                	sub    %esi,%edx
  803935:	19 cb                	sbb    %ecx,%ebx
  803937:	89 d8                	mov    %ebx,%eax
  803939:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80393d:	d3 e0                	shl    %cl,%eax
  80393f:	89 e9                	mov    %ebp,%ecx
  803941:	d3 ea                	shr    %cl,%edx
  803943:	09 d0                	or     %edx,%eax
  803945:	89 e9                	mov    %ebp,%ecx
  803947:	d3 eb                	shr    %cl,%ebx
  803949:	89 da                	mov    %ebx,%edx
  80394b:	83 c4 1c             	add    $0x1c,%esp
  80394e:	5b                   	pop    %ebx
  80394f:	5e                   	pop    %esi
  803950:	5f                   	pop    %edi
  803951:	5d                   	pop    %ebp
  803952:	c3                   	ret    
  803953:	90                   	nop
  803954:	89 fd                	mov    %edi,%ebp
  803956:	85 ff                	test   %edi,%edi
  803958:	75 0b                	jne    803965 <__umoddi3+0xe9>
  80395a:	b8 01 00 00 00       	mov    $0x1,%eax
  80395f:	31 d2                	xor    %edx,%edx
  803961:	f7 f7                	div    %edi
  803963:	89 c5                	mov    %eax,%ebp
  803965:	89 f0                	mov    %esi,%eax
  803967:	31 d2                	xor    %edx,%edx
  803969:	f7 f5                	div    %ebp
  80396b:	89 c8                	mov    %ecx,%eax
  80396d:	f7 f5                	div    %ebp
  80396f:	89 d0                	mov    %edx,%eax
  803971:	e9 44 ff ff ff       	jmp    8038ba <__umoddi3+0x3e>
  803976:	66 90                	xchg   %ax,%ax
  803978:	89 c8                	mov    %ecx,%eax
  80397a:	89 f2                	mov    %esi,%edx
  80397c:	83 c4 1c             	add    $0x1c,%esp
  80397f:	5b                   	pop    %ebx
  803980:	5e                   	pop    %esi
  803981:	5f                   	pop    %edi
  803982:	5d                   	pop    %ebp
  803983:	c3                   	ret    
  803984:	3b 04 24             	cmp    (%esp),%eax
  803987:	72 06                	jb     80398f <__umoddi3+0x113>
  803989:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80398d:	77 0f                	ja     80399e <__umoddi3+0x122>
  80398f:	89 f2                	mov    %esi,%edx
  803991:	29 f9                	sub    %edi,%ecx
  803993:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803997:	89 14 24             	mov    %edx,(%esp)
  80399a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80399e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039a2:	8b 14 24             	mov    (%esp),%edx
  8039a5:	83 c4 1c             	add    $0x1c,%esp
  8039a8:	5b                   	pop    %ebx
  8039a9:	5e                   	pop    %esi
  8039aa:	5f                   	pop    %edi
  8039ab:	5d                   	pop    %ebp
  8039ac:	c3                   	ret    
  8039ad:	8d 76 00             	lea    0x0(%esi),%esi
  8039b0:	2b 04 24             	sub    (%esp),%eax
  8039b3:	19 fa                	sbb    %edi,%edx
  8039b5:	89 d1                	mov    %edx,%ecx
  8039b7:	89 c6                	mov    %eax,%esi
  8039b9:	e9 71 ff ff ff       	jmp    80392f <__umoddi3+0xb3>
  8039be:	66 90                	xchg   %ax,%ax
  8039c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039c4:	72 ea                	jb     8039b0 <__umoddi3+0x134>
  8039c6:	89 d9                	mov    %ebx,%ecx
  8039c8:	e9 62 ff ff ff       	jmp    80392f <__umoddi3+0xb3>
