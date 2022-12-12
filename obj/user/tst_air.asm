
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
  800044:	e8 c9 23 00 00       	call   802412 <sys_getenvid>
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
  80007c:	bb 16 43 80 00       	mov    $0x804316,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb 20 43 80 00       	mov    $0x804320,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb 2c 43 80 00       	mov    $0x80432c,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb 3b 43 80 00       	mov    $0x80433b,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb 4a 43 80 00       	mov    $0x80434a,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb 5f 43 80 00       	mov    $0x80435f,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb 74 43 80 00       	mov    $0x804374,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb 85 43 80 00       	mov    $0x804385,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb 96 43 80 00       	mov    $0x804396,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb a7 43 80 00       	mov    $0x8043a7,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb b0 43 80 00       	mov    $0x8043b0,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb ba 43 80 00       	mov    $0x8043ba,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb c5 43 80 00       	mov    $0x8043c5,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb d1 43 80 00       	mov    $0x8043d1,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb db 43 80 00       	mov    $0x8043db,%ebx
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
  8001f7:	bb e5 43 80 00       	mov    $0x8043e5,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb f3 43 80 00       	mov    $0x8043f3,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 02 44 80 00       	mov    $0x804402,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 09 44 80 00       	mov    $0x804409,%ebx
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
  800492:	e8 15 1e 00 00       	call   8022ac <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 01 1e 00 00       	call   8022ac <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 ed 1d 00 00       	call   8022ac <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 d9 1d 00 00       	call   8022ac <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 c5 1d 00 00       	call   8022ac <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 b1 1d 00 00       	call   8022ac <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 9d 1d 00 00       	call   8022ac <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 10 44 80 00       	mov    $0x804410,%ebx
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
  80058f:	e8 18 1d 00 00       	call   8022ac <sys_createSemaphore>
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
  8005cc:	e8 ec 1d 00 00       	call   8023bd <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 f2 1d 00 00       	call   8023db <sys_run_env>
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
  800616:	e8 a2 1d 00 00       	call   8023bd <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 a8 1d 00 00       	call   8023db <sys_run_env>
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
  800660:	e8 58 1d 00 00       	call   8023bd <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 5e 1d 00 00       	call   8023db <sys_run_env>
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
  8006b3:	e8 05 1d 00 00       	call   8023bd <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 40 40 80 00       	push   $0x804040
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 86 40 80 00       	push   $0x804086
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 eb 1c 00 00       	call   8023db <sys_run_env>
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
  800714:	e8 cc 1b 00 00       	call   8022e5 <sys_waitSemaphore>
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
  80072f:	e8 d9 35 00 00       	call   803d0d <env_sleep>
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
  800775:	68 98 40 80 00       	push   $0x804098
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
  8007cd:	68 c8 40 80 00       	push   $0x8040c8
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
  80080c:	68 f8 40 80 00       	push   $0x8040f8
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 86 40 80 00       	push   $0x804086
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
  80084f:	68 f8 40 80 00       	push   $0x8040f8
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 86 40 80 00       	push   $0x804086
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
  8008b0:	68 f8 40 80 00       	push   $0x8040f8
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 86 40 80 00       	push   $0x804086
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
  8008e1:	e8 e2 19 00 00       	call   8022c8 <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 1c 41 80 00       	push   $0x80411c
  8008f3:	68 4a 41 80 00       	push   $0x80414a
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 86 40 80 00       	push   $0x804086
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 af 19 00 00       	call   8022c8 <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 60 41 80 00       	push   $0x804160
  800926:	68 4a 41 80 00       	push   $0x80414a
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 86 40 80 00       	push   $0x804086
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 7c 19 00 00       	call   8022c8 <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 90 41 80 00       	push   $0x804190
  800959:	68 4a 41 80 00       	push   $0x80414a
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 86 40 80 00       	push   $0x804086
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 49 19 00 00       	call   8022c8 <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 c4 41 80 00       	push   $0x8041c4
  80098c:	68 4a 41 80 00       	push   $0x80414a
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 86 40 80 00       	push   $0x804086
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 16 19 00 00       	call   8022c8 <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 f4 41 80 00       	push   $0x8041f4
  8009bf:	68 4a 41 80 00       	push   $0x80414a
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 86 40 80 00       	push   $0x804086
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 e3 18 00 00       	call   8022c8 <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 20 42 80 00       	push   $0x804220
  8009f2:	68 4a 41 80 00       	push   $0x80414a
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 86 40 80 00       	push   $0x804086
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 b0 18 00 00       	call   8022c8 <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 50 42 80 00       	push   $0x804250
  800a24:	68 4a 41 80 00       	push   $0x80414a
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 86 40 80 00       	push   $0x804086
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 10 44 80 00       	mov    $0x804410,%ebx
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
  800ab9:	e8 0a 18 00 00       	call   8022c8 <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 84 42 80 00       	push   $0x804284
  800aca:	68 4a 41 80 00       	push   $0x80414a
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 86 40 80 00       	push   $0x804086
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
  800af0:	68 c4 42 80 00       	push   $0x8042c4
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
  800b51:	e8 d5 18 00 00       	call   80242b <sys_getenvindex>
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
  800bbc:	e8 77 16 00 00       	call   802238 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 48 44 80 00       	push   $0x804448
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
  800bec:	68 70 44 80 00       	push   $0x804470
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
  800c1d:	68 98 44 80 00       	push   $0x804498
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 f0 44 80 00       	push   $0x8044f0
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 48 44 80 00       	push   $0x804448
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 f7 15 00 00       	call   802252 <sys_enable_interrupt>

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
  800c6e:	e8 84 17 00 00       	call   8023f7 <sys_destroy_env>
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
  800c7f:	e8 d9 17 00 00       	call   80245d <sys_exit_env>
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
  800ca8:	68 04 45 80 00       	push   $0x804504
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 09 45 80 00       	push   $0x804509
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
  800ce5:	68 25 45 80 00       	push   $0x804525
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
  800d11:	68 28 45 80 00       	push   $0x804528
  800d16:	6a 26                	push   $0x26
  800d18:	68 74 45 80 00       	push   $0x804574
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
  800de3:	68 80 45 80 00       	push   $0x804580
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 74 45 80 00       	push   $0x804574
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
  800e53:	68 d4 45 80 00       	push   $0x8045d4
  800e58:	6a 44                	push   $0x44
  800e5a:	68 74 45 80 00       	push   $0x804574
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
  800ead:	e8 d8 11 00 00       	call   80208a <sys_cputs>
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
  800f24:	e8 61 11 00 00       	call   80208a <sys_cputs>
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
  800f6e:	e8 c5 12 00 00       	call   802238 <sys_disable_interrupt>
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
  800f8e:	e8 bf 12 00 00       	call   802252 <sys_enable_interrupt>
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
  800fd8:	e8 e7 2d 00 00       	call   803dc4 <__udivdi3>
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
  801028:	e8 a7 2e 00 00       	call   803ed4 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 34 48 80 00       	add    $0x804834,%eax
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
  801183:	8b 04 85 58 48 80 00 	mov    0x804858(,%eax,4),%eax
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
  801264:	8b 34 9d a0 46 80 00 	mov    0x8046a0(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 45 48 80 00       	push   $0x804845
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
  801289:	68 4e 48 80 00       	push   $0x80484e
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
  8012b6:	be 51 48 80 00       	mov    $0x804851,%esi
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
  801cdc:	68 b0 49 80 00       	push   $0x8049b0
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
  801dac:	e8 1d 04 00 00       	call   8021ce <sys_allocate_chunk>
  801db1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801db4:	a1 20 51 80 00       	mov    0x805120,%eax
  801db9:	83 ec 0c             	sub    $0xc,%esp
  801dbc:	50                   	push   %eax
  801dbd:	e8 92 0a 00 00       	call   802854 <initialize_MemBlocksList>
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
  801dea:	68 d5 49 80 00       	push   $0x8049d5
  801def:	6a 33                	push   $0x33
  801df1:	68 f3 49 80 00       	push   $0x8049f3
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
  801e69:	68 00 4a 80 00       	push   $0x804a00
  801e6e:	6a 34                	push   $0x34
  801e70:	68 f3 49 80 00       	push   $0x8049f3
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
  801ede:	68 24 4a 80 00       	push   $0x804a24
  801ee3:	6a 46                	push   $0x46
  801ee5:	68 f3 49 80 00       	push   $0x8049f3
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
  801efa:	68 4c 4a 80 00       	push   $0x804a4c
  801eff:	6a 61                	push   $0x61
  801f01:	68 f3 49 80 00       	push   $0x8049f3
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
  801f20:	75 07                	jne    801f29 <smalloc+0x1e>
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
  801f27:	eb 7c                	jmp    801fa5 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f29:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f36:	01 d0                	add    %edx,%eax
  801f38:	48                   	dec    %eax
  801f39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f44:	f7 75 f0             	divl   -0x10(%ebp)
  801f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4a:	29 d0                	sub    %edx,%eax
  801f4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801f4f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f56:	e8 41 06 00 00       	call   80259c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	74 11                	je     801f70 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	ff 75 e8             	pushl  -0x18(%ebp)
  801f65:	e8 ac 0c 00 00       	call   802c16 <alloc_block_FF>
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801f70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f74:	74 2a                	je     801fa0 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	8b 40 08             	mov    0x8(%eax),%eax
  801f7c:	89 c2                	mov    %eax,%edx
  801f7e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f82:	52                   	push   %edx
  801f83:	50                   	push   %eax
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	ff 75 08             	pushl  0x8(%ebp)
  801f8a:	e8 92 03 00 00       	call   802321 <sys_createSharedObject>
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801f95:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801f99:	74 05                	je     801fa0 <smalloc+0x95>
			return (void*)virtual_address;
  801f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f9e:	eb 05                	jmp    801fa5 <smalloc+0x9a>
	}
	return NULL;
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fad:	e8 13 fd ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801fb2:	83 ec 04             	sub    $0x4,%esp
  801fb5:	68 70 4a 80 00       	push   $0x804a70
  801fba:	68 a2 00 00 00       	push   $0xa2
  801fbf:	68 f3 49 80 00       	push   $0x8049f3
  801fc4:	e8 be ec ff ff       	call   800c87 <_panic>

00801fc9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fcf:	e8 f1 fc ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fd4:	83 ec 04             	sub    $0x4,%esp
  801fd7:	68 94 4a 80 00       	push   $0x804a94
  801fdc:	68 e6 00 00 00       	push   $0xe6
  801fe1:	68 f3 49 80 00       	push   $0x8049f3
  801fe6:	e8 9c ec ff ff       	call   800c87 <_panic>

00801feb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	68 bc 4a 80 00       	push   $0x804abc
  801ff9:	68 fa 00 00 00       	push   $0xfa
  801ffe:	68 f3 49 80 00       	push   $0x8049f3
  802003:	e8 7f ec ff ff       	call   800c87 <_panic>

00802008 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	68 e0 4a 80 00       	push   $0x804ae0
  802016:	68 05 01 00 00       	push   $0x105
  80201b:	68 f3 49 80 00       	push   $0x8049f3
  802020:	e8 62 ec ff ff       	call   800c87 <_panic>

00802025 <shrink>:

}
void shrink(uint32 newSize)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80202b:	83 ec 04             	sub    $0x4,%esp
  80202e:	68 e0 4a 80 00       	push   $0x804ae0
  802033:	68 0a 01 00 00       	push   $0x10a
  802038:	68 f3 49 80 00       	push   $0x8049f3
  80203d:	e8 45 ec ff ff       	call   800c87 <_panic>

00802042 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	68 e0 4a 80 00       	push   $0x804ae0
  802050:	68 0f 01 00 00       	push   $0x10f
  802055:	68 f3 49 80 00       	push   $0x8049f3
  80205a:	e8 28 ec ff ff       	call   800c87 <_panic>

0080205f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	57                   	push   %edi
  802063:	56                   	push   %esi
  802064:	53                   	push   %ebx
  802065:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802071:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802074:	8b 7d 18             	mov    0x18(%ebp),%edi
  802077:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80207a:	cd 30                	int    $0x30
  80207c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80207f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802082:	83 c4 10             	add    $0x10,%esp
  802085:	5b                   	pop    %ebx
  802086:	5e                   	pop    %esi
  802087:	5f                   	pop    %edi
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 04             	sub    $0x4,%esp
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802096:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	52                   	push   %edx
  8020a2:	ff 75 0c             	pushl  0xc(%ebp)
  8020a5:	50                   	push   %eax
  8020a6:	6a 00                	push   $0x0
  8020a8:	e8 b2 ff ff ff       	call   80205f <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	90                   	nop
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 01                	push   $0x1
  8020c2:	e8 98 ff ff ff       	call   80205f <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	52                   	push   %edx
  8020dc:	50                   	push   %eax
  8020dd:	6a 05                	push   $0x5
  8020df:	e8 7b ff ff ff       	call   80205f <syscall>
  8020e4:	83 c4 18             	add    $0x18,%esp
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	56                   	push   %esi
  8020ed:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020ee:	8b 75 18             	mov    0x18(%ebp),%esi
  8020f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	56                   	push   %esi
  8020fe:	53                   	push   %ebx
  8020ff:	51                   	push   %ecx
  802100:	52                   	push   %edx
  802101:	50                   	push   %eax
  802102:	6a 06                	push   $0x6
  802104:	e8 56 ff ff ff       	call   80205f <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210f:	5b                   	pop    %ebx
  802110:	5e                   	pop    %esi
  802111:	5d                   	pop    %ebp
  802112:	c3                   	ret    

