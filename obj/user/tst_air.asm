
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
  800044:	e8 5e 25 00 00       	call   8025a7 <sys_getenvid>
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
  80007c:	bb 96 44 80 00       	mov    $0x804496,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb a0 44 80 00       	mov    $0x8044a0,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb ac 44 80 00       	mov    $0x8044ac,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb bb 44 80 00       	mov    $0x8044bb,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb ca 44 80 00       	mov    $0x8044ca,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb df 44 80 00       	mov    $0x8044df,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb f4 44 80 00       	mov    $0x8044f4,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb 05 45 80 00       	mov    $0x804505,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb 16 45 80 00       	mov    $0x804516,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb 27 45 80 00       	mov    $0x804527,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb 30 45 80 00       	mov    $0x804530,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb 3a 45 80 00       	mov    $0x80453a,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb 45 45 80 00       	mov    $0x804545,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb 51 45 80 00       	mov    $0x804551,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb 5b 45 80 00       	mov    $0x80455b,%ebx
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
  8001f7:	bb 65 45 80 00       	mov    $0x804565,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb 73 45 80 00       	mov    $0x804573,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 82 45 80 00       	mov    $0x804582,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 89 45 80 00       	mov    $0x804589,%ebx
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
  800264:	e8 a5 1d 00 00       	call   80200e <smalloc>
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
  800342:	e8 c7 1c 00 00       	call   80200e <smalloc>
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
  800364:	e8 a5 1c 00 00       	call   80200e <smalloc>
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
  800385:	e8 84 1c 00 00       	call   80200e <smalloc>
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
  8003a6:	e8 63 1c 00 00       	call   80200e <smalloc>
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
  8003c8:	e8 41 1c 00 00       	call   80200e <smalloc>
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
  8003ef:	e8 1a 1c 00 00       	call   80200e <smalloc>
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
  80040d:	e8 fc 1b 00 00       	call   80200e <smalloc>
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
  80042b:	e8 de 1b 00 00       	call   80200e <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 c5 1b 00 00       	call   80200e <smalloc>
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
  80046c:	e8 9d 1b 00 00       	call   80200e <smalloc>
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
  800492:	e8 aa 1f 00 00       	call   802441 <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 96 1f 00 00       	call   802441 <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 82 1f 00 00       	call   802441 <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 6e 1f 00 00       	call   802441 <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 5a 1f 00 00       	call   802441 <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 46 1f 00 00       	call   802441 <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 32 1f 00 00       	call   802441 <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 90 45 80 00       	mov    $0x804590,%ebx
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
  80058f:	e8 ad 1e 00 00       	call   802441 <sys_createSemaphore>
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
  8005cc:	e8 81 1f 00 00       	call   802552 <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 87 1f 00 00       	call   802570 <sys_run_env>
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
  800616:	e8 37 1f 00 00       	call   802552 <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 3d 1f 00 00       	call   802570 <sys_run_env>
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
  800660:	e8 ed 1e 00 00       	call   802552 <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 f3 1e 00 00       	call   802570 <sys_run_env>
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
  8006b3:	e8 9a 1e 00 00       	call   802552 <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 c0 41 80 00       	push   $0x8041c0
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 06 42 80 00       	push   $0x804206
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 80 1e 00 00       	call   802570 <sys_run_env>
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
  800714:	e8 61 1d 00 00       	call   80247a <sys_waitSemaphore>
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
  80072f:	e8 6e 37 00 00       	call   803ea2 <env_sleep>
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
  800775:	68 18 42 80 00       	push   $0x804218
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
  8007cd:	68 48 42 80 00       	push   $0x804248
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
  80080c:	68 78 42 80 00       	push   $0x804278
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 06 42 80 00       	push   $0x804206
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
  80084f:	68 78 42 80 00       	push   $0x804278
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 06 42 80 00       	push   $0x804206
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
  8008b0:	68 78 42 80 00       	push   $0x804278
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 06 42 80 00       	push   $0x804206
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
  8008e1:	e8 77 1b 00 00       	call   80245d <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 9c 42 80 00       	push   $0x80429c
  8008f3:	68 ca 42 80 00       	push   $0x8042ca
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 06 42 80 00       	push   $0x804206
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 44 1b 00 00       	call   80245d <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 e0 42 80 00       	push   $0x8042e0
  800926:	68 ca 42 80 00       	push   $0x8042ca
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 06 42 80 00       	push   $0x804206
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 11 1b 00 00       	call   80245d <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 10 43 80 00       	push   $0x804310
  800959:	68 ca 42 80 00       	push   $0x8042ca
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 06 42 80 00       	push   $0x804206
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 de 1a 00 00       	call   80245d <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 44 43 80 00       	push   $0x804344
  80098c:	68 ca 42 80 00       	push   $0x8042ca
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 06 42 80 00       	push   $0x804206
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 ab 1a 00 00       	call   80245d <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 74 43 80 00       	push   $0x804374
  8009bf:	68 ca 42 80 00       	push   $0x8042ca
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 06 42 80 00       	push   $0x804206
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 78 1a 00 00       	call   80245d <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 a0 43 80 00       	push   $0x8043a0
  8009f2:	68 ca 42 80 00       	push   $0x8042ca
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 06 42 80 00       	push   $0x804206
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 45 1a 00 00       	call   80245d <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 d0 43 80 00       	push   $0x8043d0
  800a24:	68 ca 42 80 00       	push   $0x8042ca
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 06 42 80 00       	push   $0x804206
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 90 45 80 00       	mov    $0x804590,%ebx
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
  800ab9:	e8 9f 19 00 00       	call   80245d <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 04 44 80 00       	push   $0x804404
  800aca:	68 ca 42 80 00       	push   $0x8042ca
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 06 42 80 00       	push   $0x804206
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
  800af0:	68 44 44 80 00       	push   $0x804444
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
  800b51:	e8 6a 1a 00 00       	call   8025c0 <sys_getenvindex>
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
  800bbc:	e8 0c 18 00 00       	call   8023cd <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 c8 45 80 00       	push   $0x8045c8
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
  800bec:	68 f0 45 80 00       	push   $0x8045f0
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
  800c1d:	68 18 46 80 00       	push   $0x804618
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 70 46 80 00       	push   $0x804670
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 c8 45 80 00       	push   $0x8045c8
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 8c 17 00 00       	call   8023e7 <sys_enable_interrupt>

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
  800c6e:	e8 19 19 00 00       	call   80258c <sys_destroy_env>
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
  800c7f:	e8 6e 19 00 00       	call   8025f2 <sys_exit_env>
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
  800ca8:	68 84 46 80 00       	push   $0x804684
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 89 46 80 00       	push   $0x804689
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
  800ce5:	68 a5 46 80 00       	push   $0x8046a5
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
  800d11:	68 a8 46 80 00       	push   $0x8046a8
  800d16:	6a 26                	push   $0x26
  800d18:	68 f4 46 80 00       	push   $0x8046f4
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
  800de3:	68 00 47 80 00       	push   $0x804700
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 f4 46 80 00       	push   $0x8046f4
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
  800e53:	68 54 47 80 00       	push   $0x804754
  800e58:	6a 44                	push   $0x44
  800e5a:	68 f4 46 80 00       	push   $0x8046f4
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
  800ead:	e8 6d 13 00 00       	call   80221f <sys_cputs>
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
  800f24:	e8 f6 12 00 00       	call   80221f <sys_cputs>
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
  800f6e:	e8 5a 14 00 00       	call   8023cd <sys_disable_interrupt>
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
  800f8e:	e8 54 14 00 00       	call   8023e7 <sys_enable_interrupt>
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
  800fd8:	e8 7b 2f 00 00       	call   803f58 <__udivdi3>
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
  801028:	e8 3b 30 00 00       	call   804068 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 b4 49 80 00       	add    $0x8049b4,%eax
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
  801183:	8b 04 85 d8 49 80 00 	mov    0x8049d8(,%eax,4),%eax
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
  801264:	8b 34 9d 20 48 80 00 	mov    0x804820(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 c5 49 80 00       	push   $0x8049c5
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
  801289:	68 ce 49 80 00       	push   $0x8049ce
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
  8012b6:	be d1 49 80 00       	mov    $0x8049d1,%esi
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
  801cdc:	68 30 4b 80 00       	push   $0x804b30
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
  801dac:	e8 b2 05 00 00       	call   802363 <sys_allocate_chunk>
  801db1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801db4:	a1 20 51 80 00       	mov    0x805120,%eax
  801db9:	83 ec 0c             	sub    $0xc,%esp
  801dbc:	50                   	push   %eax
  801dbd:	e8 27 0c 00 00       	call   8029e9 <initialize_MemBlocksList>
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
  801dea:	68 55 4b 80 00       	push   $0x804b55
  801def:	6a 33                	push   $0x33
  801df1:	68 73 4b 80 00       	push   $0x804b73
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
  801e69:	68 80 4b 80 00       	push   $0x804b80
  801e6e:	6a 34                	push   $0x34
  801e70:	68 73 4b 80 00       	push   $0x804b73
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
  801f01:	e8 2b 08 00 00       	call   802731 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f06:	85 c0                	test   %eax,%eax
  801f08:	74 11                	je     801f1b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	ff 75 e8             	pushl  -0x18(%ebp)
  801f10:	e8 96 0e 00 00       	call   802dab <alloc_block_FF>
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
  801f27:	e8 f2 0b 00 00       	call   802b1e <insert_sorted_allocList>
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
  801f41:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	83 ec 08             	sub    $0x8,%esp
  801f4a:	50                   	push   %eax
  801f4b:	68 40 50 80 00       	push   $0x805040
  801f50:	e8 71 0b 00 00       	call   802ac6 <find_block>
  801f55:	83 c4 10             	add    $0x10,%esp
  801f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801f5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5f:	0f 84 a6 00 00 00    	je     80200b <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	8b 50 0c             	mov    0xc(%eax),%edx
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 40 08             	mov    0x8(%eax),%eax
  801f71:	83 ec 08             	sub    $0x8,%esp
  801f74:	52                   	push   %edx
  801f75:	50                   	push   %eax
  801f76:	e8 b0 03 00 00       	call   80232b <sys_free_user_mem>
  801f7b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801f7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f82:	75 14                	jne    801f98 <free+0x5a>
  801f84:	83 ec 04             	sub    $0x4,%esp
  801f87:	68 55 4b 80 00       	push   $0x804b55
  801f8c:	6a 74                	push   $0x74
  801f8e:	68 73 4b 80 00       	push   $0x804b73
  801f93:	e8 ef ec ff ff       	call   800c87 <_panic>
  801f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9b:	8b 00                	mov    (%eax),%eax
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	74 10                	je     801fb1 <free+0x73>
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	8b 00                	mov    (%eax),%eax
  801fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa9:	8b 52 04             	mov    0x4(%edx),%edx
  801fac:	89 50 04             	mov    %edx,0x4(%eax)
  801faf:	eb 0b                	jmp    801fbc <free+0x7e>
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	8b 40 04             	mov    0x4(%eax),%eax
  801fb7:	a3 44 50 80 00       	mov    %eax,0x805044
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	8b 40 04             	mov    0x4(%eax),%eax
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	74 0f                	je     801fd5 <free+0x97>
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	8b 40 04             	mov    0x4(%eax),%eax
  801fcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcf:	8b 12                	mov    (%edx),%edx
  801fd1:	89 10                	mov    %edx,(%eax)
  801fd3:	eb 0a                	jmp    801fdf <free+0xa1>
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	8b 00                	mov    (%eax),%eax
  801fda:	a3 40 50 80 00       	mov    %eax,0x805040
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801feb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ff2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ff7:	48                   	dec    %eax
  801ff8:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	ff 75 f4             	pushl  -0xc(%ebp)
  802003:	e8 4e 17 00 00       	call   803756 <insert_sorted_with_merge_freeList>
  802008:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80200b:	90                   	nop
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 38             	sub    $0x38,%esp
  802014:	8b 45 10             	mov    0x10(%ebp),%eax
  802017:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80201a:	e8 a6 fc ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  80201f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802023:	75 0a                	jne    80202f <smalloc+0x21>
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	e9 8b 00 00 00       	jmp    8020ba <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80202f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802036:	8b 55 0c             	mov    0xc(%ebp),%edx
  802039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203c:	01 d0                	add    %edx,%eax
  80203e:	48                   	dec    %eax
  80203f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802042:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802045:	ba 00 00 00 00       	mov    $0x0,%edx
  80204a:	f7 75 f0             	divl   -0x10(%ebp)
  80204d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802050:	29 d0                	sub    %edx,%eax
  802052:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802055:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80205c:	e8 d0 06 00 00       	call   802731 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802061:	85 c0                	test   %eax,%eax
  802063:	74 11                	je     802076 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	ff 75 e8             	pushl  -0x18(%ebp)
  80206b:	e8 3b 0d 00 00       	call   802dab <alloc_block_FF>
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  802076:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207a:	74 39                	je     8020b5 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	8b 40 08             	mov    0x8(%eax),%eax
  802082:	89 c2                	mov    %eax,%edx
  802084:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802088:	52                   	push   %edx
  802089:	50                   	push   %eax
  80208a:	ff 75 0c             	pushl  0xc(%ebp)
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	e8 21 04 00 00       	call   8024b6 <sys_createSharedObject>
  802095:	83 c4 10             	add    $0x10,%esp
  802098:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80209b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80209f:	74 14                	je     8020b5 <smalloc+0xa7>
  8020a1:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8020a5:	74 0e                	je     8020b5 <smalloc+0xa7>
  8020a7:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8020ab:	74 08                	je     8020b5 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b0:	8b 40 08             	mov    0x8(%eax),%eax
  8020b3:	eb 05                	jmp    8020ba <smalloc+0xac>
	}
	return NULL;
  8020b5:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020c2:	e8 fe fb ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020c7:	83 ec 08             	sub    $0x8,%esp
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	ff 75 08             	pushl  0x8(%ebp)
  8020d0:	e8 0b 04 00 00       	call   8024e0 <sys_getSizeOfSharedObject>
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8020db:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8020df:	74 76                	je     802157 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8020e1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ee:	01 d0                	add    %edx,%eax
  8020f0:	48                   	dec    %eax
  8020f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020fc:	f7 75 ec             	divl   -0x14(%ebp)
  8020ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802102:	29 d0                	sub    %edx,%eax
  802104:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  802107:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80210e:	e8 1e 06 00 00       	call   802731 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802113:	85 c0                	test   %eax,%eax
  802115:	74 11                	je     802128 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  802117:	83 ec 0c             	sub    $0xc,%esp
  80211a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80211d:	e8 89 0c 00 00       	call   802dab <alloc_block_FF>
  802122:	83 c4 10             	add    $0x10,%esp
  802125:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  802128:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212c:	74 29                	je     802157 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	8b 40 08             	mov    0x8(%eax),%eax
  802134:	83 ec 04             	sub    $0x4,%esp
  802137:	50                   	push   %eax
  802138:	ff 75 0c             	pushl  0xc(%ebp)
  80213b:	ff 75 08             	pushl  0x8(%ebp)
  80213e:	e8 ba 03 00 00       	call   8024fd <sys_getSharedObject>
  802143:	83 c4 10             	add    $0x10,%esp
  802146:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  802149:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80214d:	74 08                	je     802157 <sget+0x9b>
				return (void *)mem_block->sva;
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	8b 40 08             	mov    0x8(%eax),%eax
  802155:	eb 05                	jmp    80215c <sget+0xa0>
		}
	}
	return NULL;
  802157:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802164:	e8 5c fb ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802169:	83 ec 04             	sub    $0x4,%esp
  80216c:	68 a4 4b 80 00       	push   $0x804ba4
  802171:	68 f7 00 00 00       	push   $0xf7
  802176:	68 73 4b 80 00       	push   $0x804b73
  80217b:	e8 07 eb ff ff       	call   800c87 <_panic>

