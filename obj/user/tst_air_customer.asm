
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
  800044:	e8 7a 1a 00 00       	call   801ac3 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 29 38 80 00       	mov    $0x803829,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 33 38 80 00       	mov    $0x803833,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 3f 38 80 00       	mov    $0x80383f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 4e 38 80 00       	mov    $0x80384e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 5d 38 80 00       	mov    $0x80385d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 72 38 80 00       	mov    $0x803872,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 87 38 80 00       	mov    $0x803887,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 98 38 80 00       	mov    $0x803898,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb a9 38 80 00       	mov    $0x8038a9,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb ba 38 80 00       	mov    $0x8038ba,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb c3 38 80 00       	mov    $0x8038c3,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb cd 38 80 00       	mov    $0x8038cd,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb d8 38 80 00       	mov    $0x8038d8,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb e4 38 80 00       	mov    $0x8038e4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ee 38 80 00       	mov    $0x8038ee,%ebx
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
  8001be:	bb f8 38 80 00       	mov    $0x8038f8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 06 39 80 00       	mov    $0x803906,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 15 39 80 00       	mov    $0x803915,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 1c 39 80 00       	mov    $0x80391c,%ebx
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
  800222:	e8 ff 13 00 00       	call   801626 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 ea 13 00 00       	call   801626 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 d2 13 00 00       	call   801626 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 ba 13 00 00       	call   801626 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 e0 16 00 00       	call   801964 <sys_waitSemaphore>
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
  8002a9:	e8 d4 16 00 00       	call   801982 <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 a1 16 00 00       	call   801964 <sys_waitSemaphore>
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
  8002e7:	e8 78 16 00 00       	call   801964 <sys_waitSemaphore>
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
  80031f:	e8 5e 16 00 00       	call   801982 <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 49 16 00 00       	call   801982 <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb 23 39 80 00       	mov    $0x803923,%ebx
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
  8003aa:	e8 b5 15 00 00       	call   801964 <sys_waitSemaphore>
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
  8003d2:	68 e0 37 80 00       	push   $0x8037e0
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 08 38 80 00       	push   $0x803808
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 7c 15 00 00       	call   801982 <sys_signalSemaphore>
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
  800418:	e8 8d 16 00 00       	call   801aaa <sys_getenvindex>
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
  800483:	e8 2f 14 00 00       	call   8018b7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 5c 39 80 00       	push   $0x80395c
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
  8004b3:	68 84 39 80 00       	push   $0x803984
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
  8004e4:	68 ac 39 80 00       	push   $0x8039ac
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 04 3a 80 00       	push   $0x803a04
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 5c 39 80 00       	push   $0x80395c
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 af 13 00 00       	call   8018d1 <sys_enable_interrupt>

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
  800535:	e8 3c 15 00 00       	call   801a76 <sys_destroy_env>
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
  800546:	e8 91 15 00 00       	call   801adc <sys_exit_env>
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
  800594:	e8 70 11 00 00       	call   801709 <sys_cputs>
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
  80060b:	e8 f9 10 00 00       	call   801709 <sys_cputs>
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
  800655:	e8 5d 12 00 00       	call   8018b7 <sys_disable_interrupt>
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
  800675:	e8 57 12 00 00       	call   8018d1 <sys_enable_interrupt>
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
  8006bf:	e8 a8 2e 00 00       	call   80356c <__udivdi3>
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
  80070f:	e8 68 2f 00 00       	call   80367c <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 34 3c 80 00       	add    $0x803c34,%eax
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
  80086a:	8b 04 85 58 3c 80 00 	mov    0x803c58(,%eax,4),%eax
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
  80094b:	8b 34 9d a0 3a 80 00 	mov    0x803aa0(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 45 3c 80 00       	push   $0x803c45
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
  800970:	68 4e 3c 80 00       	push   $0x803c4e
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
  80099d:	be 51 3c 80 00       	mov    $0x803c51,%esi
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
  8013c3:	68 b0 3d 80 00       	push   $0x803db0
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
  801493:	e8 b5 03 00 00       	call   80184d <sys_allocate_chunk>
  801498:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80149b:	a1 20 51 80 00       	mov    0x805120,%eax
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	50                   	push   %eax
  8014a4:	e8 2a 0a 00 00       	call   801ed3 <initialize_MemBlocksList>
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
  8014d1:	68 d5 3d 80 00       	push   $0x803dd5
  8014d6:	6a 33                	push   $0x33
  8014d8:	68 f3 3d 80 00       	push   $0x803df3
  8014dd:	e8 aa 1e 00 00       	call   80338c <_panic>
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
  801550:	68 00 3e 80 00       	push   $0x803e00
  801555:	6a 34                	push   $0x34
  801557:	68 f3 3d 80 00       	push   $0x803df3
  80155c:	e8 2b 1e 00 00       	call   80338c <_panic>
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
  8015ad:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b0:	e8 f7 fd ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b9:	75 07                	jne    8015c2 <malloc+0x18>
  8015bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c0:	eb 14                	jmp    8015d6 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	68 24 3e 80 00       	push   $0x803e24
  8015ca:	6a 46                	push   $0x46
  8015cc:	68 f3 3d 80 00       	push   $0x803df3
  8015d1:	e8 b6 1d 00 00       	call   80338c <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 4c 3e 80 00       	push   $0x803e4c
  8015e6:	6a 61                	push   $0x61
  8015e8:	68 f3 3d 80 00       	push   $0x803df3
  8015ed:	e8 9a 1d 00 00       	call   80338c <_panic>

008015f2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 18             	sub    $0x18,%esp
  8015f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fb:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015fe:	e8 a9 fd ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  801603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801607:	75 07                	jne    801610 <smalloc+0x1e>
  801609:	b8 00 00 00 00       	mov    $0x0,%eax
  80160e:	eb 14                	jmp    801624 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801610:	83 ec 04             	sub    $0x4,%esp
  801613:	68 70 3e 80 00       	push   $0x803e70
  801618:	6a 76                	push   $0x76
  80161a:	68 f3 3d 80 00       	push   $0x803df3
  80161f:	e8 68 1d 00 00       	call   80338c <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80162c:	e8 7b fd ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	68 98 3e 80 00       	push   $0x803e98
  801639:	68 93 00 00 00       	push   $0x93
  80163e:	68 f3 3d 80 00       	push   $0x803df3
  801643:	e8 44 1d 00 00       	call   80338c <_panic>

00801648 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80164e:	e8 59 fd ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	68 bc 3e 80 00       	push   $0x803ebc
  80165b:	68 c5 00 00 00       	push   $0xc5
  801660:	68 f3 3d 80 00       	push   $0x803df3
  801665:	e8 22 1d 00 00       	call   80338c <_panic>

0080166a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	68 e4 3e 80 00       	push   $0x803ee4
  801678:	68 d9 00 00 00       	push   $0xd9
  80167d:	68 f3 3d 80 00       	push   $0x803df3
  801682:	e8 05 1d 00 00       	call   80338c <_panic>

00801687 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	68 08 3f 80 00       	push   $0x803f08
  801695:	68 e4 00 00 00       	push   $0xe4
  80169a:	68 f3 3d 80 00       	push   $0x803df3
  80169f:	e8 e8 1c 00 00       	call   80338c <_panic>

008016a4 <shrink>:

}
void shrink(uint32 newSize)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	68 08 3f 80 00       	push   $0x803f08
  8016b2:	68 e9 00 00 00       	push   $0xe9
  8016b7:	68 f3 3d 80 00       	push   $0x803df3
  8016bc:	e8 cb 1c 00 00       	call   80338c <_panic>

008016c1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	68 08 3f 80 00       	push   $0x803f08
  8016cf:	68 ee 00 00 00       	push   $0xee
  8016d4:	68 f3 3d 80 00       	push   $0x803df3
  8016d9:	e8 ae 1c 00 00       	call   80338c <_panic>

008016de <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	57                   	push   %edi
  8016e2:	56                   	push   %esi
  8016e3:	53                   	push   %ebx
  8016e4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016f6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016f9:	cd 30                	int    $0x30
  8016fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	5b                   	pop    %ebx
  801705:	5e                   	pop    %esi
  801706:	5f                   	pop    %edi
  801707:	5d                   	pop    %ebp
  801708:	c3                   	ret    

00801709 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 04             	sub    $0x4,%esp
  80170f:	8b 45 10             	mov    0x10(%ebp),%eax
  801712:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801715:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	52                   	push   %edx
  801721:	ff 75 0c             	pushl  0xc(%ebp)
  801724:	50                   	push   %eax
  801725:	6a 00                	push   $0x0
  801727:	e8 b2 ff ff ff       	call   8016de <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	90                   	nop
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_cgetc>:

int
sys_cgetc(void)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 01                	push   $0x1
  801741:	e8 98 ff ff ff       	call   8016de <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80174e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	52                   	push   %edx
  80175b:	50                   	push   %eax
  80175c:	6a 05                	push   $0x5
  80175e:	e8 7b ff ff ff       	call   8016de <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80176d:	8b 75 18             	mov    0x18(%ebp),%esi
  801770:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801773:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801776:	8b 55 0c             	mov    0xc(%ebp),%edx
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	56                   	push   %esi
  80177d:	53                   	push   %ebx
  80177e:	51                   	push   %ecx
  80177f:	52                   	push   %edx
  801780:	50                   	push   %eax
  801781:	6a 06                	push   $0x6
  801783:	e8 56 ff ff ff       	call   8016de <syscall>
  801788:	83 c4 18             	add    $0x18,%esp
}
  80178b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178e:	5b                   	pop    %ebx
  80178f:	5e                   	pop    %esi
  801790:	5d                   	pop    %ebp
  801791:	c3                   	ret    

00801792 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801795:	8b 55 0c             	mov    0xc(%ebp),%edx
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	52                   	push   %edx
  8017a2:	50                   	push   %eax
  8017a3:	6a 07                	push   $0x7
  8017a5:	e8 34 ff ff ff       	call   8016de <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	ff 75 0c             	pushl  0xc(%ebp)
  8017bb:	ff 75 08             	pushl  0x8(%ebp)
  8017be:	6a 08                	push   $0x8
  8017c0:	e8 19 ff ff ff       	call   8016de <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 09                	push   $0x9
  8017d9:	e8 00 ff ff ff       	call   8016de <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 0a                	push   $0xa
  8017f2:	e8 e7 fe ff ff       	call   8016de <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 0b                	push   $0xb
  80180b:	e8 ce fe ff ff       	call   8016de <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	6a 0f                	push   $0xf
  801826:	e8 b3 fe ff ff       	call   8016de <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
	return;
  80182e:	90                   	nop
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	ff 75 0c             	pushl  0xc(%ebp)
  80183d:	ff 75 08             	pushl  0x8(%ebp)
  801840:	6a 10                	push   $0x10
  801842:	e8 97 fe ff ff       	call   8016de <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
	return ;
  80184a:	90                   	nop
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	ff 75 10             	pushl  0x10(%ebp)
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	ff 75 08             	pushl  0x8(%ebp)
  80185d:	6a 11                	push   $0x11
  80185f:	e8 7a fe ff ff       	call   8016de <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
	return ;
  801867:	90                   	nop
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 0c                	push   $0xc
  801879:	e8 60 fe ff ff       	call   8016de <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	ff 75 08             	pushl  0x8(%ebp)
  801891:	6a 0d                	push   $0xd
  801893:	e8 46 fe ff ff       	call   8016de <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 0e                	push   $0xe
  8018ac:	e8 2d fe ff ff       	call   8016de <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	90                   	nop
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 13                	push   $0x13
  8018c6:	e8 13 fe ff ff       	call   8016de <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	90                   	nop
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 14                	push   $0x14
  8018e0:	e8 f9 fd ff ff       	call   8016de <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	90                   	nop
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_cputc>:


void
sys_cputc(const char c)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	50                   	push   %eax
  801904:	6a 15                	push   $0x15
  801906:	e8 d3 fd ff ff       	call   8016de <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	90                   	nop
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 16                	push   $0x16
  801920:	e8 b9 fd ff ff       	call   8016de <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	90                   	nop
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	50                   	push   %eax
  80193b:	6a 17                	push   $0x17
  80193d:	e8 9c fd ff ff       	call   8016de <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 1a                	push   $0x1a
  80195a:	e8 7f fd ff ff       	call   8016de <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	52                   	push   %edx
  801974:	50                   	push   %eax
  801975:	6a 18                	push   $0x18
  801977:	e8 62 fd ff ff       	call   8016de <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	90                   	nop
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801985:	8b 55 0c             	mov    0xc(%ebp),%edx
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	52                   	push   %edx
  801992:	50                   	push   %eax
  801993:	6a 19                	push   $0x19
  801995:	e8 44 fd ff ff       	call   8016de <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	90                   	nop
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019af:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	51                   	push   %ecx
  8019b9:	52                   	push   %edx
  8019ba:	ff 75 0c             	pushl  0xc(%ebp)
  8019bd:	50                   	push   %eax
  8019be:	6a 1b                	push   $0x1b
  8019c0:	e8 19 fd ff ff       	call   8016de <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	52                   	push   %edx
  8019da:	50                   	push   %eax
  8019db:	6a 1c                	push   $0x1c
  8019dd:	e8 fc fc ff ff       	call   8016de <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	51                   	push   %ecx
  8019f8:	52                   	push   %edx
  8019f9:	50                   	push   %eax
  8019fa:	6a 1d                	push   $0x1d
  8019fc:	e8 dd fc ff ff       	call   8016de <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	52                   	push   %edx
  801a16:	50                   	push   %eax
  801a17:	6a 1e                	push   $0x1e
  801a19:	e8 c0 fc ff ff       	call   8016de <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 1f                	push   $0x1f
  801a32:	e8 a7 fc ff ff       	call   8016de <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	ff 75 14             	pushl  0x14(%ebp)
  801a47:	ff 75 10             	pushl  0x10(%ebp)
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	50                   	push   %eax
  801a4e:	6a 20                	push   $0x20
  801a50:	e8 89 fc ff ff       	call   8016de <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	50                   	push   %eax
  801a69:	6a 21                	push   $0x21
  801a6b:	e8 6e fc ff ff       	call   8016de <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	90                   	nop
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	50                   	push   %eax
  801a85:	6a 22                	push   $0x22
  801a87:	e8 52 fc ff ff       	call   8016de <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 02                	push   $0x2
  801aa0:	e8 39 fc ff ff       	call   8016de <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 03                	push   $0x3
  801ab9:	e8 20 fc ff ff       	call   8016de <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 04                	push   $0x4
  801ad2:	e8 07 fc ff ff       	call   8016de <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_exit_env>:


void sys_exit_env(void)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 23                	push   $0x23
  801aeb:	e8 ee fb ff ff       	call   8016de <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	90                   	nop
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801afc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aff:	8d 50 04             	lea    0x4(%eax),%edx
  801b02:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	52                   	push   %edx
  801b0c:	50                   	push   %eax
  801b0d:	6a 24                	push   $0x24
  801b0f:	e8 ca fb ff ff       	call   8016de <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
	return result;
  801b17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b20:	89 01                	mov    %eax,(%ecx)
  801b22:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	c9                   	leave  
  801b29:	c2 04 00             	ret    $0x4

00801b2c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	ff 75 10             	pushl  0x10(%ebp)
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	ff 75 08             	pushl  0x8(%ebp)
  801b3c:	6a 12                	push   $0x12
  801b3e:	e8 9b fb ff ff       	call   8016de <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
	return ;
  801b46:	90                   	nop
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 25                	push   $0x25
  801b58:	e8 81 fb ff ff       	call   8016de <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 04             	sub    $0x4,%esp
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b6e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	50                   	push   %eax
  801b7b:	6a 26                	push   $0x26
  801b7d:	e8 5c fb ff ff       	call   8016de <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <rsttst>:
void rsttst()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 28                	push   $0x28
  801b97:	e8 42 fb ff ff       	call   8016de <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9f:	90                   	nop
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bae:	8b 55 18             	mov    0x18(%ebp),%edx
  801bb1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bb5:	52                   	push   %edx
  801bb6:	50                   	push   %eax
  801bb7:	ff 75 10             	pushl  0x10(%ebp)
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	ff 75 08             	pushl  0x8(%ebp)
  801bc0:	6a 27                	push   $0x27
  801bc2:	e8 17 fb ff ff       	call   8016de <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bca:	90                   	nop
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <chktst>:
void chktst(uint32 n)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	ff 75 08             	pushl  0x8(%ebp)
  801bdb:	6a 29                	push   $0x29
  801bdd:	e8 fc fa ff ff       	call   8016de <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
	return ;
  801be5:	90                   	nop
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <inctst>:

void inctst()
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 2a                	push   $0x2a
  801bf7:	e8 e2 fa ff ff       	call   8016de <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bff:	90                   	nop
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <gettst>:
uint32 gettst()
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 2b                	push   $0x2b
  801c11:	e8 c8 fa ff ff       	call   8016de <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 2c                	push   $0x2c
  801c2d:	e8 ac fa ff ff       	call   8016de <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
  801c35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c38:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c3c:	75 07                	jne    801c45 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c43:	eb 05                	jmp    801c4a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 2c                	push   $0x2c
  801c5e:	e8 7b fa ff ff       	call   8016de <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
  801c66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c69:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c6d:	75 07                	jne    801c76 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c74:	eb 05                	jmp    801c7b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 2c                	push   $0x2c
  801c8f:	e8 4a fa ff ff       	call   8016de <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
  801c97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c9a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c9e:	75 07                	jne    801ca7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ca0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca5:	eb 05                	jmp    801cac <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 2c                	push   $0x2c
  801cc0:	e8 19 fa ff ff       	call   8016de <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
  801cc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ccb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ccf:	75 07                	jne    801cd8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd6:	eb 05                	jmp    801cdd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	ff 75 08             	pushl  0x8(%ebp)
  801ced:	6a 2d                	push   $0x2d
  801cef:	e8 ea f9 ff ff       	call   8016de <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf7:	90                   	nop
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cfe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d01:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	53                   	push   %ebx
  801d0d:	51                   	push   %ecx
  801d0e:	52                   	push   %edx
  801d0f:	50                   	push   %eax
  801d10:	6a 2e                	push   $0x2e
  801d12:	e8 c7 f9 ff ff       	call   8016de <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	6a 2f                	push   $0x2f
  801d32:	e8 a7 f9 ff ff       	call   8016de <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d42:	83 ec 0c             	sub    $0xc,%esp
  801d45:	68 18 3f 80 00       	push   $0x803f18
  801d4a:	e8 d3 e8 ff ff       	call   800622 <cprintf>
  801d4f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d52:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d59:	83 ec 0c             	sub    $0xc,%esp
  801d5c:	68 44 3f 80 00       	push   $0x803f44
  801d61:	e8 bc e8 ff ff       	call   800622 <cprintf>
  801d66:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d69:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d6d:	a1 38 51 80 00       	mov    0x805138,%eax
  801d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d75:	eb 56                	jmp    801dcd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d7b:	74 1c                	je     801d99 <print_mem_block_lists+0x5d>
  801d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d80:	8b 50 08             	mov    0x8(%eax),%edx
  801d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d86:	8b 48 08             	mov    0x8(%eax),%ecx
  801d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8f:	01 c8                	add    %ecx,%eax
  801d91:	39 c2                	cmp    %eax,%edx
  801d93:	73 04                	jae    801d99 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d95:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9c:	8b 50 08             	mov    0x8(%eax),%edx
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	8b 40 0c             	mov    0xc(%eax),%eax
  801da5:	01 c2                	add    %eax,%edx
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	8b 40 08             	mov    0x8(%eax),%eax
  801dad:	83 ec 04             	sub    $0x4,%esp
  801db0:	52                   	push   %edx
  801db1:	50                   	push   %eax
  801db2:	68 59 3f 80 00       	push   $0x803f59
  801db7:	e8 66 e8 ff ff       	call   800622 <cprintf>
  801dbc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dc5:	a1 40 51 80 00       	mov    0x805140,%eax
  801dca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd1:	74 07                	je     801dda <print_mem_block_lists+0x9e>
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	8b 00                	mov    (%eax),%eax
  801dd8:	eb 05                	jmp    801ddf <print_mem_block_lists+0xa3>
  801dda:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddf:	a3 40 51 80 00       	mov    %eax,0x805140
  801de4:	a1 40 51 80 00       	mov    0x805140,%eax
  801de9:	85 c0                	test   %eax,%eax
  801deb:	75 8a                	jne    801d77 <print_mem_block_lists+0x3b>
  801ded:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df1:	75 84                	jne    801d77 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801df3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801df7:	75 10                	jne    801e09 <print_mem_block_lists+0xcd>
  801df9:	83 ec 0c             	sub    $0xc,%esp
  801dfc:	68 68 3f 80 00       	push   $0x803f68
  801e01:	e8 1c e8 ff ff       	call   800622 <cprintf>
  801e06:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e10:	83 ec 0c             	sub    $0xc,%esp
  801e13:	68 8c 3f 80 00       	push   $0x803f8c
  801e18:	e8 05 e8 ff ff       	call   800622 <cprintf>
  801e1d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e20:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e24:	a1 40 50 80 00       	mov    0x805040,%eax
  801e29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2c:	eb 56                	jmp    801e84 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e32:	74 1c                	je     801e50 <print_mem_block_lists+0x114>
  801e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e37:	8b 50 08             	mov    0x8(%eax),%edx
  801e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e43:	8b 40 0c             	mov    0xc(%eax),%eax
  801e46:	01 c8                	add    %ecx,%eax
  801e48:	39 c2                	cmp    %eax,%edx
  801e4a:	73 04                	jae    801e50 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e4c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e53:	8b 50 08             	mov    0x8(%eax),%edx
  801e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e59:	8b 40 0c             	mov    0xc(%eax),%eax
  801e5c:	01 c2                	add    %eax,%edx
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	8b 40 08             	mov    0x8(%eax),%eax
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	52                   	push   %edx
  801e68:	50                   	push   %eax
  801e69:	68 59 3f 80 00       	push   $0x803f59
  801e6e:	e8 af e7 ff ff       	call   800622 <cprintf>
  801e73:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e7c:	a1 48 50 80 00       	mov    0x805048,%eax
  801e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e88:	74 07                	je     801e91 <print_mem_block_lists+0x155>
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	8b 00                	mov    (%eax),%eax
  801e8f:	eb 05                	jmp    801e96 <print_mem_block_lists+0x15a>
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	a3 48 50 80 00       	mov    %eax,0x805048
  801e9b:	a1 48 50 80 00       	mov    0x805048,%eax
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	75 8a                	jne    801e2e <print_mem_block_lists+0xf2>
  801ea4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea8:	75 84                	jne    801e2e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801eaa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eae:	75 10                	jne    801ec0 <print_mem_block_lists+0x184>
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	68 a4 3f 80 00       	push   $0x803fa4
  801eb8:	e8 65 e7 ff ff       	call   800622 <cprintf>
  801ebd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ec0:	83 ec 0c             	sub    $0xc,%esp
  801ec3:	68 18 3f 80 00       	push   $0x803f18
  801ec8:	e8 55 e7 ff ff       	call   800622 <cprintf>
  801ecd:	83 c4 10             	add    $0x10,%esp

}
  801ed0:	90                   	nop
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ed9:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ee0:	00 00 00 
  801ee3:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801eea:	00 00 00 
  801eed:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ef4:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ef7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801efe:	e9 9e 00 00 00       	jmp    801fa1 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f03:	a1 50 50 80 00       	mov    0x805050,%eax
  801f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0b:	c1 e2 04             	shl    $0x4,%edx
  801f0e:	01 d0                	add    %edx,%eax
  801f10:	85 c0                	test   %eax,%eax
  801f12:	75 14                	jne    801f28 <initialize_MemBlocksList+0x55>
  801f14:	83 ec 04             	sub    $0x4,%esp
  801f17:	68 cc 3f 80 00       	push   $0x803fcc
  801f1c:	6a 46                	push   $0x46
  801f1e:	68 ef 3f 80 00       	push   $0x803fef
  801f23:	e8 64 14 00 00       	call   80338c <_panic>
  801f28:	a1 50 50 80 00       	mov    0x805050,%eax
  801f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f30:	c1 e2 04             	shl    $0x4,%edx
  801f33:	01 d0                	add    %edx,%eax
  801f35:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f3b:	89 10                	mov    %edx,(%eax)
  801f3d:	8b 00                	mov    (%eax),%eax
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	74 18                	je     801f5b <initialize_MemBlocksList+0x88>
  801f43:	a1 48 51 80 00       	mov    0x805148,%eax
  801f48:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f4e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f51:	c1 e1 04             	shl    $0x4,%ecx
  801f54:	01 ca                	add    %ecx,%edx
  801f56:	89 50 04             	mov    %edx,0x4(%eax)
  801f59:	eb 12                	jmp    801f6d <initialize_MemBlocksList+0x9a>
  801f5b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f63:	c1 e2 04             	shl    $0x4,%edx
  801f66:	01 d0                	add    %edx,%eax
  801f68:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f6d:	a1 50 50 80 00       	mov    0x805050,%eax
  801f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f75:	c1 e2 04             	shl    $0x4,%edx
  801f78:	01 d0                	add    %edx,%eax
  801f7a:	a3 48 51 80 00       	mov    %eax,0x805148
  801f7f:	a1 50 50 80 00       	mov    0x805050,%eax
  801f84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f87:	c1 e2 04             	shl    $0x4,%edx
  801f8a:	01 d0                	add    %edx,%eax
  801f8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f93:	a1 54 51 80 00       	mov    0x805154,%eax
  801f98:	40                   	inc    %eax
  801f99:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f9e:	ff 45 f4             	incl   -0xc(%ebp)
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fa7:	0f 82 56 ff ff ff    	jb     801f03 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fad:	90                   	nop
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	8b 00                	mov    (%eax),%eax
  801fbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fbe:	eb 19                	jmp    801fd9 <find_block+0x29>
	{
		if(va==point->sva)
  801fc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc3:	8b 40 08             	mov    0x8(%eax),%eax
  801fc6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fc9:	75 05                	jne    801fd0 <find_block+0x20>
		   return point;
  801fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fce:	eb 36                	jmp    802006 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	8b 40 08             	mov    0x8(%eax),%eax
  801fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fdd:	74 07                	je     801fe6 <find_block+0x36>
  801fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe2:	8b 00                	mov    (%eax),%eax
  801fe4:	eb 05                	jmp    801feb <find_block+0x3b>
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  801feb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fee:	89 42 08             	mov    %eax,0x8(%edx)
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	8b 40 08             	mov    0x8(%eax),%eax
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	75 c5                	jne    801fc0 <find_block+0x10>
  801ffb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fff:	75 bf                	jne    801fc0 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80200e:	a1 40 50 80 00       	mov    0x805040,%eax
  802013:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802016:	a1 44 50 80 00       	mov    0x805044,%eax
  80201b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80201e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802021:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802024:	74 24                	je     80204a <insert_sorted_allocList+0x42>
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	8b 50 08             	mov    0x8(%eax),%edx
  80202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202f:	8b 40 08             	mov    0x8(%eax),%eax
  802032:	39 c2                	cmp    %eax,%edx
  802034:	76 14                	jbe    80204a <insert_sorted_allocList+0x42>
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8b 50 08             	mov    0x8(%eax),%edx
  80203c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203f:	8b 40 08             	mov    0x8(%eax),%eax
  802042:	39 c2                	cmp    %eax,%edx
  802044:	0f 82 60 01 00 00    	jb     8021aa <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80204a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80204e:	75 65                	jne    8020b5 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802050:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802054:	75 14                	jne    80206a <insert_sorted_allocList+0x62>
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	68 cc 3f 80 00       	push   $0x803fcc
  80205e:	6a 6b                	push   $0x6b
  802060:	68 ef 3f 80 00       	push   $0x803fef
  802065:	e8 22 13 00 00       	call   80338c <_panic>
  80206a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	89 10                	mov    %edx,(%eax)
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	8b 00                	mov    (%eax),%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	74 0d                	je     80208b <insert_sorted_allocList+0x83>
  80207e:	a1 40 50 80 00       	mov    0x805040,%eax
  802083:	8b 55 08             	mov    0x8(%ebp),%edx
  802086:	89 50 04             	mov    %edx,0x4(%eax)
  802089:	eb 08                	jmp    802093 <insert_sorted_allocList+0x8b>
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	a3 44 50 80 00       	mov    %eax,0x805044
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	a3 40 50 80 00       	mov    %eax,0x805040
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020aa:	40                   	inc    %eax
  8020ab:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020b0:	e9 dc 01 00 00       	jmp    802291 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	8b 50 08             	mov    0x8(%eax),%edx
  8020bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020be:	8b 40 08             	mov    0x8(%eax),%eax
  8020c1:	39 c2                	cmp    %eax,%edx
  8020c3:	77 6c                	ja     802131 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c9:	74 06                	je     8020d1 <insert_sorted_allocList+0xc9>
  8020cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020cf:	75 14                	jne    8020e5 <insert_sorted_allocList+0xdd>
  8020d1:	83 ec 04             	sub    $0x4,%esp
  8020d4:	68 08 40 80 00       	push   $0x804008
  8020d9:	6a 6f                	push   $0x6f
  8020db:	68 ef 3f 80 00       	push   $0x803fef
  8020e0:	e8 a7 12 00 00       	call   80338c <_panic>
  8020e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e8:	8b 50 04             	mov    0x4(%eax),%edx
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	89 50 04             	mov    %edx,0x4(%eax)
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020f7:	89 10                	mov    %edx,(%eax)
  8020f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fc:	8b 40 04             	mov    0x4(%eax),%eax
  8020ff:	85 c0                	test   %eax,%eax
  802101:	74 0d                	je     802110 <insert_sorted_allocList+0x108>
  802103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802106:	8b 40 04             	mov    0x4(%eax),%eax
  802109:	8b 55 08             	mov    0x8(%ebp),%edx
  80210c:	89 10                	mov    %edx,(%eax)
  80210e:	eb 08                	jmp    802118 <insert_sorted_allocList+0x110>
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	a3 40 50 80 00       	mov    %eax,0x805040
  802118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211b:	8b 55 08             	mov    0x8(%ebp),%edx
  80211e:	89 50 04             	mov    %edx,0x4(%eax)
  802121:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802126:	40                   	inc    %eax
  802127:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80212c:	e9 60 01 00 00       	jmp    802291 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	8b 50 08             	mov    0x8(%eax),%edx
  802137:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213a:	8b 40 08             	mov    0x8(%eax),%eax
  80213d:	39 c2                	cmp    %eax,%edx
  80213f:	0f 82 4c 01 00 00    	jb     802291 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802145:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802149:	75 14                	jne    80215f <insert_sorted_allocList+0x157>
  80214b:	83 ec 04             	sub    $0x4,%esp
  80214e:	68 40 40 80 00       	push   $0x804040
  802153:	6a 73                	push   $0x73
  802155:	68 ef 3f 80 00       	push   $0x803fef
  80215a:	e8 2d 12 00 00       	call   80338c <_panic>
  80215f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	89 50 04             	mov    %edx,0x4(%eax)
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	8b 40 04             	mov    0x4(%eax),%eax
  802171:	85 c0                	test   %eax,%eax
  802173:	74 0c                	je     802181 <insert_sorted_allocList+0x179>
  802175:	a1 44 50 80 00       	mov    0x805044,%eax
  80217a:	8b 55 08             	mov    0x8(%ebp),%edx
  80217d:	89 10                	mov    %edx,(%eax)
  80217f:	eb 08                	jmp    802189 <insert_sorted_allocList+0x181>
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	a3 40 50 80 00       	mov    %eax,0x805040
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	a3 44 50 80 00       	mov    %eax,0x805044
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80219a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80219f:	40                   	inc    %eax
  8021a0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021a5:	e9 e7 00 00 00       	jmp    802291 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021b7:	a1 40 50 80 00       	mov    0x805040,%eax
  8021bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bf:	e9 9d 00 00 00       	jmp    802261 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	8b 00                	mov    (%eax),%eax
  8021c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	8b 50 08             	mov    0x8(%eax),%edx
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	8b 40 08             	mov    0x8(%eax),%eax
  8021d8:	39 c2                	cmp    %eax,%edx
  8021da:	76 7d                	jbe    802259 <insert_sorted_allocList+0x251>
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	8b 50 08             	mov    0x8(%eax),%edx
  8021e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021e5:	8b 40 08             	mov    0x8(%eax),%eax
  8021e8:	39 c2                	cmp    %eax,%edx
  8021ea:	73 6d                	jae    802259 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f0:	74 06                	je     8021f8 <insert_sorted_allocList+0x1f0>
  8021f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f6:	75 14                	jne    80220c <insert_sorted_allocList+0x204>
  8021f8:	83 ec 04             	sub    $0x4,%esp
  8021fb:	68 64 40 80 00       	push   $0x804064
  802200:	6a 7f                	push   $0x7f
  802202:	68 ef 3f 80 00       	push   $0x803fef
  802207:	e8 80 11 00 00       	call   80338c <_panic>
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	8b 10                	mov    (%eax),%edx
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	89 10                	mov    %edx,(%eax)
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	8b 00                	mov    (%eax),%eax
  80221b:	85 c0                	test   %eax,%eax
  80221d:	74 0b                	je     80222a <insert_sorted_allocList+0x222>
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 00                	mov    (%eax),%eax
  802224:	8b 55 08             	mov    0x8(%ebp),%edx
  802227:	89 50 04             	mov    %edx,0x4(%eax)
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	8b 55 08             	mov    0x8(%ebp),%edx
  802230:	89 10                	mov    %edx,(%eax)
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802238:	89 50 04             	mov    %edx,0x4(%eax)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	8b 00                	mov    (%eax),%eax
  802240:	85 c0                	test   %eax,%eax
  802242:	75 08                	jne    80224c <insert_sorted_allocList+0x244>
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	a3 44 50 80 00       	mov    %eax,0x805044
  80224c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802251:	40                   	inc    %eax
  802252:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802257:	eb 39                	jmp    802292 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802259:	a1 48 50 80 00       	mov    0x805048,%eax
  80225e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802261:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802265:	74 07                	je     80226e <insert_sorted_allocList+0x266>
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	8b 00                	mov    (%eax),%eax
  80226c:	eb 05                	jmp    802273 <insert_sorted_allocList+0x26b>
  80226e:	b8 00 00 00 00       	mov    $0x0,%eax
  802273:	a3 48 50 80 00       	mov    %eax,0x805048
  802278:	a1 48 50 80 00       	mov    0x805048,%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	0f 85 3f ff ff ff    	jne    8021c4 <insert_sorted_allocList+0x1bc>
  802285:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802289:	0f 85 35 ff ff ff    	jne    8021c4 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80228f:	eb 01                	jmp    802292 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802291:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802292:	90                   	nop
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80229b:	a1 38 51 80 00       	mov    0x805138,%eax
  8022a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a3:	e9 85 01 00 00       	jmp    80242d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022b1:	0f 82 6e 01 00 00    	jb     802425 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8022bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c0:	0f 85 8a 00 00 00    	jne    802350 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ca:	75 17                	jne    8022e3 <alloc_block_FF+0x4e>
  8022cc:	83 ec 04             	sub    $0x4,%esp
  8022cf:	68 98 40 80 00       	push   $0x804098
  8022d4:	68 93 00 00 00       	push   $0x93
  8022d9:	68 ef 3f 80 00       	push   $0x803fef
  8022de:	e8 a9 10 00 00       	call   80338c <_panic>
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	8b 00                	mov    (%eax),%eax
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	74 10                	je     8022fc <alloc_block_FF+0x67>
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 00                	mov    (%eax),%eax
  8022f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f4:	8b 52 04             	mov    0x4(%edx),%edx
  8022f7:	89 50 04             	mov    %edx,0x4(%eax)
  8022fa:	eb 0b                	jmp    802307 <alloc_block_FF+0x72>
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 40 04             	mov    0x4(%eax),%eax
  802302:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 40 04             	mov    0x4(%eax),%eax
  80230d:	85 c0                	test   %eax,%eax
  80230f:	74 0f                	je     802320 <alloc_block_FF+0x8b>
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 40 04             	mov    0x4(%eax),%eax
  802317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231a:	8b 12                	mov    (%edx),%edx
  80231c:	89 10                	mov    %edx,(%eax)
  80231e:	eb 0a                	jmp    80232a <alloc_block_FF+0x95>
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 00                	mov    (%eax),%eax
  802325:	a3 38 51 80 00       	mov    %eax,0x805138
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80233d:	a1 44 51 80 00       	mov    0x805144,%eax
  802342:	48                   	dec    %eax
  802343:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	e9 10 01 00 00       	jmp    802460 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 40 0c             	mov    0xc(%eax),%eax
  802356:	3b 45 08             	cmp    0x8(%ebp),%eax
  802359:	0f 86 c6 00 00 00    	jbe    802425 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80235f:	a1 48 51 80 00       	mov    0x805148,%eax
  802364:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236a:	8b 50 08             	mov    0x8(%eax),%edx
  80236d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802370:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802376:	8b 55 08             	mov    0x8(%ebp),%edx
  802379:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80237c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802380:	75 17                	jne    802399 <alloc_block_FF+0x104>
  802382:	83 ec 04             	sub    $0x4,%esp
  802385:	68 98 40 80 00       	push   $0x804098
  80238a:	68 9b 00 00 00       	push   $0x9b
  80238f:	68 ef 3f 80 00       	push   $0x803fef
  802394:	e8 f3 0f 00 00       	call   80338c <_panic>
  802399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	74 10                	je     8023b2 <alloc_block_FF+0x11d>
  8023a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023aa:	8b 52 04             	mov    0x4(%edx),%edx
  8023ad:	89 50 04             	mov    %edx,0x4(%eax)
  8023b0:	eb 0b                	jmp    8023bd <alloc_block_FF+0x128>
  8023b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b5:	8b 40 04             	mov    0x4(%eax),%eax
  8023b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c0:	8b 40 04             	mov    0x4(%eax),%eax
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	74 0f                	je     8023d6 <alloc_block_FF+0x141>
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	8b 40 04             	mov    0x4(%eax),%eax
  8023cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d0:	8b 12                	mov    (%edx),%edx
  8023d2:	89 10                	mov    %edx,(%eax)
  8023d4:	eb 0a                	jmp    8023e0 <alloc_block_FF+0x14b>
  8023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d9:	8b 00                	mov    (%eax),%eax
  8023db:	a3 48 51 80 00       	mov    %eax,0x805148
  8023e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f3:	a1 54 51 80 00       	mov    0x805154,%eax
  8023f8:	48                   	dec    %eax
  8023f9:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 50 08             	mov    0x8(%eax),%edx
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	01 c2                	add    %eax,%edx
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 40 0c             	mov    0xc(%eax),%eax
  802415:	2b 45 08             	sub    0x8(%ebp),%eax
  802418:	89 c2                	mov    %eax,%edx
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802423:	eb 3b                	jmp    802460 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802425:	a1 40 51 80 00       	mov    0x805140,%eax
  80242a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802431:	74 07                	je     80243a <alloc_block_FF+0x1a5>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	eb 05                	jmp    80243f <alloc_block_FF+0x1aa>
  80243a:	b8 00 00 00 00       	mov    $0x0,%eax
  80243f:	a3 40 51 80 00       	mov    %eax,0x805140
  802444:	a1 40 51 80 00       	mov    0x805140,%eax
  802449:	85 c0                	test   %eax,%eax
  80244b:	0f 85 57 fe ff ff    	jne    8022a8 <alloc_block_FF+0x13>
  802451:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802455:	0f 85 4d fe ff ff    	jne    8022a8 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80245b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
  802465:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802468:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80246f:	a1 38 51 80 00       	mov    0x805138,%eax
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802477:	e9 df 00 00 00       	jmp    80255b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 40 0c             	mov    0xc(%eax),%eax
  802482:	3b 45 08             	cmp    0x8(%ebp),%eax
  802485:	0f 82 c8 00 00 00    	jb     802553 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 0c             	mov    0xc(%eax),%eax
  802491:	3b 45 08             	cmp    0x8(%ebp),%eax
  802494:	0f 85 8a 00 00 00    	jne    802524 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80249a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249e:	75 17                	jne    8024b7 <alloc_block_BF+0x55>
  8024a0:	83 ec 04             	sub    $0x4,%esp
  8024a3:	68 98 40 80 00       	push   $0x804098
  8024a8:	68 b7 00 00 00       	push   $0xb7
  8024ad:	68 ef 3f 80 00       	push   $0x803fef
  8024b2:	e8 d5 0e 00 00       	call   80338c <_panic>
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	8b 00                	mov    (%eax),%eax
  8024bc:	85 c0                	test   %eax,%eax
  8024be:	74 10                	je     8024d0 <alloc_block_BF+0x6e>
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c8:	8b 52 04             	mov    0x4(%edx),%edx
  8024cb:	89 50 04             	mov    %edx,0x4(%eax)
  8024ce:	eb 0b                	jmp    8024db <alloc_block_BF+0x79>
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 40 04             	mov    0x4(%eax),%eax
  8024d6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 40 04             	mov    0x4(%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	74 0f                	je     8024f4 <alloc_block_BF+0x92>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ee:	8b 12                	mov    (%edx),%edx
  8024f0:	89 10                	mov    %edx,(%eax)
  8024f2:	eb 0a                	jmp    8024fe <alloc_block_BF+0x9c>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	a3 38 51 80 00       	mov    %eax,0x805138
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802511:	a1 44 51 80 00       	mov    0x805144,%eax
  802516:	48                   	dec    %eax
  802517:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	e9 4d 01 00 00       	jmp    802671 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 40 0c             	mov    0xc(%eax),%eax
  80252a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252d:	76 24                	jbe    802553 <alloc_block_BF+0xf1>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 40 0c             	mov    0xc(%eax),%eax
  802535:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802538:	73 19                	jae    802553 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80253a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 40 0c             	mov    0xc(%eax),%eax
  802547:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 40 08             	mov    0x8(%eax),%eax
  802550:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802553:	a1 40 51 80 00       	mov    0x805140,%eax
  802558:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255f:	74 07                	je     802568 <alloc_block_BF+0x106>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 00                	mov    (%eax),%eax
  802566:	eb 05                	jmp    80256d <alloc_block_BF+0x10b>
  802568:	b8 00 00 00 00       	mov    $0x0,%eax
  80256d:	a3 40 51 80 00       	mov    %eax,0x805140
  802572:	a1 40 51 80 00       	mov    0x805140,%eax
  802577:	85 c0                	test   %eax,%eax
  802579:	0f 85 fd fe ff ff    	jne    80247c <alloc_block_BF+0x1a>
  80257f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802583:	0f 85 f3 fe ff ff    	jne    80247c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802589:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80258d:	0f 84 d9 00 00 00    	je     80266c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802593:	a1 48 51 80 00       	mov    0x805148,%eax
  802598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80259b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025a1:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025aa:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025b1:	75 17                	jne    8025ca <alloc_block_BF+0x168>
  8025b3:	83 ec 04             	sub    $0x4,%esp
  8025b6:	68 98 40 80 00       	push   $0x804098
  8025bb:	68 c7 00 00 00       	push   $0xc7
  8025c0:	68 ef 3f 80 00       	push   $0x803fef
  8025c5:	e8 c2 0d 00 00       	call   80338c <_panic>
  8025ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cd:	8b 00                	mov    (%eax),%eax
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	74 10                	je     8025e3 <alloc_block_BF+0x181>
  8025d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025db:	8b 52 04             	mov    0x4(%edx),%edx
  8025de:	89 50 04             	mov    %edx,0x4(%eax)
  8025e1:	eb 0b                	jmp    8025ee <alloc_block_BF+0x18c>
  8025e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e6:	8b 40 04             	mov    0x4(%eax),%eax
  8025e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f1:	8b 40 04             	mov    0x4(%eax),%eax
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	74 0f                	je     802607 <alloc_block_BF+0x1a5>
  8025f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fb:	8b 40 04             	mov    0x4(%eax),%eax
  8025fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802601:	8b 12                	mov    (%edx),%edx
  802603:	89 10                	mov    %edx,(%eax)
  802605:	eb 0a                	jmp    802611 <alloc_block_BF+0x1af>
  802607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	a3 48 51 80 00       	mov    %eax,0x805148
  802611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802614:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80261a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802624:	a1 54 51 80 00       	mov    0x805154,%eax
  802629:	48                   	dec    %eax
  80262a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80262f:	83 ec 08             	sub    $0x8,%esp
  802632:	ff 75 ec             	pushl  -0x14(%ebp)
  802635:	68 38 51 80 00       	push   $0x805138
  80263a:	e8 71 f9 ff ff       	call   801fb0 <find_block>
  80263f:	83 c4 10             	add    $0x10,%esp
  802642:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802645:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802648:	8b 50 08             	mov    0x8(%eax),%edx
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	01 c2                	add    %eax,%edx
  802650:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802653:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802656:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802659:	8b 40 0c             	mov    0xc(%eax),%eax
  80265c:	2b 45 08             	sub    0x8(%ebp),%eax
  80265f:	89 c2                	mov    %eax,%edx
  802661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802664:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266a:	eb 05                	jmp    802671 <alloc_block_BF+0x20f>
	}
	return NULL;
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802679:	a1 28 50 80 00       	mov    0x805028,%eax
  80267e:	85 c0                	test   %eax,%eax
  802680:	0f 85 de 01 00 00    	jne    802864 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802686:	a1 38 51 80 00       	mov    0x805138,%eax
  80268b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268e:	e9 9e 01 00 00       	jmp    802831 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 0c             	mov    0xc(%eax),%eax
  802699:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269c:	0f 82 87 01 00 00    	jb     802829 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ab:	0f 85 95 00 00 00    	jne    802746 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b5:	75 17                	jne    8026ce <alloc_block_NF+0x5b>
  8026b7:	83 ec 04             	sub    $0x4,%esp
  8026ba:	68 98 40 80 00       	push   $0x804098
  8026bf:	68 e0 00 00 00       	push   $0xe0
  8026c4:	68 ef 3f 80 00       	push   $0x803fef
  8026c9:	e8 be 0c 00 00       	call   80338c <_panic>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	74 10                	je     8026e7 <alloc_block_NF+0x74>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026df:	8b 52 04             	mov    0x4(%edx),%edx
  8026e2:	89 50 04             	mov    %edx,0x4(%eax)
  8026e5:	eb 0b                	jmp    8026f2 <alloc_block_NF+0x7f>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 40 04             	mov    0x4(%eax),%eax
  8026ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 04             	mov    0x4(%eax),%eax
  8026f8:	85 c0                	test   %eax,%eax
  8026fa:	74 0f                	je     80270b <alloc_block_NF+0x98>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 04             	mov    0x4(%eax),%eax
  802702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802705:	8b 12                	mov    (%edx),%edx
  802707:	89 10                	mov    %edx,(%eax)
  802709:	eb 0a                	jmp    802715 <alloc_block_NF+0xa2>
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
				   svaOfNF = point->sva;
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 40 08             	mov    0x8(%eax),%eax
  802739:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	e9 f8 04 00 00       	jmp    802c3e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 40 0c             	mov    0xc(%eax),%eax
  80274c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274f:	0f 86 d4 00 00 00    	jbe    802829 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802755:	a1 48 51 80 00       	mov    0x805148,%eax
  80275a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 50 08             	mov    0x8(%eax),%edx
  802763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802766:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	8b 55 08             	mov    0x8(%ebp),%edx
  80276f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802772:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802776:	75 17                	jne    80278f <alloc_block_NF+0x11c>
  802778:	83 ec 04             	sub    $0x4,%esp
  80277b:	68 98 40 80 00       	push   $0x804098
  802780:	68 e9 00 00 00       	push   $0xe9
  802785:	68 ef 3f 80 00       	push   $0x803fef
  80278a:	e8 fd 0b 00 00       	call   80338c <_panic>
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	8b 00                	mov    (%eax),%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	74 10                	je     8027a8 <alloc_block_NF+0x135>
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a0:	8b 52 04             	mov    0x4(%edx),%edx
  8027a3:	89 50 04             	mov    %edx,0x4(%eax)
  8027a6:	eb 0b                	jmp    8027b3 <alloc_block_NF+0x140>
  8027a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ab:	8b 40 04             	mov    0x4(%eax),%eax
  8027ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b6:	8b 40 04             	mov    0x4(%eax),%eax
  8027b9:	85 c0                	test   %eax,%eax
  8027bb:	74 0f                	je     8027cc <alloc_block_NF+0x159>
  8027bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c0:	8b 40 04             	mov    0x4(%eax),%eax
  8027c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c6:	8b 12                	mov    (%edx),%edx
  8027c8:	89 10                	mov    %edx,(%eax)
  8027ca:	eb 0a                	jmp    8027d6 <alloc_block_NF+0x163>
  8027cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8027d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e9:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ee:	48                   	dec    %eax
  8027ef:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f7:	8b 40 08             	mov    0x8(%eax),%eax
  8027fa:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 50 08             	mov    0x8(%eax),%edx
  802805:	8b 45 08             	mov    0x8(%ebp),%eax
  802808:	01 c2                	add    %eax,%edx
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 40 0c             	mov    0xc(%eax),%eax
  802816:	2b 45 08             	sub    0x8(%ebp),%eax
  802819:	89 c2                	mov    %eax,%edx
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802824:	e9 15 04 00 00       	jmp    802c3e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802829:	a1 40 51 80 00       	mov    0x805140,%eax
  80282e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802835:	74 07                	je     80283e <alloc_block_NF+0x1cb>
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	eb 05                	jmp    802843 <alloc_block_NF+0x1d0>
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
  802843:	a3 40 51 80 00       	mov    %eax,0x805140
  802848:	a1 40 51 80 00       	mov    0x805140,%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	0f 85 3e fe ff ff    	jne    802693 <alloc_block_NF+0x20>
  802855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802859:	0f 85 34 fe ff ff    	jne    802693 <alloc_block_NF+0x20>
  80285f:	e9 d5 03 00 00       	jmp    802c39 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802864:	a1 38 51 80 00       	mov    0x805138,%eax
  802869:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286c:	e9 b1 01 00 00       	jmp    802a22 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 50 08             	mov    0x8(%eax),%edx
  802877:	a1 28 50 80 00       	mov    0x805028,%eax
  80287c:	39 c2                	cmp    %eax,%edx
  80287e:	0f 82 96 01 00 00    	jb     802a1a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 40 0c             	mov    0xc(%eax),%eax
  80288a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288d:	0f 82 87 01 00 00    	jb     802a1a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 40 0c             	mov    0xc(%eax),%eax
  802899:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289c:	0f 85 95 00 00 00    	jne    802937 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a6:	75 17                	jne    8028bf <alloc_block_NF+0x24c>
  8028a8:	83 ec 04             	sub    $0x4,%esp
  8028ab:	68 98 40 80 00       	push   $0x804098
  8028b0:	68 fc 00 00 00       	push   $0xfc
  8028b5:	68 ef 3f 80 00       	push   $0x803fef
  8028ba:	e8 cd 0a 00 00       	call   80338c <_panic>
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 00                	mov    (%eax),%eax
  8028c4:	85 c0                	test   %eax,%eax
  8028c6:	74 10                	je     8028d8 <alloc_block_NF+0x265>
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d0:	8b 52 04             	mov    0x4(%edx),%edx
  8028d3:	89 50 04             	mov    %edx,0x4(%eax)
  8028d6:	eb 0b                	jmp    8028e3 <alloc_block_NF+0x270>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 04             	mov    0x4(%eax),%eax
  8028de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 40 04             	mov    0x4(%eax),%eax
  8028e9:	85 c0                	test   %eax,%eax
  8028eb:	74 0f                	je     8028fc <alloc_block_NF+0x289>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 40 04             	mov    0x4(%eax),%eax
  8028f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f6:	8b 12                	mov    (%edx),%edx
  8028f8:	89 10                	mov    %edx,(%eax)
  8028fa:	eb 0a                	jmp    802906 <alloc_block_NF+0x293>
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	a3 38 51 80 00       	mov    %eax,0x805138
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802919:	a1 44 51 80 00       	mov    0x805144,%eax
  80291e:	48                   	dec    %eax
  80291f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 08             	mov    0x8(%eax),%eax
  80292a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	e9 07 03 00 00       	jmp    802c3e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 40 0c             	mov    0xc(%eax),%eax
  80293d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802940:	0f 86 d4 00 00 00    	jbe    802a1a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802946:	a1 48 51 80 00       	mov    0x805148,%eax
  80294b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 50 08             	mov    0x8(%eax),%edx
  802954:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802957:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80295a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295d:	8b 55 08             	mov    0x8(%ebp),%edx
  802960:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802963:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802967:	75 17                	jne    802980 <alloc_block_NF+0x30d>
  802969:	83 ec 04             	sub    $0x4,%esp
  80296c:	68 98 40 80 00       	push   $0x804098
  802971:	68 04 01 00 00       	push   $0x104
  802976:	68 ef 3f 80 00       	push   $0x803fef
  80297b:	e8 0c 0a 00 00       	call   80338c <_panic>
  802980:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802983:	8b 00                	mov    (%eax),%eax
  802985:	85 c0                	test   %eax,%eax
  802987:	74 10                	je     802999 <alloc_block_NF+0x326>
  802989:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298c:	8b 00                	mov    (%eax),%eax
  80298e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802991:	8b 52 04             	mov    0x4(%edx),%edx
  802994:	89 50 04             	mov    %edx,0x4(%eax)
  802997:	eb 0b                	jmp    8029a4 <alloc_block_NF+0x331>
  802999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299c:	8b 40 04             	mov    0x4(%eax),%eax
  80299f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a7:	8b 40 04             	mov    0x4(%eax),%eax
  8029aa:	85 c0                	test   %eax,%eax
  8029ac:	74 0f                	je     8029bd <alloc_block_NF+0x34a>
  8029ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b1:	8b 40 04             	mov    0x4(%eax),%eax
  8029b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029b7:	8b 12                	mov    (%edx),%edx
  8029b9:	89 10                	mov    %edx,(%eax)
  8029bb:	eb 0a                	jmp    8029c7 <alloc_block_NF+0x354>
  8029bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c0:	8b 00                	mov    (%eax),%eax
  8029c2:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029da:	a1 54 51 80 00       	mov    0x805154,%eax
  8029df:	48                   	dec    %eax
  8029e0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e8:	8b 40 08             	mov    0x8(%eax),%eax
  8029eb:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 50 08             	mov    0x8(%eax),%edx
  8029f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f9:	01 c2                	add    %eax,%edx
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 40 0c             	mov    0xc(%eax),%eax
  802a07:	2b 45 08             	sub    0x8(%ebp),%eax
  802a0a:	89 c2                	mov    %eax,%edx
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a15:	e9 24 02 00 00       	jmp    802c3e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a1a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a26:	74 07                	je     802a2f <alloc_block_NF+0x3bc>
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	eb 05                	jmp    802a34 <alloc_block_NF+0x3c1>
  802a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a34:	a3 40 51 80 00       	mov    %eax,0x805140
  802a39:	a1 40 51 80 00       	mov    0x805140,%eax
  802a3e:	85 c0                	test   %eax,%eax
  802a40:	0f 85 2b fe ff ff    	jne    802871 <alloc_block_NF+0x1fe>
  802a46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4a:	0f 85 21 fe ff ff    	jne    802871 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a50:	a1 38 51 80 00       	mov    0x805138,%eax
  802a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a58:	e9 ae 01 00 00       	jmp    802c0b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 50 08             	mov    0x8(%eax),%edx
  802a63:	a1 28 50 80 00       	mov    0x805028,%eax
  802a68:	39 c2                	cmp    %eax,%edx
  802a6a:	0f 83 93 01 00 00    	jae    802c03 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 0c             	mov    0xc(%eax),%eax
  802a76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a79:	0f 82 84 01 00 00    	jb     802c03 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 40 0c             	mov    0xc(%eax),%eax
  802a85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a88:	0f 85 95 00 00 00    	jne    802b23 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a92:	75 17                	jne    802aab <alloc_block_NF+0x438>
  802a94:	83 ec 04             	sub    $0x4,%esp
  802a97:	68 98 40 80 00       	push   $0x804098
  802a9c:	68 14 01 00 00       	push   $0x114
  802aa1:	68 ef 3f 80 00       	push   $0x803fef
  802aa6:	e8 e1 08 00 00       	call   80338c <_panic>
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 00                	mov    (%eax),%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	74 10                	je     802ac4 <alloc_block_NF+0x451>
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abc:	8b 52 04             	mov    0x4(%edx),%edx
  802abf:	89 50 04             	mov    %edx,0x4(%eax)
  802ac2:	eb 0b                	jmp    802acf <alloc_block_NF+0x45c>
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 40 04             	mov    0x4(%eax),%eax
  802aca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 04             	mov    0x4(%eax),%eax
  802ad5:	85 c0                	test   %eax,%eax
  802ad7:	74 0f                	je     802ae8 <alloc_block_NF+0x475>
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae2:	8b 12                	mov    (%edx),%edx
  802ae4:	89 10                	mov    %edx,(%eax)
  802ae6:	eb 0a                	jmp    802af2 <alloc_block_NF+0x47f>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	a3 38 51 80 00       	mov    %eax,0x805138
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b05:	a1 44 51 80 00       	mov    0x805144,%eax
  802b0a:	48                   	dec    %eax
  802b0b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 40 08             	mov    0x8(%eax),%eax
  802b16:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	e9 1b 01 00 00       	jmp    802c3e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 40 0c             	mov    0xc(%eax),%eax
  802b29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2c:	0f 86 d1 00 00 00    	jbe    802c03 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b32:	a1 48 51 80 00       	mov    0x805148,%eax
  802b37:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 50 08             	mov    0x8(%eax),%edx
  802b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b43:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b49:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b53:	75 17                	jne    802b6c <alloc_block_NF+0x4f9>
  802b55:	83 ec 04             	sub    $0x4,%esp
  802b58:	68 98 40 80 00       	push   $0x804098
  802b5d:	68 1c 01 00 00       	push   $0x11c
  802b62:	68 ef 3f 80 00       	push   $0x803fef
  802b67:	e8 20 08 00 00       	call   80338c <_panic>
  802b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	74 10                	je     802b85 <alloc_block_NF+0x512>
  802b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b7d:	8b 52 04             	mov    0x4(%edx),%edx
  802b80:	89 50 04             	mov    %edx,0x4(%eax)
  802b83:	eb 0b                	jmp    802b90 <alloc_block_NF+0x51d>
  802b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b88:	8b 40 04             	mov    0x4(%eax),%eax
  802b8b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	8b 40 04             	mov    0x4(%eax),%eax
  802b96:	85 c0                	test   %eax,%eax
  802b98:	74 0f                	je     802ba9 <alloc_block_NF+0x536>
  802b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ba0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ba3:	8b 12                	mov    (%edx),%edx
  802ba5:	89 10                	mov    %edx,(%eax)
  802ba7:	eb 0a                	jmp    802bb3 <alloc_block_NF+0x540>
  802ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc6:	a1 54 51 80 00       	mov    0x805154,%eax
  802bcb:	48                   	dec    %eax
  802bcc:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd4:	8b 40 08             	mov    0x8(%eax),%eax
  802bd7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 50 08             	mov    0x8(%eax),%edx
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	01 c2                	add    %eax,%edx
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf3:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf6:	89 c2                	mov    %eax,%edx
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c01:	eb 3b                	jmp    802c3e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c03:	a1 40 51 80 00       	mov    0x805140,%eax
  802c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0f:	74 07                	je     802c18 <alloc_block_NF+0x5a5>
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 00                	mov    (%eax),%eax
  802c16:	eb 05                	jmp    802c1d <alloc_block_NF+0x5aa>
  802c18:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1d:	a3 40 51 80 00       	mov    %eax,0x805140
  802c22:	a1 40 51 80 00       	mov    0x805140,%eax
  802c27:	85 c0                	test   %eax,%eax
  802c29:	0f 85 2e fe ff ff    	jne    802a5d <alloc_block_NF+0x3ea>
  802c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c33:	0f 85 24 fe ff ff    	jne    802a5d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c3e:	c9                   	leave  
  802c3f:	c3                   	ret    

00802c40 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c40:	55                   	push   %ebp
  802c41:	89 e5                	mov    %esp,%ebp
  802c43:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c46:	a1 38 51 80 00       	mov    0x805138,%eax
  802c4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c4e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c53:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c56:	a1 38 51 80 00       	mov    0x805138,%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	74 14                	je     802c73 <insert_sorted_with_merge_freeList+0x33>
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 50 08             	mov    0x8(%eax),%edx
  802c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c68:	8b 40 08             	mov    0x8(%eax),%eax
  802c6b:	39 c2                	cmp    %eax,%edx
  802c6d:	0f 87 9b 01 00 00    	ja     802e0e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c77:	75 17                	jne    802c90 <insert_sorted_with_merge_freeList+0x50>
  802c79:	83 ec 04             	sub    $0x4,%esp
  802c7c:	68 cc 3f 80 00       	push   $0x803fcc
  802c81:	68 38 01 00 00       	push   $0x138
  802c86:	68 ef 3f 80 00       	push   $0x803fef
  802c8b:	e8 fc 06 00 00       	call   80338c <_panic>
  802c90:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	89 10                	mov    %edx,(%eax)
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 00                	mov    (%eax),%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	74 0d                	je     802cb1 <insert_sorted_with_merge_freeList+0x71>
  802ca4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cac:	89 50 04             	mov    %edx,0x4(%eax)
  802caf:	eb 08                	jmp    802cb9 <insert_sorted_with_merge_freeList+0x79>
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccb:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd0:	40                   	inc    %eax
  802cd1:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cda:	0f 84 a8 06 00 00    	je     803388 <insert_sorted_with_merge_freeList+0x748>
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	8b 50 08             	mov    0x8(%eax),%edx
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cec:	01 c2                	add    %eax,%edx
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 40 08             	mov    0x8(%eax),%eax
  802cf4:	39 c2                	cmp    %eax,%edx
  802cf6:	0f 85 8c 06 00 00    	jne    803388 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	8b 50 0c             	mov    0xc(%eax),%edx
  802d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d05:	8b 40 0c             	mov    0xc(%eax),%eax
  802d08:	01 c2                	add    %eax,%edx
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d14:	75 17                	jne    802d2d <insert_sorted_with_merge_freeList+0xed>
  802d16:	83 ec 04             	sub    $0x4,%esp
  802d19:	68 98 40 80 00       	push   $0x804098
  802d1e:	68 3c 01 00 00       	push   $0x13c
  802d23:	68 ef 3f 80 00       	push   $0x803fef
  802d28:	e8 5f 06 00 00       	call   80338c <_panic>
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	74 10                	je     802d46 <insert_sorted_with_merge_freeList+0x106>
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3e:	8b 52 04             	mov    0x4(%edx),%edx
  802d41:	89 50 04             	mov    %edx,0x4(%eax)
  802d44:	eb 0b                	jmp    802d51 <insert_sorted_with_merge_freeList+0x111>
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	8b 40 04             	mov    0x4(%eax),%eax
  802d4c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	85 c0                	test   %eax,%eax
  802d59:	74 0f                	je     802d6a <insert_sorted_with_merge_freeList+0x12a>
  802d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d64:	8b 12                	mov    (%edx),%edx
  802d66:	89 10                	mov    %edx,(%eax)
  802d68:	eb 0a                	jmp    802d74 <insert_sorted_with_merge_freeList+0x134>
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d87:	a1 44 51 80 00       	mov    0x805144,%eax
  802d8c:	48                   	dec    %eax
  802d8d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d95:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802da6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802daa:	75 17                	jne    802dc3 <insert_sorted_with_merge_freeList+0x183>
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	68 cc 3f 80 00       	push   $0x803fcc
  802db4:	68 3f 01 00 00       	push   $0x13f
  802db9:	68 ef 3f 80 00       	push   $0x803fef
  802dbe:	e8 c9 05 00 00       	call   80338c <_panic>
  802dc3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcc:	89 10                	mov    %edx,(%eax)
  802dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 0d                	je     802de4 <insert_sorted_with_merge_freeList+0x1a4>
  802dd7:	a1 48 51 80 00       	mov    0x805148,%eax
  802ddc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddf:	89 50 04             	mov    %edx,0x4(%eax)
  802de2:	eb 08                	jmp    802dec <insert_sorted_with_merge_freeList+0x1ac>
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802def:	a3 48 51 80 00       	mov    %eax,0x805148
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfe:	a1 54 51 80 00       	mov    0x805154,%eax
  802e03:	40                   	inc    %eax
  802e04:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e09:	e9 7a 05 00 00       	jmp    803388 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	8b 50 08             	mov    0x8(%eax),%edx
  802e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e17:	8b 40 08             	mov    0x8(%eax),%eax
  802e1a:	39 c2                	cmp    %eax,%edx
  802e1c:	0f 82 14 01 00 00    	jb     802f36 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e25:	8b 50 08             	mov    0x8(%eax),%edx
  802e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2e:	01 c2                	add    %eax,%edx
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	8b 40 08             	mov    0x8(%eax),%eax
  802e36:	39 c2                	cmp    %eax,%edx
  802e38:	0f 85 90 00 00 00    	jne    802ece <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e41:	8b 50 0c             	mov    0xc(%eax),%edx
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4a:	01 c2                	add    %eax,%edx
  802e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6a:	75 17                	jne    802e83 <insert_sorted_with_merge_freeList+0x243>
  802e6c:	83 ec 04             	sub    $0x4,%esp
  802e6f:	68 cc 3f 80 00       	push   $0x803fcc
  802e74:	68 49 01 00 00       	push   $0x149
  802e79:	68 ef 3f 80 00       	push   $0x803fef
  802e7e:	e8 09 05 00 00       	call   80338c <_panic>
  802e83:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	89 10                	mov    %edx,(%eax)
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	8b 00                	mov    (%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 0d                	je     802ea4 <insert_sorted_with_merge_freeList+0x264>
  802e97:	a1 48 51 80 00       	mov    0x805148,%eax
  802e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ea2:	eb 08                	jmp    802eac <insert_sorted_with_merge_freeList+0x26c>
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	a3 48 51 80 00       	mov    %eax,0x805148
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebe:	a1 54 51 80 00       	mov    0x805154,%eax
  802ec3:	40                   	inc    %eax
  802ec4:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ec9:	e9 bb 04 00 00       	jmp    803389 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ece:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed2:	75 17                	jne    802eeb <insert_sorted_with_merge_freeList+0x2ab>
  802ed4:	83 ec 04             	sub    $0x4,%esp
  802ed7:	68 40 40 80 00       	push   $0x804040
  802edc:	68 4c 01 00 00       	push   $0x14c
  802ee1:	68 ef 3f 80 00       	push   $0x803fef
  802ee6:	e8 a1 04 00 00       	call   80338c <_panic>
  802eeb:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	89 50 04             	mov    %edx,0x4(%eax)
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	8b 40 04             	mov    0x4(%eax),%eax
  802efd:	85 c0                	test   %eax,%eax
  802eff:	74 0c                	je     802f0d <insert_sorted_with_merge_freeList+0x2cd>
  802f01:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f06:	8b 55 08             	mov    0x8(%ebp),%edx
  802f09:	89 10                	mov    %edx,(%eax)
  802f0b:	eb 08                	jmp    802f15 <insert_sorted_with_merge_freeList+0x2d5>
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	a3 38 51 80 00       	mov    %eax,0x805138
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f26:	a1 44 51 80 00       	mov    0x805144,%eax
  802f2b:	40                   	inc    %eax
  802f2c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f31:	e9 53 04 00 00       	jmp    803389 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f36:	a1 38 51 80 00       	mov    0x805138,%eax
  802f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3e:	e9 15 04 00 00       	jmp    803358 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	8b 50 08             	mov    0x8(%eax),%edx
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 40 08             	mov    0x8(%eax),%eax
  802f57:	39 c2                	cmp    %eax,%edx
  802f59:	0f 86 f1 03 00 00    	jbe    803350 <insert_sorted_with_merge_freeList+0x710>
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	8b 50 08             	mov    0x8(%eax),%edx
  802f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f68:	8b 40 08             	mov    0x8(%eax),%eax
  802f6b:	39 c2                	cmp    %eax,%edx
  802f6d:	0f 83 dd 03 00 00    	jae    803350 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 50 08             	mov    0x8(%eax),%edx
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7f:	01 c2                	add    %eax,%edx
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	8b 40 08             	mov    0x8(%eax),%eax
  802f87:	39 c2                	cmp    %eax,%edx
  802f89:	0f 85 b9 01 00 00    	jne    803148 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	8b 50 08             	mov    0x8(%eax),%edx
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9b:	01 c2                	add    %eax,%edx
  802f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa0:	8b 40 08             	mov    0x8(%eax),%eax
  802fa3:	39 c2                	cmp    %eax,%edx
  802fa5:	0f 85 0d 01 00 00    	jne    8030b8 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb7:	01 c2                	add    %eax,%edx
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fbf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fc3:	75 17                	jne    802fdc <insert_sorted_with_merge_freeList+0x39c>
  802fc5:	83 ec 04             	sub    $0x4,%esp
  802fc8:	68 98 40 80 00       	push   $0x804098
  802fcd:	68 5c 01 00 00       	push   $0x15c
  802fd2:	68 ef 3f 80 00       	push   $0x803fef
  802fd7:	e8 b0 03 00 00       	call   80338c <_panic>
  802fdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdf:	8b 00                	mov    (%eax),%eax
  802fe1:	85 c0                	test   %eax,%eax
  802fe3:	74 10                	je     802ff5 <insert_sorted_with_merge_freeList+0x3b5>
  802fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fed:	8b 52 04             	mov    0x4(%edx),%edx
  802ff0:	89 50 04             	mov    %edx,0x4(%eax)
  802ff3:	eb 0b                	jmp    803000 <insert_sorted_with_merge_freeList+0x3c0>
  802ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff8:	8b 40 04             	mov    0x4(%eax),%eax
  802ffb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803000:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803003:	8b 40 04             	mov    0x4(%eax),%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	74 0f                	je     803019 <insert_sorted_with_merge_freeList+0x3d9>
  80300a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300d:	8b 40 04             	mov    0x4(%eax),%eax
  803010:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803013:	8b 12                	mov    (%edx),%edx
  803015:	89 10                	mov    %edx,(%eax)
  803017:	eb 0a                	jmp    803023 <insert_sorted_with_merge_freeList+0x3e3>
  803019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301c:	8b 00                	mov    (%eax),%eax
  80301e:	a3 38 51 80 00       	mov    %eax,0x805138
  803023:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803026:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803036:	a1 44 51 80 00       	mov    0x805144,%eax
  80303b:	48                   	dec    %eax
  80303c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803044:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80304b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803055:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803059:	75 17                	jne    803072 <insert_sorted_with_merge_freeList+0x432>
  80305b:	83 ec 04             	sub    $0x4,%esp
  80305e:	68 cc 3f 80 00       	push   $0x803fcc
  803063:	68 5f 01 00 00       	push   $0x15f
  803068:	68 ef 3f 80 00       	push   $0x803fef
  80306d:	e8 1a 03 00 00       	call   80338c <_panic>
  803072:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307b:	89 10                	mov    %edx,(%eax)
  80307d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	85 c0                	test   %eax,%eax
  803084:	74 0d                	je     803093 <insert_sorted_with_merge_freeList+0x453>
  803086:	a1 48 51 80 00       	mov    0x805148,%eax
  80308b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308e:	89 50 04             	mov    %edx,0x4(%eax)
  803091:	eb 08                	jmp    80309b <insert_sorted_with_merge_freeList+0x45b>
  803093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803096:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80309b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309e:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b2:	40                   	inc    %eax
  8030b3:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c4:	01 c2                	add    %eax,%edx
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e4:	75 17                	jne    8030fd <insert_sorted_with_merge_freeList+0x4bd>
  8030e6:	83 ec 04             	sub    $0x4,%esp
  8030e9:	68 cc 3f 80 00       	push   $0x803fcc
  8030ee:	68 64 01 00 00       	push   $0x164
  8030f3:	68 ef 3f 80 00       	push   $0x803fef
  8030f8:	e8 8f 02 00 00       	call   80338c <_panic>
  8030fd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803103:	8b 45 08             	mov    0x8(%ebp),%eax
  803106:	89 10                	mov    %edx,(%eax)
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	74 0d                	je     80311e <insert_sorted_with_merge_freeList+0x4de>
  803111:	a1 48 51 80 00       	mov    0x805148,%eax
  803116:	8b 55 08             	mov    0x8(%ebp),%edx
  803119:	89 50 04             	mov    %edx,0x4(%eax)
  80311c:	eb 08                	jmp    803126 <insert_sorted_with_merge_freeList+0x4e6>
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	a3 48 51 80 00       	mov    %eax,0x805148
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803138:	a1 54 51 80 00       	mov    0x805154,%eax
  80313d:	40                   	inc    %eax
  80313e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803143:	e9 41 02 00 00       	jmp    803389 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	8b 50 08             	mov    0x8(%eax),%edx
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	8b 40 0c             	mov    0xc(%eax),%eax
  803154:	01 c2                	add    %eax,%edx
  803156:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803159:	8b 40 08             	mov    0x8(%eax),%eax
  80315c:	39 c2                	cmp    %eax,%edx
  80315e:	0f 85 7c 01 00 00    	jne    8032e0 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803164:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803168:	74 06                	je     803170 <insert_sorted_with_merge_freeList+0x530>
  80316a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316e:	75 17                	jne    803187 <insert_sorted_with_merge_freeList+0x547>
  803170:	83 ec 04             	sub    $0x4,%esp
  803173:	68 08 40 80 00       	push   $0x804008
  803178:	68 69 01 00 00       	push   $0x169
  80317d:	68 ef 3f 80 00       	push   $0x803fef
  803182:	e8 05 02 00 00       	call   80338c <_panic>
  803187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318a:	8b 50 04             	mov    0x4(%eax),%edx
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	89 50 04             	mov    %edx,0x4(%eax)
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803199:	89 10                	mov    %edx,(%eax)
  80319b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319e:	8b 40 04             	mov    0x4(%eax),%eax
  8031a1:	85 c0                	test   %eax,%eax
  8031a3:	74 0d                	je     8031b2 <insert_sorted_with_merge_freeList+0x572>
  8031a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a8:	8b 40 04             	mov    0x4(%eax),%eax
  8031ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ae:	89 10                	mov    %edx,(%eax)
  8031b0:	eb 08                	jmp    8031ba <insert_sorted_with_merge_freeList+0x57a>
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c0:	89 50 04             	mov    %edx,0x4(%eax)
  8031c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c8:	40                   	inc    %eax
  8031c9:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031da:	01 c2                	add    %eax,%edx
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e6:	75 17                	jne    8031ff <insert_sorted_with_merge_freeList+0x5bf>
  8031e8:	83 ec 04             	sub    $0x4,%esp
  8031eb:	68 98 40 80 00       	push   $0x804098
  8031f0:	68 6b 01 00 00       	push   $0x16b
  8031f5:	68 ef 3f 80 00       	push   $0x803fef
  8031fa:	e8 8d 01 00 00       	call   80338c <_panic>
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	85 c0                	test   %eax,%eax
  803206:	74 10                	je     803218 <insert_sorted_with_merge_freeList+0x5d8>
  803208:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320b:	8b 00                	mov    (%eax),%eax
  80320d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803210:	8b 52 04             	mov    0x4(%edx),%edx
  803213:	89 50 04             	mov    %edx,0x4(%eax)
  803216:	eb 0b                	jmp    803223 <insert_sorted_with_merge_freeList+0x5e3>
  803218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321b:	8b 40 04             	mov    0x4(%eax),%eax
  80321e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803223:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803226:	8b 40 04             	mov    0x4(%eax),%eax
  803229:	85 c0                	test   %eax,%eax
  80322b:	74 0f                	je     80323c <insert_sorted_with_merge_freeList+0x5fc>
  80322d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803230:	8b 40 04             	mov    0x4(%eax),%eax
  803233:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803236:	8b 12                	mov    (%edx),%edx
  803238:	89 10                	mov    %edx,(%eax)
  80323a:	eb 0a                	jmp    803246 <insert_sorted_with_merge_freeList+0x606>
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	a3 38 51 80 00       	mov    %eax,0x805138
  803246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803252:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803259:	a1 44 51 80 00       	mov    0x805144,%eax
  80325e:	48                   	dec    %eax
  80325f:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80326e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803271:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803278:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80327c:	75 17                	jne    803295 <insert_sorted_with_merge_freeList+0x655>
  80327e:	83 ec 04             	sub    $0x4,%esp
  803281:	68 cc 3f 80 00       	push   $0x803fcc
  803286:	68 6e 01 00 00       	push   $0x16e
  80328b:	68 ef 3f 80 00       	push   $0x803fef
  803290:	e8 f7 00 00 00       	call   80338c <_panic>
  803295:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	89 10                	mov    %edx,(%eax)
  8032a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a3:	8b 00                	mov    (%eax),%eax
  8032a5:	85 c0                	test   %eax,%eax
  8032a7:	74 0d                	je     8032b6 <insert_sorted_with_merge_freeList+0x676>
  8032a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b1:	89 50 04             	mov    %edx,0x4(%eax)
  8032b4:	eb 08                	jmp    8032be <insert_sorted_with_merge_freeList+0x67e>
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8032c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8032d5:	40                   	inc    %eax
  8032d6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032db:	e9 a9 00 00 00       	jmp    803389 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e4:	74 06                	je     8032ec <insert_sorted_with_merge_freeList+0x6ac>
  8032e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ea:	75 17                	jne    803303 <insert_sorted_with_merge_freeList+0x6c3>
  8032ec:	83 ec 04             	sub    $0x4,%esp
  8032ef:	68 64 40 80 00       	push   $0x804064
  8032f4:	68 73 01 00 00       	push   $0x173
  8032f9:	68 ef 3f 80 00       	push   $0x803fef
  8032fe:	e8 89 00 00 00       	call   80338c <_panic>
  803303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803306:	8b 10                	mov    (%eax),%edx
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	89 10                	mov    %edx,(%eax)
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	74 0b                	je     803321 <insert_sorted_with_merge_freeList+0x6e1>
  803316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	8b 55 08             	mov    0x8(%ebp),%edx
  80331e:	89 50 04             	mov    %edx,0x4(%eax)
  803321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803324:	8b 55 08             	mov    0x8(%ebp),%edx
  803327:	89 10                	mov    %edx,(%eax)
  803329:	8b 45 08             	mov    0x8(%ebp),%eax
  80332c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80332f:	89 50 04             	mov    %edx,0x4(%eax)
  803332:	8b 45 08             	mov    0x8(%ebp),%eax
  803335:	8b 00                	mov    (%eax),%eax
  803337:	85 c0                	test   %eax,%eax
  803339:	75 08                	jne    803343 <insert_sorted_with_merge_freeList+0x703>
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803343:	a1 44 51 80 00       	mov    0x805144,%eax
  803348:	40                   	inc    %eax
  803349:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80334e:	eb 39                	jmp    803389 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803350:	a1 40 51 80 00       	mov    0x805140,%eax
  803355:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80335c:	74 07                	je     803365 <insert_sorted_with_merge_freeList+0x725>
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 00                	mov    (%eax),%eax
  803363:	eb 05                	jmp    80336a <insert_sorted_with_merge_freeList+0x72a>
  803365:	b8 00 00 00 00       	mov    $0x0,%eax
  80336a:	a3 40 51 80 00       	mov    %eax,0x805140
  80336f:	a1 40 51 80 00       	mov    0x805140,%eax
  803374:	85 c0                	test   %eax,%eax
  803376:	0f 85 c7 fb ff ff    	jne    802f43 <insert_sorted_with_merge_freeList+0x303>
  80337c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803380:	0f 85 bd fb ff ff    	jne    802f43 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803386:	eb 01                	jmp    803389 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803388:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803389:	90                   	nop
  80338a:	c9                   	leave  
  80338b:	c3                   	ret    

0080338c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80338c:	55                   	push   %ebp
  80338d:	89 e5                	mov    %esp,%ebp
  80338f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803392:	8d 45 10             	lea    0x10(%ebp),%eax
  803395:	83 c0 04             	add    $0x4,%eax
  803398:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80339b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	74 16                	je     8033ba <_panic+0x2e>
		cprintf("%s: ", argv0);
  8033a4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8033a9:	83 ec 08             	sub    $0x8,%esp
  8033ac:	50                   	push   %eax
  8033ad:	68 b8 40 80 00       	push   $0x8040b8
  8033b2:	e8 6b d2 ff ff       	call   800622 <cprintf>
  8033b7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8033ba:	a1 00 50 80 00       	mov    0x805000,%eax
  8033bf:	ff 75 0c             	pushl  0xc(%ebp)
  8033c2:	ff 75 08             	pushl  0x8(%ebp)
  8033c5:	50                   	push   %eax
  8033c6:	68 bd 40 80 00       	push   $0x8040bd
  8033cb:	e8 52 d2 ff ff       	call   800622 <cprintf>
  8033d0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8033d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8033d6:	83 ec 08             	sub    $0x8,%esp
  8033d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8033dc:	50                   	push   %eax
  8033dd:	e8 d5 d1 ff ff       	call   8005b7 <vcprintf>
  8033e2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8033e5:	83 ec 08             	sub    $0x8,%esp
  8033e8:	6a 00                	push   $0x0
  8033ea:	68 d9 40 80 00       	push   $0x8040d9
  8033ef:	e8 c3 d1 ff ff       	call   8005b7 <vcprintf>
  8033f4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8033f7:	e8 44 d1 ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  8033fc:	eb fe                	jmp    8033fc <_panic+0x70>

008033fe <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8033fe:	55                   	push   %ebp
  8033ff:	89 e5                	mov    %esp,%ebp
  803401:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803404:	a1 20 50 80 00       	mov    0x805020,%eax
  803409:	8b 50 74             	mov    0x74(%eax),%edx
  80340c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340f:	39 c2                	cmp    %eax,%edx
  803411:	74 14                	je     803427 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803413:	83 ec 04             	sub    $0x4,%esp
  803416:	68 dc 40 80 00       	push   $0x8040dc
  80341b:	6a 26                	push   $0x26
  80341d:	68 28 41 80 00       	push   $0x804128
  803422:	e8 65 ff ff ff       	call   80338c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803427:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80342e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803435:	e9 c2 00 00 00       	jmp    8034fc <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80343a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	01 d0                	add    %edx,%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	85 c0                	test   %eax,%eax
  80344d:	75 08                	jne    803457 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80344f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803452:	e9 a2 00 00 00       	jmp    8034f9 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803457:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80345e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803465:	eb 69                	jmp    8034d0 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803467:	a1 20 50 80 00       	mov    0x805020,%eax
  80346c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803472:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803475:	89 d0                	mov    %edx,%eax
  803477:	01 c0                	add    %eax,%eax
  803479:	01 d0                	add    %edx,%eax
  80347b:	c1 e0 03             	shl    $0x3,%eax
  80347e:	01 c8                	add    %ecx,%eax
  803480:	8a 40 04             	mov    0x4(%eax),%al
  803483:	84 c0                	test   %al,%al
  803485:	75 46                	jne    8034cd <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803487:	a1 20 50 80 00       	mov    0x805020,%eax
  80348c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803492:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803495:	89 d0                	mov    %edx,%eax
  803497:	01 c0                	add    %eax,%eax
  803499:	01 d0                	add    %edx,%eax
  80349b:	c1 e0 03             	shl    $0x3,%eax
  80349e:	01 c8                	add    %ecx,%eax
  8034a0:	8b 00                	mov    (%eax),%eax
  8034a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8034a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8034ad:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8034af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bc:	01 c8                	add    %ecx,%eax
  8034be:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034c0:	39 c2                	cmp    %eax,%edx
  8034c2:	75 09                	jne    8034cd <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8034c4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8034cb:	eb 12                	jmp    8034df <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034cd:	ff 45 e8             	incl   -0x18(%ebp)
  8034d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8034d5:	8b 50 74             	mov    0x74(%eax),%edx
  8034d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034db:	39 c2                	cmp    %eax,%edx
  8034dd:	77 88                	ja     803467 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8034df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034e3:	75 14                	jne    8034f9 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8034e5:	83 ec 04             	sub    $0x4,%esp
  8034e8:	68 34 41 80 00       	push   $0x804134
  8034ed:	6a 3a                	push   $0x3a
  8034ef:	68 28 41 80 00       	push   $0x804128
  8034f4:	e8 93 fe ff ff       	call   80338c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8034f9:	ff 45 f0             	incl   -0x10(%ebp)
  8034fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803502:	0f 8c 32 ff ff ff    	jl     80343a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803508:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80350f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803516:	eb 26                	jmp    80353e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803518:	a1 20 50 80 00       	mov    0x805020,%eax
  80351d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803523:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803526:	89 d0                	mov    %edx,%eax
  803528:	01 c0                	add    %eax,%eax
  80352a:	01 d0                	add    %edx,%eax
  80352c:	c1 e0 03             	shl    $0x3,%eax
  80352f:	01 c8                	add    %ecx,%eax
  803531:	8a 40 04             	mov    0x4(%eax),%al
  803534:	3c 01                	cmp    $0x1,%al
  803536:	75 03                	jne    80353b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803538:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80353b:	ff 45 e0             	incl   -0x20(%ebp)
  80353e:	a1 20 50 80 00       	mov    0x805020,%eax
  803543:	8b 50 74             	mov    0x74(%eax),%edx
  803546:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803549:	39 c2                	cmp    %eax,%edx
  80354b:	77 cb                	ja     803518 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803550:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803553:	74 14                	je     803569 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	68 88 41 80 00       	push   $0x804188
  80355d:	6a 44                	push   $0x44
  80355f:	68 28 41 80 00       	push   $0x804128
  803564:	e8 23 fe ff ff       	call   80338c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803569:	90                   	nop
  80356a:	c9                   	leave  
  80356b:	c3                   	ret    

0080356c <__udivdi3>:
  80356c:	55                   	push   %ebp
  80356d:	57                   	push   %edi
  80356e:	56                   	push   %esi
  80356f:	53                   	push   %ebx
  803570:	83 ec 1c             	sub    $0x1c,%esp
  803573:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803577:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80357b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80357f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803583:	89 ca                	mov    %ecx,%edx
  803585:	89 f8                	mov    %edi,%eax
  803587:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80358b:	85 f6                	test   %esi,%esi
  80358d:	75 2d                	jne    8035bc <__udivdi3+0x50>
  80358f:	39 cf                	cmp    %ecx,%edi
  803591:	77 65                	ja     8035f8 <__udivdi3+0x8c>
  803593:	89 fd                	mov    %edi,%ebp
  803595:	85 ff                	test   %edi,%edi
  803597:	75 0b                	jne    8035a4 <__udivdi3+0x38>
  803599:	b8 01 00 00 00       	mov    $0x1,%eax
  80359e:	31 d2                	xor    %edx,%edx
  8035a0:	f7 f7                	div    %edi
  8035a2:	89 c5                	mov    %eax,%ebp
  8035a4:	31 d2                	xor    %edx,%edx
  8035a6:	89 c8                	mov    %ecx,%eax
  8035a8:	f7 f5                	div    %ebp
  8035aa:	89 c1                	mov    %eax,%ecx
  8035ac:	89 d8                	mov    %ebx,%eax
  8035ae:	f7 f5                	div    %ebp
  8035b0:	89 cf                	mov    %ecx,%edi
  8035b2:	89 fa                	mov    %edi,%edx
  8035b4:	83 c4 1c             	add    $0x1c,%esp
  8035b7:	5b                   	pop    %ebx
  8035b8:	5e                   	pop    %esi
  8035b9:	5f                   	pop    %edi
  8035ba:	5d                   	pop    %ebp
  8035bb:	c3                   	ret    
  8035bc:	39 ce                	cmp    %ecx,%esi
  8035be:	77 28                	ja     8035e8 <__udivdi3+0x7c>
  8035c0:	0f bd fe             	bsr    %esi,%edi
  8035c3:	83 f7 1f             	xor    $0x1f,%edi
  8035c6:	75 40                	jne    803608 <__udivdi3+0x9c>
  8035c8:	39 ce                	cmp    %ecx,%esi
  8035ca:	72 0a                	jb     8035d6 <__udivdi3+0x6a>
  8035cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035d0:	0f 87 9e 00 00 00    	ja     803674 <__udivdi3+0x108>
  8035d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035db:	89 fa                	mov    %edi,%edx
  8035dd:	83 c4 1c             	add    $0x1c,%esp
  8035e0:	5b                   	pop    %ebx
  8035e1:	5e                   	pop    %esi
  8035e2:	5f                   	pop    %edi
  8035e3:	5d                   	pop    %ebp
  8035e4:	c3                   	ret    
  8035e5:	8d 76 00             	lea    0x0(%esi),%esi
  8035e8:	31 ff                	xor    %edi,%edi
  8035ea:	31 c0                	xor    %eax,%eax
  8035ec:	89 fa                	mov    %edi,%edx
  8035ee:	83 c4 1c             	add    $0x1c,%esp
  8035f1:	5b                   	pop    %ebx
  8035f2:	5e                   	pop    %esi
  8035f3:	5f                   	pop    %edi
  8035f4:	5d                   	pop    %ebp
  8035f5:	c3                   	ret    
  8035f6:	66 90                	xchg   %ax,%ax
  8035f8:	89 d8                	mov    %ebx,%eax
  8035fa:	f7 f7                	div    %edi
  8035fc:	31 ff                	xor    %edi,%edi
  8035fe:	89 fa                	mov    %edi,%edx
  803600:	83 c4 1c             	add    $0x1c,%esp
  803603:	5b                   	pop    %ebx
  803604:	5e                   	pop    %esi
  803605:	5f                   	pop    %edi
  803606:	5d                   	pop    %ebp
  803607:	c3                   	ret    
  803608:	bd 20 00 00 00       	mov    $0x20,%ebp
  80360d:	89 eb                	mov    %ebp,%ebx
  80360f:	29 fb                	sub    %edi,%ebx
  803611:	89 f9                	mov    %edi,%ecx
  803613:	d3 e6                	shl    %cl,%esi
  803615:	89 c5                	mov    %eax,%ebp
  803617:	88 d9                	mov    %bl,%cl
  803619:	d3 ed                	shr    %cl,%ebp
  80361b:	89 e9                	mov    %ebp,%ecx
  80361d:	09 f1                	or     %esi,%ecx
  80361f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803623:	89 f9                	mov    %edi,%ecx
  803625:	d3 e0                	shl    %cl,%eax
  803627:	89 c5                	mov    %eax,%ebp
  803629:	89 d6                	mov    %edx,%esi
  80362b:	88 d9                	mov    %bl,%cl
  80362d:	d3 ee                	shr    %cl,%esi
  80362f:	89 f9                	mov    %edi,%ecx
  803631:	d3 e2                	shl    %cl,%edx
  803633:	8b 44 24 08          	mov    0x8(%esp),%eax
  803637:	88 d9                	mov    %bl,%cl
  803639:	d3 e8                	shr    %cl,%eax
  80363b:	09 c2                	or     %eax,%edx
  80363d:	89 d0                	mov    %edx,%eax
  80363f:	89 f2                	mov    %esi,%edx
  803641:	f7 74 24 0c          	divl   0xc(%esp)
  803645:	89 d6                	mov    %edx,%esi
  803647:	89 c3                	mov    %eax,%ebx
  803649:	f7 e5                	mul    %ebp
  80364b:	39 d6                	cmp    %edx,%esi
  80364d:	72 19                	jb     803668 <__udivdi3+0xfc>
  80364f:	74 0b                	je     80365c <__udivdi3+0xf0>
  803651:	89 d8                	mov    %ebx,%eax
  803653:	31 ff                	xor    %edi,%edi
  803655:	e9 58 ff ff ff       	jmp    8035b2 <__udivdi3+0x46>
  80365a:	66 90                	xchg   %ax,%ax
  80365c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803660:	89 f9                	mov    %edi,%ecx
  803662:	d3 e2                	shl    %cl,%edx
  803664:	39 c2                	cmp    %eax,%edx
  803666:	73 e9                	jae    803651 <__udivdi3+0xe5>
  803668:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80366b:	31 ff                	xor    %edi,%edi
  80366d:	e9 40 ff ff ff       	jmp    8035b2 <__udivdi3+0x46>
  803672:	66 90                	xchg   %ax,%ax
  803674:	31 c0                	xor    %eax,%eax
  803676:	e9 37 ff ff ff       	jmp    8035b2 <__udivdi3+0x46>
  80367b:	90                   	nop

0080367c <__umoddi3>:
  80367c:	55                   	push   %ebp
  80367d:	57                   	push   %edi
  80367e:	56                   	push   %esi
  80367f:	53                   	push   %ebx
  803680:	83 ec 1c             	sub    $0x1c,%esp
  803683:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803687:	8b 74 24 34          	mov    0x34(%esp),%esi
  80368b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80368f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803693:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803697:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80369b:	89 f3                	mov    %esi,%ebx
  80369d:	89 fa                	mov    %edi,%edx
  80369f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036a3:	89 34 24             	mov    %esi,(%esp)
  8036a6:	85 c0                	test   %eax,%eax
  8036a8:	75 1a                	jne    8036c4 <__umoddi3+0x48>
  8036aa:	39 f7                	cmp    %esi,%edi
  8036ac:	0f 86 a2 00 00 00    	jbe    803754 <__umoddi3+0xd8>
  8036b2:	89 c8                	mov    %ecx,%eax
  8036b4:	89 f2                	mov    %esi,%edx
  8036b6:	f7 f7                	div    %edi
  8036b8:	89 d0                	mov    %edx,%eax
  8036ba:	31 d2                	xor    %edx,%edx
  8036bc:	83 c4 1c             	add    $0x1c,%esp
  8036bf:	5b                   	pop    %ebx
  8036c0:	5e                   	pop    %esi
  8036c1:	5f                   	pop    %edi
  8036c2:	5d                   	pop    %ebp
  8036c3:	c3                   	ret    
  8036c4:	39 f0                	cmp    %esi,%eax
  8036c6:	0f 87 ac 00 00 00    	ja     803778 <__umoddi3+0xfc>
  8036cc:	0f bd e8             	bsr    %eax,%ebp
  8036cf:	83 f5 1f             	xor    $0x1f,%ebp
  8036d2:	0f 84 ac 00 00 00    	je     803784 <__umoddi3+0x108>
  8036d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8036dd:	29 ef                	sub    %ebp,%edi
  8036df:	89 fe                	mov    %edi,%esi
  8036e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036e5:	89 e9                	mov    %ebp,%ecx
  8036e7:	d3 e0                	shl    %cl,%eax
  8036e9:	89 d7                	mov    %edx,%edi
  8036eb:	89 f1                	mov    %esi,%ecx
  8036ed:	d3 ef                	shr    %cl,%edi
  8036ef:	09 c7                	or     %eax,%edi
  8036f1:	89 e9                	mov    %ebp,%ecx
  8036f3:	d3 e2                	shl    %cl,%edx
  8036f5:	89 14 24             	mov    %edx,(%esp)
  8036f8:	89 d8                	mov    %ebx,%eax
  8036fa:	d3 e0                	shl    %cl,%eax
  8036fc:	89 c2                	mov    %eax,%edx
  8036fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803702:	d3 e0                	shl    %cl,%eax
  803704:	89 44 24 04          	mov    %eax,0x4(%esp)
  803708:	8b 44 24 08          	mov    0x8(%esp),%eax
  80370c:	89 f1                	mov    %esi,%ecx
  80370e:	d3 e8                	shr    %cl,%eax
  803710:	09 d0                	or     %edx,%eax
  803712:	d3 eb                	shr    %cl,%ebx
  803714:	89 da                	mov    %ebx,%edx
  803716:	f7 f7                	div    %edi
  803718:	89 d3                	mov    %edx,%ebx
  80371a:	f7 24 24             	mull   (%esp)
  80371d:	89 c6                	mov    %eax,%esi
  80371f:	89 d1                	mov    %edx,%ecx
  803721:	39 d3                	cmp    %edx,%ebx
  803723:	0f 82 87 00 00 00    	jb     8037b0 <__umoddi3+0x134>
  803729:	0f 84 91 00 00 00    	je     8037c0 <__umoddi3+0x144>
  80372f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803733:	29 f2                	sub    %esi,%edx
  803735:	19 cb                	sbb    %ecx,%ebx
  803737:	89 d8                	mov    %ebx,%eax
  803739:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80373d:	d3 e0                	shl    %cl,%eax
  80373f:	89 e9                	mov    %ebp,%ecx
  803741:	d3 ea                	shr    %cl,%edx
  803743:	09 d0                	or     %edx,%eax
  803745:	89 e9                	mov    %ebp,%ecx
  803747:	d3 eb                	shr    %cl,%ebx
  803749:	89 da                	mov    %ebx,%edx
  80374b:	83 c4 1c             	add    $0x1c,%esp
  80374e:	5b                   	pop    %ebx
  80374f:	5e                   	pop    %esi
  803750:	5f                   	pop    %edi
  803751:	5d                   	pop    %ebp
  803752:	c3                   	ret    
  803753:	90                   	nop
  803754:	89 fd                	mov    %edi,%ebp
  803756:	85 ff                	test   %edi,%edi
  803758:	75 0b                	jne    803765 <__umoddi3+0xe9>
  80375a:	b8 01 00 00 00       	mov    $0x1,%eax
  80375f:	31 d2                	xor    %edx,%edx
  803761:	f7 f7                	div    %edi
  803763:	89 c5                	mov    %eax,%ebp
  803765:	89 f0                	mov    %esi,%eax
  803767:	31 d2                	xor    %edx,%edx
  803769:	f7 f5                	div    %ebp
  80376b:	89 c8                	mov    %ecx,%eax
  80376d:	f7 f5                	div    %ebp
  80376f:	89 d0                	mov    %edx,%eax
  803771:	e9 44 ff ff ff       	jmp    8036ba <__umoddi3+0x3e>
  803776:	66 90                	xchg   %ax,%ax
  803778:	89 c8                	mov    %ecx,%eax
  80377a:	89 f2                	mov    %esi,%edx
  80377c:	83 c4 1c             	add    $0x1c,%esp
  80377f:	5b                   	pop    %ebx
  803780:	5e                   	pop    %esi
  803781:	5f                   	pop    %edi
  803782:	5d                   	pop    %ebp
  803783:	c3                   	ret    
  803784:	3b 04 24             	cmp    (%esp),%eax
  803787:	72 06                	jb     80378f <__umoddi3+0x113>
  803789:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80378d:	77 0f                	ja     80379e <__umoddi3+0x122>
  80378f:	89 f2                	mov    %esi,%edx
  803791:	29 f9                	sub    %edi,%ecx
  803793:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803797:	89 14 24             	mov    %edx,(%esp)
  80379a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80379e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037a2:	8b 14 24             	mov    (%esp),%edx
  8037a5:	83 c4 1c             	add    $0x1c,%esp
  8037a8:	5b                   	pop    %ebx
  8037a9:	5e                   	pop    %esi
  8037aa:	5f                   	pop    %edi
  8037ab:	5d                   	pop    %ebp
  8037ac:	c3                   	ret    
  8037ad:	8d 76 00             	lea    0x0(%esi),%esi
  8037b0:	2b 04 24             	sub    (%esp),%eax
  8037b3:	19 fa                	sbb    %edi,%edx
  8037b5:	89 d1                	mov    %edx,%ecx
  8037b7:	89 c6                	mov    %eax,%esi
  8037b9:	e9 71 ff ff ff       	jmp    80372f <__umoddi3+0xb3>
  8037be:	66 90                	xchg   %ax,%ax
  8037c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037c4:	72 ea                	jb     8037b0 <__umoddi3+0x134>
  8037c6:	89 d9                	mov    %ebx,%ecx
  8037c8:	e9 62 ff ff ff       	jmp    80372f <__umoddi3+0xb3>
