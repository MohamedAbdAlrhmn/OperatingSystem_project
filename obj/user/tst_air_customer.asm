
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
  800044:	e8 2f 1b 00 00       	call   801b78 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb e9 38 80 00       	mov    $0x8038e9,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb f3 38 80 00       	mov    $0x8038f3,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb ff 38 80 00       	mov    $0x8038ff,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 0e 39 80 00       	mov    $0x80390e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 1d 39 80 00       	mov    $0x80391d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 32 39 80 00       	mov    $0x803932,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 47 39 80 00       	mov    $0x803947,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 58 39 80 00       	mov    $0x803958,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 69 39 80 00       	mov    $0x803969,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 7a 39 80 00       	mov    $0x80397a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 83 39 80 00       	mov    $0x803983,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 8d 39 80 00       	mov    $0x80398d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 98 39 80 00       	mov    $0x803998,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb a4 39 80 00       	mov    $0x8039a4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ae 39 80 00       	mov    $0x8039ae,%ebx
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
  8001be:	bb b8 39 80 00       	mov    $0x8039b8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb c6 39 80 00       	mov    $0x8039c6,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb d5 39 80 00       	mov    $0x8039d5,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb dc 39 80 00       	mov    $0x8039dc,%ebx
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
  800222:	e8 b4 14 00 00       	call   8016db <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 9f 14 00 00       	call   8016db <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 87 14 00 00       	call   8016db <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 6f 14 00 00       	call   8016db <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 95 17 00 00       	call   801a19 <sys_waitSemaphore>
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
  8002a9:	e8 89 17 00 00       	call   801a37 <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 56 17 00 00       	call   801a19 <sys_waitSemaphore>
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
  8002e7:	e8 2d 17 00 00       	call   801a19 <sys_waitSemaphore>
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
  80031f:	e8 13 17 00 00       	call   801a37 <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 fe 16 00 00       	call   801a37 <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb e3 39 80 00       	mov    $0x8039e3,%ebx
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
  8003aa:	e8 6a 16 00 00       	call   801a19 <sys_waitSemaphore>
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
  8003d2:	68 a0 38 80 00       	push   $0x8038a0
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 c8 38 80 00       	push   $0x8038c8
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 31 16 00 00       	call   801a37 <sys_signalSemaphore>
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
  800418:	e8 42 17 00 00       	call   801b5f <sys_getenvindex>
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
  800483:	e8 e4 14 00 00       	call   80196c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 1c 3a 80 00       	push   $0x803a1c
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
  8004b3:	68 44 3a 80 00       	push   $0x803a44
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
  8004e4:	68 6c 3a 80 00       	push   $0x803a6c
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 c4 3a 80 00       	push   $0x803ac4
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 1c 3a 80 00       	push   $0x803a1c
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 64 14 00 00       	call   801986 <sys_enable_interrupt>

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
  800535:	e8 f1 15 00 00       	call   801b2b <sys_destroy_env>
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
  800546:	e8 46 16 00 00       	call   801b91 <sys_exit_env>
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
  800594:	e8 25 12 00 00       	call   8017be <sys_cputs>
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
  80060b:	e8 ae 11 00 00       	call   8017be <sys_cputs>
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
  800655:	e8 12 13 00 00       	call   80196c <sys_disable_interrupt>
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
  800675:	e8 0c 13 00 00       	call   801986 <sys_enable_interrupt>
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
  8006bf:	e8 60 2f 00 00       	call   803624 <__udivdi3>
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
  80070f:	e8 20 30 00 00       	call   803734 <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 f4 3c 80 00       	add    $0x803cf4,%eax
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
  80086a:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
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
  80094b:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 05 3d 80 00       	push   $0x803d05
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
  800970:	68 0e 3d 80 00       	push   $0x803d0e
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
  80099d:	be 11 3d 80 00       	mov    $0x803d11,%esi
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
  8013c3:	68 70 3e 80 00       	push   $0x803e70
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
  801493:	e8 6a 04 00 00       	call   801902 <sys_allocate_chunk>
  801498:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80149b:	a1 20 51 80 00       	mov    0x805120,%eax
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	50                   	push   %eax
  8014a4:	e8 df 0a 00 00       	call   801f88 <initialize_MemBlocksList>
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
  8014d1:	68 95 3e 80 00       	push   $0x803e95
  8014d6:	6a 33                	push   $0x33
  8014d8:	68 b3 3e 80 00       	push   $0x803eb3
  8014dd:	e8 5f 1f 00 00       	call   803441 <_panic>
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
  801550:	68 c0 3e 80 00       	push   $0x803ec0
  801555:	6a 34                	push   $0x34
  801557:	68 b3 3e 80 00       	push   $0x803eb3
  80155c:	e8 e0 1e 00 00       	call   803441 <_panic>
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
  8015e8:	e8 e3 06 00 00       	call   801cd0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	74 11                	je     801602 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f7:	e8 4e 0d 00 00       	call   80234a <alloc_block_FF>
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
  80160e:	e8 aa 0a 00 00       	call   8020bd <insert_sorted_allocList>
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
  80162e:	68 e4 3e 80 00       	push   $0x803ee4
  801633:	6a 6f                	push   $0x6f
  801635:	68 b3 3e 80 00       	push   $0x803eb3
  80163a:	e8 02 1e 00 00       	call   803441 <_panic>

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
  801654:	75 07                	jne    80165d <smalloc+0x1e>
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	eb 7c                	jmp    8016d9 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80165d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801664:	8b 55 0c             	mov    0xc(%ebp),%edx
  801667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166a:	01 d0                	add    %edx,%eax
  80166c:	48                   	dec    %eax
  80166d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801673:	ba 00 00 00 00       	mov    $0x0,%edx
  801678:	f7 75 f0             	divl   -0x10(%ebp)
  80167b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167e:	29 d0                	sub    %edx,%eax
  801680:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801683:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80168a:	e8 41 06 00 00       	call   801cd0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80168f:	85 c0                	test   %eax,%eax
  801691:	74 11                	je     8016a4 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801693:	83 ec 0c             	sub    $0xc,%esp
  801696:	ff 75 e8             	pushl  -0x18(%ebp)
  801699:	e8 ac 0c 00 00       	call   80234a <alloc_block_FF>
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8016a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a8:	74 2a                	je     8016d4 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ad:	8b 40 08             	mov    0x8(%eax),%eax
  8016b0:	89 c2                	mov    %eax,%edx
  8016b2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016b6:	52                   	push   %edx
  8016b7:	50                   	push   %eax
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	e8 92 03 00 00       	call   801a55 <sys_createSharedObject>
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8016c9:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8016cd:	74 05                	je     8016d4 <smalloc+0x95>
			return (void*)virtual_address;
  8016cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d2:	eb 05                	jmp    8016d9 <smalloc+0x9a>
	}
	return NULL;
  8016d4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e1:	e8 c6 fc ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016e6:	83 ec 04             	sub    $0x4,%esp
  8016e9:	68 08 3f 80 00       	push   $0x803f08
  8016ee:	68 b0 00 00 00       	push   $0xb0
  8016f3:	68 b3 3e 80 00       	push   $0x803eb3
  8016f8:	e8 44 1d 00 00       	call   803441 <_panic>

008016fd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801703:	e8 a4 fc ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	68 2c 3f 80 00       	push   $0x803f2c
  801710:	68 f4 00 00 00       	push   $0xf4
  801715:	68 b3 3e 80 00       	push   $0x803eb3
  80171a:	e8 22 1d 00 00       	call   803441 <_panic>

0080171f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801725:	83 ec 04             	sub    $0x4,%esp
  801728:	68 54 3f 80 00       	push   $0x803f54
  80172d:	68 08 01 00 00       	push   $0x108
  801732:	68 b3 3e 80 00       	push   $0x803eb3
  801737:	e8 05 1d 00 00       	call   803441 <_panic>

0080173c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801742:	83 ec 04             	sub    $0x4,%esp
  801745:	68 78 3f 80 00       	push   $0x803f78
  80174a:	68 13 01 00 00       	push   $0x113
  80174f:	68 b3 3e 80 00       	push   $0x803eb3
  801754:	e8 e8 1c 00 00       	call   803441 <_panic>

00801759 <shrink>:

}
void shrink(uint32 newSize)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80175f:	83 ec 04             	sub    $0x4,%esp
  801762:	68 78 3f 80 00       	push   $0x803f78
  801767:	68 18 01 00 00       	push   $0x118
  80176c:	68 b3 3e 80 00       	push   $0x803eb3
  801771:	e8 cb 1c 00 00       	call   803441 <_panic>

00801776 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80177c:	83 ec 04             	sub    $0x4,%esp
  80177f:	68 78 3f 80 00       	push   $0x803f78
  801784:	68 1d 01 00 00       	push   $0x11d
  801789:	68 b3 3e 80 00       	push   $0x803eb3
  80178e:	e8 ae 1c 00 00       	call   803441 <_panic>

00801793 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	57                   	push   %edi
  801797:	56                   	push   %esi
  801798:	53                   	push   %ebx
  801799:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
  80179f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ab:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017ae:	cd 30                	int    $0x30
  8017b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5e                   	pop    %esi
  8017bb:	5f                   	pop    %edi
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    

008017be <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 04             	sub    $0x4,%esp
  8017c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017ca:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	52                   	push   %edx
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	50                   	push   %eax
  8017da:	6a 00                	push   $0x0
  8017dc:	e8 b2 ff ff ff       	call   801793 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	90                   	nop
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 01                	push   $0x1
  8017f6:	e8 98 ff ff ff       	call   801793 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801803:	8b 55 0c             	mov    0xc(%ebp),%edx
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	52                   	push   %edx
  801810:	50                   	push   %eax
  801811:	6a 05                	push   $0x5
  801813:	e8 7b ff ff ff       	call   801793 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801822:	8b 75 18             	mov    0x18(%ebp),%esi
  801825:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801828:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	56                   	push   %esi
  801832:	53                   	push   %ebx
  801833:	51                   	push   %ecx
  801834:	52                   	push   %edx
  801835:	50                   	push   %eax
  801836:	6a 06                	push   $0x6
  801838:	e8 56 ff ff ff       	call   801793 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    

00801847 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80184a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	52                   	push   %edx
  801857:	50                   	push   %eax
  801858:	6a 07                	push   $0x7
  80185a:	e8 34 ff ff ff       	call   801793 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	6a 08                	push   $0x8
  801875:	e8 19 ff ff ff       	call   801793 <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 09                	push   $0x9
  80188e:	e8 00 ff ff ff       	call   801793 <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 0a                	push   $0xa
  8018a7:	e8 e7 fe ff ff       	call   801793 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 0b                	push   $0xb
  8018c0:	e8 ce fe ff ff       	call   801793 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	6a 0f                	push   $0xf
  8018db:	e8 b3 fe ff ff       	call   801793 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
	return;
  8018e3:	90                   	nop
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	ff 75 0c             	pushl  0xc(%ebp)
  8018f2:	ff 75 08             	pushl  0x8(%ebp)
  8018f5:	6a 10                	push   $0x10
  8018f7:	e8 97 fe ff ff       	call   801793 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ff:	90                   	nop
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	ff 75 10             	pushl  0x10(%ebp)
  80190c:	ff 75 0c             	pushl  0xc(%ebp)
  80190f:	ff 75 08             	pushl  0x8(%ebp)
  801912:	6a 11                	push   $0x11
  801914:	e8 7a fe ff ff       	call   801793 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
	return ;
  80191c:	90                   	nop
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 0c                	push   $0xc
  80192e:	e8 60 fe ff ff       	call   801793 <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	ff 75 08             	pushl  0x8(%ebp)
  801946:	6a 0d                	push   $0xd
  801948:	e8 46 fe ff ff       	call   801793 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 0e                	push   $0xe
  801961:	e8 2d fe ff ff       	call   801793 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	90                   	nop
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 13                	push   $0x13
  80197b:	e8 13 fe ff ff       	call   801793 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	90                   	nop
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 14                	push   $0x14
  801995:	e8 f9 fd ff ff       	call   801793 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	90                   	nop
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	50                   	push   %eax
  8019b9:	6a 15                	push   $0x15
  8019bb:	e8 d3 fd ff ff       	call   801793 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	90                   	nop
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 16                	push   $0x16
  8019d5:	e8 b9 fd ff ff       	call   801793 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	90                   	nop
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	6a 17                	push   $0x17
  8019f2:	e8 9c fd ff ff       	call   801793 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	52                   	push   %edx
  801a0c:	50                   	push   %eax
  801a0d:	6a 1a                	push   $0x1a
  801a0f:	e8 7f fd ff ff       	call   801793 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	52                   	push   %edx
  801a29:	50                   	push   %eax
  801a2a:	6a 18                	push   $0x18
  801a2c:	e8 62 fd ff ff       	call   801793 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	90                   	nop
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	6a 19                	push   $0x19
  801a4a:	e8 44 fd ff ff       	call   801793 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	90                   	nop
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a61:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a64:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	51                   	push   %ecx
  801a6e:	52                   	push   %edx
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	50                   	push   %eax
  801a73:	6a 1b                	push   $0x1b
  801a75:	e8 19 fd ff ff       	call   801793 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	52                   	push   %edx
  801a8f:	50                   	push   %eax
  801a90:	6a 1c                	push   $0x1c
  801a92:	e8 fc fc ff ff       	call   801793 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	51                   	push   %ecx
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 1d                	push   $0x1d
  801ab1:	e8 dd fc ff ff       	call   801793 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	52                   	push   %edx
  801acb:	50                   	push   %eax
  801acc:	6a 1e                	push   $0x1e
  801ace:	e8 c0 fc ff ff       	call   801793 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 1f                	push   $0x1f
  801ae7:	e8 a7 fc ff ff       	call   801793 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 14             	pushl  0x14(%ebp)
  801afc:	ff 75 10             	pushl  0x10(%ebp)
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	50                   	push   %eax
  801b03:	6a 20                	push   $0x20
  801b05:	e8 89 fc ff ff       	call   801793 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	50                   	push   %eax
  801b1e:	6a 21                	push   $0x21
  801b20:	e8 6e fc ff ff       	call   801793 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	90                   	nop
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	50                   	push   %eax
  801b3a:	6a 22                	push   $0x22
  801b3c:	e8 52 fc ff ff       	call   801793 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 02                	push   $0x2
  801b55:	e8 39 fc ff ff       	call   801793 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 03                	push   $0x3
  801b6e:	e8 20 fc ff ff       	call   801793 <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 04                	push   $0x4
  801b87:	e8 07 fc ff ff       	call   801793 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_exit_env>:


void sys_exit_env(void)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 23                	push   $0x23
  801ba0:	e8 ee fb ff ff       	call   801793 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	90                   	nop
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bb1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bb4:	8d 50 04             	lea    0x4(%eax),%edx
  801bb7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	52                   	push   %edx
  801bc1:	50                   	push   %eax
  801bc2:	6a 24                	push   $0x24
  801bc4:	e8 ca fb ff ff       	call   801793 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
	return result;
  801bcc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bd5:	89 01                	mov    %eax,(%ecx)
  801bd7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	c9                   	leave  
  801bde:	c2 04 00             	ret    $0x4

00801be1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 10             	pushl  0x10(%ebp)
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	ff 75 08             	pushl  0x8(%ebp)
  801bf1:	6a 12                	push   $0x12
  801bf3:	e8 9b fb ff ff       	call   801793 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfb:	90                   	nop
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_rcr2>:
uint32 sys_rcr2()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 25                	push   $0x25
  801c0d:	e8 81 fb ff ff       	call   801793 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c23:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	50                   	push   %eax
  801c30:	6a 26                	push   $0x26
  801c32:	e8 5c fb ff ff       	call   801793 <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3a:	90                   	nop
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <rsttst>:
void rsttst()
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 28                	push   $0x28
  801c4c:	e8 42 fb ff ff       	call   801793 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
	return ;
  801c54:	90                   	nop
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c63:	8b 55 18             	mov    0x18(%ebp),%edx
  801c66:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c6a:	52                   	push   %edx
  801c6b:	50                   	push   %eax
  801c6c:	ff 75 10             	pushl  0x10(%ebp)
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	6a 27                	push   $0x27
  801c77:	e8 17 fb ff ff       	call   801793 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7f:	90                   	nop
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <chktst>:
void chktst(uint32 n)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	ff 75 08             	pushl  0x8(%ebp)
  801c90:	6a 29                	push   $0x29
  801c92:	e8 fc fa ff ff       	call   801793 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9a:	90                   	nop
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <inctst>:

void inctst()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 2a                	push   $0x2a
  801cac:	e8 e2 fa ff ff       	call   801793 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb4:	90                   	nop
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <gettst>:
uint32 gettst()
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 2b                	push   $0x2b
  801cc6:	e8 c8 fa ff ff       	call   801793 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 2c                	push   $0x2c
  801ce2:	e8 ac fa ff ff       	call   801793 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
  801cea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ced:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cf1:	75 07                	jne    801cfa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cf3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf8:	eb 05                	jmp    801cff <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 2c                	push   $0x2c
  801d13:	e8 7b fa ff ff       	call   801793 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
  801d1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d1e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d22:	75 07                	jne    801d2b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d24:	b8 01 00 00 00       	mov    $0x1,%eax
  801d29:	eb 05                	jmp    801d30 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 2c                	push   $0x2c
  801d44:	e8 4a fa ff ff       	call   801793 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
  801d4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d4f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d53:	75 07                	jne    801d5c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d55:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5a:	eb 05                	jmp    801d61 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 2c                	push   $0x2c
  801d75:	e8 19 fa ff ff       	call   801793 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
  801d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d80:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d84:	75 07                	jne    801d8d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d86:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8b:	eb 05                	jmp    801d92 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	ff 75 08             	pushl  0x8(%ebp)
  801da2:	6a 2d                	push   $0x2d
  801da4:	e8 ea f9 ff ff       	call   801793 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dac:	90                   	nop
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801db3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	53                   	push   %ebx
  801dc2:	51                   	push   %ecx
  801dc3:	52                   	push   %edx
  801dc4:	50                   	push   %eax
  801dc5:	6a 2e                	push   $0x2e
  801dc7:	e8 c7 f9 ff ff       	call   801793 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	52                   	push   %edx
  801de4:	50                   	push   %eax
  801de5:	6a 2f                	push   $0x2f
  801de7:	e8 a7 f9 ff ff       	call   801793 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	68 88 3f 80 00       	push   $0x803f88
  801dff:	e8 1e e8 ff ff       	call   800622 <cprintf>
  801e04:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e0e:	83 ec 0c             	sub    $0xc,%esp
  801e11:	68 b4 3f 80 00       	push   $0x803fb4
  801e16:	e8 07 e8 ff ff       	call   800622 <cprintf>
  801e1b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e1e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e22:	a1 38 51 80 00       	mov    0x805138,%eax
  801e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2a:	eb 56                	jmp    801e82 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e30:	74 1c                	je     801e4e <print_mem_block_lists+0x5d>
  801e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e35:	8b 50 08             	mov    0x8(%eax),%edx
  801e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3b:	8b 48 08             	mov    0x8(%eax),%ecx
  801e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e41:	8b 40 0c             	mov    0xc(%eax),%eax
  801e44:	01 c8                	add    %ecx,%eax
  801e46:	39 c2                	cmp    %eax,%edx
  801e48:	73 04                	jae    801e4e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e4a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e51:	8b 50 08             	mov    0x8(%eax),%edx
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	8b 40 0c             	mov    0xc(%eax),%eax
  801e5a:	01 c2                	add    %eax,%edx
  801e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5f:	8b 40 08             	mov    0x8(%eax),%eax
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	52                   	push   %edx
  801e66:	50                   	push   %eax
  801e67:	68 c9 3f 80 00       	push   $0x803fc9
  801e6c:	e8 b1 e7 ff ff       	call   800622 <cprintf>
  801e71:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e7a:	a1 40 51 80 00       	mov    0x805140,%eax
  801e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e86:	74 07                	je     801e8f <print_mem_block_lists+0x9e>
  801e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8b:	8b 00                	mov    (%eax),%eax
  801e8d:	eb 05                	jmp    801e94 <print_mem_block_lists+0xa3>
  801e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e94:	a3 40 51 80 00       	mov    %eax,0x805140
  801e99:	a1 40 51 80 00       	mov    0x805140,%eax
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	75 8a                	jne    801e2c <print_mem_block_lists+0x3b>
  801ea2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea6:	75 84                	jne    801e2c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ea8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eac:	75 10                	jne    801ebe <print_mem_block_lists+0xcd>
  801eae:	83 ec 0c             	sub    $0xc,%esp
  801eb1:	68 d8 3f 80 00       	push   $0x803fd8
  801eb6:	e8 67 e7 ff ff       	call   800622 <cprintf>
  801ebb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ebe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	68 fc 3f 80 00       	push   $0x803ffc
  801ecd:	e8 50 e7 ff ff       	call   800622 <cprintf>
  801ed2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ed5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ed9:	a1 40 50 80 00       	mov    0x805040,%eax
  801ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee1:	eb 56                	jmp    801f39 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ee3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ee7:	74 1c                	je     801f05 <print_mem_block_lists+0x114>
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	8b 50 08             	mov    0x8(%eax),%edx
  801eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef2:	8b 48 08             	mov    0x8(%eax),%ecx
  801ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  801efb:	01 c8                	add    %ecx,%eax
  801efd:	39 c2                	cmp    %eax,%edx
  801eff:	73 04                	jae    801f05 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f01:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	8b 50 08             	mov    0x8(%eax),%edx
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f11:	01 c2                	add    %eax,%edx
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	8b 40 08             	mov    0x8(%eax),%eax
  801f19:	83 ec 04             	sub    $0x4,%esp
  801f1c:	52                   	push   %edx
  801f1d:	50                   	push   %eax
  801f1e:	68 c9 3f 80 00       	push   $0x803fc9
  801f23:	e8 fa e6 ff ff       	call   800622 <cprintf>
  801f28:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f31:	a1 48 50 80 00       	mov    0x805048,%eax
  801f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f3d:	74 07                	je     801f46 <print_mem_block_lists+0x155>
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	8b 00                	mov    (%eax),%eax
  801f44:	eb 05                	jmp    801f4b <print_mem_block_lists+0x15a>
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	a3 48 50 80 00       	mov    %eax,0x805048
  801f50:	a1 48 50 80 00       	mov    0x805048,%eax
  801f55:	85 c0                	test   %eax,%eax
  801f57:	75 8a                	jne    801ee3 <print_mem_block_lists+0xf2>
  801f59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5d:	75 84                	jne    801ee3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f5f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f63:	75 10                	jne    801f75 <print_mem_block_lists+0x184>
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	68 14 40 80 00       	push   $0x804014
  801f6d:	e8 b0 e6 ff ff       	call   800622 <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f75:	83 ec 0c             	sub    $0xc,%esp
  801f78:	68 88 3f 80 00       	push   $0x803f88
  801f7d:	e8 a0 e6 ff ff       	call   800622 <cprintf>
  801f82:	83 c4 10             	add    $0x10,%esp

}
  801f85:	90                   	nop
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f8e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f95:	00 00 00 
  801f98:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f9f:	00 00 00 
  801fa2:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fa9:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fb3:	e9 9e 00 00 00       	jmp    802056 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fb8:	a1 50 50 80 00       	mov    0x805050,%eax
  801fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc0:	c1 e2 04             	shl    $0x4,%edx
  801fc3:	01 d0                	add    %edx,%eax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	75 14                	jne    801fdd <initialize_MemBlocksList+0x55>
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	68 3c 40 80 00       	push   $0x80403c
  801fd1:	6a 46                	push   $0x46
  801fd3:	68 5f 40 80 00       	push   $0x80405f
  801fd8:	e8 64 14 00 00       	call   803441 <_panic>
  801fdd:	a1 50 50 80 00       	mov    0x805050,%eax
  801fe2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe5:	c1 e2 04             	shl    $0x4,%edx
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801ff0:	89 10                	mov    %edx,(%eax)
  801ff2:	8b 00                	mov    (%eax),%eax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	74 18                	je     802010 <initialize_MemBlocksList+0x88>
  801ff8:	a1 48 51 80 00       	mov    0x805148,%eax
  801ffd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802003:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802006:	c1 e1 04             	shl    $0x4,%ecx
  802009:	01 ca                	add    %ecx,%edx
  80200b:	89 50 04             	mov    %edx,0x4(%eax)
  80200e:	eb 12                	jmp    802022 <initialize_MemBlocksList+0x9a>
  802010:	a1 50 50 80 00       	mov    0x805050,%eax
  802015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802018:	c1 e2 04             	shl    $0x4,%edx
  80201b:	01 d0                	add    %edx,%eax
  80201d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802022:	a1 50 50 80 00       	mov    0x805050,%eax
  802027:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202a:	c1 e2 04             	shl    $0x4,%edx
  80202d:	01 d0                	add    %edx,%eax
  80202f:	a3 48 51 80 00       	mov    %eax,0x805148
  802034:	a1 50 50 80 00       	mov    0x805050,%eax
  802039:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203c:	c1 e2 04             	shl    $0x4,%edx
  80203f:	01 d0                	add    %edx,%eax
  802041:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802048:	a1 54 51 80 00       	mov    0x805154,%eax
  80204d:	40                   	inc    %eax
  80204e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802053:	ff 45 f4             	incl   -0xc(%ebp)
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	3b 45 08             	cmp    0x8(%ebp),%eax
  80205c:	0f 82 56 ff ff ff    	jb     801fb8 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802062:	90                   	nop
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	8b 00                	mov    (%eax),%eax
  802070:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802073:	eb 19                	jmp    80208e <find_block+0x29>
	{
		if(va==point->sva)
  802075:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802078:	8b 40 08             	mov    0x8(%eax),%eax
  80207b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80207e:	75 05                	jne    802085 <find_block+0x20>
		   return point;
  802080:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802083:	eb 36                	jmp    8020bb <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	8b 40 08             	mov    0x8(%eax),%eax
  80208b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80208e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802092:	74 07                	je     80209b <find_block+0x36>
  802094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802097:	8b 00                	mov    (%eax),%eax
  802099:	eb 05                	jmp    8020a0 <find_block+0x3b>
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a3:	89 42 08             	mov    %eax,0x8(%edx)
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	8b 40 08             	mov    0x8(%eax),%eax
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	75 c5                	jne    802075 <find_block+0x10>
  8020b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020b4:	75 bf                	jne    802075 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8020c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020cb:	a1 44 50 80 00       	mov    0x805044,%eax
  8020d0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020d9:	74 24                	je     8020ff <insert_sorted_allocList+0x42>
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	8b 50 08             	mov    0x8(%eax),%edx
  8020e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e4:	8b 40 08             	mov    0x8(%eax),%eax
  8020e7:	39 c2                	cmp    %eax,%edx
  8020e9:	76 14                	jbe    8020ff <insert_sorted_allocList+0x42>
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	8b 50 08             	mov    0x8(%eax),%edx
  8020f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f4:	8b 40 08             	mov    0x8(%eax),%eax
  8020f7:	39 c2                	cmp    %eax,%edx
  8020f9:	0f 82 60 01 00 00    	jb     80225f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802103:	75 65                	jne    80216a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802109:	75 14                	jne    80211f <insert_sorted_allocList+0x62>
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	68 3c 40 80 00       	push   $0x80403c
  802113:	6a 6b                	push   $0x6b
  802115:	68 5f 40 80 00       	push   $0x80405f
  80211a:	e8 22 13 00 00       	call   803441 <_panic>
  80211f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	89 10                	mov    %edx,(%eax)
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	8b 00                	mov    (%eax),%eax
  80212f:	85 c0                	test   %eax,%eax
  802131:	74 0d                	je     802140 <insert_sorted_allocList+0x83>
  802133:	a1 40 50 80 00       	mov    0x805040,%eax
  802138:	8b 55 08             	mov    0x8(%ebp),%edx
  80213b:	89 50 04             	mov    %edx,0x4(%eax)
  80213e:	eb 08                	jmp    802148 <insert_sorted_allocList+0x8b>
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	a3 44 50 80 00       	mov    %eax,0x805044
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	a3 40 50 80 00       	mov    %eax,0x805040
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80215a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80215f:	40                   	inc    %eax
  802160:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802165:	e9 dc 01 00 00       	jmp    802346 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	8b 50 08             	mov    0x8(%eax),%edx
  802170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802173:	8b 40 08             	mov    0x8(%eax),%eax
  802176:	39 c2                	cmp    %eax,%edx
  802178:	77 6c                	ja     8021e6 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80217a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80217e:	74 06                	je     802186 <insert_sorted_allocList+0xc9>
  802180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802184:	75 14                	jne    80219a <insert_sorted_allocList+0xdd>
  802186:	83 ec 04             	sub    $0x4,%esp
  802189:	68 78 40 80 00       	push   $0x804078
  80218e:	6a 6f                	push   $0x6f
  802190:	68 5f 40 80 00       	push   $0x80405f
  802195:	e8 a7 12 00 00       	call   803441 <_panic>
  80219a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219d:	8b 50 04             	mov    0x4(%eax),%edx
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	89 50 04             	mov    %edx,0x4(%eax)
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ac:	89 10                	mov    %edx,(%eax)
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	8b 40 04             	mov    0x4(%eax),%eax
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	74 0d                	je     8021c5 <insert_sorted_allocList+0x108>
  8021b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bb:	8b 40 04             	mov    0x4(%eax),%eax
  8021be:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c1:	89 10                	mov    %edx,(%eax)
  8021c3:	eb 08                	jmp    8021cd <insert_sorted_allocList+0x110>
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	a3 40 50 80 00       	mov    %eax,0x805040
  8021cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d3:	89 50 04             	mov    %edx,0x4(%eax)
  8021d6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021db:	40                   	inc    %eax
  8021dc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021e1:	e9 60 01 00 00       	jmp    802346 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	8b 50 08             	mov    0x8(%eax),%edx
  8021ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ef:	8b 40 08             	mov    0x8(%eax),%eax
  8021f2:	39 c2                	cmp    %eax,%edx
  8021f4:	0f 82 4c 01 00 00    	jb     802346 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fe:	75 14                	jne    802214 <insert_sorted_allocList+0x157>
  802200:	83 ec 04             	sub    $0x4,%esp
  802203:	68 b0 40 80 00       	push   $0x8040b0
  802208:	6a 73                	push   $0x73
  80220a:	68 5f 40 80 00       	push   $0x80405f
  80220f:	e8 2d 12 00 00       	call   803441 <_panic>
  802214:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	89 50 04             	mov    %edx,0x4(%eax)
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	8b 40 04             	mov    0x4(%eax),%eax
  802226:	85 c0                	test   %eax,%eax
  802228:	74 0c                	je     802236 <insert_sorted_allocList+0x179>
  80222a:	a1 44 50 80 00       	mov    0x805044,%eax
  80222f:	8b 55 08             	mov    0x8(%ebp),%edx
  802232:	89 10                	mov    %edx,(%eax)
  802234:	eb 08                	jmp    80223e <insert_sorted_allocList+0x181>
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	a3 40 50 80 00       	mov    %eax,0x805040
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	a3 44 50 80 00       	mov    %eax,0x805044
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80224f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802254:	40                   	inc    %eax
  802255:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80225a:	e9 e7 00 00 00       	jmp    802346 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80225f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802262:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802265:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80226c:	a1 40 50 80 00       	mov    0x805040,%eax
  802271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802274:	e9 9d 00 00 00       	jmp    802316 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	8b 00                	mov    (%eax),%eax
  80227e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	8b 50 08             	mov    0x8(%eax),%edx
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	8b 40 08             	mov    0x8(%eax),%eax
  80228d:	39 c2                	cmp    %eax,%edx
  80228f:	76 7d                	jbe    80230e <insert_sorted_allocList+0x251>
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	8b 50 08             	mov    0x8(%eax),%edx
  802297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80229a:	8b 40 08             	mov    0x8(%eax),%eax
  80229d:	39 c2                	cmp    %eax,%edx
  80229f:	73 6d                	jae    80230e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a5:	74 06                	je     8022ad <insert_sorted_allocList+0x1f0>
  8022a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ab:	75 14                	jne    8022c1 <insert_sorted_allocList+0x204>
  8022ad:	83 ec 04             	sub    $0x4,%esp
  8022b0:	68 d4 40 80 00       	push   $0x8040d4
  8022b5:	6a 7f                	push   $0x7f
  8022b7:	68 5f 40 80 00       	push   $0x80405f
  8022bc:	e8 80 11 00 00       	call   803441 <_panic>
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 10                	mov    (%eax),%edx
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	89 10                	mov    %edx,(%eax)
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	8b 00                	mov    (%eax),%eax
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	74 0b                	je     8022df <insert_sorted_allocList+0x222>
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 00                	mov    (%eax),%eax
  8022d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022dc:	89 50 04             	mov    %edx,0x4(%eax)
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e5:	89 10                	mov    %edx,(%eax)
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ed:	89 50 04             	mov    %edx,0x4(%eax)
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8b 00                	mov    (%eax),%eax
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	75 08                	jne    802301 <insert_sorted_allocList+0x244>
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	a3 44 50 80 00       	mov    %eax,0x805044
  802301:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802306:	40                   	inc    %eax
  802307:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80230c:	eb 39                	jmp    802347 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80230e:	a1 48 50 80 00       	mov    0x805048,%eax
  802313:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231a:	74 07                	je     802323 <insert_sorted_allocList+0x266>
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	eb 05                	jmp    802328 <insert_sorted_allocList+0x26b>
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
  802328:	a3 48 50 80 00       	mov    %eax,0x805048
  80232d:	a1 48 50 80 00       	mov    0x805048,%eax
  802332:	85 c0                	test   %eax,%eax
  802334:	0f 85 3f ff ff ff    	jne    802279 <insert_sorted_allocList+0x1bc>
  80233a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233e:	0f 85 35 ff ff ff    	jne    802279 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802344:	eb 01                	jmp    802347 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802346:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802347:	90                   	nop
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
  80234d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802350:	a1 38 51 80 00       	mov    0x805138,%eax
  802355:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802358:	e9 85 01 00 00       	jmp    8024e2 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	8b 40 0c             	mov    0xc(%eax),%eax
  802363:	3b 45 08             	cmp    0x8(%ebp),%eax
  802366:	0f 82 6e 01 00 00    	jb     8024da <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 40 0c             	mov    0xc(%eax),%eax
  802372:	3b 45 08             	cmp    0x8(%ebp),%eax
  802375:	0f 85 8a 00 00 00    	jne    802405 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80237b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237f:	75 17                	jne    802398 <alloc_block_FF+0x4e>
  802381:	83 ec 04             	sub    $0x4,%esp
  802384:	68 08 41 80 00       	push   $0x804108
  802389:	68 93 00 00 00       	push   $0x93
  80238e:	68 5f 40 80 00       	push   $0x80405f
  802393:	e8 a9 10 00 00       	call   803441 <_panic>
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 00                	mov    (%eax),%eax
  80239d:	85 c0                	test   %eax,%eax
  80239f:	74 10                	je     8023b1 <alloc_block_FF+0x67>
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 00                	mov    (%eax),%eax
  8023a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a9:	8b 52 04             	mov    0x4(%edx),%edx
  8023ac:	89 50 04             	mov    %edx,0x4(%eax)
  8023af:	eb 0b                	jmp    8023bc <alloc_block_FF+0x72>
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 04             	mov    0x4(%eax),%eax
  8023b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 40 04             	mov    0x4(%eax),%eax
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	74 0f                	je     8023d5 <alloc_block_FF+0x8b>
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 40 04             	mov    0x4(%eax),%eax
  8023cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cf:	8b 12                	mov    (%edx),%edx
  8023d1:	89 10                	mov    %edx,(%eax)
  8023d3:	eb 0a                	jmp    8023df <alloc_block_FF+0x95>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 00                	mov    (%eax),%eax
  8023da:	a3 38 51 80 00       	mov    %eax,0x805138
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8023f7:	48                   	dec    %eax
  8023f8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	e9 10 01 00 00       	jmp    802515 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 40 0c             	mov    0xc(%eax),%eax
  80240b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240e:	0f 86 c6 00 00 00    	jbe    8024da <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802414:	a1 48 51 80 00       	mov    0x805148,%eax
  802419:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	8b 50 08             	mov    0x8(%eax),%edx
  802422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802425:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242b:	8b 55 08             	mov    0x8(%ebp),%edx
  80242e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802435:	75 17                	jne    80244e <alloc_block_FF+0x104>
  802437:	83 ec 04             	sub    $0x4,%esp
  80243a:	68 08 41 80 00       	push   $0x804108
  80243f:	68 9b 00 00 00       	push   $0x9b
  802444:	68 5f 40 80 00       	push   $0x80405f
  802449:	e8 f3 0f 00 00       	call   803441 <_panic>
  80244e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802451:	8b 00                	mov    (%eax),%eax
  802453:	85 c0                	test   %eax,%eax
  802455:	74 10                	je     802467 <alloc_block_FF+0x11d>
  802457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245f:	8b 52 04             	mov    0x4(%edx),%edx
  802462:	89 50 04             	mov    %edx,0x4(%eax)
  802465:	eb 0b                	jmp    802472 <alloc_block_FF+0x128>
  802467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246a:	8b 40 04             	mov    0x4(%eax),%eax
  80246d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802475:	8b 40 04             	mov    0x4(%eax),%eax
  802478:	85 c0                	test   %eax,%eax
  80247a:	74 0f                	je     80248b <alloc_block_FF+0x141>
  80247c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247f:	8b 40 04             	mov    0x4(%eax),%eax
  802482:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802485:	8b 12                	mov    (%edx),%edx
  802487:	89 10                	mov    %edx,(%eax)
  802489:	eb 0a                	jmp    802495 <alloc_block_FF+0x14b>
  80248b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	a3 48 51 80 00       	mov    %eax,0x805148
  802495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802498:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8024ad:	48                   	dec    %eax
  8024ae:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 50 08             	mov    0x8(%eax),%edx
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	01 c2                	add    %eax,%edx
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ca:	2b 45 08             	sub    0x8(%ebp),%eax
  8024cd:	89 c2                	mov    %eax,%edx
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d8:	eb 3b                	jmp    802515 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024da:	a1 40 51 80 00       	mov    0x805140,%eax
  8024df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e6:	74 07                	je     8024ef <alloc_block_FF+0x1a5>
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 00                	mov    (%eax),%eax
  8024ed:	eb 05                	jmp    8024f4 <alloc_block_FF+0x1aa>
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f4:	a3 40 51 80 00       	mov    %eax,0x805140
  8024f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	0f 85 57 fe ff ff    	jne    80235d <alloc_block_FF+0x13>
  802506:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250a:	0f 85 4d fe ff ff    	jne    80235d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802510:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80251d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802524:	a1 38 51 80 00       	mov    0x805138,%eax
  802529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252c:	e9 df 00 00 00       	jmp    802610 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 40 0c             	mov    0xc(%eax),%eax
  802537:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253a:	0f 82 c8 00 00 00    	jb     802608 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 40 0c             	mov    0xc(%eax),%eax
  802546:	3b 45 08             	cmp    0x8(%ebp),%eax
  802549:	0f 85 8a 00 00 00    	jne    8025d9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80254f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802553:	75 17                	jne    80256c <alloc_block_BF+0x55>
  802555:	83 ec 04             	sub    $0x4,%esp
  802558:	68 08 41 80 00       	push   $0x804108
  80255d:	68 b7 00 00 00       	push   $0xb7
  802562:	68 5f 40 80 00       	push   $0x80405f
  802567:	e8 d5 0e 00 00       	call   803441 <_panic>
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	85 c0                	test   %eax,%eax
  802573:	74 10                	je     802585 <alloc_block_BF+0x6e>
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 00                	mov    (%eax),%eax
  80257a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257d:	8b 52 04             	mov    0x4(%edx),%edx
  802580:	89 50 04             	mov    %edx,0x4(%eax)
  802583:	eb 0b                	jmp    802590 <alloc_block_BF+0x79>
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 40 04             	mov    0x4(%eax),%eax
  80258b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 40 04             	mov    0x4(%eax),%eax
  802596:	85 c0                	test   %eax,%eax
  802598:	74 0f                	je     8025a9 <alloc_block_BF+0x92>
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	8b 40 04             	mov    0x4(%eax),%eax
  8025a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a3:	8b 12                	mov    (%edx),%edx
  8025a5:	89 10                	mov    %edx,(%eax)
  8025a7:	eb 0a                	jmp    8025b3 <alloc_block_BF+0x9c>
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 00                	mov    (%eax),%eax
  8025ae:	a3 38 51 80 00       	mov    %eax,0x805138
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c6:	a1 44 51 80 00       	mov    0x805144,%eax
  8025cb:	48                   	dec    %eax
  8025cc:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	e9 4d 01 00 00       	jmp    802726 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e2:	76 24                	jbe    802608 <alloc_block_BF+0xf1>
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025ed:	73 19                	jae    802608 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025ef:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 40 08             	mov    0x8(%eax),%eax
  802605:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802608:	a1 40 51 80 00       	mov    0x805140,%eax
  80260d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802614:	74 07                	je     80261d <alloc_block_BF+0x106>
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 00                	mov    (%eax),%eax
  80261b:	eb 05                	jmp    802622 <alloc_block_BF+0x10b>
  80261d:	b8 00 00 00 00       	mov    $0x0,%eax
  802622:	a3 40 51 80 00       	mov    %eax,0x805140
  802627:	a1 40 51 80 00       	mov    0x805140,%eax
  80262c:	85 c0                	test   %eax,%eax
  80262e:	0f 85 fd fe ff ff    	jne    802531 <alloc_block_BF+0x1a>
  802634:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802638:	0f 85 f3 fe ff ff    	jne    802531 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80263e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802642:	0f 84 d9 00 00 00    	je     802721 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802648:	a1 48 51 80 00       	mov    0x805148,%eax
  80264d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802653:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802656:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265c:	8b 55 08             	mov    0x8(%ebp),%edx
  80265f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802662:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802666:	75 17                	jne    80267f <alloc_block_BF+0x168>
  802668:	83 ec 04             	sub    $0x4,%esp
  80266b:	68 08 41 80 00       	push   $0x804108
  802670:	68 c7 00 00 00       	push   $0xc7
  802675:	68 5f 40 80 00       	push   $0x80405f
  80267a:	e8 c2 0d 00 00       	call   803441 <_panic>
  80267f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802682:	8b 00                	mov    (%eax),%eax
  802684:	85 c0                	test   %eax,%eax
  802686:	74 10                	je     802698 <alloc_block_BF+0x181>
  802688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268b:	8b 00                	mov    (%eax),%eax
  80268d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802690:	8b 52 04             	mov    0x4(%edx),%edx
  802693:	89 50 04             	mov    %edx,0x4(%eax)
  802696:	eb 0b                	jmp    8026a3 <alloc_block_BF+0x18c>
  802698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269b:	8b 40 04             	mov    0x4(%eax),%eax
  80269e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a6:	8b 40 04             	mov    0x4(%eax),%eax
  8026a9:	85 c0                	test   %eax,%eax
  8026ab:	74 0f                	je     8026bc <alloc_block_BF+0x1a5>
  8026ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b0:	8b 40 04             	mov    0x4(%eax),%eax
  8026b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026b6:	8b 12                	mov    (%edx),%edx
  8026b8:	89 10                	mov    %edx,(%eax)
  8026ba:	eb 0a                	jmp    8026c6 <alloc_block_BF+0x1af>
  8026bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8026c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8026de:	48                   	dec    %eax
  8026df:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026e4:	83 ec 08             	sub    $0x8,%esp
  8026e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8026ea:	68 38 51 80 00       	push   $0x805138
  8026ef:	e8 71 f9 ff ff       	call   802065 <find_block>
  8026f4:	83 c4 10             	add    $0x10,%esp
  8026f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fd:	8b 50 08             	mov    0x8(%eax),%edx
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	01 c2                	add    %eax,%edx
  802705:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802708:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80270b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270e:	8b 40 0c             	mov    0xc(%eax),%eax
  802711:	2b 45 08             	sub    0x8(%ebp),%eax
  802714:	89 c2                	mov    %eax,%edx
  802716:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802719:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80271c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271f:	eb 05                	jmp    802726 <alloc_block_BF+0x20f>
	}
	return NULL;
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80272e:	a1 28 50 80 00       	mov    0x805028,%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	0f 85 de 01 00 00    	jne    802919 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80273b:	a1 38 51 80 00       	mov    0x805138,%eax
  802740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802743:	e9 9e 01 00 00       	jmp    8028e6 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 40 0c             	mov    0xc(%eax),%eax
  80274e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802751:	0f 82 87 01 00 00    	jb     8028de <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 40 0c             	mov    0xc(%eax),%eax
  80275d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802760:	0f 85 95 00 00 00    	jne    8027fb <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802766:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276a:	75 17                	jne    802783 <alloc_block_NF+0x5b>
  80276c:	83 ec 04             	sub    $0x4,%esp
  80276f:	68 08 41 80 00       	push   $0x804108
  802774:	68 e0 00 00 00       	push   $0xe0
  802779:	68 5f 40 80 00       	push   $0x80405f
  80277e:	e8 be 0c 00 00       	call   803441 <_panic>
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	85 c0                	test   %eax,%eax
  80278a:	74 10                	je     80279c <alloc_block_NF+0x74>
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802794:	8b 52 04             	mov    0x4(%edx),%edx
  802797:	89 50 04             	mov    %edx,0x4(%eax)
  80279a:	eb 0b                	jmp    8027a7 <alloc_block_NF+0x7f>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 40 04             	mov    0x4(%eax),%eax
  8027a2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 40 04             	mov    0x4(%eax),%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	74 0f                	je     8027c0 <alloc_block_NF+0x98>
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 40 04             	mov    0x4(%eax),%eax
  8027b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ba:	8b 12                	mov    (%edx),%edx
  8027bc:	89 10                	mov    %edx,(%eax)
  8027be:	eb 0a                	jmp    8027ca <alloc_block_NF+0xa2>
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
				   svaOfNF = point->sva;
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 40 08             	mov    0x8(%eax),%eax
  8027ee:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	e9 f8 04 00 00       	jmp    802cf3 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802801:	3b 45 08             	cmp    0x8(%ebp),%eax
  802804:	0f 86 d4 00 00 00    	jbe    8028de <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80280a:	a1 48 51 80 00       	mov    0x805148,%eax
  80280f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 50 08             	mov    0x8(%eax),%edx
  802818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80281e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802821:	8b 55 08             	mov    0x8(%ebp),%edx
  802824:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802827:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80282b:	75 17                	jne    802844 <alloc_block_NF+0x11c>
  80282d:	83 ec 04             	sub    $0x4,%esp
  802830:	68 08 41 80 00       	push   $0x804108
  802835:	68 e9 00 00 00       	push   $0xe9
  80283a:	68 5f 40 80 00       	push   $0x80405f
  80283f:	e8 fd 0b 00 00       	call   803441 <_panic>
  802844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	74 10                	je     80285d <alloc_block_NF+0x135>
  80284d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802850:	8b 00                	mov    (%eax),%eax
  802852:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802855:	8b 52 04             	mov    0x4(%edx),%edx
  802858:	89 50 04             	mov    %edx,0x4(%eax)
  80285b:	eb 0b                	jmp    802868 <alloc_block_NF+0x140>
  80285d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	8b 40 04             	mov    0x4(%eax),%eax
  80286e:	85 c0                	test   %eax,%eax
  802870:	74 0f                	je     802881 <alloc_block_NF+0x159>
  802872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802875:	8b 40 04             	mov    0x4(%eax),%eax
  802878:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80287b:	8b 12                	mov    (%edx),%edx
  80287d:	89 10                	mov    %edx,(%eax)
  80287f:	eb 0a                	jmp    80288b <alloc_block_NF+0x163>
  802881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	a3 48 51 80 00       	mov    %eax,0x805148
  80288b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289e:	a1 54 51 80 00       	mov    0x805154,%eax
  8028a3:	48                   	dec    %eax
  8028a4:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ac:	8b 40 08             	mov    0x8(%eax),%eax
  8028af:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 50 08             	mov    0x8(%eax),%edx
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	01 c2                	add    %eax,%edx
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ce:	89 c2                	mov    %eax,%edx
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d9:	e9 15 04 00 00       	jmp    802cf3 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028de:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ea:	74 07                	je     8028f3 <alloc_block_NF+0x1cb>
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	eb 05                	jmp    8028f8 <alloc_block_NF+0x1d0>
  8028f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f8:	a3 40 51 80 00       	mov    %eax,0x805140
  8028fd:	a1 40 51 80 00       	mov    0x805140,%eax
  802902:	85 c0                	test   %eax,%eax
  802904:	0f 85 3e fe ff ff    	jne    802748 <alloc_block_NF+0x20>
  80290a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290e:	0f 85 34 fe ff ff    	jne    802748 <alloc_block_NF+0x20>
  802914:	e9 d5 03 00 00       	jmp    802cee <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802919:	a1 38 51 80 00       	mov    0x805138,%eax
  80291e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802921:	e9 b1 01 00 00       	jmp    802ad7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 50 08             	mov    0x8(%eax),%edx
  80292c:	a1 28 50 80 00       	mov    0x805028,%eax
  802931:	39 c2                	cmp    %eax,%edx
  802933:	0f 82 96 01 00 00    	jb     802acf <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 40 0c             	mov    0xc(%eax),%eax
  80293f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802942:	0f 82 87 01 00 00    	jb     802acf <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 40 0c             	mov    0xc(%eax),%eax
  80294e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802951:	0f 85 95 00 00 00    	jne    8029ec <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802957:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295b:	75 17                	jne    802974 <alloc_block_NF+0x24c>
  80295d:	83 ec 04             	sub    $0x4,%esp
  802960:	68 08 41 80 00       	push   $0x804108
  802965:	68 fc 00 00 00       	push   $0xfc
  80296a:	68 5f 40 80 00       	push   $0x80405f
  80296f:	e8 cd 0a 00 00       	call   803441 <_panic>
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	74 10                	je     80298d <alloc_block_NF+0x265>
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802985:	8b 52 04             	mov    0x4(%edx),%edx
  802988:	89 50 04             	mov    %edx,0x4(%eax)
  80298b:	eb 0b                	jmp    802998 <alloc_block_NF+0x270>
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 40 04             	mov    0x4(%eax),%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	74 0f                	je     8029b1 <alloc_block_NF+0x289>
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 40 04             	mov    0x4(%eax),%eax
  8029a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ab:	8b 12                	mov    (%edx),%edx
  8029ad:	89 10                	mov    %edx,(%eax)
  8029af:	eb 0a                	jmp    8029bb <alloc_block_NF+0x293>
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8029d3:	48                   	dec    %eax
  8029d4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 40 08             	mov    0x8(%eax),%eax
  8029df:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	e9 07 03 00 00       	jmp    802cf3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f5:	0f 86 d4 00 00 00    	jbe    802acf <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029fb:	a1 48 51 80 00       	mov    0x805148,%eax
  802a00:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 50 08             	mov    0x8(%eax),%edx
  802a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a12:	8b 55 08             	mov    0x8(%ebp),%edx
  802a15:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a18:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a1c:	75 17                	jne    802a35 <alloc_block_NF+0x30d>
  802a1e:	83 ec 04             	sub    $0x4,%esp
  802a21:	68 08 41 80 00       	push   $0x804108
  802a26:	68 04 01 00 00       	push   $0x104
  802a2b:	68 5f 40 80 00       	push   $0x80405f
  802a30:	e8 0c 0a 00 00       	call   803441 <_panic>
  802a35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	74 10                	je     802a4e <alloc_block_NF+0x326>
  802a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a46:	8b 52 04             	mov    0x4(%edx),%edx
  802a49:	89 50 04             	mov    %edx,0x4(%eax)
  802a4c:	eb 0b                	jmp    802a59 <alloc_block_NF+0x331>
  802a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5c:	8b 40 04             	mov    0x4(%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 0f                	je     802a72 <alloc_block_NF+0x34a>
  802a63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a66:	8b 40 04             	mov    0x4(%eax),%eax
  802a69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a6c:	8b 12                	mov    (%edx),%edx
  802a6e:	89 10                	mov    %edx,(%eax)
  802a70:	eb 0a                	jmp    802a7c <alloc_block_NF+0x354>
  802a72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	a3 48 51 80 00       	mov    %eax,0x805148
  802a7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8f:	a1 54 51 80 00       	mov    0x805154,%eax
  802a94:	48                   	dec    %eax
  802a95:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 50 08             	mov    0x8(%eax),%edx
  802aab:	8b 45 08             	mov    0x8(%ebp),%eax
  802aae:	01 c2                	add    %eax,%edx
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  802abc:	2b 45 08             	sub    0x8(%ebp),%eax
  802abf:	89 c2                	mov    %eax,%edx
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ac7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aca:	e9 24 02 00 00       	jmp    802cf3 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802acf:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802adb:	74 07                	je     802ae4 <alloc_block_NF+0x3bc>
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	eb 05                	jmp    802ae9 <alloc_block_NF+0x3c1>
  802ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae9:	a3 40 51 80 00       	mov    %eax,0x805140
  802aee:	a1 40 51 80 00       	mov    0x805140,%eax
  802af3:	85 c0                	test   %eax,%eax
  802af5:	0f 85 2b fe ff ff    	jne    802926 <alloc_block_NF+0x1fe>
  802afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aff:	0f 85 21 fe ff ff    	jne    802926 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b05:	a1 38 51 80 00       	mov    0x805138,%eax
  802b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0d:	e9 ae 01 00 00       	jmp    802cc0 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 50 08             	mov    0x8(%eax),%edx
  802b18:	a1 28 50 80 00       	mov    0x805028,%eax
  802b1d:	39 c2                	cmp    %eax,%edx
  802b1f:	0f 83 93 01 00 00    	jae    802cb8 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2e:	0f 82 84 01 00 00    	jb     802cb8 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3d:	0f 85 95 00 00 00    	jne    802bd8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b47:	75 17                	jne    802b60 <alloc_block_NF+0x438>
  802b49:	83 ec 04             	sub    $0x4,%esp
  802b4c:	68 08 41 80 00       	push   $0x804108
  802b51:	68 14 01 00 00       	push   $0x114
  802b56:	68 5f 40 80 00       	push   $0x80405f
  802b5b:	e8 e1 08 00 00       	call   803441 <_panic>
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	85 c0                	test   %eax,%eax
  802b67:	74 10                	je     802b79 <alloc_block_NF+0x451>
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b71:	8b 52 04             	mov    0x4(%edx),%edx
  802b74:	89 50 04             	mov    %edx,0x4(%eax)
  802b77:	eb 0b                	jmp    802b84 <alloc_block_NF+0x45c>
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 40 04             	mov    0x4(%eax),%eax
  802b7f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 40 04             	mov    0x4(%eax),%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	74 0f                	je     802b9d <alloc_block_NF+0x475>
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	8b 40 04             	mov    0x4(%eax),%eax
  802b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b97:	8b 12                	mov    (%edx),%edx
  802b99:	89 10                	mov    %edx,(%eax)
  802b9b:	eb 0a                	jmp    802ba7 <alloc_block_NF+0x47f>
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bba:	a1 44 51 80 00       	mov    0x805144,%eax
  802bbf:	48                   	dec    %eax
  802bc0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 40 08             	mov    0x8(%eax),%eax
  802bcb:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	e9 1b 01 00 00       	jmp    802cf3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bde:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be1:	0f 86 d1 00 00 00    	jbe    802cb8 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802be7:	a1 48 51 80 00       	mov    0x805148,%eax
  802bec:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 50 08             	mov    0x8(%eax),%edx
  802bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfe:	8b 55 08             	mov    0x8(%ebp),%edx
  802c01:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c08:	75 17                	jne    802c21 <alloc_block_NF+0x4f9>
  802c0a:	83 ec 04             	sub    $0x4,%esp
  802c0d:	68 08 41 80 00       	push   $0x804108
  802c12:	68 1c 01 00 00       	push   $0x11c
  802c17:	68 5f 40 80 00       	push   $0x80405f
  802c1c:	e8 20 08 00 00       	call   803441 <_panic>
  802c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	74 10                	je     802c3a <alloc_block_NF+0x512>
  802c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c32:	8b 52 04             	mov    0x4(%edx),%edx
  802c35:	89 50 04             	mov    %edx,0x4(%eax)
  802c38:	eb 0b                	jmp    802c45 <alloc_block_NF+0x51d>
  802c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3d:	8b 40 04             	mov    0x4(%eax),%eax
  802c40:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	74 0f                	je     802c5e <alloc_block_NF+0x536>
  802c4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c58:	8b 12                	mov    (%edx),%edx
  802c5a:	89 10                	mov    %edx,(%eax)
  802c5c:	eb 0a                	jmp    802c68 <alloc_block_NF+0x540>
  802c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c61:	8b 00                	mov    (%eax),%eax
  802c63:	a3 48 51 80 00       	mov    %eax,0x805148
  802c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7b:	a1 54 51 80 00       	mov    0x805154,%eax
  802c80:	48                   	dec    %eax
  802c81:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c89:	8b 40 08             	mov    0x8(%eax),%eax
  802c8c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 50 08             	mov    0x8(%eax),%edx
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	01 c2                	add    %eax,%edx
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca8:	2b 45 08             	sub    0x8(%ebp),%eax
  802cab:	89 c2                	mov    %eax,%edx
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb6:	eb 3b                	jmp    802cf3 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cb8:	a1 40 51 80 00       	mov    0x805140,%eax
  802cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc4:	74 07                	je     802ccd <alloc_block_NF+0x5a5>
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 00                	mov    (%eax),%eax
  802ccb:	eb 05                	jmp    802cd2 <alloc_block_NF+0x5aa>
  802ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd2:	a3 40 51 80 00       	mov    %eax,0x805140
  802cd7:	a1 40 51 80 00       	mov    0x805140,%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	0f 85 2e fe ff ff    	jne    802b12 <alloc_block_NF+0x3ea>
  802ce4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce8:	0f 85 24 fe ff ff    	jne    802b12 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cf3:	c9                   	leave  
  802cf4:	c3                   	ret    

00802cf5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cf5:	55                   	push   %ebp
  802cf6:	89 e5                	mov    %esp,%ebp
  802cf8:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cfb:	a1 38 51 80 00       	mov    0x805138,%eax
  802d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d03:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d08:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d0b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 14                	je     802d28 <insert_sorted_with_merge_freeList+0x33>
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	8b 50 08             	mov    0x8(%eax),%edx
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	8b 40 08             	mov    0x8(%eax),%eax
  802d20:	39 c2                	cmp    %eax,%edx
  802d22:	0f 87 9b 01 00 00    	ja     802ec3 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d2c:	75 17                	jne    802d45 <insert_sorted_with_merge_freeList+0x50>
  802d2e:	83 ec 04             	sub    $0x4,%esp
  802d31:	68 3c 40 80 00       	push   $0x80403c
  802d36:	68 38 01 00 00       	push   $0x138
  802d3b:	68 5f 40 80 00       	push   $0x80405f
  802d40:	e8 fc 06 00 00       	call   803441 <_panic>
  802d45:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	89 10                	mov    %edx,(%eax)
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	85 c0                	test   %eax,%eax
  802d57:	74 0d                	je     802d66 <insert_sorted_with_merge_freeList+0x71>
  802d59:	a1 38 51 80 00       	mov    0x805138,%eax
  802d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d61:	89 50 04             	mov    %edx,0x4(%eax)
  802d64:	eb 08                	jmp    802d6e <insert_sorted_with_merge_freeList+0x79>
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	a3 38 51 80 00       	mov    %eax,0x805138
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d80:	a1 44 51 80 00       	mov    0x805144,%eax
  802d85:	40                   	inc    %eax
  802d86:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8f:	0f 84 a8 06 00 00    	je     80343d <insert_sorted_with_merge_freeList+0x748>
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 50 08             	mov    0x8(%eax),%edx
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802da1:	01 c2                	add    %eax,%edx
  802da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da6:	8b 40 08             	mov    0x8(%eax),%eax
  802da9:	39 c2                	cmp    %eax,%edx
  802dab:	0f 85 8c 06 00 00    	jne    80343d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	8b 50 0c             	mov    0xc(%eax),%edx
  802db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dba:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbd:	01 c2                	add    %eax,%edx
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc9:	75 17                	jne    802de2 <insert_sorted_with_merge_freeList+0xed>
  802dcb:	83 ec 04             	sub    $0x4,%esp
  802dce:	68 08 41 80 00       	push   $0x804108
  802dd3:	68 3c 01 00 00       	push   $0x13c
  802dd8:	68 5f 40 80 00       	push   $0x80405f
  802ddd:	e8 5f 06 00 00       	call   803441 <_panic>
  802de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 10                	je     802dfb <insert_sorted_with_merge_freeList+0x106>
  802deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df3:	8b 52 04             	mov    0x4(%edx),%edx
  802df6:	89 50 04             	mov    %edx,0x4(%eax)
  802df9:	eb 0b                	jmp    802e06 <insert_sorted_with_merge_freeList+0x111>
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	8b 40 04             	mov    0x4(%eax),%eax
  802e01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e09:	8b 40 04             	mov    0x4(%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 0f                	je     802e1f <insert_sorted_with_merge_freeList+0x12a>
  802e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e19:	8b 12                	mov    (%edx),%edx
  802e1b:	89 10                	mov    %edx,(%eax)
  802e1d:	eb 0a                	jmp    802e29 <insert_sorted_with_merge_freeList+0x134>
  802e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	a3 38 51 80 00       	mov    %eax,0x805138
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3c:	a1 44 51 80 00       	mov    0x805144,%eax
  802e41:	48                   	dec    %eax
  802e42:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e5f:	75 17                	jne    802e78 <insert_sorted_with_merge_freeList+0x183>
  802e61:	83 ec 04             	sub    $0x4,%esp
  802e64:	68 3c 40 80 00       	push   $0x80403c
  802e69:	68 3f 01 00 00       	push   $0x13f
  802e6e:	68 5f 40 80 00       	push   $0x80405f
  802e73:	e8 c9 05 00 00       	call   803441 <_panic>
  802e78:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	74 0d                	je     802e99 <insert_sorted_with_merge_freeList+0x1a4>
  802e8c:	a1 48 51 80 00       	mov    0x805148,%eax
  802e91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e94:	89 50 04             	mov    %edx,0x4(%eax)
  802e97:	eb 08                	jmp    802ea1 <insert_sorted_with_merge_freeList+0x1ac>
  802e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb3:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb8:	40                   	inc    %eax
  802eb9:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ebe:	e9 7a 05 00 00       	jmp    80343d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	8b 50 08             	mov    0x8(%eax),%edx
  802ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecc:	8b 40 08             	mov    0x8(%eax),%eax
  802ecf:	39 c2                	cmp    %eax,%edx
  802ed1:	0f 82 14 01 00 00    	jb     802feb <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eda:	8b 50 08             	mov    0x8(%eax),%edx
  802edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee3:	01 c2                	add    %eax,%edx
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	8b 40 08             	mov    0x8(%eax),%eax
  802eeb:	39 c2                	cmp    %eax,%edx
  802eed:	0f 85 90 00 00 00    	jne    802f83 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	8b 40 0c             	mov    0xc(%eax),%eax
  802eff:	01 c2                	add    %eax,%edx
  802f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f04:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1f:	75 17                	jne    802f38 <insert_sorted_with_merge_freeList+0x243>
  802f21:	83 ec 04             	sub    $0x4,%esp
  802f24:	68 3c 40 80 00       	push   $0x80403c
  802f29:	68 49 01 00 00       	push   $0x149
  802f2e:	68 5f 40 80 00       	push   $0x80405f
  802f33:	e8 09 05 00 00       	call   803441 <_panic>
  802f38:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	89 10                	mov    %edx,(%eax)
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	85 c0                	test   %eax,%eax
  802f4a:	74 0d                	je     802f59 <insert_sorted_with_merge_freeList+0x264>
  802f4c:	a1 48 51 80 00       	mov    0x805148,%eax
  802f51:	8b 55 08             	mov    0x8(%ebp),%edx
  802f54:	89 50 04             	mov    %edx,0x4(%eax)
  802f57:	eb 08                	jmp    802f61 <insert_sorted_with_merge_freeList+0x26c>
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	a3 48 51 80 00       	mov    %eax,0x805148
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f73:	a1 54 51 80 00       	mov    0x805154,%eax
  802f78:	40                   	inc    %eax
  802f79:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f7e:	e9 bb 04 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f87:	75 17                	jne    802fa0 <insert_sorted_with_merge_freeList+0x2ab>
  802f89:	83 ec 04             	sub    $0x4,%esp
  802f8c:	68 b0 40 80 00       	push   $0x8040b0
  802f91:	68 4c 01 00 00       	push   $0x14c
  802f96:	68 5f 40 80 00       	push   $0x80405f
  802f9b:	e8 a1 04 00 00       	call   803441 <_panic>
  802fa0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	89 50 04             	mov    %edx,0x4(%eax)
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 0c                	je     802fc2 <insert_sorted_with_merge_freeList+0x2cd>
  802fb6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbe:	89 10                	mov    %edx,(%eax)
  802fc0:	eb 08                	jmp    802fca <insert_sorted_with_merge_freeList+0x2d5>
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	a3 38 51 80 00       	mov    %eax,0x805138
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdb:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe0:	40                   	inc    %eax
  802fe1:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fe6:	e9 53 04 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802feb:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff3:	e9 15 04 00 00       	jmp    80340d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 50 08             	mov    0x8(%eax),%edx
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 40 08             	mov    0x8(%eax),%eax
  80300c:	39 c2                	cmp    %eax,%edx
  80300e:	0f 86 f1 03 00 00    	jbe    803405 <insert_sorted_with_merge_freeList+0x710>
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	8b 50 08             	mov    0x8(%eax),%edx
  80301a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301d:	8b 40 08             	mov    0x8(%eax),%eax
  803020:	39 c2                	cmp    %eax,%edx
  803022:	0f 83 dd 03 00 00    	jae    803405 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	8b 50 08             	mov    0x8(%eax),%edx
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 40 0c             	mov    0xc(%eax),%eax
  803034:	01 c2                	add    %eax,%edx
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	8b 40 08             	mov    0x8(%eax),%eax
  80303c:	39 c2                	cmp    %eax,%edx
  80303e:	0f 85 b9 01 00 00    	jne    8031fd <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	8b 50 08             	mov    0x8(%eax),%edx
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	8b 40 0c             	mov    0xc(%eax),%eax
  803050:	01 c2                	add    %eax,%edx
  803052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803055:	8b 40 08             	mov    0x8(%eax),%eax
  803058:	39 c2                	cmp    %eax,%edx
  80305a:	0f 85 0d 01 00 00    	jne    80316d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	8b 50 0c             	mov    0xc(%eax),%edx
  803066:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803069:	8b 40 0c             	mov    0xc(%eax),%eax
  80306c:	01 c2                	add    %eax,%edx
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803074:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803078:	75 17                	jne    803091 <insert_sorted_with_merge_freeList+0x39c>
  80307a:	83 ec 04             	sub    $0x4,%esp
  80307d:	68 08 41 80 00       	push   $0x804108
  803082:	68 5c 01 00 00       	push   $0x15c
  803087:	68 5f 40 80 00       	push   $0x80405f
  80308c:	e8 b0 03 00 00       	call   803441 <_panic>
  803091:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803094:	8b 00                	mov    (%eax),%eax
  803096:	85 c0                	test   %eax,%eax
  803098:	74 10                	je     8030aa <insert_sorted_with_merge_freeList+0x3b5>
  80309a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309d:	8b 00                	mov    (%eax),%eax
  80309f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a2:	8b 52 04             	mov    0x4(%edx),%edx
  8030a5:	89 50 04             	mov    %edx,0x4(%eax)
  8030a8:	eb 0b                	jmp    8030b5 <insert_sorted_with_merge_freeList+0x3c0>
  8030aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ad:	8b 40 04             	mov    0x4(%eax),%eax
  8030b0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b8:	8b 40 04             	mov    0x4(%eax),%eax
  8030bb:	85 c0                	test   %eax,%eax
  8030bd:	74 0f                	je     8030ce <insert_sorted_with_merge_freeList+0x3d9>
  8030bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c2:	8b 40 04             	mov    0x4(%eax),%eax
  8030c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c8:	8b 12                	mov    (%edx),%edx
  8030ca:	89 10                	mov    %edx,(%eax)
  8030cc:	eb 0a                	jmp    8030d8 <insert_sorted_with_merge_freeList+0x3e3>
  8030ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d1:	8b 00                	mov    (%eax),%eax
  8030d3:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f0:	48                   	dec    %eax
  8030f1:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803103:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80310a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80310e:	75 17                	jne    803127 <insert_sorted_with_merge_freeList+0x432>
  803110:	83 ec 04             	sub    $0x4,%esp
  803113:	68 3c 40 80 00       	push   $0x80403c
  803118:	68 5f 01 00 00       	push   $0x15f
  80311d:	68 5f 40 80 00       	push   $0x80405f
  803122:	e8 1a 03 00 00       	call   803441 <_panic>
  803127:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80312d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803130:	89 10                	mov    %edx,(%eax)
  803132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803135:	8b 00                	mov    (%eax),%eax
  803137:	85 c0                	test   %eax,%eax
  803139:	74 0d                	je     803148 <insert_sorted_with_merge_freeList+0x453>
  80313b:	a1 48 51 80 00       	mov    0x805148,%eax
  803140:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803143:	89 50 04             	mov    %edx,0x4(%eax)
  803146:	eb 08                	jmp    803150 <insert_sorted_with_merge_freeList+0x45b>
  803148:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803153:	a3 48 51 80 00       	mov    %eax,0x805148
  803158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803162:	a1 54 51 80 00       	mov    0x805154,%eax
  803167:	40                   	inc    %eax
  803168:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80316d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803170:	8b 50 0c             	mov    0xc(%eax),%edx
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	8b 40 0c             	mov    0xc(%eax),%eax
  803179:	01 c2                	add    %eax,%edx
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803181:	8b 45 08             	mov    0x8(%ebp),%eax
  803184:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803195:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803199:	75 17                	jne    8031b2 <insert_sorted_with_merge_freeList+0x4bd>
  80319b:	83 ec 04             	sub    $0x4,%esp
  80319e:	68 3c 40 80 00       	push   $0x80403c
  8031a3:	68 64 01 00 00       	push   $0x164
  8031a8:	68 5f 40 80 00       	push   $0x80405f
  8031ad:	e8 8f 02 00 00       	call   803441 <_panic>
  8031b2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	89 10                	mov    %edx,(%eax)
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 00                	mov    (%eax),%eax
  8031c2:	85 c0                	test   %eax,%eax
  8031c4:	74 0d                	je     8031d3 <insert_sorted_with_merge_freeList+0x4de>
  8031c6:	a1 48 51 80 00       	mov    0x805148,%eax
  8031cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ce:	89 50 04             	mov    %edx,0x4(%eax)
  8031d1:	eb 08                	jmp    8031db <insert_sorted_with_merge_freeList+0x4e6>
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	a3 48 51 80 00       	mov    %eax,0x805148
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f2:	40                   	inc    %eax
  8031f3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031f8:	e9 41 02 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	8b 50 08             	mov    0x8(%eax),%edx
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	8b 40 0c             	mov    0xc(%eax),%eax
  803209:	01 c2                	add    %eax,%edx
  80320b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320e:	8b 40 08             	mov    0x8(%eax),%eax
  803211:	39 c2                	cmp    %eax,%edx
  803213:	0f 85 7c 01 00 00    	jne    803395 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803219:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80321d:	74 06                	je     803225 <insert_sorted_with_merge_freeList+0x530>
  80321f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803223:	75 17                	jne    80323c <insert_sorted_with_merge_freeList+0x547>
  803225:	83 ec 04             	sub    $0x4,%esp
  803228:	68 78 40 80 00       	push   $0x804078
  80322d:	68 69 01 00 00       	push   $0x169
  803232:	68 5f 40 80 00       	push   $0x80405f
  803237:	e8 05 02 00 00       	call   803441 <_panic>
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	8b 50 04             	mov    0x4(%eax),%edx
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	89 50 04             	mov    %edx,0x4(%eax)
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80324e:	89 10                	mov    %edx,(%eax)
  803250:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803253:	8b 40 04             	mov    0x4(%eax),%eax
  803256:	85 c0                	test   %eax,%eax
  803258:	74 0d                	je     803267 <insert_sorted_with_merge_freeList+0x572>
  80325a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325d:	8b 40 04             	mov    0x4(%eax),%eax
  803260:	8b 55 08             	mov    0x8(%ebp),%edx
  803263:	89 10                	mov    %edx,(%eax)
  803265:	eb 08                	jmp    80326f <insert_sorted_with_merge_freeList+0x57a>
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	a3 38 51 80 00       	mov    %eax,0x805138
  80326f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803272:	8b 55 08             	mov    0x8(%ebp),%edx
  803275:	89 50 04             	mov    %edx,0x4(%eax)
  803278:	a1 44 51 80 00       	mov    0x805144,%eax
  80327d:	40                   	inc    %eax
  80327e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	8b 50 0c             	mov    0xc(%eax),%edx
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	8b 40 0c             	mov    0xc(%eax),%eax
  80328f:	01 c2                	add    %eax,%edx
  803291:	8b 45 08             	mov    0x8(%ebp),%eax
  803294:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803297:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80329b:	75 17                	jne    8032b4 <insert_sorted_with_merge_freeList+0x5bf>
  80329d:	83 ec 04             	sub    $0x4,%esp
  8032a0:	68 08 41 80 00       	push   $0x804108
  8032a5:	68 6b 01 00 00       	push   $0x16b
  8032aa:	68 5f 40 80 00       	push   $0x80405f
  8032af:	e8 8d 01 00 00       	call   803441 <_panic>
  8032b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	85 c0                	test   %eax,%eax
  8032bb:	74 10                	je     8032cd <insert_sorted_with_merge_freeList+0x5d8>
  8032bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c5:	8b 52 04             	mov    0x4(%edx),%edx
  8032c8:	89 50 04             	mov    %edx,0x4(%eax)
  8032cb:	eb 0b                	jmp    8032d8 <insert_sorted_with_merge_freeList+0x5e3>
  8032cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d0:	8b 40 04             	mov    0x4(%eax),%eax
  8032d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032db:	8b 40 04             	mov    0x4(%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	74 0f                	je     8032f1 <insert_sorted_with_merge_freeList+0x5fc>
  8032e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e5:	8b 40 04             	mov    0x4(%eax),%eax
  8032e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032eb:	8b 12                	mov    (%edx),%edx
  8032ed:	89 10                	mov    %edx,(%eax)
  8032ef:	eb 0a                	jmp    8032fb <insert_sorted_with_merge_freeList+0x606>
  8032f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803304:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803307:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330e:	a1 44 51 80 00       	mov    0x805144,%eax
  803313:	48                   	dec    %eax
  803314:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80332d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803331:	75 17                	jne    80334a <insert_sorted_with_merge_freeList+0x655>
  803333:	83 ec 04             	sub    $0x4,%esp
  803336:	68 3c 40 80 00       	push   $0x80403c
  80333b:	68 6e 01 00 00       	push   $0x16e
  803340:	68 5f 40 80 00       	push   $0x80405f
  803345:	e8 f7 00 00 00       	call   803441 <_panic>
  80334a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803353:	89 10                	mov    %edx,(%eax)
  803355:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803358:	8b 00                	mov    (%eax),%eax
  80335a:	85 c0                	test   %eax,%eax
  80335c:	74 0d                	je     80336b <insert_sorted_with_merge_freeList+0x676>
  80335e:	a1 48 51 80 00       	mov    0x805148,%eax
  803363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803366:	89 50 04             	mov    %edx,0x4(%eax)
  803369:	eb 08                	jmp    803373 <insert_sorted_with_merge_freeList+0x67e>
  80336b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803373:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803376:	a3 48 51 80 00       	mov    %eax,0x805148
  80337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803385:	a1 54 51 80 00       	mov    0x805154,%eax
  80338a:	40                   	inc    %eax
  80338b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803390:	e9 a9 00 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803395:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803399:	74 06                	je     8033a1 <insert_sorted_with_merge_freeList+0x6ac>
  80339b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339f:	75 17                	jne    8033b8 <insert_sorted_with_merge_freeList+0x6c3>
  8033a1:	83 ec 04             	sub    $0x4,%esp
  8033a4:	68 d4 40 80 00       	push   $0x8040d4
  8033a9:	68 73 01 00 00       	push   $0x173
  8033ae:	68 5f 40 80 00       	push   $0x80405f
  8033b3:	e8 89 00 00 00       	call   803441 <_panic>
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	8b 10                	mov    (%eax),%edx
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	89 10                	mov    %edx,(%eax)
  8033c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c5:	8b 00                	mov    (%eax),%eax
  8033c7:	85 c0                	test   %eax,%eax
  8033c9:	74 0b                	je     8033d6 <insert_sorted_with_merge_freeList+0x6e1>
  8033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d3:	89 50 04             	mov    %edx,0x4(%eax)
  8033d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8033dc:	89 10                	mov    %edx,(%eax)
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e4:	89 50 04             	mov    %edx,0x4(%eax)
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	85 c0                	test   %eax,%eax
  8033ee:	75 08                	jne    8033f8 <insert_sorted_with_merge_freeList+0x703>
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8033fd:	40                   	inc    %eax
  8033fe:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803403:	eb 39                	jmp    80343e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803405:	a1 40 51 80 00       	mov    0x805140,%eax
  80340a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80340d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803411:	74 07                	je     80341a <insert_sorted_with_merge_freeList+0x725>
  803413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803416:	8b 00                	mov    (%eax),%eax
  803418:	eb 05                	jmp    80341f <insert_sorted_with_merge_freeList+0x72a>
  80341a:	b8 00 00 00 00       	mov    $0x0,%eax
  80341f:	a3 40 51 80 00       	mov    %eax,0x805140
  803424:	a1 40 51 80 00       	mov    0x805140,%eax
  803429:	85 c0                	test   %eax,%eax
  80342b:	0f 85 c7 fb ff ff    	jne    802ff8 <insert_sorted_with_merge_freeList+0x303>
  803431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803435:	0f 85 bd fb ff ff    	jne    802ff8 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80343b:	eb 01                	jmp    80343e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80343d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80343e:	90                   	nop
  80343f:	c9                   	leave  
  803440:	c3                   	ret    

00803441 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803441:	55                   	push   %ebp
  803442:	89 e5                	mov    %esp,%ebp
  803444:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803447:	8d 45 10             	lea    0x10(%ebp),%eax
  80344a:	83 c0 04             	add    $0x4,%eax
  80344d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803450:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803455:	85 c0                	test   %eax,%eax
  803457:	74 16                	je     80346f <_panic+0x2e>
		cprintf("%s: ", argv0);
  803459:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80345e:	83 ec 08             	sub    $0x8,%esp
  803461:	50                   	push   %eax
  803462:	68 28 41 80 00       	push   $0x804128
  803467:	e8 b6 d1 ff ff       	call   800622 <cprintf>
  80346c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80346f:	a1 00 50 80 00       	mov    0x805000,%eax
  803474:	ff 75 0c             	pushl  0xc(%ebp)
  803477:	ff 75 08             	pushl  0x8(%ebp)
  80347a:	50                   	push   %eax
  80347b:	68 2d 41 80 00       	push   $0x80412d
  803480:	e8 9d d1 ff ff       	call   800622 <cprintf>
  803485:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803488:	8b 45 10             	mov    0x10(%ebp),%eax
  80348b:	83 ec 08             	sub    $0x8,%esp
  80348e:	ff 75 f4             	pushl  -0xc(%ebp)
  803491:	50                   	push   %eax
  803492:	e8 20 d1 ff ff       	call   8005b7 <vcprintf>
  803497:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80349a:	83 ec 08             	sub    $0x8,%esp
  80349d:	6a 00                	push   $0x0
  80349f:	68 49 41 80 00       	push   $0x804149
  8034a4:	e8 0e d1 ff ff       	call   8005b7 <vcprintf>
  8034a9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8034ac:	e8 8f d0 ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  8034b1:	eb fe                	jmp    8034b1 <_panic+0x70>

008034b3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8034b3:	55                   	push   %ebp
  8034b4:	89 e5                	mov    %esp,%ebp
  8034b6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8034b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8034be:	8b 50 74             	mov    0x74(%eax),%edx
  8034c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c4:	39 c2                	cmp    %eax,%edx
  8034c6:	74 14                	je     8034dc <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8034c8:	83 ec 04             	sub    $0x4,%esp
  8034cb:	68 4c 41 80 00       	push   $0x80414c
  8034d0:	6a 26                	push   $0x26
  8034d2:	68 98 41 80 00       	push   $0x804198
  8034d7:	e8 65 ff ff ff       	call   803441 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8034dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8034e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8034ea:	e9 c2 00 00 00       	jmp    8035b1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8034ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	01 d0                	add    %edx,%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	85 c0                	test   %eax,%eax
  803502:	75 08                	jne    80350c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803504:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803507:	e9 a2 00 00 00       	jmp    8035ae <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80350c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803513:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80351a:	eb 69                	jmp    803585 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80351c:	a1 20 50 80 00       	mov    0x805020,%eax
  803521:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803527:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80352a:	89 d0                	mov    %edx,%eax
  80352c:	01 c0                	add    %eax,%eax
  80352e:	01 d0                	add    %edx,%eax
  803530:	c1 e0 03             	shl    $0x3,%eax
  803533:	01 c8                	add    %ecx,%eax
  803535:	8a 40 04             	mov    0x4(%eax),%al
  803538:	84 c0                	test   %al,%al
  80353a:	75 46                	jne    803582 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80353c:	a1 20 50 80 00       	mov    0x805020,%eax
  803541:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803547:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80354a:	89 d0                	mov    %edx,%eax
  80354c:	01 c0                	add    %eax,%eax
  80354e:	01 d0                	add    %edx,%eax
  803550:	c1 e0 03             	shl    $0x3,%eax
  803553:	01 c8                	add    %ecx,%eax
  803555:	8b 00                	mov    (%eax),%eax
  803557:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80355a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80355d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803562:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803567:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	01 c8                	add    %ecx,%eax
  803573:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803575:	39 c2                	cmp    %eax,%edx
  803577:	75 09                	jne    803582 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803579:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803580:	eb 12                	jmp    803594 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803582:	ff 45 e8             	incl   -0x18(%ebp)
  803585:	a1 20 50 80 00       	mov    0x805020,%eax
  80358a:	8b 50 74             	mov    0x74(%eax),%edx
  80358d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803590:	39 c2                	cmp    %eax,%edx
  803592:	77 88                	ja     80351c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803594:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803598:	75 14                	jne    8035ae <CheckWSWithoutLastIndex+0xfb>
			panic(
  80359a:	83 ec 04             	sub    $0x4,%esp
  80359d:	68 a4 41 80 00       	push   $0x8041a4
  8035a2:	6a 3a                	push   $0x3a
  8035a4:	68 98 41 80 00       	push   $0x804198
  8035a9:	e8 93 fe ff ff       	call   803441 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8035ae:	ff 45 f0             	incl   -0x10(%ebp)
  8035b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035b7:	0f 8c 32 ff ff ff    	jl     8034ef <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8035bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8035cb:	eb 26                	jmp    8035f3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8035cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8035d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035db:	89 d0                	mov    %edx,%eax
  8035dd:	01 c0                	add    %eax,%eax
  8035df:	01 d0                	add    %edx,%eax
  8035e1:	c1 e0 03             	shl    $0x3,%eax
  8035e4:	01 c8                	add    %ecx,%eax
  8035e6:	8a 40 04             	mov    0x4(%eax),%al
  8035e9:	3c 01                	cmp    $0x1,%al
  8035eb:	75 03                	jne    8035f0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8035ed:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035f0:	ff 45 e0             	incl   -0x20(%ebp)
  8035f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8035f8:	8b 50 74             	mov    0x74(%eax),%edx
  8035fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035fe:	39 c2                	cmp    %eax,%edx
  803600:	77 cb                	ja     8035cd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803605:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803608:	74 14                	je     80361e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80360a:	83 ec 04             	sub    $0x4,%esp
  80360d:	68 f8 41 80 00       	push   $0x8041f8
  803612:	6a 44                	push   $0x44
  803614:	68 98 41 80 00       	push   $0x804198
  803619:	e8 23 fe ff ff       	call   803441 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80361e:	90                   	nop
  80361f:	c9                   	leave  
  803620:	c3                   	ret    
  803621:	66 90                	xchg   %ax,%ax
  803623:	90                   	nop

00803624 <__udivdi3>:
  803624:	55                   	push   %ebp
  803625:	57                   	push   %edi
  803626:	56                   	push   %esi
  803627:	53                   	push   %ebx
  803628:	83 ec 1c             	sub    $0x1c,%esp
  80362b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80362f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803633:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803637:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80363b:	89 ca                	mov    %ecx,%edx
  80363d:	89 f8                	mov    %edi,%eax
  80363f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803643:	85 f6                	test   %esi,%esi
  803645:	75 2d                	jne    803674 <__udivdi3+0x50>
  803647:	39 cf                	cmp    %ecx,%edi
  803649:	77 65                	ja     8036b0 <__udivdi3+0x8c>
  80364b:	89 fd                	mov    %edi,%ebp
  80364d:	85 ff                	test   %edi,%edi
  80364f:	75 0b                	jne    80365c <__udivdi3+0x38>
  803651:	b8 01 00 00 00       	mov    $0x1,%eax
  803656:	31 d2                	xor    %edx,%edx
  803658:	f7 f7                	div    %edi
  80365a:	89 c5                	mov    %eax,%ebp
  80365c:	31 d2                	xor    %edx,%edx
  80365e:	89 c8                	mov    %ecx,%eax
  803660:	f7 f5                	div    %ebp
  803662:	89 c1                	mov    %eax,%ecx
  803664:	89 d8                	mov    %ebx,%eax
  803666:	f7 f5                	div    %ebp
  803668:	89 cf                	mov    %ecx,%edi
  80366a:	89 fa                	mov    %edi,%edx
  80366c:	83 c4 1c             	add    $0x1c,%esp
  80366f:	5b                   	pop    %ebx
  803670:	5e                   	pop    %esi
  803671:	5f                   	pop    %edi
  803672:	5d                   	pop    %ebp
  803673:	c3                   	ret    
  803674:	39 ce                	cmp    %ecx,%esi
  803676:	77 28                	ja     8036a0 <__udivdi3+0x7c>
  803678:	0f bd fe             	bsr    %esi,%edi
  80367b:	83 f7 1f             	xor    $0x1f,%edi
  80367e:	75 40                	jne    8036c0 <__udivdi3+0x9c>
  803680:	39 ce                	cmp    %ecx,%esi
  803682:	72 0a                	jb     80368e <__udivdi3+0x6a>
  803684:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803688:	0f 87 9e 00 00 00    	ja     80372c <__udivdi3+0x108>
  80368e:	b8 01 00 00 00       	mov    $0x1,%eax
  803693:	89 fa                	mov    %edi,%edx
  803695:	83 c4 1c             	add    $0x1c,%esp
  803698:	5b                   	pop    %ebx
  803699:	5e                   	pop    %esi
  80369a:	5f                   	pop    %edi
  80369b:	5d                   	pop    %ebp
  80369c:	c3                   	ret    
  80369d:	8d 76 00             	lea    0x0(%esi),%esi
  8036a0:	31 ff                	xor    %edi,%edi
  8036a2:	31 c0                	xor    %eax,%eax
  8036a4:	89 fa                	mov    %edi,%edx
  8036a6:	83 c4 1c             	add    $0x1c,%esp
  8036a9:	5b                   	pop    %ebx
  8036aa:	5e                   	pop    %esi
  8036ab:	5f                   	pop    %edi
  8036ac:	5d                   	pop    %ebp
  8036ad:	c3                   	ret    
  8036ae:	66 90                	xchg   %ax,%ax
  8036b0:	89 d8                	mov    %ebx,%eax
  8036b2:	f7 f7                	div    %edi
  8036b4:	31 ff                	xor    %edi,%edi
  8036b6:	89 fa                	mov    %edi,%edx
  8036b8:	83 c4 1c             	add    $0x1c,%esp
  8036bb:	5b                   	pop    %ebx
  8036bc:	5e                   	pop    %esi
  8036bd:	5f                   	pop    %edi
  8036be:	5d                   	pop    %ebp
  8036bf:	c3                   	ret    
  8036c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036c5:	89 eb                	mov    %ebp,%ebx
  8036c7:	29 fb                	sub    %edi,%ebx
  8036c9:	89 f9                	mov    %edi,%ecx
  8036cb:	d3 e6                	shl    %cl,%esi
  8036cd:	89 c5                	mov    %eax,%ebp
  8036cf:	88 d9                	mov    %bl,%cl
  8036d1:	d3 ed                	shr    %cl,%ebp
  8036d3:	89 e9                	mov    %ebp,%ecx
  8036d5:	09 f1                	or     %esi,%ecx
  8036d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036db:	89 f9                	mov    %edi,%ecx
  8036dd:	d3 e0                	shl    %cl,%eax
  8036df:	89 c5                	mov    %eax,%ebp
  8036e1:	89 d6                	mov    %edx,%esi
  8036e3:	88 d9                	mov    %bl,%cl
  8036e5:	d3 ee                	shr    %cl,%esi
  8036e7:	89 f9                	mov    %edi,%ecx
  8036e9:	d3 e2                	shl    %cl,%edx
  8036eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036ef:	88 d9                	mov    %bl,%cl
  8036f1:	d3 e8                	shr    %cl,%eax
  8036f3:	09 c2                	or     %eax,%edx
  8036f5:	89 d0                	mov    %edx,%eax
  8036f7:	89 f2                	mov    %esi,%edx
  8036f9:	f7 74 24 0c          	divl   0xc(%esp)
  8036fd:	89 d6                	mov    %edx,%esi
  8036ff:	89 c3                	mov    %eax,%ebx
  803701:	f7 e5                	mul    %ebp
  803703:	39 d6                	cmp    %edx,%esi
  803705:	72 19                	jb     803720 <__udivdi3+0xfc>
  803707:	74 0b                	je     803714 <__udivdi3+0xf0>
  803709:	89 d8                	mov    %ebx,%eax
  80370b:	31 ff                	xor    %edi,%edi
  80370d:	e9 58 ff ff ff       	jmp    80366a <__udivdi3+0x46>
  803712:	66 90                	xchg   %ax,%ax
  803714:	8b 54 24 08          	mov    0x8(%esp),%edx
  803718:	89 f9                	mov    %edi,%ecx
  80371a:	d3 e2                	shl    %cl,%edx
  80371c:	39 c2                	cmp    %eax,%edx
  80371e:	73 e9                	jae    803709 <__udivdi3+0xe5>
  803720:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803723:	31 ff                	xor    %edi,%edi
  803725:	e9 40 ff ff ff       	jmp    80366a <__udivdi3+0x46>
  80372a:	66 90                	xchg   %ax,%ax
  80372c:	31 c0                	xor    %eax,%eax
  80372e:	e9 37 ff ff ff       	jmp    80366a <__udivdi3+0x46>
  803733:	90                   	nop

00803734 <__umoddi3>:
  803734:	55                   	push   %ebp
  803735:	57                   	push   %edi
  803736:	56                   	push   %esi
  803737:	53                   	push   %ebx
  803738:	83 ec 1c             	sub    $0x1c,%esp
  80373b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80373f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803743:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803747:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80374b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80374f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803753:	89 f3                	mov    %esi,%ebx
  803755:	89 fa                	mov    %edi,%edx
  803757:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80375b:	89 34 24             	mov    %esi,(%esp)
  80375e:	85 c0                	test   %eax,%eax
  803760:	75 1a                	jne    80377c <__umoddi3+0x48>
  803762:	39 f7                	cmp    %esi,%edi
  803764:	0f 86 a2 00 00 00    	jbe    80380c <__umoddi3+0xd8>
  80376a:	89 c8                	mov    %ecx,%eax
  80376c:	89 f2                	mov    %esi,%edx
  80376e:	f7 f7                	div    %edi
  803770:	89 d0                	mov    %edx,%eax
  803772:	31 d2                	xor    %edx,%edx
  803774:	83 c4 1c             	add    $0x1c,%esp
  803777:	5b                   	pop    %ebx
  803778:	5e                   	pop    %esi
  803779:	5f                   	pop    %edi
  80377a:	5d                   	pop    %ebp
  80377b:	c3                   	ret    
  80377c:	39 f0                	cmp    %esi,%eax
  80377e:	0f 87 ac 00 00 00    	ja     803830 <__umoddi3+0xfc>
  803784:	0f bd e8             	bsr    %eax,%ebp
  803787:	83 f5 1f             	xor    $0x1f,%ebp
  80378a:	0f 84 ac 00 00 00    	je     80383c <__umoddi3+0x108>
  803790:	bf 20 00 00 00       	mov    $0x20,%edi
  803795:	29 ef                	sub    %ebp,%edi
  803797:	89 fe                	mov    %edi,%esi
  803799:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80379d:	89 e9                	mov    %ebp,%ecx
  80379f:	d3 e0                	shl    %cl,%eax
  8037a1:	89 d7                	mov    %edx,%edi
  8037a3:	89 f1                	mov    %esi,%ecx
  8037a5:	d3 ef                	shr    %cl,%edi
  8037a7:	09 c7                	or     %eax,%edi
  8037a9:	89 e9                	mov    %ebp,%ecx
  8037ab:	d3 e2                	shl    %cl,%edx
  8037ad:	89 14 24             	mov    %edx,(%esp)
  8037b0:	89 d8                	mov    %ebx,%eax
  8037b2:	d3 e0                	shl    %cl,%eax
  8037b4:	89 c2                	mov    %eax,%edx
  8037b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037ba:	d3 e0                	shl    %cl,%eax
  8037bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037c4:	89 f1                	mov    %esi,%ecx
  8037c6:	d3 e8                	shr    %cl,%eax
  8037c8:	09 d0                	or     %edx,%eax
  8037ca:	d3 eb                	shr    %cl,%ebx
  8037cc:	89 da                	mov    %ebx,%edx
  8037ce:	f7 f7                	div    %edi
  8037d0:	89 d3                	mov    %edx,%ebx
  8037d2:	f7 24 24             	mull   (%esp)
  8037d5:	89 c6                	mov    %eax,%esi
  8037d7:	89 d1                	mov    %edx,%ecx
  8037d9:	39 d3                	cmp    %edx,%ebx
  8037db:	0f 82 87 00 00 00    	jb     803868 <__umoddi3+0x134>
  8037e1:	0f 84 91 00 00 00    	je     803878 <__umoddi3+0x144>
  8037e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037eb:	29 f2                	sub    %esi,%edx
  8037ed:	19 cb                	sbb    %ecx,%ebx
  8037ef:	89 d8                	mov    %ebx,%eax
  8037f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037f5:	d3 e0                	shl    %cl,%eax
  8037f7:	89 e9                	mov    %ebp,%ecx
  8037f9:	d3 ea                	shr    %cl,%edx
  8037fb:	09 d0                	or     %edx,%eax
  8037fd:	89 e9                	mov    %ebp,%ecx
  8037ff:	d3 eb                	shr    %cl,%ebx
  803801:	89 da                	mov    %ebx,%edx
  803803:	83 c4 1c             	add    $0x1c,%esp
  803806:	5b                   	pop    %ebx
  803807:	5e                   	pop    %esi
  803808:	5f                   	pop    %edi
  803809:	5d                   	pop    %ebp
  80380a:	c3                   	ret    
  80380b:	90                   	nop
  80380c:	89 fd                	mov    %edi,%ebp
  80380e:	85 ff                	test   %edi,%edi
  803810:	75 0b                	jne    80381d <__umoddi3+0xe9>
  803812:	b8 01 00 00 00       	mov    $0x1,%eax
  803817:	31 d2                	xor    %edx,%edx
  803819:	f7 f7                	div    %edi
  80381b:	89 c5                	mov    %eax,%ebp
  80381d:	89 f0                	mov    %esi,%eax
  80381f:	31 d2                	xor    %edx,%edx
  803821:	f7 f5                	div    %ebp
  803823:	89 c8                	mov    %ecx,%eax
  803825:	f7 f5                	div    %ebp
  803827:	89 d0                	mov    %edx,%eax
  803829:	e9 44 ff ff ff       	jmp    803772 <__umoddi3+0x3e>
  80382e:	66 90                	xchg   %ax,%ax
  803830:	89 c8                	mov    %ecx,%eax
  803832:	89 f2                	mov    %esi,%edx
  803834:	83 c4 1c             	add    $0x1c,%esp
  803837:	5b                   	pop    %ebx
  803838:	5e                   	pop    %esi
  803839:	5f                   	pop    %edi
  80383a:	5d                   	pop    %ebp
  80383b:	c3                   	ret    
  80383c:	3b 04 24             	cmp    (%esp),%eax
  80383f:	72 06                	jb     803847 <__umoddi3+0x113>
  803841:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803845:	77 0f                	ja     803856 <__umoddi3+0x122>
  803847:	89 f2                	mov    %esi,%edx
  803849:	29 f9                	sub    %edi,%ecx
  80384b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80384f:	89 14 24             	mov    %edx,(%esp)
  803852:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803856:	8b 44 24 04          	mov    0x4(%esp),%eax
  80385a:	8b 14 24             	mov    (%esp),%edx
  80385d:	83 c4 1c             	add    $0x1c,%esp
  803860:	5b                   	pop    %ebx
  803861:	5e                   	pop    %esi
  803862:	5f                   	pop    %edi
  803863:	5d                   	pop    %ebp
  803864:	c3                   	ret    
  803865:	8d 76 00             	lea    0x0(%esi),%esi
  803868:	2b 04 24             	sub    (%esp),%eax
  80386b:	19 fa                	sbb    %edi,%edx
  80386d:	89 d1                	mov    %edx,%ecx
  80386f:	89 c6                	mov    %eax,%esi
  803871:	e9 71 ff ff ff       	jmp    8037e7 <__umoddi3+0xb3>
  803876:	66 90                	xchg   %ax,%ax
  803878:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80387c:	72 ea                	jb     803868 <__umoddi3+0x134>
  80387e:	89 d9                	mov    %ebx,%ecx
  803880:	e9 62 ff ff ff       	jmp    8037e7 <__umoddi3+0xb3>