00802180 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802186:	83 ec 04             	sub    $0x4,%esp
  802189:	68 cc 4b 80 00       	push   $0x804bcc
  80218e:	68 0b 01 00 00       	push   $0x10b
  802193:	68 73 4b 80 00       	push   $0x804b73
  802198:	e8 ea ea ff ff       	call   800c87 <_panic>

0080219d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	68 f0 4b 80 00       	push   $0x804bf0
  8021ab:	68 16 01 00 00       	push   $0x116
  8021b0:	68 73 4b 80 00       	push   $0x804b73
  8021b5:	e8 cd ea ff ff       	call   800c87 <_panic>

008021ba <shrink>:

}
void shrink(uint32 newSize)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	68 f0 4b 80 00       	push   $0x804bf0
  8021c8:	68 1b 01 00 00       	push   $0x11b
  8021cd:	68 73 4b 80 00       	push   $0x804b73
  8021d2:	e8 b0 ea ff ff       	call   800c87 <_panic>

008021d7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021dd:	83 ec 04             	sub    $0x4,%esp
  8021e0:	68 f0 4b 80 00       	push   $0x804bf0
  8021e5:	68 20 01 00 00       	push   $0x120
  8021ea:	68 73 4b 80 00       	push   $0x804b73
  8021ef:	e8 93 ea ff ff       	call   800c87 <_panic>

008021f4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	57                   	push   %edi
  8021f8:	56                   	push   %esi
  8021f9:	53                   	push   %ebx
  8021fa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	8b 55 0c             	mov    0xc(%ebp),%edx
  802203:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802206:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802209:	8b 7d 18             	mov    0x18(%ebp),%edi
  80220c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80220f:	cd 30                	int    $0x30
  802211:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802214:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802217:	83 c4 10             	add    $0x10,%esp
  80221a:	5b                   	pop    %ebx
  80221b:	5e                   	pop    %esi
  80221c:	5f                   	pop    %edi
  80221d:	5d                   	pop    %ebp
  80221e:	c3                   	ret    

0080221f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	8b 45 10             	mov    0x10(%ebp),%eax
  802228:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80222b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	52                   	push   %edx
  802237:	ff 75 0c             	pushl  0xc(%ebp)
  80223a:	50                   	push   %eax
  80223b:	6a 00                	push   $0x0
  80223d:	e8 b2 ff ff ff       	call   8021f4 <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
}
  802245:	90                   	nop
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <sys_cgetc>:

int
sys_cgetc(void)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 01                	push   $0x1
  802257:	e8 98 ff ff ff       	call   8021f4 <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802264:	8b 55 0c             	mov    0xc(%ebp),%edx
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	52                   	push   %edx
  802271:	50                   	push   %eax
  802272:	6a 05                	push   $0x5
  802274:	e8 7b ff ff ff       	call   8021f4 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	56                   	push   %esi
  802282:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802283:	8b 75 18             	mov    0x18(%ebp),%esi
  802286:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802289:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80228c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	51                   	push   %ecx
  802295:	52                   	push   %edx
  802296:	50                   	push   %eax
  802297:	6a 06                	push   $0x6
  802299:	e8 56 ff ff ff       	call   8021f4 <syscall>
  80229e:	83 c4 18             	add    $0x18,%esp
}
  8022a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022a4:	5b                   	pop    %ebx
  8022a5:	5e                   	pop    %esi
  8022a6:	5d                   	pop    %ebp
  8022a7:	c3                   	ret    

008022a8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	52                   	push   %edx
  8022b8:	50                   	push   %eax
  8022b9:	6a 07                	push   $0x7
  8022bb:	e8 34 ff ff ff       	call   8021f4 <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	ff 75 0c             	pushl  0xc(%ebp)
  8022d1:	ff 75 08             	pushl  0x8(%ebp)
  8022d4:	6a 08                	push   $0x8
  8022d6:	e8 19 ff ff ff       	call   8021f4 <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 09                	push   $0x9
  8022ef:	e8 00 ff ff ff       	call   8021f4 <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 0a                	push   $0xa
  802308:	e8 e7 fe ff ff       	call   8021f4 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 0b                	push   $0xb
  802321:	e8 ce fe ff ff       	call   8021f4 <syscall>
  802326:	83 c4 18             	add    $0x18,%esp
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	ff 75 0c             	pushl  0xc(%ebp)
  802337:	ff 75 08             	pushl  0x8(%ebp)
  80233a:	6a 0f                	push   $0xf
  80233c:	e8 b3 fe ff ff       	call   8021f4 <syscall>
  802341:	83 c4 18             	add    $0x18,%esp
	return;
  802344:	90                   	nop
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	ff 75 0c             	pushl  0xc(%ebp)
  802353:	ff 75 08             	pushl  0x8(%ebp)
  802356:	6a 10                	push   $0x10
  802358:	e8 97 fe ff ff       	call   8021f4 <syscall>
  80235d:	83 c4 18             	add    $0x18,%esp
	return ;
  802360:	90                   	nop
}
  802361:	c9                   	leave  
  802362:	c3                   	ret    

00802363 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	ff 75 10             	pushl  0x10(%ebp)
  80236d:	ff 75 0c             	pushl  0xc(%ebp)
  802370:	ff 75 08             	pushl  0x8(%ebp)
  802373:	6a 11                	push   $0x11
  802375:	e8 7a fe ff ff       	call   8021f4 <syscall>
  80237a:	83 c4 18             	add    $0x18,%esp
	return ;
  80237d:	90                   	nop
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 0c                	push   $0xc
  80238f:	e8 60 fe ff ff       	call   8021f4 <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	ff 75 08             	pushl  0x8(%ebp)
  8023a7:	6a 0d                	push   $0xd
  8023a9:	e8 46 fe ff ff       	call   8021f4 <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 0e                	push   $0xe
  8023c2:	e8 2d fe ff ff       	call   8021f4 <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	90                   	nop
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 13                	push   $0x13
  8023dc:	e8 13 fe ff ff       	call   8021f4 <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
}
  8023e4:	90                   	nop
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 14                	push   $0x14
  8023f6:	e8 f9 fd ff ff       	call   8021f4 <syscall>
  8023fb:	83 c4 18             	add    $0x18,%esp
}
  8023fe:	90                   	nop
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_cputc>:


void
sys_cputc(const char c)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	83 ec 04             	sub    $0x4,%esp
  802407:	8b 45 08             	mov    0x8(%ebp),%eax
  80240a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80240d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	50                   	push   %eax
  80241a:	6a 15                	push   $0x15
  80241c:	e8 d3 fd ff ff       	call   8021f4 <syscall>
  802421:	83 c4 18             	add    $0x18,%esp
}
  802424:	90                   	nop
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 16                	push   $0x16
  802436:	e8 b9 fd ff ff       	call   8021f4 <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
}
  80243e:	90                   	nop
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	ff 75 0c             	pushl  0xc(%ebp)
  802450:	50                   	push   %eax
  802451:	6a 17                	push   $0x17
  802453:	e8 9c fd ff ff       	call   8021f4 <syscall>
  802458:	83 c4 18             	add    $0x18,%esp
}
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802460:	8b 55 0c             	mov    0xc(%ebp),%edx
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	52                   	push   %edx
  80246d:	50                   	push   %eax
  80246e:	6a 1a                	push   $0x1a
  802470:	e8 7f fd ff ff       	call   8021f4 <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80247d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	52                   	push   %edx
  80248a:	50                   	push   %eax
  80248b:	6a 18                	push   $0x18
  80248d:	e8 62 fd ff ff       	call   8021f4 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80249b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	52                   	push   %edx
  8024a8:	50                   	push   %eax
  8024a9:	6a 19                	push   $0x19
  8024ab:	e8 44 fd ff ff       	call   8021f4 <syscall>
  8024b0:	83 c4 18             	add    $0x18,%esp
}
  8024b3:	90                   	nop
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 04             	sub    $0x4,%esp
  8024bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8024bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024c5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	6a 00                	push   $0x0
  8024ce:	51                   	push   %ecx
  8024cf:	52                   	push   %edx
  8024d0:	ff 75 0c             	pushl  0xc(%ebp)
  8024d3:	50                   	push   %eax
  8024d4:	6a 1b                	push   $0x1b
  8024d6:	e8 19 fd ff ff       	call   8021f4 <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	52                   	push   %edx
  8024f0:	50                   	push   %eax
  8024f1:	6a 1c                	push   $0x1c
  8024f3:	e8 fc fc ff ff       	call   8021f4 <syscall>
  8024f8:	83 c4 18             	add    $0x18,%esp
}
  8024fb:	c9                   	leave  
  8024fc:	c3                   	ret    

008024fd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024fd:	55                   	push   %ebp
  8024fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802500:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802503:	8b 55 0c             	mov    0xc(%ebp),%edx
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	51                   	push   %ecx
  80250e:	52                   	push   %edx
  80250f:	50                   	push   %eax
  802510:	6a 1d                	push   $0x1d
  802512:	e8 dd fc ff ff       	call   8021f4 <syscall>
  802517:	83 c4 18             	add    $0x18,%esp
}
  80251a:	c9                   	leave  
  80251b:	c3                   	ret    

0080251c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80251f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	52                   	push   %edx
  80252c:	50                   	push   %eax
  80252d:	6a 1e                	push   $0x1e
  80252f:	e8 c0 fc ff ff       	call   8021f4 <syscall>
  802534:	83 c4 18             	add    $0x18,%esp
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 1f                	push   $0x1f
  802548:	e8 a7 fc ff ff       	call   8021f4 <syscall>
  80254d:	83 c4 18             	add    $0x18,%esp
}
  802550:	c9                   	leave  
  802551:	c3                   	ret    

00802552 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	6a 00                	push   $0x0
  80255a:	ff 75 14             	pushl  0x14(%ebp)
  80255d:	ff 75 10             	pushl  0x10(%ebp)
  802560:	ff 75 0c             	pushl  0xc(%ebp)
  802563:	50                   	push   %eax
  802564:	6a 20                	push   $0x20
  802566:	e8 89 fc ff ff       	call   8021f4 <syscall>
  80256b:	83 c4 18             	add    $0x18,%esp
}
  80256e:	c9                   	leave  
  80256f:	c3                   	ret    

00802570 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	50                   	push   %eax
  80257f:	6a 21                	push   $0x21
  802581:	e8 6e fc ff ff       	call   8021f4 <syscall>
  802586:	83 c4 18             	add    $0x18,%esp
}
  802589:	90                   	nop
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	50                   	push   %eax
  80259b:	6a 22                	push   $0x22
  80259d:	e8 52 fc ff ff       	call   8021f4 <syscall>
  8025a2:	83 c4 18             	add    $0x18,%esp
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 02                	push   $0x2
  8025b6:	e8 39 fc ff ff       	call   8021f4 <syscall>
  8025bb:	83 c4 18             	add    $0x18,%esp
}
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 03                	push   $0x3
  8025cf:	e8 20 fc ff ff       	call   8021f4 <syscall>
  8025d4:	83 c4 18             	add    $0x18,%esp
}
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 04                	push   $0x4
  8025e8:	e8 07 fc ff ff       	call   8021f4 <syscall>
  8025ed:	83 c4 18             	add    $0x18,%esp
}
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    

008025f2 <sys_exit_env>:


void sys_exit_env(void)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 23                	push   $0x23
  802601:	e8 ee fb ff ff       	call   8021f4 <syscall>
  802606:	83 c4 18             	add    $0x18,%esp
}
  802609:	90                   	nop
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
  80260f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802612:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802615:	8d 50 04             	lea    0x4(%eax),%edx
  802618:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	52                   	push   %edx
  802622:	50                   	push   %eax
  802623:	6a 24                	push   $0x24
  802625:	e8 ca fb ff ff       	call   8021f4 <syscall>
  80262a:	83 c4 18             	add    $0x18,%esp
	return result;
  80262d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802633:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802636:	89 01                	mov    %eax,(%ecx)
  802638:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	c9                   	leave  
  80263f:	c2 04 00             	ret    $0x4

00802642 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	ff 75 10             	pushl  0x10(%ebp)
  80264c:	ff 75 0c             	pushl  0xc(%ebp)
  80264f:	ff 75 08             	pushl  0x8(%ebp)
  802652:	6a 12                	push   $0x12
  802654:	e8 9b fb ff ff       	call   8021f4 <syscall>
  802659:	83 c4 18             	add    $0x18,%esp
	return ;
  80265c:	90                   	nop
}
  80265d:	c9                   	leave  
  80265e:	c3                   	ret    

0080265f <sys_rcr2>:
uint32 sys_rcr2()
{
  80265f:	55                   	push   %ebp
  802660:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	6a 25                	push   $0x25
  80266e:	e8 81 fb ff ff       	call   8021f4 <syscall>
  802673:	83 c4 18             	add    $0x18,%esp
}
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	83 ec 04             	sub    $0x4,%esp
  80267e:	8b 45 08             	mov    0x8(%ebp),%eax
  802681:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802684:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	50                   	push   %eax
  802691:	6a 26                	push   $0x26
  802693:	e8 5c fb ff ff       	call   8021f4 <syscall>
  802698:	83 c4 18             	add    $0x18,%esp
	return ;
  80269b:	90                   	nop
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <rsttst>:
void rsttst()
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 28                	push   $0x28
  8026ad:	e8 42 fb ff ff       	call   8021f4 <syscall>
  8026b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b5:	90                   	nop
}
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
  8026bb:	83 ec 04             	sub    $0x4,%esp
  8026be:	8b 45 14             	mov    0x14(%ebp),%eax
  8026c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026c4:	8b 55 18             	mov    0x18(%ebp),%edx
  8026c7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026cb:	52                   	push   %edx
  8026cc:	50                   	push   %eax
  8026cd:	ff 75 10             	pushl  0x10(%ebp)
  8026d0:	ff 75 0c             	pushl  0xc(%ebp)
  8026d3:	ff 75 08             	pushl  0x8(%ebp)
  8026d6:	6a 27                	push   $0x27
  8026d8:	e8 17 fb ff ff       	call   8021f4 <syscall>
  8026dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e0:	90                   	nop
}
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    

