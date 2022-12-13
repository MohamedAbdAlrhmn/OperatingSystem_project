
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 15 0b 00 00       	call   800b4b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 01 00 00    	sub    $0x1fc,%esp
	int envID = sys_getenvid();
  800044:	e8 ee 23 00 00       	call   802437 <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  80007c:	bb 36 43 80 00       	mov    $0x804336,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb 40 43 80 00       	mov    $0x804340,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb 4c 43 80 00       	mov    $0x80434c,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb 5b 43 80 00       	mov    $0x80435b,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb 6a 43 80 00       	mov    $0x80436a,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb 7f 43 80 00       	mov    $0x80437f,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb 94 43 80 00       	mov    $0x804394,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb a5 43 80 00       	mov    $0x8043a5,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb b6 43 80 00       	mov    $0x8043b6,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb c7 43 80 00       	mov    $0x8043c7,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb d0 43 80 00       	mov    $0x8043d0,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb da 43 80 00       	mov    $0x8043da,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb e5 43 80 00       	mov    $0x8043e5,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb f1 43 80 00       	mov    $0x8043f1,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb fb 43 80 00       	mov    $0x8043fb,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9f fe ff ff 63 	movl   $0x72656c63,-0x161(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 a3 fe ff ff 	movw   $0x6b,-0x15d(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8001f7:	bb 05 44 80 00       	mov    $0x804405,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb 13 44 80 00       	mov    $0x804413,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 22 44 80 00       	mov    $0x804422,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 29 44 80 00       	mov    $0x804429,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 a2 1c 00 00       	call   801f0b <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 c4 1b 00 00       	call   801f0b <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 a2 1b 00 00       	call   801f0b <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 81 1b 00 00       	call   801f0b <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 60 1b 00 00       	call   801f0b <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 3e 1b 00 00       	call   801f0b <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 17 1b 00 00       	call   801f0b <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 f9 1a 00 00       	call   801f0b <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 db 1a 00 00       	call   801f0b <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 c2 1a 00 00       	call   801f0b <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 9a 1a 00 00       	call   801f0b <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	sys_createSemaphore(_flight1CS, 1);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	6a 01                	push   $0x1
  80048b:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  800491:	50                   	push   %eax
  800492:	e8 3a 1e 00 00       	call   8022d1 <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 26 1e 00 00       	call   8022d1 <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 12 1e 00 00       	call   8022d1 <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 fe 1d 00 00       	call   8022d1 <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 ea 1d 00 00       	call   8022d1 <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 d6 1d 00 00       	call   8022d1 <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 c2 1d 00 00       	call   8022d1 <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 30 44 80 00       	mov    $0x804430,%ebx
  80052d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800532:	89 c7                	mov    %eax,%edi
  800534:	89 de                	mov    %ebx,%esi
  800536:	89 d1                	mov    %edx,%ecx
  800538:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80053a:	8d 95 64 fe ff ff    	lea    -0x19c(%ebp),%edx
  800540:	b9 04 00 00 00       	mov    $0x4,%ecx
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800557:	50                   	push   %eax
  800558:	ff 75 d8             	pushl  -0x28(%ebp)
  80055b:	e8 03 15 00 00       	call   801a63 <ltostr>
  800560:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 db 15 00 00       	call   801b5b <strcconcat>
  800580:	83 c4 10             	add    $0x10,%esp
		sys_createSemaphore(sname, 0);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	6a 00                	push   $0x0
  800588:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	e8 3d 1d 00 00       	call   8022d1 <sys_createSemaphore>
  800594:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_cust_ready, 0);

	sys_createSemaphore(_custTerminated, 0);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  800597:	ff 45 d8             	incl   -0x28(%ebp)
  80059a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80059d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8005a0:	7c 80                	jl     800522 <_main+0x4ea>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8005a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bf:	8b 40 74             	mov    0x74(%eax),%eax
  8005c2:	52                   	push   %edx
  8005c3:	51                   	push   %ecx
  8005c4:	50                   	push   %eax
  8005c5:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	e8 11 1e 00 00       	call   8023e2 <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 17 1e 00 00       	call   802400 <sys_run_env>
  8005e9:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8005ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fc:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800602:	89 c1                	mov    %eax,%ecx
  800604:	a1 20 50 80 00       	mov    0x805020,%eax
  800609:	8b 40 74             	mov    0x74(%eax),%eax
  80060c:	52                   	push   %edx
  80060d:	51                   	push   %ecx
  80060e:	50                   	push   %eax
  80060f:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 c7 1d 00 00       	call   8023e2 <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 cd 1d 00 00       	call   802400 <sys_run_env>
  800633:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	a1 20 50 80 00       	mov    0x805020,%eax
  800653:	8b 40 74             	mov    0x74(%eax),%eax
  800656:	52                   	push   %edx
  800657:	51                   	push   %ecx
  800658:	50                   	push   %eax
  800659:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	e8 7d 1d 00 00       	call   8023e2 <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 83 1d 00 00       	call   802400 <sys_run_env>
  80067d:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800680:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800687:	eb 6d                	jmp    8006f6 <_main+0x6be>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800689:	a1 20 50 80 00       	mov    0x805020,%eax
  80068e:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800694:	a1 20 50 80 00       	mov    0x805020,%eax
  800699:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a6:	8b 40 74             	mov    0x74(%eax),%eax
  8006a9:	52                   	push   %edx
  8006aa:	51                   	push   %ecx
  8006ab:	50                   	push   %eax
  8006ac:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 2a 1d 00 00       	call   8023e2 <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 60 40 80 00       	push   $0x804060
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 a6 40 80 00       	push   $0x8040a6
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 10 1d 00 00       	call   802400 <sys_run_env>
  8006f0:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  8006f3:	ff 45 d4             	incl   -0x2c(%ebp)
  8006f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8006fc:	7c 8b                	jl     800689 <_main+0x651>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8006fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800705:	eb 18                	jmp    80071f <_main+0x6e7>
	{
		sys_waitSemaphore(envID, _custTerminated);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	ff 75 bc             	pushl  -0x44(%ebp)
  800714:	e8 f1 1b 00 00       	call   80230a <sys_waitSemaphore>
  800719:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80071c:	ff 45 d4             	incl   -0x2c(%ebp)
  80071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800722:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800725:	7c e0                	jl     800707 <_main+0x6cf>
	{
		sys_waitSemaphore(envID, _custTerminated);
	}

	env_sleep(1500);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	68 dc 05 00 00       	push   $0x5dc
  80072f:	e8 fe 35 00 00       	call   803d32 <env_sleep>
  800734:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800737:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80073e:	eb 45                	jmp    800785 <_main+0x74d>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  800740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800758:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80075b:	01 d0                	add    %edx,%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800762:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800769:	8b 45 88             	mov    -0x78(%ebp),%eax
  80076c:	01 c8                	add    %ecx,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 ec 04             	sub    $0x4,%esp
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	68 b8 40 80 00       	push   $0x8040b8
  80077a:	e8 bc 07 00 00       	call   800f3b <cprintf>
  80077f:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800782:	ff 45 d0             	incl   -0x30(%ebp)
  800785:	8b 45 90             	mov    -0x70(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80078d:	7f b1                	jg     800740 <_main+0x708>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80078f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800796:	eb 45                	jmp    8007dd <_main+0x7a5>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c4:	01 c8                	add    %ecx,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	68 e8 40 80 00       	push   $0x8040e8
  8007d2:	e8 64 07 00 00       	call   800f3b <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  8007da:	ff 45 d0             	incl   -0x30(%ebp)
  8007dd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007e5:	7f b1                	jg     800798 <_main+0x760>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  8007e7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  8007ee:	eb 33                	jmp    800823 <_main+0x7eb>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8007f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8007f9:	ff 75 88             	pushl  -0x78(%ebp)
  8007fc:	e8 05 03 00 00       	call   800b06 <find>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	83 f8 01             	cmp    $0x1,%eax
  800807:	74 17                	je     800820 <_main+0x7e8>
			{
				panic("Error, wrong booking for user %d\n", f1);
  800809:	ff 75 cc             	pushl  -0x34(%ebp)
  80080c:	68 18 41 80 00       	push   $0x804118
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 a6 40 80 00       	push   $0x8040a6
  80081b:	e8 67 04 00 00       	call   800c87 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  800820:	ff 45 cc             	incl   -0x34(%ebp)
  800823:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800826:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800829:	7c c5                	jl     8007f0 <_main+0x7b8>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  80082b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  800831:	eb 33                	jmp    800866 <_main+0x82e>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	ff 75 c8             	pushl  -0x38(%ebp)
  800839:	ff 75 a4             	pushl  -0x5c(%ebp)
  80083c:	ff 75 84             	pushl  -0x7c(%ebp)
  80083f:	e8 c2 02 00 00       	call   800b06 <find>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	83 f8 01             	cmp    $0x1,%eax
  80084a:	74 17                	je     800863 <_main+0x82b>
			{
				panic("Error, wrong booking for user %d\n", f2);
  80084c:	ff 75 c8             	pushl  -0x38(%ebp)
  80084f:	68 18 41 80 00       	push   $0x804118
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 a6 40 80 00       	push   $0x8040a6
  80085e:	e8 24 04 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  800863:	ff 45 c8             	incl   -0x38(%ebp)
  800866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800869:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800871:	7f c0                	jg     800833 <_main+0x7fb>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  800873:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800876:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  800879:	eb 4c                	jmp    8008c7 <_main+0x88f>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800881:	ff 75 a8             	pushl  -0x58(%ebp)
  800884:	ff 75 88             	pushl  -0x78(%ebp)
  800887:	e8 7a 02 00 00       	call   800b06 <find>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 f8 01             	cmp    $0x1,%eax
  800892:	75 19                	jne    8008ad <_main+0x875>
  800894:	83 ec 04             	sub    $0x4,%esp
  800897:	ff 75 c4             	pushl  -0x3c(%ebp)
  80089a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80089d:	ff 75 84             	pushl  -0x7c(%ebp)
  8008a0:	e8 61 02 00 00       	call   800b06 <find>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	83 f8 01             	cmp    $0x1,%eax
  8008ab:	74 17                	je     8008c4 <_main+0x88c>
			{
				panic("Error, wrong booking for user %d\n", f3);
  8008ad:	ff 75 c4             	pushl  -0x3c(%ebp)
  8008b0:	68 18 41 80 00       	push   $0x804118
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 a6 40 80 00       	push   $0x8040a6
  8008bf:	e8 c3 03 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  8008c4:	ff 45 c4             	incl   -0x3c(%ebp)
  8008c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8008ca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8008cd:	01 d0                	add    %edx,%eax
  8008cf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8008d2:	7f a7                	jg     80087b <_main+0x843>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(sys_getSemaphoreValue(envID, _flight1CS) == 1);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	ff 75 bc             	pushl  -0x44(%ebp)
  8008e1:	e8 07 1a 00 00       	call   8022ed <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 3c 41 80 00       	push   $0x80413c
  8008f3:	68 6a 41 80 00       	push   $0x80416a
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 a6 40 80 00       	push   $0x8040a6
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 d4 19 00 00       	call   8022ed <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 80 41 80 00       	push   $0x804180
  800926:	68 6a 41 80 00       	push   $0x80416a
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 a6 40 80 00       	push   $0x8040a6
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 a1 19 00 00       	call   8022ed <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 b0 41 80 00       	push   $0x8041b0
  800959:	68 6a 41 80 00       	push   $0x80416a
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 a6 40 80 00       	push   $0x8040a6
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 6e 19 00 00       	call   8022ed <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 e4 41 80 00       	push   $0x8041e4
  80098c:	68 6a 41 80 00       	push   $0x80416a
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 a6 40 80 00       	push   $0x8040a6
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 3b 19 00 00       	call   8022ed <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 14 42 80 00       	push   $0x804214
  8009bf:	68 6a 41 80 00       	push   $0x80416a
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 a6 40 80 00       	push   $0x8040a6
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 08 19 00 00       	call   8022ed <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 40 42 80 00       	push   $0x804240
  8009f2:	68 6a 41 80 00       	push   $0x80416a
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 a6 40 80 00       	push   $0x8040a6
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 d5 18 00 00       	call   8022ed <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 70 42 80 00       	push   $0x804270
  800a24:	68 6a 41 80 00       	push   $0x80416a
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 a6 40 80 00       	push   $0x8040a6
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 30 44 80 00       	mov    $0x804430,%ebx
  800a56:	ba 0e 00 00 00       	mov    $0xe,%edx
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	89 de                	mov    %ebx,%esi
  800a5f:	89 d1                	mov    %edx,%ecx
  800a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800a63:	8d 95 41 fe ff ff    	lea    -0x1bf(%ebp),%edx
  800a69:	b9 04 00 00 00       	mov    $0x4,%ecx
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	89 d7                	mov    %edx,%edi
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
			char id[5]; char cust_finishedSemaphoreName[50];
			ltostr(s, id);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	ff 75 c0             	pushl  -0x40(%ebp)
  800a84:	e8 da 0f 00 00       	call   801a63 <ltostr>
  800a89:	83 c4 10             	add    $0x10,%esp
			strcconcat(prefix, id, cust_finishedSemaphoreName);
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 b2 10 00 00       	call   801b5b <strcconcat>
  800aa9:	83 c4 10             	add    $0x10,%esp
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 bc             	pushl  -0x44(%ebp)
  800ab9:	e8 2f 18 00 00       	call   8022ed <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 a4 42 80 00       	push   $0x8042a4
  800aca:	68 6a 41 80 00       	push   $0x80416a
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 a6 40 80 00       	push   $0x8040a6
  800ad9:	e8 a9 01 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ade:	ff 45 c0             	incl   -0x40(%ebp)
  800ae1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ae4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800ae7:	0f 8c 5e ff ff ff    	jl     800a4b <_main+0xa13>
			ltostr(s, id);
			strcconcat(prefix, id, cust_finishedSemaphoreName);
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	68 e4 42 80 00       	push   $0x8042e4
  800af5:	e8 41 04 00 00       	call   800f3b <cprintf>
  800afa:	83 c4 10             	add    $0x10,%esp
	}

}
  800afd:	90                   	nop
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <find>:


int find(int* arr, int size, int val)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b1a:	eb 22                	jmp    800b3e <find+0x38>
	{
		if(arr[i] == val)
  800b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b30:	75 09                	jne    800b3b <find+0x35>
		{
			result = 1;
  800b32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b39:	eb 0b                	jmp    800b46 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b3b:	ff 45 f8             	incl   -0x8(%ebp)
  800b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b44:	7c d6                	jl     800b1c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b51:	e8 fa 18 00 00       	call   802450 <sys_getenvindex>
  800b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5c:	89 d0                	mov    %edx,%eax
  800b5e:	c1 e0 03             	shl    $0x3,%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	01 c0                	add    %eax,%eax
  800b65:	01 d0                	add    %edx,%eax
  800b67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	c1 e0 04             	shl    $0x4,%eax
  800b73:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b78:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b82:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b88:	84 c0                	test   %al,%al
  800b8a:	74 0f                	je     800b9b <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b8c:	a1 20 50 80 00       	mov    0x805020,%eax
  800b91:	05 5c 05 00 00       	add    $0x55c,%eax
  800b96:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	7e 0a                	jle    800bab <libmain+0x60>
		binaryname = argv[0];
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	ff 75 08             	pushl  0x8(%ebp)
  800bb4:	e8 7f f4 ff ff       	call   800038 <_main>
  800bb9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bbc:	e8 9c 16 00 00       	call   80225d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 68 44 80 00       	push   $0x804468
  800bc9:	e8 6d 03 00 00       	call   800f3b <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bd1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bdc:	a1 20 50 80 00       	mov    0x805020,%eax
  800be1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	68 90 44 80 00       	push   $0x804490
  800bf1:	e8 45 03 00 00       	call   800f3b <cprintf>
  800bf6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c04:	a1 20 50 80 00       	mov    0x805020,%eax
  800c09:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c0f:	a1 20 50 80 00       	mov    0x805020,%eax
  800c14:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c1a:	51                   	push   %ecx
  800c1b:	52                   	push   %edx
  800c1c:	50                   	push   %eax
  800c1d:	68 b8 44 80 00       	push   $0x8044b8
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 10 45 80 00       	push   $0x804510
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 68 44 80 00       	push   $0x804468
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 1c 16 00 00       	call   802277 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c5b:	e8 19 00 00 00       	call   800c79 <exit>
}
  800c60:	90                   	nop
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	6a 00                	push   $0x0
  800c6e:	e8 a9 17 00 00       	call   80241c <sys_destroy_env>
  800c73:	83 c4 10             	add    $0x10,%esp
}
  800c76:	90                   	nop
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <exit>:

void
exit(void)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c7f:	e8 fe 17 00 00       	call   802482 <sys_exit_env>
}
  800c84:	90                   	nop
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c8d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c90:	83 c0 04             	add    $0x4,%eax
  800c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c96:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	74 16                	je     800cb5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c9f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	50                   	push   %eax
  800ca8:	68 24 45 80 00       	push   $0x804524
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 29 45 80 00       	push   $0x804529
  800cc6:	e8 70 02 00 00       	call   800f3b <cprintf>
  800ccb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cce:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	e8 f3 01 00 00       	call   800ed0 <vcprintf>
  800cdd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	6a 00                	push   $0x0
  800ce5:	68 45 45 80 00       	push   $0x804545
  800cea:	e8 e1 01 00 00       	call   800ed0 <vcprintf>
  800cef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cf2:	e8 82 ff ff ff       	call   800c79 <exit>

	// should not return here
	while (1) ;
  800cf7:	eb fe                	jmp    800cf7 <_panic+0x70>

00800cf9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cff:	a1 20 50 80 00       	mov    0x805020,%eax
  800d04:	8b 50 74             	mov    0x74(%eax),%edx
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	39 c2                	cmp    %eax,%edx
  800d0c:	74 14                	je     800d22 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d0e:	83 ec 04             	sub    $0x4,%esp
  800d11:	68 48 45 80 00       	push   $0x804548
  800d16:	6a 26                	push   $0x26
  800d18:	68 94 45 80 00       	push   $0x804594
  800d1d:	e8 65 ff ff ff       	call   800c87 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d30:	e9 c2 00 00 00       	jmp    800df7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	01 d0                	add    %edx,%eax
  800d44:	8b 00                	mov    (%eax),%eax
  800d46:	85 c0                	test   %eax,%eax
  800d48:	75 08                	jne    800d52 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d4a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d4d:	e9 a2 00 00 00       	jmp    800df4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d52:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d59:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d60:	eb 69                	jmp    800dcb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d62:	a1 20 50 80 00       	mov    0x805020,%eax
  800d67:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d70:	89 d0                	mov    %edx,%eax
  800d72:	01 c0                	add    %eax,%eax
  800d74:	01 d0                	add    %edx,%eax
  800d76:	c1 e0 03             	shl    $0x3,%eax
  800d79:	01 c8                	add    %ecx,%eax
  800d7b:	8a 40 04             	mov    0x4(%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 46                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d82:	a1 20 50 80 00       	mov    0x805020,%eax
  800d87:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d90:	89 d0                	mov    %edx,%eax
  800d92:	01 c0                	add    %eax,%eax
  800d94:	01 d0                	add    %edx,%eax
  800d96:	c1 e0 03             	shl    $0x3,%eax
  800d99:	01 c8                	add    %ecx,%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	01 c8                	add    %ecx,%eax
  800db9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	75 09                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800dbf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dc6:	eb 12                	jmp    800dda <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc8:	ff 45 e8             	incl   -0x18(%ebp)
  800dcb:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd0:	8b 50 74             	mov    0x74(%eax),%edx
  800dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	77 88                	ja     800d62 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dde:	75 14                	jne    800df4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	68 a0 45 80 00       	push   $0x8045a0
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 94 45 80 00       	push   $0x804594
  800def:	e8 93 fe ff ff       	call   800c87 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800df4:	ff 45 f0             	incl   -0x10(%ebp)
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dfd:	0f 8c 32 ff ff ff    	jl     800d35 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e03:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e11:	eb 26                	jmp    800e39 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e13:	a1 20 50 80 00       	mov    0x805020,%eax
  800e18:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e21:	89 d0                	mov    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	c1 e0 03             	shl    $0x3,%eax
  800e2a:	01 c8                	add    %ecx,%eax
  800e2c:	8a 40 04             	mov    0x4(%eax),%al
  800e2f:	3c 01                	cmp    $0x1,%al
  800e31:	75 03                	jne    800e36 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e33:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e36:	ff 45 e0             	incl   -0x20(%ebp)
  800e39:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3e:	8b 50 74             	mov    0x74(%eax),%edx
  800e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e44:	39 c2                	cmp    %eax,%edx
  800e46:	77 cb                	ja     800e13 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e4e:	74 14                	je     800e64 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e50:	83 ec 04             	sub    $0x4,%esp
  800e53:	68 f4 45 80 00       	push   $0x8045f4
  800e58:	6a 44                	push   $0x44
  800e5a:	68 94 45 80 00       	push   $0x804594
  800e5f:	e8 23 fe ff ff       	call   800c87 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e64:	90                   	nop
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	8d 48 01             	lea    0x1(%eax),%ecx
  800e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e78:	89 0a                	mov    %ecx,(%edx)
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	88 d1                	mov    %dl,%cl
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e90:	75 2c                	jne    800ebe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e92:	a0 24 50 80 00       	mov    0x805024,%al
  800e97:	0f b6 c0             	movzbl %al,%eax
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8b 12                	mov    (%edx),%edx
  800e9f:	89 d1                	mov    %edx,%ecx
  800ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea4:	83 c2 08             	add    $0x8,%edx
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	50                   	push   %eax
  800eab:	51                   	push   %ecx
  800eac:	52                   	push   %edx
  800ead:	e8 fd 11 00 00       	call   8020af <sys_cputs>
  800eb2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8b 40 04             	mov    0x4(%eax),%eax
  800ec4:	8d 50 01             	lea    0x1(%eax),%edx
  800ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eca:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ecd:	90                   	nop
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ed9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ee0:	00 00 00 
	b.cnt = 0;
  800ee3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800eea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	ff 75 08             	pushl  0x8(%ebp)
  800ef3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	68 67 0e 80 00       	push   $0x800e67
  800eff:	e8 11 02 00 00       	call   801115 <vprintfmt>
  800f04:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f07:	a0 24 50 80 00       	mov    0x805024,%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f15:	83 ec 04             	sub    $0x4,%esp
  800f18:	50                   	push   %eax
  800f19:	52                   	push   %edx
  800f1a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f20:	83 c0 08             	add    $0x8,%eax
  800f23:	50                   	push   %eax
  800f24:	e8 86 11 00 00       	call   8020af <sys_cputs>
  800f29:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f2c:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f33:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <cprintf>:

int cprintf(const char *fmt, ...) {
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f41:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f48:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 f4             	pushl  -0xc(%ebp)
  800f57:	50                   	push   %eax
  800f58:	e8 73 ff ff ff       	call   800ed0 <vcprintf>
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f6e:	e8 ea 12 00 00       	call   80225d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f73:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f82:	50                   	push   %eax
  800f83:	e8 48 ff ff ff       	call   800ed0 <vcprintf>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f8e:	e8 e4 12 00 00       	call   802277 <sys_enable_interrupt>
	return cnt;
  800f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 14             	sub    $0x14,%esp
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fab:	8b 45 18             	mov    0x18(%ebp),%eax
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb6:	77 55                	ja     80100d <printnum+0x75>
  800fb8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fbb:	72 05                	jb     800fc2 <printnum+0x2a>
  800fbd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fc0:	77 4b                	ja     80100d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fc2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fc8:	8b 45 18             	mov    0x18(%ebp),%eax
  800fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd0:	52                   	push   %edx
  800fd1:	50                   	push   %eax
  800fd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fd8:	e8 0b 2e 00 00       	call   803de8 <__udivdi3>
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	ff 75 20             	pushl  0x20(%ebp)
  800fe6:	53                   	push   %ebx
  800fe7:	ff 75 18             	pushl  0x18(%ebp)
  800fea:	52                   	push   %edx
  800feb:	50                   	push   %eax
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	e8 a1 ff ff ff       	call   800f98 <printnum>
  800ff7:	83 c4 20             	add    $0x20,%esp
  800ffa:	eb 1a                	jmp    801016 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 20             	pushl  0x20(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80100d:	ff 4d 1c             	decl   0x1c(%ebp)
  801010:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801014:	7f e6                	jg     800ffc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801016:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801024:	53                   	push   %ebx
  801025:	51                   	push   %ecx
  801026:	52                   	push   %edx
  801027:	50                   	push   %eax
  801028:	e8 cb 2e 00 00       	call   803ef8 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 54 48 80 00       	add    $0x804854,%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f be c0             	movsbl %al,%eax
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	50                   	push   %eax
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	ff d0                	call   *%eax
  801046:	83 c4 10             	add    $0x10,%esp
}
  801049:	90                   	nop
  80104a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801052:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801056:	7e 1c                	jle    801074 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8b 00                	mov    (%eax),%eax
  80105d:	8d 50 08             	lea    0x8(%eax),%edx
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 10                	mov    %edx,(%eax)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8b 00                	mov    (%eax),%eax
  80106a:	83 e8 08             	sub    $0x8,%eax
  80106d:	8b 50 04             	mov    0x4(%eax),%edx
  801070:	8b 00                	mov    (%eax),%eax
  801072:	eb 40                	jmp    8010b4 <getuint+0x65>
	else if (lflag)
  801074:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801078:	74 1e                	je     801098 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8b 00                	mov    (%eax),%eax
  80107f:	8d 50 04             	lea    0x4(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	89 10                	mov    %edx,(%eax)
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8b 00                	mov    (%eax),%eax
  80108c:	83 e8 04             	sub    $0x4,%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	ba 00 00 00 00       	mov    $0x0,%edx
  801096:	eb 1c                	jmp    8010b4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8b 00                	mov    (%eax),%eax
  80109d:	8d 50 04             	lea    0x4(%eax),%edx
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 10                	mov    %edx,(%eax)
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	83 e8 04             	sub    $0x4,%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010bd:	7e 1c                	jle    8010db <getint+0x25>
		return va_arg(*ap, long long);
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8b 00                	mov    (%eax),%eax
  8010c4:	8d 50 08             	lea    0x8(%eax),%edx
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	89 10                	mov    %edx,(%eax)
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	83 e8 08             	sub    $0x8,%eax
  8010d4:	8b 50 04             	mov    0x4(%eax),%edx
  8010d7:	8b 00                	mov    (%eax),%eax
  8010d9:	eb 38                	jmp    801113 <getint+0x5d>
	else if (lflag)
  8010db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010df:	74 1a                	je     8010fb <getint+0x45>
		return va_arg(*ap, long);
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8b 00                	mov    (%eax),%eax
  8010e6:	8d 50 04             	lea    0x4(%eax),%edx
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	89 10                	mov    %edx,(%eax)
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8b 00                	mov    (%eax),%eax
  8010f3:	83 e8 04             	sub    $0x4,%eax
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	99                   	cltd   
  8010f9:	eb 18                	jmp    801113 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8b 00                	mov    (%eax),%eax
  801100:	8d 50 04             	lea    0x4(%eax),%edx
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	89 10                	mov    %edx,(%eax)
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8b 00                	mov    (%eax),%eax
  80110d:	83 e8 04             	sub    $0x4,%eax
  801110:	8b 00                	mov    (%eax),%eax
  801112:	99                   	cltd   
}
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80111d:	eb 17                	jmp    801136 <vprintfmt+0x21>
			if (ch == '\0')
  80111f:	85 db                	test   %ebx,%ebx
  801121:	0f 84 af 03 00 00    	je     8014d6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	53                   	push   %ebx
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	ff d0                	call   *%eax
  801133:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 10             	mov    %edx,0x10(%ebp)
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f b6 d8             	movzbl %al,%ebx
  801144:	83 fb 25             	cmp    $0x25,%ebx
  801147:	75 d6                	jne    80111f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801149:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80114d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801154:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80115b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801162:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	8d 50 01             	lea    0x1(%eax),%edx
  80116f:	89 55 10             	mov    %edx,0x10(%ebp)
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 d8             	movzbl %al,%ebx
  801177:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80117a:	83 f8 55             	cmp    $0x55,%eax
  80117d:	0f 87 2b 03 00 00    	ja     8014ae <vprintfmt+0x399>
  801183:	8b 04 85 78 48 80 00 	mov    0x804878(,%eax,4),%eax
  80118a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80118c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801190:	eb d7                	jmp    801169 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801192:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801196:	eb d1                	jmp    801169 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801198:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80119f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	c1 e0 02             	shl    $0x2,%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	01 c0                	add    %eax,%eax
  8011ab:	01 d8                	add    %ebx,%eax
  8011ad:	83 e8 30             	sub    $0x30,%eax
  8011b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8011be:	7e 3e                	jle    8011fe <vprintfmt+0xe9>
  8011c0:	83 fb 39             	cmp    $0x39,%ebx
  8011c3:	7f 39                	jg     8011fe <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011c5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011c8:	eb d5                	jmp    80119f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	83 c0 04             	add    $0x4,%eax
  8011d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d6:	83 e8 04             	sub    $0x4,%eax
  8011d9:	8b 00                	mov    (%eax),%eax
  8011db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011de:	eb 1f                	jmp    8011ff <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e4:	79 83                	jns    801169 <vprintfmt+0x54>
				width = 0;
  8011e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011ed:	e9 77 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011f2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011f9:	e9 6b ff ff ff       	jmp    801169 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011fe:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801203:	0f 89 60 ff ff ff    	jns    801169 <vprintfmt+0x54>
				width = precision, precision = -1;
  801209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80120c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80120f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801216:	e9 4e ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80121b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80121e:	e9 46 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	83 c0 04             	add    $0x4,%eax
  801229:	89 45 14             	mov    %eax,0x14(%ebp)
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	83 e8 04             	sub    $0x4,%eax
  801232:	8b 00                	mov    (%eax),%eax
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	50                   	push   %eax
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	ff d0                	call   *%eax
  801240:	83 c4 10             	add    $0x10,%esp
			break;
  801243:	e9 89 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	83 c0 04             	add    $0x4,%eax
  80124e:	89 45 14             	mov    %eax,0x14(%ebp)
  801251:	8b 45 14             	mov    0x14(%ebp),%eax
  801254:	83 e8 04             	sub    $0x4,%eax
  801257:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801259:	85 db                	test   %ebx,%ebx
  80125b:	79 02                	jns    80125f <vprintfmt+0x14a>
				err = -err;
  80125d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80125f:	83 fb 64             	cmp    $0x64,%ebx
  801262:	7f 0b                	jg     80126f <vprintfmt+0x15a>
  801264:	8b 34 9d c0 46 80 00 	mov    0x8046c0(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 65 48 80 00       	push   $0x804865
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	e8 5e 02 00 00       	call   8014de <printfmt>
  801280:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801283:	e9 49 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801288:	56                   	push   %esi
  801289:	68 6e 48 80 00       	push   $0x80486e
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	ff 75 08             	pushl  0x8(%ebp)
  801294:	e8 45 02 00 00       	call   8014de <printfmt>
  801299:	83 c4 10             	add    $0x10,%esp
			break;
  80129c:	e9 30 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	83 c0 04             	add    $0x4,%eax
  8012a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	83 e8 04             	sub    $0x4,%eax
  8012b0:	8b 30                	mov    (%eax),%esi
  8012b2:	85 f6                	test   %esi,%esi
  8012b4:	75 05                	jne    8012bb <vprintfmt+0x1a6>
				p = "(null)";
  8012b6:	be 71 48 80 00       	mov    $0x804871,%esi
			if (width > 0 && padc != '-')
  8012bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012bf:	7e 6d                	jle    80132e <vprintfmt+0x219>
  8012c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012c5:	74 67                	je     80132e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	50                   	push   %eax
  8012ce:	56                   	push   %esi
  8012cf:	e8 0c 03 00 00       	call   8015e0 <strnlen>
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012da:	eb 16                	jmp    8012f2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012dc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	50                   	push   %eax
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	ff d0                	call   *%eax
  8012ec:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8012f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012f6:	7f e4                	jg     8012dc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012f8:	eb 34                	jmp    80132e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012fe:	74 1c                	je     80131c <vprintfmt+0x207>
  801300:	83 fb 1f             	cmp    $0x1f,%ebx
  801303:	7e 05                	jle    80130a <vprintfmt+0x1f5>
  801305:	83 fb 7e             	cmp    $0x7e,%ebx
  801308:	7e 12                	jle    80131c <vprintfmt+0x207>
					putch('?', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 3f                	push   $0x3f
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	eb 0f                	jmp    80132b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 0c             	pushl  0xc(%ebp)
  801322:	53                   	push   %ebx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	ff d0                	call   *%eax
  801328:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80132b:	ff 4d e4             	decl   -0x1c(%ebp)
  80132e:	89 f0                	mov    %esi,%eax
  801330:	8d 70 01             	lea    0x1(%eax),%esi
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be d8             	movsbl %al,%ebx
  801338:	85 db                	test   %ebx,%ebx
  80133a:	74 24                	je     801360 <vprintfmt+0x24b>
  80133c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801340:	78 b8                	js     8012fa <vprintfmt+0x1e5>
  801342:	ff 4d e0             	decl   -0x20(%ebp)
  801345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801349:	79 af                	jns    8012fa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80134b:	eb 13                	jmp    801360 <vprintfmt+0x24b>
				putch(' ', putdat);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	6a 20                	push   $0x20
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	ff d0                	call   *%eax
  80135a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80135d:	ff 4d e4             	decl   -0x1c(%ebp)
  801360:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801364:	7f e7                	jg     80134d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801366:	e9 66 01 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	ff 75 e8             	pushl  -0x18(%ebp)
  801371:	8d 45 14             	lea    0x14(%ebp),%eax
  801374:	50                   	push   %eax
  801375:	e8 3c fd ff ff       	call   8010b6 <getint>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801380:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801389:	85 d2                	test   %edx,%edx
  80138b:	79 23                	jns    8013b0 <vprintfmt+0x29b>
				putch('-', putdat);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	6a 2d                	push   $0x2d
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	ff d0                	call   *%eax
  80139a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a3:	f7 d8                	neg    %eax
  8013a5:	83 d2 00             	adc    $0x0,%edx
  8013a8:	f7 da                	neg    %edx
  8013aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013b0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013b7:	e9 bc 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	e8 84 fc ff ff       	call   80104f <getuint>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013db:	e9 98 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	6a 58                	push   $0x58
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	ff d0                	call   *%eax
  8013ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	6a 58                	push   $0x58
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	ff d0                	call   *%eax
  8013fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	6a 58                	push   $0x58
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	ff d0                	call   *%eax
  80140d:	83 c4 10             	add    $0x10,%esp
			break;
  801410:	e9 bc 00 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	6a 30                	push   $0x30
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	ff d0                	call   *%eax
  801422:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	6a 78                	push   $0x78
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	ff d0                	call   *%eax
  801432:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	83 c0 04             	add    $0x4,%eax
  80143b:	89 45 14             	mov    %eax,0x14(%ebp)
  80143e:	8b 45 14             	mov    0x14(%ebp),%eax
  801441:	83 e8 04             	sub    $0x4,%eax
  801444:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801450:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801457:	eb 1f                	jmp    801478 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	ff 75 e8             	pushl  -0x18(%ebp)
  80145f:	8d 45 14             	lea    0x14(%ebp),%eax
  801462:	50                   	push   %eax
  801463:	e8 e7 fb ff ff       	call   80104f <getuint>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801471:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801478:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	52                   	push   %edx
  801483:	ff 75 e4             	pushl  -0x1c(%ebp)
  801486:	50                   	push   %eax
  801487:	ff 75 f4             	pushl  -0xc(%ebp)
  80148a:	ff 75 f0             	pushl  -0x10(%ebp)
  80148d:	ff 75 0c             	pushl  0xc(%ebp)
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	e8 00 fb ff ff       	call   800f98 <printnum>
  801498:	83 c4 20             	add    $0x20,%esp
			break;
  80149b:	eb 34                	jmp    8014d1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	53                   	push   %ebx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	ff d0                	call   *%eax
  8014a9:	83 c4 10             	add    $0x10,%esp
			break;
  8014ac:	eb 23                	jmp    8014d1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	6a 25                	push   $0x25
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	ff d0                	call   *%eax
  8014bb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014be:	ff 4d 10             	decl   0x10(%ebp)
  8014c1:	eb 03                	jmp    8014c6 <vprintfmt+0x3b1>
  8014c3:	ff 4d 10             	decl   0x10(%ebp)
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	48                   	dec    %eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	3c 25                	cmp    $0x25,%al
  8014ce:	75 f3                	jne    8014c3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014d0:	90                   	nop
		}
	}
  8014d1:	e9 47 fc ff ff       	jmp    80111d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014d6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8014e7:	83 c0 04             	add    $0x4,%eax
  8014ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 16 fc ff ff       	call   801115 <vprintfmt>
  8014ff:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	8b 40 08             	mov    0x8(%eax),%eax
  80150e:	8d 50 01             	lea    0x1(%eax),%edx
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	8b 10                	mov    (%eax),%edx
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	8b 40 04             	mov    0x4(%eax),%eax
  801522:	39 c2                	cmp    %eax,%edx
  801524:	73 12                	jae    801538 <sprintputch+0x33>
		*b->buf++ = ch;
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	8d 48 01             	lea    0x1(%eax),%ecx
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	89 0a                	mov    %ecx,(%edx)
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	88 10                	mov    %dl,(%eax)
}
  801538:	90                   	nop
  801539:	5d                   	pop    %ebp
  80153a:	c3                   	ret    

0080153b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	74 06                	je     801568 <vsnprintf+0x2d>
  801562:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801566:	7f 07                	jg     80156f <vsnprintf+0x34>
		return -E_INVAL;
  801568:	b8 03 00 00 00       	mov    $0x3,%eax
  80156d:	eb 20                	jmp    80158f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80156f:	ff 75 14             	pushl  0x14(%ebp)
  801572:	ff 75 10             	pushl  0x10(%ebp)
  801575:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	68 05 15 80 00       	push   $0x801505
  80157e:	e8 92 fb ff ff       	call   801115 <vprintfmt>
  801583:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801589:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801597:	8d 45 10             	lea    0x10(%ebp),%eax
  80159a:	83 c0 04             	add    $0x4,%eax
  80159d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a6:	50                   	push   %eax
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 89 ff ff ff       	call   80153b <vsnprintf>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ca:	eb 06                	jmp    8015d2 <strlen+0x15>
		n++;
  8015cc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015cf:	ff 45 08             	incl   0x8(%ebp)
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	84 c0                	test   %al,%al
  8015d9:	75 f1                	jne    8015cc <strlen+0xf>
		n++;
	return n;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 09                	jmp    8015f8 <strnlen+0x18>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	ff 4d 0c             	decl   0xc(%ebp)
  8015f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fc:	74 09                	je     801607 <strnlen+0x27>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	84 c0                	test   %al,%al
  801605:	75 e8                	jne    8015ef <strnlen+0xf>
		n++;
	return n;
  801607:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801618:	90                   	nop
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 08             	mov    %edx,0x8(%ebp)
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8d 4a 01             	lea    0x1(%edx),%ecx
  801628:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
  80162f:	8a 00                	mov    (%eax),%al
  801631:	84 c0                	test   %al,%al
  801633:	75 e4                	jne    801619 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801635:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164d:	eb 1f                	jmp    80166e <strncpy+0x34>
		*dst++ = *src;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 08             	mov    %edx,0x8(%ebp)
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8a 12                	mov    (%edx),%dl
  80165d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	84 c0                	test   %al,%al
  801666:	74 03                	je     80166b <strncpy+0x31>
			src++;
  801668:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	3b 45 10             	cmp    0x10(%ebp),%eax
  801674:	72 d9                	jb     80164f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801676:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801687:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168b:	74 30                	je     8016bd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80168d:	eb 16                	jmp    8016a5 <strlcpy+0x2a>
			*dst++ = *src++;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8d 50 01             	lea    0x1(%eax),%edx
  801695:	89 55 08             	mov    %edx,0x8(%ebp)
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80169e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016a1:	8a 12                	mov    (%edx),%dl
  8016a3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a5:	ff 4d 10             	decl   0x10(%ebp)
  8016a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ac:	74 09                	je     8016b7 <strlcpy+0x3c>
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	84 c0                	test   %al,%al
  8016b5:	75 d8                	jne    80168f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c3:	29 c2                	sub    %eax,%edx
  8016c5:	89 d0                	mov    %edx,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016cc:	eb 06                	jmp    8016d4 <strcmp+0xb>
		p++, q++;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	84 c0                	test   %al,%al
  8016db:	74 0e                	je     8016eb <strcmp+0x22>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 10                	mov    (%eax),%dl
  8016e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	38 c2                	cmp    %al,%dl
  8016e9:	74 e3                	je     8016ce <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 d0             	movzbl %al,%edx
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	0f b6 c0             	movzbl %al,%eax
  8016fb:	29 c2                	sub    %eax,%edx
  8016fd:	89 d0                	mov    %edx,%eax
}
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801704:	eb 09                	jmp    80170f <strncmp+0xe>
		n--, p++, q++;
  801706:	ff 4d 10             	decl   0x10(%ebp)
  801709:	ff 45 08             	incl   0x8(%ebp)
  80170c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80170f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801713:	74 17                	je     80172c <strncmp+0x2b>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 0e                	je     80172c <strncmp+0x2b>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8a 10                	mov    (%eax),%dl
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 da                	je     801706 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80172c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801730:	75 07                	jne    801739 <strncmp+0x38>
		return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	eb 14                	jmp    80174d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	0f b6 d0             	movzbl %al,%edx
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	0f b6 c0             	movzbl %al,%eax
  801749:	29 c2                	sub    %eax,%edx
  80174b:	89 d0                	mov    %edx,%eax
}
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
  801758:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80175b:	eb 12                	jmp    80176f <strchr+0x20>
		if (*s == c)
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801765:	75 05                	jne    80176c <strchr+0x1d>
			return (char *) s;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	eb 11                	jmp    80177d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80176c:	ff 45 08             	incl   0x8(%ebp)
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	84 c0                	test   %al,%al
  801776:	75 e5                	jne    80175d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80178b:	eb 0d                	jmp    80179a <strfind+0x1b>
		if (*s == c)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801795:	74 0e                	je     8017a5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8a 00                	mov    (%eax),%al
  80179f:	84 c0                	test   %al,%al
  8017a1:	75 ea                	jne    80178d <strfind+0xe>
  8017a3:	eb 01                	jmp    8017a6 <strfind+0x27>
		if (*s == c)
			break;
  8017a5:	90                   	nop
	return (char *) s;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017bd:	eb 0e                	jmp    8017cd <memset+0x22>
		*p++ = c;
  8017bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c2:	8d 50 01             	lea    0x1(%eax),%edx
  8017c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017cd:	ff 4d f8             	decl   -0x8(%ebp)
  8017d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017d4:	79 e9                	jns    8017bf <memset+0x14>
		*p++ = c;

	return v;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017ed:	eb 16                	jmp    801805 <memcpy+0x2a>
		*d++ = *s++;
  8017ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f2:	8d 50 01             	lea    0x1(%eax),%edx
  8017f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801801:	8a 12                	mov    (%edx),%dl
  801803:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801805:	8b 45 10             	mov    0x10(%ebp),%eax
  801808:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180b:	89 55 10             	mov    %edx,0x10(%ebp)
  80180e:	85 c0                	test   %eax,%eax
  801810:	75 dd                	jne    8017ef <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80182f:	73 50                	jae    801881 <memmove+0x6a>
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80183c:	76 43                	jbe    801881 <memmove+0x6a>
		s += n;
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801844:	8b 45 10             	mov    0x10(%ebp),%eax
  801847:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80184a:	eb 10                	jmp    80185c <memmove+0x45>
			*--d = *--s;
  80184c:	ff 4d f8             	decl   -0x8(%ebp)
  80184f:	ff 4d fc             	decl   -0x4(%ebp)
  801852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801855:	8a 10                	mov    (%eax),%dl
  801857:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80185c:	8b 45 10             	mov    0x10(%ebp),%eax
  80185f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801862:	89 55 10             	mov    %edx,0x10(%ebp)
  801865:	85 c0                	test   %eax,%eax
  801867:	75 e3                	jne    80184c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801869:	eb 23                	jmp    80188e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80186b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186e:	8d 50 01             	lea    0x1(%eax),%edx
  801871:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801874:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801877:	8d 4a 01             	lea    0x1(%edx),%ecx
  80187a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80187d:	8a 12                	mov    (%edx),%dl
  80187f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	8d 50 ff             	lea    -0x1(%eax),%edx
  801887:	89 55 10             	mov    %edx,0x10(%ebp)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 dd                	jne    80186b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018a5:	eb 2a                	jmp    8018d1 <memcmp+0x3e>
		if (*s1 != *s2)
  8018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018aa:	8a 10                	mov    (%eax),%dl
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	38 c2                	cmp    %al,%dl
  8018b3:	74 16                	je     8018cb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c0:	8a 00                	mov    (%eax),%al
  8018c2:	0f b6 c0             	movzbl %al,%eax
  8018c5:	29 c2                	sub    %eax,%edx
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	eb 18                	jmp    8018e3 <memcmp+0x50>
		s1++, s2++;
  8018cb:	ff 45 fc             	incl   -0x4(%ebp)
  8018ce:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	75 c9                	jne    8018a7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018f6:	eb 15                	jmp    80190d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8a 00                	mov    (%eax),%al
  8018fd:	0f b6 d0             	movzbl %al,%edx
  801900:	8b 45 0c             	mov    0xc(%ebp),%eax
  801903:	0f b6 c0             	movzbl %al,%eax
  801906:	39 c2                	cmp    %eax,%edx
  801908:	74 0d                	je     801917 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80190a:	ff 45 08             	incl   0x8(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801913:	72 e3                	jb     8018f8 <memfind+0x13>
  801915:	eb 01                	jmp    801918 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801917:	90                   	nop
	return (void *) s;
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80192a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801931:	eb 03                	jmp    801936 <strtol+0x19>
		s++;
  801933:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	3c 20                	cmp    $0x20,%al
  80193d:	74 f4                	je     801933 <strtol+0x16>
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8a 00                	mov    (%eax),%al
  801944:	3c 09                	cmp    $0x9,%al
  801946:	74 eb                	je     801933 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8a 00                	mov    (%eax),%al
  80194d:	3c 2b                	cmp    $0x2b,%al
  80194f:	75 05                	jne    801956 <strtol+0x39>
		s++;
  801951:	ff 45 08             	incl   0x8(%ebp)
  801954:	eb 13                	jmp    801969 <strtol+0x4c>
	else if (*s == '-')
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	3c 2d                	cmp    $0x2d,%al
  80195d:	75 0a                	jne    801969 <strtol+0x4c>
		s++, neg = 1;
  80195f:	ff 45 08             	incl   0x8(%ebp)
  801962:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801969:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196d:	74 06                	je     801975 <strtol+0x58>
  80196f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801973:	75 20                	jne    801995 <strtol+0x78>
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	3c 30                	cmp    $0x30,%al
  80197c:	75 17                	jne    801995 <strtol+0x78>
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	40                   	inc    %eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	3c 78                	cmp    $0x78,%al
  801986:	75 0d                	jne    801995 <strtol+0x78>
		s += 2, base = 16;
  801988:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80198c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801993:	eb 28                	jmp    8019bd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801995:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801999:	75 15                	jne    8019b0 <strtol+0x93>
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3c 30                	cmp    $0x30,%al
  8019a2:	75 0c                	jne    8019b0 <strtol+0x93>
		s++, base = 8;
  8019a4:	ff 45 08             	incl   0x8(%ebp)
  8019a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019ae:	eb 0d                	jmp    8019bd <strtol+0xa0>
	else if (base == 0)
  8019b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b4:	75 07                	jne    8019bd <strtol+0xa0>
		base = 10;
  8019b6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 2f                	cmp    $0x2f,%al
  8019c4:	7e 19                	jle    8019df <strtol+0xc2>
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 39                	cmp    $0x39,%al
  8019cd:	7f 10                	jg     8019df <strtol+0xc2>
			dig = *s - '0';
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	0f be c0             	movsbl %al,%eax
  8019d7:	83 e8 30             	sub    $0x30,%eax
  8019da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019dd:	eb 42                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	3c 60                	cmp    $0x60,%al
  8019e6:	7e 19                	jle    801a01 <strtol+0xe4>
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	3c 7a                	cmp    $0x7a,%al
  8019ef:	7f 10                	jg     801a01 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	0f be c0             	movsbl %al,%eax
  8019f9:	83 e8 57             	sub    $0x57,%eax
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ff:	eb 20                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 40                	cmp    $0x40,%al
  801a08:	7e 39                	jle    801a43 <strtol+0x126>
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	3c 5a                	cmp    $0x5a,%al
  801a11:	7f 30                	jg     801a43 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	0f be c0             	movsbl %al,%eax
  801a1b:	83 e8 37             	sub    $0x37,%eax
  801a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a27:	7d 19                	jge    801a42 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a29:	ff 45 08             	incl   0x8(%ebp)
  801a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a3d:	e9 7b ff ff ff       	jmp    8019bd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a42:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a47:	74 08                	je     801a51 <strtol+0x134>
		*endptr = (char *) s;
  801a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a55:	74 07                	je     801a5e <strtol+0x141>
  801a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5a:	f7 d8                	neg    %eax
  801a5c:	eb 03                	jmp    801a61 <strtol+0x144>
  801a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <ltostr>:

void
ltostr(long value, char *str)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7b:	79 13                	jns    801a90 <ltostr+0x2d>
	{
		neg = 1;
  801a7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a87:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a8a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a8d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a98:	99                   	cltd   
  801a99:	f7 f9                	idiv   %ecx
  801a9b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa1:	8d 50 01             	lea    0x1(%eax),%edx
  801aa4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aa7:	89 c2                	mov    %eax,%edx
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ab1:	83 c2 30             	add    $0x30,%edx
  801ab4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ab6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801abe:	f7 e9                	imul   %ecx
  801ac0:	c1 fa 02             	sar    $0x2,%edx
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	c1 f8 1f             	sar    $0x1f,%eax
  801ac8:	29 c2                	sub    %eax,%edx
  801aca:	89 d0                	mov    %edx,%eax
  801acc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ad7:	f7 e9                	imul   %ecx
  801ad9:	c1 fa 02             	sar    $0x2,%edx
  801adc:	89 c8                	mov    %ecx,%eax
  801ade:	c1 f8 1f             	sar    $0x1f,%eax
  801ae1:	29 c2                	sub    %eax,%edx
  801ae3:	89 d0                	mov    %edx,%eax
  801ae5:	c1 e0 02             	shl    $0x2,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	01 c0                	add    %eax,%eax
  801aec:	29 c1                	sub    %eax,%ecx
  801aee:	89 ca                	mov    %ecx,%edx
  801af0:	85 d2                	test   %edx,%edx
  801af2:	75 9c                	jne    801a90 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afe:	48                   	dec    %eax
  801aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b06:	74 3d                	je     801b45 <ltostr+0xe2>
		start = 1 ;
  801b08:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b0f:	eb 34                	jmp    801b45 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	8a 00                	mov    (%eax),%al
  801b1b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	01 c2                	add    %eax,%edx
  801b26:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	01 c8                	add    %ecx,%eax
  801b2e:	8a 00                	mov    (%eax),%al
  801b30:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 c2                	add    %eax,%edx
  801b3a:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b3d:	88 02                	mov    %al,(%edx)
		start++ ;
  801b3f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b42:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b48:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b4b:	7c c4                	jl     801b11 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b4d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	01 d0                	add    %edx,%eax
  801b55:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	e8 54 fa ff ff       	call   8015bd <strlen>
  801b69:	83 c4 04             	add    $0x4,%esp
  801b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	e8 46 fa ff ff       	call   8015bd <strlen>
  801b77:	83 c4 04             	add    $0x4,%esp
  801b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b8b:	eb 17                	jmp    801ba4 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b90:	8b 45 10             	mov    0x10(%ebp),%eax
  801b93:	01 c2                	add    %eax,%edx
  801b95:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	01 c8                	add    %ecx,%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ba1:	ff 45 fc             	incl   -0x4(%ebp)
  801ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801baa:	7c e1                	jl     801b8d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bba:	eb 1f                	jmp    801bdb <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbf:	8d 50 01             	lea    0x1(%eax),%edx
  801bc2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bc5:	89 c2                	mov    %eax,%edx
  801bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bca:	01 c2                	add    %eax,%edx
  801bcc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd2:	01 c8                	add    %ecx,%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bd8:	ff 45 f8             	incl   -0x8(%ebp)
  801bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bde:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801be1:	7c d9                	jl     801bbc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be6:	8b 45 10             	mov    0x10(%ebp),%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	c6 00 00             	movb   $0x0,(%eax)
}
  801bee:	90                   	nop
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801c00:	8b 00                	mov    (%eax),%eax
  801c02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c14:	eb 0c                	jmp    801c22 <strsplit+0x31>
			*string++ = 0;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8d 50 01             	lea    0x1(%eax),%edx
  801c1c:	89 55 08             	mov    %edx,0x8(%ebp)
  801c1f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8a 00                	mov    (%eax),%al
  801c27:	84 c0                	test   %al,%al
  801c29:	74 18                	je     801c43 <strsplit+0x52>
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8a 00                	mov    (%eax),%al
  801c30:	0f be c0             	movsbl %al,%eax
  801c33:	50                   	push   %eax
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	e8 13 fb ff ff       	call   80174f <strchr>
  801c3c:	83 c4 08             	add    $0x8,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	75 d3                	jne    801c16 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8a 00                	mov    (%eax),%al
  801c48:	84 c0                	test   %al,%al
  801c4a:	74 5a                	je     801ca6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	83 f8 0f             	cmp    $0xf,%eax
  801c54:	75 07                	jne    801c5d <strsplit+0x6c>
		{
			return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5b:	eb 66                	jmp    801cc3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c60:	8b 00                	mov    (%eax),%eax
  801c62:	8d 48 01             	lea    0x1(%eax),%ecx
  801c65:	8b 55 14             	mov    0x14(%ebp),%edx
  801c68:	89 0a                	mov    %ecx,(%edx)
  801c6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	01 c2                	add    %eax,%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c7b:	eb 03                	jmp    801c80 <strsplit+0x8f>
			string++;
  801c7d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	84 c0                	test   %al,%al
  801c87:	74 8b                	je     801c14 <strsplit+0x23>
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8a 00                	mov    (%eax),%al
  801c8e:	0f be c0             	movsbl %al,%eax
  801c91:	50                   	push   %eax
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	e8 b5 fa ff ff       	call   80174f <strchr>
  801c9a:	83 c4 08             	add    $0x8,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	74 dc                	je     801c7d <strsplit+0x8c>
			string++;
	}
  801ca1:	e9 6e ff ff ff       	jmp    801c14 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ca6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb6:	01 d0                	add    %edx,%eax
  801cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ccb:	a1 04 50 80 00       	mov    0x805004,%eax
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	74 1f                	je     801cf3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cd4:	e8 1d 00 00 00       	call   801cf6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	68 d0 49 80 00       	push   $0x8049d0
  801ce1:	e8 55 f2 ff ff       	call   800f3b <cprintf>
  801ce6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ce9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cf0:	00 00 00 
	}
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801cfc:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d03:	00 00 00 
  801d06:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d0d:	00 00 00 
  801d10:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d17:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801d1a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d21:	00 00 00 
  801d24:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d2b:	00 00 00 
  801d2e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d35:	00 00 00 
	uint32 arr_size = 0;
  801d38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801d3f:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d4e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d53:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801d58:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d5f:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801d62:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d69:	a1 20 51 80 00       	mov    0x805120,%eax
  801d6e:	c1 e0 04             	shl    $0x4,%eax
  801d71:	89 c2                	mov    %eax,%edx
  801d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d76:	01 d0                	add    %edx,%eax
  801d78:	48                   	dec    %eax
  801d79:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d84:	f7 75 ec             	divl   -0x14(%ebp)
  801d87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d8a:	29 d0                	sub    %edx,%eax
  801d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801d8f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d9e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801da3:	83 ec 04             	sub    $0x4,%esp
  801da6:	6a 06                	push   $0x6
  801da8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dab:	50                   	push   %eax
  801dac:	e8 42 04 00 00       	call   8021f3 <sys_allocate_chunk>
  801db1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801db4:	a1 20 51 80 00       	mov    0x805120,%eax
  801db9:	83 ec 0c             	sub    $0xc,%esp
  801dbc:	50                   	push   %eax
  801dbd:	e8 b7 0a 00 00       	call   802879 <initialize_MemBlocksList>
  801dc2:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801dc5:	a1 48 51 80 00       	mov    0x805148,%eax
  801dca:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801dd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dda:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801de1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801de5:	75 14                	jne    801dfb <initialize_dyn_block_system+0x105>
  801de7:	83 ec 04             	sub    $0x4,%esp
  801dea:	68 f5 49 80 00       	push   $0x8049f5
  801def:	6a 33                	push   $0x33
  801df1:	68 13 4a 80 00       	push   $0x804a13
  801df6:	e8 8c ee ff ff       	call   800c87 <_panic>
  801dfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dfe:	8b 00                	mov    (%eax),%eax
  801e00:	85 c0                	test   %eax,%eax
  801e02:	74 10                	je     801e14 <initialize_dyn_block_system+0x11e>
  801e04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e07:	8b 00                	mov    (%eax),%eax
  801e09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e0c:	8b 52 04             	mov    0x4(%edx),%edx
  801e0f:	89 50 04             	mov    %edx,0x4(%eax)
  801e12:	eb 0b                	jmp    801e1f <initialize_dyn_block_system+0x129>
  801e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e17:	8b 40 04             	mov    0x4(%eax),%eax
  801e1a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e22:	8b 40 04             	mov    0x4(%eax),%eax
  801e25:	85 c0                	test   %eax,%eax
  801e27:	74 0f                	je     801e38 <initialize_dyn_block_system+0x142>
  801e29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e2c:	8b 40 04             	mov    0x4(%eax),%eax
  801e2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e32:	8b 12                	mov    (%edx),%edx
  801e34:	89 10                	mov    %edx,(%eax)
  801e36:	eb 0a                	jmp    801e42 <initialize_dyn_block_system+0x14c>
  801e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	a3 48 51 80 00       	mov    %eax,0x805148
  801e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e55:	a1 54 51 80 00       	mov    0x805154,%eax
  801e5a:	48                   	dec    %eax
  801e5b:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801e60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e64:	75 14                	jne    801e7a <initialize_dyn_block_system+0x184>
  801e66:	83 ec 04             	sub    $0x4,%esp
  801e69:	68 20 4a 80 00       	push   $0x804a20
  801e6e:	6a 34                	push   $0x34
  801e70:	68 13 4a 80 00       	push   $0x804a13
  801e75:	e8 0d ee ff ff       	call   800c87 <_panic>
  801e7a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801e80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e83:	89 10                	mov    %edx,(%eax)
  801e85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e88:	8b 00                	mov    (%eax),%eax
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	74 0d                	je     801e9b <initialize_dyn_block_system+0x1a5>
  801e8e:	a1 38 51 80 00       	mov    0x805138,%eax
  801e93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e96:	89 50 04             	mov    %edx,0x4(%eax)
  801e99:	eb 08                	jmp    801ea3 <initialize_dyn_block_system+0x1ad>
  801e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e9e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801ea3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea6:	a3 38 51 80 00       	mov    %eax,0x805138
  801eab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eb5:	a1 44 51 80 00       	mov    0x805144,%eax
  801eba:	40                   	inc    %eax
  801ebb:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801ec0:	90                   	nop
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ec9:	e8 f7 fd ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ece:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ed2:	75 07                	jne    801edb <malloc+0x18>
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	eb 14                	jmp    801eef <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	68 44 4a 80 00       	push   $0x804a44
  801ee3:	6a 46                	push   $0x46
  801ee5:	68 13 4a 80 00       	push   $0x804a13
  801eea:	e8 98 ed ff ff       	call   800c87 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801ef7:	83 ec 04             	sub    $0x4,%esp
  801efa:	68 6c 4a 80 00       	push   $0x804a6c
  801eff:	6a 61                	push   $0x61
  801f01:	68 13 4a 80 00       	push   $0x804a13
  801f06:	e8 7c ed ff ff       	call   800c87 <_panic>

00801f0b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 38             	sub    $0x38,%esp
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f17:	e8 a9 fd ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f20:	75 0a                	jne    801f2c <smalloc+0x21>
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
  801f27:	e9 9e 00 00 00       	jmp    801fca <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f2c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f39:	01 d0                	add    %edx,%eax
  801f3b:	48                   	dec    %eax
  801f3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f42:	ba 00 00 00 00       	mov    $0x0,%edx
  801f47:	f7 75 f0             	divl   -0x10(%ebp)
  801f4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4d:	29 d0                	sub    %edx,%eax
  801f4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801f52:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f59:	e8 63 06 00 00       	call   8025c1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	74 11                	je     801f73 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801f62:	83 ec 0c             	sub    $0xc,%esp
  801f65:	ff 75 e8             	pushl  -0x18(%ebp)
  801f68:	e8 ce 0c 00 00       	call   802c3b <alloc_block_FF>
  801f6d:	83 c4 10             	add    $0x10,%esp
  801f70:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801f73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f77:	74 4c                	je     801fc5 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 40 08             	mov    0x8(%eax),%eax
  801f7f:	89 c2                	mov    %eax,%edx
  801f81:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f85:	52                   	push   %edx
  801f86:	50                   	push   %eax
  801f87:	ff 75 0c             	pushl  0xc(%ebp)
  801f8a:	ff 75 08             	pushl  0x8(%ebp)
  801f8d:	e8 b4 03 00 00       	call   802346 <sys_createSharedObject>
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801f98:	83 ec 08             	sub    $0x8,%esp
  801f9b:	ff 75 e0             	pushl  -0x20(%ebp)
  801f9e:	68 8f 4a 80 00       	push   $0x804a8f
  801fa3:	e8 93 ef ff ff       	call   800f3b <cprintf>
  801fa8:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801fab:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801faf:	74 14                	je     801fc5 <smalloc+0xba>
  801fb1:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801fb5:	74 0e                	je     801fc5 <smalloc+0xba>
  801fb7:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801fbb:	74 08                	je     801fc5 <smalloc+0xba>
			return (void*) mem_block->sva;
  801fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc0:	8b 40 08             	mov    0x8(%eax),%eax
  801fc3:	eb 05                	jmp    801fca <smalloc+0xbf>
	}
	return NULL;
  801fc5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fd2:	e8 ee fc ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	68 a4 4a 80 00       	push   $0x804aa4
  801fdf:	68 ab 00 00 00       	push   $0xab
  801fe4:	68 13 4a 80 00       	push   $0x804a13
  801fe9:	e8 99 ec ff ff       	call   800c87 <_panic>

00801fee <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ff4:	e8 cc fc ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ff9:	83 ec 04             	sub    $0x4,%esp
  801ffc:	68 c8 4a 80 00       	push   $0x804ac8
  802001:	68 ef 00 00 00       	push   $0xef
  802006:	68 13 4a 80 00       	push   $0x804a13
  80200b:	e8 77 ec ff ff       	call   800c87 <_panic>

00802010 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	68 f0 4a 80 00       	push   $0x804af0
  80201e:	68 03 01 00 00       	push   $0x103
  802023:	68 13 4a 80 00       	push   $0x804a13
  802028:	e8 5a ec ff ff       	call   800c87 <_panic>

0080202d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802033:	83 ec 04             	sub    $0x4,%esp
  802036:	68 14 4b 80 00       	push   $0x804b14
  80203b:	68 0e 01 00 00       	push   $0x10e
  802040:	68 13 4a 80 00       	push   $0x804a13
  802045:	e8 3d ec ff ff       	call   800c87 <_panic>

0080204a <shrink>:

}
void shrink(uint32 newSize)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802050:	83 ec 04             	sub    $0x4,%esp
  802053:	68 14 4b 80 00       	push   $0x804b14
  802058:	68 13 01 00 00       	push   $0x113
  80205d:	68 13 4a 80 00       	push   $0x804a13
  802062:	e8 20 ec ff ff       	call   800c87 <_panic>

