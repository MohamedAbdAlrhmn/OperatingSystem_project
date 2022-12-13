
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
  800044:	e8 c1 1b 00 00       	call   801c0a <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 69 39 80 00       	mov    $0x803969,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 73 39 80 00       	mov    $0x803973,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 7f 39 80 00       	mov    $0x80397f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 8e 39 80 00       	mov    $0x80398e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 9d 39 80 00       	mov    $0x80399d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb b2 39 80 00       	mov    $0x8039b2,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb c7 39 80 00       	mov    $0x8039c7,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb d8 39 80 00       	mov    $0x8039d8,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb e9 39 80 00       	mov    $0x8039e9,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb fa 39 80 00       	mov    $0x8039fa,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 03 3a 80 00       	mov    $0x803a03,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 0d 3a 80 00       	mov    $0x803a0d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 18 3a 80 00       	mov    $0x803a18,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 24 3a 80 00       	mov    $0x803a24,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 2e 3a 80 00       	mov    $0x803a2e,%ebx
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
  8001be:	bb 38 3a 80 00       	mov    $0x803a38,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 46 3a 80 00       	mov    $0x803a46,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 55 3a 80 00       	mov    $0x803a55,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 5c 3a 80 00       	mov    $0x803a5c,%ebx
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
  800222:	e8 c6 14 00 00       	call   8016ed <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 b1 14 00 00       	call   8016ed <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 99 14 00 00       	call   8016ed <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 81 14 00 00       	call   8016ed <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 27 18 00 00       	call   801aab <sys_waitSemaphore>
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
  8002a9:	e8 1b 18 00 00       	call   801ac9 <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 e8 17 00 00       	call   801aab <sys_waitSemaphore>
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
  8002e7:	e8 bf 17 00 00       	call   801aab <sys_waitSemaphore>
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
  80031f:	e8 a5 17 00 00       	call   801ac9 <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 90 17 00 00       	call   801ac9 <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb 63 3a 80 00       	mov    $0x803a63,%ebx
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
  8003aa:	e8 fc 16 00 00       	call   801aab <sys_waitSemaphore>
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
  8003d2:	68 20 39 80 00       	push   $0x803920
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 48 39 80 00       	push   $0x803948
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 c3 16 00 00       	call   801ac9 <sys_signalSemaphore>
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
  800418:	e8 d4 17 00 00       	call   801bf1 <sys_getenvindex>
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
  800483:	e8 76 15 00 00       	call   8019fe <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 9c 3a 80 00       	push   $0x803a9c
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
  8004b3:	68 c4 3a 80 00       	push   $0x803ac4
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
  8004e4:	68 ec 3a 80 00       	push   $0x803aec
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 44 3b 80 00       	push   $0x803b44
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 9c 3a 80 00       	push   $0x803a9c
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 f6 14 00 00       	call   801a18 <sys_enable_interrupt>

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
  800535:	e8 83 16 00 00       	call   801bbd <sys_destroy_env>
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
  800546:	e8 d8 16 00 00       	call   801c23 <sys_exit_env>
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
  800594:	e8 b7 12 00 00       	call   801850 <sys_cputs>
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
  80060b:	e8 40 12 00 00       	call   801850 <sys_cputs>
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
  800655:	e8 a4 13 00 00       	call   8019fe <sys_disable_interrupt>
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
  800675:	e8 9e 13 00 00       	call   801a18 <sys_enable_interrupt>
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
  8006bf:	e8 f0 2f 00 00       	call   8036b4 <__udivdi3>
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
  80070f:	e8 b0 30 00 00       	call   8037c4 <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 74 3d 80 00       	add    $0x803d74,%eax
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
  80086a:	8b 04 85 98 3d 80 00 	mov    0x803d98(,%eax,4),%eax
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
  80094b:	8b 34 9d e0 3b 80 00 	mov    0x803be0(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 85 3d 80 00       	push   $0x803d85
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
  800970:	68 8e 3d 80 00       	push   $0x803d8e
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
  80099d:	be 91 3d 80 00       	mov    $0x803d91,%esi
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
  8013c3:	68 f0 3e 80 00       	push   $0x803ef0
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
  801493:	e8 fc 04 00 00       	call   801994 <sys_allocate_chunk>
  801498:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80149b:	a1 20 51 80 00       	mov    0x805120,%eax
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	50                   	push   %eax
  8014a4:	e8 71 0b 00 00       	call   80201a <initialize_MemBlocksList>
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
  8014d1:	68 15 3f 80 00       	push   $0x803f15
  8014d6:	6a 33                	push   $0x33
  8014d8:	68 33 3f 80 00       	push   $0x803f33
  8014dd:	e8 f1 1f 00 00       	call   8034d3 <_panic>
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
  801550:	68 40 3f 80 00       	push   $0x803f40
  801555:	6a 34                	push   $0x34
  801557:	68 33 3f 80 00       	push   $0x803f33
  80155c:	e8 72 1f 00 00       	call   8034d3 <_panic>
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
  8015e8:	e8 75 07 00 00       	call   801d62 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	74 11                	je     801602 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f7:	e8 e0 0d 00 00       	call   8023dc <alloc_block_FF>
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
  80160e:	e8 3c 0b 00 00       	call   80214f <insert_sorted_allocList>
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
  801628:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	68 64 3f 80 00       	push   $0x803f64
  801633:	6a 6f                	push   $0x6f
  801635:	68 33 3f 80 00       	push   $0x803f33
  80163a:	e8 94 1e 00 00       	call   8034d3 <_panic>

0080163f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 38             	sub    $0x38,%esp
  801645:	8b 45 10             	mov    0x10(%ebp),%eax
  801648:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80164b:	e8 5c fd ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  801650:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801654:	75 0a                	jne    801660 <smalloc+0x21>
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	e9 8b 00 00 00       	jmp    8016eb <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801660:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166d:	01 d0                	add    %edx,%eax
  80166f:	48                   	dec    %eax
  801670:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801673:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801676:	ba 00 00 00 00       	mov    $0x0,%edx
  80167b:	f7 75 f0             	divl   -0x10(%ebp)
  80167e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801681:	29 d0                	sub    %edx,%eax
  801683:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801686:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80168d:	e8 d0 06 00 00       	call   801d62 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801692:	85 c0                	test   %eax,%eax
  801694:	74 11                	je     8016a7 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801696:	83 ec 0c             	sub    $0xc,%esp
  801699:	ff 75 e8             	pushl  -0x18(%ebp)
  80169c:	e8 3b 0d 00 00       	call   8023dc <alloc_block_FF>
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016ab:	74 39                	je     8016e6 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b0:	8b 40 08             	mov    0x8(%eax),%eax
  8016b3:	89 c2                	mov    %eax,%edx
  8016b5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016b9:	52                   	push   %edx
  8016ba:	50                   	push   %eax
  8016bb:	ff 75 0c             	pushl  0xc(%ebp)
  8016be:	ff 75 08             	pushl  0x8(%ebp)
  8016c1:	e8 21 04 00 00       	call   801ae7 <sys_createSharedObject>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016cc:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016d0:	74 14                	je     8016e6 <smalloc+0xa7>
  8016d2:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016d6:	74 0e                	je     8016e6 <smalloc+0xa7>
  8016d8:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016dc:	74 08                	je     8016e6 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e1:	8b 40 08             	mov    0x8(%eax),%eax
  8016e4:	eb 05                	jmp    8016eb <smalloc+0xac>
	}
	return NULL;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f3:	e8 b4 fc ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016f8:	83 ec 08             	sub    $0x8,%esp
  8016fb:	ff 75 0c             	pushl  0xc(%ebp)
  8016fe:	ff 75 08             	pushl  0x8(%ebp)
  801701:	e8 0b 04 00 00       	call   801b11 <sys_getSizeOfSharedObject>
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80170c:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801710:	74 76                	je     801788 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801712:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801719:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80171c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	48                   	dec    %eax
  801722:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801725:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801728:	ba 00 00 00 00       	mov    $0x0,%edx
  80172d:	f7 75 ec             	divl   -0x14(%ebp)
  801730:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801733:	29 d0                	sub    %edx,%eax
  801735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801738:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80173f:	e8 1e 06 00 00       	call   801d62 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801744:	85 c0                	test   %eax,%eax
  801746:	74 11                	je     801759 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80174e:	e8 89 0c 00 00       	call   8023dc <alloc_block_FF>
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801759:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80175d:	74 29                	je     801788 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80175f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801762:	8b 40 08             	mov    0x8(%eax),%eax
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	50                   	push   %eax
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	ff 75 08             	pushl  0x8(%ebp)
  80176f:	e8 ba 03 00 00       	call   801b2e <sys_getSharedObject>
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80177a:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80177e:	74 08                	je     801788 <sget+0x9b>
				return (void *)mem_block->sva;
  801780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801783:	8b 40 08             	mov    0x8(%eax),%eax
  801786:	eb 05                	jmp    80178d <sget+0xa0>
		}
	}
	return (void *)NULL;
  801788:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801795:	e8 12 fc ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	68 88 3f 80 00       	push   $0x803f88
  8017a2:	68 f1 00 00 00       	push   $0xf1
  8017a7:	68 33 3f 80 00       	push   $0x803f33
  8017ac:	e8 22 1d 00 00       	call   8034d3 <_panic>

008017b1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	68 b0 3f 80 00       	push   $0x803fb0
  8017bf:	68 05 01 00 00       	push   $0x105
  8017c4:	68 33 3f 80 00       	push   $0x803f33
  8017c9:	e8 05 1d 00 00       	call   8034d3 <_panic>

008017ce <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	68 d4 3f 80 00       	push   $0x803fd4
  8017dc:	68 10 01 00 00       	push   $0x110
  8017e1:	68 33 3f 80 00       	push   $0x803f33
  8017e6:	e8 e8 1c 00 00       	call   8034d3 <_panic>

008017eb <shrink>:

}
void shrink(uint32 newSize)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	68 d4 3f 80 00       	push   $0x803fd4
  8017f9:	68 15 01 00 00       	push   $0x115
  8017fe:	68 33 3f 80 00       	push   $0x803f33
  801803:	e8 cb 1c 00 00       	call   8034d3 <_panic>

00801808 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 d4 3f 80 00       	push   $0x803fd4
  801816:	68 1a 01 00 00       	push   $0x11a
  80181b:	68 33 3f 80 00       	push   $0x803f33
  801820:	e8 ae 1c 00 00       	call   8034d3 <_panic>

00801825 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	57                   	push   %edi
  801829:	56                   	push   %esi
  80182a:	53                   	push   %ebx
  80182b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8b 55 0c             	mov    0xc(%ebp),%edx
  801834:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801837:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80183a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80183d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801840:	cd 30                	int    $0x30
  801842:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801845:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801848:	83 c4 10             	add    $0x10,%esp
  80184b:	5b                   	pop    %ebx
  80184c:	5e                   	pop    %esi
  80184d:	5f                   	pop    %edi
  80184e:	5d                   	pop    %ebp
  80184f:	c3                   	ret    

00801850 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 04             	sub    $0x4,%esp
  801856:	8b 45 10             	mov    0x10(%ebp),%eax
  801859:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80185c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	52                   	push   %edx
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	50                   	push   %eax
  80186c:	6a 00                	push   $0x0
  80186e:	e8 b2 ff ff ff       	call   801825 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	90                   	nop
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_cgetc>:

int
sys_cgetc(void)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 01                	push   $0x1
  801888:	e8 98 ff ff ff       	call   801825 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801895:	8b 55 0c             	mov    0xc(%ebp),%edx
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	52                   	push   %edx
  8018a2:	50                   	push   %eax
  8018a3:	6a 05                	push   $0x5
  8018a5:	e8 7b ff ff ff       	call   801825 <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b4:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	56                   	push   %esi
  8018c4:	53                   	push   %ebx
  8018c5:	51                   	push   %ecx
  8018c6:	52                   	push   %edx
  8018c7:	50                   	push   %eax
  8018c8:	6a 06                	push   $0x6
  8018ca:	e8 56 ff ff ff       	call   801825 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d5:	5b                   	pop    %ebx
  8018d6:	5e                   	pop    %esi
  8018d7:	5d                   	pop    %ebp
  8018d8:	c3                   	ret    