008026e3 <chktst>:
void chktst(uint32 n)
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	ff 75 08             	pushl  0x8(%ebp)
  8026f1:	6a 29                	push   $0x29
  8026f3:	e8 fc fa ff ff       	call   8021f4 <syscall>
  8026f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8026fb:	90                   	nop
}
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    

008026fe <inctst>:

void inctst()
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 2a                	push   $0x2a
  80270d:	e8 e2 fa ff ff       	call   8021f4 <syscall>
  802712:	83 c4 18             	add    $0x18,%esp
	return ;
  802715:	90                   	nop
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <gettst>:
uint32 gettst()
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 2b                	push   $0x2b
  802727:	e8 c8 fa ff ff       	call   8021f4 <syscall>
  80272c:	83 c4 18             	add    $0x18,%esp
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 2c                	push   $0x2c
  802743:	e8 ac fa ff ff       	call   8021f4 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
  80274b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80274e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802752:	75 07                	jne    80275b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802754:	b8 01 00 00 00       	mov    $0x1,%eax
  802759:	eb 05                	jmp    802760 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80275b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802768:	6a 00                	push   $0x0
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	6a 2c                	push   $0x2c
  802774:	e8 7b fa ff ff       	call   8021f4 <syscall>
  802779:	83 c4 18             	add    $0x18,%esp
  80277c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80277f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802783:	75 07                	jne    80278c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802785:	b8 01 00 00 00       	mov    $0x1,%eax
  80278a:	eb 05                	jmp    802791 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80278c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
  802796:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 2c                	push   $0x2c
  8027a5:	e8 4a fa ff ff       	call   8021f4 <syscall>
  8027aa:	83 c4 18             	add    $0x18,%esp
  8027ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027b0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027b4:	75 07                	jne    8027bd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027bb:	eb 05                	jmp    8027c2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 2c                	push   $0x2c
  8027d6:	e8 19 fa ff ff       	call   8021f4 <syscall>
  8027db:	83 c4 18             	add    $0x18,%esp
  8027de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027e1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027e5:	75 07                	jne    8027ee <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ec:	eb 05                	jmp    8027f3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f3:	c9                   	leave  
  8027f4:	c3                   	ret    

008027f5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	ff 75 08             	pushl  0x8(%ebp)
  802803:	6a 2d                	push   $0x2d
  802805:	e8 ea f9 ff ff       	call   8021f4 <syscall>
  80280a:	83 c4 18             	add    $0x18,%esp
	return ;
  80280d:	90                   	nop
}
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802814:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802817:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80281a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	6a 00                	push   $0x0
  802822:	53                   	push   %ebx
  802823:	51                   	push   %ecx
  802824:	52                   	push   %edx
  802825:	50                   	push   %eax
  802826:	6a 2e                	push   $0x2e
  802828:	e8 c7 f9 ff ff       	call   8021f4 <syscall>
  80282d:	83 c4 18             	add    $0x18,%esp
}
  802830:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802833:	c9                   	leave  
  802834:	c3                   	ret    

00802835 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	52                   	push   %edx
  802845:	50                   	push   %eax
  802846:	6a 2f                	push   $0x2f
  802848:	e8 a7 f9 ff ff       	call   8021f4 <syscall>
  80284d:	83 c4 18             	add    $0x18,%esp
}
  802850:	c9                   	leave  
  802851:	c3                   	ret    

00802852 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802852:	55                   	push   %ebp
  802853:	89 e5                	mov    %esp,%ebp
  802855:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802858:	83 ec 0c             	sub    $0xc,%esp
  80285b:	68 00 4c 80 00       	push   $0x804c00
  802860:	e8 d6 e6 ff ff       	call   800f3b <cprintf>
  802865:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802868:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80286f:	83 ec 0c             	sub    $0xc,%esp
  802872:	68 2c 4c 80 00       	push   $0x804c2c
  802877:	e8 bf e6 ff ff       	call   800f3b <cprintf>
  80287c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80287f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802883:	a1 38 51 80 00       	mov    0x805138,%eax
  802888:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288b:	eb 56                	jmp    8028e3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80288d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802891:	74 1c                	je     8028af <print_mem_block_lists+0x5d>
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 50 08             	mov    0x8(%eax),%edx
  802899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289c:	8b 48 08             	mov    0x8(%eax),%ecx
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a5:	01 c8                	add    %ecx,%eax
  8028a7:	39 c2                	cmp    %eax,%edx
  8028a9:	73 04                	jae    8028af <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8028ab:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 50 08             	mov    0x8(%eax),%edx
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bb:	01 c2                	add    %eax,%edx
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 40 08             	mov    0x8(%eax),%eax
  8028c3:	83 ec 04             	sub    $0x4,%esp
  8028c6:	52                   	push   %edx
  8028c7:	50                   	push   %eax
  8028c8:	68 41 4c 80 00       	push   $0x804c41
  8028cd:	e8 69 e6 ff ff       	call   800f3b <cprintf>
  8028d2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028db:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e7:	74 07                	je     8028f0 <print_mem_block_lists+0x9e>
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	eb 05                	jmp    8028f5 <print_mem_block_lists+0xa3>
  8028f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f5:	a3 40 51 80 00       	mov    %eax,0x805140
  8028fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	75 8a                	jne    80288d <print_mem_block_lists+0x3b>
  802903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802907:	75 84                	jne    80288d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802909:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80290d:	75 10                	jne    80291f <print_mem_block_lists+0xcd>
  80290f:	83 ec 0c             	sub    $0xc,%esp
  802912:	68 50 4c 80 00       	push   $0x804c50
  802917:	e8 1f e6 ff ff       	call   800f3b <cprintf>
  80291c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80291f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802926:	83 ec 0c             	sub    $0xc,%esp
  802929:	68 74 4c 80 00       	push   $0x804c74
  80292e:	e8 08 e6 ff ff       	call   800f3b <cprintf>
  802933:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802936:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80293a:	a1 40 50 80 00       	mov    0x805040,%eax
  80293f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802942:	eb 56                	jmp    80299a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802944:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802948:	74 1c                	je     802966 <print_mem_block_lists+0x114>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 50 08             	mov    0x8(%eax),%edx
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	8b 48 08             	mov    0x8(%eax),%ecx
  802956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802959:	8b 40 0c             	mov    0xc(%eax),%eax
  80295c:	01 c8                	add    %ecx,%eax
  80295e:	39 c2                	cmp    %eax,%edx
  802960:	73 04                	jae    802966 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802962:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 50 08             	mov    0x8(%eax),%edx
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 40 0c             	mov    0xc(%eax),%eax
  802972:	01 c2                	add    %eax,%edx
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 40 08             	mov    0x8(%eax),%eax
  80297a:	83 ec 04             	sub    $0x4,%esp
  80297d:	52                   	push   %edx
  80297e:	50                   	push   %eax
  80297f:	68 41 4c 80 00       	push   $0x804c41
  802984:	e8 b2 e5 ff ff       	call   800f3b <cprintf>
  802989:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802992:	a1 48 50 80 00       	mov    0x805048,%eax
  802997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299e:	74 07                	je     8029a7 <print_mem_block_lists+0x155>
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	eb 05                	jmp    8029ac <print_mem_block_lists+0x15a>
  8029a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ac:	a3 48 50 80 00       	mov    %eax,0x805048
  8029b1:	a1 48 50 80 00       	mov    0x805048,%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	75 8a                	jne    802944 <print_mem_block_lists+0xf2>
  8029ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029be:	75 84                	jne    802944 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029c0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029c4:	75 10                	jne    8029d6 <print_mem_block_lists+0x184>
  8029c6:	83 ec 0c             	sub    $0xc,%esp
  8029c9:	68 8c 4c 80 00       	push   $0x804c8c
  8029ce:	e8 68 e5 ff ff       	call   800f3b <cprintf>
  8029d3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029d6:	83 ec 0c             	sub    $0xc,%esp
  8029d9:	68 00 4c 80 00       	push   $0x804c00
  8029de:	e8 58 e5 ff ff       	call   800f3b <cprintf>
  8029e3:	83 c4 10             	add    $0x10,%esp

}
  8029e6:	90                   	nop
  8029e7:	c9                   	leave  
  8029e8:	c3                   	ret    

008029e9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029e9:	55                   	push   %ebp
  8029ea:	89 e5                	mov    %esp,%ebp
  8029ec:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8029ef:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029f6:	00 00 00 
  8029f9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a00:	00 00 00 
  802a03:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a0a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802a0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a14:	e9 9e 00 00 00       	jmp    802ab7 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802a19:	a1 50 50 80 00       	mov    0x805050,%eax
  802a1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a21:	c1 e2 04             	shl    $0x4,%edx
  802a24:	01 d0                	add    %edx,%eax
  802a26:	85 c0                	test   %eax,%eax
  802a28:	75 14                	jne    802a3e <initialize_MemBlocksList+0x55>
  802a2a:	83 ec 04             	sub    $0x4,%esp
  802a2d:	68 b4 4c 80 00       	push   $0x804cb4
  802a32:	6a 46                	push   $0x46
  802a34:	68 d7 4c 80 00       	push   $0x804cd7
  802a39:	e8 49 e2 ff ff       	call   800c87 <_panic>
  802a3e:	a1 50 50 80 00       	mov    0x805050,%eax
  802a43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a46:	c1 e2 04             	shl    $0x4,%edx
  802a49:	01 d0                	add    %edx,%eax
  802a4b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a51:	89 10                	mov    %edx,(%eax)
  802a53:	8b 00                	mov    (%eax),%eax
  802a55:	85 c0                	test   %eax,%eax
  802a57:	74 18                	je     802a71 <initialize_MemBlocksList+0x88>
  802a59:	a1 48 51 80 00       	mov    0x805148,%eax
  802a5e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a64:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a67:	c1 e1 04             	shl    $0x4,%ecx
  802a6a:	01 ca                	add    %ecx,%edx
  802a6c:	89 50 04             	mov    %edx,0x4(%eax)
  802a6f:	eb 12                	jmp    802a83 <initialize_MemBlocksList+0x9a>
  802a71:	a1 50 50 80 00       	mov    0x805050,%eax
  802a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a79:	c1 e2 04             	shl    $0x4,%edx
  802a7c:	01 d0                	add    %edx,%eax
  802a7e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a83:	a1 50 50 80 00       	mov    0x805050,%eax
  802a88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8b:	c1 e2 04             	shl    $0x4,%edx
  802a8e:	01 d0                	add    %edx,%eax
  802a90:	a3 48 51 80 00       	mov    %eax,0x805148
  802a95:	a1 50 50 80 00       	mov    0x805050,%eax
  802a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9d:	c1 e2 04             	shl    $0x4,%edx
  802aa0:	01 d0                	add    %edx,%eax
  802aa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa9:	a1 54 51 80 00       	mov    0x805154,%eax
  802aae:	40                   	inc    %eax
  802aaf:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802ab4:	ff 45 f4             	incl   -0xc(%ebp)
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abd:	0f 82 56 ff ff ff    	jb     802a19 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802ac3:	90                   	nop
  802ac4:	c9                   	leave  
  802ac5:	c3                   	ret    