00802067 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	68 14 4b 80 00       	push   $0x804b14
  802075:	68 18 01 00 00       	push   $0x118
  80207a:	68 13 4a 80 00       	push   $0x804a13
  80207f:	e8 03 ec ff ff       	call   800c87 <_panic>

00802084 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	57                   	push   %edi
  802088:	56                   	push   %esi
  802089:	53                   	push   %ebx
  80208a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	8b 55 0c             	mov    0xc(%ebp),%edx
  802093:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802096:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802099:	8b 7d 18             	mov    0x18(%ebp),%edi
  80209c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80209f:	cd 30                	int    $0x30
  8020a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	5b                   	pop    %ebx
  8020ab:	5e                   	pop    %esi
  8020ac:	5f                   	pop    %edi
  8020ad:	5d                   	pop    %ebp
  8020ae:	c3                   	ret    

008020af <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 04             	sub    $0x4,%esp
  8020b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020bb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	52                   	push   %edx
  8020c7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ca:	50                   	push   %eax
  8020cb:	6a 00                	push   $0x0
  8020cd:	e8 b2 ff ff ff       	call   802084 <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
}
  8020d5:	90                   	nop
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 01                	push   $0x1
  8020e7:	e8 98 ff ff ff       	call   802084 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	52                   	push   %edx
  802101:	50                   	push   %eax
  802102:	6a 05                	push   $0x5
  802104:	e8 7b ff ff ff       	call   802084 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	56                   	push   %esi
  802112:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802113:	8b 75 18             	mov    0x18(%ebp),%esi
  802116:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802119:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	56                   	push   %esi
  802123:	53                   	push   %ebx
  802124:	51                   	push   %ecx
  802125:	52                   	push   %edx
  802126:	50                   	push   %eax
  802127:	6a 06                	push   $0x6
  802129:	e8 56 ff ff ff       	call   802084 <syscall>
  80212e:	83 c4 18             	add    $0x18,%esp
}
  802131:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802134:	5b                   	pop    %ebx
  802135:	5e                   	pop    %esi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    

