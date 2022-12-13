
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
  800044:	e8 16 24 00 00       	call   80245f <sys_getenvid>
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
  80007c:	bb 56 43 80 00       	mov    $0x804356,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb 60 43 80 00       	mov    $0x804360,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb 6c 43 80 00       	mov    $0x80436c,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb 7b 43 80 00       	mov    $0x80437b,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb 8a 43 80 00       	mov    $0x80438a,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb 9f 43 80 00       	mov    $0x80439f,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb b4 43 80 00       	mov    $0x8043b4,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb c5 43 80 00       	mov    $0x8043c5,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb d6 43 80 00       	mov    $0x8043d6,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb e7 43 80 00       	mov    $0x8043e7,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb f0 43 80 00       	mov    $0x8043f0,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb fa 43 80 00       	mov    $0x8043fa,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb 05 44 80 00       	mov    $0x804405,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb 11 44 80 00       	mov    $0x804411,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb 1b 44 80 00       	mov    $0x80441b,%ebx
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
  8001f7:	bb 25 44 80 00       	mov    $0x804425,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb 33 44 80 00       	mov    $0x804433,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 42 44 80 00       	mov    $0x804442,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 49 44 80 00       	mov    $0x804449,%ebx
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
  800264:	e8 ef 1c 00 00       	call   801f58 <smalloc>
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
  800342:	e8 11 1c 00 00       	call   801f58 <smalloc>
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
  800364:	e8 ef 1b 00 00       	call   801f58 <smalloc>
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
  800385:	e8 ce 1b 00 00       	call   801f58 <smalloc>
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
  8003a6:	e8 ad 1b 00 00       	call   801f58 <smalloc>
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
  8003c8:	e8 8b 1b 00 00       	call   801f58 <smalloc>
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
  8003ef:	e8 64 1b 00 00       	call   801f58 <smalloc>
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
  80040d:	e8 46 1b 00 00       	call   801f58 <smalloc>
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
  80042b:	e8 28 1b 00 00       	call   801f58 <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 0f 1b 00 00       	call   801f58 <smalloc>
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
  80046c:	e8 e7 1a 00 00       	call   801f58 <smalloc>
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
  800492:	e8 62 1e 00 00       	call   8022f9 <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 4e 1e 00 00       	call   8022f9 <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 3a 1e 00 00       	call   8022f9 <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 26 1e 00 00       	call   8022f9 <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 12 1e 00 00       	call   8022f9 <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 fe 1d 00 00       	call   8022f9 <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 ea 1d 00 00       	call   8022f9 <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 50 44 80 00       	mov    $0x804450,%ebx
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
  80058f:	e8 65 1d 00 00       	call   8022f9 <sys_createSemaphore>
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
  8005cc:	e8 39 1e 00 00       	call   80240a <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 3f 1e 00 00       	call   802428 <sys_run_env>
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
  800616:	e8 ef 1d 00 00       	call   80240a <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 f5 1d 00 00       	call   802428 <sys_run_env>
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
  800660:	e8 a5 1d 00 00       	call   80240a <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 ab 1d 00 00       	call   802428 <sys_run_env>
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
  8006b3:	e8 52 1d 00 00       	call   80240a <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 80 40 80 00       	push   $0x804080
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 c6 40 80 00       	push   $0x8040c6
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 38 1d 00 00       	call   802428 <sys_run_env>
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
  800714:	e8 19 1c 00 00       	call   802332 <sys_waitSemaphore>
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
  80072f:	e8 26 36 00 00       	call   803d5a <env_sleep>
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
  800775:	68 d8 40 80 00       	push   $0x8040d8
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
  8007cd:	68 08 41 80 00       	push   $0x804108
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
  80080c:	68 38 41 80 00       	push   $0x804138
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 c6 40 80 00       	push   $0x8040c6
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
  80084f:	68 38 41 80 00       	push   $0x804138
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 c6 40 80 00       	push   $0x8040c6
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
  8008b0:	68 38 41 80 00       	push   $0x804138
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 c6 40 80 00       	push   $0x8040c6
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
  8008e1:	e8 2f 1a 00 00       	call   802315 <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 5c 41 80 00       	push   $0x80415c
  8008f3:	68 8a 41 80 00       	push   $0x80418a
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 c6 40 80 00       	push   $0x8040c6
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 fc 19 00 00       	call   802315 <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 a0 41 80 00       	push   $0x8041a0
  800926:	68 8a 41 80 00       	push   $0x80418a
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 c6 40 80 00       	push   $0x8040c6
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 c9 19 00 00       	call   802315 <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 d0 41 80 00       	push   $0x8041d0
  800959:	68 8a 41 80 00       	push   $0x80418a
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 c6 40 80 00       	push   $0x8040c6
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 96 19 00 00       	call   802315 <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 04 42 80 00       	push   $0x804204
  80098c:	68 8a 41 80 00       	push   $0x80418a
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 c6 40 80 00       	push   $0x8040c6
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 63 19 00 00       	call   802315 <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 34 42 80 00       	push   $0x804234
  8009bf:	68 8a 41 80 00       	push   $0x80418a
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 c6 40 80 00       	push   $0x8040c6
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 30 19 00 00       	call   802315 <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 60 42 80 00       	push   $0x804260
  8009f2:	68 8a 41 80 00       	push   $0x80418a
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 c6 40 80 00       	push   $0x8040c6
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 fd 18 00 00       	call   802315 <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 90 42 80 00       	push   $0x804290
  800a24:	68 8a 41 80 00       	push   $0x80418a
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 c6 40 80 00       	push   $0x8040c6
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 50 44 80 00       	mov    $0x804450,%ebx
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
  800ab9:	e8 57 18 00 00       	call   802315 <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 c4 42 80 00       	push   $0x8042c4
  800aca:	68 8a 41 80 00       	push   $0x80418a
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 c6 40 80 00       	push   $0x8040c6
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
  800af0:	68 04 43 80 00       	push   $0x804304
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
  800b51:	e8 22 19 00 00       	call   802478 <sys_getenvindex>
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
  800bbc:	e8 c4 16 00 00       	call   802285 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 88 44 80 00       	push   $0x804488
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
  800bec:	68 b0 44 80 00       	push   $0x8044b0
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
  800c1d:	68 d8 44 80 00       	push   $0x8044d8
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 30 45 80 00       	push   $0x804530
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 88 44 80 00       	push   $0x804488
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 44 16 00 00       	call   80229f <sys_enable_interrupt>

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
  800c6e:	e8 d1 17 00 00       	call   802444 <sys_destroy_env>
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
  800c7f:	e8 26 18 00 00       	call   8024aa <sys_exit_env>
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
  800ca8:	68 44 45 80 00       	push   $0x804544
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 49 45 80 00       	push   $0x804549
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
  800ce5:	68 65 45 80 00       	push   $0x804565
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
  800d11:	68 68 45 80 00       	push   $0x804568
  800d16:	6a 26                	push   $0x26
  800d18:	68 b4 45 80 00       	push   $0x8045b4
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
  800de3:	68 c0 45 80 00       	push   $0x8045c0
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 b4 45 80 00       	push   $0x8045b4
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
  800e53:	68 14 46 80 00       	push   $0x804614
  800e58:	6a 44                	push   $0x44
  800e5a:	68 b4 45 80 00       	push   $0x8045b4
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
  800ead:	e8 25 12 00 00       	call   8020d7 <sys_cputs>
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
  800f24:	e8 ae 11 00 00       	call   8020d7 <sys_cputs>
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
  800f6e:	e8 12 13 00 00       	call   802285 <sys_disable_interrupt>
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
  800f8e:	e8 0c 13 00 00       	call   80229f <sys_enable_interrupt>
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
  800fd8:	e8 33 2e 00 00       	call   803e10 <__udivdi3>
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
  801028:	e8 f3 2e 00 00       	call   803f20 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 74 48 80 00       	add    $0x804874,%eax
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
  801183:	8b 04 85 98 48 80 00 	mov    0x804898(,%eax,4),%eax
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
  801264:	8b 34 9d e0 46 80 00 	mov    0x8046e0(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 85 48 80 00       	push   $0x804885
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
  801289:	68 8e 48 80 00       	push   $0x80488e
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
  8012b6:	be 91 48 80 00       	mov    $0x804891,%esi
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
  801cdc:	68 f0 49 80 00       	push   $0x8049f0
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
  801dac:	e8 6a 04 00 00       	call   80221b <sys_allocate_chunk>
  801db1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801db4:	a1 20 51 80 00       	mov    0x805120,%eax
  801db9:	83 ec 0c             	sub    $0xc,%esp
  801dbc:	50                   	push   %eax
  801dbd:	e8 df 0a 00 00       	call   8028a1 <initialize_MemBlocksList>
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
  801dea:	68 15 4a 80 00       	push   $0x804a15
  801def:	6a 33                	push   $0x33
  801df1:	68 33 4a 80 00       	push   $0x804a33
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
  801e69:	68 40 4a 80 00       	push   $0x804a40
  801e6e:	6a 34                	push   $0x34
  801e70:	68 33 4a 80 00       	push   $0x804a33
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
  801ec6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ec9:	e8 f7 fd ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ece:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ed2:	75 07                	jne    801edb <malloc+0x18>
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	eb 61                	jmp    801f3c <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801edb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee8:	01 d0                	add    %edx,%eax
  801eea:	48                   	dec    %eax
  801eeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801eee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef6:	f7 75 f0             	divl   -0x10(%ebp)
  801ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efc:	29 d0                	sub    %edx,%eax
  801efe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f01:	e8 e3 06 00 00       	call   8025e9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f06:	85 c0                	test   %eax,%eax
  801f08:	74 11                	je     801f1b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	ff 75 e8             	pushl  -0x18(%ebp)
  801f10:	e8 4e 0d 00 00       	call   802c63 <alloc_block_FF>
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801f1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f1f:	74 16                	je     801f37 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	ff 75 f4             	pushl  -0xc(%ebp)
  801f27:	e8 aa 0a 00 00       	call   8029d6 <insert_sorted_allocList>
  801f2c:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	8b 40 08             	mov    0x8(%eax),%eax
  801f35:	eb 05                	jmp    801f3c <malloc+0x79>
	}

    return NULL;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801f44:	83 ec 04             	sub    $0x4,%esp
  801f47:	68 64 4a 80 00       	push   $0x804a64
  801f4c:	6a 6f                	push   $0x6f
  801f4e:	68 33 4a 80 00       	push   $0x804a33
  801f53:	e8 2f ed ff ff       	call   800c87 <_panic>

00801f58 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 38             	sub    $0x38,%esp
  801f5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f61:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f64:	e8 5c fd ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f6d:	75 07                	jne    801f76 <smalloc+0x1e>
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	eb 7c                	jmp    801ff2 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f76:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f83:	01 d0                	add    %edx,%eax
  801f85:	48                   	dec    %eax
  801f86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f91:	f7 75 f0             	divl   -0x10(%ebp)
  801f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f97:	29 d0                	sub    %edx,%eax
  801f99:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801f9c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801fa3:	e8 41 06 00 00       	call   8025e9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	74 11                	je     801fbd <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801fac:	83 ec 0c             	sub    $0xc,%esp
  801faf:	ff 75 e8             	pushl  -0x18(%ebp)
  801fb2:	e8 ac 0c 00 00       	call   802c63 <alloc_block_FF>
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801fbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc1:	74 2a                	je     801fed <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	8b 40 08             	mov    0x8(%eax),%eax
  801fc9:	89 c2                	mov    %eax,%edx
  801fcb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fcf:	52                   	push   %edx
  801fd0:	50                   	push   %eax
  801fd1:	ff 75 0c             	pushl  0xc(%ebp)
  801fd4:	ff 75 08             	pushl  0x8(%ebp)
  801fd7:	e8 92 03 00 00       	call   80236e <sys_createSharedObject>
  801fdc:	83 c4 10             	add    $0x10,%esp
  801fdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801fe2:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801fe6:	74 05                	je     801fed <smalloc+0x95>
			return (void*)virtual_address;
  801fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801feb:	eb 05                	jmp    801ff2 <smalloc+0x9a>
	}
	return NULL;
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ffa:	e8 c6 fc ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	68 88 4a 80 00       	push   $0x804a88
  802007:	68 b0 00 00 00       	push   $0xb0
  80200c:	68 33 4a 80 00       	push   $0x804a33
  802011:	e8 71 ec ff ff       	call   800c87 <_panic>

00802016 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80201c:	e8 a4 fc ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802021:	83 ec 04             	sub    $0x4,%esp
  802024:	68 ac 4a 80 00       	push   $0x804aac
  802029:	68 f4 00 00 00       	push   $0xf4
  80202e:	68 33 4a 80 00       	push   $0x804a33
  802033:	e8 4f ec ff ff       	call   800c87 <_panic>

00802038 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	68 d4 4a 80 00       	push   $0x804ad4
  802046:	68 08 01 00 00       	push   $0x108
  80204b:	68 33 4a 80 00       	push   $0x804a33
  802050:	e8 32 ec ff ff       	call   800c87 <_panic>

00802055 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80205b:	83 ec 04             	sub    $0x4,%esp
  80205e:	68 f8 4a 80 00       	push   $0x804af8
  802063:	68 13 01 00 00       	push   $0x113
  802068:	68 33 4a 80 00       	push   $0x804a33
  80206d:	e8 15 ec ff ff       	call   800c87 <_panic>

00802072 <shrink>:

}
void shrink(uint32 newSize)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	68 f8 4a 80 00       	push   $0x804af8
  802080:	68 18 01 00 00       	push   $0x118
  802085:	68 33 4a 80 00       	push   $0x804a33
  80208a:	e8 f8 eb ff ff       	call   800c87 <_panic>

0080208f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802095:	83 ec 04             	sub    $0x4,%esp
  802098:	68 f8 4a 80 00       	push   $0x804af8
  80209d:	68 1d 01 00 00       	push   $0x11d
  8020a2:	68 33 4a 80 00       	push   $0x804a33
  8020a7:	e8 db eb ff ff       	call   800c87 <_panic>