00802ac6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802ac6:	55                   	push   %ebp
  802ac7:	89 e5                	mov    %esp,%ebp
  802ac9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ad4:	eb 19                	jmp    802aef <find_block+0x29>
	{
		if(va==point->sva)
  802ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ad9:	8b 40 08             	mov    0x8(%eax),%eax
  802adc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802adf:	75 05                	jne    802ae6 <find_block+0x20>
		   return point;
  802ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ae4:	eb 36                	jmp    802b1c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 40 08             	mov    0x8(%eax),%eax
  802aec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802aef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802af3:	74 07                	je     802afc <find_block+0x36>
  802af5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802af8:	8b 00                	mov    (%eax),%eax
  802afa:	eb 05                	jmp    802b01 <find_block+0x3b>
  802afc:	b8 00 00 00 00       	mov    $0x0,%eax
  802b01:	8b 55 08             	mov    0x8(%ebp),%edx
  802b04:	89 42 08             	mov    %eax,0x8(%edx)
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	8b 40 08             	mov    0x8(%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	75 c5                	jne    802ad6 <find_block+0x10>
  802b11:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b15:	75 bf                	jne    802ad6 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b1c:	c9                   	leave  
  802b1d:	c3                   	ret    

00802b1e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b1e:	55                   	push   %ebp
  802b1f:	89 e5                	mov    %esp,%ebp
  802b21:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802b24:	a1 40 50 80 00       	mov    0x805040,%eax
  802b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802b2c:	a1 44 50 80 00       	mov    0x805044,%eax
  802b31:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b37:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b3a:	74 24                	je     802b60 <insert_sorted_allocList+0x42>
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	8b 50 08             	mov    0x8(%eax),%edx
  802b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b45:	8b 40 08             	mov    0x8(%eax),%eax
  802b48:	39 c2                	cmp    %eax,%edx
  802b4a:	76 14                	jbe    802b60 <insert_sorted_allocList+0x42>
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	8b 50 08             	mov    0x8(%eax),%edx
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	8b 40 08             	mov    0x8(%eax),%eax
  802b58:	39 c2                	cmp    %eax,%edx
  802b5a:	0f 82 60 01 00 00    	jb     802cc0 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802b60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b64:	75 65                	jne    802bcb <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b6a:	75 14                	jne    802b80 <insert_sorted_allocList+0x62>
  802b6c:	83 ec 04             	sub    $0x4,%esp
  802b6f:	68 b4 4c 80 00       	push   $0x804cb4
  802b74:	6a 6b                	push   $0x6b
  802b76:	68 d7 4c 80 00       	push   $0x804cd7
  802b7b:	e8 07 e1 ff ff       	call   800c87 <_panic>
  802b80:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	89 10                	mov    %edx,(%eax)
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	74 0d                	je     802ba1 <insert_sorted_allocList+0x83>
  802b94:	a1 40 50 80 00       	mov    0x805040,%eax
  802b99:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9c:	89 50 04             	mov    %edx,0x4(%eax)
  802b9f:	eb 08                	jmp    802ba9 <insert_sorted_allocList+0x8b>
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	a3 44 50 80 00       	mov    %eax,0x805044
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	a3 40 50 80 00       	mov    %eax,0x805040
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bc0:	40                   	inc    %eax
  802bc1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bc6:	e9 dc 01 00 00       	jmp    802da7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	8b 50 08             	mov    0x8(%eax),%edx
  802bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd4:	8b 40 08             	mov    0x8(%eax),%eax
  802bd7:	39 c2                	cmp    %eax,%edx
  802bd9:	77 6c                	ja     802c47 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802bdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bdf:	74 06                	je     802be7 <insert_sorted_allocList+0xc9>
  802be1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be5:	75 14                	jne    802bfb <insert_sorted_allocList+0xdd>
  802be7:	83 ec 04             	sub    $0x4,%esp
  802bea:	68 f0 4c 80 00       	push   $0x804cf0
  802bef:	6a 6f                	push   $0x6f
  802bf1:	68 d7 4c 80 00       	push   $0x804cd7
  802bf6:	e8 8c e0 ff ff       	call   800c87 <_panic>
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 50 04             	mov    0x4(%eax),%edx
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	89 50 04             	mov    %edx,0x4(%eax)
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c0d:	89 10                	mov    %edx,(%eax)
  802c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c12:	8b 40 04             	mov    0x4(%eax),%eax
  802c15:	85 c0                	test   %eax,%eax
  802c17:	74 0d                	je     802c26 <insert_sorted_allocList+0x108>
  802c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1c:	8b 40 04             	mov    0x4(%eax),%eax
  802c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c22:	89 10                	mov    %edx,(%eax)
  802c24:	eb 08                	jmp    802c2e <insert_sorted_allocList+0x110>
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	a3 40 50 80 00       	mov    %eax,0x805040
  802c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c31:	8b 55 08             	mov    0x8(%ebp),%edx
  802c34:	89 50 04             	mov    %edx,0x4(%eax)
  802c37:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c3c:	40                   	inc    %eax
  802c3d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c42:	e9 60 01 00 00       	jmp    802da7 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	8b 50 08             	mov    0x8(%eax),%edx
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 40 08             	mov    0x8(%eax),%eax
  802c53:	39 c2                	cmp    %eax,%edx
  802c55:	0f 82 4c 01 00 00    	jb     802da7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802c5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c5f:	75 14                	jne    802c75 <insert_sorted_allocList+0x157>
  802c61:	83 ec 04             	sub    $0x4,%esp
  802c64:	68 28 4d 80 00       	push   $0x804d28
  802c69:	6a 73                	push   $0x73
  802c6b:	68 d7 4c 80 00       	push   $0x804cd7
  802c70:	e8 12 e0 ff ff       	call   800c87 <_panic>
  802c75:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	89 50 04             	mov    %edx,0x4(%eax)
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	74 0c                	je     802c97 <insert_sorted_allocList+0x179>
  802c8b:	a1 44 50 80 00       	mov    0x805044,%eax
  802c90:	8b 55 08             	mov    0x8(%ebp),%edx
  802c93:	89 10                	mov    %edx,(%eax)
  802c95:	eb 08                	jmp    802c9f <insert_sorted_allocList+0x181>
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	a3 40 50 80 00       	mov    %eax,0x805040
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	a3 44 50 80 00       	mov    %eax,0x805044
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cb5:	40                   	inc    %eax
  802cb6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802cbb:	e9 e7 00 00 00       	jmp    802da7 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802cc6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802ccd:	a1 40 50 80 00       	mov    0x805040,%eax
  802cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd5:	e9 9d 00 00 00       	jmp    802d77 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 00                	mov    (%eax),%eax
  802cdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 50 08             	mov    0x8(%eax),%edx
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 40 08             	mov    0x8(%eax),%eax
  802cee:	39 c2                	cmp    %eax,%edx
  802cf0:	76 7d                	jbe    802d6f <insert_sorted_allocList+0x251>
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	8b 50 08             	mov    0x8(%eax),%edx
  802cf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfb:	8b 40 08             	mov    0x8(%eax),%eax
  802cfe:	39 c2                	cmp    %eax,%edx
  802d00:	73 6d                	jae    802d6f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d06:	74 06                	je     802d0e <insert_sorted_allocList+0x1f0>
  802d08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0c:	75 14                	jne    802d22 <insert_sorted_allocList+0x204>
  802d0e:	83 ec 04             	sub    $0x4,%esp
  802d11:	68 4c 4d 80 00       	push   $0x804d4c
  802d16:	6a 7f                	push   $0x7f
  802d18:	68 d7 4c 80 00       	push   $0x804cd7
  802d1d:	e8 65 df ff ff       	call   800c87 <_panic>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 10                	mov    (%eax),%edx
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	89 10                	mov    %edx,(%eax)
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	85 c0                	test   %eax,%eax
  802d33:	74 0b                	je     802d40 <insert_sorted_allocList+0x222>
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3d:	89 50 04             	mov    %edx,0x4(%eax)
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	8b 55 08             	mov    0x8(%ebp),%edx
  802d46:	89 10                	mov    %edx,(%eax)
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4e:	89 50 04             	mov    %edx,0x4(%eax)
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	8b 00                	mov    (%eax),%eax
  802d56:	85 c0                	test   %eax,%eax
  802d58:	75 08                	jne    802d62 <insert_sorted_allocList+0x244>
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	a3 44 50 80 00       	mov    %eax,0x805044
  802d62:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d67:	40                   	inc    %eax
  802d68:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802d6d:	eb 39                	jmp    802da8 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802d6f:	a1 48 50 80 00       	mov    0x805048,%eax
  802d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7b:	74 07                	je     802d84 <insert_sorted_allocList+0x266>
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	8b 00                	mov    (%eax),%eax
  802d82:	eb 05                	jmp    802d89 <insert_sorted_allocList+0x26b>
  802d84:	b8 00 00 00 00       	mov    $0x0,%eax
  802d89:	a3 48 50 80 00       	mov    %eax,0x805048
  802d8e:	a1 48 50 80 00       	mov    0x805048,%eax
  802d93:	85 c0                	test   %eax,%eax
  802d95:	0f 85 3f ff ff ff    	jne    802cda <insert_sorted_allocList+0x1bc>
  802d9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9f:	0f 85 35 ff ff ff    	jne    802cda <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802da5:	eb 01                	jmp    802da8 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802da7:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802da8:	90                   	nop
  802da9:	c9                   	leave  
  802daa:	c3                   	ret    

00802dab <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802dab:	55                   	push   %ebp
  802dac:	89 e5                	mov    %esp,%ebp
  802dae:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802db1:	a1 38 51 80 00       	mov    0x805138,%eax
  802db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db9:	e9 85 01 00 00       	jmp    802f43 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dc7:	0f 82 6e 01 00 00    	jb     802f3b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd6:	0f 85 8a 00 00 00    	jne    802e66 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de0:	75 17                	jne    802df9 <alloc_block_FF+0x4e>
  802de2:	83 ec 04             	sub    $0x4,%esp
  802de5:	68 80 4d 80 00       	push   $0x804d80
  802dea:	68 93 00 00 00       	push   $0x93
  802def:	68 d7 4c 80 00       	push   $0x804cd7
  802df4:	e8 8e de ff ff       	call   800c87 <_panic>
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 10                	je     802e12 <alloc_block_FF+0x67>
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0a:	8b 52 04             	mov    0x4(%edx),%edx
  802e0d:	89 50 04             	mov    %edx,0x4(%eax)
  802e10:	eb 0b                	jmp    802e1d <alloc_block_FF+0x72>
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 40 04             	mov    0x4(%eax),%eax
  802e18:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 0f                	je     802e36 <alloc_block_FF+0x8b>
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 40 04             	mov    0x4(%eax),%eax
  802e2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e30:	8b 12                	mov    (%edx),%edx
  802e32:	89 10                	mov    %edx,(%eax)
  802e34:	eb 0a                	jmp    802e40 <alloc_block_FF+0x95>
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	a3 38 51 80 00       	mov    %eax,0x805138
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e53:	a1 44 51 80 00       	mov    0x805144,%eax
  802e58:	48                   	dec    %eax
  802e59:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e61:	e9 10 01 00 00       	jmp    802f76 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6f:	0f 86 c6 00 00 00    	jbe    802f3b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e75:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 50 08             	mov    0x8(%eax),%edx
  802e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e86:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e96:	75 17                	jne    802eaf <alloc_block_FF+0x104>
  802e98:	83 ec 04             	sub    $0x4,%esp
  802e9b:	68 80 4d 80 00       	push   $0x804d80
  802ea0:	68 9b 00 00 00       	push   $0x9b
  802ea5:	68 d7 4c 80 00       	push   $0x804cd7
  802eaa:	e8 d8 dd ff ff       	call   800c87 <_panic>
  802eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb2:	8b 00                	mov    (%eax),%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	74 10                	je     802ec8 <alloc_block_FF+0x11d>
  802eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebb:	8b 00                	mov    (%eax),%eax
  802ebd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec0:	8b 52 04             	mov    0x4(%edx),%edx
  802ec3:	89 50 04             	mov    %edx,0x4(%eax)
  802ec6:	eb 0b                	jmp    802ed3 <alloc_block_FF+0x128>
  802ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecb:	8b 40 04             	mov    0x4(%eax),%eax
  802ece:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed6:	8b 40 04             	mov    0x4(%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 0f                	je     802eec <alloc_block_FF+0x141>
  802edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee0:	8b 40 04             	mov    0x4(%eax),%eax
  802ee3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee6:	8b 12                	mov    (%edx),%edx
  802ee8:	89 10                	mov    %edx,(%eax)
  802eea:	eb 0a                	jmp    802ef6 <alloc_block_FF+0x14b>
  802eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eef:	8b 00                	mov    (%eax),%eax
  802ef1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f09:	a1 54 51 80 00       	mov    0x805154,%eax
  802f0e:	48                   	dec    %eax
  802f0f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 50 08             	mov    0x8(%eax),%edx
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	01 c2                	add    %eax,%edx
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2b:	2b 45 08             	sub    0x8(%ebp),%eax
  802f2e:	89 c2                	mov    %eax,%edx
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f39:	eb 3b                	jmp    802f76 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802f3b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f47:	74 07                	je     802f50 <alloc_block_FF+0x1a5>
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	eb 05                	jmp    802f55 <alloc_block_FF+0x1aa>
  802f50:	b8 00 00 00 00       	mov    $0x0,%eax
  802f55:	a3 40 51 80 00       	mov    %eax,0x805140
  802f5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f5f:	85 c0                	test   %eax,%eax
  802f61:	0f 85 57 fe ff ff    	jne    802dbe <alloc_block_FF+0x13>
  802f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6b:	0f 85 4d fe ff ff    	jne    802dbe <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f76:	c9                   	leave  
  802f77:	c3                   	ret    

00802f78 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802f78:	55                   	push   %ebp
  802f79:	89 e5                	mov    %esp,%ebp
  802f7b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802f7e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802f85:	a1 38 51 80 00       	mov    0x805138,%eax
  802f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f8d:	e9 df 00 00 00       	jmp    803071 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	8b 40 0c             	mov    0xc(%eax),%eax
  802f98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f9b:	0f 82 c8 00 00 00    	jb     803069 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802faa:	0f 85 8a 00 00 00    	jne    80303a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802fb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb4:	75 17                	jne    802fcd <alloc_block_BF+0x55>
  802fb6:	83 ec 04             	sub    $0x4,%esp
  802fb9:	68 80 4d 80 00       	push   $0x804d80
  802fbe:	68 b7 00 00 00       	push   $0xb7
  802fc3:	68 d7 4c 80 00       	push   $0x804cd7
  802fc8:	e8 ba dc ff ff       	call   800c87 <_panic>
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	8b 00                	mov    (%eax),%eax
  802fd2:	85 c0                	test   %eax,%eax
  802fd4:	74 10                	je     802fe6 <alloc_block_BF+0x6e>
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	8b 00                	mov    (%eax),%eax
  802fdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fde:	8b 52 04             	mov    0x4(%edx),%edx
  802fe1:	89 50 04             	mov    %edx,0x4(%eax)
  802fe4:	eb 0b                	jmp    802ff1 <alloc_block_BF+0x79>
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 40 04             	mov    0x4(%eax),%eax
  802fec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	8b 40 04             	mov    0x4(%eax),%eax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	74 0f                	je     80300a <alloc_block_BF+0x92>
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 40 04             	mov    0x4(%eax),%eax
  803001:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803004:	8b 12                	mov    (%edx),%edx
  803006:	89 10                	mov    %edx,(%eax)
  803008:	eb 0a                	jmp    803014 <alloc_block_BF+0x9c>
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	a3 38 51 80 00       	mov    %eax,0x805138
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803027:	a1 44 51 80 00       	mov    0x805144,%eax
  80302c:	48                   	dec    %eax
  80302d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  803032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803035:	e9 4d 01 00 00       	jmp    803187 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 40 0c             	mov    0xc(%eax),%eax
  803040:	3b 45 08             	cmp    0x8(%ebp),%eax
  803043:	76 24                	jbe    803069 <alloc_block_BF+0xf1>
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	8b 40 0c             	mov    0xc(%eax),%eax
  80304b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80304e:	73 19                	jae    803069 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803050:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	8b 40 0c             	mov    0xc(%eax),%eax
  80305d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	8b 40 08             	mov    0x8(%eax),%eax
  803066:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803069:	a1 40 51 80 00       	mov    0x805140,%eax
  80306e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803075:	74 07                	je     80307e <alloc_block_BF+0x106>
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	eb 05                	jmp    803083 <alloc_block_BF+0x10b>
  80307e:	b8 00 00 00 00       	mov    $0x0,%eax
  803083:	a3 40 51 80 00       	mov    %eax,0x805140
  803088:	a1 40 51 80 00       	mov    0x805140,%eax
  80308d:	85 c0                	test   %eax,%eax
  80308f:	0f 85 fd fe ff ff    	jne    802f92 <alloc_block_BF+0x1a>
  803095:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803099:	0f 85 f3 fe ff ff    	jne    802f92 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80309f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030a3:	0f 84 d9 00 00 00    	je     803182 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8030b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030b7:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8030ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c0:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8030c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030c7:	75 17                	jne    8030e0 <alloc_block_BF+0x168>
  8030c9:	83 ec 04             	sub    $0x4,%esp
  8030cc:	68 80 4d 80 00       	push   $0x804d80
  8030d1:	68 c7 00 00 00       	push   $0xc7
  8030d6:	68 d7 4c 80 00       	push   $0x804cd7
  8030db:	e8 a7 db ff ff       	call   800c87 <_panic>
  8030e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e3:	8b 00                	mov    (%eax),%eax
  8030e5:	85 c0                	test   %eax,%eax
  8030e7:	74 10                	je     8030f9 <alloc_block_BF+0x181>
  8030e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ec:	8b 00                	mov    (%eax),%eax
  8030ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030f1:	8b 52 04             	mov    0x4(%edx),%edx
  8030f4:	89 50 04             	mov    %edx,0x4(%eax)
  8030f7:	eb 0b                	jmp    803104 <alloc_block_BF+0x18c>
  8030f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803104:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803107:	8b 40 04             	mov    0x4(%eax),%eax
  80310a:	85 c0                	test   %eax,%eax
  80310c:	74 0f                	je     80311d <alloc_block_BF+0x1a5>
  80310e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803111:	8b 40 04             	mov    0x4(%eax),%eax
  803114:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803117:	8b 12                	mov    (%edx),%edx
  803119:	89 10                	mov    %edx,(%eax)
  80311b:	eb 0a                	jmp    803127 <alloc_block_BF+0x1af>
  80311d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	a3 48 51 80 00       	mov    %eax,0x805148
  803127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803133:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313a:	a1 54 51 80 00       	mov    0x805154,%eax
  80313f:	48                   	dec    %eax
  803140:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803145:	83 ec 08             	sub    $0x8,%esp
  803148:	ff 75 ec             	pushl  -0x14(%ebp)
  80314b:	68 38 51 80 00       	push   $0x805138
  803150:	e8 71 f9 ff ff       	call   802ac6 <find_block>
  803155:	83 c4 10             	add    $0x10,%esp
  803158:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80315b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80315e:	8b 50 08             	mov    0x8(%eax),%edx
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	01 c2                	add    %eax,%edx
  803166:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803169:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80316c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80316f:	8b 40 0c             	mov    0xc(%eax),%eax
  803172:	2b 45 08             	sub    0x8(%ebp),%eax
  803175:	89 c2                	mov    %eax,%edx
  803177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80317a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80317d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803180:	eb 05                	jmp    803187 <alloc_block_BF+0x20f>
	}
	return NULL;
  803182:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803187:	c9                   	leave  
  803188:	c3                   	ret    

00803189 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803189:	55                   	push   %ebp
  80318a:	89 e5                	mov    %esp,%ebp
  80318c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80318f:	a1 28 50 80 00       	mov    0x805028,%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	0f 85 de 01 00 00    	jne    80337a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80319c:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a4:	e9 9e 01 00 00       	jmp    803347 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8031a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8031af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031b2:	0f 82 87 01 00 00    	jb     80333f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8031b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c1:	0f 85 95 00 00 00    	jne    80325c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8031c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031cb:	75 17                	jne    8031e4 <alloc_block_NF+0x5b>
  8031cd:	83 ec 04             	sub    $0x4,%esp
  8031d0:	68 80 4d 80 00       	push   $0x804d80
  8031d5:	68 e0 00 00 00       	push   $0xe0
  8031da:	68 d7 4c 80 00       	push   $0x804cd7
  8031df:	e8 a3 da ff ff       	call   800c87 <_panic>
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	85 c0                	test   %eax,%eax
  8031eb:	74 10                	je     8031fd <alloc_block_NF+0x74>
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	8b 00                	mov    (%eax),%eax
  8031f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f5:	8b 52 04             	mov    0x4(%edx),%edx
  8031f8:	89 50 04             	mov    %edx,0x4(%eax)
  8031fb:	eb 0b                	jmp    803208 <alloc_block_NF+0x7f>
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 40 04             	mov    0x4(%eax),%eax
  803203:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	8b 40 04             	mov    0x4(%eax),%eax
  80320e:	85 c0                	test   %eax,%eax
  803210:	74 0f                	je     803221 <alloc_block_NF+0x98>
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	8b 40 04             	mov    0x4(%eax),%eax
  803218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321b:	8b 12                	mov    (%edx),%edx
  80321d:	89 10                	mov    %edx,(%eax)
  80321f:	eb 0a                	jmp    80322b <alloc_block_NF+0xa2>
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	a3 38 51 80 00       	mov    %eax,0x805138
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323e:	a1 44 51 80 00       	mov    0x805144,%eax
  803243:	48                   	dec    %eax
  803244:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	8b 40 08             	mov    0x8(%eax),%eax
  80324f:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  803254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803257:	e9 f8 04 00 00       	jmp    803754 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 40 0c             	mov    0xc(%eax),%eax
  803262:	3b 45 08             	cmp    0x8(%ebp),%eax
  803265:	0f 86 d4 00 00 00    	jbe    80333f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80326b:	a1 48 51 80 00       	mov    0x805148,%eax
  803270:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803276:	8b 50 08             	mov    0x8(%eax),%edx
  803279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80327f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803282:	8b 55 08             	mov    0x8(%ebp),%edx
  803285:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80328c:	75 17                	jne    8032a5 <alloc_block_NF+0x11c>
  80328e:	83 ec 04             	sub    $0x4,%esp
  803291:	68 80 4d 80 00       	push   $0x804d80
  803296:	68 e9 00 00 00       	push   $0xe9
  80329b:	68 d7 4c 80 00       	push   $0x804cd7
  8032a0:	e8 e2 d9 ff ff       	call   800c87 <_panic>
  8032a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a8:	8b 00                	mov    (%eax),%eax
  8032aa:	85 c0                	test   %eax,%eax
  8032ac:	74 10                	je     8032be <alloc_block_NF+0x135>
  8032ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b1:	8b 00                	mov    (%eax),%eax
  8032b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032b6:	8b 52 04             	mov    0x4(%edx),%edx
  8032b9:	89 50 04             	mov    %edx,0x4(%eax)
  8032bc:	eb 0b                	jmp    8032c9 <alloc_block_NF+0x140>
  8032be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c1:	8b 40 04             	mov    0x4(%eax),%eax
  8032c4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cc:	8b 40 04             	mov    0x4(%eax),%eax
  8032cf:	85 c0                	test   %eax,%eax
  8032d1:	74 0f                	je     8032e2 <alloc_block_NF+0x159>
  8032d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d6:	8b 40 04             	mov    0x4(%eax),%eax
  8032d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032dc:	8b 12                	mov    (%edx),%edx
  8032de:	89 10                	mov    %edx,(%eax)
  8032e0:	eb 0a                	jmp    8032ec <alloc_block_NF+0x163>
  8032e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ff:	a1 54 51 80 00       	mov    0x805154,%eax
  803304:	48                   	dec    %eax
  803305:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80330a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330d:	8b 40 08             	mov    0x8(%eax),%eax
  803310:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 50 08             	mov    0x8(%eax),%edx
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	01 c2                	add    %eax,%edx
  803320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803323:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 40 0c             	mov    0xc(%eax),%eax
  80332c:	2b 45 08             	sub    0x8(%ebp),%eax
  80332f:	89 c2                	mov    %eax,%edx
  803331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803334:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333a:	e9 15 04 00 00       	jmp    803754 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80333f:	a1 40 51 80 00       	mov    0x805140,%eax
  803344:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803347:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334b:	74 07                	je     803354 <alloc_block_NF+0x1cb>
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	8b 00                	mov    (%eax),%eax
  803352:	eb 05                	jmp    803359 <alloc_block_NF+0x1d0>
  803354:	b8 00 00 00 00       	mov    $0x0,%eax
  803359:	a3 40 51 80 00       	mov    %eax,0x805140
  80335e:	a1 40 51 80 00       	mov    0x805140,%eax
  803363:	85 c0                	test   %eax,%eax
  803365:	0f 85 3e fe ff ff    	jne    8031a9 <alloc_block_NF+0x20>
  80336b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336f:	0f 85 34 fe ff ff    	jne    8031a9 <alloc_block_NF+0x20>
  803375:	e9 d5 03 00 00       	jmp    80374f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80337a:	a1 38 51 80 00       	mov    0x805138,%eax
  80337f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803382:	e9 b1 01 00 00       	jmp    803538 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338a:	8b 50 08             	mov    0x8(%eax),%edx
  80338d:	a1 28 50 80 00       	mov    0x805028,%eax
  803392:	39 c2                	cmp    %eax,%edx
  803394:	0f 82 96 01 00 00    	jb     803530 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033a3:	0f 82 87 01 00 00    	jb     803530 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8033af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033b2:	0f 85 95 00 00 00    	jne    80344d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8033b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033bc:	75 17                	jne    8033d5 <alloc_block_NF+0x24c>
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	68 80 4d 80 00       	push   $0x804d80
  8033c6:	68 fc 00 00 00       	push   $0xfc
  8033cb:	68 d7 4c 80 00       	push   $0x804cd7
  8033d0:	e8 b2 d8 ff ff       	call   800c87 <_panic>
  8033d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	85 c0                	test   %eax,%eax
  8033dc:	74 10                	je     8033ee <alloc_block_NF+0x265>
  8033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e1:	8b 00                	mov    (%eax),%eax
  8033e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e6:	8b 52 04             	mov    0x4(%edx),%edx
  8033e9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ec:	eb 0b                	jmp    8033f9 <alloc_block_NF+0x270>
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	8b 40 04             	mov    0x4(%eax),%eax
  8033f4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	8b 40 04             	mov    0x4(%eax),%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	74 0f                	je     803412 <alloc_block_NF+0x289>
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	8b 40 04             	mov    0x4(%eax),%eax
  803409:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80340c:	8b 12                	mov    (%edx),%edx
  80340e:	89 10                	mov    %edx,(%eax)
  803410:	eb 0a                	jmp    80341c <alloc_block_NF+0x293>
  803412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803415:	8b 00                	mov    (%eax),%eax
  803417:	a3 38 51 80 00       	mov    %eax,0x805138
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803428:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342f:	a1 44 51 80 00       	mov    0x805144,%eax
  803434:	48                   	dec    %eax
  803435:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343d:	8b 40 08             	mov    0x8(%eax),%eax
  803440:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	e9 07 03 00 00       	jmp    803754 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80344d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803450:	8b 40 0c             	mov    0xc(%eax),%eax
  803453:	3b 45 08             	cmp    0x8(%ebp),%eax
  803456:	0f 86 d4 00 00 00    	jbe    803530 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80345c:	a1 48 51 80 00       	mov    0x805148,%eax
  803461:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803467:	8b 50 08             	mov    0x8(%eax),%edx
  80346a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803473:	8b 55 08             	mov    0x8(%ebp),%edx
  803476:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803479:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80347d:	75 17                	jne    803496 <alloc_block_NF+0x30d>
  80347f:	83 ec 04             	sub    $0x4,%esp
  803482:	68 80 4d 80 00       	push   $0x804d80
  803487:	68 04 01 00 00       	push   $0x104
  80348c:	68 d7 4c 80 00       	push   $0x804cd7
  803491:	e8 f1 d7 ff ff       	call   800c87 <_panic>
  803496:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803499:	8b 00                	mov    (%eax),%eax
  80349b:	85 c0                	test   %eax,%eax
  80349d:	74 10                	je     8034af <alloc_block_NF+0x326>
  80349f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a2:	8b 00                	mov    (%eax),%eax
  8034a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a7:	8b 52 04             	mov    0x4(%edx),%edx
  8034aa:	89 50 04             	mov    %edx,0x4(%eax)
  8034ad:	eb 0b                	jmp    8034ba <alloc_block_NF+0x331>
  8034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b2:	8b 40 04             	mov    0x4(%eax),%eax
  8034b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bd:	8b 40 04             	mov    0x4(%eax),%eax
  8034c0:	85 c0                	test   %eax,%eax
  8034c2:	74 0f                	je     8034d3 <alloc_block_NF+0x34a>
  8034c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c7:	8b 40 04             	mov    0x4(%eax),%eax
  8034ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034cd:	8b 12                	mov    (%edx),%edx
  8034cf:	89 10                	mov    %edx,(%eax)
  8034d1:	eb 0a                	jmp    8034dd <alloc_block_NF+0x354>
  8034d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8034dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8034f5:	48                   	dec    %eax
  8034f6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8034fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fe:	8b 40 08             	mov    0x8(%eax),%eax
  803501:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 50 08             	mov    0x8(%eax),%edx
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	01 c2                	add    %eax,%edx
  803511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803514:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351a:	8b 40 0c             	mov    0xc(%eax),%eax
  80351d:	2b 45 08             	sub    0x8(%ebp),%eax
  803520:	89 c2                	mov    %eax,%edx
  803522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803525:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803528:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352b:	e9 24 02 00 00       	jmp    803754 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803530:	a1 40 51 80 00       	mov    0x805140,%eax
  803535:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353c:	74 07                	je     803545 <alloc_block_NF+0x3bc>
  80353e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803541:	8b 00                	mov    (%eax),%eax
  803543:	eb 05                	jmp    80354a <alloc_block_NF+0x3c1>
  803545:	b8 00 00 00 00       	mov    $0x0,%eax
  80354a:	a3 40 51 80 00       	mov    %eax,0x805140
  80354f:	a1 40 51 80 00       	mov    0x805140,%eax
  803554:	85 c0                	test   %eax,%eax
  803556:	0f 85 2b fe ff ff    	jne    803387 <alloc_block_NF+0x1fe>
  80355c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803560:	0f 85 21 fe ff ff    	jne    803387 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803566:	a1 38 51 80 00       	mov    0x805138,%eax
  80356b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80356e:	e9 ae 01 00 00       	jmp    803721 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803576:	8b 50 08             	mov    0x8(%eax),%edx
  803579:	a1 28 50 80 00       	mov    0x805028,%eax
  80357e:	39 c2                	cmp    %eax,%edx
  803580:	0f 83 93 01 00 00    	jae    803719 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	8b 40 0c             	mov    0xc(%eax),%eax
  80358c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80358f:	0f 82 84 01 00 00    	jb     803719 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803598:	8b 40 0c             	mov    0xc(%eax),%eax
  80359b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80359e:	0f 85 95 00 00 00    	jne    803639 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8035a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a8:	75 17                	jne    8035c1 <alloc_block_NF+0x438>
  8035aa:	83 ec 04             	sub    $0x4,%esp
  8035ad:	68 80 4d 80 00       	push   $0x804d80
  8035b2:	68 14 01 00 00       	push   $0x114
  8035b7:	68 d7 4c 80 00       	push   $0x804cd7
  8035bc:	e8 c6 d6 ff ff       	call   800c87 <_panic>
  8035c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c4:	8b 00                	mov    (%eax),%eax
  8035c6:	85 c0                	test   %eax,%eax
  8035c8:	74 10                	je     8035da <alloc_block_NF+0x451>
  8035ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cd:	8b 00                	mov    (%eax),%eax
  8035cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d2:	8b 52 04             	mov    0x4(%edx),%edx
  8035d5:	89 50 04             	mov    %edx,0x4(%eax)
  8035d8:	eb 0b                	jmp    8035e5 <alloc_block_NF+0x45c>
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	8b 40 04             	mov    0x4(%eax),%eax
  8035e0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e8:	8b 40 04             	mov    0x4(%eax),%eax
  8035eb:	85 c0                	test   %eax,%eax
  8035ed:	74 0f                	je     8035fe <alloc_block_NF+0x475>
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	8b 40 04             	mov    0x4(%eax),%eax
  8035f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f8:	8b 12                	mov    (%edx),%edx
  8035fa:	89 10                	mov    %edx,(%eax)
  8035fc:	eb 0a                	jmp    803608 <alloc_block_NF+0x47f>
  8035fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803601:	8b 00                	mov    (%eax),%eax
  803603:	a3 38 51 80 00       	mov    %eax,0x805138
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803614:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361b:	a1 44 51 80 00       	mov    0x805144,%eax
  803620:	48                   	dec    %eax
  803621:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803629:	8b 40 08             	mov    0x8(%eax),%eax
  80362c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803634:	e9 1b 01 00 00       	jmp    803754 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363c:	8b 40 0c             	mov    0xc(%eax),%eax
  80363f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803642:	0f 86 d1 00 00 00    	jbe    803719 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803648:	a1 48 51 80 00       	mov    0x805148,%eax
  80364d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803653:	8b 50 08             	mov    0x8(%eax),%edx
  803656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803659:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80365c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80365f:	8b 55 08             	mov    0x8(%ebp),%edx
  803662:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803665:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803669:	75 17                	jne    803682 <alloc_block_NF+0x4f9>
  80366b:	83 ec 04             	sub    $0x4,%esp
  80366e:	68 80 4d 80 00       	push   $0x804d80
  803673:	68 1c 01 00 00       	push   $0x11c
  803678:	68 d7 4c 80 00       	push   $0x804cd7
  80367d:	e8 05 d6 ff ff       	call   800c87 <_panic>
  803682:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803685:	8b 00                	mov    (%eax),%eax
  803687:	85 c0                	test   %eax,%eax
  803689:	74 10                	je     80369b <alloc_block_NF+0x512>
  80368b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80368e:	8b 00                	mov    (%eax),%eax
  803690:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803693:	8b 52 04             	mov    0x4(%edx),%edx
  803696:	89 50 04             	mov    %edx,0x4(%eax)
  803699:	eb 0b                	jmp    8036a6 <alloc_block_NF+0x51d>
  80369b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369e:	8b 40 04             	mov    0x4(%eax),%eax
  8036a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a9:	8b 40 04             	mov    0x4(%eax),%eax
  8036ac:	85 c0                	test   %eax,%eax
  8036ae:	74 0f                	je     8036bf <alloc_block_NF+0x536>
  8036b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b3:	8b 40 04             	mov    0x4(%eax),%eax
  8036b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036b9:	8b 12                	mov    (%edx),%edx
  8036bb:	89 10                	mov    %edx,(%eax)
  8036bd:	eb 0a                	jmp    8036c9 <alloc_block_NF+0x540>
  8036bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c2:	8b 00                	mov    (%eax),%eax
  8036c4:	a3 48 51 80 00       	mov    %eax,0x805148
  8036c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036dc:	a1 54 51 80 00       	mov    0x805154,%eax
  8036e1:	48                   	dec    %eax
  8036e2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8036e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ea:	8b 40 08             	mov    0x8(%eax),%eax
  8036ed:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f5:	8b 50 08             	mov    0x8(%eax),%edx
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fb:	01 c2                	add    %eax,%edx
  8036fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803700:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803706:	8b 40 0c             	mov    0xc(%eax),%eax
  803709:	2b 45 08             	sub    0x8(%ebp),%eax
  80370c:	89 c2                	mov    %eax,%edx
  80370e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803711:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803714:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803717:	eb 3b                	jmp    803754 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803719:	a1 40 51 80 00       	mov    0x805140,%eax
  80371e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803721:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803725:	74 07                	je     80372e <alloc_block_NF+0x5a5>
  803727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372a:	8b 00                	mov    (%eax),%eax
  80372c:	eb 05                	jmp    803733 <alloc_block_NF+0x5aa>
  80372e:	b8 00 00 00 00       	mov    $0x0,%eax
  803733:	a3 40 51 80 00       	mov    %eax,0x805140
  803738:	a1 40 51 80 00       	mov    0x805140,%eax
  80373d:	85 c0                	test   %eax,%eax
  80373f:	0f 85 2e fe ff ff    	jne    803573 <alloc_block_NF+0x3ea>
  803745:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803749:	0f 85 24 fe ff ff    	jne    803573 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80374f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803754:	c9                   	leave  
  803755:	c3                   	ret    

00803756 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803756:	55                   	push   %ebp
  803757:	89 e5                	mov    %esp,%ebp
  803759:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80375c:	a1 38 51 80 00       	mov    0x805138,%eax
  803761:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803764:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803769:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80376c:	a1 38 51 80 00       	mov    0x805138,%eax
  803771:	85 c0                	test   %eax,%eax
  803773:	74 14                	je     803789 <insert_sorted_with_merge_freeList+0x33>
  803775:	8b 45 08             	mov    0x8(%ebp),%eax
  803778:	8b 50 08             	mov    0x8(%eax),%edx
  80377b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377e:	8b 40 08             	mov    0x8(%eax),%eax
  803781:	39 c2                	cmp    %eax,%edx
  803783:	0f 87 9b 01 00 00    	ja     803924 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803789:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80378d:	75 17                	jne    8037a6 <insert_sorted_with_merge_freeList+0x50>
  80378f:	83 ec 04             	sub    $0x4,%esp
  803792:	68 b4 4c 80 00       	push   $0x804cb4
  803797:	68 38 01 00 00       	push   $0x138
  80379c:	68 d7 4c 80 00       	push   $0x804cd7
  8037a1:	e8 e1 d4 ff ff       	call   800c87 <_panic>
  8037a6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8037ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8037af:	89 10                	mov    %edx,(%eax)
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b4:	8b 00                	mov    (%eax),%eax
  8037b6:	85 c0                	test   %eax,%eax
  8037b8:	74 0d                	je     8037c7 <insert_sorted_with_merge_freeList+0x71>
  8037ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8037bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c2:	89 50 04             	mov    %edx,0x4(%eax)
  8037c5:	eb 08                	jmp    8037cf <insert_sorted_with_merge_freeList+0x79>
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8037d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8037e6:	40                   	inc    %eax
  8037e7:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037f0:	0f 84 a8 06 00 00    	je     803e9e <insert_sorted_with_merge_freeList+0x748>
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f9:	8b 50 08             	mov    0x8(%eax),%edx
  8037fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803802:	01 c2                	add    %eax,%edx
  803804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803807:	8b 40 08             	mov    0x8(%eax),%eax
  80380a:	39 c2                	cmp    %eax,%edx
  80380c:	0f 85 8c 06 00 00    	jne    803e9e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803812:	8b 45 08             	mov    0x8(%ebp),%eax
  803815:	8b 50 0c             	mov    0xc(%eax),%edx
  803818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381b:	8b 40 0c             	mov    0xc(%eax),%eax
  80381e:	01 c2                	add    %eax,%edx
  803820:	8b 45 08             	mov    0x8(%ebp),%eax
  803823:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803826:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80382a:	75 17                	jne    803843 <insert_sorted_with_merge_freeList+0xed>
  80382c:	83 ec 04             	sub    $0x4,%esp
  80382f:	68 80 4d 80 00       	push   $0x804d80
  803834:	68 3c 01 00 00       	push   $0x13c
  803839:	68 d7 4c 80 00       	push   $0x804cd7
  80383e:	e8 44 d4 ff ff       	call   800c87 <_panic>
  803843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803846:	8b 00                	mov    (%eax),%eax
  803848:	85 c0                	test   %eax,%eax
  80384a:	74 10                	je     80385c <insert_sorted_with_merge_freeList+0x106>
  80384c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384f:	8b 00                	mov    (%eax),%eax
  803851:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803854:	8b 52 04             	mov    0x4(%edx),%edx
  803857:	89 50 04             	mov    %edx,0x4(%eax)
  80385a:	eb 0b                	jmp    803867 <insert_sorted_with_merge_freeList+0x111>
  80385c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385f:	8b 40 04             	mov    0x4(%eax),%eax
  803862:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386a:	8b 40 04             	mov    0x4(%eax),%eax
  80386d:	85 c0                	test   %eax,%eax
  80386f:	74 0f                	je     803880 <insert_sorted_with_merge_freeList+0x12a>
  803871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803874:	8b 40 04             	mov    0x4(%eax),%eax
  803877:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80387a:	8b 12                	mov    (%edx),%edx
  80387c:	89 10                	mov    %edx,(%eax)
  80387e:	eb 0a                	jmp    80388a <insert_sorted_with_merge_freeList+0x134>
  803880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803883:	8b 00                	mov    (%eax),%eax
  803885:	a3 38 51 80 00       	mov    %eax,0x805138
  80388a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803896:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80389d:	a1 44 51 80 00       	mov    0x805144,%eax
  8038a2:	48                   	dec    %eax
  8038a3:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8038a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8038b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8038bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038c0:	75 17                	jne    8038d9 <insert_sorted_with_merge_freeList+0x183>
  8038c2:	83 ec 04             	sub    $0x4,%esp
  8038c5:	68 b4 4c 80 00       	push   $0x804cb4
  8038ca:	68 3f 01 00 00       	push   $0x13f
  8038cf:	68 d7 4c 80 00       	push   $0x804cd7
  8038d4:	e8 ae d3 ff ff       	call   800c87 <_panic>
  8038d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e2:	89 10                	mov    %edx,(%eax)
  8038e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e7:	8b 00                	mov    (%eax),%eax
  8038e9:	85 c0                	test   %eax,%eax
  8038eb:	74 0d                	je     8038fa <insert_sorted_with_merge_freeList+0x1a4>
  8038ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8038f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038f5:	89 50 04             	mov    %edx,0x4(%eax)
  8038f8:	eb 08                	jmp    803902 <insert_sorted_with_merge_freeList+0x1ac>
  8038fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803905:	a3 48 51 80 00       	mov    %eax,0x805148
  80390a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803914:	a1 54 51 80 00       	mov    0x805154,%eax
  803919:	40                   	inc    %eax
  80391a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80391f:	e9 7a 05 00 00       	jmp    803e9e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803924:	8b 45 08             	mov    0x8(%ebp),%eax
  803927:	8b 50 08             	mov    0x8(%eax),%edx
  80392a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80392d:	8b 40 08             	mov    0x8(%eax),%eax
  803930:	39 c2                	cmp    %eax,%edx
  803932:	0f 82 14 01 00 00    	jb     803a4c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80393b:	8b 50 08             	mov    0x8(%eax),%edx
  80393e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803941:	8b 40 0c             	mov    0xc(%eax),%eax
  803944:	01 c2                	add    %eax,%edx
  803946:	8b 45 08             	mov    0x8(%ebp),%eax
  803949:	8b 40 08             	mov    0x8(%eax),%eax
  80394c:	39 c2                	cmp    %eax,%edx
  80394e:	0f 85 90 00 00 00    	jne    8039e4 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803957:	8b 50 0c             	mov    0xc(%eax),%edx
  80395a:	8b 45 08             	mov    0x8(%ebp),%eax
  80395d:	8b 40 0c             	mov    0xc(%eax),%eax
  803960:	01 c2                	add    %eax,%edx
  803962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803965:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803968:	8b 45 08             	mov    0x8(%ebp),%eax
  80396b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803972:	8b 45 08             	mov    0x8(%ebp),%eax
  803975:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80397c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803980:	75 17                	jne    803999 <insert_sorted_with_merge_freeList+0x243>
  803982:	83 ec 04             	sub    $0x4,%esp
  803985:	68 b4 4c 80 00       	push   $0x804cb4
  80398a:	68 49 01 00 00       	push   $0x149
  80398f:	68 d7 4c 80 00       	push   $0x804cd7
  803994:	e8 ee d2 ff ff       	call   800c87 <_panic>
  803999:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80399f:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a2:	89 10                	mov    %edx,(%eax)
  8039a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	85 c0                	test   %eax,%eax
  8039ab:	74 0d                	je     8039ba <insert_sorted_with_merge_freeList+0x264>
  8039ad:	a1 48 51 80 00       	mov    0x805148,%eax
  8039b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8039b5:	89 50 04             	mov    %edx,0x4(%eax)
  8039b8:	eb 08                	jmp    8039c2 <insert_sorted_with_merge_freeList+0x26c>
  8039ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c5:	a3 48 51 80 00       	mov    %eax,0x805148
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8039d9:	40                   	inc    %eax
  8039da:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039df:	e9 bb 04 00 00       	jmp    803e9f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8039e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039e8:	75 17                	jne    803a01 <insert_sorted_with_merge_freeList+0x2ab>
  8039ea:	83 ec 04             	sub    $0x4,%esp
  8039ed:	68 28 4d 80 00       	push   $0x804d28
  8039f2:	68 4c 01 00 00       	push   $0x14c
  8039f7:	68 d7 4c 80 00       	push   $0x804cd7
  8039fc:	e8 86 d2 ff ff       	call   800c87 <_panic>
  803a01:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803a07:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0a:	89 50 04             	mov    %edx,0x4(%eax)
  803a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a10:	8b 40 04             	mov    0x4(%eax),%eax
  803a13:	85 c0                	test   %eax,%eax
  803a15:	74 0c                	je     803a23 <insert_sorted_with_merge_freeList+0x2cd>
  803a17:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803a1c:	8b 55 08             	mov    0x8(%ebp),%edx
  803a1f:	89 10                	mov    %edx,(%eax)
  803a21:	eb 08                	jmp    803a2b <insert_sorted_with_merge_freeList+0x2d5>
  803a23:	8b 45 08             	mov    0x8(%ebp),%eax
  803a26:	a3 38 51 80 00       	mov    %eax,0x805138
  803a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a33:	8b 45 08             	mov    0x8(%ebp),%eax
  803a36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a3c:	a1 44 51 80 00       	mov    0x805144,%eax
  803a41:	40                   	inc    %eax
  803a42:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a47:	e9 53 04 00 00       	jmp    803e9f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a4c:	a1 38 51 80 00       	mov    0x805138,%eax
  803a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a54:	e9 15 04 00 00       	jmp    803e6e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5c:	8b 00                	mov    (%eax),%eax
  803a5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803a61:	8b 45 08             	mov    0x8(%ebp),%eax
  803a64:	8b 50 08             	mov    0x8(%eax),%edx
  803a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6a:	8b 40 08             	mov    0x8(%eax),%eax
  803a6d:	39 c2                	cmp    %eax,%edx
  803a6f:	0f 86 f1 03 00 00    	jbe    803e66 <insert_sorted_with_merge_freeList+0x710>
  803a75:	8b 45 08             	mov    0x8(%ebp),%eax
  803a78:	8b 50 08             	mov    0x8(%eax),%edx
  803a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7e:	8b 40 08             	mov    0x8(%eax),%eax
  803a81:	39 c2                	cmp    %eax,%edx
  803a83:	0f 83 dd 03 00 00    	jae    803e66 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8c:	8b 50 08             	mov    0x8(%eax),%edx
  803a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a92:	8b 40 0c             	mov    0xc(%eax),%eax
  803a95:	01 c2                	add    %eax,%edx
  803a97:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9a:	8b 40 08             	mov    0x8(%eax),%eax
  803a9d:	39 c2                	cmp    %eax,%edx
  803a9f:	0f 85 b9 01 00 00    	jne    803c5e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa8:	8b 50 08             	mov    0x8(%eax),%edx
  803aab:	8b 45 08             	mov    0x8(%ebp),%eax
  803aae:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab1:	01 c2                	add    %eax,%edx
  803ab3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab6:	8b 40 08             	mov    0x8(%eax),%eax
  803ab9:	39 c2                	cmp    %eax,%edx
  803abb:	0f 85 0d 01 00 00    	jne    803bce <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac4:	8b 50 0c             	mov    0xc(%eax),%edx
  803ac7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aca:	8b 40 0c             	mov    0xc(%eax),%eax
  803acd:	01 c2                	add    %eax,%edx
  803acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad2:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803ad5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ad9:	75 17                	jne    803af2 <insert_sorted_with_merge_freeList+0x39c>
  803adb:	83 ec 04             	sub    $0x4,%esp
  803ade:	68 80 4d 80 00       	push   $0x804d80
  803ae3:	68 5c 01 00 00       	push   $0x15c
  803ae8:	68 d7 4c 80 00       	push   $0x804cd7
  803aed:	e8 95 d1 ff ff       	call   800c87 <_panic>
  803af2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af5:	8b 00                	mov    (%eax),%eax
  803af7:	85 c0                	test   %eax,%eax
  803af9:	74 10                	je     803b0b <insert_sorted_with_merge_freeList+0x3b5>
  803afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803afe:	8b 00                	mov    (%eax),%eax
  803b00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b03:	8b 52 04             	mov    0x4(%edx),%edx
  803b06:	89 50 04             	mov    %edx,0x4(%eax)
  803b09:	eb 0b                	jmp    803b16 <insert_sorted_with_merge_freeList+0x3c0>
  803b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0e:	8b 40 04             	mov    0x4(%eax),%eax
  803b11:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b19:	8b 40 04             	mov    0x4(%eax),%eax
  803b1c:	85 c0                	test   %eax,%eax
  803b1e:	74 0f                	je     803b2f <insert_sorted_with_merge_freeList+0x3d9>
  803b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b23:	8b 40 04             	mov    0x4(%eax),%eax
  803b26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b29:	8b 12                	mov    (%edx),%edx
  803b2b:	89 10                	mov    %edx,(%eax)
  803b2d:	eb 0a                	jmp    803b39 <insert_sorted_with_merge_freeList+0x3e3>
  803b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b32:	8b 00                	mov    (%eax),%eax
  803b34:	a3 38 51 80 00       	mov    %eax,0x805138
  803b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b4c:	a1 44 51 80 00       	mov    0x805144,%eax
  803b51:	48                   	dec    %eax
  803b52:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803b57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803b61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b64:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803b6b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b6f:	75 17                	jne    803b88 <insert_sorted_with_merge_freeList+0x432>
  803b71:	83 ec 04             	sub    $0x4,%esp
  803b74:	68 b4 4c 80 00       	push   $0x804cb4
  803b79:	68 5f 01 00 00       	push   $0x15f
  803b7e:	68 d7 4c 80 00       	push   $0x804cd7
  803b83:	e8 ff d0 ff ff       	call   800c87 <_panic>
  803b88:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b91:	89 10                	mov    %edx,(%eax)
  803b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b96:	8b 00                	mov    (%eax),%eax
  803b98:	85 c0                	test   %eax,%eax
  803b9a:	74 0d                	je     803ba9 <insert_sorted_with_merge_freeList+0x453>
  803b9c:	a1 48 51 80 00       	mov    0x805148,%eax
  803ba1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ba4:	89 50 04             	mov    %edx,0x4(%eax)
  803ba7:	eb 08                	jmp    803bb1 <insert_sorted_with_merge_freeList+0x45b>
  803ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803bb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb4:	a3 48 51 80 00       	mov    %eax,0x805148
  803bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bc3:	a1 54 51 80 00       	mov    0x805154,%eax
  803bc8:	40                   	inc    %eax
  803bc9:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd1:	8b 50 0c             	mov    0xc(%eax),%edx
  803bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd7:	8b 40 0c             	mov    0xc(%eax),%eax
  803bda:	01 c2                	add    %eax,%edx
  803bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdf:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803be2:	8b 45 08             	mov    0x8(%ebp),%eax
  803be5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803bec:	8b 45 08             	mov    0x8(%ebp),%eax
  803bef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803bf6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bfa:	75 17                	jne    803c13 <insert_sorted_with_merge_freeList+0x4bd>
  803bfc:	83 ec 04             	sub    $0x4,%esp
  803bff:	68 b4 4c 80 00       	push   $0x804cb4
  803c04:	68 64 01 00 00       	push   $0x164
  803c09:	68 d7 4c 80 00       	push   $0x804cd7
  803c0e:	e8 74 d0 ff ff       	call   800c87 <_panic>
  803c13:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c19:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1c:	89 10                	mov    %edx,(%eax)
  803c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c21:	8b 00                	mov    (%eax),%eax
  803c23:	85 c0                	test   %eax,%eax
  803c25:	74 0d                	je     803c34 <insert_sorted_with_merge_freeList+0x4de>
  803c27:	a1 48 51 80 00       	mov    0x805148,%eax
  803c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  803c2f:	89 50 04             	mov    %edx,0x4(%eax)
  803c32:	eb 08                	jmp    803c3c <insert_sorted_with_merge_freeList+0x4e6>
  803c34:	8b 45 08             	mov    0x8(%ebp),%eax
  803c37:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3f:	a3 48 51 80 00       	mov    %eax,0x805148
  803c44:	8b 45 08             	mov    0x8(%ebp),%eax
  803c47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c4e:	a1 54 51 80 00       	mov    0x805154,%eax
  803c53:	40                   	inc    %eax
  803c54:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c59:	e9 41 02 00 00       	jmp    803e9f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c61:	8b 50 08             	mov    0x8(%eax),%edx
  803c64:	8b 45 08             	mov    0x8(%ebp),%eax
  803c67:	8b 40 0c             	mov    0xc(%eax),%eax
  803c6a:	01 c2                	add    %eax,%edx
  803c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6f:	8b 40 08             	mov    0x8(%eax),%eax
  803c72:	39 c2                	cmp    %eax,%edx
  803c74:	0f 85 7c 01 00 00    	jne    803df6 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803c7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c7e:	74 06                	je     803c86 <insert_sorted_with_merge_freeList+0x530>
  803c80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c84:	75 17                	jne    803c9d <insert_sorted_with_merge_freeList+0x547>
  803c86:	83 ec 04             	sub    $0x4,%esp
  803c89:	68 f0 4c 80 00       	push   $0x804cf0
  803c8e:	68 69 01 00 00       	push   $0x169
  803c93:	68 d7 4c 80 00       	push   $0x804cd7
  803c98:	e8 ea cf ff ff       	call   800c87 <_panic>
  803c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca0:	8b 50 04             	mov    0x4(%eax),%edx
  803ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca6:	89 50 04             	mov    %edx,0x4(%eax)
  803ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803caf:	89 10                	mov    %edx,(%eax)
  803cb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cb4:	8b 40 04             	mov    0x4(%eax),%eax
  803cb7:	85 c0                	test   %eax,%eax
  803cb9:	74 0d                	je     803cc8 <insert_sorted_with_merge_freeList+0x572>
  803cbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cbe:	8b 40 04             	mov    0x4(%eax),%eax
  803cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  803cc4:	89 10                	mov    %edx,(%eax)
  803cc6:	eb 08                	jmp    803cd0 <insert_sorted_with_merge_freeList+0x57a>
  803cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccb:	a3 38 51 80 00       	mov    %eax,0x805138
  803cd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  803cd6:	89 50 04             	mov    %edx,0x4(%eax)
  803cd9:	a1 44 51 80 00       	mov    0x805144,%eax
  803cde:	40                   	inc    %eax
  803cdf:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce7:	8b 50 0c             	mov    0xc(%eax),%edx
  803cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ced:	8b 40 0c             	mov    0xc(%eax),%eax
  803cf0:	01 c2                	add    %eax,%edx
  803cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803cf8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cfc:	75 17                	jne    803d15 <insert_sorted_with_merge_freeList+0x5bf>
  803cfe:	83 ec 04             	sub    $0x4,%esp
  803d01:	68 80 4d 80 00       	push   $0x804d80
  803d06:	68 6b 01 00 00       	push   $0x16b
  803d0b:	68 d7 4c 80 00       	push   $0x804cd7
  803d10:	e8 72 cf ff ff       	call   800c87 <_panic>
  803d15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d18:	8b 00                	mov    (%eax),%eax
  803d1a:	85 c0                	test   %eax,%eax
  803d1c:	74 10                	je     803d2e <insert_sorted_with_merge_freeList+0x5d8>
  803d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d21:	8b 00                	mov    (%eax),%eax
  803d23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d26:	8b 52 04             	mov    0x4(%edx),%edx
  803d29:	89 50 04             	mov    %edx,0x4(%eax)
  803d2c:	eb 0b                	jmp    803d39 <insert_sorted_with_merge_freeList+0x5e3>
  803d2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d31:	8b 40 04             	mov    0x4(%eax),%eax
  803d34:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3c:	8b 40 04             	mov    0x4(%eax),%eax
  803d3f:	85 c0                	test   %eax,%eax
  803d41:	74 0f                	je     803d52 <insert_sorted_with_merge_freeList+0x5fc>
  803d43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d46:	8b 40 04             	mov    0x4(%eax),%eax
  803d49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d4c:	8b 12                	mov    (%edx),%edx
  803d4e:	89 10                	mov    %edx,(%eax)
  803d50:	eb 0a                	jmp    803d5c <insert_sorted_with_merge_freeList+0x606>
  803d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d55:	8b 00                	mov    (%eax),%eax
  803d57:	a3 38 51 80 00       	mov    %eax,0x805138
  803d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d6f:	a1 44 51 80 00       	mov    0x805144,%eax
  803d74:	48                   	dec    %eax
  803d75:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803d7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d7d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803d84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d87:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803d8e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d92:	75 17                	jne    803dab <insert_sorted_with_merge_freeList+0x655>
  803d94:	83 ec 04             	sub    $0x4,%esp
  803d97:	68 b4 4c 80 00       	push   $0x804cb4
  803d9c:	68 6e 01 00 00       	push   $0x16e
  803da1:	68 d7 4c 80 00       	push   $0x804cd7
  803da6:	e8 dc ce ff ff       	call   800c87 <_panic>
  803dab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803db4:	89 10                	mov    %edx,(%eax)
  803db6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803db9:	8b 00                	mov    (%eax),%eax
  803dbb:	85 c0                	test   %eax,%eax
  803dbd:	74 0d                	je     803dcc <insert_sorted_with_merge_freeList+0x676>
  803dbf:	a1 48 51 80 00       	mov    0x805148,%eax
  803dc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dc7:	89 50 04             	mov    %edx,0x4(%eax)
  803dca:	eb 08                	jmp    803dd4 <insert_sorted_with_merge_freeList+0x67e>
  803dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dcf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803dd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dd7:	a3 48 51 80 00       	mov    %eax,0x805148
  803ddc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ddf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803de6:	a1 54 51 80 00       	mov    0x805154,%eax
  803deb:	40                   	inc    %eax
  803dec:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803df1:	e9 a9 00 00 00       	jmp    803e9f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803df6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dfa:	74 06                	je     803e02 <insert_sorted_with_merge_freeList+0x6ac>
  803dfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e00:	75 17                	jne    803e19 <insert_sorted_with_merge_freeList+0x6c3>
  803e02:	83 ec 04             	sub    $0x4,%esp
  803e05:	68 4c 4d 80 00       	push   $0x804d4c
  803e0a:	68 73 01 00 00       	push   $0x173
  803e0f:	68 d7 4c 80 00       	push   $0x804cd7
  803e14:	e8 6e ce ff ff       	call   800c87 <_panic>
  803e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1c:	8b 10                	mov    (%eax),%edx
  803e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e21:	89 10                	mov    %edx,(%eax)
  803e23:	8b 45 08             	mov    0x8(%ebp),%eax
  803e26:	8b 00                	mov    (%eax),%eax
  803e28:	85 c0                	test   %eax,%eax
  803e2a:	74 0b                	je     803e37 <insert_sorted_with_merge_freeList+0x6e1>
  803e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2f:	8b 00                	mov    (%eax),%eax
  803e31:	8b 55 08             	mov    0x8(%ebp),%edx
  803e34:	89 50 04             	mov    %edx,0x4(%eax)
  803e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  803e3d:	89 10                	mov    %edx,(%eax)
  803e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e45:	89 50 04             	mov    %edx,0x4(%eax)
  803e48:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4b:	8b 00                	mov    (%eax),%eax
  803e4d:	85 c0                	test   %eax,%eax
  803e4f:	75 08                	jne    803e59 <insert_sorted_with_merge_freeList+0x703>
  803e51:	8b 45 08             	mov    0x8(%ebp),%eax
  803e54:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803e59:	a1 44 51 80 00       	mov    0x805144,%eax
  803e5e:	40                   	inc    %eax
  803e5f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803e64:	eb 39                	jmp    803e9f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803e66:	a1 40 51 80 00       	mov    0x805140,%eax
  803e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e72:	74 07                	je     803e7b <insert_sorted_with_merge_freeList+0x725>
  803e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e77:	8b 00                	mov    (%eax),%eax
  803e79:	eb 05                	jmp    803e80 <insert_sorted_with_merge_freeList+0x72a>
  803e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e80:	a3 40 51 80 00       	mov    %eax,0x805140
  803e85:	a1 40 51 80 00       	mov    0x805140,%eax
  803e8a:	85 c0                	test   %eax,%eax
  803e8c:	0f 85 c7 fb ff ff    	jne    803a59 <insert_sorted_with_merge_freeList+0x303>
  803e92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e96:	0f 85 bd fb ff ff    	jne    803a59 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e9c:	eb 01                	jmp    803e9f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803e9e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e9f:	90                   	nop
  803ea0:	c9                   	leave  
  803ea1:	c3                   	ret    

00803ea2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803ea2:	55                   	push   %ebp
  803ea3:	89 e5                	mov    %esp,%ebp
  803ea5:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  803eab:	89 d0                	mov    %edx,%eax
  803ead:	c1 e0 02             	shl    $0x2,%eax
  803eb0:	01 d0                	add    %edx,%eax
  803eb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803eb9:	01 d0                	add    %edx,%eax
  803ebb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ec2:	01 d0                	add    %edx,%eax
  803ec4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ecb:	01 d0                	add    %edx,%eax
  803ecd:	c1 e0 04             	shl    $0x4,%eax
  803ed0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803ed3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803eda:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803edd:	83 ec 0c             	sub    $0xc,%esp
  803ee0:	50                   	push   %eax
  803ee1:	e8 26 e7 ff ff       	call   80260c <sys_get_virtual_time>
  803ee6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803ee9:	eb 41                	jmp    803f2c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803eeb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803eee:	83 ec 0c             	sub    $0xc,%esp
  803ef1:	50                   	push   %eax
  803ef2:	e8 15 e7 ff ff       	call   80260c <sys_get_virtual_time>
  803ef7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803efa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f00:	29 c2                	sub    %eax,%edx
  803f02:	89 d0                	mov    %edx,%eax
  803f04:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803f07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f0d:	89 d1                	mov    %edx,%ecx
  803f0f:	29 c1                	sub    %eax,%ecx
  803f11:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f17:	39 c2                	cmp    %eax,%edx
  803f19:	0f 97 c0             	seta   %al
  803f1c:	0f b6 c0             	movzbl %al,%eax
  803f1f:	29 c1                	sub    %eax,%ecx
  803f21:	89 c8                	mov    %ecx,%eax
  803f23:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803f26:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803f32:	72 b7                	jb     803eeb <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803f34:	90                   	nop
  803f35:	c9                   	leave  
  803f36:	c3                   	ret    

00803f37 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803f37:	55                   	push   %ebp
  803f38:	89 e5                	mov    %esp,%ebp
  803f3a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803f3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803f44:	eb 03                	jmp    803f49 <busy_wait+0x12>
  803f46:	ff 45 fc             	incl   -0x4(%ebp)
  803f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f4f:	72 f5                	jb     803f46 <busy_wait+0xf>
	return i;
  803f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803f54:	c9                   	leave  
  803f55:	c3                   	ret    
  803f56:	66 90                	xchg   %ax,%ax

00803f58 <__udivdi3>:
  803f58:	55                   	push   %ebp
  803f59:	57                   	push   %edi
  803f5a:	56                   	push   %esi
  803f5b:	53                   	push   %ebx
  803f5c:	83 ec 1c             	sub    $0x1c,%esp
  803f5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f6f:	89 ca                	mov    %ecx,%edx
  803f71:	89 f8                	mov    %edi,%eax
  803f73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f77:	85 f6                	test   %esi,%esi
  803f79:	75 2d                	jne    803fa8 <__udivdi3+0x50>
  803f7b:	39 cf                	cmp    %ecx,%edi
  803f7d:	77 65                	ja     803fe4 <__udivdi3+0x8c>
  803f7f:	89 fd                	mov    %edi,%ebp
  803f81:	85 ff                	test   %edi,%edi
  803f83:	75 0b                	jne    803f90 <__udivdi3+0x38>
  803f85:	b8 01 00 00 00       	mov    $0x1,%eax
  803f8a:	31 d2                	xor    %edx,%edx
  803f8c:	f7 f7                	div    %edi
  803f8e:	89 c5                	mov    %eax,%ebp
  803f90:	31 d2                	xor    %edx,%edx
  803f92:	89 c8                	mov    %ecx,%eax
  803f94:	f7 f5                	div    %ebp
  803f96:	89 c1                	mov    %eax,%ecx
  803f98:	89 d8                	mov    %ebx,%eax
  803f9a:	f7 f5                	div    %ebp
  803f9c:	89 cf                	mov    %ecx,%edi
  803f9e:	89 fa                	mov    %edi,%edx
  803fa0:	83 c4 1c             	add    $0x1c,%esp
  803fa3:	5b                   	pop    %ebx
  803fa4:	5e                   	pop    %esi
  803fa5:	5f                   	pop    %edi
  803fa6:	5d                   	pop    %ebp
  803fa7:	c3                   	ret    
  803fa8:	39 ce                	cmp    %ecx,%esi
  803faa:	77 28                	ja     803fd4 <__udivdi3+0x7c>
  803fac:	0f bd fe             	bsr    %esi,%edi
  803faf:	83 f7 1f             	xor    $0x1f,%edi
  803fb2:	75 40                	jne    803ff4 <__udivdi3+0x9c>
  803fb4:	39 ce                	cmp    %ecx,%esi
  803fb6:	72 0a                	jb     803fc2 <__udivdi3+0x6a>
  803fb8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fbc:	0f 87 9e 00 00 00    	ja     804060 <__udivdi3+0x108>
  803fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803fc7:	89 fa                	mov    %edi,%edx
  803fc9:	83 c4 1c             	add    $0x1c,%esp
  803fcc:	5b                   	pop    %ebx
  803fcd:	5e                   	pop    %esi
  803fce:	5f                   	pop    %edi
  803fcf:	5d                   	pop    %ebp
  803fd0:	c3                   	ret    
  803fd1:	8d 76 00             	lea    0x0(%esi),%esi
  803fd4:	31 ff                	xor    %edi,%edi
  803fd6:	31 c0                	xor    %eax,%eax
  803fd8:	89 fa                	mov    %edi,%edx
  803fda:	83 c4 1c             	add    $0x1c,%esp
  803fdd:	5b                   	pop    %ebx
  803fde:	5e                   	pop    %esi
  803fdf:	5f                   	pop    %edi
  803fe0:	5d                   	pop    %ebp
  803fe1:	c3                   	ret    
  803fe2:	66 90                	xchg   %ax,%ax
  803fe4:	89 d8                	mov    %ebx,%eax
  803fe6:	f7 f7                	div    %edi
  803fe8:	31 ff                	xor    %edi,%edi
  803fea:	89 fa                	mov    %edi,%edx
  803fec:	83 c4 1c             	add    $0x1c,%esp
  803fef:	5b                   	pop    %ebx
  803ff0:	5e                   	pop    %esi
  803ff1:	5f                   	pop    %edi
  803ff2:	5d                   	pop    %ebp
  803ff3:	c3                   	ret    
  803ff4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ff9:	89 eb                	mov    %ebp,%ebx
  803ffb:	29 fb                	sub    %edi,%ebx
  803ffd:	89 f9                	mov    %edi,%ecx
  803fff:	d3 e6                	shl    %cl,%esi
  804001:	89 c5                	mov    %eax,%ebp
  804003:	88 d9                	mov    %bl,%cl
  804005:	d3 ed                	shr    %cl,%ebp
  804007:	89 e9                	mov    %ebp,%ecx
  804009:	09 f1                	or     %esi,%ecx
  80400b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80400f:	89 f9                	mov    %edi,%ecx
  804011:	d3 e0                	shl    %cl,%eax
  804013:	89 c5                	mov    %eax,%ebp
  804015:	89 d6                	mov    %edx,%esi
  804017:	88 d9                	mov    %bl,%cl
  804019:	d3 ee                	shr    %cl,%esi
  80401b:	89 f9                	mov    %edi,%ecx
  80401d:	d3 e2                	shl    %cl,%edx
  80401f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804023:	88 d9                	mov    %bl,%cl
  804025:	d3 e8                	shr    %cl,%eax
  804027:	09 c2                	or     %eax,%edx
  804029:	89 d0                	mov    %edx,%eax
  80402b:	89 f2                	mov    %esi,%edx
  80402d:	f7 74 24 0c          	divl   0xc(%esp)
  804031:	89 d6                	mov    %edx,%esi
  804033:	89 c3                	mov    %eax,%ebx
  804035:	f7 e5                	mul    %ebp
  804037:	39 d6                	cmp    %edx,%esi
  804039:	72 19                	jb     804054 <__udivdi3+0xfc>
  80403b:	74 0b                	je     804048 <__udivdi3+0xf0>
  80403d:	89 d8                	mov    %ebx,%eax
  80403f:	31 ff                	xor    %edi,%edi
  804041:	e9 58 ff ff ff       	jmp    803f9e <__udivdi3+0x46>
  804046:	66 90                	xchg   %ax,%ax
  804048:	8b 54 24 08          	mov    0x8(%esp),%edx
  80404c:	89 f9                	mov    %edi,%ecx
  80404e:	d3 e2                	shl    %cl,%edx
  804050:	39 c2                	cmp    %eax,%edx
  804052:	73 e9                	jae    80403d <__udivdi3+0xe5>
  804054:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804057:	31 ff                	xor    %edi,%edi
  804059:	e9 40 ff ff ff       	jmp    803f9e <__udivdi3+0x46>
  80405e:	66 90                	xchg   %ax,%ax
  804060:	31 c0                	xor    %eax,%eax
  804062:	e9 37 ff ff ff       	jmp    803f9e <__udivdi3+0x46>
  804067:	90                   	nop

00804068 <__umoddi3>:
  804068:	55                   	push   %ebp
  804069:	57                   	push   %edi
  80406a:	56                   	push   %esi
  80406b:	53                   	push   %ebx
  80406c:	83 ec 1c             	sub    $0x1c,%esp
  80406f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804073:	8b 74 24 34          	mov    0x34(%esp),%esi
  804077:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80407b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80407f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804083:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804087:	89 f3                	mov    %esi,%ebx
  804089:	89 fa                	mov    %edi,%edx
  80408b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80408f:	89 34 24             	mov    %esi,(%esp)
  804092:	85 c0                	test   %eax,%eax
  804094:	75 1a                	jne    8040b0 <__umoddi3+0x48>
  804096:	39 f7                	cmp    %esi,%edi
  804098:	0f 86 a2 00 00 00    	jbe    804140 <__umoddi3+0xd8>
  80409e:	89 c8                	mov    %ecx,%eax
  8040a0:	89 f2                	mov    %esi,%edx
  8040a2:	f7 f7                	div    %edi
  8040a4:	89 d0                	mov    %edx,%eax
  8040a6:	31 d2                	xor    %edx,%edx
  8040a8:	83 c4 1c             	add    $0x1c,%esp
  8040ab:	5b                   	pop    %ebx
  8040ac:	5e                   	pop    %esi
  8040ad:	5f                   	pop    %edi
  8040ae:	5d                   	pop    %ebp
  8040af:	c3                   	ret    
  8040b0:	39 f0                	cmp    %esi,%eax
  8040b2:	0f 87 ac 00 00 00    	ja     804164 <__umoddi3+0xfc>
  8040b8:	0f bd e8             	bsr    %eax,%ebp
  8040bb:	83 f5 1f             	xor    $0x1f,%ebp
  8040be:	0f 84 ac 00 00 00    	je     804170 <__umoddi3+0x108>
  8040c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8040c9:	29 ef                	sub    %ebp,%edi
  8040cb:	89 fe                	mov    %edi,%esi
  8040cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040d1:	89 e9                	mov    %ebp,%ecx
  8040d3:	d3 e0                	shl    %cl,%eax
  8040d5:	89 d7                	mov    %edx,%edi
  8040d7:	89 f1                	mov    %esi,%ecx
  8040d9:	d3 ef                	shr    %cl,%edi
  8040db:	09 c7                	or     %eax,%edi
  8040dd:	89 e9                	mov    %ebp,%ecx
  8040df:	d3 e2                	shl    %cl,%edx
  8040e1:	89 14 24             	mov    %edx,(%esp)
  8040e4:	89 d8                	mov    %ebx,%eax
  8040e6:	d3 e0                	shl    %cl,%eax
  8040e8:	89 c2                	mov    %eax,%edx
  8040ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040ee:	d3 e0                	shl    %cl,%eax
  8040f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040f8:	89 f1                	mov    %esi,%ecx
  8040fa:	d3 e8                	shr    %cl,%eax
  8040fc:	09 d0                	or     %edx,%eax
  8040fe:	d3 eb                	shr    %cl,%ebx
  804100:	89 da                	mov    %ebx,%edx
  804102:	f7 f7                	div    %edi
  804104:	89 d3                	mov    %edx,%ebx
  804106:	f7 24 24             	mull   (%esp)
  804109:	89 c6                	mov    %eax,%esi
  80410b:	89 d1                	mov    %edx,%ecx
  80410d:	39 d3                	cmp    %edx,%ebx
  80410f:	0f 82 87 00 00 00    	jb     80419c <__umoddi3+0x134>
  804115:	0f 84 91 00 00 00    	je     8041ac <__umoddi3+0x144>
  80411b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80411f:	29 f2                	sub    %esi,%edx
  804121:	19 cb                	sbb    %ecx,%ebx
  804123:	89 d8                	mov    %ebx,%eax
  804125:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804129:	d3 e0                	shl    %cl,%eax
  80412b:	89 e9                	mov    %ebp,%ecx
  80412d:	d3 ea                	shr    %cl,%edx
  80412f:	09 d0                	or     %edx,%eax
  804131:	89 e9                	mov    %ebp,%ecx
  804133:	d3 eb                	shr    %cl,%ebx
  804135:	89 da                	mov    %ebx,%edx
  804137:	83 c4 1c             	add    $0x1c,%esp
  80413a:	5b                   	pop    %ebx
  80413b:	5e                   	pop    %esi
  80413c:	5f                   	pop    %edi
  80413d:	5d                   	pop    %ebp
  80413e:	c3                   	ret    
  80413f:	90                   	nop
  804140:	89 fd                	mov    %edi,%ebp
  804142:	85 ff                	test   %edi,%edi
  804144:	75 0b                	jne    804151 <__umoddi3+0xe9>
  804146:	b8 01 00 00 00       	mov    $0x1,%eax
  80414b:	31 d2                	xor    %edx,%edx
  80414d:	f7 f7                	div    %edi
  80414f:	89 c5                	mov    %eax,%ebp
  804151:	89 f0                	mov    %esi,%eax
  804153:	31 d2                	xor    %edx,%edx
  804155:	f7 f5                	div    %ebp
  804157:	89 c8                	mov    %ecx,%eax
  804159:	f7 f5                	div    %ebp
  80415b:	89 d0                	mov    %edx,%eax
  80415d:	e9 44 ff ff ff       	jmp    8040a6 <__umoddi3+0x3e>
  804162:	66 90                	xchg   %ax,%ax
  804164:	89 c8                	mov    %ecx,%eax
  804166:	89 f2                	mov    %esi,%edx
  804168:	83 c4 1c             	add    $0x1c,%esp
  80416b:	5b                   	pop    %ebx
  80416c:	5e                   	pop    %esi
  80416d:	5f                   	pop    %edi
  80416e:	5d                   	pop    %ebp
  80416f:	c3                   	ret    
  804170:	3b 04 24             	cmp    (%esp),%eax
  804173:	72 06                	jb     80417b <__umoddi3+0x113>
  804175:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804179:	77 0f                	ja     80418a <__umoddi3+0x122>
  80417b:	89 f2                	mov    %esi,%edx
  80417d:	29 f9                	sub    %edi,%ecx
  80417f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804183:	89 14 24             	mov    %edx,(%esp)
  804186:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80418a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80418e:	8b 14 24             	mov    (%esp),%edx
  804191:	83 c4 1c             	add    $0x1c,%esp
  804194:	5b                   	pop    %ebx
  804195:	5e                   	pop    %esi
  804196:	5f                   	pop    %edi
  804197:	5d                   	pop    %ebp
  804198:	c3                   	ret    
  804199:	8d 76 00             	lea    0x0(%esi),%esi
  80419c:	2b 04 24             	sub    (%esp),%eax
  80419f:	19 fa                	sbb    %edi,%edx
  8041a1:	89 d1                	mov    %edx,%ecx
  8041a3:	89 c6                	mov    %eax,%esi
  8041a5:	e9 71 ff ff ff       	jmp    80411b <__umoddi3+0xb3>
  8041aa:	66 90                	xchg   %ax,%ax
  8041ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041b0:	72 ea                	jb     80419c <__umoddi3+0x134>
  8041b2:	89 d9                	mov    %ebx,%ecx
  8041b4:	e9 62 ff ff ff       	jmp    80411b <__umoddi3+0xb3>