00802138 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80213b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	52                   	push   %edx
  802148:	50                   	push   %eax
  802149:	6a 07                	push   $0x7
  80214b:	e8 34 ff ff ff       	call   802084 <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	ff 75 0c             	pushl  0xc(%ebp)
  802161:	ff 75 08             	pushl  0x8(%ebp)
  802164:	6a 08                	push   $0x8
  802166:	e8 19 ff ff ff       	call   802084 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 09                	push   $0x9
  80217f:	e8 00 ff ff ff       	call   802084 <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 0a                	push   $0xa
  802198:	e8 e7 fe ff ff       	call   802084 <syscall>
  80219d:	83 c4 18             	add    $0x18,%esp
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 0b                	push   $0xb
  8021b1:	e8 ce fe ff ff       	call   802084 <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	ff 75 0c             	pushl  0xc(%ebp)
  8021c7:	ff 75 08             	pushl  0x8(%ebp)
  8021ca:	6a 0f                	push   $0xf
  8021cc:	e8 b3 fe ff ff       	call   802084 <syscall>
  8021d1:	83 c4 18             	add    $0x18,%esp
	return;
  8021d4:	90                   	nop
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	ff 75 0c             	pushl  0xc(%ebp)
  8021e3:	ff 75 08             	pushl  0x8(%ebp)
  8021e6:	6a 10                	push   $0x10
  8021e8:	e8 97 fe ff ff       	call   802084 <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f0:	90                   	nop
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	ff 75 10             	pushl  0x10(%ebp)
  8021fd:	ff 75 0c             	pushl  0xc(%ebp)
  802200:	ff 75 08             	pushl  0x8(%ebp)
  802203:	6a 11                	push   $0x11
  802205:	e8 7a fe ff ff       	call   802084 <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
	return ;
  80220d:	90                   	nop
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 0c                	push   $0xc
  80221f:	e8 60 fe ff ff       	call   802084 <syscall>
  802224:	83 c4 18             	add    $0x18,%esp
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	ff 75 08             	pushl  0x8(%ebp)
  802237:	6a 0d                	push   $0xd
  802239:	e8 46 fe ff ff       	call   802084 <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 0e                	push   $0xe
  802252:	e8 2d fe ff ff       	call   802084 <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	90                   	nop
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 13                	push   $0x13
  80226c:	e8 13 fe ff ff       	call   802084 <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
}
  802274:	90                   	nop
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 14                	push   $0x14
  802286:	e8 f9 fd ff ff       	call   802084 <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	90                   	nop
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_cputc>:


void
sys_cputc(const char c)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 04             	sub    $0x4,%esp
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80229d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	50                   	push   %eax
  8022aa:	6a 15                	push   $0x15
  8022ac:	e8 d3 fd ff ff       	call   802084 <syscall>
  8022b1:	83 c4 18             	add    $0x18,%esp
}
  8022b4:	90                   	nop
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 16                	push   $0x16
  8022c6:	e8 b9 fd ff ff       	call   802084 <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	90                   	nop
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	ff 75 0c             	pushl  0xc(%ebp)
  8022e0:	50                   	push   %eax
  8022e1:	6a 17                	push   $0x17
  8022e3:	e8 9c fd ff ff       	call   802084 <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	52                   	push   %edx
  8022fd:	50                   	push   %eax
  8022fe:	6a 1a                	push   $0x1a
  802300:	e8 7f fd ff ff       	call   802084 <syscall>
  802305:	83 c4 18             	add    $0x18,%esp
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80230d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	52                   	push   %edx
  80231a:	50                   	push   %eax
  80231b:	6a 18                	push   $0x18
  80231d:	e8 62 fd ff ff       	call   802084 <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
}
  802325:	90                   	nop
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80232b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	52                   	push   %edx
  802338:	50                   	push   %eax
  802339:	6a 19                	push   $0x19
  80233b:	e8 44 fd ff ff       	call   802084 <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
}
  802343:	90                   	nop
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	8b 45 10             	mov    0x10(%ebp),%eax
  80234f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802352:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802355:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	6a 00                	push   $0x0
  80235e:	51                   	push   %ecx
  80235f:	52                   	push   %edx
  802360:	ff 75 0c             	pushl  0xc(%ebp)
  802363:	50                   	push   %eax
  802364:	6a 1b                	push   $0x1b
  802366:	e8 19 fd ff ff       	call   802084 <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802373:	8b 55 0c             	mov    0xc(%ebp),%edx
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	52                   	push   %edx
  802380:	50                   	push   %eax
  802381:	6a 1c                	push   $0x1c
  802383:	e8 fc fc ff ff       	call   802084 <syscall>
  802388:	83 c4 18             	add    $0x18,%esp
}
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802390:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802393:	8b 55 0c             	mov    0xc(%ebp),%edx
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	51                   	push   %ecx
  80239e:	52                   	push   %edx
  80239f:	50                   	push   %eax
  8023a0:	6a 1d                	push   $0x1d
  8023a2:	e8 dd fc ff ff       	call   802084 <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	52                   	push   %edx
  8023bc:	50                   	push   %eax
  8023bd:	6a 1e                	push   $0x1e
  8023bf:	e8 c0 fc ff ff       	call   802084 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 1f                	push   $0x1f
  8023d8:	e8 a7 fc ff ff       	call   802084 <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	ff 75 14             	pushl  0x14(%ebp)
  8023ed:	ff 75 10             	pushl  0x10(%ebp)
  8023f0:	ff 75 0c             	pushl  0xc(%ebp)
  8023f3:	50                   	push   %eax
  8023f4:	6a 20                	push   $0x20
  8023f6:	e8 89 fc ff ff       	call   802084 <syscall>
  8023fb:	83 c4 18             	add    $0x18,%esp
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	50                   	push   %eax
  80240f:	6a 21                	push   $0x21
  802411:	e8 6e fc ff ff       	call   802084 <syscall>
  802416:	83 c4 18             	add    $0x18,%esp
}
  802419:	90                   	nop
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	50                   	push   %eax
  80242b:	6a 22                	push   $0x22
  80242d:	e8 52 fc ff ff       	call   802084 <syscall>
  802432:	83 c4 18             	add    $0x18,%esp
}
  802435:	c9                   	leave  
  802436:	c3                   	ret    

00802437 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 02                	push   $0x2
  802446:	e8 39 fc ff ff       	call   802084 <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
}
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 03                	push   $0x3
  80245f:	e8 20 fc ff ff       	call   802084 <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 04                	push   $0x4
  802478:	e8 07 fc ff ff       	call   802084 <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <sys_exit_env>:


void sys_exit_env(void)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 23                	push   $0x23
  802491:	e8 ee fb ff ff       	call   802084 <syscall>
  802496:	83 c4 18             	add    $0x18,%esp
}
  802499:	90                   	nop
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024a2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024a5:	8d 50 04             	lea    0x4(%eax),%edx
  8024a8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	52                   	push   %edx
  8024b2:	50                   	push   %eax
  8024b3:	6a 24                	push   $0x24
  8024b5:	e8 ca fb ff ff       	call   802084 <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
	return result;
  8024bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024c6:	89 01                	mov    %eax,(%ecx)
  8024c8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	c9                   	leave  
  8024cf:	c2 04 00             	ret    $0x4

008024d2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	ff 75 10             	pushl  0x10(%ebp)
  8024dc:	ff 75 0c             	pushl  0xc(%ebp)
  8024df:	ff 75 08             	pushl  0x8(%ebp)
  8024e2:	6a 12                	push   $0x12
  8024e4:	e8 9b fb ff ff       	call   802084 <syscall>
  8024e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ec:	90                   	nop
}
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 25                	push   $0x25
  8024fe:	e8 81 fb ff ff       	call   802084 <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	83 ec 04             	sub    $0x4,%esp
  80250e:	8b 45 08             	mov    0x8(%ebp),%eax
  802511:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802514:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	50                   	push   %eax
  802521:	6a 26                	push   $0x26
  802523:	e8 5c fb ff ff       	call   802084 <syscall>
  802528:	83 c4 18             	add    $0x18,%esp
	return ;
  80252b:	90                   	nop
}
  80252c:	c9                   	leave  
  80252d:	c3                   	ret    

0080252e <rsttst>:
void rsttst()
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 28                	push   $0x28
  80253d:	e8 42 fb ff ff       	call   802084 <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
	return ;
  802545:	90                   	nop
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
  80254b:	83 ec 04             	sub    $0x4,%esp
  80254e:	8b 45 14             	mov    0x14(%ebp),%eax
  802551:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802554:	8b 55 18             	mov    0x18(%ebp),%edx
  802557:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80255b:	52                   	push   %edx
  80255c:	50                   	push   %eax
  80255d:	ff 75 10             	pushl  0x10(%ebp)
  802560:	ff 75 0c             	pushl  0xc(%ebp)
  802563:	ff 75 08             	pushl  0x8(%ebp)
  802566:	6a 27                	push   $0x27
  802568:	e8 17 fb ff ff       	call   802084 <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
	return ;
  802570:	90                   	nop
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <chktst>:
void chktst(uint32 n)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	ff 75 08             	pushl  0x8(%ebp)
  802581:	6a 29                	push   $0x29
  802583:	e8 fc fa ff ff       	call   802084 <syscall>
  802588:	83 c4 18             	add    $0x18,%esp
	return ;
  80258b:	90                   	nop
}
  80258c:	c9                   	leave  
  80258d:	c3                   	ret    

0080258e <inctst>:

void inctst()
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 2a                	push   $0x2a
  80259d:	e8 e2 fa ff ff       	call   802084 <syscall>
  8025a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a5:	90                   	nop
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <gettst>:
uint32 gettst()
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 2b                	push   $0x2b
  8025b7:	e8 c8 fa ff ff       	call   802084 <syscall>
  8025bc:	83 c4 18             	add    $0x18,%esp
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
  8025c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 2c                	push   $0x2c
  8025d3:	e8 ac fa ff ff       	call   802084 <syscall>
  8025d8:	83 c4 18             	add    $0x18,%esp
  8025db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025de:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025e2:	75 07                	jne    8025eb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e9:	eb 05                	jmp    8025f0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    

008025f2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
  8025f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 2c                	push   $0x2c
  802604:	e8 7b fa ff ff       	call   802084 <syscall>
  802609:	83 c4 18             	add    $0x18,%esp
  80260c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80260f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802613:	75 07                	jne    80261c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802615:	b8 01 00 00 00       	mov    $0x1,%eax
  80261a:	eb 05                	jmp    802621 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80261c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
  802626:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	6a 2c                	push   $0x2c
  802635:	e8 4a fa ff ff       	call   802084 <syscall>
  80263a:	83 c4 18             	add    $0x18,%esp
  80263d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802640:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802644:	75 07                	jne    80264d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802646:	b8 01 00 00 00       	mov    $0x1,%eax
  80264b:	eb 05                	jmp    802652 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80264d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802652:	c9                   	leave  
  802653:	c3                   	ret    

00802654 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
  802657:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 2c                	push   $0x2c
  802666:	e8 19 fa ff ff       	call   802084 <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
  80266e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802671:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802675:	75 07                	jne    80267e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802677:	b8 01 00 00 00       	mov    $0x1,%eax
  80267c:	eb 05                	jmp    802683 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	ff 75 08             	pushl  0x8(%ebp)
  802693:	6a 2d                	push   $0x2d
  802695:	e8 ea f9 ff ff       	call   802084 <syscall>
  80269a:	83 c4 18             	add    $0x18,%esp
	return ;
  80269d:	90                   	nop
}
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
  8026a3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	6a 00                	push   $0x0
  8026b2:	53                   	push   %ebx
  8026b3:	51                   	push   %ecx
  8026b4:	52                   	push   %edx
  8026b5:	50                   	push   %eax
  8026b6:	6a 2e                	push   $0x2e
  8026b8:	e8 c7 f9 ff ff       	call   802084 <syscall>
  8026bd:	83 c4 18             	add    $0x18,%esp
}
  8026c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026c3:	c9                   	leave  
  8026c4:	c3                   	ret    