008020ac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	57                   	push   %edi
  8020b0:	56                   	push   %esi
  8020b1:	53                   	push   %ebx
  8020b2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020c1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020c4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020c7:	cd 30                	int    $0x30
  8020c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020cf:	83 c4 10             	add    $0x10,%esp
  8020d2:	5b                   	pop    %ebx
  8020d3:	5e                   	pop    %esi
  8020d4:	5f                   	pop    %edi
  8020d5:	5d                   	pop    %ebp
  8020d6:	c3                   	ret    

008020d7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 04             	sub    $0x4,%esp
  8020dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	52                   	push   %edx
  8020ef:	ff 75 0c             	pushl  0xc(%ebp)
  8020f2:	50                   	push   %eax
  8020f3:	6a 00                	push   $0x0
  8020f5:	e8 b2 ff ff ff       	call   8020ac <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
}
  8020fd:	90                   	nop
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sys_cgetc>:

int
sys_cgetc(void)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 01                	push   $0x1
  80210f:	e8 98 ff ff ff       	call   8020ac <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80211c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	52                   	push   %edx
  802129:	50                   	push   %eax
  80212a:	6a 05                	push   $0x5
  80212c:	e8 7b ff ff ff       	call   8020ac <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	56                   	push   %esi
  80213a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80213b:	8b 75 18             	mov    0x18(%ebp),%esi
  80213e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802141:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802144:	8b 55 0c             	mov    0xc(%ebp),%edx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	56                   	push   %esi
  80214b:	53                   	push   %ebx
  80214c:	51                   	push   %ecx
  80214d:	52                   	push   %edx
  80214e:	50                   	push   %eax
  80214f:	6a 06                	push   $0x6
  802151:	e8 56 ff ff ff       	call   8020ac <syscall>
  802156:	83 c4 18             	add    $0x18,%esp
}
  802159:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80215c:	5b                   	pop    %ebx
  80215d:	5e                   	pop    %esi
  80215e:	5d                   	pop    %ebp
  80215f:	c3                   	ret    

00802160 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802163:	8b 55 0c             	mov    0xc(%ebp),%edx
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	52                   	push   %edx
  802170:	50                   	push   %eax
  802171:	6a 07                	push   $0x7
  802173:	e8 34 ff ff ff       	call   8020ac <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	ff 75 0c             	pushl  0xc(%ebp)
  802189:	ff 75 08             	pushl  0x8(%ebp)
  80218c:	6a 08                	push   $0x8
  80218e:	e8 19 ff ff ff       	call   8020ac <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 09                	push   $0x9
  8021a7:	e8 00 ff ff ff       	call   8020ac <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 0a                	push   $0xa
  8021c0:	e8 e7 fe ff ff       	call   8020ac <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 0b                	push   $0xb
  8021d9:	e8 ce fe ff ff       	call   8020ac <syscall>
  8021de:	83 c4 18             	add    $0x18,%esp
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	ff 75 08             	pushl  0x8(%ebp)
  8021f2:	6a 0f                	push   $0xf
  8021f4:	e8 b3 fe ff ff       	call   8020ac <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
	return;
  8021fc:	90                   	nop
}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	ff 75 0c             	pushl  0xc(%ebp)
  80220b:	ff 75 08             	pushl  0x8(%ebp)
  80220e:	6a 10                	push   $0x10
  802210:	e8 97 fe ff ff       	call   8020ac <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
	return ;
  802218:	90                   	nop
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	ff 75 10             	pushl  0x10(%ebp)
  802225:	ff 75 0c             	pushl  0xc(%ebp)
  802228:	ff 75 08             	pushl  0x8(%ebp)
  80222b:	6a 11                	push   $0x11
  80222d:	e8 7a fe ff ff       	call   8020ac <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
	return ;
  802235:	90                   	nop
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 0c                	push   $0xc
  802247:	e8 60 fe ff ff       	call   8020ac <syscall>
  80224c:	83 c4 18             	add    $0x18,%esp
}
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	ff 75 08             	pushl  0x8(%ebp)
  80225f:	6a 0d                	push   $0xd
  802261:	e8 46 fe ff ff       	call   8020ac <syscall>
  802266:	83 c4 18             	add    $0x18,%esp
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 0e                	push   $0xe
  80227a:	e8 2d fe ff ff       	call   8020ac <syscall>
  80227f:	83 c4 18             	add    $0x18,%esp
}
  802282:	90                   	nop
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 13                	push   $0x13
  802294:	e8 13 fe ff ff       	call   8020ac <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
}
  80229c:	90                   	nop
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 14                	push   $0x14
  8022ae:	e8 f9 fd ff ff       	call   8020ac <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
}
  8022b6:	90                   	nop
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022c5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	50                   	push   %eax
  8022d2:	6a 15                	push   $0x15
  8022d4:	e8 d3 fd ff ff       	call   8020ac <syscall>
  8022d9:	83 c4 18             	add    $0x18,%esp
}
  8022dc:	90                   	nop
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 16                	push   $0x16
  8022ee:	e8 b9 fd ff ff       	call   8020ac <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
}
  8022f6:	90                   	nop
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	ff 75 0c             	pushl  0xc(%ebp)
  802308:	50                   	push   %eax
  802309:	6a 17                	push   $0x17
  80230b:	e8 9c fd ff ff       	call   8020ac <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802318:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	52                   	push   %edx
  802325:	50                   	push   %eax
  802326:	6a 1a                	push   $0x1a
  802328:	e8 7f fd ff ff       	call   8020ac <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802335:	8b 55 0c             	mov    0xc(%ebp),%edx
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	52                   	push   %edx
  802342:	50                   	push   %eax
  802343:	6a 18                	push   $0x18
  802345:	e8 62 fd ff ff       	call   8020ac <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	90                   	nop
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802353:	8b 55 0c             	mov    0xc(%ebp),%edx
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	52                   	push   %edx
  802360:	50                   	push   %eax
  802361:	6a 19                	push   $0x19
  802363:	e8 44 fd ff ff       	call   8020ac <syscall>
  802368:	83 c4 18             	add    $0x18,%esp
}
  80236b:	90                   	nop
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	8b 45 10             	mov    0x10(%ebp),%eax
  802377:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80237a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80237d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	6a 00                	push   $0x0
  802386:	51                   	push   %ecx
  802387:	52                   	push   %edx
  802388:	ff 75 0c             	pushl  0xc(%ebp)
  80238b:	50                   	push   %eax
  80238c:	6a 1b                	push   $0x1b
  80238e:	e8 19 fd ff ff       	call   8020ac <syscall>
  802393:	83 c4 18             	add    $0x18,%esp
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80239b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	52                   	push   %edx
  8023a8:	50                   	push   %eax
  8023a9:	6a 1c                	push   $0x1c
  8023ab:	e8 fc fc ff ff       	call   8020ac <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	51                   	push   %ecx
  8023c6:	52                   	push   %edx
  8023c7:	50                   	push   %eax
  8023c8:	6a 1d                	push   $0x1d
  8023ca:	e8 dd fc ff ff       	call   8020ac <syscall>
  8023cf:	83 c4 18             	add    $0x18,%esp
}
  8023d2:	c9                   	leave  
  8023d3:	c3                   	ret    

008023d4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	52                   	push   %edx
  8023e4:	50                   	push   %eax
  8023e5:	6a 1e                	push   $0x1e
  8023e7:	e8 c0 fc ff ff       	call   8020ac <syscall>
  8023ec:	83 c4 18             	add    $0x18,%esp
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 1f                	push   $0x1f
  802400:	e8 a7 fc ff ff       	call   8020ac <syscall>
  802405:	83 c4 18             	add    $0x18,%esp
}
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	6a 00                	push   $0x0
  802412:	ff 75 14             	pushl  0x14(%ebp)
  802415:	ff 75 10             	pushl  0x10(%ebp)
  802418:	ff 75 0c             	pushl  0xc(%ebp)
  80241b:	50                   	push   %eax
  80241c:	6a 20                	push   $0x20
  80241e:	e8 89 fc ff ff       	call   8020ac <syscall>
  802423:	83 c4 18             	add    $0x18,%esp
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	50                   	push   %eax
  802437:	6a 21                	push   $0x21
  802439:	e8 6e fc ff ff       	call   8020ac <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
}
  802441:	90                   	nop
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	50                   	push   %eax
  802453:	6a 22                	push   $0x22
  802455:	e8 52 fc ff ff       	call   8020ac <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 02                	push   $0x2
  80246e:	e8 39 fc ff ff       	call   8020ac <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 03                	push   $0x3
  802487:	e8 20 fc ff ff       	call   8020ac <syscall>
  80248c:	83 c4 18             	add    $0x18,%esp
}
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 04                	push   $0x4
  8024a0:	e8 07 fc ff ff       	call   8020ac <syscall>
  8024a5:	83 c4 18             	add    $0x18,%esp
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <sys_exit_env>:


void sys_exit_env(void)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 23                	push   $0x23
  8024b9:	e8 ee fb ff ff       	call   8020ac <syscall>
  8024be:	83 c4 18             	add    $0x18,%esp
}
  8024c1:	90                   	nop
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024ca:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024cd:	8d 50 04             	lea    0x4(%eax),%edx
  8024d0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	52                   	push   %edx
  8024da:	50                   	push   %eax
  8024db:	6a 24                	push   $0x24
  8024dd:	e8 ca fb ff ff       	call   8020ac <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
	return result;
  8024e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ee:	89 01                	mov    %eax,(%ecx)
  8024f0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	c9                   	leave  
  8024f7:	c2 04 00             	ret    $0x4

008024fa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	ff 75 10             	pushl  0x10(%ebp)
  802504:	ff 75 0c             	pushl  0xc(%ebp)
  802507:	ff 75 08             	pushl  0x8(%ebp)
  80250a:	6a 12                	push   $0x12
  80250c:	e8 9b fb ff ff       	call   8020ac <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
	return ;
  802514:	90                   	nop
}
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <sys_rcr2>:
uint32 sys_rcr2()
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 25                	push   $0x25
  802526:	e8 81 fb ff ff       	call   8020ac <syscall>
  80252b:	83 c4 18             	add    $0x18,%esp
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
  802533:	83 ec 04             	sub    $0x4,%esp
  802536:	8b 45 08             	mov    0x8(%ebp),%eax
  802539:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80253c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	50                   	push   %eax
  802549:	6a 26                	push   $0x26
  80254b:	e8 5c fb ff ff       	call   8020ac <syscall>
  802550:	83 c4 18             	add    $0x18,%esp
	return ;
  802553:	90                   	nop
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <rsttst>:
void rsttst()
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 28                	push   $0x28
  802565:	e8 42 fb ff ff       	call   8020ac <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
	return ;
  80256d:	90                   	nop
}
  80256e:	c9                   	leave  
  80256f:	c3                   	ret    

00802570 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	83 ec 04             	sub    $0x4,%esp
  802576:	8b 45 14             	mov    0x14(%ebp),%eax
  802579:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80257c:	8b 55 18             	mov    0x18(%ebp),%edx
  80257f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802583:	52                   	push   %edx
  802584:	50                   	push   %eax
  802585:	ff 75 10             	pushl  0x10(%ebp)
  802588:	ff 75 0c             	pushl  0xc(%ebp)
  80258b:	ff 75 08             	pushl  0x8(%ebp)
  80258e:	6a 27                	push   $0x27
  802590:	e8 17 fb ff ff       	call   8020ac <syscall>
  802595:	83 c4 18             	add    $0x18,%esp
	return ;
  802598:	90                   	nop
}
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <chktst>:
void chktst(uint32 n)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	ff 75 08             	pushl  0x8(%ebp)
  8025a9:	6a 29                	push   $0x29
  8025ab:	e8 fc fa ff ff       	call   8020ac <syscall>
  8025b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b3:	90                   	nop
}
  8025b4:	c9                   	leave  
  8025b5:	c3                   	ret    

008025b6 <inctst>:

void inctst()
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 2a                	push   $0x2a
  8025c5:	e8 e2 fa ff ff       	call   8020ac <syscall>
  8025ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cd:	90                   	nop
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <gettst>:
uint32 gettst()
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 2b                	push   $0x2b
  8025df:	e8 c8 fa ff ff       	call   8020ac <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 2c                	push   $0x2c
  8025fb:	e8 ac fa ff ff       	call   8020ac <syscall>
  802600:	83 c4 18             	add    $0x18,%esp
  802603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802606:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80260a:	75 07                	jne    802613 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80260c:	b8 01 00 00 00       	mov    $0x1,%eax
  802611:	eb 05                	jmp    802618 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 2c                	push   $0x2c
  80262c:	e8 7b fa ff ff       	call   8020ac <syscall>
  802631:	83 c4 18             	add    $0x18,%esp
  802634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802637:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80263b:	75 07                	jne    802644 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80263d:	b8 01 00 00 00       	mov    $0x1,%eax
  802642:	eb 05                	jmp    802649 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 2c                	push   $0x2c
  80265d:	e8 4a fa ff ff       	call   8020ac <syscall>
  802662:	83 c4 18             	add    $0x18,%esp
  802665:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802668:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80266c:	75 07                	jne    802675 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80266e:	b8 01 00 00 00       	mov    $0x1,%eax
  802673:	eb 05                	jmp    80267a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802675:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 2c                	push   $0x2c
  80268e:	e8 19 fa ff ff       	call   8020ac <syscall>
  802693:	83 c4 18             	add    $0x18,%esp
  802696:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802699:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80269d:	75 07                	jne    8026a6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80269f:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a4:	eb 05                	jmp    8026ab <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	ff 75 08             	pushl  0x8(%ebp)
  8026bb:	6a 2d                	push   $0x2d
  8026bd:	e8 ea f9 ff ff       	call   8020ac <syscall>
  8026c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c5:	90                   	nop
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	6a 00                	push   $0x0
  8026da:	53                   	push   %ebx
  8026db:	51                   	push   %ecx
  8026dc:	52                   	push   %edx
  8026dd:	50                   	push   %eax
  8026de:	6a 2e                	push   $0x2e
  8026e0:	e8 c7 f9 ff ff       	call   8020ac <syscall>
  8026e5:	83 c4 18             	add    $0x18,%esp
}
  8026e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	52                   	push   %edx
  8026fd:	50                   	push   %eax
  8026fe:	6a 2f                	push   $0x2f
  802700:	e8 a7 f9 ff ff       	call   8020ac <syscall>
  802705:	83 c4 18             	add    $0x18,%esp
}
  802708:	c9                   	leave  
  802709:	c3                   	ret    