00802113 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802116:	8b 55 0c             	mov    0xc(%ebp),%edx
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	52                   	push   %edx
  802123:	50                   	push   %eax
  802124:	6a 07                	push   $0x7
  802126:	e8 34 ff ff ff       	call   80205f <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	ff 75 08             	pushl  0x8(%ebp)
  80213f:	6a 08                	push   $0x8
  802141:	e8 19 ff ff ff       	call   80205f <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 09                	push   $0x9
  80215a:	e8 00 ff ff ff       	call   80205f <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 0a                	push   $0xa
  802173:	e8 e7 fe ff ff       	call   80205f <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 0b                	push   $0xb
  80218c:	e8 ce fe ff ff       	call   80205f <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	ff 75 0c             	pushl  0xc(%ebp)
  8021a2:	ff 75 08             	pushl  0x8(%ebp)
  8021a5:	6a 0f                	push   $0xf
  8021a7:	e8 b3 fe ff ff       	call   80205f <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
	return;
  8021af:	90                   	nop
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	ff 75 0c             	pushl  0xc(%ebp)
  8021be:	ff 75 08             	pushl  0x8(%ebp)
  8021c1:	6a 10                	push   $0x10
  8021c3:	e8 97 fe ff ff       	call   80205f <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cb:	90                   	nop
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	ff 75 10             	pushl  0x10(%ebp)
  8021d8:	ff 75 0c             	pushl  0xc(%ebp)
  8021db:	ff 75 08             	pushl  0x8(%ebp)
  8021de:	6a 11                	push   $0x11
  8021e0:	e8 7a fe ff ff       	call   80205f <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e8:	90                   	nop
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 0c                	push   $0xc
  8021fa:	e8 60 fe ff ff       	call   80205f <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	ff 75 08             	pushl  0x8(%ebp)
  802212:	6a 0d                	push   $0xd
  802214:	e8 46 fe ff ff       	call   80205f <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 0e                	push   $0xe
  80222d:	e8 2d fe ff ff       	call   80205f <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	90                   	nop
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 13                	push   $0x13
  802247:	e8 13 fe ff ff       	call   80205f <syscall>
  80224c:	83 c4 18             	add    $0x18,%esp
}
  80224f:	90                   	nop
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 14                	push   $0x14
  802261:	e8 f9 fd ff ff       	call   80205f <syscall>
  802266:	83 c4 18             	add    $0x18,%esp
}
  802269:	90                   	nop
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <sys_cputc>:


void
sys_cputc(const char c)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802278:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	50                   	push   %eax
  802285:	6a 15                	push   $0x15
  802287:	e8 d3 fd ff ff       	call   80205f <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
}
  80228f:	90                   	nop
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 16                	push   $0x16
  8022a1:	e8 b9 fd ff ff       	call   80205f <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
}
  8022a9:	90                   	nop
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	ff 75 0c             	pushl  0xc(%ebp)
  8022bb:	50                   	push   %eax
  8022bc:	6a 17                	push   $0x17
  8022be:	e8 9c fd ff ff       	call   80205f <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	52                   	push   %edx
  8022d8:	50                   	push   %eax
  8022d9:	6a 1a                	push   $0x1a
  8022db:	e8 7f fd ff ff       	call   80205f <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	52                   	push   %edx
  8022f5:	50                   	push   %eax
  8022f6:	6a 18                	push   $0x18
  8022f8:	e8 62 fd ff ff       	call   80205f <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	90                   	nop
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802306:	8b 55 0c             	mov    0xc(%ebp),%edx
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	52                   	push   %edx
  802313:	50                   	push   %eax
  802314:	6a 19                	push   $0x19
  802316:	e8 44 fd ff ff       	call   80205f <syscall>
  80231b:	83 c4 18             	add    $0x18,%esp
}
  80231e:	90                   	nop
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 04             	sub    $0x4,%esp
  802327:	8b 45 10             	mov    0x10(%ebp),%eax
  80232a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80232d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802330:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	6a 00                	push   $0x0
  802339:	51                   	push   %ecx
  80233a:	52                   	push   %edx
  80233b:	ff 75 0c             	pushl  0xc(%ebp)
  80233e:	50                   	push   %eax
  80233f:	6a 1b                	push   $0x1b
  802341:	e8 19 fd ff ff       	call   80205f <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80234e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	52                   	push   %edx
  80235b:	50                   	push   %eax
  80235c:	6a 1c                	push   $0x1c
  80235e:	e8 fc fc ff ff       	call   80205f <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80236b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80236e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	51                   	push   %ecx
  802379:	52                   	push   %edx
  80237a:	50                   	push   %eax
  80237b:	6a 1d                	push   $0x1d
  80237d:	e8 dd fc ff ff       	call   80205f <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80238a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	52                   	push   %edx
  802397:	50                   	push   %eax
  802398:	6a 1e                	push   $0x1e
  80239a:	e8 c0 fc ff ff       	call   80205f <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 1f                	push   $0x1f
  8023b3:	e8 a7 fc ff ff       	call   80205f <syscall>
  8023b8:	83 c4 18             	add    $0x18,%esp
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	6a 00                	push   $0x0
  8023c5:	ff 75 14             	pushl  0x14(%ebp)
  8023c8:	ff 75 10             	pushl  0x10(%ebp)
  8023cb:	ff 75 0c             	pushl  0xc(%ebp)
  8023ce:	50                   	push   %eax
  8023cf:	6a 20                	push   $0x20
  8023d1:	e8 89 fc ff ff       	call   80205f <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	50                   	push   %eax
  8023ea:	6a 21                	push   $0x21
  8023ec:	e8 6e fc ff ff       	call   80205f <syscall>
  8023f1:	83 c4 18             	add    $0x18,%esp
}
  8023f4:	90                   	nop
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	50                   	push   %eax
  802406:	6a 22                	push   $0x22
  802408:	e8 52 fc ff ff       	call   80205f <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 02                	push   $0x2
  802421:	e8 39 fc ff ff       	call   80205f <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 03                	push   $0x3
  80243a:	e8 20 fc ff ff       	call   80205f <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
}
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 04                	push   $0x4
  802453:	e8 07 fc ff ff       	call   80205f <syscall>
  802458:	83 c4 18             	add    $0x18,%esp
}
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <sys_exit_env>:


void sys_exit_env(void)
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 23                	push   $0x23
  80246c:	e8 ee fb ff ff       	call   80205f <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
}
  802474:	90                   	nop
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80247d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802480:	8d 50 04             	lea    0x4(%eax),%edx
  802483:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	52                   	push   %edx
  80248d:	50                   	push   %eax
  80248e:	6a 24                	push   $0x24
  802490:	e8 ca fb ff ff       	call   80205f <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
	return result;
  802498:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80249b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80249e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024a1:	89 01                	mov    %eax,(%ecx)
  8024a3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	c9                   	leave  
  8024aa:	c2 04 00             	ret    $0x4

008024ad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	ff 75 10             	pushl  0x10(%ebp)
  8024b7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ba:	ff 75 08             	pushl  0x8(%ebp)
  8024bd:	6a 12                	push   $0x12
  8024bf:	e8 9b fb ff ff       	call   80205f <syscall>
  8024c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c7:	90                   	nop
}
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 25                	push   $0x25
  8024d9:	e8 81 fb ff ff       	call   80205f <syscall>
  8024de:	83 c4 18             	add    $0x18,%esp
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	83 ec 04             	sub    $0x4,%esp
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024ef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	50                   	push   %eax
  8024fc:	6a 26                	push   $0x26
  8024fe:	e8 5c fb ff ff       	call   80205f <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
	return ;
  802506:	90                   	nop
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <rsttst>:
void rsttst()
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 28                	push   $0x28
  802518:	e8 42 fb ff ff       	call   80205f <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
	return ;
  802520:	90                   	nop
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	8b 45 14             	mov    0x14(%ebp),%eax
  80252c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80252f:	8b 55 18             	mov    0x18(%ebp),%edx
  802532:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802536:	52                   	push   %edx
  802537:	50                   	push   %eax
  802538:	ff 75 10             	pushl  0x10(%ebp)
  80253b:	ff 75 0c             	pushl  0xc(%ebp)
  80253e:	ff 75 08             	pushl  0x8(%ebp)
  802541:	6a 27                	push   $0x27
  802543:	e8 17 fb ff ff       	call   80205f <syscall>
  802548:	83 c4 18             	add    $0x18,%esp
	return ;
  80254b:	90                   	nop
}
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <chktst>:
void chktst(uint32 n)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	ff 75 08             	pushl  0x8(%ebp)
  80255c:	6a 29                	push   $0x29
  80255e:	e8 fc fa ff ff       	call   80205f <syscall>
  802563:	83 c4 18             	add    $0x18,%esp
	return ;
  802566:	90                   	nop
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <inctst>:

void inctst()
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 2a                	push   $0x2a
  802578:	e8 e2 fa ff ff       	call   80205f <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
	return ;
  802580:	90                   	nop
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <gettst>:
uint32 gettst()
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 2b                	push   $0x2b
  802592:	e8 c8 fa ff ff       	call   80205f <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
}
  80259a:	c9                   	leave  
  80259b:	c3                   	ret    

0080259c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 2c                	push   $0x2c
  8025ae:	e8 ac fa ff ff       	call   80205f <syscall>
  8025b3:	83 c4 18             	add    $0x18,%esp
  8025b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025b9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025bd:	75 07                	jne    8025c6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c4:	eb 05                	jmp    8025cb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
  8025d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 2c                	push   $0x2c
  8025df:	e8 7b fa ff ff       	call   80205f <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
  8025e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025ea:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025ee:	75 07                	jne    8025f7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f5:	eb 05                	jmp    8025fc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 2c                	push   $0x2c
  802610:	e8 4a fa ff ff       	call   80205f <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
  802618:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80261b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80261f:	75 07                	jne    802628 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802621:	b8 01 00 00 00       	mov    $0x1,%eax
  802626:	eb 05                	jmp    80262d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 2c                	push   $0x2c
  802641:	e8 19 fa ff ff       	call   80205f <syscall>
  802646:	83 c4 18             	add    $0x18,%esp
  802649:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80264c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802650:	75 07                	jne    802659 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802652:	b8 01 00 00 00       	mov    $0x1,%eax
  802657:	eb 05                	jmp    80265e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	ff 75 08             	pushl  0x8(%ebp)
  80266e:	6a 2d                	push   $0x2d
  802670:	e8 ea f9 ff ff       	call   80205f <syscall>
  802675:	83 c4 18             	add    $0x18,%esp
	return ;
  802678:	90                   	nop
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80267f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802682:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802685:	8b 55 0c             	mov    0xc(%ebp),%edx
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	6a 00                	push   $0x0
  80268d:	53                   	push   %ebx
  80268e:	51                   	push   %ecx
  80268f:	52                   	push   %edx
  802690:	50                   	push   %eax
  802691:	6a 2e                	push   $0x2e
  802693:	e8 c7 f9 ff ff       	call   80205f <syscall>
  802698:	83 c4 18             	add    $0x18,%esp
}
  80269b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	52                   	push   %edx
  8026b0:	50                   	push   %eax
  8026b1:	6a 2f                	push   $0x2f
  8026b3:	e8 a7 f9 ff ff       	call   80205f <syscall>
  8026b8:	83 c4 18             	add    $0x18,%esp
}
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
  8026c0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026c3:	83 ec 0c             	sub    $0xc,%esp
  8026c6:	68 f0 4a 80 00       	push   $0x804af0
  8026cb:	e8 6b e8 ff ff       	call   800f3b <cprintf>
  8026d0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026da:	83 ec 0c             	sub    $0xc,%esp
  8026dd:	68 1c 4b 80 00       	push   $0x804b1c
  8026e2:	e8 54 e8 ff ff       	call   800f3b <cprintf>
  8026e7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026ea:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026ee:	a1 38 51 80 00       	mov    0x805138,%eax
  8026f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f6:	eb 56                	jmp    80274e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026fc:	74 1c                	je     80271a <print_mem_block_lists+0x5d>
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 50 08             	mov    0x8(%eax),%edx
  802704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802707:	8b 48 08             	mov    0x8(%eax),%ecx
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	8b 40 0c             	mov    0xc(%eax),%eax
  802710:	01 c8                	add    %ecx,%eax
  802712:	39 c2                	cmp    %eax,%edx
  802714:	73 04                	jae    80271a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802716:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 50 08             	mov    0x8(%eax),%edx
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 40 0c             	mov    0xc(%eax),%eax
  802726:	01 c2                	add    %eax,%edx
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 40 08             	mov    0x8(%eax),%eax
  80272e:	83 ec 04             	sub    $0x4,%esp
  802731:	52                   	push   %edx
  802732:	50                   	push   %eax
  802733:	68 31 4b 80 00       	push   $0x804b31
  802738:	e8 fe e7 ff ff       	call   800f3b <cprintf>
  80273d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802746:	a1 40 51 80 00       	mov    0x805140,%eax
  80274b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802752:	74 07                	je     80275b <print_mem_block_lists+0x9e>
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 00                	mov    (%eax),%eax
  802759:	eb 05                	jmp    802760 <print_mem_block_lists+0xa3>
  80275b:	b8 00 00 00 00       	mov    $0x0,%eax
  802760:	a3 40 51 80 00       	mov    %eax,0x805140
  802765:	a1 40 51 80 00       	mov    0x805140,%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	75 8a                	jne    8026f8 <print_mem_block_lists+0x3b>
  80276e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802772:	75 84                	jne    8026f8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802774:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802778:	75 10                	jne    80278a <print_mem_block_lists+0xcd>
  80277a:	83 ec 0c             	sub    $0xc,%esp
  80277d:	68 40 4b 80 00       	push   $0x804b40
  802782:	e8 b4 e7 ff ff       	call   800f3b <cprintf>
  802787:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80278a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802791:	83 ec 0c             	sub    $0xc,%esp
  802794:	68 64 4b 80 00       	push   $0x804b64
  802799:	e8 9d e7 ff ff       	call   800f3b <cprintf>
  80279e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027a1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027a5:	a1 40 50 80 00       	mov    0x805040,%eax
  8027aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ad:	eb 56                	jmp    802805 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027b3:	74 1c                	je     8027d1 <print_mem_block_lists+0x114>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 50 08             	mov    0x8(%eax),%edx
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	8b 48 08             	mov    0x8(%eax),%ecx
  8027c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c7:	01 c8                	add    %ecx,%eax
  8027c9:	39 c2                	cmp    %eax,%edx
  8027cb:	73 04                	jae    8027d1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027cd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 50 08             	mov    0x8(%eax),%edx
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dd:	01 c2                	add    %eax,%edx
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 40 08             	mov    0x8(%eax),%eax
  8027e5:	83 ec 04             	sub    $0x4,%esp
  8027e8:	52                   	push   %edx
  8027e9:	50                   	push   %eax
  8027ea:	68 31 4b 80 00       	push   $0x804b31
  8027ef:	e8 47 e7 ff ff       	call   800f3b <cprintf>
  8027f4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027fd:	a1 48 50 80 00       	mov    0x805048,%eax
  802802:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802805:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802809:	74 07                	je     802812 <print_mem_block_lists+0x155>
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	eb 05                	jmp    802817 <print_mem_block_lists+0x15a>
  802812:	b8 00 00 00 00       	mov    $0x0,%eax
  802817:	a3 48 50 80 00       	mov    %eax,0x805048
  80281c:	a1 48 50 80 00       	mov    0x805048,%eax
  802821:	85 c0                	test   %eax,%eax
  802823:	75 8a                	jne    8027af <print_mem_block_lists+0xf2>
  802825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802829:	75 84                	jne    8027af <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80282b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80282f:	75 10                	jne    802841 <print_mem_block_lists+0x184>
  802831:	83 ec 0c             	sub    $0xc,%esp
  802834:	68 7c 4b 80 00       	push   $0x804b7c
  802839:	e8 fd e6 ff ff       	call   800f3b <cprintf>
  80283e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802841:	83 ec 0c             	sub    $0xc,%esp
  802844:	68 f0 4a 80 00       	push   $0x804af0
  802849:	e8 ed e6 ff ff       	call   800f3b <cprintf>
  80284e:	83 c4 10             	add    $0x10,%esp

}
  802851:	90                   	nop
  802852:	c9                   	leave  
  802853:	c3                   	ret    