008026c5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026c5:	55                   	push   %ebp
  8026c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	52                   	push   %edx
  8026d5:	50                   	push   %eax
  8026d6:	6a 2f                	push   $0x2f
  8026d8:	e8 a7 f9 ff ff       	call   802084 <syscall>
  8026dd:	83 c4 18             	add    $0x18,%esp
}
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	68 24 4b 80 00       	push   $0x804b24
  8026f0:	e8 46 e8 ff ff       	call   800f3b <cprintf>
  8026f5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026ff:	83 ec 0c             	sub    $0xc,%esp
  802702:	68 50 4b 80 00       	push   $0x804b50
  802707:	e8 2f e8 ff ff       	call   800f3b <cprintf>
  80270c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80270f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802713:	a1 38 51 80 00       	mov    0x805138,%eax
  802718:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271b:	eb 56                	jmp    802773 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80271d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802721:	74 1c                	je     80273f <print_mem_block_lists+0x5d>
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 50 08             	mov    0x8(%eax),%edx
  802729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272c:	8b 48 08             	mov    0x8(%eax),%ecx
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	8b 40 0c             	mov    0xc(%eax),%eax
  802735:	01 c8                	add    %ecx,%eax
  802737:	39 c2                	cmp    %eax,%edx
  802739:	73 04                	jae    80273f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80273b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 50 08             	mov    0x8(%eax),%edx
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 40 0c             	mov    0xc(%eax),%eax
  80274b:	01 c2                	add    %eax,%edx
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 40 08             	mov    0x8(%eax),%eax
  802753:	83 ec 04             	sub    $0x4,%esp
  802756:	52                   	push   %edx
  802757:	50                   	push   %eax
  802758:	68 65 4b 80 00       	push   $0x804b65
  80275d:	e8 d9 e7 ff ff       	call   800f3b <cprintf>
  802762:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80276b:	a1 40 51 80 00       	mov    0x805140,%eax
  802770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802777:	74 07                	je     802780 <print_mem_block_lists+0x9e>
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 00                	mov    (%eax),%eax
  80277e:	eb 05                	jmp    802785 <print_mem_block_lists+0xa3>
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
  802785:	a3 40 51 80 00       	mov    %eax,0x805140
  80278a:	a1 40 51 80 00       	mov    0x805140,%eax
  80278f:	85 c0                	test   %eax,%eax
  802791:	75 8a                	jne    80271d <print_mem_block_lists+0x3b>
  802793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802797:	75 84                	jne    80271d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802799:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80279d:	75 10                	jne    8027af <print_mem_block_lists+0xcd>
  80279f:	83 ec 0c             	sub    $0xc,%esp
  8027a2:	68 74 4b 80 00       	push   $0x804b74
  8027a7:	e8 8f e7 ff ff       	call   800f3b <cprintf>
  8027ac:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8027af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027b6:	83 ec 0c             	sub    $0xc,%esp
  8027b9:	68 98 4b 80 00       	push   $0x804b98
  8027be:	e8 78 e7 ff ff       	call   800f3b <cprintf>
  8027c3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027c6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027ca:	a1 40 50 80 00       	mov    0x805040,%eax
  8027cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d2:	eb 56                	jmp    80282a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d8:	74 1c                	je     8027f6 <print_mem_block_lists+0x114>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 50 08             	mov    0x8(%eax),%edx
  8027e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e3:	8b 48 08             	mov    0x8(%eax),%ecx
  8027e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ec:	01 c8                	add    %ecx,%eax
  8027ee:	39 c2                	cmp    %eax,%edx
  8027f0:	73 04                	jae    8027f6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027f2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 50 08             	mov    0x8(%eax),%edx
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802802:	01 c2                	add    %eax,%edx
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 40 08             	mov    0x8(%eax),%eax
  80280a:	83 ec 04             	sub    $0x4,%esp
  80280d:	52                   	push   %edx
  80280e:	50                   	push   %eax
  80280f:	68 65 4b 80 00       	push   $0x804b65
  802814:	e8 22 e7 ff ff       	call   800f3b <cprintf>
  802819:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802822:	a1 48 50 80 00       	mov    0x805048,%eax
  802827:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282e:	74 07                	je     802837 <print_mem_block_lists+0x155>
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	eb 05                	jmp    80283c <print_mem_block_lists+0x15a>
  802837:	b8 00 00 00 00       	mov    $0x0,%eax
  80283c:	a3 48 50 80 00       	mov    %eax,0x805048
  802841:	a1 48 50 80 00       	mov    0x805048,%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	75 8a                	jne    8027d4 <print_mem_block_lists+0xf2>
  80284a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284e:	75 84                	jne    8027d4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802850:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802854:	75 10                	jne    802866 <print_mem_block_lists+0x184>
  802856:	83 ec 0c             	sub    $0xc,%esp
  802859:	68 b0 4b 80 00       	push   $0x804bb0
  80285e:	e8 d8 e6 ff ff       	call   800f3b <cprintf>
  802863:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802866:	83 ec 0c             	sub    $0xc,%esp
  802869:	68 24 4b 80 00       	push   $0x804b24
  80286e:	e8 c8 e6 ff ff       	call   800f3b <cprintf>
  802873:	83 c4 10             	add    $0x10,%esp

}
  802876:	90                   	nop
  802877:	c9                   	leave  
  802878:	c3                   	ret    

00802879 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802879:	55                   	push   %ebp
  80287a:	89 e5                	mov    %esp,%ebp
  80287c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80287f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802886:	00 00 00 
  802889:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802890:	00 00 00 
  802893:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80289a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80289d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028a4:	e9 9e 00 00 00       	jmp    802947 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8028a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b1:	c1 e2 04             	shl    $0x4,%edx
  8028b4:	01 d0                	add    %edx,%eax
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	75 14                	jne    8028ce <initialize_MemBlocksList+0x55>
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	68 d8 4b 80 00       	push   $0x804bd8
  8028c2:	6a 46                	push   $0x46
  8028c4:	68 fb 4b 80 00       	push   $0x804bfb
  8028c9:	e8 b9 e3 ff ff       	call   800c87 <_panic>
  8028ce:	a1 50 50 80 00       	mov    0x805050,%eax
  8028d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d6:	c1 e2 04             	shl    $0x4,%edx
  8028d9:	01 d0                	add    %edx,%eax
  8028db:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028e1:	89 10                	mov    %edx,(%eax)
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	85 c0                	test   %eax,%eax
  8028e7:	74 18                	je     802901 <initialize_MemBlocksList+0x88>
  8028e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8028ee:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028f4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028f7:	c1 e1 04             	shl    $0x4,%ecx
  8028fa:	01 ca                	add    %ecx,%edx
  8028fc:	89 50 04             	mov    %edx,0x4(%eax)
  8028ff:	eb 12                	jmp    802913 <initialize_MemBlocksList+0x9a>
  802901:	a1 50 50 80 00       	mov    0x805050,%eax
  802906:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802909:	c1 e2 04             	shl    $0x4,%edx
  80290c:	01 d0                	add    %edx,%eax
  80290e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802913:	a1 50 50 80 00       	mov    0x805050,%eax
  802918:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291b:	c1 e2 04             	shl    $0x4,%edx
  80291e:	01 d0                	add    %edx,%eax
  802920:	a3 48 51 80 00       	mov    %eax,0x805148
  802925:	a1 50 50 80 00       	mov    0x805050,%eax
  80292a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292d:	c1 e2 04             	shl    $0x4,%edx
  802930:	01 d0                	add    %edx,%eax
  802932:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802939:	a1 54 51 80 00       	mov    0x805154,%eax
  80293e:	40                   	inc    %eax
  80293f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802944:	ff 45 f4             	incl   -0xc(%ebp)
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294d:	0f 82 56 ff ff ff    	jb     8028a9 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802953:	90                   	nop
  802954:	c9                   	leave  
  802955:	c3                   	ret    