0080270a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80270a:	55                   	push   %ebp
  80270b:	89 e5                	mov    %esp,%ebp
  80270d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802710:	83 ec 0c             	sub    $0xc,%esp
  802713:	68 08 4b 80 00       	push   $0x804b08
  802718:	e8 1e e8 ff ff       	call   800f3b <cprintf>
  80271d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802720:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802727:	83 ec 0c             	sub    $0xc,%esp
  80272a:	68 34 4b 80 00       	push   $0x804b34
  80272f:	e8 07 e8 ff ff       	call   800f3b <cprintf>
  802734:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802737:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80273b:	a1 38 51 80 00       	mov    0x805138,%eax
  802740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802743:	eb 56                	jmp    80279b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802745:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802749:	74 1c                	je     802767 <print_mem_block_lists+0x5d>
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 50 08             	mov    0x8(%eax),%edx
  802751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802754:	8b 48 08             	mov    0x8(%eax),%ecx
  802757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275a:	8b 40 0c             	mov    0xc(%eax),%eax
  80275d:	01 c8                	add    %ecx,%eax
  80275f:	39 c2                	cmp    %eax,%edx
  802761:	73 04                	jae    802767 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802763:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 50 08             	mov    0x8(%eax),%edx
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 40 0c             	mov    0xc(%eax),%eax
  802773:	01 c2                	add    %eax,%edx
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 40 08             	mov    0x8(%eax),%eax
  80277b:	83 ec 04             	sub    $0x4,%esp
  80277e:	52                   	push   %edx
  80277f:	50                   	push   %eax
  802780:	68 49 4b 80 00       	push   $0x804b49
  802785:	e8 b1 e7 ff ff       	call   800f3b <cprintf>
  80278a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802793:	a1 40 51 80 00       	mov    0x805140,%eax
  802798:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279f:	74 07                	je     8027a8 <print_mem_block_lists+0x9e>
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	eb 05                	jmp    8027ad <print_mem_block_lists+0xa3>
  8027a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ad:	a3 40 51 80 00       	mov    %eax,0x805140
  8027b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	75 8a                	jne    802745 <print_mem_block_lists+0x3b>
  8027bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bf:	75 84                	jne    802745 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8027c1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027c5:	75 10                	jne    8027d7 <print_mem_block_lists+0xcd>
  8027c7:	83 ec 0c             	sub    $0xc,%esp
  8027ca:	68 58 4b 80 00       	push   $0x804b58
  8027cf:	e8 67 e7 ff ff       	call   800f3b <cprintf>
  8027d4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8027d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027de:	83 ec 0c             	sub    $0xc,%esp
  8027e1:	68 7c 4b 80 00       	push   $0x804b7c
  8027e6:	e8 50 e7 ff ff       	call   800f3b <cprintf>
  8027eb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027ee:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027f2:	a1 40 50 80 00       	mov    0x805040,%eax
  8027f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fa:	eb 56                	jmp    802852 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802800:	74 1c                	je     80281e <print_mem_block_lists+0x114>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 50 08             	mov    0x8(%eax),%edx
  802808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280b:	8b 48 08             	mov    0x8(%eax),%ecx
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	8b 40 0c             	mov    0xc(%eax),%eax
  802814:	01 c8                	add    %ecx,%eax
  802816:	39 c2                	cmp    %eax,%edx
  802818:	73 04                	jae    80281e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80281a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 50 08             	mov    0x8(%eax),%edx
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 40 0c             	mov    0xc(%eax),%eax
  80282a:	01 c2                	add    %eax,%edx
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 40 08             	mov    0x8(%eax),%eax
  802832:	83 ec 04             	sub    $0x4,%esp
  802835:	52                   	push   %edx
  802836:	50                   	push   %eax
  802837:	68 49 4b 80 00       	push   $0x804b49
  80283c:	e8 fa e6 ff ff       	call   800f3b <cprintf>
  802841:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80284a:	a1 48 50 80 00       	mov    0x805048,%eax
  80284f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802856:	74 07                	je     80285f <print_mem_block_lists+0x155>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	eb 05                	jmp    802864 <print_mem_block_lists+0x15a>
  80285f:	b8 00 00 00 00       	mov    $0x0,%eax
  802864:	a3 48 50 80 00       	mov    %eax,0x805048
  802869:	a1 48 50 80 00       	mov    0x805048,%eax
  80286e:	85 c0                	test   %eax,%eax
  802870:	75 8a                	jne    8027fc <print_mem_block_lists+0xf2>
  802872:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802876:	75 84                	jne    8027fc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802878:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80287c:	75 10                	jne    80288e <print_mem_block_lists+0x184>
  80287e:	83 ec 0c             	sub    $0xc,%esp
  802881:	68 94 4b 80 00       	push   $0x804b94
  802886:	e8 b0 e6 ff ff       	call   800f3b <cprintf>
  80288b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80288e:	83 ec 0c             	sub    $0xc,%esp
  802891:	68 08 4b 80 00       	push   $0x804b08
  802896:	e8 a0 e6 ff ff       	call   800f3b <cprintf>
  80289b:	83 c4 10             	add    $0x10,%esp

}
  80289e:	90                   	nop
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
  8028a4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8028a7:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8028ae:	00 00 00 
  8028b1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8028b8:	00 00 00 
  8028bb:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8028c2:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8028c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028cc:	e9 9e 00 00 00       	jmp    80296f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8028d1:	a1 50 50 80 00       	mov    0x805050,%eax
  8028d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d9:	c1 e2 04             	shl    $0x4,%edx
  8028dc:	01 d0                	add    %edx,%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	75 14                	jne    8028f6 <initialize_MemBlocksList+0x55>
  8028e2:	83 ec 04             	sub    $0x4,%esp
  8028e5:	68 bc 4b 80 00       	push   $0x804bbc
  8028ea:	6a 46                	push   $0x46
  8028ec:	68 df 4b 80 00       	push   $0x804bdf
  8028f1:	e8 91 e3 ff ff       	call   800c87 <_panic>
  8028f6:	a1 50 50 80 00       	mov    0x805050,%eax
  8028fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fe:	c1 e2 04             	shl    $0x4,%edx
  802901:	01 d0                	add    %edx,%eax
  802903:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802909:	89 10                	mov    %edx,(%eax)
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	74 18                	je     802929 <initialize_MemBlocksList+0x88>
  802911:	a1 48 51 80 00       	mov    0x805148,%eax
  802916:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80291c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80291f:	c1 e1 04             	shl    $0x4,%ecx
  802922:	01 ca                	add    %ecx,%edx
  802924:	89 50 04             	mov    %edx,0x4(%eax)
  802927:	eb 12                	jmp    80293b <initialize_MemBlocksList+0x9a>
  802929:	a1 50 50 80 00       	mov    0x805050,%eax
  80292e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802931:	c1 e2 04             	shl    $0x4,%edx
  802934:	01 d0                	add    %edx,%eax
  802936:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80293b:	a1 50 50 80 00       	mov    0x805050,%eax
  802940:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802943:	c1 e2 04             	shl    $0x4,%edx
  802946:	01 d0                	add    %edx,%eax
  802948:	a3 48 51 80 00       	mov    %eax,0x805148
  80294d:	a1 50 50 80 00       	mov    0x805050,%eax
  802952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802955:	c1 e2 04             	shl    $0x4,%edx
  802958:	01 d0                	add    %edx,%eax
  80295a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802961:	a1 54 51 80 00       	mov    0x805154,%eax
  802966:	40                   	inc    %eax
  802967:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80296c:	ff 45 f4             	incl   -0xc(%ebp)
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	3b 45 08             	cmp    0x8(%ebp),%eax
  802975:	0f 82 56 ff ff ff    	jb     8028d1 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80297b:	90                   	nop
  80297c:	c9                   	leave  
  80297d:	c3                   	ret    

0080297e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80297e:	55                   	push   %ebp
  80297f:	89 e5                	mov    %esp,%ebp
  802981:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80298c:	eb 19                	jmp    8029a7 <find_block+0x29>
	{
		if(va==point->sva)
  80298e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802991:	8b 40 08             	mov    0x8(%eax),%eax
  802994:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802997:	75 05                	jne    80299e <find_block+0x20>
		   return point;
  802999:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80299c:	eb 36                	jmp    8029d4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	8b 40 08             	mov    0x8(%eax),%eax
  8029a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029ab:	74 07                	je     8029b4 <find_block+0x36>
  8029ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	eb 05                	jmp    8029b9 <find_block+0x3b>
  8029b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bc:	89 42 08             	mov    %eax,0x8(%edx)
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	8b 40 08             	mov    0x8(%eax),%eax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	75 c5                	jne    80298e <find_block+0x10>
  8029c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029cd:	75 bf                	jne    80298e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8029cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029d4:	c9                   	leave  
  8029d5:	c3                   	ret    

008029d6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8029d6:	55                   	push   %ebp
  8029d7:	89 e5                	mov    %esp,%ebp
  8029d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8029dc:	a1 40 50 80 00       	mov    0x805040,%eax
  8029e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8029e4:	a1 44 50 80 00       	mov    0x805044,%eax
  8029e9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8029ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029f2:	74 24                	je     802a18 <insert_sorted_allocList+0x42>
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	8b 50 08             	mov    0x8(%eax),%edx
  8029fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fd:	8b 40 08             	mov    0x8(%eax),%eax
  802a00:	39 c2                	cmp    %eax,%edx
  802a02:	76 14                	jbe    802a18 <insert_sorted_allocList+0x42>
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	8b 50 08             	mov    0x8(%eax),%edx
  802a0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0d:	8b 40 08             	mov    0x8(%eax),%eax
  802a10:	39 c2                	cmp    %eax,%edx
  802a12:	0f 82 60 01 00 00    	jb     802b78 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802a18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a1c:	75 65                	jne    802a83 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802a1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a22:	75 14                	jne    802a38 <insert_sorted_allocList+0x62>
  802a24:	83 ec 04             	sub    $0x4,%esp
  802a27:	68 bc 4b 80 00       	push   $0x804bbc
  802a2c:	6a 6b                	push   $0x6b
  802a2e:	68 df 4b 80 00       	push   $0x804bdf
  802a33:	e8 4f e2 ff ff       	call   800c87 <_panic>
  802a38:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	89 10                	mov    %edx,(%eax)
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	74 0d                	je     802a59 <insert_sorted_allocList+0x83>
  802a4c:	a1 40 50 80 00       	mov    0x805040,%eax
  802a51:	8b 55 08             	mov    0x8(%ebp),%edx
  802a54:	89 50 04             	mov    %edx,0x4(%eax)
  802a57:	eb 08                	jmp    802a61 <insert_sorted_allocList+0x8b>
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	a3 44 50 80 00       	mov    %eax,0x805044
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	a3 40 50 80 00       	mov    %eax,0x805040
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a73:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a78:	40                   	inc    %eax
  802a79:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a7e:	e9 dc 01 00 00       	jmp    802c5f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	8b 50 08             	mov    0x8(%eax),%edx
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	8b 40 08             	mov    0x8(%eax),%eax
  802a8f:	39 c2                	cmp    %eax,%edx
  802a91:	77 6c                	ja     802aff <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a97:	74 06                	je     802a9f <insert_sorted_allocList+0xc9>
  802a99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9d:	75 14                	jne    802ab3 <insert_sorted_allocList+0xdd>
  802a9f:	83 ec 04             	sub    $0x4,%esp
  802aa2:	68 f8 4b 80 00       	push   $0x804bf8
  802aa7:	6a 6f                	push   $0x6f
  802aa9:	68 df 4b 80 00       	push   $0x804bdf
  802aae:	e8 d4 e1 ff ff       	call   800c87 <_panic>
  802ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab6:	8b 50 04             	mov    0x4(%eax),%edx
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	89 50 04             	mov    %edx,0x4(%eax)
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ac5:	89 10                	mov    %edx,(%eax)
  802ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aca:	8b 40 04             	mov    0x4(%eax),%eax
  802acd:	85 c0                	test   %eax,%eax
  802acf:	74 0d                	je     802ade <insert_sorted_allocList+0x108>
  802ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad4:	8b 40 04             	mov    0x4(%eax),%eax
  802ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ada:	89 10                	mov    %edx,(%eax)
  802adc:	eb 08                	jmp    802ae6 <insert_sorted_allocList+0x110>
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	a3 40 50 80 00       	mov    %eax,0x805040
  802ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  802aec:	89 50 04             	mov    %edx,0x4(%eax)
  802aef:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802af4:	40                   	inc    %eax
  802af5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802afa:	e9 60 01 00 00       	jmp    802c5f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	8b 50 08             	mov    0x8(%eax),%edx
  802b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b08:	8b 40 08             	mov    0x8(%eax),%eax
  802b0b:	39 c2                	cmp    %eax,%edx
  802b0d:	0f 82 4c 01 00 00    	jb     802c5f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802b13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b17:	75 14                	jne    802b2d <insert_sorted_allocList+0x157>
  802b19:	83 ec 04             	sub    $0x4,%esp
  802b1c:	68 30 4c 80 00       	push   $0x804c30
  802b21:	6a 73                	push   $0x73
  802b23:	68 df 4b 80 00       	push   $0x804bdf
  802b28:	e8 5a e1 ff ff       	call   800c87 <_panic>
  802b2d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	89 50 04             	mov    %edx,0x4(%eax)
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	8b 40 04             	mov    0x4(%eax),%eax
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	74 0c                	je     802b4f <insert_sorted_allocList+0x179>
  802b43:	a1 44 50 80 00       	mov    0x805044,%eax
  802b48:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4b:	89 10                	mov    %edx,(%eax)
  802b4d:	eb 08                	jmp    802b57 <insert_sorted_allocList+0x181>
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	a3 40 50 80 00       	mov    %eax,0x805040
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	a3 44 50 80 00       	mov    %eax,0x805044
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b68:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b6d:	40                   	inc    %eax
  802b6e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b73:	e9 e7 00 00 00       	jmp    802c5f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b7e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b85:	a1 40 50 80 00       	mov    0x805040,%eax
  802b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b8d:	e9 9d 00 00 00       	jmp    802c2f <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 40 08             	mov    0x8(%eax),%eax
  802ba6:	39 c2                	cmp    %eax,%edx
  802ba8:	76 7d                	jbe    802c27 <insert_sorted_allocList+0x251>
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	8b 50 08             	mov    0x8(%eax),%edx
  802bb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb3:	8b 40 08             	mov    0x8(%eax),%eax
  802bb6:	39 c2                	cmp    %eax,%edx
  802bb8:	73 6d                	jae    802c27 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802bba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbe:	74 06                	je     802bc6 <insert_sorted_allocList+0x1f0>
  802bc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc4:	75 14                	jne    802bda <insert_sorted_allocList+0x204>
  802bc6:	83 ec 04             	sub    $0x4,%esp
  802bc9:	68 54 4c 80 00       	push   $0x804c54
  802bce:	6a 7f                	push   $0x7f
  802bd0:	68 df 4b 80 00       	push   $0x804bdf
  802bd5:	e8 ad e0 ff ff       	call   800c87 <_panic>
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 10                	mov    (%eax),%edx
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	89 10                	mov    %edx,(%eax)
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	74 0b                	je     802bf8 <insert_sorted_allocList+0x222>
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 00                	mov    (%eax),%eax
  802bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf5:	89 50 04             	mov    %edx,0x4(%eax)
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfe:	89 10                	mov    %edx,(%eax)
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%eax)
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	75 08                	jne    802c1a <insert_sorted_allocList+0x244>
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	a3 44 50 80 00       	mov    %eax,0x805044
  802c1a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c1f:	40                   	inc    %eax
  802c20:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802c25:	eb 39                	jmp    802c60 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802c27:	a1 48 50 80 00       	mov    0x805048,%eax
  802c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c33:	74 07                	je     802c3c <insert_sorted_allocList+0x266>
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	eb 05                	jmp    802c41 <insert_sorted_allocList+0x26b>
  802c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c41:	a3 48 50 80 00       	mov    %eax,0x805048
  802c46:	a1 48 50 80 00       	mov    0x805048,%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	0f 85 3f ff ff ff    	jne    802b92 <insert_sorted_allocList+0x1bc>
  802c53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c57:	0f 85 35 ff ff ff    	jne    802b92 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c5d:	eb 01                	jmp    802c60 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c5f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c60:	90                   	nop
  802c61:	c9                   	leave  
  802c62:	c3                   	ret    