00802854 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802854:	55                   	push   %ebp
  802855:	89 e5                	mov    %esp,%ebp
  802857:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80285a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802861:	00 00 00 
  802864:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80286b:	00 00 00 
  80286e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802875:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802878:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80287f:	e9 9e 00 00 00       	jmp    802922 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802884:	a1 50 50 80 00       	mov    0x805050,%eax
  802889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288c:	c1 e2 04             	shl    $0x4,%edx
  80288f:	01 d0                	add    %edx,%eax
  802891:	85 c0                	test   %eax,%eax
  802893:	75 14                	jne    8028a9 <initialize_MemBlocksList+0x55>
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	68 a4 4b 80 00       	push   $0x804ba4
  80289d:	6a 46                	push   $0x46
  80289f:	68 c7 4b 80 00       	push   $0x804bc7
  8028a4:	e8 de e3 ff ff       	call   800c87 <_panic>
  8028a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b1:	c1 e2 04             	shl    $0x4,%edx
  8028b4:	01 d0                	add    %edx,%eax
  8028b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028bc:	89 10                	mov    %edx,(%eax)
  8028be:	8b 00                	mov    (%eax),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	74 18                	je     8028dc <initialize_MemBlocksList+0x88>
  8028c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8028c9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028cf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028d2:	c1 e1 04             	shl    $0x4,%ecx
  8028d5:	01 ca                	add    %ecx,%edx
  8028d7:	89 50 04             	mov    %edx,0x4(%eax)
  8028da:	eb 12                	jmp    8028ee <initialize_MemBlocksList+0x9a>
  8028dc:	a1 50 50 80 00       	mov    0x805050,%eax
  8028e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e4:	c1 e2 04             	shl    $0x4,%edx
  8028e7:	01 d0                	add    %edx,%eax
  8028e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ee:	a1 50 50 80 00       	mov    0x805050,%eax
  8028f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f6:	c1 e2 04             	shl    $0x4,%edx
  8028f9:	01 d0                	add    %edx,%eax
  8028fb:	a3 48 51 80 00       	mov    %eax,0x805148
  802900:	a1 50 50 80 00       	mov    0x805050,%eax
  802905:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802908:	c1 e2 04             	shl    $0x4,%edx
  80290b:	01 d0                	add    %edx,%eax
  80290d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802914:	a1 54 51 80 00       	mov    0x805154,%eax
  802919:	40                   	inc    %eax
  80291a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80291f:	ff 45 f4             	incl   -0xc(%ebp)
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	3b 45 08             	cmp    0x8(%ebp),%eax
  802928:	0f 82 56 ff ff ff    	jb     802884 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80292e:	90                   	nop
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80293f:	eb 19                	jmp    80295a <find_block+0x29>
	{
		if(va==point->sva)
  802941:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802944:	8b 40 08             	mov    0x8(%eax),%eax
  802947:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80294a:	75 05                	jne    802951 <find_block+0x20>
		   return point;
  80294c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80294f:	eb 36                	jmp    802987 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	8b 40 08             	mov    0x8(%eax),%eax
  802957:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80295a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80295e:	74 07                	je     802967 <find_block+0x36>
  802960:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	eb 05                	jmp    80296c <find_block+0x3b>
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
  80296c:	8b 55 08             	mov    0x8(%ebp),%edx
  80296f:	89 42 08             	mov    %eax,0x8(%edx)
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	8b 40 08             	mov    0x8(%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	75 c5                	jne    802941 <find_block+0x10>
  80297c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802980:	75 bf                	jne    802941 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802982:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802987:	c9                   	leave  
  802988:	c3                   	ret    

00802989 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802989:	55                   	push   %ebp
  80298a:	89 e5                	mov    %esp,%ebp
  80298c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80298f:	a1 40 50 80 00       	mov    0x805040,%eax
  802994:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802997:	a1 44 50 80 00       	mov    0x805044,%eax
  80299c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80299f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029a5:	74 24                	je     8029cb <insert_sorted_allocList+0x42>
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	8b 50 08             	mov    0x8(%eax),%edx
  8029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b0:	8b 40 08             	mov    0x8(%eax),%eax
  8029b3:	39 c2                	cmp    %eax,%edx
  8029b5:	76 14                	jbe    8029cb <insert_sorted_allocList+0x42>
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	8b 50 08             	mov    0x8(%eax),%edx
  8029bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c0:	8b 40 08             	mov    0x8(%eax),%eax
  8029c3:	39 c2                	cmp    %eax,%edx
  8029c5:	0f 82 60 01 00 00    	jb     802b2b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8029cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029cf:	75 65                	jne    802a36 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8029d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d5:	75 14                	jne    8029eb <insert_sorted_allocList+0x62>
  8029d7:	83 ec 04             	sub    $0x4,%esp
  8029da:	68 a4 4b 80 00       	push   $0x804ba4
  8029df:	6a 6b                	push   $0x6b
  8029e1:	68 c7 4b 80 00       	push   $0x804bc7
  8029e6:	e8 9c e2 ff ff       	call   800c87 <_panic>
  8029eb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	89 10                	mov    %edx,(%eax)
  8029f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	74 0d                	je     802a0c <insert_sorted_allocList+0x83>
  8029ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802a04:	8b 55 08             	mov    0x8(%ebp),%edx
  802a07:	89 50 04             	mov    %edx,0x4(%eax)
  802a0a:	eb 08                	jmp    802a14 <insert_sorted_allocList+0x8b>
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	a3 44 50 80 00       	mov    %eax,0x805044
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	a3 40 50 80 00       	mov    %eax,0x805040
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a26:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a2b:	40                   	inc    %eax
  802a2c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a31:	e9 dc 01 00 00       	jmp    802c12 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	8b 50 08             	mov    0x8(%eax),%edx
  802a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3f:	8b 40 08             	mov    0x8(%eax),%eax
  802a42:	39 c2                	cmp    %eax,%edx
  802a44:	77 6c                	ja     802ab2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4a:	74 06                	je     802a52 <insert_sorted_allocList+0xc9>
  802a4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a50:	75 14                	jne    802a66 <insert_sorted_allocList+0xdd>
  802a52:	83 ec 04             	sub    $0x4,%esp
  802a55:	68 e0 4b 80 00       	push   $0x804be0
  802a5a:	6a 6f                	push   $0x6f
  802a5c:	68 c7 4b 80 00       	push   $0x804bc7
  802a61:	e8 21 e2 ff ff       	call   800c87 <_panic>
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 50 04             	mov    0x4(%eax),%edx
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	89 50 04             	mov    %edx,0x4(%eax)
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a78:	89 10                	mov    %edx,(%eax)
  802a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7d:	8b 40 04             	mov    0x4(%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 0d                	je     802a91 <insert_sorted_allocList+0x108>
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 40 04             	mov    0x4(%eax),%eax
  802a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8d:	89 10                	mov    %edx,(%eax)
  802a8f:	eb 08                	jmp    802a99 <insert_sorted_allocList+0x110>
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	a3 40 50 80 00       	mov    %eax,0x805040
  802a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9f:	89 50 04             	mov    %edx,0x4(%eax)
  802aa2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aa7:	40                   	inc    %eax
  802aa8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802aad:	e9 60 01 00 00       	jmp    802c12 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	8b 50 08             	mov    0x8(%eax),%edx
  802ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abb:	8b 40 08             	mov    0x8(%eax),%eax
  802abe:	39 c2                	cmp    %eax,%edx
  802ac0:	0f 82 4c 01 00 00    	jb     802c12 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802ac6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aca:	75 14                	jne    802ae0 <insert_sorted_allocList+0x157>
  802acc:	83 ec 04             	sub    $0x4,%esp
  802acf:	68 18 4c 80 00       	push   $0x804c18
  802ad4:	6a 73                	push   $0x73
  802ad6:	68 c7 4b 80 00       	push   $0x804bc7
  802adb:	e8 a7 e1 ff ff       	call   800c87 <_panic>
  802ae0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	89 50 04             	mov    %edx,0x4(%eax)
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	8b 40 04             	mov    0x4(%eax),%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	74 0c                	je     802b02 <insert_sorted_allocList+0x179>
  802af6:	a1 44 50 80 00       	mov    0x805044,%eax
  802afb:	8b 55 08             	mov    0x8(%ebp),%edx
  802afe:	89 10                	mov    %edx,(%eax)
  802b00:	eb 08                	jmp    802b0a <insert_sorted_allocList+0x181>
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	a3 40 50 80 00       	mov    %eax,0x805040
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	a3 44 50 80 00       	mov    %eax,0x805044
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b20:	40                   	inc    %eax
  802b21:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b26:	e9 e7 00 00 00       	jmp    802c12 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b31:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b38:	a1 40 50 80 00       	mov    0x805040,%eax
  802b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b40:	e9 9d 00 00 00       	jmp    802be2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	8b 50 08             	mov    0x8(%eax),%edx
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 40 08             	mov    0x8(%eax),%eax
  802b59:	39 c2                	cmp    %eax,%edx
  802b5b:	76 7d                	jbe    802bda <insert_sorted_allocList+0x251>
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	8b 50 08             	mov    0x8(%eax),%edx
  802b63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b66:	8b 40 08             	mov    0x8(%eax),%eax
  802b69:	39 c2                	cmp    %eax,%edx
  802b6b:	73 6d                	jae    802bda <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b71:	74 06                	je     802b79 <insert_sorted_allocList+0x1f0>
  802b73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b77:	75 14                	jne    802b8d <insert_sorted_allocList+0x204>
  802b79:	83 ec 04             	sub    $0x4,%esp
  802b7c:	68 3c 4c 80 00       	push   $0x804c3c
  802b81:	6a 7f                	push   $0x7f
  802b83:	68 c7 4b 80 00       	push   $0x804bc7
  802b88:	e8 fa e0 ff ff       	call   800c87 <_panic>
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 10                	mov    (%eax),%edx
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	89 10                	mov    %edx,(%eax)
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	74 0b                	je     802bab <insert_sorted_allocList+0x222>
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba8:	89 50 04             	mov    %edx,0x4(%eax)
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb1:	89 10                	mov    %edx,(%eax)
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb9:	89 50 04             	mov    %edx,0x4(%eax)
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	75 08                	jne    802bcd <insert_sorted_allocList+0x244>
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	a3 44 50 80 00       	mov    %eax,0x805044
  802bcd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bd2:	40                   	inc    %eax
  802bd3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802bd8:	eb 39                	jmp    802c13 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802bda:	a1 48 50 80 00       	mov    0x805048,%eax
  802bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be6:	74 07                	je     802bef <insert_sorted_allocList+0x266>
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	eb 05                	jmp    802bf4 <insert_sorted_allocList+0x26b>
  802bef:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf4:	a3 48 50 80 00       	mov    %eax,0x805048
  802bf9:	a1 48 50 80 00       	mov    0x805048,%eax
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	0f 85 3f ff ff ff    	jne    802b45 <insert_sorted_allocList+0x1bc>
  802c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0a:	0f 85 35 ff ff ff    	jne    802b45 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c10:	eb 01                	jmp    802c13 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c12:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c13:	90                   	nop
  802c14:	c9                   	leave  
  802c15:	c3                   	ret    

00802c16 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c16:	55                   	push   %ebp
  802c17:	89 e5                	mov    %esp,%ebp
  802c19:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c1c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c24:	e9 85 01 00 00       	jmp    802dae <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c32:	0f 82 6e 01 00 00    	jb     802da6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c41:	0f 85 8a 00 00 00    	jne    802cd1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4b:	75 17                	jne    802c64 <alloc_block_FF+0x4e>
  802c4d:	83 ec 04             	sub    $0x4,%esp
  802c50:	68 70 4c 80 00       	push   $0x804c70
  802c55:	68 93 00 00 00       	push   $0x93
  802c5a:	68 c7 4b 80 00       	push   $0x804bc7
  802c5f:	e8 23 e0 ff ff       	call   800c87 <_panic>
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 00                	mov    (%eax),%eax
  802c69:	85 c0                	test   %eax,%eax
  802c6b:	74 10                	je     802c7d <alloc_block_FF+0x67>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c75:	8b 52 04             	mov    0x4(%edx),%edx
  802c78:	89 50 04             	mov    %edx,0x4(%eax)
  802c7b:	eb 0b                	jmp    802c88 <alloc_block_FF+0x72>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 40 04             	mov    0x4(%eax),%eax
  802c83:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 04             	mov    0x4(%eax),%eax
  802c8e:	85 c0                	test   %eax,%eax
  802c90:	74 0f                	je     802ca1 <alloc_block_FF+0x8b>
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 04             	mov    0x4(%eax),%eax
  802c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c9b:	8b 12                	mov    (%edx),%edx
  802c9d:	89 10                	mov    %edx,(%eax)
  802c9f:	eb 0a                	jmp    802cab <alloc_block_FF+0x95>
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 00                	mov    (%eax),%eax
  802ca6:	a3 38 51 80 00       	mov    %eax,0x805138
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbe:	a1 44 51 80 00       	mov    0x805144,%eax
  802cc3:	48                   	dec    %eax
  802cc4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	e9 10 01 00 00       	jmp    802de1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cda:	0f 86 c6 00 00 00    	jbe    802da6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ce0:	a1 48 51 80 00       	mov    0x805148,%eax
  802ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 50 08             	mov    0x8(%eax),%edx
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfa:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d01:	75 17                	jne    802d1a <alloc_block_FF+0x104>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 70 4c 80 00       	push   $0x804c70
  802d0b:	68 9b 00 00 00       	push   $0x9b
  802d10:	68 c7 4b 80 00       	push   $0x804bc7
  802d15:	e8 6d df ff ff       	call   800c87 <_panic>
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 10                	je     802d33 <alloc_block_FF+0x11d>
  802d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2b:	8b 52 04             	mov    0x4(%edx),%edx
  802d2e:	89 50 04             	mov    %edx,0x4(%eax)
  802d31:	eb 0b                	jmp    802d3e <alloc_block_FF+0x128>
  802d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 0f                	je     802d57 <alloc_block_FF+0x141>
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d51:	8b 12                	mov    (%edx),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	eb 0a                	jmp    802d61 <alloc_block_FF+0x14b>
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	a3 48 51 80 00       	mov    %eax,0x805148
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d74:	a1 54 51 80 00       	mov    0x805154,%eax
  802d79:	48                   	dec    %eax
  802d7a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 50 08             	mov    0x8(%eax),%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	01 c2                	add    %eax,%edx
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 40 0c             	mov    0xc(%eax),%eax
  802d96:	2b 45 08             	sub    0x8(%ebp),%eax
  802d99:	89 c2                	mov    %eax,%edx
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da4:	eb 3b                	jmp    802de1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802da6:	a1 40 51 80 00       	mov    0x805140,%eax
  802dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db2:	74 07                	je     802dbb <alloc_block_FF+0x1a5>
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	eb 05                	jmp    802dc0 <alloc_block_FF+0x1aa>
  802dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc0:	a3 40 51 80 00       	mov    %eax,0x805140
  802dc5:	a1 40 51 80 00       	mov    0x805140,%eax
  802dca:	85 c0                	test   %eax,%eax
  802dcc:	0f 85 57 fe ff ff    	jne    802c29 <alloc_block_FF+0x13>
  802dd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd6:	0f 85 4d fe ff ff    	jne    802c29 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de1:	c9                   	leave  
  802de2:	c3                   	ret    

00802de3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802de3:	55                   	push   %ebp
  802de4:	89 e5                	mov    %esp,%ebp
  802de6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802de9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802df0:	a1 38 51 80 00       	mov    0x805138,%eax
  802df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df8:	e9 df 00 00 00       	jmp    802edc <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 40 0c             	mov    0xc(%eax),%eax
  802e03:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e06:	0f 82 c8 00 00 00    	jb     802ed4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e12:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e15:	0f 85 8a 00 00 00    	jne    802ea5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1f:	75 17                	jne    802e38 <alloc_block_BF+0x55>
  802e21:	83 ec 04             	sub    $0x4,%esp
  802e24:	68 70 4c 80 00       	push   $0x804c70
  802e29:	68 b7 00 00 00       	push   $0xb7
  802e2e:	68 c7 4b 80 00       	push   $0x804bc7
  802e33:	e8 4f de ff ff       	call   800c87 <_panic>
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	85 c0                	test   %eax,%eax
  802e3f:	74 10                	je     802e51 <alloc_block_BF+0x6e>
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 00                	mov    (%eax),%eax
  802e46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e49:	8b 52 04             	mov    0x4(%edx),%edx
  802e4c:	89 50 04             	mov    %edx,0x4(%eax)
  802e4f:	eb 0b                	jmp    802e5c <alloc_block_BF+0x79>
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 04             	mov    0x4(%eax),%eax
  802e57:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	8b 40 04             	mov    0x4(%eax),%eax
  802e62:	85 c0                	test   %eax,%eax
  802e64:	74 0f                	je     802e75 <alloc_block_BF+0x92>
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 04             	mov    0x4(%eax),%eax
  802e6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6f:	8b 12                	mov    (%edx),%edx
  802e71:	89 10                	mov    %edx,(%eax)
  802e73:	eb 0a                	jmp    802e7f <alloc_block_BF+0x9c>
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 00                	mov    (%eax),%eax
  802e7a:	a3 38 51 80 00       	mov    %eax,0x805138
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e92:	a1 44 51 80 00       	mov    0x805144,%eax
  802e97:	48                   	dec    %eax
  802e98:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	e9 4d 01 00 00       	jmp    802ff2 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eab:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eae:	76 24                	jbe    802ed4 <alloc_block_BF+0xf1>
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802eb9:	73 19                	jae    802ed4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ebb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 40 08             	mov    0x8(%eax),%eax
  802ed1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ed4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee0:	74 07                	je     802ee9 <alloc_block_BF+0x106>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	eb 05                	jmp    802eee <alloc_block_BF+0x10b>
  802ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  802eee:	a3 40 51 80 00       	mov    %eax,0x805140
  802ef3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	0f 85 fd fe ff ff    	jne    802dfd <alloc_block_BF+0x1a>
  802f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f04:	0f 85 f3 fe ff ff    	jne    802dfd <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802f0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f0e:	0f 84 d9 00 00 00    	je     802fed <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f14:	a1 48 51 80 00       	mov    0x805148,%eax
  802f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f22:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f28:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f32:	75 17                	jne    802f4b <alloc_block_BF+0x168>
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	68 70 4c 80 00       	push   $0x804c70
  802f3c:	68 c7 00 00 00       	push   $0xc7
  802f41:	68 c7 4b 80 00       	push   $0x804bc7
  802f46:	e8 3c dd ff ff       	call   800c87 <_panic>
  802f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	74 10                	je     802f64 <alloc_block_BF+0x181>
  802f54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f5c:	8b 52 04             	mov    0x4(%edx),%edx
  802f5f:	89 50 04             	mov    %edx,0x4(%eax)
  802f62:	eb 0b                	jmp    802f6f <alloc_block_BF+0x18c>
  802f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f72:	8b 40 04             	mov    0x4(%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 0f                	je     802f88 <alloc_block_BF+0x1a5>
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f82:	8b 12                	mov    (%edx),%edx
  802f84:	89 10                	mov    %edx,(%eax)
  802f86:	eb 0a                	jmp    802f92 <alloc_block_BF+0x1af>
  802f88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	a3 48 51 80 00       	mov    %eax,0x805148
  802f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa5:	a1 54 51 80 00       	mov    0x805154,%eax
  802faa:	48                   	dec    %eax
  802fab:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802fb0:	83 ec 08             	sub    $0x8,%esp
  802fb3:	ff 75 ec             	pushl  -0x14(%ebp)
  802fb6:	68 38 51 80 00       	push   $0x805138
  802fbb:	e8 71 f9 ff ff       	call   802931 <find_block>
  802fc0:	83 c4 10             	add    $0x10,%esp
  802fc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802fc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc9:	8b 50 08             	mov    0x8(%eax),%edx
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	01 c2                	add    %eax,%edx
  802fd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802fd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fda:	8b 40 0c             	mov    0xc(%eax),%eax
  802fdd:	2b 45 08             	sub    0x8(%ebp),%eax
  802fe0:	89 c2                	mov    %eax,%edx
  802fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802feb:	eb 05                	jmp    802ff2 <alloc_block_BF+0x20f>
	}
	return NULL;
  802fed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff2:	c9                   	leave  
  802ff3:	c3                   	ret    

00802ff4 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ff4:	55                   	push   %ebp
  802ff5:	89 e5                	mov    %esp,%ebp
  802ff7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ffa:	a1 28 50 80 00       	mov    0x805028,%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	0f 85 de 01 00 00    	jne    8031e5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803007:	a1 38 51 80 00       	mov    0x805138,%eax
  80300c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300f:	e9 9e 01 00 00       	jmp    8031b2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	8b 40 0c             	mov    0xc(%eax),%eax
  80301a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301d:	0f 82 87 01 00 00    	jb     8031aa <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 40 0c             	mov    0xc(%eax),%eax
  803029:	3b 45 08             	cmp    0x8(%ebp),%eax
  80302c:	0f 85 95 00 00 00    	jne    8030c7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803036:	75 17                	jne    80304f <alloc_block_NF+0x5b>
  803038:	83 ec 04             	sub    $0x4,%esp
  80303b:	68 70 4c 80 00       	push   $0x804c70
  803040:	68 e0 00 00 00       	push   $0xe0
  803045:	68 c7 4b 80 00       	push   $0x804bc7
  80304a:	e8 38 dc ff ff       	call   800c87 <_panic>
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 10                	je     803068 <alloc_block_NF+0x74>
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803060:	8b 52 04             	mov    0x4(%edx),%edx
  803063:	89 50 04             	mov    %edx,0x4(%eax)
  803066:	eb 0b                	jmp    803073 <alloc_block_NF+0x7f>
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	8b 40 04             	mov    0x4(%eax),%eax
  80306e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 40 04             	mov    0x4(%eax),%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	74 0f                	je     80308c <alloc_block_NF+0x98>
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803086:	8b 12                	mov    (%edx),%edx
  803088:	89 10                	mov    %edx,(%eax)
  80308a:	eb 0a                	jmp    803096 <alloc_block_NF+0xa2>
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	a3 38 51 80 00       	mov    %eax,0x805138
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ae:	48                   	dec    %eax
  8030af:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ba:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	e9 f8 04 00 00       	jmp    8035bf <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d0:	0f 86 d4 00 00 00    	jbe    8031aa <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030d6:	a1 48 51 80 00       	mov    0x805148,%eax
  8030db:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	8b 50 08             	mov    0x8(%eax),%edx
  8030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8030ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f0:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030f7:	75 17                	jne    803110 <alloc_block_NF+0x11c>
  8030f9:	83 ec 04             	sub    $0x4,%esp
  8030fc:	68 70 4c 80 00       	push   $0x804c70
  803101:	68 e9 00 00 00       	push   $0xe9
  803106:	68 c7 4b 80 00       	push   $0x804bc7
  80310b:	e8 77 db ff ff       	call   800c87 <_panic>
  803110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	85 c0                	test   %eax,%eax
  803117:	74 10                	je     803129 <alloc_block_NF+0x135>
  803119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803121:	8b 52 04             	mov    0x4(%edx),%edx
  803124:	89 50 04             	mov    %edx,0x4(%eax)
  803127:	eb 0b                	jmp    803134 <alloc_block_NF+0x140>
  803129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312c:	8b 40 04             	mov    0x4(%eax),%eax
  80312f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 0f                	je     80314d <alloc_block_NF+0x159>
  80313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803141:	8b 40 04             	mov    0x4(%eax),%eax
  803144:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803147:	8b 12                	mov    (%edx),%edx
  803149:	89 10                	mov    %edx,(%eax)
  80314b:	eb 0a                	jmp    803157 <alloc_block_NF+0x163>
  80314d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	a3 48 51 80 00       	mov    %eax,0x805148
  803157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803163:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316a:	a1 54 51 80 00       	mov    0x805154,%eax
  80316f:	48                   	dec    %eax
  803170:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803178:	8b 40 08             	mov    0x8(%eax),%eax
  80317b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 50 08             	mov    0x8(%eax),%edx
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	01 c2                	add    %eax,%edx
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	8b 40 0c             	mov    0xc(%eax),%eax
  803197:	2b 45 08             	sub    0x8(%ebp),%eax
  80319a:	89 c2                	mov    %eax,%edx
  80319c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a5:	e9 15 04 00 00       	jmp    8035bf <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8031aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8031af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b6:	74 07                	je     8031bf <alloc_block_NF+0x1cb>
  8031b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	eb 05                	jmp    8031c4 <alloc_block_NF+0x1d0>
  8031bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c4:	a3 40 51 80 00       	mov    %eax,0x805140
  8031c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	0f 85 3e fe ff ff    	jne    803014 <alloc_block_NF+0x20>
  8031d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031da:	0f 85 34 fe ff ff    	jne    803014 <alloc_block_NF+0x20>
  8031e0:	e9 d5 03 00 00       	jmp    8035ba <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031e5:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ed:	e9 b1 01 00 00       	jmp    8033a3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8031f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f5:	8b 50 08             	mov    0x8(%eax),%edx
  8031f8:	a1 28 50 80 00       	mov    0x805028,%eax
  8031fd:	39 c2                	cmp    %eax,%edx
  8031ff:	0f 82 96 01 00 00    	jb     80339b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	8b 40 0c             	mov    0xc(%eax),%eax
  80320b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80320e:	0f 82 87 01 00 00    	jb     80339b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 40 0c             	mov    0xc(%eax),%eax
  80321a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80321d:	0f 85 95 00 00 00    	jne    8032b8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803227:	75 17                	jne    803240 <alloc_block_NF+0x24c>
  803229:	83 ec 04             	sub    $0x4,%esp
  80322c:	68 70 4c 80 00       	push   $0x804c70
  803231:	68 fc 00 00 00       	push   $0xfc
  803236:	68 c7 4b 80 00       	push   $0x804bc7
  80323b:	e8 47 da ff ff       	call   800c87 <_panic>
  803240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803243:	8b 00                	mov    (%eax),%eax
  803245:	85 c0                	test   %eax,%eax
  803247:	74 10                	je     803259 <alloc_block_NF+0x265>
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803251:	8b 52 04             	mov    0x4(%edx),%edx
  803254:	89 50 04             	mov    %edx,0x4(%eax)
  803257:	eb 0b                	jmp    803264 <alloc_block_NF+0x270>
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 40 04             	mov    0x4(%eax),%eax
  80325f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803267:	8b 40 04             	mov    0x4(%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 0f                	je     80327d <alloc_block_NF+0x289>
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803277:	8b 12                	mov    (%edx),%edx
  803279:	89 10                	mov    %edx,(%eax)
  80327b:	eb 0a                	jmp    803287 <alloc_block_NF+0x293>
  80327d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803280:	8b 00                	mov    (%eax),%eax
  803282:	a3 38 51 80 00       	mov    %eax,0x805138
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803293:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329a:	a1 44 51 80 00       	mov    0x805144,%eax
  80329f:	48                   	dec    %eax
  8032a0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a8:	8b 40 08             	mov    0x8(%eax),%eax
  8032ab:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	e9 07 03 00 00       	jmp    8035bf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c1:	0f 86 d4 00 00 00    	jbe    80339b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8032cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d2:	8b 50 08             	mov    0x8(%eax),%edx
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032de:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e8:	75 17                	jne    803301 <alloc_block_NF+0x30d>
  8032ea:	83 ec 04             	sub    $0x4,%esp
  8032ed:	68 70 4c 80 00       	push   $0x804c70
  8032f2:	68 04 01 00 00       	push   $0x104
  8032f7:	68 c7 4b 80 00       	push   $0x804bc7
  8032fc:	e8 86 d9 ff ff       	call   800c87 <_panic>
  803301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	85 c0                	test   %eax,%eax
  803308:	74 10                	je     80331a <alloc_block_NF+0x326>
  80330a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803312:	8b 52 04             	mov    0x4(%edx),%edx
  803315:	89 50 04             	mov    %edx,0x4(%eax)
  803318:	eb 0b                	jmp    803325 <alloc_block_NF+0x331>
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	8b 40 04             	mov    0x4(%eax),%eax
  803320:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803325:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803328:	8b 40 04             	mov    0x4(%eax),%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	74 0f                	je     80333e <alloc_block_NF+0x34a>
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	8b 40 04             	mov    0x4(%eax),%eax
  803335:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803338:	8b 12                	mov    (%edx),%edx
  80333a:	89 10                	mov    %edx,(%eax)
  80333c:	eb 0a                	jmp    803348 <alloc_block_NF+0x354>
  80333e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803341:	8b 00                	mov    (%eax),%eax
  803343:	a3 48 51 80 00       	mov    %eax,0x805148
  803348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803351:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803354:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335b:	a1 54 51 80 00       	mov    0x805154,%eax
  803360:	48                   	dec    %eax
  803361:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803369:	8b 40 08             	mov    0x8(%eax),%eax
  80336c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	8b 50 08             	mov    0x8(%eax),%edx
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	01 c2                	add    %eax,%edx
  80337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	8b 40 0c             	mov    0xc(%eax),%eax
  803388:	2b 45 08             	sub    0x8(%ebp),%eax
  80338b:	89 c2                	mov    %eax,%edx
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803393:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803396:	e9 24 02 00 00       	jmp    8035bf <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80339b:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a7:	74 07                	je     8033b0 <alloc_block_NF+0x3bc>
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	eb 05                	jmp    8033b5 <alloc_block_NF+0x3c1>
  8033b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8033ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8033bf:	85 c0                	test   %eax,%eax
  8033c1:	0f 85 2b fe ff ff    	jne    8031f2 <alloc_block_NF+0x1fe>
  8033c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033cb:	0f 85 21 fe ff ff    	jne    8031f2 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8033d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d9:	e9 ae 01 00 00       	jmp    80358c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e1:	8b 50 08             	mov    0x8(%eax),%edx
  8033e4:	a1 28 50 80 00       	mov    0x805028,%eax
  8033e9:	39 c2                	cmp    %eax,%edx
  8033eb:	0f 83 93 01 00 00    	jae    803584 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033fa:	0f 82 84 01 00 00    	jb     803584 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	8b 40 0c             	mov    0xc(%eax),%eax
  803406:	3b 45 08             	cmp    0x8(%ebp),%eax
  803409:	0f 85 95 00 00 00    	jne    8034a4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80340f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803413:	75 17                	jne    80342c <alloc_block_NF+0x438>
  803415:	83 ec 04             	sub    $0x4,%esp
  803418:	68 70 4c 80 00       	push   $0x804c70
  80341d:	68 14 01 00 00       	push   $0x114
  803422:	68 c7 4b 80 00       	push   $0x804bc7
  803427:	e8 5b d8 ff ff       	call   800c87 <_panic>
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	74 10                	je     803445 <alloc_block_NF+0x451>
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	8b 00                	mov    (%eax),%eax
  80343a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80343d:	8b 52 04             	mov    0x4(%edx),%edx
  803440:	89 50 04             	mov    %edx,0x4(%eax)
  803443:	eb 0b                	jmp    803450 <alloc_block_NF+0x45c>
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	8b 40 04             	mov    0x4(%eax),%eax
  80344b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	8b 40 04             	mov    0x4(%eax),%eax
  803456:	85 c0                	test   %eax,%eax
  803458:	74 0f                	je     803469 <alloc_block_NF+0x475>
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 40 04             	mov    0x4(%eax),%eax
  803460:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803463:	8b 12                	mov    (%edx),%edx
  803465:	89 10                	mov    %edx,(%eax)
  803467:	eb 0a                	jmp    803473 <alloc_block_NF+0x47f>
  803469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346c:	8b 00                	mov    (%eax),%eax
  80346e:	a3 38 51 80 00       	mov    %eax,0x805138
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803486:	a1 44 51 80 00       	mov    0x805144,%eax
  80348b:	48                   	dec    %eax
  80348c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	8b 40 08             	mov    0x8(%eax),%eax
  803497:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80349c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349f:	e9 1b 01 00 00       	jmp    8035bf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8034aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034ad:	0f 86 d1 00 00 00    	jbe    803584 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8034b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	8b 50 08             	mov    0x8(%eax),%edx
  8034c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8034c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8034d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034d4:	75 17                	jne    8034ed <alloc_block_NF+0x4f9>
  8034d6:	83 ec 04             	sub    $0x4,%esp
  8034d9:	68 70 4c 80 00       	push   $0x804c70
  8034de:	68 1c 01 00 00       	push   $0x11c
  8034e3:	68 c7 4b 80 00       	push   $0x804bc7
  8034e8:	e8 9a d7 ff ff       	call   800c87 <_panic>
  8034ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f0:	8b 00                	mov    (%eax),%eax
  8034f2:	85 c0                	test   %eax,%eax
  8034f4:	74 10                	je     803506 <alloc_block_NF+0x512>
  8034f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034fe:	8b 52 04             	mov    0x4(%edx),%edx
  803501:	89 50 04             	mov    %edx,0x4(%eax)
  803504:	eb 0b                	jmp    803511 <alloc_block_NF+0x51d>
  803506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803509:	8b 40 04             	mov    0x4(%eax),%eax
  80350c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803514:	8b 40 04             	mov    0x4(%eax),%eax
  803517:	85 c0                	test   %eax,%eax
  803519:	74 0f                	je     80352a <alloc_block_NF+0x536>
  80351b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351e:	8b 40 04             	mov    0x4(%eax),%eax
  803521:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803524:	8b 12                	mov    (%edx),%edx
  803526:	89 10                	mov    %edx,(%eax)
  803528:	eb 0a                	jmp    803534 <alloc_block_NF+0x540>
  80352a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	a3 48 51 80 00       	mov    %eax,0x805148
  803534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80353d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803540:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803547:	a1 54 51 80 00       	mov    0x805154,%eax
  80354c:	48                   	dec    %eax
  80354d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803555:	8b 40 08             	mov    0x8(%eax),%eax
  803558:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80355d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803560:	8b 50 08             	mov    0x8(%eax),%edx
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	01 c2                	add    %eax,%edx
  803568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80356e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803571:	8b 40 0c             	mov    0xc(%eax),%eax
  803574:	2b 45 08             	sub    0x8(%ebp),%eax
  803577:	89 c2                	mov    %eax,%edx
  803579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80357f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803582:	eb 3b                	jmp    8035bf <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803584:	a1 40 51 80 00       	mov    0x805140,%eax
  803589:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80358c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803590:	74 07                	je     803599 <alloc_block_NF+0x5a5>
  803592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803595:	8b 00                	mov    (%eax),%eax
  803597:	eb 05                	jmp    80359e <alloc_block_NF+0x5aa>
  803599:	b8 00 00 00 00       	mov    $0x0,%eax
  80359e:	a3 40 51 80 00       	mov    %eax,0x805140
  8035a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	0f 85 2e fe ff ff    	jne    8033de <alloc_block_NF+0x3ea>
  8035b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b4:	0f 85 24 fe ff ff    	jne    8033de <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8035ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035bf:	c9                   	leave  
  8035c0:	c3                   	ret    

008035c1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8035c1:	55                   	push   %ebp
  8035c2:	89 e5                	mov    %esp,%ebp
  8035c4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8035c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8035cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8035cf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035d4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8035d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8035dc:	85 c0                	test   %eax,%eax
  8035de:	74 14                	je     8035f4 <insert_sorted_with_merge_freeList+0x33>
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	8b 50 08             	mov    0x8(%eax),%edx
  8035e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e9:	8b 40 08             	mov    0x8(%eax),%eax
  8035ec:	39 c2                	cmp    %eax,%edx
  8035ee:	0f 87 9b 01 00 00    	ja     80378f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8035f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f8:	75 17                	jne    803611 <insert_sorted_with_merge_freeList+0x50>
  8035fa:	83 ec 04             	sub    $0x4,%esp
  8035fd:	68 a4 4b 80 00       	push   $0x804ba4
  803602:	68 38 01 00 00       	push   $0x138
  803607:	68 c7 4b 80 00       	push   $0x804bc7
  80360c:	e8 76 d6 ff ff       	call   800c87 <_panic>
  803611:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	89 10                	mov    %edx,(%eax)
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	8b 00                	mov    (%eax),%eax
  803621:	85 c0                	test   %eax,%eax
  803623:	74 0d                	je     803632 <insert_sorted_with_merge_freeList+0x71>
  803625:	a1 38 51 80 00       	mov    0x805138,%eax
  80362a:	8b 55 08             	mov    0x8(%ebp),%edx
  80362d:	89 50 04             	mov    %edx,0x4(%eax)
  803630:	eb 08                	jmp    80363a <insert_sorted_with_merge_freeList+0x79>
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	a3 38 51 80 00       	mov    %eax,0x805138
  803642:	8b 45 08             	mov    0x8(%ebp),%eax
  803645:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364c:	a1 44 51 80 00       	mov    0x805144,%eax
  803651:	40                   	inc    %eax
  803652:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803657:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80365b:	0f 84 a8 06 00 00    	je     803d09 <insert_sorted_with_merge_freeList+0x748>
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	8b 50 08             	mov    0x8(%eax),%edx
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	8b 40 0c             	mov    0xc(%eax),%eax
  80366d:	01 c2                	add    %eax,%edx
  80366f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803672:	8b 40 08             	mov    0x8(%eax),%eax
  803675:	39 c2                	cmp    %eax,%edx
  803677:	0f 85 8c 06 00 00    	jne    803d09 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80367d:	8b 45 08             	mov    0x8(%ebp),%eax
  803680:	8b 50 0c             	mov    0xc(%eax),%edx
  803683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803686:	8b 40 0c             	mov    0xc(%eax),%eax
  803689:	01 c2                	add    %eax,%edx
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803691:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803695:	75 17                	jne    8036ae <insert_sorted_with_merge_freeList+0xed>
  803697:	83 ec 04             	sub    $0x4,%esp
  80369a:	68 70 4c 80 00       	push   $0x804c70
  80369f:	68 3c 01 00 00       	push   $0x13c
  8036a4:	68 c7 4b 80 00       	push   $0x804bc7
  8036a9:	e8 d9 d5 ff ff       	call   800c87 <_panic>
  8036ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b1:	8b 00                	mov    (%eax),%eax
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	74 10                	je     8036c7 <insert_sorted_with_merge_freeList+0x106>
  8036b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ba:	8b 00                	mov    (%eax),%eax
  8036bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036bf:	8b 52 04             	mov    0x4(%edx),%edx
  8036c2:	89 50 04             	mov    %edx,0x4(%eax)
  8036c5:	eb 0b                	jmp    8036d2 <insert_sorted_with_merge_freeList+0x111>
  8036c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ca:	8b 40 04             	mov    0x4(%eax),%eax
  8036cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d5:	8b 40 04             	mov    0x4(%eax),%eax
  8036d8:	85 c0                	test   %eax,%eax
  8036da:	74 0f                	je     8036eb <insert_sorted_with_merge_freeList+0x12a>
  8036dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036df:	8b 40 04             	mov    0x4(%eax),%eax
  8036e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e5:	8b 12                	mov    (%edx),%edx
  8036e7:	89 10                	mov    %edx,(%eax)
  8036e9:	eb 0a                	jmp    8036f5 <insert_sorted_with_merge_freeList+0x134>
  8036eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ee:	8b 00                	mov    (%eax),%eax
  8036f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8036f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803701:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803708:	a1 44 51 80 00       	mov    0x805144,%eax
  80370d:	48                   	dec    %eax
  80370e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803716:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80371d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803720:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803727:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80372b:	75 17                	jne    803744 <insert_sorted_with_merge_freeList+0x183>
  80372d:	83 ec 04             	sub    $0x4,%esp
  803730:	68 a4 4b 80 00       	push   $0x804ba4
  803735:	68 3f 01 00 00       	push   $0x13f
  80373a:	68 c7 4b 80 00       	push   $0x804bc7
  80373f:	e8 43 d5 ff ff       	call   800c87 <_panic>
  803744:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80374a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374d:	89 10                	mov    %edx,(%eax)
  80374f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803752:	8b 00                	mov    (%eax),%eax
  803754:	85 c0                	test   %eax,%eax
  803756:	74 0d                	je     803765 <insert_sorted_with_merge_freeList+0x1a4>
  803758:	a1 48 51 80 00       	mov    0x805148,%eax
  80375d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803760:	89 50 04             	mov    %edx,0x4(%eax)
  803763:	eb 08                	jmp    80376d <insert_sorted_with_merge_freeList+0x1ac>
  803765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803768:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80376d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803770:	a3 48 51 80 00       	mov    %eax,0x805148
  803775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803778:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80377f:	a1 54 51 80 00       	mov    0x805154,%eax
  803784:	40                   	inc    %eax
  803785:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80378a:	e9 7a 05 00 00       	jmp    803d09 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	8b 50 08             	mov    0x8(%eax),%edx
  803795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803798:	8b 40 08             	mov    0x8(%eax),%eax
  80379b:	39 c2                	cmp    %eax,%edx
  80379d:	0f 82 14 01 00 00    	jb     8038b7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8037a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a6:	8b 50 08             	mov    0x8(%eax),%edx
  8037a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8037af:	01 c2                	add    %eax,%edx
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b4:	8b 40 08             	mov    0x8(%eax),%eax
  8037b7:	39 c2                	cmp    %eax,%edx
  8037b9:	0f 85 90 00 00 00    	jne    80384f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8037bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c2:	8b 50 0c             	mov    0xc(%eax),%edx
  8037c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8037cb:	01 c2                	add    %eax,%edx
  8037cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8037d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8037dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037eb:	75 17                	jne    803804 <insert_sorted_with_merge_freeList+0x243>
  8037ed:	83 ec 04             	sub    $0x4,%esp
  8037f0:	68 a4 4b 80 00       	push   $0x804ba4
  8037f5:	68 49 01 00 00       	push   $0x149
  8037fa:	68 c7 4b 80 00       	push   $0x804bc7
  8037ff:	e8 83 d4 ff ff       	call   800c87 <_panic>
  803804:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80380a:	8b 45 08             	mov    0x8(%ebp),%eax
  80380d:	89 10                	mov    %edx,(%eax)
  80380f:	8b 45 08             	mov    0x8(%ebp),%eax
  803812:	8b 00                	mov    (%eax),%eax
  803814:	85 c0                	test   %eax,%eax
  803816:	74 0d                	je     803825 <insert_sorted_with_merge_freeList+0x264>
  803818:	a1 48 51 80 00       	mov    0x805148,%eax
  80381d:	8b 55 08             	mov    0x8(%ebp),%edx
  803820:	89 50 04             	mov    %edx,0x4(%eax)
  803823:	eb 08                	jmp    80382d <insert_sorted_with_merge_freeList+0x26c>
  803825:	8b 45 08             	mov    0x8(%ebp),%eax
  803828:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	a3 48 51 80 00       	mov    %eax,0x805148
  803835:	8b 45 08             	mov    0x8(%ebp),%eax
  803838:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383f:	a1 54 51 80 00       	mov    0x805154,%eax
  803844:	40                   	inc    %eax
  803845:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80384a:	e9 bb 04 00 00       	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80384f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803853:	75 17                	jne    80386c <insert_sorted_with_merge_freeList+0x2ab>
  803855:	83 ec 04             	sub    $0x4,%esp
  803858:	68 18 4c 80 00       	push   $0x804c18
  80385d:	68 4c 01 00 00       	push   $0x14c
  803862:	68 c7 4b 80 00       	push   $0x804bc7
  803867:	e8 1b d4 ff ff       	call   800c87 <_panic>
  80386c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	89 50 04             	mov    %edx,0x4(%eax)
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	8b 40 04             	mov    0x4(%eax),%eax
  80387e:	85 c0                	test   %eax,%eax
  803880:	74 0c                	je     80388e <insert_sorted_with_merge_freeList+0x2cd>
  803882:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803887:	8b 55 08             	mov    0x8(%ebp),%edx
  80388a:	89 10                	mov    %edx,(%eax)
  80388c:	eb 08                	jmp    803896 <insert_sorted_with_merge_freeList+0x2d5>
  80388e:	8b 45 08             	mov    0x8(%ebp),%eax
  803891:	a3 38 51 80 00       	mov    %eax,0x805138
  803896:	8b 45 08             	mov    0x8(%ebp),%eax
  803899:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8038ac:	40                   	inc    %eax
  8038ad:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038b2:	e9 53 04 00 00       	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8038bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038bf:	e9 15 04 00 00       	jmp    803cd9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8038c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c7:	8b 00                	mov    (%eax),%eax
  8038c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	8b 50 08             	mov    0x8(%eax),%edx
  8038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d5:	8b 40 08             	mov    0x8(%eax),%eax
  8038d8:	39 c2                	cmp    %eax,%edx
  8038da:	0f 86 f1 03 00 00    	jbe    803cd1 <insert_sorted_with_merge_freeList+0x710>
  8038e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e3:	8b 50 08             	mov    0x8(%eax),%edx
  8038e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e9:	8b 40 08             	mov    0x8(%eax),%eax
  8038ec:	39 c2                	cmp    %eax,%edx
  8038ee:	0f 83 dd 03 00 00    	jae    803cd1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f7:	8b 50 08             	mov    0x8(%eax),%edx
  8038fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803900:	01 c2                	add    %eax,%edx
  803902:	8b 45 08             	mov    0x8(%ebp),%eax
  803905:	8b 40 08             	mov    0x8(%eax),%eax
  803908:	39 c2                	cmp    %eax,%edx
  80390a:	0f 85 b9 01 00 00    	jne    803ac9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	8b 50 08             	mov    0x8(%eax),%edx
  803916:	8b 45 08             	mov    0x8(%ebp),%eax
  803919:	8b 40 0c             	mov    0xc(%eax),%eax
  80391c:	01 c2                	add    %eax,%edx
  80391e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803921:	8b 40 08             	mov    0x8(%eax),%eax
  803924:	39 c2                	cmp    %eax,%edx
  803926:	0f 85 0d 01 00 00    	jne    803a39 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	8b 50 0c             	mov    0xc(%eax),%edx
  803932:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803935:	8b 40 0c             	mov    0xc(%eax),%eax
  803938:	01 c2                	add    %eax,%edx
  80393a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803940:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803944:	75 17                	jne    80395d <insert_sorted_with_merge_freeList+0x39c>
  803946:	83 ec 04             	sub    $0x4,%esp
  803949:	68 70 4c 80 00       	push   $0x804c70
  80394e:	68 5c 01 00 00       	push   $0x15c
  803953:	68 c7 4b 80 00       	push   $0x804bc7
  803958:	e8 2a d3 ff ff       	call   800c87 <_panic>
  80395d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803960:	8b 00                	mov    (%eax),%eax
  803962:	85 c0                	test   %eax,%eax
  803964:	74 10                	je     803976 <insert_sorted_with_merge_freeList+0x3b5>
  803966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803969:	8b 00                	mov    (%eax),%eax
  80396b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80396e:	8b 52 04             	mov    0x4(%edx),%edx
  803971:	89 50 04             	mov    %edx,0x4(%eax)
  803974:	eb 0b                	jmp    803981 <insert_sorted_with_merge_freeList+0x3c0>
  803976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803979:	8b 40 04             	mov    0x4(%eax),%eax
  80397c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803981:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803984:	8b 40 04             	mov    0x4(%eax),%eax
  803987:	85 c0                	test   %eax,%eax
  803989:	74 0f                	je     80399a <insert_sorted_with_merge_freeList+0x3d9>
  80398b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398e:	8b 40 04             	mov    0x4(%eax),%eax
  803991:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803994:	8b 12                	mov    (%edx),%edx
  803996:	89 10                	mov    %edx,(%eax)
  803998:	eb 0a                	jmp    8039a4 <insert_sorted_with_merge_freeList+0x3e3>
  80399a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399d:	8b 00                	mov    (%eax),%eax
  80399f:	a3 38 51 80 00       	mov    %eax,0x805138
  8039a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8039bc:	48                   	dec    %eax
  8039bd:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8039c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8039cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039da:	75 17                	jne    8039f3 <insert_sorted_with_merge_freeList+0x432>
  8039dc:	83 ec 04             	sub    $0x4,%esp
  8039df:	68 a4 4b 80 00       	push   $0x804ba4
  8039e4:	68 5f 01 00 00       	push   $0x15f
  8039e9:	68 c7 4b 80 00       	push   $0x804bc7
  8039ee:	e8 94 d2 ff ff       	call   800c87 <_panic>
  8039f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fc:	89 10                	mov    %edx,(%eax)
  8039fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a01:	8b 00                	mov    (%eax),%eax
  803a03:	85 c0                	test   %eax,%eax
  803a05:	74 0d                	je     803a14 <insert_sorted_with_merge_freeList+0x453>
  803a07:	a1 48 51 80 00       	mov    0x805148,%eax
  803a0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a0f:	89 50 04             	mov    %edx,0x4(%eax)
  803a12:	eb 08                	jmp    803a1c <insert_sorted_with_merge_freeList+0x45b>
  803a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a17:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1f:	a3 48 51 80 00       	mov    %eax,0x805148
  803a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a2e:	a1 54 51 80 00       	mov    0x805154,%eax
  803a33:	40                   	inc    %eax
  803a34:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3c:	8b 50 0c             	mov    0xc(%eax),%edx
  803a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a42:	8b 40 0c             	mov    0xc(%eax),%eax
  803a45:	01 c2                	add    %eax,%edx
  803a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a57:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a65:	75 17                	jne    803a7e <insert_sorted_with_merge_freeList+0x4bd>
  803a67:	83 ec 04             	sub    $0x4,%esp
  803a6a:	68 a4 4b 80 00       	push   $0x804ba4
  803a6f:	68 64 01 00 00       	push   $0x164
  803a74:	68 c7 4b 80 00       	push   $0x804bc7
  803a79:	e8 09 d2 ff ff       	call   800c87 <_panic>
  803a7e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a84:	8b 45 08             	mov    0x8(%ebp),%eax
  803a87:	89 10                	mov    %edx,(%eax)
  803a89:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8c:	8b 00                	mov    (%eax),%eax
  803a8e:	85 c0                	test   %eax,%eax
  803a90:	74 0d                	je     803a9f <insert_sorted_with_merge_freeList+0x4de>
  803a92:	a1 48 51 80 00       	mov    0x805148,%eax
  803a97:	8b 55 08             	mov    0x8(%ebp),%edx
  803a9a:	89 50 04             	mov    %edx,0x4(%eax)
  803a9d:	eb 08                	jmp    803aa7 <insert_sorted_with_merge_freeList+0x4e6>
  803a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aaa:	a3 48 51 80 00       	mov    %eax,0x805148
  803aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab9:	a1 54 51 80 00       	mov    0x805154,%eax
  803abe:	40                   	inc    %eax
  803abf:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ac4:	e9 41 02 00 00       	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  803acc:	8b 50 08             	mov    0x8(%eax),%edx
  803acf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ad5:	01 c2                	add    %eax,%edx
  803ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ada:	8b 40 08             	mov    0x8(%eax),%eax
  803add:	39 c2                	cmp    %eax,%edx
  803adf:	0f 85 7c 01 00 00    	jne    803c61 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803ae5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ae9:	74 06                	je     803af1 <insert_sorted_with_merge_freeList+0x530>
  803aeb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aef:	75 17                	jne    803b08 <insert_sorted_with_merge_freeList+0x547>
  803af1:	83 ec 04             	sub    $0x4,%esp
  803af4:	68 e0 4b 80 00       	push   $0x804be0
  803af9:	68 69 01 00 00       	push   $0x169
  803afe:	68 c7 4b 80 00       	push   $0x804bc7
  803b03:	e8 7f d1 ff ff       	call   800c87 <_panic>
  803b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0b:	8b 50 04             	mov    0x4(%eax),%edx
  803b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b11:	89 50 04             	mov    %edx,0x4(%eax)
  803b14:	8b 45 08             	mov    0x8(%ebp),%eax
  803b17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b1a:	89 10                	mov    %edx,(%eax)
  803b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1f:	8b 40 04             	mov    0x4(%eax),%eax
  803b22:	85 c0                	test   %eax,%eax
  803b24:	74 0d                	je     803b33 <insert_sorted_with_merge_freeList+0x572>
  803b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b29:	8b 40 04             	mov    0x4(%eax),%eax
  803b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  803b2f:	89 10                	mov    %edx,(%eax)
  803b31:	eb 08                	jmp    803b3b <insert_sorted_with_merge_freeList+0x57a>
  803b33:	8b 45 08             	mov    0x8(%ebp),%eax
  803b36:	a3 38 51 80 00       	mov    %eax,0x805138
  803b3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3e:	8b 55 08             	mov    0x8(%ebp),%edx
  803b41:	89 50 04             	mov    %edx,0x4(%eax)
  803b44:	a1 44 51 80 00       	mov    0x805144,%eax
  803b49:	40                   	inc    %eax
  803b4a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b52:	8b 50 0c             	mov    0xc(%eax),%edx
  803b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b58:	8b 40 0c             	mov    0xc(%eax),%eax
  803b5b:	01 c2                	add    %eax,%edx
  803b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b60:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b63:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b67:	75 17                	jne    803b80 <insert_sorted_with_merge_freeList+0x5bf>
  803b69:	83 ec 04             	sub    $0x4,%esp
  803b6c:	68 70 4c 80 00       	push   $0x804c70
  803b71:	68 6b 01 00 00       	push   $0x16b
  803b76:	68 c7 4b 80 00       	push   $0x804bc7
  803b7b:	e8 07 d1 ff ff       	call   800c87 <_panic>
  803b80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b83:	8b 00                	mov    (%eax),%eax
  803b85:	85 c0                	test   %eax,%eax
  803b87:	74 10                	je     803b99 <insert_sorted_with_merge_freeList+0x5d8>
  803b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8c:	8b 00                	mov    (%eax),%eax
  803b8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b91:	8b 52 04             	mov    0x4(%edx),%edx
  803b94:	89 50 04             	mov    %edx,0x4(%eax)
  803b97:	eb 0b                	jmp    803ba4 <insert_sorted_with_merge_freeList+0x5e3>
  803b99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9c:	8b 40 04             	mov    0x4(%eax),%eax
  803b9f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ba4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba7:	8b 40 04             	mov    0x4(%eax),%eax
  803baa:	85 c0                	test   %eax,%eax
  803bac:	74 0f                	je     803bbd <insert_sorted_with_merge_freeList+0x5fc>
  803bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb1:	8b 40 04             	mov    0x4(%eax),%eax
  803bb4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bb7:	8b 12                	mov    (%edx),%edx
  803bb9:	89 10                	mov    %edx,(%eax)
  803bbb:	eb 0a                	jmp    803bc7 <insert_sorted_with_merge_freeList+0x606>
  803bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc0:	8b 00                	mov    (%eax),%eax
  803bc2:	a3 38 51 80 00       	mov    %eax,0x805138
  803bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bda:	a1 44 51 80 00       	mov    0x805144,%eax
  803bdf:	48                   	dec    %eax
  803be0:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803bef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803bf9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bfd:	75 17                	jne    803c16 <insert_sorted_with_merge_freeList+0x655>
  803bff:	83 ec 04             	sub    $0x4,%esp
  803c02:	68 a4 4b 80 00       	push   $0x804ba4
  803c07:	68 6e 01 00 00       	push   $0x16e
  803c0c:	68 c7 4b 80 00       	push   $0x804bc7
  803c11:	e8 71 d0 ff ff       	call   800c87 <_panic>
  803c16:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c1f:	89 10                	mov    %edx,(%eax)
  803c21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c24:	8b 00                	mov    (%eax),%eax
  803c26:	85 c0                	test   %eax,%eax
  803c28:	74 0d                	je     803c37 <insert_sorted_with_merge_freeList+0x676>
  803c2a:	a1 48 51 80 00       	mov    0x805148,%eax
  803c2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c32:	89 50 04             	mov    %edx,0x4(%eax)
  803c35:	eb 08                	jmp    803c3f <insert_sorted_with_merge_freeList+0x67e>
  803c37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c42:	a3 48 51 80 00       	mov    %eax,0x805148
  803c47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c51:	a1 54 51 80 00       	mov    0x805154,%eax
  803c56:	40                   	inc    %eax
  803c57:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c5c:	e9 a9 00 00 00       	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c65:	74 06                	je     803c6d <insert_sorted_with_merge_freeList+0x6ac>
  803c67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c6b:	75 17                	jne    803c84 <insert_sorted_with_merge_freeList+0x6c3>
  803c6d:	83 ec 04             	sub    $0x4,%esp
  803c70:	68 3c 4c 80 00       	push   $0x804c3c
  803c75:	68 73 01 00 00       	push   $0x173
  803c7a:	68 c7 4b 80 00       	push   $0x804bc7
  803c7f:	e8 03 d0 ff ff       	call   800c87 <_panic>
  803c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c87:	8b 10                	mov    (%eax),%edx
  803c89:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8c:	89 10                	mov    %edx,(%eax)
  803c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c91:	8b 00                	mov    (%eax),%eax
  803c93:	85 c0                	test   %eax,%eax
  803c95:	74 0b                	je     803ca2 <insert_sorted_with_merge_freeList+0x6e1>
  803c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9a:	8b 00                	mov    (%eax),%eax
  803c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  803c9f:	89 50 04             	mov    %edx,0x4(%eax)
  803ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  803ca8:	89 10                	mov    %edx,(%eax)
  803caa:	8b 45 08             	mov    0x8(%ebp),%eax
  803cad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cb0:	89 50 04             	mov    %edx,0x4(%eax)
  803cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb6:	8b 00                	mov    (%eax),%eax
  803cb8:	85 c0                	test   %eax,%eax
  803cba:	75 08                	jne    803cc4 <insert_sorted_with_merge_freeList+0x703>
  803cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  803cbf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803cc4:	a1 44 51 80 00       	mov    0x805144,%eax
  803cc9:	40                   	inc    %eax
  803cca:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803ccf:	eb 39                	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803cd1:	a1 40 51 80 00       	mov    0x805140,%eax
  803cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cdd:	74 07                	je     803ce6 <insert_sorted_with_merge_freeList+0x725>
  803cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce2:	8b 00                	mov    (%eax),%eax
  803ce4:	eb 05                	jmp    803ceb <insert_sorted_with_merge_freeList+0x72a>
  803ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  803ceb:	a3 40 51 80 00       	mov    %eax,0x805140
  803cf0:	a1 40 51 80 00       	mov    0x805140,%eax
  803cf5:	85 c0                	test   %eax,%eax
  803cf7:	0f 85 c7 fb ff ff    	jne    8038c4 <insert_sorted_with_merge_freeList+0x303>
  803cfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d01:	0f 85 bd fb ff ff    	jne    8038c4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d07:	eb 01                	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803d09:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d0a:	90                   	nop
  803d0b:	c9                   	leave  
  803d0c:	c3                   	ret    

00803d0d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803d0d:	55                   	push   %ebp
  803d0e:	89 e5                	mov    %esp,%ebp
  803d10:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803d13:	8b 55 08             	mov    0x8(%ebp),%edx
  803d16:	89 d0                	mov    %edx,%eax
  803d18:	c1 e0 02             	shl    $0x2,%eax
  803d1b:	01 d0                	add    %edx,%eax
  803d1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d24:	01 d0                	add    %edx,%eax
  803d26:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d2d:	01 d0                	add    %edx,%eax
  803d2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d36:	01 d0                	add    %edx,%eax
  803d38:	c1 e0 04             	shl    $0x4,%eax
  803d3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803d3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803d45:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803d48:	83 ec 0c             	sub    $0xc,%esp
  803d4b:	50                   	push   %eax
  803d4c:	e8 26 e7 ff ff       	call   802477 <sys_get_virtual_time>
  803d51:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803d54:	eb 41                	jmp    803d97 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803d56:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803d59:	83 ec 0c             	sub    $0xc,%esp
  803d5c:	50                   	push   %eax
  803d5d:	e8 15 e7 ff ff       	call   802477 <sys_get_virtual_time>
  803d62:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803d65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d6b:	29 c2                	sub    %eax,%edx
  803d6d:	89 d0                	mov    %edx,%eax
  803d6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803d72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d78:	89 d1                	mov    %edx,%ecx
  803d7a:	29 c1                	sub    %eax,%ecx
  803d7c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d82:	39 c2                	cmp    %eax,%edx
  803d84:	0f 97 c0             	seta   %al
  803d87:	0f b6 c0             	movzbl %al,%eax
  803d8a:	29 c1                	sub    %eax,%ecx
  803d8c:	89 c8                	mov    %ecx,%eax
  803d8e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803d91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803d9d:	72 b7                	jb     803d56 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803d9f:	90                   	nop
  803da0:	c9                   	leave  
  803da1:	c3                   	ret    

00803da2 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803da2:	55                   	push   %ebp
  803da3:	89 e5                	mov    %esp,%ebp
  803da5:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803da8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803daf:	eb 03                	jmp    803db4 <busy_wait+0x12>
  803db1:	ff 45 fc             	incl   -0x4(%ebp)
  803db4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803db7:	3b 45 08             	cmp    0x8(%ebp),%eax
  803dba:	72 f5                	jb     803db1 <busy_wait+0xf>
	return i;
  803dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803dbf:	c9                   	leave  
  803dc0:	c3                   	ret    
  803dc1:	66 90                	xchg   %ax,%ax
  803dc3:	90                   	nop

00803dc4 <__udivdi3>:
  803dc4:	55                   	push   %ebp
  803dc5:	57                   	push   %edi
  803dc6:	56                   	push   %esi
  803dc7:	53                   	push   %ebx
  803dc8:	83 ec 1c             	sub    $0x1c,%esp
  803dcb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803dcf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803dd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dd7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ddb:	89 ca                	mov    %ecx,%edx
  803ddd:	89 f8                	mov    %edi,%eax
  803ddf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803de3:	85 f6                	test   %esi,%esi
  803de5:	75 2d                	jne    803e14 <__udivdi3+0x50>
  803de7:	39 cf                	cmp    %ecx,%edi
  803de9:	77 65                	ja     803e50 <__udivdi3+0x8c>
  803deb:	89 fd                	mov    %edi,%ebp
  803ded:	85 ff                	test   %edi,%edi
  803def:	75 0b                	jne    803dfc <__udivdi3+0x38>
  803df1:	b8 01 00 00 00       	mov    $0x1,%eax
  803df6:	31 d2                	xor    %edx,%edx
  803df8:	f7 f7                	div    %edi
  803dfa:	89 c5                	mov    %eax,%ebp
  803dfc:	31 d2                	xor    %edx,%edx
  803dfe:	89 c8                	mov    %ecx,%eax
  803e00:	f7 f5                	div    %ebp
  803e02:	89 c1                	mov    %eax,%ecx
  803e04:	89 d8                	mov    %ebx,%eax
  803e06:	f7 f5                	div    %ebp
  803e08:	89 cf                	mov    %ecx,%edi
  803e0a:	89 fa                	mov    %edi,%edx
  803e0c:	83 c4 1c             	add    $0x1c,%esp
  803e0f:	5b                   	pop    %ebx
  803e10:	5e                   	pop    %esi
  803e11:	5f                   	pop    %edi
  803e12:	5d                   	pop    %ebp
  803e13:	c3                   	ret    
  803e14:	39 ce                	cmp    %ecx,%esi
  803e16:	77 28                	ja     803e40 <__udivdi3+0x7c>
  803e18:	0f bd fe             	bsr    %esi,%edi
  803e1b:	83 f7 1f             	xor    $0x1f,%edi
  803e1e:	75 40                	jne    803e60 <__udivdi3+0x9c>
  803e20:	39 ce                	cmp    %ecx,%esi
  803e22:	72 0a                	jb     803e2e <__udivdi3+0x6a>
  803e24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e28:	0f 87 9e 00 00 00    	ja     803ecc <__udivdi3+0x108>
  803e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803e33:	89 fa                	mov    %edi,%edx
  803e35:	83 c4 1c             	add    $0x1c,%esp
  803e38:	5b                   	pop    %ebx
  803e39:	5e                   	pop    %esi
  803e3a:	5f                   	pop    %edi
  803e3b:	5d                   	pop    %ebp
  803e3c:	c3                   	ret    
  803e3d:	8d 76 00             	lea    0x0(%esi),%esi
  803e40:	31 ff                	xor    %edi,%edi
  803e42:	31 c0                	xor    %eax,%eax
  803e44:	89 fa                	mov    %edi,%edx
  803e46:	83 c4 1c             	add    $0x1c,%esp
  803e49:	5b                   	pop    %ebx
  803e4a:	5e                   	pop    %esi
  803e4b:	5f                   	pop    %edi
  803e4c:	5d                   	pop    %ebp
  803e4d:	c3                   	ret    
  803e4e:	66 90                	xchg   %ax,%ax
  803e50:	89 d8                	mov    %ebx,%eax
  803e52:	f7 f7                	div    %edi
  803e54:	31 ff                	xor    %edi,%edi
  803e56:	89 fa                	mov    %edi,%edx
  803e58:	83 c4 1c             	add    $0x1c,%esp
  803e5b:	5b                   	pop    %ebx
  803e5c:	5e                   	pop    %esi
  803e5d:	5f                   	pop    %edi
  803e5e:	5d                   	pop    %ebp
  803e5f:	c3                   	ret    
  803e60:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e65:	89 eb                	mov    %ebp,%ebx
  803e67:	29 fb                	sub    %edi,%ebx
  803e69:	89 f9                	mov    %edi,%ecx
  803e6b:	d3 e6                	shl    %cl,%esi
  803e6d:	89 c5                	mov    %eax,%ebp
  803e6f:	88 d9                	mov    %bl,%cl
  803e71:	d3 ed                	shr    %cl,%ebp
  803e73:	89 e9                	mov    %ebp,%ecx
  803e75:	09 f1                	or     %esi,%ecx
  803e77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e7b:	89 f9                	mov    %edi,%ecx
  803e7d:	d3 e0                	shl    %cl,%eax
  803e7f:	89 c5                	mov    %eax,%ebp
  803e81:	89 d6                	mov    %edx,%esi
  803e83:	88 d9                	mov    %bl,%cl
  803e85:	d3 ee                	shr    %cl,%esi
  803e87:	89 f9                	mov    %edi,%ecx
  803e89:	d3 e2                	shl    %cl,%edx
  803e8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e8f:	88 d9                	mov    %bl,%cl
  803e91:	d3 e8                	shr    %cl,%eax
  803e93:	09 c2                	or     %eax,%edx
  803e95:	89 d0                	mov    %edx,%eax
  803e97:	89 f2                	mov    %esi,%edx
  803e99:	f7 74 24 0c          	divl   0xc(%esp)
  803e9d:	89 d6                	mov    %edx,%esi
  803e9f:	89 c3                	mov    %eax,%ebx
  803ea1:	f7 e5                	mul    %ebp
  803ea3:	39 d6                	cmp    %edx,%esi
  803ea5:	72 19                	jb     803ec0 <__udivdi3+0xfc>
  803ea7:	74 0b                	je     803eb4 <__udivdi3+0xf0>
  803ea9:	89 d8                	mov    %ebx,%eax
  803eab:	31 ff                	xor    %edi,%edi
  803ead:	e9 58 ff ff ff       	jmp    803e0a <__udivdi3+0x46>
  803eb2:	66 90                	xchg   %ax,%ax
  803eb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803eb8:	89 f9                	mov    %edi,%ecx
  803eba:	d3 e2                	shl    %cl,%edx
  803ebc:	39 c2                	cmp    %eax,%edx
  803ebe:	73 e9                	jae    803ea9 <__udivdi3+0xe5>
  803ec0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ec3:	31 ff                	xor    %edi,%edi
  803ec5:	e9 40 ff ff ff       	jmp    803e0a <__udivdi3+0x46>
  803eca:	66 90                	xchg   %ax,%ax
  803ecc:	31 c0                	xor    %eax,%eax
  803ece:	e9 37 ff ff ff       	jmp    803e0a <__udivdi3+0x46>
  803ed3:	90                   	nop

00803ed4 <__umoddi3>:
  803ed4:	55                   	push   %ebp
  803ed5:	57                   	push   %edi
  803ed6:	56                   	push   %esi
  803ed7:	53                   	push   %ebx
  803ed8:	83 ec 1c             	sub    $0x1c,%esp
  803edb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803edf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ee3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ee7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803eeb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803eef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ef3:	89 f3                	mov    %esi,%ebx
  803ef5:	89 fa                	mov    %edi,%edx
  803ef7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803efb:	89 34 24             	mov    %esi,(%esp)
  803efe:	85 c0                	test   %eax,%eax
  803f00:	75 1a                	jne    803f1c <__umoddi3+0x48>
  803f02:	39 f7                	cmp    %esi,%edi
  803f04:	0f 86 a2 00 00 00    	jbe    803fac <__umoddi3+0xd8>
  803f0a:	89 c8                	mov    %ecx,%eax
  803f0c:	89 f2                	mov    %esi,%edx
  803f0e:	f7 f7                	div    %edi
  803f10:	89 d0                	mov    %edx,%eax
  803f12:	31 d2                	xor    %edx,%edx
  803f14:	83 c4 1c             	add    $0x1c,%esp
  803f17:	5b                   	pop    %ebx
  803f18:	5e                   	pop    %esi
  803f19:	5f                   	pop    %edi
  803f1a:	5d                   	pop    %ebp
  803f1b:	c3                   	ret    
  803f1c:	39 f0                	cmp    %esi,%eax
  803f1e:	0f 87 ac 00 00 00    	ja     803fd0 <__umoddi3+0xfc>
  803f24:	0f bd e8             	bsr    %eax,%ebp
  803f27:	83 f5 1f             	xor    $0x1f,%ebp
  803f2a:	0f 84 ac 00 00 00    	je     803fdc <__umoddi3+0x108>
  803f30:	bf 20 00 00 00       	mov    $0x20,%edi
  803f35:	29 ef                	sub    %ebp,%edi
  803f37:	89 fe                	mov    %edi,%esi
  803f39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f3d:	89 e9                	mov    %ebp,%ecx
  803f3f:	d3 e0                	shl    %cl,%eax
  803f41:	89 d7                	mov    %edx,%edi
  803f43:	89 f1                	mov    %esi,%ecx
  803f45:	d3 ef                	shr    %cl,%edi
  803f47:	09 c7                	or     %eax,%edi
  803f49:	89 e9                	mov    %ebp,%ecx
  803f4b:	d3 e2                	shl    %cl,%edx
  803f4d:	89 14 24             	mov    %edx,(%esp)
  803f50:	89 d8                	mov    %ebx,%eax
  803f52:	d3 e0                	shl    %cl,%eax
  803f54:	89 c2                	mov    %eax,%edx
  803f56:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f5a:	d3 e0                	shl    %cl,%eax
  803f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f60:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f64:	89 f1                	mov    %esi,%ecx
  803f66:	d3 e8                	shr    %cl,%eax
  803f68:	09 d0                	or     %edx,%eax
  803f6a:	d3 eb                	shr    %cl,%ebx
  803f6c:	89 da                	mov    %ebx,%edx
  803f6e:	f7 f7                	div    %edi
  803f70:	89 d3                	mov    %edx,%ebx
  803f72:	f7 24 24             	mull   (%esp)
  803f75:	89 c6                	mov    %eax,%esi
  803f77:	89 d1                	mov    %edx,%ecx
  803f79:	39 d3                	cmp    %edx,%ebx
  803f7b:	0f 82 87 00 00 00    	jb     804008 <__umoddi3+0x134>
  803f81:	0f 84 91 00 00 00    	je     804018 <__umoddi3+0x144>
  803f87:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f8b:	29 f2                	sub    %esi,%edx
  803f8d:	19 cb                	sbb    %ecx,%ebx
  803f8f:	89 d8                	mov    %ebx,%eax
  803f91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f95:	d3 e0                	shl    %cl,%eax
  803f97:	89 e9                	mov    %ebp,%ecx
  803f99:	d3 ea                	shr    %cl,%edx
  803f9b:	09 d0                	or     %edx,%eax
  803f9d:	89 e9                	mov    %ebp,%ecx
  803f9f:	d3 eb                	shr    %cl,%ebx
  803fa1:	89 da                	mov    %ebx,%edx
  803fa3:	83 c4 1c             	add    $0x1c,%esp
  803fa6:	5b                   	pop    %ebx
  803fa7:	5e                   	pop    %esi
  803fa8:	5f                   	pop    %edi
  803fa9:	5d                   	pop    %ebp
  803faa:	c3                   	ret    
  803fab:	90                   	nop
  803fac:	89 fd                	mov    %edi,%ebp
  803fae:	85 ff                	test   %edi,%edi
  803fb0:	75 0b                	jne    803fbd <__umoddi3+0xe9>
  803fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  803fb7:	31 d2                	xor    %edx,%edx
  803fb9:	f7 f7                	div    %edi
  803fbb:	89 c5                	mov    %eax,%ebp
  803fbd:	89 f0                	mov    %esi,%eax
  803fbf:	31 d2                	xor    %edx,%edx
  803fc1:	f7 f5                	div    %ebp
  803fc3:	89 c8                	mov    %ecx,%eax
  803fc5:	f7 f5                	div    %ebp
  803fc7:	89 d0                	mov    %edx,%eax
  803fc9:	e9 44 ff ff ff       	jmp    803f12 <__umoddi3+0x3e>
  803fce:	66 90                	xchg   %ax,%ax
  803fd0:	89 c8                	mov    %ecx,%eax
  803fd2:	89 f2                	mov    %esi,%edx
  803fd4:	83 c4 1c             	add    $0x1c,%esp
  803fd7:	5b                   	pop    %ebx
  803fd8:	5e                   	pop    %esi
  803fd9:	5f                   	pop    %edi
  803fda:	5d                   	pop    %ebp
  803fdb:	c3                   	ret    
  803fdc:	3b 04 24             	cmp    (%esp),%eax
  803fdf:	72 06                	jb     803fe7 <__umoddi3+0x113>
  803fe1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803fe5:	77 0f                	ja     803ff6 <__umoddi3+0x122>
  803fe7:	89 f2                	mov    %esi,%edx
  803fe9:	29 f9                	sub    %edi,%ecx
  803feb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803fef:	89 14 24             	mov    %edx,(%esp)
  803ff2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ff6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ffa:	8b 14 24             	mov    (%esp),%edx
  803ffd:	83 c4 1c             	add    $0x1c,%esp
  804000:	5b                   	pop    %ebx
  804001:	5e                   	pop    %esi
  804002:	5f                   	pop    %edi
  804003:	5d                   	pop    %ebp
  804004:	c3                   	ret    
  804005:	8d 76 00             	lea    0x0(%esi),%esi
  804008:	2b 04 24             	sub    (%esp),%eax
  80400b:	19 fa                	sbb    %edi,%edx
  80400d:	89 d1                	mov    %edx,%ecx
  80400f:	89 c6                	mov    %eax,%esi
  804011:	e9 71 ff ff ff       	jmp    803f87 <__umoddi3+0xb3>
  804016:	66 90                	xchg   %ax,%ax
  804018:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80401c:	72 ea                	jb     804008 <__umoddi3+0x134>
  80401e:	89 d9                	mov    %ebx,%ecx
  804020:	e9 62 ff ff ff       	jmp    803f87 <__umoddi3+0xb3>