00802956 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802964:	eb 19                	jmp    80297f <find_block+0x29>
	{
		if(va==point->sva)
  802966:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802969:	8b 40 08             	mov    0x8(%eax),%eax
  80296c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80296f:	75 05                	jne    802976 <find_block+0x20>
		   return point;
  802971:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802974:	eb 36                	jmp    8029ac <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	8b 40 08             	mov    0x8(%eax),%eax
  80297c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80297f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802983:	74 07                	je     80298c <find_block+0x36>
  802985:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	eb 05                	jmp    802991 <find_block+0x3b>
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
  802991:	8b 55 08             	mov    0x8(%ebp),%edx
  802994:	89 42 08             	mov    %eax,0x8(%edx)
  802997:	8b 45 08             	mov    0x8(%ebp),%eax
  80299a:	8b 40 08             	mov    0x8(%eax),%eax
  80299d:	85 c0                	test   %eax,%eax
  80299f:	75 c5                	jne    802966 <find_block+0x10>
  8029a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029a5:	75 bf                	jne    802966 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8029a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

008029ae <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
  8029b1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8029b4:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8029bc:	a1 44 50 80 00       	mov    0x805044,%eax
  8029c1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029ca:	74 24                	je     8029f0 <insert_sorted_allocList+0x42>
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	8b 50 08             	mov    0x8(%eax),%edx
  8029d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d5:	8b 40 08             	mov    0x8(%eax),%eax
  8029d8:	39 c2                	cmp    %eax,%edx
  8029da:	76 14                	jbe    8029f0 <insert_sorted_allocList+0x42>
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	8b 50 08             	mov    0x8(%eax),%edx
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	8b 40 08             	mov    0x8(%eax),%eax
  8029e8:	39 c2                	cmp    %eax,%edx
  8029ea:	0f 82 60 01 00 00    	jb     802b50 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8029f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f4:	75 65                	jne    802a5b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8029f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fa:	75 14                	jne    802a10 <insert_sorted_allocList+0x62>
  8029fc:	83 ec 04             	sub    $0x4,%esp
  8029ff:	68 d8 4b 80 00       	push   $0x804bd8
  802a04:	6a 6b                	push   $0x6b
  802a06:	68 fb 4b 80 00       	push   $0x804bfb
  802a0b:	e8 77 e2 ff ff       	call   800c87 <_panic>
  802a10:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	89 10                	mov    %edx,(%eax)
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	85 c0                	test   %eax,%eax
  802a22:	74 0d                	je     802a31 <insert_sorted_allocList+0x83>
  802a24:	a1 40 50 80 00       	mov    0x805040,%eax
  802a29:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2c:	89 50 04             	mov    %edx,0x4(%eax)
  802a2f:	eb 08                	jmp    802a39 <insert_sorted_allocList+0x8b>
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	a3 44 50 80 00       	mov    %eax,0x805044
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	a3 40 50 80 00       	mov    %eax,0x805040
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a50:	40                   	inc    %eax
  802a51:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a56:	e9 dc 01 00 00       	jmp    802c37 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	8b 50 08             	mov    0x8(%eax),%edx
  802a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a64:	8b 40 08             	mov    0x8(%eax),%eax
  802a67:	39 c2                	cmp    %eax,%edx
  802a69:	77 6c                	ja     802ad7 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a6f:	74 06                	je     802a77 <insert_sorted_allocList+0xc9>
  802a71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a75:	75 14                	jne    802a8b <insert_sorted_allocList+0xdd>
  802a77:	83 ec 04             	sub    $0x4,%esp
  802a7a:	68 14 4c 80 00       	push   $0x804c14
  802a7f:	6a 6f                	push   $0x6f
  802a81:	68 fb 4b 80 00       	push   $0x804bfb
  802a86:	e8 fc e1 ff ff       	call   800c87 <_panic>
  802a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8e:	8b 50 04             	mov    0x4(%eax),%edx
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	89 50 04             	mov    %edx,0x4(%eax)
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a9d:	89 10                	mov    %edx,(%eax)
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 0d                	je     802ab6 <insert_sorted_allocList+0x108>
  802aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab2:	89 10                	mov    %edx,(%eax)
  802ab4:	eb 08                	jmp    802abe <insert_sorted_allocList+0x110>
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	a3 40 50 80 00       	mov    %eax,0x805040
  802abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac4:	89 50 04             	mov    %edx,0x4(%eax)
  802ac7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802acc:	40                   	inc    %eax
  802acd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ad2:	e9 60 01 00 00       	jmp    802c37 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	8b 50 08             	mov    0x8(%eax),%edx
  802add:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae0:	8b 40 08             	mov    0x8(%eax),%eax
  802ae3:	39 c2                	cmp    %eax,%edx
  802ae5:	0f 82 4c 01 00 00    	jb     802c37 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802aeb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aef:	75 14                	jne    802b05 <insert_sorted_allocList+0x157>
  802af1:	83 ec 04             	sub    $0x4,%esp
  802af4:	68 4c 4c 80 00       	push   $0x804c4c
  802af9:	6a 73                	push   $0x73
  802afb:	68 fb 4b 80 00       	push   $0x804bfb
  802b00:	e8 82 e1 ff ff       	call   800c87 <_panic>
  802b05:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	89 50 04             	mov    %edx,0x4(%eax)
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	85 c0                	test   %eax,%eax
  802b19:	74 0c                	je     802b27 <insert_sorted_allocList+0x179>
  802b1b:	a1 44 50 80 00       	mov    0x805044,%eax
  802b20:	8b 55 08             	mov    0x8(%ebp),%edx
  802b23:	89 10                	mov    %edx,(%eax)
  802b25:	eb 08                	jmp    802b2f <insert_sorted_allocList+0x181>
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	a3 40 50 80 00       	mov    %eax,0x805040
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	a3 44 50 80 00       	mov    %eax,0x805044
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b40:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b45:	40                   	inc    %eax
  802b46:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b4b:	e9 e7 00 00 00       	jmp    802c37 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b56:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b5d:	a1 40 50 80 00       	mov    0x805040,%eax
  802b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b65:	e9 9d 00 00 00       	jmp    802c07 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 00                	mov    (%eax),%eax
  802b6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 50 08             	mov    0x8(%eax),%edx
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 40 08             	mov    0x8(%eax),%eax
  802b7e:	39 c2                	cmp    %eax,%edx
  802b80:	76 7d                	jbe    802bff <insert_sorted_allocList+0x251>
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 50 08             	mov    0x8(%eax),%edx
  802b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8b:	8b 40 08             	mov    0x8(%eax),%eax
  802b8e:	39 c2                	cmp    %eax,%edx
  802b90:	73 6d                	jae    802bff <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b96:	74 06                	je     802b9e <insert_sorted_allocList+0x1f0>
  802b98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b9c:	75 14                	jne    802bb2 <insert_sorted_allocList+0x204>
  802b9e:	83 ec 04             	sub    $0x4,%esp
  802ba1:	68 70 4c 80 00       	push   $0x804c70
  802ba6:	6a 7f                	push   $0x7f
  802ba8:	68 fb 4b 80 00       	push   $0x804bfb
  802bad:	e8 d5 e0 ff ff       	call   800c87 <_panic>
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 10                	mov    (%eax),%edx
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	89 10                	mov    %edx,(%eax)
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	74 0b                	je     802bd0 <insert_sorted_allocList+0x222>
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcd:	89 50 04             	mov    %edx,0x4(%eax)
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd6:	89 10                	mov    %edx,(%eax)
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bde:	89 50 04             	mov    %edx,0x4(%eax)
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 00                	mov    (%eax),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	75 08                	jne    802bf2 <insert_sorted_allocList+0x244>
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	a3 44 50 80 00       	mov    %eax,0x805044
  802bf2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bf7:	40                   	inc    %eax
  802bf8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802bfd:	eb 39                	jmp    802c38 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802bff:	a1 48 50 80 00       	mov    0x805048,%eax
  802c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0b:	74 07                	je     802c14 <insert_sorted_allocList+0x266>
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 00                	mov    (%eax),%eax
  802c12:	eb 05                	jmp    802c19 <insert_sorted_allocList+0x26b>
  802c14:	b8 00 00 00 00       	mov    $0x0,%eax
  802c19:	a3 48 50 80 00       	mov    %eax,0x805048
  802c1e:	a1 48 50 80 00       	mov    0x805048,%eax
  802c23:	85 c0                	test   %eax,%eax
  802c25:	0f 85 3f ff ff ff    	jne    802b6a <insert_sorted_allocList+0x1bc>
  802c2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2f:	0f 85 35 ff ff ff    	jne    802b6a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c35:	eb 01                	jmp    802c38 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c37:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c38:	90                   	nop
  802c39:	c9                   	leave  
  802c3a:	c3                   	ret    

00802c3b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c3b:	55                   	push   %ebp
  802c3c:	89 e5                	mov    %esp,%ebp
  802c3e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c41:	a1 38 51 80 00       	mov    0x805138,%eax
  802c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c49:	e9 85 01 00 00       	jmp    802dd3 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 40 0c             	mov    0xc(%eax),%eax
  802c54:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c57:	0f 82 6e 01 00 00    	jb     802dcb <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 0c             	mov    0xc(%eax),%eax
  802c63:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c66:	0f 85 8a 00 00 00    	jne    802cf6 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c70:	75 17                	jne    802c89 <alloc_block_FF+0x4e>
  802c72:	83 ec 04             	sub    $0x4,%esp
  802c75:	68 a4 4c 80 00       	push   $0x804ca4
  802c7a:	68 93 00 00 00       	push   $0x93
  802c7f:	68 fb 4b 80 00       	push   $0x804bfb
  802c84:	e8 fe df ff ff       	call   800c87 <_panic>
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	85 c0                	test   %eax,%eax
  802c90:	74 10                	je     802ca2 <alloc_block_FF+0x67>
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 00                	mov    (%eax),%eax
  802c97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c9a:	8b 52 04             	mov    0x4(%edx),%edx
  802c9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ca0:	eb 0b                	jmp    802cad <alloc_block_FF+0x72>
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 40 04             	mov    0x4(%eax),%eax
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	74 0f                	je     802cc6 <alloc_block_FF+0x8b>
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 40 04             	mov    0x4(%eax),%eax
  802cbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc0:	8b 12                	mov    (%edx),%edx
  802cc2:	89 10                	mov    %edx,(%eax)
  802cc4:	eb 0a                	jmp    802cd0 <alloc_block_FF+0x95>
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 00                	mov    (%eax),%eax
  802ccb:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ce8:	48                   	dec    %eax
  802ce9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	e9 10 01 00 00       	jmp    802e06 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cff:	0f 86 c6 00 00 00    	jbe    802dcb <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d05:	a1 48 51 80 00       	mov    0x805148,%eax
  802d0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	8b 50 08             	mov    0x8(%eax),%edx
  802d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d16:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d26:	75 17                	jne    802d3f <alloc_block_FF+0x104>
  802d28:	83 ec 04             	sub    $0x4,%esp
  802d2b:	68 a4 4c 80 00       	push   $0x804ca4
  802d30:	68 9b 00 00 00       	push   $0x9b
  802d35:	68 fb 4b 80 00       	push   $0x804bfb
  802d3a:	e8 48 df ff ff       	call   800c87 <_panic>
  802d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d42:	8b 00                	mov    (%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 10                	je     802d58 <alloc_block_FF+0x11d>
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	8b 00                	mov    (%eax),%eax
  802d4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d50:	8b 52 04             	mov    0x4(%edx),%edx
  802d53:	89 50 04             	mov    %edx,0x4(%eax)
  802d56:	eb 0b                	jmp    802d63 <alloc_block_FF+0x128>
  802d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5b:	8b 40 04             	mov    0x4(%eax),%eax
  802d5e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	8b 40 04             	mov    0x4(%eax),%eax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	74 0f                	je     802d7c <alloc_block_FF+0x141>
  802d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d70:	8b 40 04             	mov    0x4(%eax),%eax
  802d73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d76:	8b 12                	mov    (%edx),%edx
  802d78:	89 10                	mov    %edx,(%eax)
  802d7a:	eb 0a                	jmp    802d86 <alloc_block_FF+0x14b>
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	8b 00                	mov    (%eax),%eax
  802d81:	a3 48 51 80 00       	mov    %eax,0x805148
  802d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d99:	a1 54 51 80 00       	mov    0x805154,%eax
  802d9e:	48                   	dec    %eax
  802d9f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 50 08             	mov    0x8(%eax),%edx
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	01 c2                	add    %eax,%edx
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbb:	2b 45 08             	sub    0x8(%ebp),%eax
  802dbe:	89 c2                	mov    %eax,%edx
  802dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc9:	eb 3b                	jmp    802e06 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802dcb:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd7:	74 07                	je     802de0 <alloc_block_FF+0x1a5>
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 00                	mov    (%eax),%eax
  802dde:	eb 05                	jmp    802de5 <alloc_block_FF+0x1aa>
  802de0:	b8 00 00 00 00       	mov    $0x0,%eax
  802de5:	a3 40 51 80 00       	mov    %eax,0x805140
  802dea:	a1 40 51 80 00       	mov    0x805140,%eax
  802def:	85 c0                	test   %eax,%eax
  802df1:	0f 85 57 fe ff ff    	jne    802c4e <alloc_block_FF+0x13>
  802df7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfb:	0f 85 4d fe ff ff    	jne    802c4e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e06:	c9                   	leave  
  802e07:	c3                   	ret    

00802e08 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e08:	55                   	push   %ebp
  802e09:	89 e5                	mov    %esp,%ebp
  802e0b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802e0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e15:	a1 38 51 80 00       	mov    0x805138,%eax
  802e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1d:	e9 df 00 00 00       	jmp    802f01 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 40 0c             	mov    0xc(%eax),%eax
  802e28:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e2b:	0f 82 c8 00 00 00    	jb     802ef9 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e3a:	0f 85 8a 00 00 00    	jne    802eca <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802e40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e44:	75 17                	jne    802e5d <alloc_block_BF+0x55>
  802e46:	83 ec 04             	sub    $0x4,%esp
  802e49:	68 a4 4c 80 00       	push   $0x804ca4
  802e4e:	68 b7 00 00 00       	push   $0xb7
  802e53:	68 fb 4b 80 00       	push   $0x804bfb
  802e58:	e8 2a de ff ff       	call   800c87 <_panic>
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	85 c0                	test   %eax,%eax
  802e64:	74 10                	je     802e76 <alloc_block_BF+0x6e>
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6e:	8b 52 04             	mov    0x4(%edx),%edx
  802e71:	89 50 04             	mov    %edx,0x4(%eax)
  802e74:	eb 0b                	jmp    802e81 <alloc_block_BF+0x79>
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 40 04             	mov    0x4(%eax),%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	74 0f                	je     802e9a <alloc_block_BF+0x92>
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e94:	8b 12                	mov    (%edx),%edx
  802e96:	89 10                	mov    %edx,(%eax)
  802e98:	eb 0a                	jmp    802ea4 <alloc_block_BF+0x9c>
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 00                	mov    (%eax),%eax
  802e9f:	a3 38 51 80 00       	mov    %eax,0x805138
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb7:	a1 44 51 80 00       	mov    0x805144,%eax
  802ebc:	48                   	dec    %eax
  802ebd:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	e9 4d 01 00 00       	jmp    803017 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed3:	76 24                	jbe    802ef9 <alloc_block_BF+0xf1>
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 40 0c             	mov    0xc(%eax),%eax
  802edb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ede:	73 19                	jae    802ef9 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ee0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 40 0c             	mov    0xc(%eax),%eax
  802eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 40 08             	mov    0x8(%eax),%eax
  802ef6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ef9:	a1 40 51 80 00       	mov    0x805140,%eax
  802efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f05:	74 07                	je     802f0e <alloc_block_BF+0x106>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	eb 05                	jmp    802f13 <alloc_block_BF+0x10b>
  802f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f13:	a3 40 51 80 00       	mov    %eax,0x805140
  802f18:	a1 40 51 80 00       	mov    0x805140,%eax
  802f1d:	85 c0                	test   %eax,%eax
  802f1f:	0f 85 fd fe ff ff    	jne    802e22 <alloc_block_BF+0x1a>
  802f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f29:	0f 85 f3 fe ff ff    	jne    802e22 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802f2f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f33:	0f 84 d9 00 00 00    	je     803012 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f39:	a1 48 51 80 00       	mov    0x805148,%eax
  802f3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f44:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f47:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f50:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f57:	75 17                	jne    802f70 <alloc_block_BF+0x168>
  802f59:	83 ec 04             	sub    $0x4,%esp
  802f5c:	68 a4 4c 80 00       	push   $0x804ca4
  802f61:	68 c7 00 00 00       	push   $0xc7
  802f66:	68 fb 4b 80 00       	push   $0x804bfb
  802f6b:	e8 17 dd ff ff       	call   800c87 <_panic>
  802f70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 10                	je     802f89 <alloc_block_BF+0x181>
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f81:	8b 52 04             	mov    0x4(%edx),%edx
  802f84:	89 50 04             	mov    %edx,0x4(%eax)
  802f87:	eb 0b                	jmp    802f94 <alloc_block_BF+0x18c>
  802f89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f97:	8b 40 04             	mov    0x4(%eax),%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	74 0f                	je     802fad <alloc_block_BF+0x1a5>
  802f9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa1:	8b 40 04             	mov    0x4(%eax),%eax
  802fa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fa7:	8b 12                	mov    (%edx),%edx
  802fa9:	89 10                	mov    %edx,(%eax)
  802fab:	eb 0a                	jmp    802fb7 <alloc_block_BF+0x1af>
  802fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	a3 48 51 80 00       	mov    %eax,0x805148
  802fb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fca:	a1 54 51 80 00       	mov    0x805154,%eax
  802fcf:	48                   	dec    %eax
  802fd0:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802fd5:	83 ec 08             	sub    $0x8,%esp
  802fd8:	ff 75 ec             	pushl  -0x14(%ebp)
  802fdb:	68 38 51 80 00       	push   $0x805138
  802fe0:	e8 71 f9 ff ff       	call   802956 <find_block>
  802fe5:	83 c4 10             	add    $0x10,%esp
  802fe8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802feb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fee:	8b 50 08             	mov    0x8(%eax),%edx
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	01 c2                	add    %eax,%edx
  802ff6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff9:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ffc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fff:	8b 40 0c             	mov    0xc(%eax),%eax
  803002:	2b 45 08             	sub    0x8(%ebp),%eax
  803005:	89 c2                	mov    %eax,%edx
  803007:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80300d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803010:	eb 05                	jmp    803017 <alloc_block_BF+0x20f>
	}
	return NULL;
  803012:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803017:	c9                   	leave  
  803018:	c3                   	ret    

00803019 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803019:	55                   	push   %ebp
  80301a:	89 e5                	mov    %esp,%ebp
  80301c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80301f:	a1 28 50 80 00       	mov    0x805028,%eax
  803024:	85 c0                	test   %eax,%eax
  803026:	0f 85 de 01 00 00    	jne    80320a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80302c:	a1 38 51 80 00       	mov    0x805138,%eax
  803031:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803034:	e9 9e 01 00 00       	jmp    8031d7 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	8b 40 0c             	mov    0xc(%eax),%eax
  80303f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803042:	0f 82 87 01 00 00    	jb     8031cf <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 40 0c             	mov    0xc(%eax),%eax
  80304e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803051:	0f 85 95 00 00 00    	jne    8030ec <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803057:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305b:	75 17                	jne    803074 <alloc_block_NF+0x5b>
  80305d:	83 ec 04             	sub    $0x4,%esp
  803060:	68 a4 4c 80 00       	push   $0x804ca4
  803065:	68 e0 00 00 00       	push   $0xe0
  80306a:	68 fb 4b 80 00       	push   $0x804bfb
  80306f:	e8 13 dc ff ff       	call   800c87 <_panic>
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	74 10                	je     80308d <alloc_block_NF+0x74>
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803085:	8b 52 04             	mov    0x4(%edx),%edx
  803088:	89 50 04             	mov    %edx,0x4(%eax)
  80308b:	eb 0b                	jmp    803098 <alloc_block_NF+0x7f>
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803090:	8b 40 04             	mov    0x4(%eax),%eax
  803093:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	8b 40 04             	mov    0x4(%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 0f                	je     8030b1 <alloc_block_NF+0x98>
  8030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a5:	8b 40 04             	mov    0x4(%eax),%eax
  8030a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ab:	8b 12                	mov    (%edx),%edx
  8030ad:	89 10                	mov    %edx,(%eax)
  8030af:	eb 0a                	jmp    8030bb <alloc_block_NF+0xa2>
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d3:	48                   	dec    %eax
  8030d4:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 40 08             	mov    0x8(%eax),%eax
  8030df:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	e9 f8 04 00 00       	jmp    8035e4 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f5:	0f 86 d4 00 00 00    	jbe    8031cf <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030fb:	a1 48 51 80 00       	mov    0x805148,%eax
  803100:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	8b 50 08             	mov    0x8(%eax),%edx
  803109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	8b 55 08             	mov    0x8(%ebp),%edx
  803115:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803118:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80311c:	75 17                	jne    803135 <alloc_block_NF+0x11c>
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	68 a4 4c 80 00       	push   $0x804ca4
  803126:	68 e9 00 00 00       	push   $0xe9
  80312b:	68 fb 4b 80 00       	push   $0x804bfb
  803130:	e8 52 db ff ff       	call   800c87 <_panic>
  803135:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803138:	8b 00                	mov    (%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 10                	je     80314e <alloc_block_NF+0x135>
  80313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803146:	8b 52 04             	mov    0x4(%edx),%edx
  803149:	89 50 04             	mov    %edx,0x4(%eax)
  80314c:	eb 0b                	jmp    803159 <alloc_block_NF+0x140>
  80314e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803151:	8b 40 04             	mov    0x4(%eax),%eax
  803154:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315c:	8b 40 04             	mov    0x4(%eax),%eax
  80315f:	85 c0                	test   %eax,%eax
  803161:	74 0f                	je     803172 <alloc_block_NF+0x159>
  803163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803166:	8b 40 04             	mov    0x4(%eax),%eax
  803169:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80316c:	8b 12                	mov    (%edx),%edx
  80316e:	89 10                	mov    %edx,(%eax)
  803170:	eb 0a                	jmp    80317c <alloc_block_NF+0x163>
  803172:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803175:	8b 00                	mov    (%eax),%eax
  803177:	a3 48 51 80 00       	mov    %eax,0x805148
  80317c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803188:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318f:	a1 54 51 80 00       	mov    0x805154,%eax
  803194:	48                   	dec    %eax
  803195:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319d:	8b 40 08             	mov    0x8(%eax),%eax
  8031a0:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 50 08             	mov    0x8(%eax),%edx
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	01 c2                	add    %eax,%edx
  8031b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b3:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8031bf:	89 c2                	mov    %eax,%edx
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8031c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ca:	e9 15 04 00 00       	jmp    8035e4 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8031cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8031d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031db:	74 07                	je     8031e4 <alloc_block_NF+0x1cb>
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	eb 05                	jmp    8031e9 <alloc_block_NF+0x1d0>
  8031e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e9:	a3 40 51 80 00       	mov    %eax,0x805140
  8031ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f3:	85 c0                	test   %eax,%eax
  8031f5:	0f 85 3e fe ff ff    	jne    803039 <alloc_block_NF+0x20>
  8031fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ff:	0f 85 34 fe ff ff    	jne    803039 <alloc_block_NF+0x20>
  803205:	e9 d5 03 00 00       	jmp    8035df <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80320a:	a1 38 51 80 00       	mov    0x805138,%eax
  80320f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803212:	e9 b1 01 00 00       	jmp    8033c8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321a:	8b 50 08             	mov    0x8(%eax),%edx
  80321d:	a1 28 50 80 00       	mov    0x805028,%eax
  803222:	39 c2                	cmp    %eax,%edx
  803224:	0f 82 96 01 00 00    	jb     8033c0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	8b 40 0c             	mov    0xc(%eax),%eax
  803230:	3b 45 08             	cmp    0x8(%ebp),%eax
  803233:	0f 82 87 01 00 00    	jb     8033c0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	8b 40 0c             	mov    0xc(%eax),%eax
  80323f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803242:	0f 85 95 00 00 00    	jne    8032dd <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324c:	75 17                	jne    803265 <alloc_block_NF+0x24c>
  80324e:	83 ec 04             	sub    $0x4,%esp
  803251:	68 a4 4c 80 00       	push   $0x804ca4
  803256:	68 fc 00 00 00       	push   $0xfc
  80325b:	68 fb 4b 80 00       	push   $0x804bfb
  803260:	e8 22 da ff ff       	call   800c87 <_panic>
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 10                	je     80327e <alloc_block_NF+0x265>
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803276:	8b 52 04             	mov    0x4(%edx),%edx
  803279:	89 50 04             	mov    %edx,0x4(%eax)
  80327c:	eb 0b                	jmp    803289 <alloc_block_NF+0x270>
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 40 04             	mov    0x4(%eax),%eax
  803284:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	85 c0                	test   %eax,%eax
  803291:	74 0f                	je     8032a2 <alloc_block_NF+0x289>
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	8b 40 04             	mov    0x4(%eax),%eax
  803299:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80329c:	8b 12                	mov    (%edx),%edx
  80329e:	89 10                	mov    %edx,(%eax)
  8032a0:	eb 0a                	jmp    8032ac <alloc_block_NF+0x293>
  8032a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a5:	8b 00                	mov    (%eax),%eax
  8032a7:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8032c4:	48                   	dec    %eax
  8032c5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	8b 40 08             	mov    0x8(%eax),%eax
  8032d0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	e9 07 03 00 00       	jmp    8035e4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032e6:	0f 86 d4 00 00 00    	jbe    8033c0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8032f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f7:	8b 50 08             	mov    0x8(%eax),%edx
  8032fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fd:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803300:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803303:	8b 55 08             	mov    0x8(%ebp),%edx
  803306:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803309:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80330d:	75 17                	jne    803326 <alloc_block_NF+0x30d>
  80330f:	83 ec 04             	sub    $0x4,%esp
  803312:	68 a4 4c 80 00       	push   $0x804ca4
  803317:	68 04 01 00 00       	push   $0x104
  80331c:	68 fb 4b 80 00       	push   $0x804bfb
  803321:	e8 61 d9 ff ff       	call   800c87 <_panic>
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	74 10                	je     80333f <alloc_block_NF+0x326>
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803337:	8b 52 04             	mov    0x4(%edx),%edx
  80333a:	89 50 04             	mov    %edx,0x4(%eax)
  80333d:	eb 0b                	jmp    80334a <alloc_block_NF+0x331>
  80333f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803342:	8b 40 04             	mov    0x4(%eax),%eax
  803345:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334d:	8b 40 04             	mov    0x4(%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 0f                	je     803363 <alloc_block_NF+0x34a>
  803354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803357:	8b 40 04             	mov    0x4(%eax),%eax
  80335a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335d:	8b 12                	mov    (%edx),%edx
  80335f:	89 10                	mov    %edx,(%eax)
  803361:	eb 0a                	jmp    80336d <alloc_block_NF+0x354>
  803363:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803366:	8b 00                	mov    (%eax),%eax
  803368:	a3 48 51 80 00       	mov    %eax,0x805148
  80336d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803370:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803376:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803379:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803380:	a1 54 51 80 00       	mov    0x805154,%eax
  803385:	48                   	dec    %eax
  803386:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	8b 40 08             	mov    0x8(%eax),%eax
  803391:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803399:	8b 50 08             	mov    0x8(%eax),%edx
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	01 c2                	add    %eax,%edx
  8033a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ad:	2b 45 08             	sub    0x8(%ebp),%eax
  8033b0:	89 c2                	mov    %eax,%edx
  8033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bb:	e9 24 02 00 00       	jmp    8035e4 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033cc:	74 07                	je     8033d5 <alloc_block_NF+0x3bc>
  8033ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d1:	8b 00                	mov    (%eax),%eax
  8033d3:	eb 05                	jmp    8033da <alloc_block_NF+0x3c1>
  8033d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033da:	a3 40 51 80 00       	mov    %eax,0x805140
  8033df:	a1 40 51 80 00       	mov    0x805140,%eax
  8033e4:	85 c0                	test   %eax,%eax
  8033e6:	0f 85 2b fe ff ff    	jne    803217 <alloc_block_NF+0x1fe>
  8033ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f0:	0f 85 21 fe ff ff    	jne    803217 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8033fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033fe:	e9 ae 01 00 00       	jmp    8035b1 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	8b 50 08             	mov    0x8(%eax),%edx
  803409:	a1 28 50 80 00       	mov    0x805028,%eax
  80340e:	39 c2                	cmp    %eax,%edx
  803410:	0f 83 93 01 00 00    	jae    8035a9 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803419:	8b 40 0c             	mov    0xc(%eax),%eax
  80341c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80341f:	0f 82 84 01 00 00    	jb     8035a9 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803428:	8b 40 0c             	mov    0xc(%eax),%eax
  80342b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80342e:	0f 85 95 00 00 00    	jne    8034c9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803438:	75 17                	jne    803451 <alloc_block_NF+0x438>
  80343a:	83 ec 04             	sub    $0x4,%esp
  80343d:	68 a4 4c 80 00       	push   $0x804ca4
  803442:	68 14 01 00 00       	push   $0x114
  803447:	68 fb 4b 80 00       	push   $0x804bfb
  80344c:	e8 36 d8 ff ff       	call   800c87 <_panic>
  803451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803454:	8b 00                	mov    (%eax),%eax
  803456:	85 c0                	test   %eax,%eax
  803458:	74 10                	je     80346a <alloc_block_NF+0x451>
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803462:	8b 52 04             	mov    0x4(%edx),%edx
  803465:	89 50 04             	mov    %edx,0x4(%eax)
  803468:	eb 0b                	jmp    803475 <alloc_block_NF+0x45c>
  80346a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346d:	8b 40 04             	mov    0x4(%eax),%eax
  803470:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803478:	8b 40 04             	mov    0x4(%eax),%eax
  80347b:	85 c0                	test   %eax,%eax
  80347d:	74 0f                	je     80348e <alloc_block_NF+0x475>
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	8b 40 04             	mov    0x4(%eax),%eax
  803485:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803488:	8b 12                	mov    (%edx),%edx
  80348a:	89 10                	mov    %edx,(%eax)
  80348c:	eb 0a                	jmp    803498 <alloc_block_NF+0x47f>
  80348e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803491:	8b 00                	mov    (%eax),%eax
  803493:	a3 38 51 80 00       	mov    %eax,0x805138
  803498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8034b0:	48                   	dec    %eax
  8034b1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8034b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b9:	8b 40 08             	mov    0x8(%eax),%eax
  8034bc:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8034c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c4:	e9 1b 01 00 00       	jmp    8035e4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8034cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034d2:	0f 86 d1 00 00 00    	jbe    8035a9 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8034d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8034dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	8b 50 08             	mov    0x8(%eax),%edx
  8034e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8034ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8034f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034f9:	75 17                	jne    803512 <alloc_block_NF+0x4f9>
  8034fb:	83 ec 04             	sub    $0x4,%esp
  8034fe:	68 a4 4c 80 00       	push   $0x804ca4
  803503:	68 1c 01 00 00       	push   $0x11c
  803508:	68 fb 4b 80 00       	push   $0x804bfb
  80350d:	e8 75 d7 ff ff       	call   800c87 <_panic>
  803512:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803515:	8b 00                	mov    (%eax),%eax
  803517:	85 c0                	test   %eax,%eax
  803519:	74 10                	je     80352b <alloc_block_NF+0x512>
  80351b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351e:	8b 00                	mov    (%eax),%eax
  803520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803523:	8b 52 04             	mov    0x4(%edx),%edx
  803526:	89 50 04             	mov    %edx,0x4(%eax)
  803529:	eb 0b                	jmp    803536 <alloc_block_NF+0x51d>
  80352b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352e:	8b 40 04             	mov    0x4(%eax),%eax
  803531:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803536:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803539:	8b 40 04             	mov    0x4(%eax),%eax
  80353c:	85 c0                	test   %eax,%eax
  80353e:	74 0f                	je     80354f <alloc_block_NF+0x536>
  803540:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803543:	8b 40 04             	mov    0x4(%eax),%eax
  803546:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803549:	8b 12                	mov    (%edx),%edx
  80354b:	89 10                	mov    %edx,(%eax)
  80354d:	eb 0a                	jmp    803559 <alloc_block_NF+0x540>
  80354f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803552:	8b 00                	mov    (%eax),%eax
  803554:	a3 48 51 80 00       	mov    %eax,0x805148
  803559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803562:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803565:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80356c:	a1 54 51 80 00       	mov    0x805154,%eax
  803571:	48                   	dec    %eax
  803572:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357a:	8b 40 08             	mov    0x8(%eax),%eax
  80357d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803585:	8b 50 08             	mov    0x8(%eax),%edx
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	01 c2                	add    %eax,%edx
  80358d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803590:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803596:	8b 40 0c             	mov    0xc(%eax),%eax
  803599:	2b 45 08             	sub    0x8(%ebp),%eax
  80359c:	89 c2                	mov    %eax,%edx
  80359e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8035a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a7:	eb 3b                	jmp    8035e4 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8035a9:	a1 40 51 80 00       	mov    0x805140,%eax
  8035ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b5:	74 07                	je     8035be <alloc_block_NF+0x5a5>
  8035b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ba:	8b 00                	mov    (%eax),%eax
  8035bc:	eb 05                	jmp    8035c3 <alloc_block_NF+0x5aa>
  8035be:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c3:	a3 40 51 80 00       	mov    %eax,0x805140
  8035c8:	a1 40 51 80 00       	mov    0x805140,%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	0f 85 2e fe ff ff    	jne    803403 <alloc_block_NF+0x3ea>
  8035d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d9:	0f 85 24 fe ff ff    	jne    803403 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8035df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035e4:	c9                   	leave  
  8035e5:	c3                   	ret    

008035e6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8035e6:	55                   	push   %ebp
  8035e7:	89 e5                	mov    %esp,%ebp
  8035e9:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8035ec:	a1 38 51 80 00       	mov    0x805138,%eax
  8035f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8035f4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035f9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8035fc:	a1 38 51 80 00       	mov    0x805138,%eax
  803601:	85 c0                	test   %eax,%eax
  803603:	74 14                	je     803619 <insert_sorted_with_merge_freeList+0x33>
  803605:	8b 45 08             	mov    0x8(%ebp),%eax
  803608:	8b 50 08             	mov    0x8(%eax),%edx
  80360b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360e:	8b 40 08             	mov    0x8(%eax),%eax
  803611:	39 c2                	cmp    %eax,%edx
  803613:	0f 87 9b 01 00 00    	ja     8037b4 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803619:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80361d:	75 17                	jne    803636 <insert_sorted_with_merge_freeList+0x50>
  80361f:	83 ec 04             	sub    $0x4,%esp
  803622:	68 d8 4b 80 00       	push   $0x804bd8
  803627:	68 38 01 00 00       	push   $0x138
  80362c:	68 fb 4b 80 00       	push   $0x804bfb
  803631:	e8 51 d6 ff ff       	call   800c87 <_panic>
  803636:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80363c:	8b 45 08             	mov    0x8(%ebp),%eax
  80363f:	89 10                	mov    %edx,(%eax)
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	8b 00                	mov    (%eax),%eax
  803646:	85 c0                	test   %eax,%eax
  803648:	74 0d                	je     803657 <insert_sorted_with_merge_freeList+0x71>
  80364a:	a1 38 51 80 00       	mov    0x805138,%eax
  80364f:	8b 55 08             	mov    0x8(%ebp),%edx
  803652:	89 50 04             	mov    %edx,0x4(%eax)
  803655:	eb 08                	jmp    80365f <insert_sorted_with_merge_freeList+0x79>
  803657:	8b 45 08             	mov    0x8(%ebp),%eax
  80365a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	a3 38 51 80 00       	mov    %eax,0x805138
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803671:	a1 44 51 80 00       	mov    0x805144,%eax
  803676:	40                   	inc    %eax
  803677:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80367c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803680:	0f 84 a8 06 00 00    	je     803d2e <insert_sorted_with_merge_freeList+0x748>
  803686:	8b 45 08             	mov    0x8(%ebp),%eax
  803689:	8b 50 08             	mov    0x8(%eax),%edx
  80368c:	8b 45 08             	mov    0x8(%ebp),%eax
  80368f:	8b 40 0c             	mov    0xc(%eax),%eax
  803692:	01 c2                	add    %eax,%edx
  803694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803697:	8b 40 08             	mov    0x8(%eax),%eax
  80369a:	39 c2                	cmp    %eax,%edx
  80369c:	0f 85 8c 06 00 00    	jne    803d2e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	8b 50 0c             	mov    0xc(%eax),%edx
  8036a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ae:	01 c2                	add    %eax,%edx
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8036b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036ba:	75 17                	jne    8036d3 <insert_sorted_with_merge_freeList+0xed>
  8036bc:	83 ec 04             	sub    $0x4,%esp
  8036bf:	68 a4 4c 80 00       	push   $0x804ca4
  8036c4:	68 3c 01 00 00       	push   $0x13c
  8036c9:	68 fb 4b 80 00       	push   $0x804bfb
  8036ce:	e8 b4 d5 ff ff       	call   800c87 <_panic>
  8036d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d6:	8b 00                	mov    (%eax),%eax
  8036d8:	85 c0                	test   %eax,%eax
  8036da:	74 10                	je     8036ec <insert_sorted_with_merge_freeList+0x106>
  8036dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036df:	8b 00                	mov    (%eax),%eax
  8036e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e4:	8b 52 04             	mov    0x4(%edx),%edx
  8036e7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ea:	eb 0b                	jmp    8036f7 <insert_sorted_with_merge_freeList+0x111>
  8036ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ef:	8b 40 04             	mov    0x4(%eax),%eax
  8036f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036fa:	8b 40 04             	mov    0x4(%eax),%eax
  8036fd:	85 c0                	test   %eax,%eax
  8036ff:	74 0f                	je     803710 <insert_sorted_with_merge_freeList+0x12a>
  803701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803704:	8b 40 04             	mov    0x4(%eax),%eax
  803707:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80370a:	8b 12                	mov    (%edx),%edx
  80370c:	89 10                	mov    %edx,(%eax)
  80370e:	eb 0a                	jmp    80371a <insert_sorted_with_merge_freeList+0x134>
  803710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803713:	8b 00                	mov    (%eax),%eax
  803715:	a3 38 51 80 00       	mov    %eax,0x805138
  80371a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803726:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372d:	a1 44 51 80 00       	mov    0x805144,%eax
  803732:	48                   	dec    %eax
  803733:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803745:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80374c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803750:	75 17                	jne    803769 <insert_sorted_with_merge_freeList+0x183>
  803752:	83 ec 04             	sub    $0x4,%esp
  803755:	68 d8 4b 80 00       	push   $0x804bd8
  80375a:	68 3f 01 00 00       	push   $0x13f
  80375f:	68 fb 4b 80 00       	push   $0x804bfb
  803764:	e8 1e d5 ff ff       	call   800c87 <_panic>
  803769:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80376f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803772:	89 10                	mov    %edx,(%eax)
  803774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803777:	8b 00                	mov    (%eax),%eax
  803779:	85 c0                	test   %eax,%eax
  80377b:	74 0d                	je     80378a <insert_sorted_with_merge_freeList+0x1a4>
  80377d:	a1 48 51 80 00       	mov    0x805148,%eax
  803782:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803785:	89 50 04             	mov    %edx,0x4(%eax)
  803788:	eb 08                	jmp    803792 <insert_sorted_with_merge_freeList+0x1ac>
  80378a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803795:	a3 48 51 80 00       	mov    %eax,0x805148
  80379a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8037a9:	40                   	inc    %eax
  8037aa:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037af:	e9 7a 05 00 00       	jmp    803d2e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	8b 50 08             	mov    0x8(%eax),%edx
  8037ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037bd:	8b 40 08             	mov    0x8(%eax),%eax
  8037c0:	39 c2                	cmp    %eax,%edx
  8037c2:	0f 82 14 01 00 00    	jb     8038dc <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8037c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037cb:	8b 50 08             	mov    0x8(%eax),%edx
  8037ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d4:	01 c2                	add    %eax,%edx
  8037d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d9:	8b 40 08             	mov    0x8(%eax),%eax
  8037dc:	39 c2                	cmp    %eax,%edx
  8037de:	0f 85 90 00 00 00    	jne    803874 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8037e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f0:	01 c2                	add    %eax,%edx
  8037f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f5:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8037f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803802:	8b 45 08             	mov    0x8(%ebp),%eax
  803805:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80380c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803810:	75 17                	jne    803829 <insert_sorted_with_merge_freeList+0x243>
  803812:	83 ec 04             	sub    $0x4,%esp
  803815:	68 d8 4b 80 00       	push   $0x804bd8
  80381a:	68 49 01 00 00       	push   $0x149
  80381f:	68 fb 4b 80 00       	push   $0x804bfb
  803824:	e8 5e d4 ff ff       	call   800c87 <_panic>
  803829:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80382f:	8b 45 08             	mov    0x8(%ebp),%eax
  803832:	89 10                	mov    %edx,(%eax)
  803834:	8b 45 08             	mov    0x8(%ebp),%eax
  803837:	8b 00                	mov    (%eax),%eax
  803839:	85 c0                	test   %eax,%eax
  80383b:	74 0d                	je     80384a <insert_sorted_with_merge_freeList+0x264>
  80383d:	a1 48 51 80 00       	mov    0x805148,%eax
  803842:	8b 55 08             	mov    0x8(%ebp),%edx
  803845:	89 50 04             	mov    %edx,0x4(%eax)
  803848:	eb 08                	jmp    803852 <insert_sorted_with_merge_freeList+0x26c>
  80384a:	8b 45 08             	mov    0x8(%ebp),%eax
  80384d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803852:	8b 45 08             	mov    0x8(%ebp),%eax
  803855:	a3 48 51 80 00       	mov    %eax,0x805148
  80385a:	8b 45 08             	mov    0x8(%ebp),%eax
  80385d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803864:	a1 54 51 80 00       	mov    0x805154,%eax
  803869:	40                   	inc    %eax
  80386a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80386f:	e9 bb 04 00 00       	jmp    803d2f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803874:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803878:	75 17                	jne    803891 <insert_sorted_with_merge_freeList+0x2ab>
  80387a:	83 ec 04             	sub    $0x4,%esp
  80387d:	68 4c 4c 80 00       	push   $0x804c4c
  803882:	68 4c 01 00 00       	push   $0x14c
  803887:	68 fb 4b 80 00       	push   $0x804bfb
  80388c:	e8 f6 d3 ff ff       	call   800c87 <_panic>
  803891:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803897:	8b 45 08             	mov    0x8(%ebp),%eax
  80389a:	89 50 04             	mov    %edx,0x4(%eax)
  80389d:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a0:	8b 40 04             	mov    0x4(%eax),%eax
  8038a3:	85 c0                	test   %eax,%eax
  8038a5:	74 0c                	je     8038b3 <insert_sorted_with_merge_freeList+0x2cd>
  8038a7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8038ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8038af:	89 10                	mov    %edx,(%eax)
  8038b1:	eb 08                	jmp    8038bb <insert_sorted_with_merge_freeList+0x2d5>
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8038bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8038d1:	40                   	inc    %eax
  8038d2:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038d7:	e9 53 04 00 00       	jmp    803d2f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8038e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038e4:	e9 15 04 00 00       	jmp    803cfe <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8038e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ec:	8b 00                	mov    (%eax),%eax
  8038ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8038f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f4:	8b 50 08             	mov    0x8(%eax),%edx
  8038f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fa:	8b 40 08             	mov    0x8(%eax),%eax
  8038fd:	39 c2                	cmp    %eax,%edx
  8038ff:	0f 86 f1 03 00 00    	jbe    803cf6 <insert_sorted_with_merge_freeList+0x710>
  803905:	8b 45 08             	mov    0x8(%ebp),%eax
  803908:	8b 50 08             	mov    0x8(%eax),%edx
  80390b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390e:	8b 40 08             	mov    0x8(%eax),%eax
  803911:	39 c2                	cmp    %eax,%edx
  803913:	0f 83 dd 03 00 00    	jae    803cf6 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391c:	8b 50 08             	mov    0x8(%eax),%edx
  80391f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803922:	8b 40 0c             	mov    0xc(%eax),%eax
  803925:	01 c2                	add    %eax,%edx
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	8b 40 08             	mov    0x8(%eax),%eax
  80392d:	39 c2                	cmp    %eax,%edx
  80392f:	0f 85 b9 01 00 00    	jne    803aee <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803935:	8b 45 08             	mov    0x8(%ebp),%eax
  803938:	8b 50 08             	mov    0x8(%eax),%edx
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	8b 40 0c             	mov    0xc(%eax),%eax
  803941:	01 c2                	add    %eax,%edx
  803943:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803946:	8b 40 08             	mov    0x8(%eax),%eax
  803949:	39 c2                	cmp    %eax,%edx
  80394b:	0f 85 0d 01 00 00    	jne    803a5e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803954:	8b 50 0c             	mov    0xc(%eax),%edx
  803957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395a:	8b 40 0c             	mov    0xc(%eax),%eax
  80395d:	01 c2                	add    %eax,%edx
  80395f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803962:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803965:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803969:	75 17                	jne    803982 <insert_sorted_with_merge_freeList+0x39c>
  80396b:	83 ec 04             	sub    $0x4,%esp
  80396e:	68 a4 4c 80 00       	push   $0x804ca4
  803973:	68 5c 01 00 00       	push   $0x15c
  803978:	68 fb 4b 80 00       	push   $0x804bfb
  80397d:	e8 05 d3 ff ff       	call   800c87 <_panic>
  803982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803985:	8b 00                	mov    (%eax),%eax
  803987:	85 c0                	test   %eax,%eax
  803989:	74 10                	je     80399b <insert_sorted_with_merge_freeList+0x3b5>
  80398b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398e:	8b 00                	mov    (%eax),%eax
  803990:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803993:	8b 52 04             	mov    0x4(%edx),%edx
  803996:	89 50 04             	mov    %edx,0x4(%eax)
  803999:	eb 0b                	jmp    8039a6 <insert_sorted_with_merge_freeList+0x3c0>
  80399b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399e:	8b 40 04             	mov    0x4(%eax),%eax
  8039a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a9:	8b 40 04             	mov    0x4(%eax),%eax
  8039ac:	85 c0                	test   %eax,%eax
  8039ae:	74 0f                	je     8039bf <insert_sorted_with_merge_freeList+0x3d9>
  8039b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b3:	8b 40 04             	mov    0x4(%eax),%eax
  8039b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039b9:	8b 12                	mov    (%edx),%edx
  8039bb:	89 10                	mov    %edx,(%eax)
  8039bd:	eb 0a                	jmp    8039c9 <insert_sorted_with_merge_freeList+0x3e3>
  8039bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c2:	8b 00                	mov    (%eax),%eax
  8039c4:	a3 38 51 80 00       	mov    %eax,0x805138
  8039c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8039e1:	48                   	dec    %eax
  8039e2:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8039e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8039f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039ff:	75 17                	jne    803a18 <insert_sorted_with_merge_freeList+0x432>
  803a01:	83 ec 04             	sub    $0x4,%esp
  803a04:	68 d8 4b 80 00       	push   $0x804bd8
  803a09:	68 5f 01 00 00       	push   $0x15f
  803a0e:	68 fb 4b 80 00       	push   $0x804bfb
  803a13:	e8 6f d2 ff ff       	call   800c87 <_panic>
  803a18:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a21:	89 10                	mov    %edx,(%eax)
  803a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a26:	8b 00                	mov    (%eax),%eax
  803a28:	85 c0                	test   %eax,%eax
  803a2a:	74 0d                	je     803a39 <insert_sorted_with_merge_freeList+0x453>
  803a2c:	a1 48 51 80 00       	mov    0x805148,%eax
  803a31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a34:	89 50 04             	mov    %edx,0x4(%eax)
  803a37:	eb 08                	jmp    803a41 <insert_sorted_with_merge_freeList+0x45b>
  803a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a44:	a3 48 51 80 00       	mov    %eax,0x805148
  803a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a53:	a1 54 51 80 00       	mov    0x805154,%eax
  803a58:	40                   	inc    %eax
  803a59:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a61:	8b 50 0c             	mov    0xc(%eax),%edx
  803a64:	8b 45 08             	mov    0x8(%ebp),%eax
  803a67:	8b 40 0c             	mov    0xc(%eax),%eax
  803a6a:	01 c2                	add    %eax,%edx
  803a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a72:	8b 45 08             	mov    0x8(%ebp),%eax
  803a75:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a8a:	75 17                	jne    803aa3 <insert_sorted_with_merge_freeList+0x4bd>
  803a8c:	83 ec 04             	sub    $0x4,%esp
  803a8f:	68 d8 4b 80 00       	push   $0x804bd8
  803a94:	68 64 01 00 00       	push   $0x164
  803a99:	68 fb 4b 80 00       	push   $0x804bfb
  803a9e:	e8 e4 d1 ff ff       	call   800c87 <_panic>
  803aa3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aac:	89 10                	mov    %edx,(%eax)
  803aae:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab1:	8b 00                	mov    (%eax),%eax
  803ab3:	85 c0                	test   %eax,%eax
  803ab5:	74 0d                	je     803ac4 <insert_sorted_with_merge_freeList+0x4de>
  803ab7:	a1 48 51 80 00       	mov    0x805148,%eax
  803abc:	8b 55 08             	mov    0x8(%ebp),%edx
  803abf:	89 50 04             	mov    %edx,0x4(%eax)
  803ac2:	eb 08                	jmp    803acc <insert_sorted_with_merge_freeList+0x4e6>
  803ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803acc:	8b 45 08             	mov    0x8(%ebp),%eax
  803acf:	a3 48 51 80 00       	mov    %eax,0x805148
  803ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ade:	a1 54 51 80 00       	mov    0x805154,%eax
  803ae3:	40                   	inc    %eax
  803ae4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ae9:	e9 41 02 00 00       	jmp    803d2f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803aee:	8b 45 08             	mov    0x8(%ebp),%eax
  803af1:	8b 50 08             	mov    0x8(%eax),%edx
  803af4:	8b 45 08             	mov    0x8(%ebp),%eax
  803af7:	8b 40 0c             	mov    0xc(%eax),%eax
  803afa:	01 c2                	add    %eax,%edx
  803afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aff:	8b 40 08             	mov    0x8(%eax),%eax
  803b02:	39 c2                	cmp    %eax,%edx
  803b04:	0f 85 7c 01 00 00    	jne    803c86 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803b0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b0e:	74 06                	je     803b16 <insert_sorted_with_merge_freeList+0x530>
  803b10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b14:	75 17                	jne    803b2d <insert_sorted_with_merge_freeList+0x547>
  803b16:	83 ec 04             	sub    $0x4,%esp
  803b19:	68 14 4c 80 00       	push   $0x804c14
  803b1e:	68 69 01 00 00       	push   $0x169
  803b23:	68 fb 4b 80 00       	push   $0x804bfb
  803b28:	e8 5a d1 ff ff       	call   800c87 <_panic>
  803b2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b30:	8b 50 04             	mov    0x4(%eax),%edx
  803b33:	8b 45 08             	mov    0x8(%ebp),%eax
  803b36:	89 50 04             	mov    %edx,0x4(%eax)
  803b39:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b3f:	89 10                	mov    %edx,(%eax)
  803b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b44:	8b 40 04             	mov    0x4(%eax),%eax
  803b47:	85 c0                	test   %eax,%eax
  803b49:	74 0d                	je     803b58 <insert_sorted_with_merge_freeList+0x572>
  803b4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b4e:	8b 40 04             	mov    0x4(%eax),%eax
  803b51:	8b 55 08             	mov    0x8(%ebp),%edx
  803b54:	89 10                	mov    %edx,(%eax)
  803b56:	eb 08                	jmp    803b60 <insert_sorted_with_merge_freeList+0x57a>
  803b58:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5b:	a3 38 51 80 00       	mov    %eax,0x805138
  803b60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b63:	8b 55 08             	mov    0x8(%ebp),%edx
  803b66:	89 50 04             	mov    %edx,0x4(%eax)
  803b69:	a1 44 51 80 00       	mov    0x805144,%eax
  803b6e:	40                   	inc    %eax
  803b6f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b74:	8b 45 08             	mov    0x8(%ebp),%eax
  803b77:	8b 50 0c             	mov    0xc(%eax),%edx
  803b7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7d:	8b 40 0c             	mov    0xc(%eax),%eax
  803b80:	01 c2                	add    %eax,%edx
  803b82:	8b 45 08             	mov    0x8(%ebp),%eax
  803b85:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b8c:	75 17                	jne    803ba5 <insert_sorted_with_merge_freeList+0x5bf>
  803b8e:	83 ec 04             	sub    $0x4,%esp
  803b91:	68 a4 4c 80 00       	push   $0x804ca4
  803b96:	68 6b 01 00 00       	push   $0x16b
  803b9b:	68 fb 4b 80 00       	push   $0x804bfb
  803ba0:	e8 e2 d0 ff ff       	call   800c87 <_panic>
  803ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba8:	8b 00                	mov    (%eax),%eax
  803baa:	85 c0                	test   %eax,%eax
  803bac:	74 10                	je     803bbe <insert_sorted_with_merge_freeList+0x5d8>
  803bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb1:	8b 00                	mov    (%eax),%eax
  803bb3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bb6:	8b 52 04             	mov    0x4(%edx),%edx
  803bb9:	89 50 04             	mov    %edx,0x4(%eax)
  803bbc:	eb 0b                	jmp    803bc9 <insert_sorted_with_merge_freeList+0x5e3>
  803bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc1:	8b 40 04             	mov    0x4(%eax),%eax
  803bc4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bcc:	8b 40 04             	mov    0x4(%eax),%eax
  803bcf:	85 c0                	test   %eax,%eax
  803bd1:	74 0f                	je     803be2 <insert_sorted_with_merge_freeList+0x5fc>
  803bd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd6:	8b 40 04             	mov    0x4(%eax),%eax
  803bd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bdc:	8b 12                	mov    (%edx),%edx
  803bde:	89 10                	mov    %edx,(%eax)
  803be0:	eb 0a                	jmp    803bec <insert_sorted_with_merge_freeList+0x606>
  803be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be5:	8b 00                	mov    (%eax),%eax
  803be7:	a3 38 51 80 00       	mov    %eax,0x805138
  803bec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bff:	a1 44 51 80 00       	mov    0x805144,%eax
  803c04:	48                   	dec    %eax
  803c05:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803c0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c22:	75 17                	jne    803c3b <insert_sorted_with_merge_freeList+0x655>
  803c24:	83 ec 04             	sub    $0x4,%esp
  803c27:	68 d8 4b 80 00       	push   $0x804bd8
  803c2c:	68 6e 01 00 00       	push   $0x16e
  803c31:	68 fb 4b 80 00       	push   $0x804bfb
  803c36:	e8 4c d0 ff ff       	call   800c87 <_panic>
  803c3b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c44:	89 10                	mov    %edx,(%eax)
  803c46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c49:	8b 00                	mov    (%eax),%eax
  803c4b:	85 c0                	test   %eax,%eax
  803c4d:	74 0d                	je     803c5c <insert_sorted_with_merge_freeList+0x676>
  803c4f:	a1 48 51 80 00       	mov    0x805148,%eax
  803c54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c57:	89 50 04             	mov    %edx,0x4(%eax)
  803c5a:	eb 08                	jmp    803c64 <insert_sorted_with_merge_freeList+0x67e>
  803c5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c67:	a3 48 51 80 00       	mov    %eax,0x805148
  803c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c76:	a1 54 51 80 00       	mov    0x805154,%eax
  803c7b:	40                   	inc    %eax
  803c7c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c81:	e9 a9 00 00 00       	jmp    803d2f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c8a:	74 06                	je     803c92 <insert_sorted_with_merge_freeList+0x6ac>
  803c8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c90:	75 17                	jne    803ca9 <insert_sorted_with_merge_freeList+0x6c3>
  803c92:	83 ec 04             	sub    $0x4,%esp
  803c95:	68 70 4c 80 00       	push   $0x804c70
  803c9a:	68 73 01 00 00       	push   $0x173
  803c9f:	68 fb 4b 80 00       	push   $0x804bfb
  803ca4:	e8 de cf ff ff       	call   800c87 <_panic>
  803ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cac:	8b 10                	mov    (%eax),%edx
  803cae:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb1:	89 10                	mov    %edx,(%eax)
  803cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb6:	8b 00                	mov    (%eax),%eax
  803cb8:	85 c0                	test   %eax,%eax
  803cba:	74 0b                	je     803cc7 <insert_sorted_with_merge_freeList+0x6e1>
  803cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbf:	8b 00                	mov    (%eax),%eax
  803cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  803cc4:	89 50 04             	mov    %edx,0x4(%eax)
  803cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cca:	8b 55 08             	mov    0x8(%ebp),%edx
  803ccd:	89 10                	mov    %edx,(%eax)
  803ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cd5:	89 50 04             	mov    %edx,0x4(%eax)
  803cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdb:	8b 00                	mov    (%eax),%eax
  803cdd:	85 c0                	test   %eax,%eax
  803cdf:	75 08                	jne    803ce9 <insert_sorted_with_merge_freeList+0x703>
  803ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ce9:	a1 44 51 80 00       	mov    0x805144,%eax
  803cee:	40                   	inc    %eax
  803cef:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803cf4:	eb 39                	jmp    803d2f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803cf6:	a1 40 51 80 00       	mov    0x805140,%eax
  803cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d02:	74 07                	je     803d0b <insert_sorted_with_merge_freeList+0x725>
  803d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d07:	8b 00                	mov    (%eax),%eax
  803d09:	eb 05                	jmp    803d10 <insert_sorted_with_merge_freeList+0x72a>
  803d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d10:	a3 40 51 80 00       	mov    %eax,0x805140
  803d15:	a1 40 51 80 00       	mov    0x805140,%eax
  803d1a:	85 c0                	test   %eax,%eax
  803d1c:	0f 85 c7 fb ff ff    	jne    8038e9 <insert_sorted_with_merge_freeList+0x303>
  803d22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d26:	0f 85 bd fb ff ff    	jne    8038e9 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d2c:	eb 01                	jmp    803d2f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803d2e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d2f:	90                   	nop
  803d30:	c9                   	leave  
  803d31:	c3                   	ret    

00803d32 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803d32:	55                   	push   %ebp
  803d33:	89 e5                	mov    %esp,%ebp
  803d35:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803d38:	8b 55 08             	mov    0x8(%ebp),%edx
  803d3b:	89 d0                	mov    %edx,%eax
  803d3d:	c1 e0 02             	shl    $0x2,%eax
  803d40:	01 d0                	add    %edx,%eax
  803d42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d49:	01 d0                	add    %edx,%eax
  803d4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d52:	01 d0                	add    %edx,%eax
  803d54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d5b:	01 d0                	add    %edx,%eax
  803d5d:	c1 e0 04             	shl    $0x4,%eax
  803d60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803d63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803d6a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803d6d:	83 ec 0c             	sub    $0xc,%esp
  803d70:	50                   	push   %eax
  803d71:	e8 26 e7 ff ff       	call   80249c <sys_get_virtual_time>
  803d76:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803d79:	eb 41                	jmp    803dbc <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803d7b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803d7e:	83 ec 0c             	sub    $0xc,%esp
  803d81:	50                   	push   %eax
  803d82:	e8 15 e7 ff ff       	call   80249c <sys_get_virtual_time>
  803d87:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803d8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d90:	29 c2                	sub    %eax,%edx
  803d92:	89 d0                	mov    %edx,%eax
  803d94:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803d97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d9d:	89 d1                	mov    %edx,%ecx
  803d9f:	29 c1                	sub    %eax,%ecx
  803da1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803da4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803da7:	39 c2                	cmp    %eax,%edx
  803da9:	0f 97 c0             	seta   %al
  803dac:	0f b6 c0             	movzbl %al,%eax
  803daf:	29 c1                	sub    %eax,%ecx
  803db1:	89 c8                	mov    %ecx,%eax
  803db3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803db6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803dc2:	72 b7                	jb     803d7b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803dc4:	90                   	nop
  803dc5:	c9                   	leave  
  803dc6:	c3                   	ret    

00803dc7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803dc7:	55                   	push   %ebp
  803dc8:	89 e5                	mov    %esp,%ebp
  803dca:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803dcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803dd4:	eb 03                	jmp    803dd9 <busy_wait+0x12>
  803dd6:	ff 45 fc             	incl   -0x4(%ebp)
  803dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803ddc:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ddf:	72 f5                	jb     803dd6 <busy_wait+0xf>
	return i;
  803de1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803de4:	c9                   	leave  
  803de5:	c3                   	ret    
  803de6:	66 90                	xchg   %ax,%ax

00803de8 <__udivdi3>:
  803de8:	55                   	push   %ebp
  803de9:	57                   	push   %edi
  803dea:	56                   	push   %esi
  803deb:	53                   	push   %ebx
  803dec:	83 ec 1c             	sub    $0x1c,%esp
  803def:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803df3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803df7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dfb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803dff:	89 ca                	mov    %ecx,%edx
  803e01:	89 f8                	mov    %edi,%eax
  803e03:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e07:	85 f6                	test   %esi,%esi
  803e09:	75 2d                	jne    803e38 <__udivdi3+0x50>
  803e0b:	39 cf                	cmp    %ecx,%edi
  803e0d:	77 65                	ja     803e74 <__udivdi3+0x8c>
  803e0f:	89 fd                	mov    %edi,%ebp
  803e11:	85 ff                	test   %edi,%edi
  803e13:	75 0b                	jne    803e20 <__udivdi3+0x38>
  803e15:	b8 01 00 00 00       	mov    $0x1,%eax
  803e1a:	31 d2                	xor    %edx,%edx
  803e1c:	f7 f7                	div    %edi
  803e1e:	89 c5                	mov    %eax,%ebp
  803e20:	31 d2                	xor    %edx,%edx
  803e22:	89 c8                	mov    %ecx,%eax
  803e24:	f7 f5                	div    %ebp
  803e26:	89 c1                	mov    %eax,%ecx
  803e28:	89 d8                	mov    %ebx,%eax
  803e2a:	f7 f5                	div    %ebp
  803e2c:	89 cf                	mov    %ecx,%edi
  803e2e:	89 fa                	mov    %edi,%edx
  803e30:	83 c4 1c             	add    $0x1c,%esp
  803e33:	5b                   	pop    %ebx
  803e34:	5e                   	pop    %esi
  803e35:	5f                   	pop    %edi
  803e36:	5d                   	pop    %ebp
  803e37:	c3                   	ret    
  803e38:	39 ce                	cmp    %ecx,%esi
  803e3a:	77 28                	ja     803e64 <__udivdi3+0x7c>
  803e3c:	0f bd fe             	bsr    %esi,%edi
  803e3f:	83 f7 1f             	xor    $0x1f,%edi
  803e42:	75 40                	jne    803e84 <__udivdi3+0x9c>
  803e44:	39 ce                	cmp    %ecx,%esi
  803e46:	72 0a                	jb     803e52 <__udivdi3+0x6a>
  803e48:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e4c:	0f 87 9e 00 00 00    	ja     803ef0 <__udivdi3+0x108>
  803e52:	b8 01 00 00 00       	mov    $0x1,%eax
  803e57:	89 fa                	mov    %edi,%edx
  803e59:	83 c4 1c             	add    $0x1c,%esp
  803e5c:	5b                   	pop    %ebx
  803e5d:	5e                   	pop    %esi
  803e5e:	5f                   	pop    %edi
  803e5f:	5d                   	pop    %ebp
  803e60:	c3                   	ret    
  803e61:	8d 76 00             	lea    0x0(%esi),%esi
  803e64:	31 ff                	xor    %edi,%edi
  803e66:	31 c0                	xor    %eax,%eax
  803e68:	89 fa                	mov    %edi,%edx
  803e6a:	83 c4 1c             	add    $0x1c,%esp
  803e6d:	5b                   	pop    %ebx
  803e6e:	5e                   	pop    %esi
  803e6f:	5f                   	pop    %edi
  803e70:	5d                   	pop    %ebp
  803e71:	c3                   	ret    
  803e72:	66 90                	xchg   %ax,%ax
  803e74:	89 d8                	mov    %ebx,%eax
  803e76:	f7 f7                	div    %edi
  803e78:	31 ff                	xor    %edi,%edi
  803e7a:	89 fa                	mov    %edi,%edx
  803e7c:	83 c4 1c             	add    $0x1c,%esp
  803e7f:	5b                   	pop    %ebx
  803e80:	5e                   	pop    %esi
  803e81:	5f                   	pop    %edi
  803e82:	5d                   	pop    %ebp
  803e83:	c3                   	ret    
  803e84:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e89:	89 eb                	mov    %ebp,%ebx
  803e8b:	29 fb                	sub    %edi,%ebx
  803e8d:	89 f9                	mov    %edi,%ecx
  803e8f:	d3 e6                	shl    %cl,%esi
  803e91:	89 c5                	mov    %eax,%ebp
  803e93:	88 d9                	mov    %bl,%cl
  803e95:	d3 ed                	shr    %cl,%ebp
  803e97:	89 e9                	mov    %ebp,%ecx
  803e99:	09 f1                	or     %esi,%ecx
  803e9b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e9f:	89 f9                	mov    %edi,%ecx
  803ea1:	d3 e0                	shl    %cl,%eax
  803ea3:	89 c5                	mov    %eax,%ebp
  803ea5:	89 d6                	mov    %edx,%esi
  803ea7:	88 d9                	mov    %bl,%cl
  803ea9:	d3 ee                	shr    %cl,%esi
  803eab:	89 f9                	mov    %edi,%ecx
  803ead:	d3 e2                	shl    %cl,%edx
  803eaf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eb3:	88 d9                	mov    %bl,%cl
  803eb5:	d3 e8                	shr    %cl,%eax
  803eb7:	09 c2                	or     %eax,%edx
  803eb9:	89 d0                	mov    %edx,%eax
  803ebb:	89 f2                	mov    %esi,%edx
  803ebd:	f7 74 24 0c          	divl   0xc(%esp)
  803ec1:	89 d6                	mov    %edx,%esi
  803ec3:	89 c3                	mov    %eax,%ebx
  803ec5:	f7 e5                	mul    %ebp
  803ec7:	39 d6                	cmp    %edx,%esi
  803ec9:	72 19                	jb     803ee4 <__udivdi3+0xfc>
  803ecb:	74 0b                	je     803ed8 <__udivdi3+0xf0>
  803ecd:	89 d8                	mov    %ebx,%eax
  803ecf:	31 ff                	xor    %edi,%edi
  803ed1:	e9 58 ff ff ff       	jmp    803e2e <__udivdi3+0x46>
  803ed6:	66 90                	xchg   %ax,%ax
  803ed8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803edc:	89 f9                	mov    %edi,%ecx
  803ede:	d3 e2                	shl    %cl,%edx
  803ee0:	39 c2                	cmp    %eax,%edx
  803ee2:	73 e9                	jae    803ecd <__udivdi3+0xe5>
  803ee4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ee7:	31 ff                	xor    %edi,%edi
  803ee9:	e9 40 ff ff ff       	jmp    803e2e <__udivdi3+0x46>
  803eee:	66 90                	xchg   %ax,%ax
  803ef0:	31 c0                	xor    %eax,%eax
  803ef2:	e9 37 ff ff ff       	jmp    803e2e <__udivdi3+0x46>
  803ef7:	90                   	nop

00803ef8 <__umoddi3>:
  803ef8:	55                   	push   %ebp
  803ef9:	57                   	push   %edi
  803efa:	56                   	push   %esi
  803efb:	53                   	push   %ebx
  803efc:	83 ec 1c             	sub    $0x1c,%esp
  803eff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f03:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f17:	89 f3                	mov    %esi,%ebx
  803f19:	89 fa                	mov    %edi,%edx
  803f1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f1f:	89 34 24             	mov    %esi,(%esp)
  803f22:	85 c0                	test   %eax,%eax
  803f24:	75 1a                	jne    803f40 <__umoddi3+0x48>
  803f26:	39 f7                	cmp    %esi,%edi
  803f28:	0f 86 a2 00 00 00    	jbe    803fd0 <__umoddi3+0xd8>
  803f2e:	89 c8                	mov    %ecx,%eax
  803f30:	89 f2                	mov    %esi,%edx
  803f32:	f7 f7                	div    %edi
  803f34:	89 d0                	mov    %edx,%eax
  803f36:	31 d2                	xor    %edx,%edx
  803f38:	83 c4 1c             	add    $0x1c,%esp
  803f3b:	5b                   	pop    %ebx
  803f3c:	5e                   	pop    %esi
  803f3d:	5f                   	pop    %edi
  803f3e:	5d                   	pop    %ebp
  803f3f:	c3                   	ret    
  803f40:	39 f0                	cmp    %esi,%eax
  803f42:	0f 87 ac 00 00 00    	ja     803ff4 <__umoddi3+0xfc>
  803f48:	0f bd e8             	bsr    %eax,%ebp
  803f4b:	83 f5 1f             	xor    $0x1f,%ebp
  803f4e:	0f 84 ac 00 00 00    	je     804000 <__umoddi3+0x108>
  803f54:	bf 20 00 00 00       	mov    $0x20,%edi
  803f59:	29 ef                	sub    %ebp,%edi
  803f5b:	89 fe                	mov    %edi,%esi
  803f5d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f61:	89 e9                	mov    %ebp,%ecx
  803f63:	d3 e0                	shl    %cl,%eax
  803f65:	89 d7                	mov    %edx,%edi
  803f67:	89 f1                	mov    %esi,%ecx
  803f69:	d3 ef                	shr    %cl,%edi
  803f6b:	09 c7                	or     %eax,%edi
  803f6d:	89 e9                	mov    %ebp,%ecx
  803f6f:	d3 e2                	shl    %cl,%edx
  803f71:	89 14 24             	mov    %edx,(%esp)
  803f74:	89 d8                	mov    %ebx,%eax
  803f76:	d3 e0                	shl    %cl,%eax
  803f78:	89 c2                	mov    %eax,%edx
  803f7a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f7e:	d3 e0                	shl    %cl,%eax
  803f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f84:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f88:	89 f1                	mov    %esi,%ecx
  803f8a:	d3 e8                	shr    %cl,%eax
  803f8c:	09 d0                	or     %edx,%eax
  803f8e:	d3 eb                	shr    %cl,%ebx
  803f90:	89 da                	mov    %ebx,%edx
  803f92:	f7 f7                	div    %edi
  803f94:	89 d3                	mov    %edx,%ebx
  803f96:	f7 24 24             	mull   (%esp)
  803f99:	89 c6                	mov    %eax,%esi
  803f9b:	89 d1                	mov    %edx,%ecx
  803f9d:	39 d3                	cmp    %edx,%ebx
  803f9f:	0f 82 87 00 00 00    	jb     80402c <__umoddi3+0x134>
  803fa5:	0f 84 91 00 00 00    	je     80403c <__umoddi3+0x144>
  803fab:	8b 54 24 04          	mov    0x4(%esp),%edx
  803faf:	29 f2                	sub    %esi,%edx
  803fb1:	19 cb                	sbb    %ecx,%ebx
  803fb3:	89 d8                	mov    %ebx,%eax
  803fb5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803fb9:	d3 e0                	shl    %cl,%eax
  803fbb:	89 e9                	mov    %ebp,%ecx
  803fbd:	d3 ea                	shr    %cl,%edx
  803fbf:	09 d0                	or     %edx,%eax
  803fc1:	89 e9                	mov    %ebp,%ecx
  803fc3:	d3 eb                	shr    %cl,%ebx
  803fc5:	89 da                	mov    %ebx,%edx
  803fc7:	83 c4 1c             	add    $0x1c,%esp
  803fca:	5b                   	pop    %ebx
  803fcb:	5e                   	pop    %esi
  803fcc:	5f                   	pop    %edi
  803fcd:	5d                   	pop    %ebp
  803fce:	c3                   	ret    
  803fcf:	90                   	nop
  803fd0:	89 fd                	mov    %edi,%ebp
  803fd2:	85 ff                	test   %edi,%edi
  803fd4:	75 0b                	jne    803fe1 <__umoddi3+0xe9>
  803fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  803fdb:	31 d2                	xor    %edx,%edx
  803fdd:	f7 f7                	div    %edi
  803fdf:	89 c5                	mov    %eax,%ebp
  803fe1:	89 f0                	mov    %esi,%eax
  803fe3:	31 d2                	xor    %edx,%edx
  803fe5:	f7 f5                	div    %ebp
  803fe7:	89 c8                	mov    %ecx,%eax
  803fe9:	f7 f5                	div    %ebp
  803feb:	89 d0                	mov    %edx,%eax
  803fed:	e9 44 ff ff ff       	jmp    803f36 <__umoddi3+0x3e>
  803ff2:	66 90                	xchg   %ax,%ax
  803ff4:	89 c8                	mov    %ecx,%eax
  803ff6:	89 f2                	mov    %esi,%edx
  803ff8:	83 c4 1c             	add    $0x1c,%esp
  803ffb:	5b                   	pop    %ebx
  803ffc:	5e                   	pop    %esi
  803ffd:	5f                   	pop    %edi
  803ffe:	5d                   	pop    %ebp
  803fff:	c3                   	ret    
  804000:	3b 04 24             	cmp    (%esp),%eax
  804003:	72 06                	jb     80400b <__umoddi3+0x113>
  804005:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804009:	77 0f                	ja     80401a <__umoddi3+0x122>
  80400b:	89 f2                	mov    %esi,%edx
  80400d:	29 f9                	sub    %edi,%ecx
  80400f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804013:	89 14 24             	mov    %edx,(%esp)
  804016:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80401a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80401e:	8b 14 24             	mov    (%esp),%edx
  804021:	83 c4 1c             	add    $0x1c,%esp
  804024:	5b                   	pop    %ebx
  804025:	5e                   	pop    %esi
  804026:	5f                   	pop    %edi
  804027:	5d                   	pop    %ebp
  804028:	c3                   	ret    
  804029:	8d 76 00             	lea    0x0(%esi),%esi
  80402c:	2b 04 24             	sub    (%esp),%eax
  80402f:	19 fa                	sbb    %edi,%edx
  804031:	89 d1                	mov    %edx,%ecx
  804033:	89 c6                	mov    %eax,%esi
  804035:	e9 71 ff ff ff       	jmp    803fab <__umoddi3+0xb3>
  80403a:	66 90                	xchg   %ax,%ax
  80403c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804040:	72 ea                	jb     80402c <__umoddi3+0x134>
  804042:	89 d9                	mov    %ebx,%ecx
  804044:	e9 62 ff ff ff       	jmp    803fab <__umoddi3+0xb3>