00802c63 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c63:	55                   	push   %ebp
  802c64:	89 e5                	mov    %esp,%ebp
  802c66:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c69:	a1 38 51 80 00       	mov    0x805138,%eax
  802c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c71:	e9 85 01 00 00       	jmp    802dfb <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c7f:	0f 82 6e 01 00 00    	jb     802df3 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c8e:	0f 85 8a 00 00 00    	jne    802d1e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c98:	75 17                	jne    802cb1 <alloc_block_FF+0x4e>
  802c9a:	83 ec 04             	sub    $0x4,%esp
  802c9d:	68 88 4c 80 00       	push   $0x804c88
  802ca2:	68 93 00 00 00       	push   $0x93
  802ca7:	68 df 4b 80 00       	push   $0x804bdf
  802cac:	e8 d6 df ff ff       	call   800c87 <_panic>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 10                	je     802cca <alloc_block_FF+0x67>
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	8b 00                	mov    (%eax),%eax
  802cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc2:	8b 52 04             	mov    0x4(%edx),%edx
  802cc5:	89 50 04             	mov    %edx,0x4(%eax)
  802cc8:	eb 0b                	jmp    802cd5 <alloc_block_FF+0x72>
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 04             	mov    0x4(%eax),%eax
  802cd0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 40 04             	mov    0x4(%eax),%eax
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	74 0f                	je     802cee <alloc_block_FF+0x8b>
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 04             	mov    0x4(%eax),%eax
  802ce5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce8:	8b 12                	mov    (%edx),%edx
  802cea:	89 10                	mov    %edx,(%eax)
  802cec:	eb 0a                	jmp    802cf8 <alloc_block_FF+0x95>
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	a3 38 51 80 00       	mov    %eax,0x805138
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d10:	48                   	dec    %eax
  802d11:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	e9 10 01 00 00       	jmp    802e2e <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 40 0c             	mov    0xc(%eax),%eax
  802d24:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d27:	0f 86 c6 00 00 00    	jbe    802df3 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d2d:	a1 48 51 80 00       	mov    0x805148,%eax
  802d32:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	8b 50 08             	mov    0x8(%eax),%edx
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d44:	8b 55 08             	mov    0x8(%ebp),%edx
  802d47:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d4e:	75 17                	jne    802d67 <alloc_block_FF+0x104>
  802d50:	83 ec 04             	sub    $0x4,%esp
  802d53:	68 88 4c 80 00       	push   $0x804c88
  802d58:	68 9b 00 00 00       	push   $0x9b
  802d5d:	68 df 4b 80 00       	push   $0x804bdf
  802d62:	e8 20 df ff ff       	call   800c87 <_panic>
  802d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	74 10                	je     802d80 <alloc_block_FF+0x11d>
  802d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d78:	8b 52 04             	mov    0x4(%edx),%edx
  802d7b:	89 50 04             	mov    %edx,0x4(%eax)
  802d7e:	eb 0b                	jmp    802d8b <alloc_block_FF+0x128>
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 0f                	je     802da4 <alloc_block_FF+0x141>
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	8b 40 04             	mov    0x4(%eax),%eax
  802d9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d9e:	8b 12                	mov    (%edx),%edx
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	eb 0a                	jmp    802dae <alloc_block_FF+0x14b>
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	a3 48 51 80 00       	mov    %eax,0x805148
  802dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc1:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc6:	48                   	dec    %eax
  802dc7:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 50 08             	mov    0x8(%eax),%edx
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	01 c2                	add    %eax,%edx
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 40 0c             	mov    0xc(%eax),%eax
  802de3:	2b 45 08             	sub    0x8(%ebp),%eax
  802de6:	89 c2                	mov    %eax,%edx
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df1:	eb 3b                	jmp    802e2e <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802df3:	a1 40 51 80 00       	mov    0x805140,%eax
  802df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dff:	74 07                	je     802e08 <alloc_block_FF+0x1a5>
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 00                	mov    (%eax),%eax
  802e06:	eb 05                	jmp    802e0d <alloc_block_FF+0x1aa>
  802e08:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0d:	a3 40 51 80 00       	mov    %eax,0x805140
  802e12:	a1 40 51 80 00       	mov    0x805140,%eax
  802e17:	85 c0                	test   %eax,%eax
  802e19:	0f 85 57 fe ff ff    	jne    802c76 <alloc_block_FF+0x13>
  802e1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e23:	0f 85 4d fe ff ff    	jne    802c76 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2e:	c9                   	leave  
  802e2f:	c3                   	ret    

00802e30 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
  802e33:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802e36:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e3d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e45:	e9 df 00 00 00       	jmp    802f29 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e53:	0f 82 c8 00 00 00    	jb     802f21 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e62:	0f 85 8a 00 00 00    	jne    802ef2 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802e68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6c:	75 17                	jne    802e85 <alloc_block_BF+0x55>
  802e6e:	83 ec 04             	sub    $0x4,%esp
  802e71:	68 88 4c 80 00       	push   $0x804c88
  802e76:	68 b7 00 00 00       	push   $0xb7
  802e7b:	68 df 4b 80 00       	push   $0x804bdf
  802e80:	e8 02 de ff ff       	call   800c87 <_panic>
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	85 c0                	test   %eax,%eax
  802e8c:	74 10                	je     802e9e <alloc_block_BF+0x6e>
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	8b 00                	mov    (%eax),%eax
  802e93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e96:	8b 52 04             	mov    0x4(%edx),%edx
  802e99:	89 50 04             	mov    %edx,0x4(%eax)
  802e9c:	eb 0b                	jmp    802ea9 <alloc_block_BF+0x79>
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 40 04             	mov    0x4(%eax),%eax
  802ea4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 40 04             	mov    0x4(%eax),%eax
  802eaf:	85 c0                	test   %eax,%eax
  802eb1:	74 0f                	je     802ec2 <alloc_block_BF+0x92>
  802eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb6:	8b 40 04             	mov    0x4(%eax),%eax
  802eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebc:	8b 12                	mov    (%edx),%edx
  802ebe:	89 10                	mov    %edx,(%eax)
  802ec0:	eb 0a                	jmp    802ecc <alloc_block_BF+0x9c>
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	a3 38 51 80 00       	mov    %eax,0x805138
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edf:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee4:	48                   	dec    %eax
  802ee5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	e9 4d 01 00 00       	jmp    80303f <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802efb:	76 24                	jbe    802f21 <alloc_block_BF+0xf1>
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 40 0c             	mov    0xc(%eax),%eax
  802f03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f06:	73 19                	jae    802f21 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802f08:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	8b 40 0c             	mov    0xc(%eax),%eax
  802f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 40 08             	mov    0x8(%eax),%eax
  802f1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802f21:	a1 40 51 80 00       	mov    0x805140,%eax
  802f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2d:	74 07                	je     802f36 <alloc_block_BF+0x106>
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	8b 00                	mov    (%eax),%eax
  802f34:	eb 05                	jmp    802f3b <alloc_block_BF+0x10b>
  802f36:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3b:	a3 40 51 80 00       	mov    %eax,0x805140
  802f40:	a1 40 51 80 00       	mov    0x805140,%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	0f 85 fd fe ff ff    	jne    802e4a <alloc_block_BF+0x1a>
  802f4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f51:	0f 85 f3 fe ff ff    	jne    802e4a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802f57:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f5b:	0f 84 d9 00 00 00    	je     80303a <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f61:	a1 48 51 80 00       	mov    0x805148,%eax
  802f66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f6f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f75:	8b 55 08             	mov    0x8(%ebp),%edx
  802f78:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f7f:	75 17                	jne    802f98 <alloc_block_BF+0x168>
  802f81:	83 ec 04             	sub    $0x4,%esp
  802f84:	68 88 4c 80 00       	push   $0x804c88
  802f89:	68 c7 00 00 00       	push   $0xc7
  802f8e:	68 df 4b 80 00       	push   $0x804bdf
  802f93:	e8 ef dc ff ff       	call   800c87 <_panic>
  802f98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	74 10                	je     802fb1 <alloc_block_BF+0x181>
  802fa1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa4:	8b 00                	mov    (%eax),%eax
  802fa6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fa9:	8b 52 04             	mov    0x4(%edx),%edx
  802fac:	89 50 04             	mov    %edx,0x4(%eax)
  802faf:	eb 0b                	jmp    802fbc <alloc_block_BF+0x18c>
  802fb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb4:	8b 40 04             	mov    0x4(%eax),%eax
  802fb7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbf:	8b 40 04             	mov    0x4(%eax),%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	74 0f                	je     802fd5 <alloc_block_BF+0x1a5>
  802fc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc9:	8b 40 04             	mov    0x4(%eax),%eax
  802fcc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fcf:	8b 12                	mov    (%edx),%edx
  802fd1:	89 10                	mov    %edx,(%eax)
  802fd3:	eb 0a                	jmp    802fdf <alloc_block_BF+0x1af>
  802fd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	a3 48 51 80 00       	mov    %eax,0x805148
  802fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802feb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff2:	a1 54 51 80 00       	mov    0x805154,%eax
  802ff7:	48                   	dec    %eax
  802ff8:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ffd:	83 ec 08             	sub    $0x8,%esp
  803000:	ff 75 ec             	pushl  -0x14(%ebp)
  803003:	68 38 51 80 00       	push   $0x805138
  803008:	e8 71 f9 ff ff       	call   80297e <find_block>
  80300d:	83 c4 10             	add    $0x10,%esp
  803010:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803013:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803016:	8b 50 08             	mov    0x8(%eax),%edx
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	01 c2                	add    %eax,%edx
  80301e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803021:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803024:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803027:	8b 40 0c             	mov    0xc(%eax),%eax
  80302a:	2b 45 08             	sub    0x8(%ebp),%eax
  80302d:	89 c2                	mov    %eax,%edx
  80302f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803032:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803035:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803038:	eb 05                	jmp    80303f <alloc_block_BF+0x20f>
	}
	return NULL;
  80303a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80303f:	c9                   	leave  
  803040:	c3                   	ret    