008018d9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	52                   	push   %edx
  8018e9:	50                   	push   %eax
  8018ea:	6a 07                	push   $0x7
  8018ec:	e8 34 ff ff ff       	call   801825 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	6a 08                	push   $0x8
  801907:	e8 19 ff ff ff       	call   801825 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 09                	push   $0x9
  801920:	e8 00 ff ff ff       	call   801825 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 0a                	push   $0xa
  801939:	e8 e7 fe ff ff       	call   801825 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 0b                	push   $0xb
  801952:	e8 ce fe ff ff       	call   801825 <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	ff 75 08             	pushl  0x8(%ebp)
  80196b:	6a 0f                	push   $0xf
  80196d:	e8 b3 fe ff ff       	call   801825 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
	return;
  801975:	90                   	nop
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	ff 75 0c             	pushl  0xc(%ebp)
  801984:	ff 75 08             	pushl  0x8(%ebp)
  801987:	6a 10                	push   $0x10
  801989:	e8 97 fe ff ff       	call   801825 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
	return ;
  801991:	90                   	nop
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	ff 75 10             	pushl  0x10(%ebp)
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	ff 75 08             	pushl  0x8(%ebp)
  8019a4:	6a 11                	push   $0x11
  8019a6:	e8 7a fe ff ff       	call   801825 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ae:	90                   	nop
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 0c                	push   $0xc
  8019c0:	e8 60 fe ff ff       	call   801825 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	ff 75 08             	pushl  0x8(%ebp)
  8019d8:	6a 0d                	push   $0xd
  8019da:	e8 46 fe ff ff       	call   801825 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 0e                	push   $0xe
  8019f3:	e8 2d fe ff ff       	call   801825 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 13                	push   $0x13
  801a0d:	e8 13 fe ff ff       	call   801825 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 14                	push   $0x14
  801a27:	e8 f9 fd ff ff       	call   801825 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	90                   	nop
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a3e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	50                   	push   %eax
  801a4b:	6a 15                	push   $0x15
  801a4d:	e8 d3 fd ff ff       	call   801825 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	90                   	nop
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 16                	push   $0x16
  801a67:	e8 b9 fd ff ff       	call   801825 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	90                   	nop
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	ff 75 0c             	pushl  0xc(%ebp)
  801a81:	50                   	push   %eax
  801a82:	6a 17                	push   $0x17
  801a84:	e8 9c fd ff ff       	call   801825 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	52                   	push   %edx
  801a9e:	50                   	push   %eax
  801a9f:	6a 1a                	push   $0x1a
  801aa1:	e8 7f fd ff ff       	call   801825 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	52                   	push   %edx
  801abb:	50                   	push   %eax
  801abc:	6a 18                	push   $0x18
  801abe:	e8 62 fd ff ff       	call   801825 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	90                   	nop
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 19                	push   $0x19
  801adc:	e8 44 fd ff ff       	call   801825 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	90                   	nop
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	83 ec 04             	sub    $0x4,%esp
  801aed:	8b 45 10             	mov    0x10(%ebp),%eax
  801af0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801af3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	6a 00                	push   $0x0
  801aff:	51                   	push   %ecx
  801b00:	52                   	push   %edx
  801b01:	ff 75 0c             	pushl  0xc(%ebp)
  801b04:	50                   	push   %eax
  801b05:	6a 1b                	push   $0x1b
  801b07:	e8 19 fd ff ff       	call   801825 <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	52                   	push   %edx
  801b21:	50                   	push   %eax
  801b22:	6a 1c                	push   $0x1c
  801b24:	e8 fc fc ff ff       	call   801825 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	51                   	push   %ecx
  801b3f:	52                   	push   %edx
  801b40:	50                   	push   %eax
  801b41:	6a 1d                	push   $0x1d
  801b43:	e8 dd fc ff ff       	call   801825 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	52                   	push   %edx
  801b5d:	50                   	push   %eax
  801b5e:	6a 1e                	push   $0x1e
  801b60:	e8 c0 fc ff ff       	call   801825 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 1f                	push   $0x1f
  801b79:	e8 a7 fc ff ff       	call   801825 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	6a 00                	push   $0x0
  801b8b:	ff 75 14             	pushl  0x14(%ebp)
  801b8e:	ff 75 10             	pushl  0x10(%ebp)
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	50                   	push   %eax
  801b95:	6a 20                	push   $0x20
  801b97:	e8 89 fc ff ff       	call   801825 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	50                   	push   %eax
  801bb0:	6a 21                	push   $0x21
  801bb2:	e8 6e fc ff ff       	call   801825 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	90                   	nop
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	50                   	push   %eax
  801bcc:	6a 22                	push   $0x22
  801bce:	e8 52 fc ff ff       	call   801825 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 02                	push   $0x2
  801be7:	e8 39 fc ff ff       	call   801825 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 03                	push   $0x3
  801c00:	e8 20 fc ff ff       	call   801825 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 04                	push   $0x4
  801c19:	e8 07 fc ff ff       	call   801825 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_exit_env>:


void sys_exit_env(void)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 23                	push   $0x23
  801c32:	e8 ee fb ff ff       	call   801825 <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
}
  801c3a:	90                   	nop
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c43:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c46:	8d 50 04             	lea    0x4(%eax),%edx
  801c49:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	52                   	push   %edx
  801c53:	50                   	push   %eax
  801c54:	6a 24                	push   $0x24
  801c56:	e8 ca fb ff ff       	call   801825 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
	return result;
  801c5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c67:	89 01                	mov    %eax,(%ecx)
  801c69:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	c9                   	leave  
  801c70:	c2 04 00             	ret    $0x4

00801c73 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	ff 75 10             	pushl  0x10(%ebp)
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	ff 75 08             	pushl  0x8(%ebp)
  801c83:	6a 12                	push   $0x12
  801c85:	e8 9b fb ff ff       	call   801825 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8d:	90                   	nop
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 25                	push   $0x25
  801c9f:	e8 81 fb ff ff       	call   801825 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 04             	sub    $0x4,%esp
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cb5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	50                   	push   %eax
  801cc2:	6a 26                	push   $0x26
  801cc4:	e8 5c fb ff ff       	call   801825 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccc:	90                   	nop
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <rsttst>:
void rsttst()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 28                	push   $0x28
  801cde:	e8 42 fb ff ff       	call   801825 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce6:	90                   	nop
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cf5:	8b 55 18             	mov    0x18(%ebp),%edx
  801cf8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cfc:	52                   	push   %edx
  801cfd:	50                   	push   %eax
  801cfe:	ff 75 10             	pushl  0x10(%ebp)
  801d01:	ff 75 0c             	pushl  0xc(%ebp)
  801d04:	ff 75 08             	pushl  0x8(%ebp)
  801d07:	6a 27                	push   $0x27
  801d09:	e8 17 fb ff ff       	call   801825 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d11:	90                   	nop
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <chktst>:
void chktst(uint32 n)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	ff 75 08             	pushl  0x8(%ebp)
  801d22:	6a 29                	push   $0x29
  801d24:	e8 fc fa ff ff       	call   801825 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2c:	90                   	nop
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <inctst>:

void inctst()
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 2a                	push   $0x2a
  801d3e:	e8 e2 fa ff ff       	call   801825 <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
	return ;
  801d46:	90                   	nop
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <gettst>:
uint32 gettst()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 2b                	push   $0x2b
  801d58:	e8 c8 fa ff ff       	call   801825 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 2c                	push   $0x2c
  801d74:	e8 ac fa ff ff       	call   801825 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
  801d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d7f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d83:	75 07                	jne    801d8c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d85:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8a:	eb 05                	jmp    801d91 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 2c                	push   $0x2c
  801da5:	e8 7b fa ff ff       	call   801825 <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
  801dad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801db0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801db4:	75 07                	jne    801dbd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801db6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbb:	eb 05                	jmp    801dc2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 2c                	push   $0x2c
  801dd6:	e8 4a fa ff ff       	call   801825 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
  801dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801de1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801de5:	75 07                	jne    801dee <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801de7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dec:	eb 05                	jmp    801df3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 2c                	push   $0x2c
  801e07:	e8 19 fa ff ff       	call   801825 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
  801e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e12:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e16:	75 07                	jne    801e1f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e18:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1d:	eb 05                	jmp    801e24 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	ff 75 08             	pushl  0x8(%ebp)
  801e34:	6a 2d                	push   $0x2d
  801e36:	e8 ea f9 ff ff       	call   801825 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3e:	90                   	nop
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e45:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e51:	6a 00                	push   $0x0
  801e53:	53                   	push   %ebx
  801e54:	51                   	push   %ecx
  801e55:	52                   	push   %edx
  801e56:	50                   	push   %eax
  801e57:	6a 2e                	push   $0x2e
  801e59:	e8 c7 f9 ff ff       	call   801825 <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	52                   	push   %edx
  801e76:	50                   	push   %eax
  801e77:	6a 2f                	push   $0x2f
  801e79:	e8 a7 f9 ff ff       	call   801825 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e89:	83 ec 0c             	sub    $0xc,%esp
  801e8c:	68 e4 3f 80 00       	push   $0x803fe4
  801e91:	e8 8c e7 ff ff       	call   800622 <cprintf>
  801e96:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e99:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ea0:	83 ec 0c             	sub    $0xc,%esp
  801ea3:	68 10 40 80 00       	push   $0x804010
  801ea8:	e8 75 e7 ff ff       	call   800622 <cprintf>
  801ead:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eb0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eb4:	a1 38 51 80 00       	mov    0x805138,%eax
  801eb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ebc:	eb 56                	jmp    801f14 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ebe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ec2:	74 1c                	je     801ee0 <print_mem_block_lists+0x5d>
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec7:	8b 50 08             	mov    0x8(%eax),%edx
  801eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecd:	8b 48 08             	mov    0x8(%eax),%ecx
  801ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed6:	01 c8                	add    %ecx,%eax
  801ed8:	39 c2                	cmp    %eax,%edx
  801eda:	73 04                	jae    801ee0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801edc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee3:	8b 50 08             	mov    0x8(%eax),%edx
  801ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee9:	8b 40 0c             	mov    0xc(%eax),%eax
  801eec:	01 c2                	add    %eax,%edx
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	8b 40 08             	mov    0x8(%eax),%eax
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	52                   	push   %edx
  801ef8:	50                   	push   %eax
  801ef9:	68 25 40 80 00       	push   $0x804025
  801efe:	e8 1f e7 ff ff       	call   800622 <cprintf>
  801f03:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f0c:	a1 40 51 80 00       	mov    0x805140,%eax
  801f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f18:	74 07                	je     801f21 <print_mem_block_lists+0x9e>
  801f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1d:	8b 00                	mov    (%eax),%eax
  801f1f:	eb 05                	jmp    801f26 <print_mem_block_lists+0xa3>
  801f21:	b8 00 00 00 00       	mov    $0x0,%eax
  801f26:	a3 40 51 80 00       	mov    %eax,0x805140
  801f2b:	a1 40 51 80 00       	mov    0x805140,%eax
  801f30:	85 c0                	test   %eax,%eax
  801f32:	75 8a                	jne    801ebe <print_mem_block_lists+0x3b>
  801f34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f38:	75 84                	jne    801ebe <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f3a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f3e:	75 10                	jne    801f50 <print_mem_block_lists+0xcd>
  801f40:	83 ec 0c             	sub    $0xc,%esp
  801f43:	68 34 40 80 00       	push   $0x804034
  801f48:	e8 d5 e6 ff ff       	call   800622 <cprintf>
  801f4d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f50:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f57:	83 ec 0c             	sub    $0xc,%esp
  801f5a:	68 58 40 80 00       	push   $0x804058
  801f5f:	e8 be e6 ff ff       	call   800622 <cprintf>
  801f64:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f67:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f6b:	a1 40 50 80 00       	mov    0x805040,%eax
  801f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f73:	eb 56                	jmp    801fcb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f79:	74 1c                	je     801f97 <print_mem_block_lists+0x114>
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	8b 50 08             	mov    0x8(%eax),%edx
  801f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f84:	8b 48 08             	mov    0x8(%eax),%ecx
  801f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8d:	01 c8                	add    %ecx,%eax
  801f8f:	39 c2                	cmp    %eax,%edx
  801f91:	73 04                	jae    801f97 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f93:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	8b 50 08             	mov    0x8(%eax),%edx
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa3:	01 c2                	add    %eax,%edx
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	8b 40 08             	mov    0x8(%eax),%eax
  801fab:	83 ec 04             	sub    $0x4,%esp
  801fae:	52                   	push   %edx
  801faf:	50                   	push   %eax
  801fb0:	68 25 40 80 00       	push   $0x804025
  801fb5:	e8 68 e6 ff ff       	call   800622 <cprintf>
  801fba:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fc3:	a1 48 50 80 00       	mov    0x805048,%eax
  801fc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcf:	74 07                	je     801fd8 <print_mem_block_lists+0x155>
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	8b 00                	mov    (%eax),%eax
  801fd6:	eb 05                	jmp    801fdd <print_mem_block_lists+0x15a>
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdd:	a3 48 50 80 00       	mov    %eax,0x805048
  801fe2:	a1 48 50 80 00       	mov    0x805048,%eax
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	75 8a                	jne    801f75 <print_mem_block_lists+0xf2>
  801feb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fef:	75 84                	jne    801f75 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ff1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ff5:	75 10                	jne    802007 <print_mem_block_lists+0x184>
  801ff7:	83 ec 0c             	sub    $0xc,%esp
  801ffa:	68 70 40 80 00       	push   $0x804070
  801fff:	e8 1e e6 ff ff       	call   800622 <cprintf>
  802004:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	68 e4 3f 80 00       	push   $0x803fe4
  80200f:	e8 0e e6 ff ff       	call   800622 <cprintf>
  802014:	83 c4 10             	add    $0x10,%esp

}
  802017:	90                   	nop
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802020:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802027:	00 00 00 
  80202a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802031:	00 00 00 
  802034:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80203b:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80203e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802045:	e9 9e 00 00 00       	jmp    8020e8 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80204a:	a1 50 50 80 00       	mov    0x805050,%eax
  80204f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802052:	c1 e2 04             	shl    $0x4,%edx
  802055:	01 d0                	add    %edx,%eax
  802057:	85 c0                	test   %eax,%eax
  802059:	75 14                	jne    80206f <initialize_MemBlocksList+0x55>
  80205b:	83 ec 04             	sub    $0x4,%esp
  80205e:	68 98 40 80 00       	push   $0x804098
  802063:	6a 46                	push   $0x46
  802065:	68 bb 40 80 00       	push   $0x8040bb
  80206a:	e8 64 14 00 00       	call   8034d3 <_panic>
  80206f:	a1 50 50 80 00       	mov    0x805050,%eax
  802074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802077:	c1 e2 04             	shl    $0x4,%edx
  80207a:	01 d0                	add    %edx,%eax
  80207c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802082:	89 10                	mov    %edx,(%eax)
  802084:	8b 00                	mov    (%eax),%eax
  802086:	85 c0                	test   %eax,%eax
  802088:	74 18                	je     8020a2 <initialize_MemBlocksList+0x88>
  80208a:	a1 48 51 80 00       	mov    0x805148,%eax
  80208f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802095:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802098:	c1 e1 04             	shl    $0x4,%ecx
  80209b:	01 ca                	add    %ecx,%edx
  80209d:	89 50 04             	mov    %edx,0x4(%eax)
  8020a0:	eb 12                	jmp    8020b4 <initialize_MemBlocksList+0x9a>
  8020a2:	a1 50 50 80 00       	mov    0x805050,%eax
  8020a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020aa:	c1 e2 04             	shl    $0x4,%edx
  8020ad:	01 d0                	add    %edx,%eax
  8020af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020b4:	a1 50 50 80 00       	mov    0x805050,%eax
  8020b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bc:	c1 e2 04             	shl    $0x4,%edx
  8020bf:	01 d0                	add    %edx,%eax
  8020c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8020c6:	a1 50 50 80 00       	mov    0x805050,%eax
  8020cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ce:	c1 e2 04             	shl    $0x4,%edx
  8020d1:	01 d0                	add    %edx,%eax
  8020d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020da:	a1 54 51 80 00       	mov    0x805154,%eax
  8020df:	40                   	inc    %eax
  8020e0:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020e5:	ff 45 f4             	incl   -0xc(%ebp)
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ee:	0f 82 56 ff ff ff    	jb     80204a <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020f4:	90                   	nop
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	8b 00                	mov    (%eax),%eax
  802102:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802105:	eb 19                	jmp    802120 <find_block+0x29>
	{
		if(va==point->sva)
  802107:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210a:	8b 40 08             	mov    0x8(%eax),%eax
  80210d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802110:	75 05                	jne    802117 <find_block+0x20>
		   return point;
  802112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802115:	eb 36                	jmp    80214d <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8b 40 08             	mov    0x8(%eax),%eax
  80211d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802120:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802124:	74 07                	je     80212d <find_block+0x36>
  802126:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802129:	8b 00                	mov    (%eax),%eax
  80212b:	eb 05                	jmp    802132 <find_block+0x3b>
  80212d:	b8 00 00 00 00       	mov    $0x0,%eax
  802132:	8b 55 08             	mov    0x8(%ebp),%edx
  802135:	89 42 08             	mov    %eax,0x8(%edx)
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	8b 40 08             	mov    0x8(%eax),%eax
  80213e:	85 c0                	test   %eax,%eax
  802140:	75 c5                	jne    802107 <find_block+0x10>
  802142:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802146:	75 bf                	jne    802107 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802148:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802155:	a1 40 50 80 00       	mov    0x805040,%eax
  80215a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80215d:	a1 44 50 80 00       	mov    0x805044,%eax
  802162:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802168:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80216b:	74 24                	je     802191 <insert_sorted_allocList+0x42>
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	8b 50 08             	mov    0x8(%eax),%edx
  802173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802176:	8b 40 08             	mov    0x8(%eax),%eax
  802179:	39 c2                	cmp    %eax,%edx
  80217b:	76 14                	jbe    802191 <insert_sorted_allocList+0x42>
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	8b 50 08             	mov    0x8(%eax),%edx
  802183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802186:	8b 40 08             	mov    0x8(%eax),%eax
  802189:	39 c2                	cmp    %eax,%edx
  80218b:	0f 82 60 01 00 00    	jb     8022f1 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802191:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802195:	75 65                	jne    8021fc <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802197:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80219b:	75 14                	jne    8021b1 <insert_sorted_allocList+0x62>
  80219d:	83 ec 04             	sub    $0x4,%esp
  8021a0:	68 98 40 80 00       	push   $0x804098
  8021a5:	6a 6b                	push   $0x6b
  8021a7:	68 bb 40 80 00       	push   $0x8040bb
  8021ac:	e8 22 13 00 00       	call   8034d3 <_panic>
  8021b1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	89 10                	mov    %edx,(%eax)
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	8b 00                	mov    (%eax),%eax
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	74 0d                	je     8021d2 <insert_sorted_allocList+0x83>
  8021c5:	a1 40 50 80 00       	mov    0x805040,%eax
  8021ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8021cd:	89 50 04             	mov    %edx,0x4(%eax)
  8021d0:	eb 08                	jmp    8021da <insert_sorted_allocList+0x8b>
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	a3 44 50 80 00       	mov    %eax,0x805044
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	a3 40 50 80 00       	mov    %eax,0x805040
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ec:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021f1:	40                   	inc    %eax
  8021f2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f7:	e9 dc 01 00 00       	jmp    8023d8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	8b 50 08             	mov    0x8(%eax),%edx
  802202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802205:	8b 40 08             	mov    0x8(%eax),%eax
  802208:	39 c2                	cmp    %eax,%edx
  80220a:	77 6c                	ja     802278 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80220c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802210:	74 06                	je     802218 <insert_sorted_allocList+0xc9>
  802212:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802216:	75 14                	jne    80222c <insert_sorted_allocList+0xdd>
  802218:	83 ec 04             	sub    $0x4,%esp
  80221b:	68 d4 40 80 00       	push   $0x8040d4
  802220:	6a 6f                	push   $0x6f
  802222:	68 bb 40 80 00       	push   $0x8040bb
  802227:	e8 a7 12 00 00       	call   8034d3 <_panic>
  80222c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222f:	8b 50 04             	mov    0x4(%eax),%edx
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	89 50 04             	mov    %edx,0x4(%eax)
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80223e:	89 10                	mov    %edx,(%eax)
  802240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802243:	8b 40 04             	mov    0x4(%eax),%eax
  802246:	85 c0                	test   %eax,%eax
  802248:	74 0d                	je     802257 <insert_sorted_allocList+0x108>
  80224a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224d:	8b 40 04             	mov    0x4(%eax),%eax
  802250:	8b 55 08             	mov    0x8(%ebp),%edx
  802253:	89 10                	mov    %edx,(%eax)
  802255:	eb 08                	jmp    80225f <insert_sorted_allocList+0x110>
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	a3 40 50 80 00       	mov    %eax,0x805040
  80225f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802262:	8b 55 08             	mov    0x8(%ebp),%edx
  802265:	89 50 04             	mov    %edx,0x4(%eax)
  802268:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80226d:	40                   	inc    %eax
  80226e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802273:	e9 60 01 00 00       	jmp    8023d8 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	8b 50 08             	mov    0x8(%eax),%edx
  80227e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802281:	8b 40 08             	mov    0x8(%eax),%eax
  802284:	39 c2                	cmp    %eax,%edx
  802286:	0f 82 4c 01 00 00    	jb     8023d8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80228c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802290:	75 14                	jne    8022a6 <insert_sorted_allocList+0x157>
  802292:	83 ec 04             	sub    $0x4,%esp
  802295:	68 0c 41 80 00       	push   $0x80410c
  80229a:	6a 73                	push   $0x73
  80229c:	68 bb 40 80 00       	push   $0x8040bb
  8022a1:	e8 2d 12 00 00       	call   8034d3 <_panic>
  8022a6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	89 50 04             	mov    %edx,0x4(%eax)
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	8b 40 04             	mov    0x4(%eax),%eax
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	74 0c                	je     8022c8 <insert_sorted_allocList+0x179>
  8022bc:	a1 44 50 80 00       	mov    0x805044,%eax
  8022c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c4:	89 10                	mov    %edx,(%eax)
  8022c6:	eb 08                	jmp    8022d0 <insert_sorted_allocList+0x181>
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	a3 40 50 80 00       	mov    %eax,0x805040
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022e6:	40                   	inc    %eax
  8022e7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022ec:	e9 e7 00 00 00       	jmp    8023d8 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022fe:	a1 40 50 80 00       	mov    0x805040,%eax
  802303:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802306:	e9 9d 00 00 00       	jmp    8023a8 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 00                	mov    (%eax),%eax
  802310:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	8b 50 08             	mov    0x8(%eax),%edx
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	8b 40 08             	mov    0x8(%eax),%eax
  80231f:	39 c2                	cmp    %eax,%edx
  802321:	76 7d                	jbe    8023a0 <insert_sorted_allocList+0x251>
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	8b 50 08             	mov    0x8(%eax),%edx
  802329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80232c:	8b 40 08             	mov    0x8(%eax),%eax
  80232f:	39 c2                	cmp    %eax,%edx
  802331:	73 6d                	jae    8023a0 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802337:	74 06                	je     80233f <insert_sorted_allocList+0x1f0>
  802339:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80233d:	75 14                	jne    802353 <insert_sorted_allocList+0x204>
  80233f:	83 ec 04             	sub    $0x4,%esp
  802342:	68 30 41 80 00       	push   $0x804130
  802347:	6a 7f                	push   $0x7f
  802349:	68 bb 40 80 00       	push   $0x8040bb
  80234e:	e8 80 11 00 00       	call   8034d3 <_panic>
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	8b 10                	mov    (%eax),%edx
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	89 10                	mov    %edx,(%eax)
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	8b 00                	mov    (%eax),%eax
  802362:	85 c0                	test   %eax,%eax
  802364:	74 0b                	je     802371 <insert_sorted_allocList+0x222>
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	8b 55 08             	mov    0x8(%ebp),%edx
  80236e:	89 50 04             	mov    %edx,0x4(%eax)
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 55 08             	mov    0x8(%ebp),%edx
  802377:	89 10                	mov    %edx,(%eax)
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237f:	89 50 04             	mov    %edx,0x4(%eax)
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	85 c0                	test   %eax,%eax
  802389:	75 08                	jne    802393 <insert_sorted_allocList+0x244>
  80238b:	8b 45 08             	mov    0x8(%ebp),%eax
  80238e:	a3 44 50 80 00       	mov    %eax,0x805044
  802393:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802398:	40                   	inc    %eax
  802399:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80239e:	eb 39                	jmp    8023d9 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023a0:	a1 48 50 80 00       	mov    0x805048,%eax
  8023a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ac:	74 07                	je     8023b5 <insert_sorted_allocList+0x266>
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	eb 05                	jmp    8023ba <insert_sorted_allocList+0x26b>
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ba:	a3 48 50 80 00       	mov    %eax,0x805048
  8023bf:	a1 48 50 80 00       	mov    0x805048,%eax
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	0f 85 3f ff ff ff    	jne    80230b <insert_sorted_allocList+0x1bc>
  8023cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d0:	0f 85 35 ff ff ff    	jne    80230b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023d6:	eb 01                	jmp    8023d9 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023d8:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023d9:	90                   	nop
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8023e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ea:	e9 85 01 00 00       	jmp    802574 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f8:	0f 82 6e 01 00 00    	jb     80256c <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 40 0c             	mov    0xc(%eax),%eax
  802404:	3b 45 08             	cmp    0x8(%ebp),%eax
  802407:	0f 85 8a 00 00 00    	jne    802497 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80240d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802411:	75 17                	jne    80242a <alloc_block_FF+0x4e>
  802413:	83 ec 04             	sub    $0x4,%esp
  802416:	68 64 41 80 00       	push   $0x804164
  80241b:	68 93 00 00 00       	push   $0x93
  802420:	68 bb 40 80 00       	push   $0x8040bb
  802425:	e8 a9 10 00 00       	call   8034d3 <_panic>
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	85 c0                	test   %eax,%eax
  802431:	74 10                	je     802443 <alloc_block_FF+0x67>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243b:	8b 52 04             	mov    0x4(%edx),%edx
  80243e:	89 50 04             	mov    %edx,0x4(%eax)
  802441:	eb 0b                	jmp    80244e <alloc_block_FF+0x72>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 04             	mov    0x4(%eax),%eax
  802449:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 40 04             	mov    0x4(%eax),%eax
  802454:	85 c0                	test   %eax,%eax
  802456:	74 0f                	je     802467 <alloc_block_FF+0x8b>
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 40 04             	mov    0x4(%eax),%eax
  80245e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802461:	8b 12                	mov    (%edx),%edx
  802463:	89 10                	mov    %edx,(%eax)
  802465:	eb 0a                	jmp    802471 <alloc_block_FF+0x95>
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	a3 38 51 80 00       	mov    %eax,0x805138
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802484:	a1 44 51 80 00       	mov    0x805144,%eax
  802489:	48                   	dec    %eax
  80248a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	e9 10 01 00 00       	jmp    8025a7 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 40 0c             	mov    0xc(%eax),%eax
  80249d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a0:	0f 86 c6 00 00 00    	jbe    80256c <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8024ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	8b 50 08             	mov    0x8(%eax),%edx
  8024b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b7:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c0:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c7:	75 17                	jne    8024e0 <alloc_block_FF+0x104>
  8024c9:	83 ec 04             	sub    $0x4,%esp
  8024cc:	68 64 41 80 00       	push   $0x804164
  8024d1:	68 9b 00 00 00       	push   $0x9b
  8024d6:	68 bb 40 80 00       	push   $0x8040bb
  8024db:	e8 f3 0f 00 00       	call   8034d3 <_panic>
  8024e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e3:	8b 00                	mov    (%eax),%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	74 10                	je     8024f9 <alloc_block_FF+0x11d>
  8024e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ec:	8b 00                	mov    (%eax),%eax
  8024ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f1:	8b 52 04             	mov    0x4(%edx),%edx
  8024f4:	89 50 04             	mov    %edx,0x4(%eax)
  8024f7:	eb 0b                	jmp    802504 <alloc_block_FF+0x128>
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 40 04             	mov    0x4(%eax),%eax
  8024ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	8b 40 04             	mov    0x4(%eax),%eax
  80250a:	85 c0                	test   %eax,%eax
  80250c:	74 0f                	je     80251d <alloc_block_FF+0x141>
  80250e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802511:	8b 40 04             	mov    0x4(%eax),%eax
  802514:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802517:	8b 12                	mov    (%edx),%edx
  802519:	89 10                	mov    %edx,(%eax)
  80251b:	eb 0a                	jmp    802527 <alloc_block_FF+0x14b>
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	a3 48 51 80 00       	mov    %eax,0x805148
  802527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802533:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253a:	a1 54 51 80 00       	mov    0x805154,%eax
  80253f:	48                   	dec    %eax
  802540:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 50 08             	mov    0x8(%eax),%edx
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	01 c2                	add    %eax,%edx
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 40 0c             	mov    0xc(%eax),%eax
  80255c:	2b 45 08             	sub    0x8(%ebp),%eax
  80255f:	89 c2                	mov    %eax,%edx
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256a:	eb 3b                	jmp    8025a7 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80256c:	a1 40 51 80 00       	mov    0x805140,%eax
  802571:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802578:	74 07                	je     802581 <alloc_block_FF+0x1a5>
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	eb 05                	jmp    802586 <alloc_block_FF+0x1aa>
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
  802586:	a3 40 51 80 00       	mov    %eax,0x805140
  80258b:	a1 40 51 80 00       	mov    0x805140,%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	0f 85 57 fe ff ff    	jne    8023ef <alloc_block_FF+0x13>
  802598:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259c:	0f 85 4d fe ff ff    	jne    8023ef <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
  8025ac:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8025bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025be:	e9 df 00 00 00       	jmp    8026a2 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cc:	0f 82 c8 00 00 00    	jb     80269a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025db:	0f 85 8a 00 00 00    	jne    80266b <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e5:	75 17                	jne    8025fe <alloc_block_BF+0x55>
  8025e7:	83 ec 04             	sub    $0x4,%esp
  8025ea:	68 64 41 80 00       	push   $0x804164
  8025ef:	68 b7 00 00 00       	push   $0xb7
  8025f4:	68 bb 40 80 00       	push   $0x8040bb
  8025f9:	e8 d5 0e 00 00       	call   8034d3 <_panic>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	85 c0                	test   %eax,%eax
  802605:	74 10                	je     802617 <alloc_block_BF+0x6e>
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260f:	8b 52 04             	mov    0x4(%edx),%edx
  802612:	89 50 04             	mov    %edx,0x4(%eax)
  802615:	eb 0b                	jmp    802622 <alloc_block_BF+0x79>
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 40 04             	mov    0x4(%eax),%eax
  80261d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 40 04             	mov    0x4(%eax),%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 0f                	je     80263b <alloc_block_BF+0x92>
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 40 04             	mov    0x4(%eax),%eax
  802632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802635:	8b 12                	mov    (%edx),%edx
  802637:	89 10                	mov    %edx,(%eax)
  802639:	eb 0a                	jmp    802645 <alloc_block_BF+0x9c>
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 00                	mov    (%eax),%eax
  802640:	a3 38 51 80 00       	mov    %eax,0x805138
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802658:	a1 44 51 80 00       	mov    0x805144,%eax
  80265d:	48                   	dec    %eax
  80265e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	e9 4d 01 00 00       	jmp    8027b8 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 40 0c             	mov    0xc(%eax),%eax
  802671:	3b 45 08             	cmp    0x8(%ebp),%eax
  802674:	76 24                	jbe    80269a <alloc_block_BF+0xf1>
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 40 0c             	mov    0xc(%eax),%eax
  80267c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80267f:	73 19                	jae    80269a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802681:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 40 0c             	mov    0xc(%eax),%eax
  80268e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 40 08             	mov    0x8(%eax),%eax
  802697:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80269a:	a1 40 51 80 00       	mov    0x805140,%eax
  80269f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a6:	74 07                	je     8026af <alloc_block_BF+0x106>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 00                	mov    (%eax),%eax
  8026ad:	eb 05                	jmp    8026b4 <alloc_block_BF+0x10b>
  8026af:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b4:	a3 40 51 80 00       	mov    %eax,0x805140
  8026b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	0f 85 fd fe ff ff    	jne    8025c3 <alloc_block_BF+0x1a>
  8026c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ca:	0f 85 f3 fe ff ff    	jne    8025c3 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026d4:	0f 84 d9 00 00 00    	je     8027b3 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026da:	a1 48 51 80 00       	mov    0x805148,%eax
  8026df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e8:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f1:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026f8:	75 17                	jne    802711 <alloc_block_BF+0x168>
  8026fa:	83 ec 04             	sub    $0x4,%esp
  8026fd:	68 64 41 80 00       	push   $0x804164
  802702:	68 c7 00 00 00       	push   $0xc7
  802707:	68 bb 40 80 00       	push   $0x8040bb
  80270c:	e8 c2 0d 00 00       	call   8034d3 <_panic>
  802711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802714:	8b 00                	mov    (%eax),%eax
  802716:	85 c0                	test   %eax,%eax
  802718:	74 10                	je     80272a <alloc_block_BF+0x181>
  80271a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802722:	8b 52 04             	mov    0x4(%edx),%edx
  802725:	89 50 04             	mov    %edx,0x4(%eax)
  802728:	eb 0b                	jmp    802735 <alloc_block_BF+0x18c>
  80272a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272d:	8b 40 04             	mov    0x4(%eax),%eax
  802730:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802738:	8b 40 04             	mov    0x4(%eax),%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	74 0f                	je     80274e <alloc_block_BF+0x1a5>
  80273f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802742:	8b 40 04             	mov    0x4(%eax),%eax
  802745:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802748:	8b 12                	mov    (%edx),%edx
  80274a:	89 10                	mov    %edx,(%eax)
  80274c:	eb 0a                	jmp    802758 <alloc_block_BF+0x1af>
  80274e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	a3 48 51 80 00       	mov    %eax,0x805148
  802758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802764:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276b:	a1 54 51 80 00       	mov    0x805154,%eax
  802770:	48                   	dec    %eax
  802771:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802776:	83 ec 08             	sub    $0x8,%esp
  802779:	ff 75 ec             	pushl  -0x14(%ebp)
  80277c:	68 38 51 80 00       	push   $0x805138
  802781:	e8 71 f9 ff ff       	call   8020f7 <find_block>
  802786:	83 c4 10             	add    $0x10,%esp
  802789:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80278c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278f:	8b 50 08             	mov    0x8(%eax),%edx
  802792:	8b 45 08             	mov    0x8(%ebp),%eax
  802795:	01 c2                	add    %eax,%edx
  802797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80279d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a3:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a6:	89 c2                	mov    %eax,%edx
  8027a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ab:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b1:	eb 05                	jmp    8027b8 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
  8027bd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027c0:	a1 28 50 80 00       	mov    0x805028,%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	0f 85 de 01 00 00    	jne    8029ab <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8027d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d5:	e9 9e 01 00 00       	jmp    802978 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e3:	0f 82 87 01 00 00    	jb     802970 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f2:	0f 85 95 00 00 00    	jne    80288d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	75 17                	jne    802815 <alloc_block_NF+0x5b>
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	68 64 41 80 00       	push   $0x804164
  802806:	68 e0 00 00 00       	push   $0xe0
  80280b:	68 bb 40 80 00       	push   $0x8040bb
  802810:	e8 be 0c 00 00       	call   8034d3 <_panic>
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 10                	je     80282e <alloc_block_NF+0x74>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802826:	8b 52 04             	mov    0x4(%edx),%edx
  802829:	89 50 04             	mov    %edx,0x4(%eax)
  80282c:	eb 0b                	jmp    802839 <alloc_block_NF+0x7f>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	74 0f                	je     802852 <alloc_block_NF+0x98>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284c:	8b 12                	mov    (%edx),%edx
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	eb 0a                	jmp    80285c <alloc_block_NF+0xa2>
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
				   svaOfNF = point->sva;
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 40 08             	mov    0x8(%eax),%eax
  802880:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	e9 f8 04 00 00       	jmp    802d85 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 40 0c             	mov    0xc(%eax),%eax
  802893:	3b 45 08             	cmp    0x8(%ebp),%eax
  802896:	0f 86 d4 00 00 00    	jbe    802970 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80289c:	a1 48 51 80 00       	mov    0x805148,%eax
  8028a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 50 08             	mov    0x8(%eax),%edx
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b6:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028bd:	75 17                	jne    8028d6 <alloc_block_NF+0x11c>
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	68 64 41 80 00       	push   $0x804164
  8028c7:	68 e9 00 00 00       	push   $0xe9
  8028cc:	68 bb 40 80 00       	push   $0x8040bb
  8028d1:	e8 fd 0b 00 00       	call   8034d3 <_panic>
  8028d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d9:	8b 00                	mov    (%eax),%eax
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	74 10                	je     8028ef <alloc_block_NF+0x135>
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e7:	8b 52 04             	mov    0x4(%edx),%edx
  8028ea:	89 50 04             	mov    %edx,0x4(%eax)
  8028ed:	eb 0b                	jmp    8028fa <alloc_block_NF+0x140>
  8028ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fd:	8b 40 04             	mov    0x4(%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0f                	je     802913 <alloc_block_NF+0x159>
  802904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80290d:	8b 12                	mov    (%edx),%edx
  80290f:	89 10                	mov    %edx,(%eax)
  802911:	eb 0a                	jmp    80291d <alloc_block_NF+0x163>
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	a3 48 51 80 00       	mov    %eax,0x805148
  80291d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802930:	a1 54 51 80 00       	mov    0x805154,%eax
  802935:	48                   	dec    %eax
  802936:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80293b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293e:	8b 40 08             	mov    0x8(%eax),%eax
  802941:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 50 08             	mov    0x8(%eax),%edx
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	01 c2                	add    %eax,%edx
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	2b 45 08             	sub    0x8(%ebp),%eax
  802960:	89 c2                	mov    %eax,%edx
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296b:	e9 15 04 00 00       	jmp    802d85 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802970:	a1 40 51 80 00       	mov    0x805140,%eax
  802975:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297c:	74 07                	je     802985 <alloc_block_NF+0x1cb>
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	eb 05                	jmp    80298a <alloc_block_NF+0x1d0>
  802985:	b8 00 00 00 00       	mov    $0x0,%eax
  80298a:	a3 40 51 80 00       	mov    %eax,0x805140
  80298f:	a1 40 51 80 00       	mov    0x805140,%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	0f 85 3e fe ff ff    	jne    8027da <alloc_block_NF+0x20>
  80299c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a0:	0f 85 34 fe ff ff    	jne    8027da <alloc_block_NF+0x20>
  8029a6:	e9 d5 03 00 00       	jmp    802d80 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029ab:	a1 38 51 80 00       	mov    0x805138,%eax
  8029b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b3:	e9 b1 01 00 00       	jmp    802b69 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 50 08             	mov    0x8(%eax),%edx
  8029be:	a1 28 50 80 00       	mov    0x805028,%eax
  8029c3:	39 c2                	cmp    %eax,%edx
  8029c5:	0f 82 96 01 00 00    	jb     802b61 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d4:	0f 82 87 01 00 00    	jb     802b61 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e3:	0f 85 95 00 00 00    	jne    802a7e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ed:	75 17                	jne    802a06 <alloc_block_NF+0x24c>
  8029ef:	83 ec 04             	sub    $0x4,%esp
  8029f2:	68 64 41 80 00       	push   $0x804164
  8029f7:	68 fc 00 00 00       	push   $0xfc
  8029fc:	68 bb 40 80 00       	push   $0x8040bb
  802a01:	e8 cd 0a 00 00       	call   8034d3 <_panic>
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 00                	mov    (%eax),%eax
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	74 10                	je     802a1f <alloc_block_NF+0x265>
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a17:	8b 52 04             	mov    0x4(%edx),%edx
  802a1a:	89 50 04             	mov    %edx,0x4(%eax)
  802a1d:	eb 0b                	jmp    802a2a <alloc_block_NF+0x270>
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 40 04             	mov    0x4(%eax),%eax
  802a25:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 40 04             	mov    0x4(%eax),%eax
  802a30:	85 c0                	test   %eax,%eax
  802a32:	74 0f                	je     802a43 <alloc_block_NF+0x289>
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 40 04             	mov    0x4(%eax),%eax
  802a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3d:	8b 12                	mov    (%edx),%edx
  802a3f:	89 10                	mov    %edx,(%eax)
  802a41:	eb 0a                	jmp    802a4d <alloc_block_NF+0x293>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	a3 38 51 80 00       	mov    %eax,0x805138
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a60:	a1 44 51 80 00       	mov    0x805144,%eax
  802a65:	48                   	dec    %eax
  802a66:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 40 08             	mov    0x8(%eax),%eax
  802a71:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	e9 07 03 00 00       	jmp    802d85 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 40 0c             	mov    0xc(%eax),%eax
  802a84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a87:	0f 86 d4 00 00 00    	jbe    802b61 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a8d:	a1 48 51 80 00       	mov    0x805148,%eax
  802a92:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 50 08             	mov    0x8(%eax),%edx
  802a9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa4:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aaa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aae:	75 17                	jne    802ac7 <alloc_block_NF+0x30d>
  802ab0:	83 ec 04             	sub    $0x4,%esp
  802ab3:	68 64 41 80 00       	push   $0x804164
  802ab8:	68 04 01 00 00       	push   $0x104
  802abd:	68 bb 40 80 00       	push   $0x8040bb
  802ac2:	e8 0c 0a 00 00       	call   8034d3 <_panic>
  802ac7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aca:	8b 00                	mov    (%eax),%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	74 10                	je     802ae0 <alloc_block_NF+0x326>
  802ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad3:	8b 00                	mov    (%eax),%eax
  802ad5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad8:	8b 52 04             	mov    0x4(%edx),%edx
  802adb:	89 50 04             	mov    %edx,0x4(%eax)
  802ade:	eb 0b                	jmp    802aeb <alloc_block_NF+0x331>
  802ae0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae3:	8b 40 04             	mov    0x4(%eax),%eax
  802ae6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aee:	8b 40 04             	mov    0x4(%eax),%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	74 0f                	je     802b04 <alloc_block_NF+0x34a>
  802af5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af8:	8b 40 04             	mov    0x4(%eax),%eax
  802afb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802afe:	8b 12                	mov    (%edx),%edx
  802b00:	89 10                	mov    %edx,(%eax)
  802b02:	eb 0a                	jmp    802b0e <alloc_block_NF+0x354>
  802b04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	a3 48 51 80 00       	mov    %eax,0x805148
  802b0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b21:	a1 54 51 80 00       	mov    0x805154,%eax
  802b26:	48                   	dec    %eax
  802b27:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2f:	8b 40 08             	mov    0x8(%eax),%eax
  802b32:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 50 08             	mov    0x8(%eax),%edx
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	01 c2                	add    %eax,%edx
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4e:	2b 45 08             	sub    0x8(%ebp),%eax
  802b51:	89 c2                	mov    %eax,%edx
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5c:	e9 24 02 00 00       	jmp    802d85 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b61:	a1 40 51 80 00       	mov    0x805140,%eax
  802b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6d:	74 07                	je     802b76 <alloc_block_NF+0x3bc>
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	eb 05                	jmp    802b7b <alloc_block_NF+0x3c1>
  802b76:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7b:	a3 40 51 80 00       	mov    %eax,0x805140
  802b80:	a1 40 51 80 00       	mov    0x805140,%eax
  802b85:	85 c0                	test   %eax,%eax
  802b87:	0f 85 2b fe ff ff    	jne    8029b8 <alloc_block_NF+0x1fe>
  802b8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b91:	0f 85 21 fe ff ff    	jne    8029b8 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b97:	a1 38 51 80 00       	mov    0x805138,%eax
  802b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9f:	e9 ae 01 00 00       	jmp    802d52 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 50 08             	mov    0x8(%eax),%edx
  802baa:	a1 28 50 80 00       	mov    0x805028,%eax
  802baf:	39 c2                	cmp    %eax,%edx
  802bb1:	0f 83 93 01 00 00    	jae    802d4a <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc0:	0f 82 84 01 00 00    	jb     802d4a <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bcf:	0f 85 95 00 00 00    	jne    802c6a <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd9:	75 17                	jne    802bf2 <alloc_block_NF+0x438>
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	68 64 41 80 00       	push   $0x804164
  802be3:	68 14 01 00 00       	push   $0x114
  802be8:	68 bb 40 80 00       	push   $0x8040bb
  802bed:	e8 e1 08 00 00       	call   8034d3 <_panic>
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 10                	je     802c0b <alloc_block_NF+0x451>
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c03:	8b 52 04             	mov    0x4(%edx),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%eax)
  802c09:	eb 0b                	jmp    802c16 <alloc_block_NF+0x45c>
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 0f                	je     802c2f <alloc_block_NF+0x475>
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 40 04             	mov    0x4(%eax),%eax
  802c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c29:	8b 12                	mov    (%edx),%edx
  802c2b:	89 10                	mov    %edx,(%eax)
  802c2d:	eb 0a                	jmp    802c39 <alloc_block_NF+0x47f>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	a3 38 51 80 00       	mov    %eax,0x805138
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4c:	a1 44 51 80 00       	mov    0x805144,%eax
  802c51:	48                   	dec    %eax
  802c52:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 08             	mov    0x8(%eax),%eax
  802c5d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	e9 1b 01 00 00       	jmp    802d85 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c73:	0f 86 d1 00 00 00    	jbe    802d4a <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c79:	a1 48 51 80 00       	mov    0x805148,%eax
  802c7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 50 08             	mov    0x8(%eax),%edx
  802c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c90:	8b 55 08             	mov    0x8(%ebp),%edx
  802c93:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c9a:	75 17                	jne    802cb3 <alloc_block_NF+0x4f9>
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	68 64 41 80 00       	push   $0x804164
  802ca4:	68 1c 01 00 00       	push   $0x11c
  802ca9:	68 bb 40 80 00       	push   $0x8040bb
  802cae:	e8 20 08 00 00       	call   8034d3 <_panic>
  802cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 10                	je     802ccc <alloc_block_NF+0x512>
  802cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc4:	8b 52 04             	mov    0x4(%edx),%edx
  802cc7:	89 50 04             	mov    %edx,0x4(%eax)
  802cca:	eb 0b                	jmp    802cd7 <alloc_block_NF+0x51d>
  802ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cda:	8b 40 04             	mov    0x4(%eax),%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	74 0f                	je     802cf0 <alloc_block_NF+0x536>
  802ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce4:	8b 40 04             	mov    0x4(%eax),%eax
  802ce7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cea:	8b 12                	mov    (%edx),%edx
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	eb 0a                	jmp    802cfa <alloc_block_NF+0x540>
  802cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf3:	8b 00                	mov    (%eax),%eax
  802cf5:	a3 48 51 80 00       	mov    %eax,0x805148
  802cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0d:	a1 54 51 80 00       	mov    0x805154,%eax
  802d12:	48                   	dec    %eax
  802d13:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1b:	8b 40 08             	mov    0x8(%eax),%eax
  802d1e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 50 08             	mov    0x8(%eax),%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	01 c2                	add    %eax,%edx
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3a:	2b 45 08             	sub    0x8(%ebp),%eax
  802d3d:	89 c2                	mov    %eax,%edx
  802d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d42:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d48:	eb 3b                	jmp    802d85 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d4a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d56:	74 07                	je     802d5f <alloc_block_NF+0x5a5>
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	eb 05                	jmp    802d64 <alloc_block_NF+0x5aa>
  802d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d64:	a3 40 51 80 00       	mov    %eax,0x805140
  802d69:	a1 40 51 80 00       	mov    0x805140,%eax
  802d6e:	85 c0                	test   %eax,%eax
  802d70:	0f 85 2e fe ff ff    	jne    802ba4 <alloc_block_NF+0x3ea>
  802d76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7a:	0f 85 24 fe ff ff    	jne    802ba4 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d85:	c9                   	leave  
  802d86:	c3                   	ret    

00802d87 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d87:	55                   	push   %ebp
  802d88:	89 e5                	mov    %esp,%ebp
  802d8a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d8d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d95:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d9a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 14                	je     802dba <insert_sorted_with_merge_freeList+0x33>
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	8b 50 08             	mov    0x8(%eax),%edx
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	8b 40 08             	mov    0x8(%eax),%eax
  802db2:	39 c2                	cmp    %eax,%edx
  802db4:	0f 87 9b 01 00 00    	ja     802f55 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802dba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbe:	75 17                	jne    802dd7 <insert_sorted_with_merge_freeList+0x50>
  802dc0:	83 ec 04             	sub    $0x4,%esp
  802dc3:	68 98 40 80 00       	push   $0x804098
  802dc8:	68 38 01 00 00       	push   $0x138
  802dcd:	68 bb 40 80 00       	push   $0x8040bb
  802dd2:	e8 fc 06 00 00       	call   8034d3 <_panic>
  802dd7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	89 10                	mov    %edx,(%eax)
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 0d                	je     802df8 <insert_sorted_with_merge_freeList+0x71>
  802deb:	a1 38 51 80 00       	mov    0x805138,%eax
  802df0:	8b 55 08             	mov    0x8(%ebp),%edx
  802df3:	89 50 04             	mov    %edx,0x4(%eax)
  802df6:	eb 08                	jmp    802e00 <insert_sorted_with_merge_freeList+0x79>
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	a3 38 51 80 00       	mov    %eax,0x805138
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e12:	a1 44 51 80 00       	mov    0x805144,%eax
  802e17:	40                   	inc    %eax
  802e18:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e21:	0f 84 a8 06 00 00    	je     8034cf <insert_sorted_with_merge_freeList+0x748>
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	8b 50 08             	mov    0x8(%eax),%edx
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	8b 40 0c             	mov    0xc(%eax),%eax
  802e33:	01 c2                	add    %eax,%edx
  802e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e38:	8b 40 08             	mov    0x8(%eax),%eax
  802e3b:	39 c2                	cmp    %eax,%edx
  802e3d:	0f 85 8c 06 00 00    	jne    8034cf <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	8b 50 0c             	mov    0xc(%eax),%edx
  802e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4f:	01 c2                	add    %eax,%edx
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e5b:	75 17                	jne    802e74 <insert_sorted_with_merge_freeList+0xed>
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	68 64 41 80 00       	push   $0x804164
  802e65:	68 3c 01 00 00       	push   $0x13c
  802e6a:	68 bb 40 80 00       	push   $0x8040bb
  802e6f:	e8 5f 06 00 00       	call   8034d3 <_panic>
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	74 10                	je     802e8d <insert_sorted_with_merge_freeList+0x106>
  802e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e85:	8b 52 04             	mov    0x4(%edx),%edx
  802e88:	89 50 04             	mov    %edx,0x4(%eax)
  802e8b:	eb 0b                	jmp    802e98 <insert_sorted_with_merge_freeList+0x111>
  802e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	74 0f                	je     802eb1 <insert_sorted_with_merge_freeList+0x12a>
  802ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea5:	8b 40 04             	mov    0x4(%eax),%eax
  802ea8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eab:	8b 12                	mov    (%edx),%edx
  802ead:	89 10                	mov    %edx,(%eax)
  802eaf:	eb 0a                	jmp    802ebb <insert_sorted_with_merge_freeList+0x134>
  802eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb4:	8b 00                	mov    (%eax),%eax
  802eb6:	a3 38 51 80 00       	mov    %eax,0x805138
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed3:	48                   	dec    %eax
  802ed4:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802eed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef1:	75 17                	jne    802f0a <insert_sorted_with_merge_freeList+0x183>
  802ef3:	83 ec 04             	sub    $0x4,%esp
  802ef6:	68 98 40 80 00       	push   $0x804098
  802efb:	68 3f 01 00 00       	push   $0x13f
  802f00:	68 bb 40 80 00       	push   $0x8040bb
  802f05:	e8 c9 05 00 00       	call   8034d3 <_panic>
  802f0a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f13:	89 10                	mov    %edx,(%eax)
  802f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f18:	8b 00                	mov    (%eax),%eax
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	74 0d                	je     802f2b <insert_sorted_with_merge_freeList+0x1a4>
  802f1e:	a1 48 51 80 00       	mov    0x805148,%eax
  802f23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f26:	89 50 04             	mov    %edx,0x4(%eax)
  802f29:	eb 08                	jmp    802f33 <insert_sorted_with_merge_freeList+0x1ac>
  802f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f36:	a3 48 51 80 00       	mov    %eax,0x805148
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f45:	a1 54 51 80 00       	mov    0x805154,%eax
  802f4a:	40                   	inc    %eax
  802f4b:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f50:	e9 7a 05 00 00       	jmp    8034cf <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	8b 50 08             	mov    0x8(%eax),%edx
  802f5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5e:	8b 40 08             	mov    0x8(%eax),%eax
  802f61:	39 c2                	cmp    %eax,%edx
  802f63:	0f 82 14 01 00 00    	jb     80307d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6c:	8b 50 08             	mov    0x8(%eax),%edx
  802f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f72:	8b 40 0c             	mov    0xc(%eax),%eax
  802f75:	01 c2                	add    %eax,%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 40 08             	mov    0x8(%eax),%eax
  802f7d:	39 c2                	cmp    %eax,%edx
  802f7f:	0f 85 90 00 00 00    	jne    803015 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	8b 50 0c             	mov    0xc(%eax),%edx
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f91:	01 c2                	add    %eax,%edx
  802f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f96:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb1:	75 17                	jne    802fca <insert_sorted_with_merge_freeList+0x243>
  802fb3:	83 ec 04             	sub    $0x4,%esp
  802fb6:	68 98 40 80 00       	push   $0x804098
  802fbb:	68 49 01 00 00       	push   $0x149
  802fc0:	68 bb 40 80 00       	push   $0x8040bb
  802fc5:	e8 09 05 00 00       	call   8034d3 <_panic>
  802fca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	89 10                	mov    %edx,(%eax)
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	74 0d                	je     802feb <insert_sorted_with_merge_freeList+0x264>
  802fde:	a1 48 51 80 00       	mov    0x805148,%eax
  802fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe6:	89 50 04             	mov    %edx,0x4(%eax)
  802fe9:	eb 08                	jmp    802ff3 <insert_sorted_with_merge_freeList+0x26c>
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	a3 48 51 80 00       	mov    %eax,0x805148
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803005:	a1 54 51 80 00       	mov    0x805154,%eax
  80300a:	40                   	inc    %eax
  80300b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803010:	e9 bb 04 00 00       	jmp    8034d0 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803015:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803019:	75 17                	jne    803032 <insert_sorted_with_merge_freeList+0x2ab>
  80301b:	83 ec 04             	sub    $0x4,%esp
  80301e:	68 0c 41 80 00       	push   $0x80410c
  803023:	68 4c 01 00 00       	push   $0x14c
  803028:	68 bb 40 80 00       	push   $0x8040bb
  80302d:	e8 a1 04 00 00       	call   8034d3 <_panic>
  803032:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	89 50 04             	mov    %edx,0x4(%eax)
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	8b 40 04             	mov    0x4(%eax),%eax
  803044:	85 c0                	test   %eax,%eax
  803046:	74 0c                	je     803054 <insert_sorted_with_merge_freeList+0x2cd>
  803048:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80304d:	8b 55 08             	mov    0x8(%ebp),%edx
  803050:	89 10                	mov    %edx,(%eax)
  803052:	eb 08                	jmp    80305c <insert_sorted_with_merge_freeList+0x2d5>
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	a3 38 51 80 00       	mov    %eax,0x805138
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306d:	a1 44 51 80 00       	mov    0x805144,%eax
  803072:	40                   	inc    %eax
  803073:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803078:	e9 53 04 00 00       	jmp    8034d0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80307d:	a1 38 51 80 00       	mov    0x805138,%eax
  803082:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803085:	e9 15 04 00 00       	jmp    80349f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 50 08             	mov    0x8(%eax),%edx
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	8b 40 08             	mov    0x8(%eax),%eax
  80309e:	39 c2                	cmp    %eax,%edx
  8030a0:	0f 86 f1 03 00 00    	jbe    803497 <insert_sorted_with_merge_freeList+0x710>
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 50 08             	mov    0x8(%eax),%edx
  8030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030af:	8b 40 08             	mov    0x8(%eax),%eax
  8030b2:	39 c2                	cmp    %eax,%edx
  8030b4:	0f 83 dd 03 00 00    	jae    803497 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	8b 50 08             	mov    0x8(%eax),%edx
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c6:	01 c2                	add    %eax,%edx
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	8b 40 08             	mov    0x8(%eax),%eax
  8030ce:	39 c2                	cmp    %eax,%edx
  8030d0:	0f 85 b9 01 00 00    	jne    80328f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	8b 50 08             	mov    0x8(%eax),%edx
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e2:	01 c2                	add    %eax,%edx
  8030e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ea:	39 c2                	cmp    %eax,%edx
  8030ec:	0f 85 0d 01 00 00    	jne    8031ff <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f5:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fe:	01 c2                	add    %eax,%edx
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803106:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80310a:	75 17                	jne    803123 <insert_sorted_with_merge_freeList+0x39c>
  80310c:	83 ec 04             	sub    $0x4,%esp
  80310f:	68 64 41 80 00       	push   $0x804164
  803114:	68 5c 01 00 00       	push   $0x15c
  803119:	68 bb 40 80 00       	push   $0x8040bb
  80311e:	e8 b0 03 00 00       	call   8034d3 <_panic>
  803123:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	74 10                	je     80313c <insert_sorted_with_merge_freeList+0x3b5>
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803134:	8b 52 04             	mov    0x4(%edx),%edx
  803137:	89 50 04             	mov    %edx,0x4(%eax)
  80313a:	eb 0b                	jmp    803147 <insert_sorted_with_merge_freeList+0x3c0>
  80313c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313f:	8b 40 04             	mov    0x4(%eax),%eax
  803142:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803147:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	85 c0                	test   %eax,%eax
  80314f:	74 0f                	je     803160 <insert_sorted_with_merge_freeList+0x3d9>
  803151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803154:	8b 40 04             	mov    0x4(%eax),%eax
  803157:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80315a:	8b 12                	mov    (%edx),%edx
  80315c:	89 10                	mov    %edx,(%eax)
  80315e:	eb 0a                	jmp    80316a <insert_sorted_with_merge_freeList+0x3e3>
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	a3 38 51 80 00       	mov    %eax,0x805138
  80316a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803173:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803176:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317d:	a1 44 51 80 00       	mov    0x805144,%eax
  803182:	48                   	dec    %eax
  803183:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803188:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803195:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80319c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031a0:	75 17                	jne    8031b9 <insert_sorted_with_merge_freeList+0x432>
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	68 98 40 80 00       	push   $0x804098
  8031aa:	68 5f 01 00 00       	push   $0x15f
  8031af:	68 bb 40 80 00       	push   $0x8040bb
  8031b4:	e8 1a 03 00 00       	call   8034d3 <_panic>
  8031b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	89 10                	mov    %edx,(%eax)
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	74 0d                	je     8031da <insert_sorted_with_merge_freeList+0x453>
  8031cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	eb 08                	jmp    8031e2 <insert_sorted_with_merge_freeList+0x45b>
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f9:	40                   	inc    %eax
  8031fa:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	8b 50 0c             	mov    0xc(%eax),%edx
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	8b 40 0c             	mov    0xc(%eax),%eax
  80320b:	01 c2                	add    %eax,%edx
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803227:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322b:	75 17                	jne    803244 <insert_sorted_with_merge_freeList+0x4bd>
  80322d:	83 ec 04             	sub    $0x4,%esp
  803230:	68 98 40 80 00       	push   $0x804098
  803235:	68 64 01 00 00       	push   $0x164
  80323a:	68 bb 40 80 00       	push   $0x8040bb
  80323f:	e8 8f 02 00 00       	call   8034d3 <_panic>
  803244:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80324a:	8b 45 08             	mov    0x8(%ebp),%eax
  80324d:	89 10                	mov    %edx,(%eax)
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	8b 00                	mov    (%eax),%eax
  803254:	85 c0                	test   %eax,%eax
  803256:	74 0d                	je     803265 <insert_sorted_with_merge_freeList+0x4de>
  803258:	a1 48 51 80 00       	mov    0x805148,%eax
  80325d:	8b 55 08             	mov    0x8(%ebp),%edx
  803260:	89 50 04             	mov    %edx,0x4(%eax)
  803263:	eb 08                	jmp    80326d <insert_sorted_with_merge_freeList+0x4e6>
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	a3 48 51 80 00       	mov    %eax,0x805148
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327f:	a1 54 51 80 00       	mov    0x805154,%eax
  803284:	40                   	inc    %eax
  803285:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80328a:	e9 41 02 00 00       	jmp    8034d0 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	8b 50 08             	mov    0x8(%eax),%edx
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	8b 40 0c             	mov    0xc(%eax),%eax
  80329b:	01 c2                	add    %eax,%edx
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	8b 40 08             	mov    0x8(%eax),%eax
  8032a3:	39 c2                	cmp    %eax,%edx
  8032a5:	0f 85 7c 01 00 00    	jne    803427 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032af:	74 06                	je     8032b7 <insert_sorted_with_merge_freeList+0x530>
  8032b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b5:	75 17                	jne    8032ce <insert_sorted_with_merge_freeList+0x547>
  8032b7:	83 ec 04             	sub    $0x4,%esp
  8032ba:	68 d4 40 80 00       	push   $0x8040d4
  8032bf:	68 69 01 00 00       	push   $0x169
  8032c4:	68 bb 40 80 00       	push   $0x8040bb
  8032c9:	e8 05 02 00 00       	call   8034d3 <_panic>
  8032ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d1:	8b 50 04             	mov    0x4(%eax),%edx
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	89 50 04             	mov    %edx,0x4(%eax)
  8032da:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e0:	89 10                	mov    %edx,(%eax)
  8032e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e5:	8b 40 04             	mov    0x4(%eax),%eax
  8032e8:	85 c0                	test   %eax,%eax
  8032ea:	74 0d                	je     8032f9 <insert_sorted_with_merge_freeList+0x572>
  8032ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ef:	8b 40 04             	mov    0x4(%eax),%eax
  8032f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f5:	89 10                	mov    %edx,(%eax)
  8032f7:	eb 08                	jmp    803301 <insert_sorted_with_merge_freeList+0x57a>
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803304:	8b 55 08             	mov    0x8(%ebp),%edx
  803307:	89 50 04             	mov    %edx,0x4(%eax)
  80330a:	a1 44 51 80 00       	mov    0x805144,%eax
  80330f:	40                   	inc    %eax
  803310:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	8b 50 0c             	mov    0xc(%eax),%edx
  80331b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331e:	8b 40 0c             	mov    0xc(%eax),%eax
  803321:	01 c2                	add    %eax,%edx
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803329:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80332d:	75 17                	jne    803346 <insert_sorted_with_merge_freeList+0x5bf>
  80332f:	83 ec 04             	sub    $0x4,%esp
  803332:	68 64 41 80 00       	push   $0x804164
  803337:	68 6b 01 00 00       	push   $0x16b
  80333c:	68 bb 40 80 00       	push   $0x8040bb
  803341:	e8 8d 01 00 00       	call   8034d3 <_panic>
  803346:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	85 c0                	test   %eax,%eax
  80334d:	74 10                	je     80335f <insert_sorted_with_merge_freeList+0x5d8>
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	8b 00                	mov    (%eax),%eax
  803354:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803357:	8b 52 04             	mov    0x4(%edx),%edx
  80335a:	89 50 04             	mov    %edx,0x4(%eax)
  80335d:	eb 0b                	jmp    80336a <insert_sorted_with_merge_freeList+0x5e3>
  80335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803362:	8b 40 04             	mov    0x4(%eax),%eax
  803365:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80336a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336d:	8b 40 04             	mov    0x4(%eax),%eax
  803370:	85 c0                	test   %eax,%eax
  803372:	74 0f                	je     803383 <insert_sorted_with_merge_freeList+0x5fc>
  803374:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803377:	8b 40 04             	mov    0x4(%eax),%eax
  80337a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80337d:	8b 12                	mov    (%edx),%edx
  80337f:	89 10                	mov    %edx,(%eax)
  803381:	eb 0a                	jmp    80338d <insert_sorted_with_merge_freeList+0x606>
  803383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803386:	8b 00                	mov    (%eax),%eax
  803388:	a3 38 51 80 00       	mov    %eax,0x805138
  80338d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803396:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803399:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a5:	48                   	dec    %eax
  8033a6:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c3:	75 17                	jne    8033dc <insert_sorted_with_merge_freeList+0x655>
  8033c5:	83 ec 04             	sub    $0x4,%esp
  8033c8:	68 98 40 80 00       	push   $0x804098
  8033cd:	68 6e 01 00 00       	push   $0x16e
  8033d2:	68 bb 40 80 00       	push   $0x8040bb
  8033d7:	e8 f7 00 00 00       	call   8034d3 <_panic>
  8033dc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e5:	89 10                	mov    %edx,(%eax)
  8033e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	85 c0                	test   %eax,%eax
  8033ee:	74 0d                	je     8033fd <insert_sorted_with_merge_freeList+0x676>
  8033f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f8:	89 50 04             	mov    %edx,0x4(%eax)
  8033fb:	eb 08                	jmp    803405 <insert_sorted_with_merge_freeList+0x67e>
  8033fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803400:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803408:	a3 48 51 80 00       	mov    %eax,0x805148
  80340d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803410:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803417:	a1 54 51 80 00       	mov    0x805154,%eax
  80341c:	40                   	inc    %eax
  80341d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803422:	e9 a9 00 00 00       	jmp    8034d0 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80342b:	74 06                	je     803433 <insert_sorted_with_merge_freeList+0x6ac>
  80342d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803431:	75 17                	jne    80344a <insert_sorted_with_merge_freeList+0x6c3>
  803433:	83 ec 04             	sub    $0x4,%esp
  803436:	68 30 41 80 00       	push   $0x804130
  80343b:	68 73 01 00 00       	push   $0x173
  803440:	68 bb 40 80 00       	push   $0x8040bb
  803445:	e8 89 00 00 00       	call   8034d3 <_panic>
  80344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344d:	8b 10                	mov    (%eax),%edx
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	89 10                	mov    %edx,(%eax)
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	8b 00                	mov    (%eax),%eax
  803459:	85 c0                	test   %eax,%eax
  80345b:	74 0b                	je     803468 <insert_sorted_with_merge_freeList+0x6e1>
  80345d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803460:	8b 00                	mov    (%eax),%eax
  803462:	8b 55 08             	mov    0x8(%ebp),%edx
  803465:	89 50 04             	mov    %edx,0x4(%eax)
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	8b 55 08             	mov    0x8(%ebp),%edx
  80346e:	89 10                	mov    %edx,(%eax)
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803476:	89 50 04             	mov    %edx,0x4(%eax)
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	8b 00                	mov    (%eax),%eax
  80347e:	85 c0                	test   %eax,%eax
  803480:	75 08                	jne    80348a <insert_sorted_with_merge_freeList+0x703>
  803482:	8b 45 08             	mov    0x8(%ebp),%eax
  803485:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80348a:	a1 44 51 80 00       	mov    0x805144,%eax
  80348f:	40                   	inc    %eax
  803490:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803495:	eb 39                	jmp    8034d0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803497:	a1 40 51 80 00       	mov    0x805140,%eax
  80349c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a3:	74 07                	je     8034ac <insert_sorted_with_merge_freeList+0x725>
  8034a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	eb 05                	jmp    8034b1 <insert_sorted_with_merge_freeList+0x72a>
  8034ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b1:	a3 40 51 80 00       	mov    %eax,0x805140
  8034b6:	a1 40 51 80 00       	mov    0x805140,%eax
  8034bb:	85 c0                	test   %eax,%eax
  8034bd:	0f 85 c7 fb ff ff    	jne    80308a <insert_sorted_with_merge_freeList+0x303>
  8034c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c7:	0f 85 bd fb ff ff    	jne    80308a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034cd:	eb 01                	jmp    8034d0 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034cf:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034d0:	90                   	nop
  8034d1:	c9                   	leave  
  8034d2:	c3                   	ret    

008034d3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8034d3:	55                   	push   %ebp
  8034d4:	89 e5                	mov    %esp,%ebp
  8034d6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8034d9:	8d 45 10             	lea    0x10(%ebp),%eax
  8034dc:	83 c0 04             	add    $0x4,%eax
  8034df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8034e2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8034e7:	85 c0                	test   %eax,%eax
  8034e9:	74 16                	je     803501 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8034eb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8034f0:	83 ec 08             	sub    $0x8,%esp
  8034f3:	50                   	push   %eax
  8034f4:	68 84 41 80 00       	push   $0x804184
  8034f9:	e8 24 d1 ff ff       	call   800622 <cprintf>
  8034fe:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803501:	a1 00 50 80 00       	mov    0x805000,%eax
  803506:	ff 75 0c             	pushl  0xc(%ebp)
  803509:	ff 75 08             	pushl  0x8(%ebp)
  80350c:	50                   	push   %eax
  80350d:	68 89 41 80 00       	push   $0x804189
  803512:	e8 0b d1 ff ff       	call   800622 <cprintf>
  803517:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80351a:	8b 45 10             	mov    0x10(%ebp),%eax
  80351d:	83 ec 08             	sub    $0x8,%esp
  803520:	ff 75 f4             	pushl  -0xc(%ebp)
  803523:	50                   	push   %eax
  803524:	e8 8e d0 ff ff       	call   8005b7 <vcprintf>
  803529:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80352c:	83 ec 08             	sub    $0x8,%esp
  80352f:	6a 00                	push   $0x0
  803531:	68 a5 41 80 00       	push   $0x8041a5
  803536:	e8 7c d0 ff ff       	call   8005b7 <vcprintf>
  80353b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80353e:	e8 fd cf ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  803543:	eb fe                	jmp    803543 <_panic+0x70>

00803545 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803545:	55                   	push   %ebp
  803546:	89 e5                	mov    %esp,%ebp
  803548:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80354b:	a1 20 50 80 00       	mov    0x805020,%eax
  803550:	8b 50 74             	mov    0x74(%eax),%edx
  803553:	8b 45 0c             	mov    0xc(%ebp),%eax
  803556:	39 c2                	cmp    %eax,%edx
  803558:	74 14                	je     80356e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80355a:	83 ec 04             	sub    $0x4,%esp
  80355d:	68 a8 41 80 00       	push   $0x8041a8
  803562:	6a 26                	push   $0x26
  803564:	68 f4 41 80 00       	push   $0x8041f4
  803569:	e8 65 ff ff ff       	call   8034d3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80356e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803575:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80357c:	e9 c2 00 00 00       	jmp    803643 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803584:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	01 d0                	add    %edx,%eax
  803590:	8b 00                	mov    (%eax),%eax
  803592:	85 c0                	test   %eax,%eax
  803594:	75 08                	jne    80359e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803596:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803599:	e9 a2 00 00 00       	jmp    803640 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80359e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8035ac:	eb 69                	jmp    803617 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8035ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8035b3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035bc:	89 d0                	mov    %edx,%eax
  8035be:	01 c0                	add    %eax,%eax
  8035c0:	01 d0                	add    %edx,%eax
  8035c2:	c1 e0 03             	shl    $0x3,%eax
  8035c5:	01 c8                	add    %ecx,%eax
  8035c7:	8a 40 04             	mov    0x4(%eax),%al
  8035ca:	84 c0                	test   %al,%al
  8035cc:	75 46                	jne    803614 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8035ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8035d3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035dc:	89 d0                	mov    %edx,%eax
  8035de:	01 c0                	add    %eax,%eax
  8035e0:	01 d0                	add    %edx,%eax
  8035e2:	c1 e0 03             	shl    $0x3,%eax
  8035e5:	01 c8                	add    %ecx,%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8035ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8035f4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8035f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	01 c8                	add    %ecx,%eax
  803605:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803607:	39 c2                	cmp    %eax,%edx
  803609:	75 09                	jne    803614 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80360b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803612:	eb 12                	jmp    803626 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803614:	ff 45 e8             	incl   -0x18(%ebp)
  803617:	a1 20 50 80 00       	mov    0x805020,%eax
  80361c:	8b 50 74             	mov    0x74(%eax),%edx
  80361f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803622:	39 c2                	cmp    %eax,%edx
  803624:	77 88                	ja     8035ae <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803626:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80362a:	75 14                	jne    803640 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80362c:	83 ec 04             	sub    $0x4,%esp
  80362f:	68 00 42 80 00       	push   $0x804200
  803634:	6a 3a                	push   $0x3a
  803636:	68 f4 41 80 00       	push   $0x8041f4
  80363b:	e8 93 fe ff ff       	call   8034d3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803640:	ff 45 f0             	incl   -0x10(%ebp)
  803643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803646:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803649:	0f 8c 32 ff ff ff    	jl     803581 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80364f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803656:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80365d:	eb 26                	jmp    803685 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80365f:	a1 20 50 80 00       	mov    0x805020,%eax
  803664:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80366a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80366d:	89 d0                	mov    %edx,%eax
  80366f:	01 c0                	add    %eax,%eax
  803671:	01 d0                	add    %edx,%eax
  803673:	c1 e0 03             	shl    $0x3,%eax
  803676:	01 c8                	add    %ecx,%eax
  803678:	8a 40 04             	mov    0x4(%eax),%al
  80367b:	3c 01                	cmp    $0x1,%al
  80367d:	75 03                	jne    803682 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80367f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803682:	ff 45 e0             	incl   -0x20(%ebp)
  803685:	a1 20 50 80 00       	mov    0x805020,%eax
  80368a:	8b 50 74             	mov    0x74(%eax),%edx
  80368d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803690:	39 c2                	cmp    %eax,%edx
  803692:	77 cb                	ja     80365f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803697:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80369a:	74 14                	je     8036b0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80369c:	83 ec 04             	sub    $0x4,%esp
  80369f:	68 54 42 80 00       	push   $0x804254
  8036a4:	6a 44                	push   $0x44
  8036a6:	68 f4 41 80 00       	push   $0x8041f4
  8036ab:	e8 23 fe ff ff       	call   8034d3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8036b0:	90                   	nop
  8036b1:	c9                   	leave  
  8036b2:	c3                   	ret    
  8036b3:	90                   	nop

008036b4 <__udivdi3>:
  8036b4:	55                   	push   %ebp
  8036b5:	57                   	push   %edi
  8036b6:	56                   	push   %esi
  8036b7:	53                   	push   %ebx
  8036b8:	83 ec 1c             	sub    $0x1c,%esp
  8036bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036cb:	89 ca                	mov    %ecx,%edx
  8036cd:	89 f8                	mov    %edi,%eax
  8036cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036d3:	85 f6                	test   %esi,%esi
  8036d5:	75 2d                	jne    803704 <__udivdi3+0x50>
  8036d7:	39 cf                	cmp    %ecx,%edi
  8036d9:	77 65                	ja     803740 <__udivdi3+0x8c>
  8036db:	89 fd                	mov    %edi,%ebp
  8036dd:	85 ff                	test   %edi,%edi
  8036df:	75 0b                	jne    8036ec <__udivdi3+0x38>
  8036e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8036e6:	31 d2                	xor    %edx,%edx
  8036e8:	f7 f7                	div    %edi
  8036ea:	89 c5                	mov    %eax,%ebp
  8036ec:	31 d2                	xor    %edx,%edx
  8036ee:	89 c8                	mov    %ecx,%eax
  8036f0:	f7 f5                	div    %ebp
  8036f2:	89 c1                	mov    %eax,%ecx
  8036f4:	89 d8                	mov    %ebx,%eax
  8036f6:	f7 f5                	div    %ebp
  8036f8:	89 cf                	mov    %ecx,%edi
  8036fa:	89 fa                	mov    %edi,%edx
  8036fc:	83 c4 1c             	add    $0x1c,%esp
  8036ff:	5b                   	pop    %ebx
  803700:	5e                   	pop    %esi
  803701:	5f                   	pop    %edi
  803702:	5d                   	pop    %ebp
  803703:	c3                   	ret    
  803704:	39 ce                	cmp    %ecx,%esi
  803706:	77 28                	ja     803730 <__udivdi3+0x7c>
  803708:	0f bd fe             	bsr    %esi,%edi
  80370b:	83 f7 1f             	xor    $0x1f,%edi
  80370e:	75 40                	jne    803750 <__udivdi3+0x9c>
  803710:	39 ce                	cmp    %ecx,%esi
  803712:	72 0a                	jb     80371e <__udivdi3+0x6a>
  803714:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803718:	0f 87 9e 00 00 00    	ja     8037bc <__udivdi3+0x108>
  80371e:	b8 01 00 00 00       	mov    $0x1,%eax
  803723:	89 fa                	mov    %edi,%edx
  803725:	83 c4 1c             	add    $0x1c,%esp
  803728:	5b                   	pop    %ebx
  803729:	5e                   	pop    %esi
  80372a:	5f                   	pop    %edi
  80372b:	5d                   	pop    %ebp
  80372c:	c3                   	ret    
  80372d:	8d 76 00             	lea    0x0(%esi),%esi
  803730:	31 ff                	xor    %edi,%edi
  803732:	31 c0                	xor    %eax,%eax
  803734:	89 fa                	mov    %edi,%edx
  803736:	83 c4 1c             	add    $0x1c,%esp
  803739:	5b                   	pop    %ebx
  80373a:	5e                   	pop    %esi
  80373b:	5f                   	pop    %edi
  80373c:	5d                   	pop    %ebp
  80373d:	c3                   	ret    
  80373e:	66 90                	xchg   %ax,%ax
  803740:	89 d8                	mov    %ebx,%eax
  803742:	f7 f7                	div    %edi
  803744:	31 ff                	xor    %edi,%edi
  803746:	89 fa                	mov    %edi,%edx
  803748:	83 c4 1c             	add    $0x1c,%esp
  80374b:	5b                   	pop    %ebx
  80374c:	5e                   	pop    %esi
  80374d:	5f                   	pop    %edi
  80374e:	5d                   	pop    %ebp
  80374f:	c3                   	ret    
  803750:	bd 20 00 00 00       	mov    $0x20,%ebp
  803755:	89 eb                	mov    %ebp,%ebx
  803757:	29 fb                	sub    %edi,%ebx
  803759:	89 f9                	mov    %edi,%ecx
  80375b:	d3 e6                	shl    %cl,%esi
  80375d:	89 c5                	mov    %eax,%ebp
  80375f:	88 d9                	mov    %bl,%cl
  803761:	d3 ed                	shr    %cl,%ebp
  803763:	89 e9                	mov    %ebp,%ecx
  803765:	09 f1                	or     %esi,%ecx
  803767:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80376b:	89 f9                	mov    %edi,%ecx
  80376d:	d3 e0                	shl    %cl,%eax
  80376f:	89 c5                	mov    %eax,%ebp
  803771:	89 d6                	mov    %edx,%esi
  803773:	88 d9                	mov    %bl,%cl
  803775:	d3 ee                	shr    %cl,%esi
  803777:	89 f9                	mov    %edi,%ecx
  803779:	d3 e2                	shl    %cl,%edx
  80377b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80377f:	88 d9                	mov    %bl,%cl
  803781:	d3 e8                	shr    %cl,%eax
  803783:	09 c2                	or     %eax,%edx
  803785:	89 d0                	mov    %edx,%eax
  803787:	89 f2                	mov    %esi,%edx
  803789:	f7 74 24 0c          	divl   0xc(%esp)
  80378d:	89 d6                	mov    %edx,%esi
  80378f:	89 c3                	mov    %eax,%ebx
  803791:	f7 e5                	mul    %ebp
  803793:	39 d6                	cmp    %edx,%esi
  803795:	72 19                	jb     8037b0 <__udivdi3+0xfc>
  803797:	74 0b                	je     8037a4 <__udivdi3+0xf0>
  803799:	89 d8                	mov    %ebx,%eax
  80379b:	31 ff                	xor    %edi,%edi
  80379d:	e9 58 ff ff ff       	jmp    8036fa <__udivdi3+0x46>
  8037a2:	66 90                	xchg   %ax,%ax
  8037a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037a8:	89 f9                	mov    %edi,%ecx
  8037aa:	d3 e2                	shl    %cl,%edx
  8037ac:	39 c2                	cmp    %eax,%edx
  8037ae:	73 e9                	jae    803799 <__udivdi3+0xe5>
  8037b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037b3:	31 ff                	xor    %edi,%edi
  8037b5:	e9 40 ff ff ff       	jmp    8036fa <__udivdi3+0x46>
  8037ba:	66 90                	xchg   %ax,%ax
  8037bc:	31 c0                	xor    %eax,%eax
  8037be:	e9 37 ff ff ff       	jmp    8036fa <__udivdi3+0x46>
  8037c3:	90                   	nop

008037c4 <__umoddi3>:
  8037c4:	55                   	push   %ebp
  8037c5:	57                   	push   %edi
  8037c6:	56                   	push   %esi
  8037c7:	53                   	push   %ebx
  8037c8:	83 ec 1c             	sub    $0x1c,%esp
  8037cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037e3:	89 f3                	mov    %esi,%ebx
  8037e5:	89 fa                	mov    %edi,%edx
  8037e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037eb:	89 34 24             	mov    %esi,(%esp)
  8037ee:	85 c0                	test   %eax,%eax
  8037f0:	75 1a                	jne    80380c <__umoddi3+0x48>
  8037f2:	39 f7                	cmp    %esi,%edi
  8037f4:	0f 86 a2 00 00 00    	jbe    80389c <__umoddi3+0xd8>
  8037fa:	89 c8                	mov    %ecx,%eax
  8037fc:	89 f2                	mov    %esi,%edx
  8037fe:	f7 f7                	div    %edi
  803800:	89 d0                	mov    %edx,%eax
  803802:	31 d2                	xor    %edx,%edx
  803804:	83 c4 1c             	add    $0x1c,%esp
  803807:	5b                   	pop    %ebx
  803808:	5e                   	pop    %esi
  803809:	5f                   	pop    %edi
  80380a:	5d                   	pop    %ebp
  80380b:	c3                   	ret    
  80380c:	39 f0                	cmp    %esi,%eax
  80380e:	0f 87 ac 00 00 00    	ja     8038c0 <__umoddi3+0xfc>
  803814:	0f bd e8             	bsr    %eax,%ebp
  803817:	83 f5 1f             	xor    $0x1f,%ebp
  80381a:	0f 84 ac 00 00 00    	je     8038cc <__umoddi3+0x108>
  803820:	bf 20 00 00 00       	mov    $0x20,%edi
  803825:	29 ef                	sub    %ebp,%edi
  803827:	89 fe                	mov    %edi,%esi
  803829:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80382d:	89 e9                	mov    %ebp,%ecx
  80382f:	d3 e0                	shl    %cl,%eax
  803831:	89 d7                	mov    %edx,%edi
  803833:	89 f1                	mov    %esi,%ecx
  803835:	d3 ef                	shr    %cl,%edi
  803837:	09 c7                	or     %eax,%edi
  803839:	89 e9                	mov    %ebp,%ecx
  80383b:	d3 e2                	shl    %cl,%edx
  80383d:	89 14 24             	mov    %edx,(%esp)
  803840:	89 d8                	mov    %ebx,%eax
  803842:	d3 e0                	shl    %cl,%eax
  803844:	89 c2                	mov    %eax,%edx
  803846:	8b 44 24 08          	mov    0x8(%esp),%eax
  80384a:	d3 e0                	shl    %cl,%eax
  80384c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803850:	8b 44 24 08          	mov    0x8(%esp),%eax
  803854:	89 f1                	mov    %esi,%ecx
  803856:	d3 e8                	shr    %cl,%eax
  803858:	09 d0                	or     %edx,%eax
  80385a:	d3 eb                	shr    %cl,%ebx
  80385c:	89 da                	mov    %ebx,%edx
  80385e:	f7 f7                	div    %edi
  803860:	89 d3                	mov    %edx,%ebx
  803862:	f7 24 24             	mull   (%esp)
  803865:	89 c6                	mov    %eax,%esi
  803867:	89 d1                	mov    %edx,%ecx
  803869:	39 d3                	cmp    %edx,%ebx
  80386b:	0f 82 87 00 00 00    	jb     8038f8 <__umoddi3+0x134>
  803871:	0f 84 91 00 00 00    	je     803908 <__umoddi3+0x144>
  803877:	8b 54 24 04          	mov    0x4(%esp),%edx
  80387b:	29 f2                	sub    %esi,%edx
  80387d:	19 cb                	sbb    %ecx,%ebx
  80387f:	89 d8                	mov    %ebx,%eax
  803881:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803885:	d3 e0                	shl    %cl,%eax
  803887:	89 e9                	mov    %ebp,%ecx
  803889:	d3 ea                	shr    %cl,%edx
  80388b:	09 d0                	or     %edx,%eax
  80388d:	89 e9                	mov    %ebp,%ecx
  80388f:	d3 eb                	shr    %cl,%ebx
  803891:	89 da                	mov    %ebx,%edx
  803893:	83 c4 1c             	add    $0x1c,%esp
  803896:	5b                   	pop    %ebx
  803897:	5e                   	pop    %esi
  803898:	5f                   	pop    %edi
  803899:	5d                   	pop    %ebp
  80389a:	c3                   	ret    
  80389b:	90                   	nop
  80389c:	89 fd                	mov    %edi,%ebp
  80389e:	85 ff                	test   %edi,%edi
  8038a0:	75 0b                	jne    8038ad <__umoddi3+0xe9>
  8038a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038a7:	31 d2                	xor    %edx,%edx
  8038a9:	f7 f7                	div    %edi
  8038ab:	89 c5                	mov    %eax,%ebp
  8038ad:	89 f0                	mov    %esi,%eax
  8038af:	31 d2                	xor    %edx,%edx
  8038b1:	f7 f5                	div    %ebp
  8038b3:	89 c8                	mov    %ecx,%eax
  8038b5:	f7 f5                	div    %ebp
  8038b7:	89 d0                	mov    %edx,%eax
  8038b9:	e9 44 ff ff ff       	jmp    803802 <__umoddi3+0x3e>
  8038be:	66 90                	xchg   %ax,%ax
  8038c0:	89 c8                	mov    %ecx,%eax
  8038c2:	89 f2                	mov    %esi,%edx
  8038c4:	83 c4 1c             	add    $0x1c,%esp
  8038c7:	5b                   	pop    %ebx
  8038c8:	5e                   	pop    %esi
  8038c9:	5f                   	pop    %edi
  8038ca:	5d                   	pop    %ebp
  8038cb:	c3                   	ret    
  8038cc:	3b 04 24             	cmp    (%esp),%eax
  8038cf:	72 06                	jb     8038d7 <__umoddi3+0x113>
  8038d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038d5:	77 0f                	ja     8038e6 <__umoddi3+0x122>
  8038d7:	89 f2                	mov    %esi,%edx
  8038d9:	29 f9                	sub    %edi,%ecx
  8038db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038df:	89 14 24             	mov    %edx,(%esp)
  8038e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038ea:	8b 14 24             	mov    (%esp),%edx
  8038ed:	83 c4 1c             	add    $0x1c,%esp
  8038f0:	5b                   	pop    %ebx
  8038f1:	5e                   	pop    %esi
  8038f2:	5f                   	pop    %edi
  8038f3:	5d                   	pop    %ebp
  8038f4:	c3                   	ret    
  8038f5:	8d 76 00             	lea    0x0(%esi),%esi
  8038f8:	2b 04 24             	sub    (%esp),%eax
  8038fb:	19 fa                	sbb    %edi,%edx
  8038fd:	89 d1                	mov    %edx,%ecx
  8038ff:	89 c6                	mov    %eax,%esi
  803901:	e9 71 ff ff ff       	jmp    803877 <__umoddi3+0xb3>
  803906:	66 90                	xchg   %ax,%ax
  803908:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80390c:	72 ea                	jb     8038f8 <__umoddi3+0x134>
  80390e:	89 d9                	mov    %ebx,%ecx
  803910:	e9 62 ff ff ff       	jmp    803877 <__umoddi3+0xb3>