00803041 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803041:	55                   	push   %ebp
  803042:	89 e5                	mov    %esp,%ebp
  803044:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803047:	a1 28 50 80 00       	mov    0x805028,%eax
  80304c:	85 c0                	test   %eax,%eax
  80304e:	0f 85 de 01 00 00    	jne    803232 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803054:	a1 38 51 80 00       	mov    0x805138,%eax
  803059:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80305c:	e9 9e 01 00 00       	jmp    8031ff <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803064:	8b 40 0c             	mov    0xc(%eax),%eax
  803067:	3b 45 08             	cmp    0x8(%ebp),%eax
  80306a:	0f 82 87 01 00 00    	jb     8031f7 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 40 0c             	mov    0xc(%eax),%eax
  803076:	3b 45 08             	cmp    0x8(%ebp),%eax
  803079:	0f 85 95 00 00 00    	jne    803114 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80307f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803083:	75 17                	jne    80309c <alloc_block_NF+0x5b>
  803085:	83 ec 04             	sub    $0x4,%esp
  803088:	68 88 4c 80 00       	push   $0x804c88
  80308d:	68 e0 00 00 00       	push   $0xe0
  803092:	68 df 4b 80 00       	push   $0x804bdf
  803097:	e8 eb db ff ff       	call   800c87 <_panic>
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 00                	mov    (%eax),%eax
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	74 10                	je     8030b5 <alloc_block_NF+0x74>
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 00                	mov    (%eax),%eax
  8030aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ad:	8b 52 04             	mov    0x4(%edx),%edx
  8030b0:	89 50 04             	mov    %edx,0x4(%eax)
  8030b3:	eb 0b                	jmp    8030c0 <alloc_block_NF+0x7f>
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 40 04             	mov    0x4(%eax),%eax
  8030bb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 40 04             	mov    0x4(%eax),%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 0f                	je     8030d9 <alloc_block_NF+0x98>
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	8b 40 04             	mov    0x4(%eax),%eax
  8030d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d3:	8b 12                	mov    (%edx),%edx
  8030d5:	89 10                	mov    %edx,(%eax)
  8030d7:	eb 0a                	jmp    8030e3 <alloc_block_NF+0xa2>
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8030fb:	48                   	dec    %eax
  8030fc:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803104:	8b 40 08             	mov    0x8(%eax),%eax
  803107:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310f:	e9 f8 04 00 00       	jmp    80360c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803117:	8b 40 0c             	mov    0xc(%eax),%eax
  80311a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80311d:	0f 86 d4 00 00 00    	jbe    8031f7 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803123:	a1 48 51 80 00       	mov    0x805148,%eax
  803128:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	8b 50 08             	mov    0x8(%eax),%edx
  803131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803134:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803137:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313a:	8b 55 08             	mov    0x8(%ebp),%edx
  80313d:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803140:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803144:	75 17                	jne    80315d <alloc_block_NF+0x11c>
  803146:	83 ec 04             	sub    $0x4,%esp
  803149:	68 88 4c 80 00       	push   $0x804c88
  80314e:	68 e9 00 00 00       	push   $0xe9
  803153:	68 df 4b 80 00       	push   $0x804bdf
  803158:	e8 2a db ff ff       	call   800c87 <_panic>
  80315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	85 c0                	test   %eax,%eax
  803164:	74 10                	je     803176 <alloc_block_NF+0x135>
  803166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803169:	8b 00                	mov    (%eax),%eax
  80316b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80316e:	8b 52 04             	mov    0x4(%edx),%edx
  803171:	89 50 04             	mov    %edx,0x4(%eax)
  803174:	eb 0b                	jmp    803181 <alloc_block_NF+0x140>
  803176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803179:	8b 40 04             	mov    0x4(%eax),%eax
  80317c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803184:	8b 40 04             	mov    0x4(%eax),%eax
  803187:	85 c0                	test   %eax,%eax
  803189:	74 0f                	je     80319a <alloc_block_NF+0x159>
  80318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318e:	8b 40 04             	mov    0x4(%eax),%eax
  803191:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803194:	8b 12                	mov    (%edx),%edx
  803196:	89 10                	mov    %edx,(%eax)
  803198:	eb 0a                	jmp    8031a4 <alloc_block_NF+0x163>
  80319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8031bc:	48                   	dec    %eax
  8031bd:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	8b 40 08             	mov    0x8(%eax),%eax
  8031c8:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 50 08             	mov    0x8(%eax),%edx
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	01 c2                	add    %eax,%edx
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8031de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e4:	2b 45 08             	sub    0x8(%ebp),%eax
  8031e7:	89 c2                	mov    %eax,%edx
  8031e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ec:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8031ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f2:	e9 15 04 00 00       	jmp    80360c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8031f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8031fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803203:	74 07                	je     80320c <alloc_block_NF+0x1cb>
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	eb 05                	jmp    803211 <alloc_block_NF+0x1d0>
  80320c:	b8 00 00 00 00       	mov    $0x0,%eax
  803211:	a3 40 51 80 00       	mov    %eax,0x805140
  803216:	a1 40 51 80 00       	mov    0x805140,%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	0f 85 3e fe ff ff    	jne    803061 <alloc_block_NF+0x20>
  803223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803227:	0f 85 34 fe ff ff    	jne    803061 <alloc_block_NF+0x20>
  80322d:	e9 d5 03 00 00       	jmp    803607 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803232:	a1 38 51 80 00       	mov    0x805138,%eax
  803237:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80323a:	e9 b1 01 00 00       	jmp    8033f0 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80323f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803242:	8b 50 08             	mov    0x8(%eax),%edx
  803245:	a1 28 50 80 00       	mov    0x805028,%eax
  80324a:	39 c2                	cmp    %eax,%edx
  80324c:	0f 82 96 01 00 00    	jb     8033e8 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	8b 40 0c             	mov    0xc(%eax),%eax
  803258:	3b 45 08             	cmp    0x8(%ebp),%eax
  80325b:	0f 82 87 01 00 00    	jb     8033e8 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	8b 40 0c             	mov    0xc(%eax),%eax
  803267:	3b 45 08             	cmp    0x8(%ebp),%eax
  80326a:	0f 85 95 00 00 00    	jne    803305 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803270:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803274:	75 17                	jne    80328d <alloc_block_NF+0x24c>
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	68 88 4c 80 00       	push   $0x804c88
  80327e:	68 fc 00 00 00       	push   $0xfc
  803283:	68 df 4b 80 00       	push   $0x804bdf
  803288:	e8 fa d9 ff ff       	call   800c87 <_panic>
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	8b 00                	mov    (%eax),%eax
  803292:	85 c0                	test   %eax,%eax
  803294:	74 10                	je     8032a6 <alloc_block_NF+0x265>
  803296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803299:	8b 00                	mov    (%eax),%eax
  80329b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80329e:	8b 52 04             	mov    0x4(%edx),%edx
  8032a1:	89 50 04             	mov    %edx,0x4(%eax)
  8032a4:	eb 0b                	jmp    8032b1 <alloc_block_NF+0x270>
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	8b 40 04             	mov    0x4(%eax),%eax
  8032b7:	85 c0                	test   %eax,%eax
  8032b9:	74 0f                	je     8032ca <alloc_block_NF+0x289>
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 40 04             	mov    0x4(%eax),%eax
  8032c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c4:	8b 12                	mov    (%edx),%edx
  8032c6:	89 10                	mov    %edx,(%eax)
  8032c8:	eb 0a                	jmp    8032d4 <alloc_block_NF+0x293>
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	8b 00                	mov    (%eax),%eax
  8032cf:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e7:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ec:	48                   	dec    %eax
  8032ed:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	8b 40 08             	mov    0x8(%eax),%eax
  8032f8:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	e9 07 03 00 00       	jmp    80360c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	8b 40 0c             	mov    0xc(%eax),%eax
  80330b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330e:	0f 86 d4 00 00 00    	jbe    8033e8 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803314:	a1 48 51 80 00       	mov    0x805148,%eax
  803319:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331f:	8b 50 08             	mov    0x8(%eax),%edx
  803322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803325:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803328:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332b:	8b 55 08             	mov    0x8(%ebp),%edx
  80332e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803331:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803335:	75 17                	jne    80334e <alloc_block_NF+0x30d>
  803337:	83 ec 04             	sub    $0x4,%esp
  80333a:	68 88 4c 80 00       	push   $0x804c88
  80333f:	68 04 01 00 00       	push   $0x104
  803344:	68 df 4b 80 00       	push   $0x804bdf
  803349:	e8 39 d9 ff ff       	call   800c87 <_panic>
  80334e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803351:	8b 00                	mov    (%eax),%eax
  803353:	85 c0                	test   %eax,%eax
  803355:	74 10                	je     803367 <alloc_block_NF+0x326>
  803357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335f:	8b 52 04             	mov    0x4(%edx),%edx
  803362:	89 50 04             	mov    %edx,0x4(%eax)
  803365:	eb 0b                	jmp    803372 <alloc_block_NF+0x331>
  803367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336a:	8b 40 04             	mov    0x4(%eax),%eax
  80336d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803375:	8b 40 04             	mov    0x4(%eax),%eax
  803378:	85 c0                	test   %eax,%eax
  80337a:	74 0f                	je     80338b <alloc_block_NF+0x34a>
  80337c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337f:	8b 40 04             	mov    0x4(%eax),%eax
  803382:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803385:	8b 12                	mov    (%edx),%edx
  803387:	89 10                	mov    %edx,(%eax)
  803389:	eb 0a                	jmp    803395 <alloc_block_NF+0x354>
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	8b 00                	mov    (%eax),%eax
  803390:	a3 48 51 80 00       	mov    %eax,0x805148
  803395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803398:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ad:	48                   	dec    %eax
  8033ae:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b6:	8b 40 08             	mov    0x8(%eax),%eax
  8033b9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8033be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c1:	8b 50 08             	mov    0x8(%eax),%edx
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	01 c2                	add    %eax,%edx
  8033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cc:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d5:	2b 45 08             	sub    0x8(%ebp),%eax
  8033d8:	89 c2                	mov    %eax,%edx
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e3:	e9 24 02 00 00       	jmp    80360c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8033ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f4:	74 07                	je     8033fd <alloc_block_NF+0x3bc>
  8033f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f9:	8b 00                	mov    (%eax),%eax
  8033fb:	eb 05                	jmp    803402 <alloc_block_NF+0x3c1>
  8033fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803402:	a3 40 51 80 00       	mov    %eax,0x805140
  803407:	a1 40 51 80 00       	mov    0x805140,%eax
  80340c:	85 c0                	test   %eax,%eax
  80340e:	0f 85 2b fe ff ff    	jne    80323f <alloc_block_NF+0x1fe>
  803414:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803418:	0f 85 21 fe ff ff    	jne    80323f <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80341e:	a1 38 51 80 00       	mov    0x805138,%eax
  803423:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803426:	e9 ae 01 00 00       	jmp    8035d9 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80342b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342e:	8b 50 08             	mov    0x8(%eax),%edx
  803431:	a1 28 50 80 00       	mov    0x805028,%eax
  803436:	39 c2                	cmp    %eax,%edx
  803438:	0f 83 93 01 00 00    	jae    8035d1 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80343e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803441:	8b 40 0c             	mov    0xc(%eax),%eax
  803444:	3b 45 08             	cmp    0x8(%ebp),%eax
  803447:	0f 82 84 01 00 00    	jb     8035d1 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80344d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803450:	8b 40 0c             	mov    0xc(%eax),%eax
  803453:	3b 45 08             	cmp    0x8(%ebp),%eax
  803456:	0f 85 95 00 00 00    	jne    8034f1 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80345c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803460:	75 17                	jne    803479 <alloc_block_NF+0x438>
  803462:	83 ec 04             	sub    $0x4,%esp
  803465:	68 88 4c 80 00       	push   $0x804c88
  80346a:	68 14 01 00 00       	push   $0x114
  80346f:	68 df 4b 80 00       	push   $0x804bdf
  803474:	e8 0e d8 ff ff       	call   800c87 <_panic>
  803479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347c:	8b 00                	mov    (%eax),%eax
  80347e:	85 c0                	test   %eax,%eax
  803480:	74 10                	je     803492 <alloc_block_NF+0x451>
  803482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803485:	8b 00                	mov    (%eax),%eax
  803487:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80348a:	8b 52 04             	mov    0x4(%edx),%edx
  80348d:	89 50 04             	mov    %edx,0x4(%eax)
  803490:	eb 0b                	jmp    80349d <alloc_block_NF+0x45c>
  803492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803495:	8b 40 04             	mov    0x4(%eax),%eax
  803498:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a0:	8b 40 04             	mov    0x4(%eax),%eax
  8034a3:	85 c0                	test   %eax,%eax
  8034a5:	74 0f                	je     8034b6 <alloc_block_NF+0x475>
  8034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034aa:	8b 40 04             	mov    0x4(%eax),%eax
  8034ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b0:	8b 12                	mov    (%edx),%edx
  8034b2:	89 10                	mov    %edx,(%eax)
  8034b4:	eb 0a                	jmp    8034c0 <alloc_block_NF+0x47f>
  8034b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b9:	8b 00                	mov    (%eax),%eax
  8034bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8034d8:	48                   	dec    %eax
  8034d9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e1:	8b 40 08             	mov    0x8(%eax),%eax
  8034e4:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8034e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ec:	e9 1b 01 00 00       	jmp    80360c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034fa:	0f 86 d1 00 00 00    	jbe    8035d1 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803500:	a1 48 51 80 00       	mov    0x805148,%eax
  803505:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350b:	8b 50 08             	mov    0x8(%eax),%edx
  80350e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803511:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803517:	8b 55 08             	mov    0x8(%ebp),%edx
  80351a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80351d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803521:	75 17                	jne    80353a <alloc_block_NF+0x4f9>
  803523:	83 ec 04             	sub    $0x4,%esp
  803526:	68 88 4c 80 00       	push   $0x804c88
  80352b:	68 1c 01 00 00       	push   $0x11c
  803530:	68 df 4b 80 00       	push   $0x804bdf
  803535:	e8 4d d7 ff ff       	call   800c87 <_panic>
  80353a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353d:	8b 00                	mov    (%eax),%eax
  80353f:	85 c0                	test   %eax,%eax
  803541:	74 10                	je     803553 <alloc_block_NF+0x512>
  803543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803546:	8b 00                	mov    (%eax),%eax
  803548:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80354b:	8b 52 04             	mov    0x4(%edx),%edx
  80354e:	89 50 04             	mov    %edx,0x4(%eax)
  803551:	eb 0b                	jmp    80355e <alloc_block_NF+0x51d>
  803553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803556:	8b 40 04             	mov    0x4(%eax),%eax
  803559:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80355e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803561:	8b 40 04             	mov    0x4(%eax),%eax
  803564:	85 c0                	test   %eax,%eax
  803566:	74 0f                	je     803577 <alloc_block_NF+0x536>
  803568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356b:	8b 40 04             	mov    0x4(%eax),%eax
  80356e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803571:	8b 12                	mov    (%edx),%edx
  803573:	89 10                	mov    %edx,(%eax)
  803575:	eb 0a                	jmp    803581 <alloc_block_NF+0x540>
  803577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	a3 48 51 80 00       	mov    %eax,0x805148
  803581:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803584:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80358a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803594:	a1 54 51 80 00       	mov    0x805154,%eax
  803599:	48                   	dec    %eax
  80359a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80359f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a2:	8b 40 08             	mov    0x8(%eax),%eax
  8035a5:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8035aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ad:	8b 50 08             	mov    0x8(%eax),%edx
  8035b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b3:	01 c2                	add    %eax,%edx
  8035b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8035bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035be:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c1:	2b 45 08             	sub    0x8(%ebp),%eax
  8035c4:	89 c2                	mov    %eax,%edx
  8035c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8035cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035cf:	eb 3b                	jmp    80360c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8035d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8035d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035dd:	74 07                	je     8035e6 <alloc_block_NF+0x5a5>
  8035df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	eb 05                	jmp    8035eb <alloc_block_NF+0x5aa>
  8035e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035eb:	a3 40 51 80 00       	mov    %eax,0x805140
  8035f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8035f5:	85 c0                	test   %eax,%eax
  8035f7:	0f 85 2e fe ff ff    	jne    80342b <alloc_block_NF+0x3ea>
  8035fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803601:	0f 85 24 fe ff ff    	jne    80342b <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803607:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80360c:	c9                   	leave  
  80360d:	c3                   	ret    

0080360e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80360e:	55                   	push   %ebp
  80360f:	89 e5                	mov    %esp,%ebp
  803611:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803614:	a1 38 51 80 00       	mov    0x805138,%eax
  803619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80361c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803621:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803624:	a1 38 51 80 00       	mov    0x805138,%eax
  803629:	85 c0                	test   %eax,%eax
  80362b:	74 14                	je     803641 <insert_sorted_with_merge_freeList+0x33>
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	8b 50 08             	mov    0x8(%eax),%edx
  803633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803636:	8b 40 08             	mov    0x8(%eax),%eax
  803639:	39 c2                	cmp    %eax,%edx
  80363b:	0f 87 9b 01 00 00    	ja     8037dc <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803641:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803645:	75 17                	jne    80365e <insert_sorted_with_merge_freeList+0x50>
  803647:	83 ec 04             	sub    $0x4,%esp
  80364a:	68 bc 4b 80 00       	push   $0x804bbc
  80364f:	68 38 01 00 00       	push   $0x138
  803654:	68 df 4b 80 00       	push   $0x804bdf
  803659:	e8 29 d6 ff ff       	call   800c87 <_panic>
  80365e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803664:	8b 45 08             	mov    0x8(%ebp),%eax
  803667:	89 10                	mov    %edx,(%eax)
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	85 c0                	test   %eax,%eax
  803670:	74 0d                	je     80367f <insert_sorted_with_merge_freeList+0x71>
  803672:	a1 38 51 80 00       	mov    0x805138,%eax
  803677:	8b 55 08             	mov    0x8(%ebp),%edx
  80367a:	89 50 04             	mov    %edx,0x4(%eax)
  80367d:	eb 08                	jmp    803687 <insert_sorted_with_merge_freeList+0x79>
  80367f:	8b 45 08             	mov    0x8(%ebp),%eax
  803682:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	a3 38 51 80 00       	mov    %eax,0x805138
  80368f:	8b 45 08             	mov    0x8(%ebp),%eax
  803692:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803699:	a1 44 51 80 00       	mov    0x805144,%eax
  80369e:	40                   	inc    %eax
  80369f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036a8:	0f 84 a8 06 00 00    	je     803d56 <insert_sorted_with_merge_freeList+0x748>
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	8b 50 08             	mov    0x8(%eax),%edx
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ba:	01 c2                	add    %eax,%edx
  8036bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036bf:	8b 40 08             	mov    0x8(%eax),%eax
  8036c2:	39 c2                	cmp    %eax,%edx
  8036c4:	0f 85 8c 06 00 00    	jne    803d56 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8036ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8036d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d6:	01 c2                	add    %eax,%edx
  8036d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036db:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8036de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036e2:	75 17                	jne    8036fb <insert_sorted_with_merge_freeList+0xed>
  8036e4:	83 ec 04             	sub    $0x4,%esp
  8036e7:	68 88 4c 80 00       	push   $0x804c88
  8036ec:	68 3c 01 00 00       	push   $0x13c
  8036f1:	68 df 4b 80 00       	push   $0x804bdf
  8036f6:	e8 8c d5 ff ff       	call   800c87 <_panic>
  8036fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036fe:	8b 00                	mov    (%eax),%eax
  803700:	85 c0                	test   %eax,%eax
  803702:	74 10                	je     803714 <insert_sorted_with_merge_freeList+0x106>
  803704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803707:	8b 00                	mov    (%eax),%eax
  803709:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80370c:	8b 52 04             	mov    0x4(%edx),%edx
  80370f:	89 50 04             	mov    %edx,0x4(%eax)
  803712:	eb 0b                	jmp    80371f <insert_sorted_with_merge_freeList+0x111>
  803714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803717:	8b 40 04             	mov    0x4(%eax),%eax
  80371a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80371f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803722:	8b 40 04             	mov    0x4(%eax),%eax
  803725:	85 c0                	test   %eax,%eax
  803727:	74 0f                	je     803738 <insert_sorted_with_merge_freeList+0x12a>
  803729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372c:	8b 40 04             	mov    0x4(%eax),%eax
  80372f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803732:	8b 12                	mov    (%edx),%edx
  803734:	89 10                	mov    %edx,(%eax)
  803736:	eb 0a                	jmp    803742 <insert_sorted_with_merge_freeList+0x134>
  803738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373b:	8b 00                	mov    (%eax),%eax
  80373d:	a3 38 51 80 00       	mov    %eax,0x805138
  803742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803745:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80374b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803755:	a1 44 51 80 00       	mov    0x805144,%eax
  80375a:	48                   	dec    %eax
  80375b:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803763:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80376a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803774:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803778:	75 17                	jne    803791 <insert_sorted_with_merge_freeList+0x183>
  80377a:	83 ec 04             	sub    $0x4,%esp
  80377d:	68 bc 4b 80 00       	push   $0x804bbc
  803782:	68 3f 01 00 00       	push   $0x13f
  803787:	68 df 4b 80 00       	push   $0x804bdf
  80378c:	e8 f6 d4 ff ff       	call   800c87 <_panic>
  803791:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379a:	89 10                	mov    %edx,(%eax)
  80379c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	85 c0                	test   %eax,%eax
  8037a3:	74 0d                	je     8037b2 <insert_sorted_with_merge_freeList+0x1a4>
  8037a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8037aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037ad:	89 50 04             	mov    %edx,0x4(%eax)
  8037b0:	eb 08                	jmp    8037ba <insert_sorted_with_merge_freeList+0x1ac>
  8037b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8037c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8037d1:	40                   	inc    %eax
  8037d2:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037d7:	e9 7a 05 00 00       	jmp    803d56 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8037dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037df:	8b 50 08             	mov    0x8(%eax),%edx
  8037e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e5:	8b 40 08             	mov    0x8(%eax),%eax
  8037e8:	39 c2                	cmp    %eax,%edx
  8037ea:	0f 82 14 01 00 00    	jb     803904 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8037f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f3:	8b 50 08             	mov    0x8(%eax),%edx
  8037f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8037fc:	01 c2                	add    %eax,%edx
  8037fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803801:	8b 40 08             	mov    0x8(%eax),%eax
  803804:	39 c2                	cmp    %eax,%edx
  803806:	0f 85 90 00 00 00    	jne    80389c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80380c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380f:	8b 50 0c             	mov    0xc(%eax),%edx
  803812:	8b 45 08             	mov    0x8(%ebp),%eax
  803815:	8b 40 0c             	mov    0xc(%eax),%eax
  803818:	01 c2                	add    %eax,%edx
  80381a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803820:	8b 45 08             	mov    0x8(%ebp),%eax
  803823:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80382a:	8b 45 08             	mov    0x8(%ebp),%eax
  80382d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803834:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803838:	75 17                	jne    803851 <insert_sorted_with_merge_freeList+0x243>
  80383a:	83 ec 04             	sub    $0x4,%esp
  80383d:	68 bc 4b 80 00       	push   $0x804bbc
  803842:	68 49 01 00 00       	push   $0x149
  803847:	68 df 4b 80 00       	push   $0x804bdf
  80384c:	e8 36 d4 ff ff       	call   800c87 <_panic>
  803851:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803857:	8b 45 08             	mov    0x8(%ebp),%eax
  80385a:	89 10                	mov    %edx,(%eax)
  80385c:	8b 45 08             	mov    0x8(%ebp),%eax
  80385f:	8b 00                	mov    (%eax),%eax
  803861:	85 c0                	test   %eax,%eax
  803863:	74 0d                	je     803872 <insert_sorted_with_merge_freeList+0x264>
  803865:	a1 48 51 80 00       	mov    0x805148,%eax
  80386a:	8b 55 08             	mov    0x8(%ebp),%edx
  80386d:	89 50 04             	mov    %edx,0x4(%eax)
  803870:	eb 08                	jmp    80387a <insert_sorted_with_merge_freeList+0x26c>
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80387a:	8b 45 08             	mov    0x8(%ebp),%eax
  80387d:	a3 48 51 80 00       	mov    %eax,0x805148
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80388c:	a1 54 51 80 00       	mov    0x805154,%eax
  803891:	40                   	inc    %eax
  803892:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803897:	e9 bb 04 00 00       	jmp    803d57 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80389c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a0:	75 17                	jne    8038b9 <insert_sorted_with_merge_freeList+0x2ab>
  8038a2:	83 ec 04             	sub    $0x4,%esp
  8038a5:	68 30 4c 80 00       	push   $0x804c30
  8038aa:	68 4c 01 00 00       	push   $0x14c
  8038af:	68 df 4b 80 00       	push   $0x804bdf
  8038b4:	e8 ce d3 ff ff       	call   800c87 <_panic>
  8038b9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	89 50 04             	mov    %edx,0x4(%eax)
  8038c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c8:	8b 40 04             	mov    0x4(%eax),%eax
  8038cb:	85 c0                	test   %eax,%eax
  8038cd:	74 0c                	je     8038db <insert_sorted_with_merge_freeList+0x2cd>
  8038cf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8038d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d7:	89 10                	mov    %edx,(%eax)
  8038d9:	eb 08                	jmp    8038e3 <insert_sorted_with_merge_freeList+0x2d5>
  8038db:	8b 45 08             	mov    0x8(%ebp),%eax
  8038de:	a3 38 51 80 00       	mov    %eax,0x805138
  8038e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8038f9:	40                   	inc    %eax
  8038fa:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038ff:	e9 53 04 00 00       	jmp    803d57 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803904:	a1 38 51 80 00       	mov    0x805138,%eax
  803909:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80390c:	e9 15 04 00 00       	jmp    803d26 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803914:	8b 00                	mov    (%eax),%eax
  803916:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803919:	8b 45 08             	mov    0x8(%ebp),%eax
  80391c:	8b 50 08             	mov    0x8(%eax),%edx
  80391f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803922:	8b 40 08             	mov    0x8(%eax),%eax
  803925:	39 c2                	cmp    %eax,%edx
  803927:	0f 86 f1 03 00 00    	jbe    803d1e <insert_sorted_with_merge_freeList+0x710>
  80392d:	8b 45 08             	mov    0x8(%ebp),%eax
  803930:	8b 50 08             	mov    0x8(%eax),%edx
  803933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803936:	8b 40 08             	mov    0x8(%eax),%eax
  803939:	39 c2                	cmp    %eax,%edx
  80393b:	0f 83 dd 03 00 00    	jae    803d1e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803944:	8b 50 08             	mov    0x8(%eax),%edx
  803947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394a:	8b 40 0c             	mov    0xc(%eax),%eax
  80394d:	01 c2                	add    %eax,%edx
  80394f:	8b 45 08             	mov    0x8(%ebp),%eax
  803952:	8b 40 08             	mov    0x8(%eax),%eax
  803955:	39 c2                	cmp    %eax,%edx
  803957:	0f 85 b9 01 00 00    	jne    803b16 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80395d:	8b 45 08             	mov    0x8(%ebp),%eax
  803960:	8b 50 08             	mov    0x8(%eax),%edx
  803963:	8b 45 08             	mov    0x8(%ebp),%eax
  803966:	8b 40 0c             	mov    0xc(%eax),%eax
  803969:	01 c2                	add    %eax,%edx
  80396b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396e:	8b 40 08             	mov    0x8(%eax),%eax
  803971:	39 c2                	cmp    %eax,%edx
  803973:	0f 85 0d 01 00 00    	jne    803a86 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397c:	8b 50 0c             	mov    0xc(%eax),%edx
  80397f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803982:	8b 40 0c             	mov    0xc(%eax),%eax
  803985:	01 c2                	add    %eax,%edx
  803987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80398d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803991:	75 17                	jne    8039aa <insert_sorted_with_merge_freeList+0x39c>
  803993:	83 ec 04             	sub    $0x4,%esp
  803996:	68 88 4c 80 00       	push   $0x804c88
  80399b:	68 5c 01 00 00       	push   $0x15c
  8039a0:	68 df 4b 80 00       	push   $0x804bdf
  8039a5:	e8 dd d2 ff ff       	call   800c87 <_panic>
  8039aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ad:	8b 00                	mov    (%eax),%eax
  8039af:	85 c0                	test   %eax,%eax
  8039b1:	74 10                	je     8039c3 <insert_sorted_with_merge_freeList+0x3b5>
  8039b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b6:	8b 00                	mov    (%eax),%eax
  8039b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039bb:	8b 52 04             	mov    0x4(%edx),%edx
  8039be:	89 50 04             	mov    %edx,0x4(%eax)
  8039c1:	eb 0b                	jmp    8039ce <insert_sorted_with_merge_freeList+0x3c0>
  8039c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c6:	8b 40 04             	mov    0x4(%eax),%eax
  8039c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d1:	8b 40 04             	mov    0x4(%eax),%eax
  8039d4:	85 c0                	test   %eax,%eax
  8039d6:	74 0f                	je     8039e7 <insert_sorted_with_merge_freeList+0x3d9>
  8039d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039db:	8b 40 04             	mov    0x4(%eax),%eax
  8039de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039e1:	8b 12                	mov    (%edx),%edx
  8039e3:	89 10                	mov    %edx,(%eax)
  8039e5:	eb 0a                	jmp    8039f1 <insert_sorted_with_merge_freeList+0x3e3>
  8039e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ea:	8b 00                	mov    (%eax),%eax
  8039ec:	a3 38 51 80 00       	mov    %eax,0x805138
  8039f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a04:	a1 44 51 80 00       	mov    0x805144,%eax
  803a09:	48                   	dec    %eax
  803a0a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a23:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a27:	75 17                	jne    803a40 <insert_sorted_with_merge_freeList+0x432>
  803a29:	83 ec 04             	sub    $0x4,%esp
  803a2c:	68 bc 4b 80 00       	push   $0x804bbc
  803a31:	68 5f 01 00 00       	push   $0x15f
  803a36:	68 df 4b 80 00       	push   $0x804bdf
  803a3b:	e8 47 d2 ff ff       	call   800c87 <_panic>
  803a40:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a49:	89 10                	mov    %edx,(%eax)
  803a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4e:	8b 00                	mov    (%eax),%eax
  803a50:	85 c0                	test   %eax,%eax
  803a52:	74 0d                	je     803a61 <insert_sorted_with_merge_freeList+0x453>
  803a54:	a1 48 51 80 00       	mov    0x805148,%eax
  803a59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a5c:	89 50 04             	mov    %edx,0x4(%eax)
  803a5f:	eb 08                	jmp    803a69 <insert_sorted_with_merge_freeList+0x45b>
  803a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a64:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6c:	a3 48 51 80 00       	mov    %eax,0x805148
  803a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a7b:	a1 54 51 80 00       	mov    0x805154,%eax
  803a80:	40                   	inc    %eax
  803a81:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a89:	8b 50 0c             	mov    0xc(%eax),%edx
  803a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8f:	8b 40 0c             	mov    0xc(%eax),%eax
  803a92:	01 c2                	add    %eax,%edx
  803a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a97:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803aae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ab2:	75 17                	jne    803acb <insert_sorted_with_merge_freeList+0x4bd>
  803ab4:	83 ec 04             	sub    $0x4,%esp
  803ab7:	68 bc 4b 80 00       	push   $0x804bbc
  803abc:	68 64 01 00 00       	push   $0x164
  803ac1:	68 df 4b 80 00       	push   $0x804bdf
  803ac6:	e8 bc d1 ff ff       	call   800c87 <_panic>
  803acb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad4:	89 10                	mov    %edx,(%eax)
  803ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad9:	8b 00                	mov    (%eax),%eax
  803adb:	85 c0                	test   %eax,%eax
  803add:	74 0d                	je     803aec <insert_sorted_with_merge_freeList+0x4de>
  803adf:	a1 48 51 80 00       	mov    0x805148,%eax
  803ae4:	8b 55 08             	mov    0x8(%ebp),%edx
  803ae7:	89 50 04             	mov    %edx,0x4(%eax)
  803aea:	eb 08                	jmp    803af4 <insert_sorted_with_merge_freeList+0x4e6>
  803aec:	8b 45 08             	mov    0x8(%ebp),%eax
  803aef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803af4:	8b 45 08             	mov    0x8(%ebp),%eax
  803af7:	a3 48 51 80 00       	mov    %eax,0x805148
  803afc:	8b 45 08             	mov    0x8(%ebp),%eax
  803aff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b06:	a1 54 51 80 00       	mov    0x805154,%eax
  803b0b:	40                   	inc    %eax
  803b0c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803b11:	e9 41 02 00 00       	jmp    803d57 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803b16:	8b 45 08             	mov    0x8(%ebp),%eax
  803b19:	8b 50 08             	mov    0x8(%eax),%edx
  803b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1f:	8b 40 0c             	mov    0xc(%eax),%eax
  803b22:	01 c2                	add    %eax,%edx
  803b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b27:	8b 40 08             	mov    0x8(%eax),%eax
  803b2a:	39 c2                	cmp    %eax,%edx
  803b2c:	0f 85 7c 01 00 00    	jne    803cae <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803b32:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b36:	74 06                	je     803b3e <insert_sorted_with_merge_freeList+0x530>
  803b38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b3c:	75 17                	jne    803b55 <insert_sorted_with_merge_freeList+0x547>
  803b3e:	83 ec 04             	sub    $0x4,%esp
  803b41:	68 f8 4b 80 00       	push   $0x804bf8
  803b46:	68 69 01 00 00       	push   $0x169
  803b4b:	68 df 4b 80 00       	push   $0x804bdf
  803b50:	e8 32 d1 ff ff       	call   800c87 <_panic>
  803b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b58:	8b 50 04             	mov    0x4(%eax),%edx
  803b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5e:	89 50 04             	mov    %edx,0x4(%eax)
  803b61:	8b 45 08             	mov    0x8(%ebp),%eax
  803b64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b67:	89 10                	mov    %edx,(%eax)
  803b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6c:	8b 40 04             	mov    0x4(%eax),%eax
  803b6f:	85 c0                	test   %eax,%eax
  803b71:	74 0d                	je     803b80 <insert_sorted_with_merge_freeList+0x572>
  803b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b76:	8b 40 04             	mov    0x4(%eax),%eax
  803b79:	8b 55 08             	mov    0x8(%ebp),%edx
  803b7c:	89 10                	mov    %edx,(%eax)
  803b7e:	eb 08                	jmp    803b88 <insert_sorted_with_merge_freeList+0x57a>
  803b80:	8b 45 08             	mov    0x8(%ebp),%eax
  803b83:	a3 38 51 80 00       	mov    %eax,0x805138
  803b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8b:	8b 55 08             	mov    0x8(%ebp),%edx
  803b8e:	89 50 04             	mov    %edx,0x4(%eax)
  803b91:	a1 44 51 80 00       	mov    0x805144,%eax
  803b96:	40                   	inc    %eax
  803b97:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9f:	8b 50 0c             	mov    0xc(%eax),%edx
  803ba2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  803ba8:	01 c2                	add    %eax,%edx
  803baa:	8b 45 08             	mov    0x8(%ebp),%eax
  803bad:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803bb0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bb4:	75 17                	jne    803bcd <insert_sorted_with_merge_freeList+0x5bf>
  803bb6:	83 ec 04             	sub    $0x4,%esp
  803bb9:	68 88 4c 80 00       	push   $0x804c88
  803bbe:	68 6b 01 00 00       	push   $0x16b
  803bc3:	68 df 4b 80 00       	push   $0x804bdf
  803bc8:	e8 ba d0 ff ff       	call   800c87 <_panic>
  803bcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd0:	8b 00                	mov    (%eax),%eax
  803bd2:	85 c0                	test   %eax,%eax
  803bd4:	74 10                	je     803be6 <insert_sorted_with_merge_freeList+0x5d8>
  803bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd9:	8b 00                	mov    (%eax),%eax
  803bdb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bde:	8b 52 04             	mov    0x4(%edx),%edx
  803be1:	89 50 04             	mov    %edx,0x4(%eax)
  803be4:	eb 0b                	jmp    803bf1 <insert_sorted_with_merge_freeList+0x5e3>
  803be6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be9:	8b 40 04             	mov    0x4(%eax),%eax
  803bec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf4:	8b 40 04             	mov    0x4(%eax),%eax
  803bf7:	85 c0                	test   %eax,%eax
  803bf9:	74 0f                	je     803c0a <insert_sorted_with_merge_freeList+0x5fc>
  803bfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bfe:	8b 40 04             	mov    0x4(%eax),%eax
  803c01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c04:	8b 12                	mov    (%edx),%edx
  803c06:	89 10                	mov    %edx,(%eax)
  803c08:	eb 0a                	jmp    803c14 <insert_sorted_with_merge_freeList+0x606>
  803c0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0d:	8b 00                	mov    (%eax),%eax
  803c0f:	a3 38 51 80 00       	mov    %eax,0x805138
  803c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c27:	a1 44 51 80 00       	mov    0x805144,%eax
  803c2c:	48                   	dec    %eax
  803c2d:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803c32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803c3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c3f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c46:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c4a:	75 17                	jne    803c63 <insert_sorted_with_merge_freeList+0x655>
  803c4c:	83 ec 04             	sub    $0x4,%esp
  803c4f:	68 bc 4b 80 00       	push   $0x804bbc
  803c54:	68 6e 01 00 00       	push   $0x16e
  803c59:	68 df 4b 80 00       	push   $0x804bdf
  803c5e:	e8 24 d0 ff ff       	call   800c87 <_panic>
  803c63:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6c:	89 10                	mov    %edx,(%eax)
  803c6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c71:	8b 00                	mov    (%eax),%eax
  803c73:	85 c0                	test   %eax,%eax
  803c75:	74 0d                	je     803c84 <insert_sorted_with_merge_freeList+0x676>
  803c77:	a1 48 51 80 00       	mov    0x805148,%eax
  803c7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c7f:	89 50 04             	mov    %edx,0x4(%eax)
  803c82:	eb 08                	jmp    803c8c <insert_sorted_with_merge_freeList+0x67e>
  803c84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c87:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c8f:	a3 48 51 80 00       	mov    %eax,0x805148
  803c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c9e:	a1 54 51 80 00       	mov    0x805154,%eax
  803ca3:	40                   	inc    %eax
  803ca4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ca9:	e9 a9 00 00 00       	jmp    803d57 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803cae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cb2:	74 06                	je     803cba <insert_sorted_with_merge_freeList+0x6ac>
  803cb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cb8:	75 17                	jne    803cd1 <insert_sorted_with_merge_freeList+0x6c3>
  803cba:	83 ec 04             	sub    $0x4,%esp
  803cbd:	68 54 4c 80 00       	push   $0x804c54
  803cc2:	68 73 01 00 00       	push   $0x173
  803cc7:	68 df 4b 80 00       	push   $0x804bdf
  803ccc:	e8 b6 cf ff ff       	call   800c87 <_panic>
  803cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd4:	8b 10                	mov    (%eax),%edx
  803cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd9:	89 10                	mov    %edx,(%eax)
  803cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cde:	8b 00                	mov    (%eax),%eax
  803ce0:	85 c0                	test   %eax,%eax
  803ce2:	74 0b                	je     803cef <insert_sorted_with_merge_freeList+0x6e1>
  803ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce7:	8b 00                	mov    (%eax),%eax
  803ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  803cec:	89 50 04             	mov    %edx,0x4(%eax)
  803cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  803cf5:	89 10                	mov    %edx,(%eax)
  803cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cfd:	89 50 04             	mov    %edx,0x4(%eax)
  803d00:	8b 45 08             	mov    0x8(%ebp),%eax
  803d03:	8b 00                	mov    (%eax),%eax
  803d05:	85 c0                	test   %eax,%eax
  803d07:	75 08                	jne    803d11 <insert_sorted_with_merge_freeList+0x703>
  803d09:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d11:	a1 44 51 80 00       	mov    0x805144,%eax
  803d16:	40                   	inc    %eax
  803d17:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803d1c:	eb 39                	jmp    803d57 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803d1e:	a1 40 51 80 00       	mov    0x805140,%eax
  803d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d2a:	74 07                	je     803d33 <insert_sorted_with_merge_freeList+0x725>
  803d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2f:	8b 00                	mov    (%eax),%eax
  803d31:	eb 05                	jmp    803d38 <insert_sorted_with_merge_freeList+0x72a>
  803d33:	b8 00 00 00 00       	mov    $0x0,%eax
  803d38:	a3 40 51 80 00       	mov    %eax,0x805140
  803d3d:	a1 40 51 80 00       	mov    0x805140,%eax
  803d42:	85 c0                	test   %eax,%eax
  803d44:	0f 85 c7 fb ff ff    	jne    803911 <insert_sorted_with_merge_freeList+0x303>
  803d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d4e:	0f 85 bd fb ff ff    	jne    803911 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d54:	eb 01                	jmp    803d57 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803d56:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d57:	90                   	nop
  803d58:	c9                   	leave  
  803d59:	c3                   	ret    

00803d5a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803d5a:	55                   	push   %ebp
  803d5b:	89 e5                	mov    %esp,%ebp
  803d5d:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803d60:	8b 55 08             	mov    0x8(%ebp),%edx
  803d63:	89 d0                	mov    %edx,%eax
  803d65:	c1 e0 02             	shl    $0x2,%eax
  803d68:	01 d0                	add    %edx,%eax
  803d6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d71:	01 d0                	add    %edx,%eax
  803d73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d7a:	01 d0                	add    %edx,%eax
  803d7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d83:	01 d0                	add    %edx,%eax
  803d85:	c1 e0 04             	shl    $0x4,%eax
  803d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803d8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803d92:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803d95:	83 ec 0c             	sub    $0xc,%esp
  803d98:	50                   	push   %eax
  803d99:	e8 26 e7 ff ff       	call   8024c4 <sys_get_virtual_time>
  803d9e:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803da1:	eb 41                	jmp    803de4 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803da3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803da6:	83 ec 0c             	sub    $0xc,%esp
  803da9:	50                   	push   %eax
  803daa:	e8 15 e7 ff ff       	call   8024c4 <sys_get_virtual_time>
  803daf:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803db2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803db5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803db8:	29 c2                	sub    %eax,%edx
  803dba:	89 d0                	mov    %edx,%eax
  803dbc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803dbf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dc5:	89 d1                	mov    %edx,%ecx
  803dc7:	29 c1                	sub    %eax,%ecx
  803dc9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803dcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dcf:	39 c2                	cmp    %eax,%edx
  803dd1:	0f 97 c0             	seta   %al
  803dd4:	0f b6 c0             	movzbl %al,%eax
  803dd7:	29 c1                	sub    %eax,%ecx
  803dd9:	89 c8                	mov    %ecx,%eax
  803ddb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803dde:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803dea:	72 b7                	jb     803da3 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803dec:	90                   	nop
  803ded:	c9                   	leave  
  803dee:	c3                   	ret    

00803def <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803def:	55                   	push   %ebp
  803df0:	89 e5                	mov    %esp,%ebp
  803df2:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803df5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803dfc:	eb 03                	jmp    803e01 <busy_wait+0x12>
  803dfe:	ff 45 fc             	incl   -0x4(%ebp)
  803e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803e04:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e07:	72 f5                	jb     803dfe <busy_wait+0xf>
	return i;
  803e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803e0c:	c9                   	leave  
  803e0d:	c3                   	ret    
  803e0e:	66 90                	xchg   %ax,%ax

00803e10 <__udivdi3>:
  803e10:	55                   	push   %ebp
  803e11:	57                   	push   %edi
  803e12:	56                   	push   %esi
  803e13:	53                   	push   %ebx
  803e14:	83 ec 1c             	sub    $0x1c,%esp
  803e17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e27:	89 ca                	mov    %ecx,%edx
  803e29:	89 f8                	mov    %edi,%eax
  803e2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e2f:	85 f6                	test   %esi,%esi
  803e31:	75 2d                	jne    803e60 <__udivdi3+0x50>
  803e33:	39 cf                	cmp    %ecx,%edi
  803e35:	77 65                	ja     803e9c <__udivdi3+0x8c>
  803e37:	89 fd                	mov    %edi,%ebp
  803e39:	85 ff                	test   %edi,%edi
  803e3b:	75 0b                	jne    803e48 <__udivdi3+0x38>
  803e3d:	b8 01 00 00 00       	mov    $0x1,%eax
  803e42:	31 d2                	xor    %edx,%edx
  803e44:	f7 f7                	div    %edi
  803e46:	89 c5                	mov    %eax,%ebp
  803e48:	31 d2                	xor    %edx,%edx
  803e4a:	89 c8                	mov    %ecx,%eax
  803e4c:	f7 f5                	div    %ebp
  803e4e:	89 c1                	mov    %eax,%ecx
  803e50:	89 d8                	mov    %ebx,%eax
  803e52:	f7 f5                	div    %ebp
  803e54:	89 cf                	mov    %ecx,%edi
  803e56:	89 fa                	mov    %edi,%edx
  803e58:	83 c4 1c             	add    $0x1c,%esp
  803e5b:	5b                   	pop    %ebx
  803e5c:	5e                   	pop    %esi
  803e5d:	5f                   	pop    %edi
  803e5e:	5d                   	pop    %ebp
  803e5f:	c3                   	ret    
  803e60:	39 ce                	cmp    %ecx,%esi
  803e62:	77 28                	ja     803e8c <__udivdi3+0x7c>
  803e64:	0f bd fe             	bsr    %esi,%edi
  803e67:	83 f7 1f             	xor    $0x1f,%edi
  803e6a:	75 40                	jne    803eac <__udivdi3+0x9c>
  803e6c:	39 ce                	cmp    %ecx,%esi
  803e6e:	72 0a                	jb     803e7a <__udivdi3+0x6a>
  803e70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e74:	0f 87 9e 00 00 00    	ja     803f18 <__udivdi3+0x108>
  803e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e7f:	89 fa                	mov    %edi,%edx
  803e81:	83 c4 1c             	add    $0x1c,%esp
  803e84:	5b                   	pop    %ebx
  803e85:	5e                   	pop    %esi
  803e86:	5f                   	pop    %edi
  803e87:	5d                   	pop    %ebp
  803e88:	c3                   	ret    
  803e89:	8d 76 00             	lea    0x0(%esi),%esi
  803e8c:	31 ff                	xor    %edi,%edi
  803e8e:	31 c0                	xor    %eax,%eax
  803e90:	89 fa                	mov    %edi,%edx
  803e92:	83 c4 1c             	add    $0x1c,%esp
  803e95:	5b                   	pop    %ebx
  803e96:	5e                   	pop    %esi
  803e97:	5f                   	pop    %edi
  803e98:	5d                   	pop    %ebp
  803e99:	c3                   	ret    
  803e9a:	66 90                	xchg   %ax,%ax
  803e9c:	89 d8                	mov    %ebx,%eax
  803e9e:	f7 f7                	div    %edi
  803ea0:	31 ff                	xor    %edi,%edi
  803ea2:	89 fa                	mov    %edi,%edx
  803ea4:	83 c4 1c             	add    $0x1c,%esp
  803ea7:	5b                   	pop    %ebx
  803ea8:	5e                   	pop    %esi
  803ea9:	5f                   	pop    %edi
  803eaa:	5d                   	pop    %ebp
  803eab:	c3                   	ret    
  803eac:	bd 20 00 00 00       	mov    $0x20,%ebp
  803eb1:	89 eb                	mov    %ebp,%ebx
  803eb3:	29 fb                	sub    %edi,%ebx
  803eb5:	89 f9                	mov    %edi,%ecx
  803eb7:	d3 e6                	shl    %cl,%esi
  803eb9:	89 c5                	mov    %eax,%ebp
  803ebb:	88 d9                	mov    %bl,%cl
  803ebd:	d3 ed                	shr    %cl,%ebp
  803ebf:	89 e9                	mov    %ebp,%ecx
  803ec1:	09 f1                	or     %esi,%ecx
  803ec3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ec7:	89 f9                	mov    %edi,%ecx
  803ec9:	d3 e0                	shl    %cl,%eax
  803ecb:	89 c5                	mov    %eax,%ebp
  803ecd:	89 d6                	mov    %edx,%esi
  803ecf:	88 d9                	mov    %bl,%cl
  803ed1:	d3 ee                	shr    %cl,%esi
  803ed3:	89 f9                	mov    %edi,%ecx
  803ed5:	d3 e2                	shl    %cl,%edx
  803ed7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803edb:	88 d9                	mov    %bl,%cl
  803edd:	d3 e8                	shr    %cl,%eax
  803edf:	09 c2                	or     %eax,%edx
  803ee1:	89 d0                	mov    %edx,%eax
  803ee3:	89 f2                	mov    %esi,%edx
  803ee5:	f7 74 24 0c          	divl   0xc(%esp)
  803ee9:	89 d6                	mov    %edx,%esi
  803eeb:	89 c3                	mov    %eax,%ebx
  803eed:	f7 e5                	mul    %ebp
  803eef:	39 d6                	cmp    %edx,%esi
  803ef1:	72 19                	jb     803f0c <__udivdi3+0xfc>
  803ef3:	74 0b                	je     803f00 <__udivdi3+0xf0>
  803ef5:	89 d8                	mov    %ebx,%eax
  803ef7:	31 ff                	xor    %edi,%edi
  803ef9:	e9 58 ff ff ff       	jmp    803e56 <__udivdi3+0x46>
  803efe:	66 90                	xchg   %ax,%ax
  803f00:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f04:	89 f9                	mov    %edi,%ecx
  803f06:	d3 e2                	shl    %cl,%edx
  803f08:	39 c2                	cmp    %eax,%edx
  803f0a:	73 e9                	jae    803ef5 <__udivdi3+0xe5>
  803f0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f0f:	31 ff                	xor    %edi,%edi
  803f11:	e9 40 ff ff ff       	jmp    803e56 <__udivdi3+0x46>
  803f16:	66 90                	xchg   %ax,%ax
  803f18:	31 c0                	xor    %eax,%eax
  803f1a:	e9 37 ff ff ff       	jmp    803e56 <__udivdi3+0x46>
  803f1f:	90                   	nop

00803f20 <__umoddi3>:
  803f20:	55                   	push   %ebp
  803f21:	57                   	push   %edi
  803f22:	56                   	push   %esi
  803f23:	53                   	push   %ebx
  803f24:	83 ec 1c             	sub    $0x1c,%esp
  803f27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f3f:	89 f3                	mov    %esi,%ebx
  803f41:	89 fa                	mov    %edi,%edx
  803f43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f47:	89 34 24             	mov    %esi,(%esp)
  803f4a:	85 c0                	test   %eax,%eax
  803f4c:	75 1a                	jne    803f68 <__umoddi3+0x48>
  803f4e:	39 f7                	cmp    %esi,%edi
  803f50:	0f 86 a2 00 00 00    	jbe    803ff8 <__umoddi3+0xd8>
  803f56:	89 c8                	mov    %ecx,%eax
  803f58:	89 f2                	mov    %esi,%edx
  803f5a:	f7 f7                	div    %edi
  803f5c:	89 d0                	mov    %edx,%eax
  803f5e:	31 d2                	xor    %edx,%edx
  803f60:	83 c4 1c             	add    $0x1c,%esp
  803f63:	5b                   	pop    %ebx
  803f64:	5e                   	pop    %esi
  803f65:	5f                   	pop    %edi
  803f66:	5d                   	pop    %ebp
  803f67:	c3                   	ret    
  803f68:	39 f0                	cmp    %esi,%eax
  803f6a:	0f 87 ac 00 00 00    	ja     80401c <__umoddi3+0xfc>
  803f70:	0f bd e8             	bsr    %eax,%ebp
  803f73:	83 f5 1f             	xor    $0x1f,%ebp
  803f76:	0f 84 ac 00 00 00    	je     804028 <__umoddi3+0x108>
  803f7c:	bf 20 00 00 00       	mov    $0x20,%edi
  803f81:	29 ef                	sub    %ebp,%edi
  803f83:	89 fe                	mov    %edi,%esi
  803f85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f89:	89 e9                	mov    %ebp,%ecx
  803f8b:	d3 e0                	shl    %cl,%eax
  803f8d:	89 d7                	mov    %edx,%edi
  803f8f:	89 f1                	mov    %esi,%ecx
  803f91:	d3 ef                	shr    %cl,%edi
  803f93:	09 c7                	or     %eax,%edi
  803f95:	89 e9                	mov    %ebp,%ecx
  803f97:	d3 e2                	shl    %cl,%edx
  803f99:	89 14 24             	mov    %edx,(%esp)
  803f9c:	89 d8                	mov    %ebx,%eax
  803f9e:	d3 e0                	shl    %cl,%eax
  803fa0:	89 c2                	mov    %eax,%edx
  803fa2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fa6:	d3 e0                	shl    %cl,%eax
  803fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fac:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fb0:	89 f1                	mov    %esi,%ecx
  803fb2:	d3 e8                	shr    %cl,%eax
  803fb4:	09 d0                	or     %edx,%eax
  803fb6:	d3 eb                	shr    %cl,%ebx
  803fb8:	89 da                	mov    %ebx,%edx
  803fba:	f7 f7                	div    %edi
  803fbc:	89 d3                	mov    %edx,%ebx
  803fbe:	f7 24 24             	mull   (%esp)
  803fc1:	89 c6                	mov    %eax,%esi
  803fc3:	89 d1                	mov    %edx,%ecx
  803fc5:	39 d3                	cmp    %edx,%ebx
  803fc7:	0f 82 87 00 00 00    	jb     804054 <__umoddi3+0x134>
  803fcd:	0f 84 91 00 00 00    	je     804064 <__umoddi3+0x144>
  803fd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803fd7:	29 f2                	sub    %esi,%edx
  803fd9:	19 cb                	sbb    %ecx,%ebx
  803fdb:	89 d8                	mov    %ebx,%eax
  803fdd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803fe1:	d3 e0                	shl    %cl,%eax
  803fe3:	89 e9                	mov    %ebp,%ecx
  803fe5:	d3 ea                	shr    %cl,%edx
  803fe7:	09 d0                	or     %edx,%eax
  803fe9:	89 e9                	mov    %ebp,%ecx
  803feb:	d3 eb                	shr    %cl,%ebx
  803fed:	89 da                	mov    %ebx,%edx
  803fef:	83 c4 1c             	add    $0x1c,%esp
  803ff2:	5b                   	pop    %ebx
  803ff3:	5e                   	pop    %esi
  803ff4:	5f                   	pop    %edi
  803ff5:	5d                   	pop    %ebp
  803ff6:	c3                   	ret    
  803ff7:	90                   	nop
  803ff8:	89 fd                	mov    %edi,%ebp
  803ffa:	85 ff                	test   %edi,%edi
  803ffc:	75 0b                	jne    804009 <__umoddi3+0xe9>
  803ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  804003:	31 d2                	xor    %edx,%edx
  804005:	f7 f7                	div    %edi
  804007:	89 c5                	mov    %eax,%ebp
  804009:	89 f0                	mov    %esi,%eax
  80400b:	31 d2                	xor    %edx,%edx
  80400d:	f7 f5                	div    %ebp
  80400f:	89 c8                	mov    %ecx,%eax
  804011:	f7 f5                	div    %ebp
  804013:	89 d0                	mov    %edx,%eax
  804015:	e9 44 ff ff ff       	jmp    803f5e <__umoddi3+0x3e>
  80401a:	66 90                	xchg   %ax,%ax
  80401c:	89 c8                	mov    %ecx,%eax
  80401e:	89 f2                	mov    %esi,%edx
  804020:	83 c4 1c             	add    $0x1c,%esp
  804023:	5b                   	pop    %ebx
  804024:	5e                   	pop    %esi
  804025:	5f                   	pop    %edi
  804026:	5d                   	pop    %ebp
  804027:	c3                   	ret    
  804028:	3b 04 24             	cmp    (%esp),%eax
  80402b:	72 06                	jb     804033 <__umoddi3+0x113>
  80402d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804031:	77 0f                	ja     804042 <__umoddi3+0x122>
  804033:	89 f2                	mov    %esi,%edx
  804035:	29 f9                	sub    %edi,%ecx
  804037:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80403b:	89 14 24             	mov    %edx,(%esp)
  80403e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804042:	8b 44 24 04          	mov    0x4(%esp),%eax
  804046:	8b 14 24             	mov    (%esp),%edx
  804049:	83 c4 1c             	add    $0x1c,%esp
  80404c:	5b                   	pop    %ebx
  80404d:	5e                   	pop    %esi
  80404e:	5f                   	pop    %edi
  80404f:	5d                   	pop    %ebp
  804050:	c3                   	ret    
  804051:	8d 76 00             	lea    0x0(%esi),%esi
  804054:	2b 04 24             	sub    (%esp),%eax
  804057:	19 fa                	sbb    %edi,%edx
  804059:	89 d1                	mov    %edx,%ecx
  80405b:	89 c6                	mov    %eax,%esi
  80405d:	e9 71 ff ff ff       	jmp    803fd3 <__umoddi3+0xb3>
  804062:	66 90                	xchg   %ax,%ax
  804064:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804068:	72 ea                	jb     804054 <__umoddi3+0x134>
  80406a:	89 d9                	mov    %ebx,%ecx
  80406c:	e9 62 ff ff ff       	jmp    803fd3 <__umoddi3+0xb3>
