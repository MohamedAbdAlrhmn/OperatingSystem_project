
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
  800044:	e8 a8 24 00 00       	call   8024f1 <sys_getenvid>
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
  80007c:	bb f6 43 80 00       	mov    $0x8043f6,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb 00 44 80 00       	mov    $0x804400,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb 0c 44 80 00       	mov    $0x80440c,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb 1b 44 80 00       	mov    $0x80441b,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb 2a 44 80 00       	mov    $0x80442a,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb 3f 44 80 00       	mov    $0x80443f,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb 54 44 80 00       	mov    $0x804454,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb 65 44 80 00       	mov    $0x804465,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb 76 44 80 00       	mov    $0x804476,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb 87 44 80 00       	mov    $0x804487,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb 90 44 80 00       	mov    $0x804490,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb 9a 44 80 00       	mov    $0x80449a,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb a5 44 80 00       	mov    $0x8044a5,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb b1 44 80 00       	mov    $0x8044b1,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb bb 44 80 00       	mov    $0x8044bb,%ebx
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
  8001f7:	bb c5 44 80 00       	mov    $0x8044c5,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb d3 44 80 00       	mov    $0x8044d3,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb e2 44 80 00       	mov    $0x8044e2,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb e9 44 80 00       	mov    $0x8044e9,%ebx
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
  800492:	e8 f4 1e 00 00       	call   80238b <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 e0 1e 00 00       	call   80238b <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 cc 1e 00 00       	call   80238b <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 b8 1e 00 00       	call   80238b <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 a4 1e 00 00       	call   80238b <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 90 1e 00 00       	call   80238b <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 7c 1e 00 00       	call   80238b <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb f0 44 80 00       	mov    $0x8044f0,%ebx
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
  80058f:	e8 f7 1d 00 00       	call   80238b <sys_createSemaphore>
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
  8005cc:	e8 cb 1e 00 00       	call   80249c <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 d1 1e 00 00       	call   8024ba <sys_run_env>
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
  800616:	e8 81 1e 00 00       	call   80249c <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 87 1e 00 00       	call   8024ba <sys_run_env>
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
  800660:	e8 37 1e 00 00       	call   80249c <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 3d 1e 00 00       	call   8024ba <sys_run_env>
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
  8006b3:	e8 e4 1d 00 00       	call   80249c <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 20 41 80 00       	push   $0x804120
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 66 41 80 00       	push   $0x804166
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 ca 1d 00 00       	call   8024ba <sys_run_env>
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
  800714:	e8 ab 1c 00 00       	call   8023c4 <sys_waitSemaphore>
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
  80072f:	e8 b8 36 00 00       	call   803dec <env_sleep>
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
  800775:	68 78 41 80 00       	push   $0x804178
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
  8007cd:	68 a8 41 80 00       	push   $0x8041a8
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
  80080c:	68 d8 41 80 00       	push   $0x8041d8
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 66 41 80 00       	push   $0x804166
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
  80084f:	68 d8 41 80 00       	push   $0x8041d8
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 66 41 80 00       	push   $0x804166
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
  8008b0:	68 d8 41 80 00       	push   $0x8041d8
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 66 41 80 00       	push   $0x804166
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
  8008e1:	e8 c1 1a 00 00       	call   8023a7 <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 fc 41 80 00       	push   $0x8041fc
  8008f3:	68 2a 42 80 00       	push   $0x80422a
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 66 41 80 00       	push   $0x804166
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 8e 1a 00 00       	call   8023a7 <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 40 42 80 00       	push   $0x804240
  800926:	68 2a 42 80 00       	push   $0x80422a
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 66 41 80 00       	push   $0x804166
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 5b 1a 00 00       	call   8023a7 <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 70 42 80 00       	push   $0x804270
  800959:	68 2a 42 80 00       	push   $0x80422a
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 66 41 80 00       	push   $0x804166
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 28 1a 00 00       	call   8023a7 <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 a4 42 80 00       	push   $0x8042a4
  80098c:	68 2a 42 80 00       	push   $0x80422a
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 66 41 80 00       	push   $0x804166
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 f5 19 00 00       	call   8023a7 <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 d4 42 80 00       	push   $0x8042d4
  8009bf:	68 2a 42 80 00       	push   $0x80422a
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 66 41 80 00       	push   $0x804166
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 c2 19 00 00       	call   8023a7 <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 00 43 80 00       	push   $0x804300
  8009f2:	68 2a 42 80 00       	push   $0x80422a
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 66 41 80 00       	push   $0x804166
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 8f 19 00 00       	call   8023a7 <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 30 43 80 00       	push   $0x804330
  800a24:	68 2a 42 80 00       	push   $0x80422a
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 66 41 80 00       	push   $0x804166
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb f0 44 80 00       	mov    $0x8044f0,%ebx
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
  800ab9:	e8 e9 18 00 00       	call   8023a7 <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 64 43 80 00       	push   $0x804364
  800aca:	68 2a 42 80 00       	push   $0x80422a
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 66 41 80 00       	push   $0x804166
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
  800af0:	68 a4 43 80 00       	push   $0x8043a4
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
  800b51:	e8 b4 19 00 00       	call   80250a <sys_getenvindex>
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
  800bbc:	e8 56 17 00 00       	call   802317 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 28 45 80 00       	push   $0x804528
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
  800bec:	68 50 45 80 00       	push   $0x804550
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
  800c1d:	68 78 45 80 00       	push   $0x804578
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 d0 45 80 00       	push   $0x8045d0
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 28 45 80 00       	push   $0x804528
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 d6 16 00 00       	call   802331 <sys_enable_interrupt>

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
  800c6e:	e8 63 18 00 00       	call   8024d6 <sys_destroy_env>
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
  800c7f:	e8 b8 18 00 00       	call   80253c <sys_exit_env>
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
  800ca8:	68 e4 45 80 00       	push   $0x8045e4
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 e9 45 80 00       	push   $0x8045e9
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
  800ce5:	68 05 46 80 00       	push   $0x804605
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
  800d11:	68 08 46 80 00       	push   $0x804608
  800d16:	6a 26                	push   $0x26
  800d18:	68 54 46 80 00       	push   $0x804654
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
  800de3:	68 60 46 80 00       	push   $0x804660
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 54 46 80 00       	push   $0x804654
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
  800e53:	68 b4 46 80 00       	push   $0x8046b4
  800e58:	6a 44                	push   $0x44
  800e5a:	68 54 46 80 00       	push   $0x804654
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
  800ead:	e8 b7 12 00 00       	call   802169 <sys_cputs>
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
  800f24:	e8 40 12 00 00       	call   802169 <sys_cputs>
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
  800f6e:	e8 a4 13 00 00       	call   802317 <sys_disable_interrupt>
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
  800f8e:	e8 9e 13 00 00       	call   802331 <sys_enable_interrupt>
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
  800fd8:	e8 c3 2e 00 00       	call   803ea0 <__udivdi3>
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
  801028:	e8 83 2f 00 00       	call   803fb0 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 14 49 80 00       	add    $0x804914,%eax
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
  801183:	8b 04 85 38 49 80 00 	mov    0x804938(,%eax,4),%eax
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
  801264:	8b 34 9d 80 47 80 00 	mov    0x804780(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 25 49 80 00       	push   $0x804925
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
  801289:	68 2e 49 80 00       	push   $0x80492e
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
  8012b6:	be 31 49 80 00       	mov    $0x804931,%esi
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
  801cdc:	68 90 4a 80 00       	push   $0x804a90
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
  801dac:	e8 fc 04 00 00       	call   8022ad <sys_allocate_chunk>
  801db1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801db4:	a1 20 51 80 00       	mov    0x805120,%eax
  801db9:	83 ec 0c             	sub    $0xc,%esp
  801dbc:	50                   	push   %eax
  801dbd:	e8 71 0b 00 00       	call   802933 <initialize_MemBlocksList>
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
  801dea:	68 b5 4a 80 00       	push   $0x804ab5
  801def:	6a 33                	push   $0x33
  801df1:	68 d3 4a 80 00       	push   $0x804ad3
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
  801e69:	68 e0 4a 80 00       	push   $0x804ae0
  801e6e:	6a 34                	push   $0x34
  801e70:	68 d3 4a 80 00       	push   $0x804ad3
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
  801f01:	e8 75 07 00 00       	call   80267b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f06:	85 c0                	test   %eax,%eax
  801f08:	74 11                	je     801f1b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	ff 75 e8             	pushl  -0x18(%ebp)
  801f10:	e8 e0 0d 00 00       	call   802cf5 <alloc_block_FF>
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
  801f27:	e8 3c 0b 00 00       	call   802a68 <insert_sorted_allocList>
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
  801f47:	68 04 4b 80 00       	push   $0x804b04
  801f4c:	6a 6f                	push   $0x6f
  801f4e:	68 d3 4a 80 00       	push   $0x804ad3
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
  801f6d:	75 0a                	jne    801f79 <smalloc+0x21>
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	e9 8b 00 00 00       	jmp    802004 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f79:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f86:	01 d0                	add    %edx,%eax
  801f88:	48                   	dec    %eax
  801f89:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f94:	f7 75 f0             	divl   -0x10(%ebp)
  801f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9a:	29 d0                	sub    %edx,%eax
  801f9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801f9f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801fa6:	e8 d0 06 00 00       	call   80267b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fab:	85 c0                	test   %eax,%eax
  801fad:	74 11                	je     801fc0 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	ff 75 e8             	pushl  -0x18(%ebp)
  801fb5:	e8 3b 0d 00 00       	call   802cf5 <alloc_block_FF>
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801fc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc4:	74 39                	je     801fff <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	8b 40 08             	mov    0x8(%eax),%eax
  801fcc:	89 c2                	mov    %eax,%edx
  801fce:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fd2:	52                   	push   %edx
  801fd3:	50                   	push   %eax
  801fd4:	ff 75 0c             	pushl  0xc(%ebp)
  801fd7:	ff 75 08             	pushl  0x8(%ebp)
  801fda:	e8 21 04 00 00       	call   802400 <sys_createSharedObject>
  801fdf:	83 c4 10             	add    $0x10,%esp
  801fe2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801fe5:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801fe9:	74 14                	je     801fff <smalloc+0xa7>
  801feb:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801fef:	74 0e                	je     801fff <smalloc+0xa7>
  801ff1:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801ff5:	74 08                	je     801fff <smalloc+0xa7>
			return (void*) mem_block->sva;
  801ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffa:	8b 40 08             	mov    0x8(%eax),%eax
  801ffd:	eb 05                	jmp    802004 <smalloc+0xac>
	}
	return NULL;
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80200c:	e8 b4 fc ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802011:	83 ec 08             	sub    $0x8,%esp
  802014:	ff 75 0c             	pushl  0xc(%ebp)
  802017:	ff 75 08             	pushl  0x8(%ebp)
  80201a:	e8 0b 04 00 00       	call   80242a <sys_getSizeOfSharedObject>
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  802025:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  802029:	74 76                	je     8020a1 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80202b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802032:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802035:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802038:	01 d0                	add    %edx,%eax
  80203a:	48                   	dec    %eax
  80203b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80203e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802041:	ba 00 00 00 00       	mov    $0x0,%edx
  802046:	f7 75 ec             	divl   -0x14(%ebp)
  802049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80204c:	29 d0                	sub    %edx,%eax
  80204e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  802051:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802058:	e8 1e 06 00 00       	call   80267b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80205d:	85 c0                	test   %eax,%eax
  80205f:	74 11                	je     802072 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  802061:	83 ec 0c             	sub    $0xc,%esp
  802064:	ff 75 e4             	pushl  -0x1c(%ebp)
  802067:	e8 89 0c 00 00       	call   802cf5 <alloc_block_FF>
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  802072:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802076:	74 29                	je     8020a1 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	8b 40 08             	mov    0x8(%eax),%eax
  80207e:	83 ec 04             	sub    $0x4,%esp
  802081:	50                   	push   %eax
  802082:	ff 75 0c             	pushl  0xc(%ebp)
  802085:	ff 75 08             	pushl  0x8(%ebp)
  802088:	e8 ba 03 00 00       	call   802447 <sys_getSharedObject>
  80208d:	83 c4 10             	add    $0x10,%esp
  802090:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  802093:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  802097:	74 08                	je     8020a1 <sget+0x9b>
				return (void *)mem_block->sva;
  802099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209c:	8b 40 08             	mov    0x8(%eax),%eax
  80209f:	eb 05                	jmp    8020a6 <sget+0xa0>
		}
	}
	return (void *)NULL;
  8020a1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020ae:	e8 12 fc ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020b3:	83 ec 04             	sub    $0x4,%esp
  8020b6:	68 28 4b 80 00       	push   $0x804b28
  8020bb:	68 f1 00 00 00       	push   $0xf1
  8020c0:	68 d3 4a 80 00       	push   $0x804ad3
  8020c5:	e8 bd eb ff ff       	call   800c87 <_panic>

008020ca <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020d0:	83 ec 04             	sub    $0x4,%esp
  8020d3:	68 50 4b 80 00       	push   $0x804b50
  8020d8:	68 05 01 00 00       	push   $0x105
  8020dd:	68 d3 4a 80 00       	push   $0x804ad3
  8020e2:	e8 a0 eb ff ff       	call   800c87 <_panic>

008020e7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020ed:	83 ec 04             	sub    $0x4,%esp
  8020f0:	68 74 4b 80 00       	push   $0x804b74
  8020f5:	68 10 01 00 00       	push   $0x110
  8020fa:	68 d3 4a 80 00       	push   $0x804ad3
  8020ff:	e8 83 eb ff ff       	call   800c87 <_panic>

00802104 <shrink>:

}
void shrink(uint32 newSize)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80210a:	83 ec 04             	sub    $0x4,%esp
  80210d:	68 74 4b 80 00       	push   $0x804b74
  802112:	68 15 01 00 00       	push   $0x115
  802117:	68 d3 4a 80 00       	push   $0x804ad3
  80211c:	e8 66 eb ff ff       	call   800c87 <_panic>

00802121 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	68 74 4b 80 00       	push   $0x804b74
  80212f:	68 1a 01 00 00       	push   $0x11a
  802134:	68 d3 4a 80 00       	push   $0x804ad3
  802139:	e8 49 eb ff ff       	call   800c87 <_panic>

0080213e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	57                   	push   %edi
  802142:	56                   	push   %esi
  802143:	53                   	push   %ebx
  802144:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802150:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802153:	8b 7d 18             	mov    0x18(%ebp),%edi
  802156:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802159:	cd 30                	int    $0x30
  80215b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80215e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802161:	83 c4 10             	add    $0x10,%esp
  802164:	5b                   	pop    %ebx
  802165:	5e                   	pop    %esi
  802166:	5f                   	pop    %edi
  802167:	5d                   	pop    %ebp
  802168:	c3                   	ret    

00802169 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	83 ec 04             	sub    $0x4,%esp
  80216f:	8b 45 10             	mov    0x10(%ebp),%eax
  802172:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802175:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	52                   	push   %edx
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	50                   	push   %eax
  802185:	6a 00                	push   $0x0
  802187:	e8 b2 ff ff ff       	call   80213e <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	90                   	nop
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_cgetc>:

int
sys_cgetc(void)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 01                	push   $0x1
  8021a1:	e8 98 ff ff ff       	call   80213e <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	52                   	push   %edx
  8021bb:	50                   	push   %eax
  8021bc:	6a 05                	push   $0x5
  8021be:	e8 7b ff ff ff       	call   80213e <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	56                   	push   %esi
  8021cc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8021d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	56                   	push   %esi
  8021dd:	53                   	push   %ebx
  8021de:	51                   	push   %ecx
  8021df:	52                   	push   %edx
  8021e0:	50                   	push   %eax
  8021e1:	6a 06                	push   $0x6
  8021e3:	e8 56 ff ff ff       	call   80213e <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
}
  8021eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ee:	5b                   	pop    %ebx
  8021ef:	5e                   	pop    %esi
  8021f0:	5d                   	pop    %ebp
  8021f1:	c3                   	ret    

008021f2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	52                   	push   %edx
  802202:	50                   	push   %eax
  802203:	6a 07                	push   $0x7
  802205:	e8 34 ff ff ff       	call   80213e <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	ff 75 0c             	pushl  0xc(%ebp)
  80221b:	ff 75 08             	pushl  0x8(%ebp)
  80221e:	6a 08                	push   $0x8
  802220:	e8 19 ff ff ff       	call   80213e <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 09                	push   $0x9
  802239:	e8 00 ff ff ff       	call   80213e <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 0a                	push   $0xa
  802252:	e8 e7 fe ff ff       	call   80213e <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 0b                	push   $0xb
  80226b:	e8 ce fe ff ff       	call   80213e <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	ff 75 0c             	pushl  0xc(%ebp)
  802281:	ff 75 08             	pushl  0x8(%ebp)
  802284:	6a 0f                	push   $0xf
  802286:	e8 b3 fe ff ff       	call   80213e <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
	return;
  80228e:	90                   	nop
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	ff 75 0c             	pushl  0xc(%ebp)
  80229d:	ff 75 08             	pushl  0x8(%ebp)
  8022a0:	6a 10                	push   $0x10
  8022a2:	e8 97 fe ff ff       	call   80213e <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022aa:	90                   	nop
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	ff 75 10             	pushl  0x10(%ebp)
  8022b7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ba:	ff 75 08             	pushl  0x8(%ebp)
  8022bd:	6a 11                	push   $0x11
  8022bf:	e8 7a fe ff ff       	call   80213e <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c7:	90                   	nop
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 0c                	push   $0xc
  8022d9:	e8 60 fe ff ff       	call   80213e <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	ff 75 08             	pushl  0x8(%ebp)
  8022f1:	6a 0d                	push   $0xd
  8022f3:	e8 46 fe ff ff       	call   80213e <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 0e                	push   $0xe
  80230c:	e8 2d fe ff ff       	call   80213e <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	90                   	nop
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 13                	push   $0x13
  802326:	e8 13 fe ff ff       	call   80213e <syscall>
  80232b:	83 c4 18             	add    $0x18,%esp
}
  80232e:	90                   	nop
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 14                	push   $0x14
  802340:	e8 f9 fd ff ff       	call   80213e <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	90                   	nop
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_cputc>:


void
sys_cputc(const char c)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 04             	sub    $0x4,%esp
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802357:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	50                   	push   %eax
  802364:	6a 15                	push   $0x15
  802366:	e8 d3 fd ff ff       	call   80213e <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
}
  80236e:	90                   	nop
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 16                	push   $0x16
  802380:	e8 b9 fd ff ff       	call   80213e <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
}
  802388:	90                   	nop
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	ff 75 0c             	pushl  0xc(%ebp)
  80239a:	50                   	push   %eax
  80239b:	6a 17                	push   $0x17
  80239d:	e8 9c fd ff ff       	call   80213e <syscall>
  8023a2:	83 c4 18             	add    $0x18,%esp
}
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	52                   	push   %edx
  8023b7:	50                   	push   %eax
  8023b8:	6a 1a                	push   $0x1a
  8023ba:	e8 7f fd ff ff       	call   80213e <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	52                   	push   %edx
  8023d4:	50                   	push   %eax
  8023d5:	6a 18                	push   $0x18
  8023d7:	e8 62 fd ff ff       	call   80213e <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
}
  8023df:	90                   	nop
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	52                   	push   %edx
  8023f2:	50                   	push   %eax
  8023f3:	6a 19                	push   $0x19
  8023f5:	e8 44 fd ff ff       	call   80213e <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
}
  8023fd:	90                   	nop
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	8b 45 10             	mov    0x10(%ebp),%eax
  802409:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80240c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80240f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	6a 00                	push   $0x0
  802418:	51                   	push   %ecx
  802419:	52                   	push   %edx
  80241a:	ff 75 0c             	pushl  0xc(%ebp)
  80241d:	50                   	push   %eax
  80241e:	6a 1b                	push   $0x1b
  802420:	e8 19 fd ff ff       	call   80213e <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80242d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	52                   	push   %edx
  80243a:	50                   	push   %eax
  80243b:	6a 1c                	push   $0x1c
  80243d:	e8 fc fc ff ff       	call   80213e <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80244a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80244d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	51                   	push   %ecx
  802458:	52                   	push   %edx
  802459:	50                   	push   %eax
  80245a:	6a 1d                	push   $0x1d
  80245c:	e8 dd fc ff ff       	call   80213e <syscall>
  802461:	83 c4 18             	add    $0x18,%esp
}
  802464:	c9                   	leave  
  802465:	c3                   	ret    

00802466 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	52                   	push   %edx
  802476:	50                   	push   %eax
  802477:	6a 1e                	push   $0x1e
  802479:	e8 c0 fc ff ff       	call   80213e <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 1f                	push   $0x1f
  802492:	e8 a7 fc ff ff       	call   80213e <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	6a 00                	push   $0x0
  8024a4:	ff 75 14             	pushl  0x14(%ebp)
  8024a7:	ff 75 10             	pushl  0x10(%ebp)
  8024aa:	ff 75 0c             	pushl  0xc(%ebp)
  8024ad:	50                   	push   %eax
  8024ae:	6a 20                	push   $0x20
  8024b0:	e8 89 fc ff ff       	call   80213e <syscall>
  8024b5:	83 c4 18             	add    $0x18,%esp
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	50                   	push   %eax
  8024c9:	6a 21                	push   $0x21
  8024cb:	e8 6e fc ff ff       	call   80213e <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
}
  8024d3:	90                   	nop
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	50                   	push   %eax
  8024e5:	6a 22                	push   $0x22
  8024e7:	e8 52 fc ff ff       	call   80213e <syscall>
  8024ec:	83 c4 18             	add    $0x18,%esp
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 02                	push   $0x2
  802500:	e8 39 fc ff ff       	call   80213e <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 03                	push   $0x3
  802519:	e8 20 fc ff ff       	call   80213e <syscall>
  80251e:	83 c4 18             	add    $0x18,%esp
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 04                	push   $0x4
  802532:	e8 07 fc ff ff       	call   80213e <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <sys_exit_env>:


void sys_exit_env(void)
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 23                	push   $0x23
  80254b:	e8 ee fb ff ff       	call   80213e <syscall>
  802550:	83 c4 18             	add    $0x18,%esp
}
  802553:	90                   	nop
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80255c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80255f:	8d 50 04             	lea    0x4(%eax),%edx
  802562:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	52                   	push   %edx
  80256c:	50                   	push   %eax
  80256d:	6a 24                	push   $0x24
  80256f:	e8 ca fb ff ff       	call   80213e <syscall>
  802574:	83 c4 18             	add    $0x18,%esp
	return result;
  802577:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80257a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80257d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802580:	89 01                	mov    %eax,(%ecx)
  802582:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802585:	8b 45 08             	mov    0x8(%ebp),%eax
  802588:	c9                   	leave  
  802589:	c2 04 00             	ret    $0x4

0080258c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	ff 75 10             	pushl  0x10(%ebp)
  802596:	ff 75 0c             	pushl  0xc(%ebp)
  802599:	ff 75 08             	pushl  0x8(%ebp)
  80259c:	6a 12                	push   $0x12
  80259e:	e8 9b fb ff ff       	call   80213e <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a6:	90                   	nop
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 25                	push   $0x25
  8025b8:	e8 81 fb ff ff       	call   80213e <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 04             	sub    $0x4,%esp
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025ce:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	50                   	push   %eax
  8025db:	6a 26                	push   $0x26
  8025dd:	e8 5c fb ff ff       	call   80213e <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e5:	90                   	nop
}
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <rsttst>:
void rsttst()
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 28                	push   $0x28
  8025f7:	e8 42 fb ff ff       	call   80213e <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ff:	90                   	nop
}
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 04             	sub    $0x4,%esp
  802608:	8b 45 14             	mov    0x14(%ebp),%eax
  80260b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80260e:	8b 55 18             	mov    0x18(%ebp),%edx
  802611:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802615:	52                   	push   %edx
  802616:	50                   	push   %eax
  802617:	ff 75 10             	pushl  0x10(%ebp)
  80261a:	ff 75 0c             	pushl  0xc(%ebp)
  80261d:	ff 75 08             	pushl  0x8(%ebp)
  802620:	6a 27                	push   $0x27
  802622:	e8 17 fb ff ff       	call   80213e <syscall>
  802627:	83 c4 18             	add    $0x18,%esp
	return ;
  80262a:	90                   	nop
}
  80262b:	c9                   	leave  
  80262c:	c3                   	ret    

0080262d <chktst>:
void chktst(uint32 n)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	ff 75 08             	pushl  0x8(%ebp)
  80263b:	6a 29                	push   $0x29
  80263d:	e8 fc fa ff ff       	call   80213e <syscall>
  802642:	83 c4 18             	add    $0x18,%esp
	return ;
  802645:	90                   	nop
}
  802646:	c9                   	leave  
  802647:	c3                   	ret    

00802648 <inctst>:

void inctst()
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 2a                	push   $0x2a
  802657:	e8 e2 fa ff ff       	call   80213e <syscall>
  80265c:	83 c4 18             	add    $0x18,%esp
	return ;
  80265f:	90                   	nop
}
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <gettst>:
uint32 gettst()
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 2b                	push   $0x2b
  802671:	e8 c8 fa ff ff       	call   80213e <syscall>
  802676:	83 c4 18             	add    $0x18,%esp
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 2c                	push   $0x2c
  80268d:	e8 ac fa ff ff       	call   80213e <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
  802695:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802698:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80269c:	75 07                	jne    8026a5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80269e:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a3:	eb 05                	jmp    8026aa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8026a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026aa:	c9                   	leave  
  8026ab:	c3                   	ret    

008026ac <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
  8026af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 2c                	push   $0x2c
  8026be:	e8 7b fa ff ff       	call   80213e <syscall>
  8026c3:	83 c4 18             	add    $0x18,%esp
  8026c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026c9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026cd:	75 07                	jne    8026d6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d4:	eb 05                	jmp    8026db <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026db:	c9                   	leave  
  8026dc:	c3                   	ret    

008026dd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 2c                	push   $0x2c
  8026ef:	e8 4a fa ff ff       	call   80213e <syscall>
  8026f4:	83 c4 18             	add    $0x18,%esp
  8026f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026fa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026fe:	75 07                	jne    802707 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802700:	b8 01 00 00 00       	mov    $0x1,%eax
  802705:	eb 05                	jmp    80270c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
  802711:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 2c                	push   $0x2c
  802720:	e8 19 fa ff ff       	call   80213e <syscall>
  802725:	83 c4 18             	add    $0x18,%esp
  802728:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80272b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80272f:	75 07                	jne    802738 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802731:	b8 01 00 00 00       	mov    $0x1,%eax
  802736:	eb 05                	jmp    80273d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802738:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80273d:	c9                   	leave  
  80273e:	c3                   	ret    

0080273f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	ff 75 08             	pushl  0x8(%ebp)
  80274d:	6a 2d                	push   $0x2d
  80274f:	e8 ea f9 ff ff       	call   80213e <syscall>
  802754:	83 c4 18             	add    $0x18,%esp
	return ;
  802757:	90                   	nop
}
  802758:	c9                   	leave  
  802759:	c3                   	ret    

0080275a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80275e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802761:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802764:	8b 55 0c             	mov    0xc(%ebp),%edx
  802767:	8b 45 08             	mov    0x8(%ebp),%eax
  80276a:	6a 00                	push   $0x0
  80276c:	53                   	push   %ebx
  80276d:	51                   	push   %ecx
  80276e:	52                   	push   %edx
  80276f:	50                   	push   %eax
  802770:	6a 2e                	push   $0x2e
  802772:	e8 c7 f9 ff ff       	call   80213e <syscall>
  802777:	83 c4 18             	add    $0x18,%esp
}
  80277a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80277d:	c9                   	leave  
  80277e:	c3                   	ret    

0080277f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802782:	8b 55 0c             	mov    0xc(%ebp),%edx
  802785:	8b 45 08             	mov    0x8(%ebp),%eax
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	52                   	push   %edx
  80278f:	50                   	push   %eax
  802790:	6a 2f                	push   $0x2f
  802792:	e8 a7 f9 ff ff       	call   80213e <syscall>
  802797:	83 c4 18             	add    $0x18,%esp
}
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8027a2:	83 ec 0c             	sub    $0xc,%esp
  8027a5:	68 84 4b 80 00       	push   $0x804b84
  8027aa:	e8 8c e7 ff ff       	call   800f3b <cprintf>
  8027af:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8027b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8027b9:	83 ec 0c             	sub    $0xc,%esp
  8027bc:	68 b0 4b 80 00       	push   $0x804bb0
  8027c1:	e8 75 e7 ff ff       	call   800f3b <cprintf>
  8027c6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8027c9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8027d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d5:	eb 56                	jmp    80282d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027db:	74 1c                	je     8027f9 <print_mem_block_lists+0x5d>
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 50 08             	mov    0x8(%eax),%edx
  8027e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e6:	8b 48 08             	mov    0x8(%eax),%ecx
  8027e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ef:	01 c8                	add    %ecx,%eax
  8027f1:	39 c2                	cmp    %eax,%edx
  8027f3:	73 04                	jae    8027f9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8027f5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 50 08             	mov    0x8(%eax),%edx
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 40 0c             	mov    0xc(%eax),%eax
  802805:	01 c2                	add    %eax,%edx
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 40 08             	mov    0x8(%eax),%eax
  80280d:	83 ec 04             	sub    $0x4,%esp
  802810:	52                   	push   %edx
  802811:	50                   	push   %eax
  802812:	68 c5 4b 80 00       	push   $0x804bc5
  802817:	e8 1f e7 ff ff       	call   800f3b <cprintf>
  80281c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802825:	a1 40 51 80 00       	mov    0x805140,%eax
  80282a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	74 07                	je     80283a <print_mem_block_lists+0x9e>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	eb 05                	jmp    80283f <print_mem_block_lists+0xa3>
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	a3 40 51 80 00       	mov    %eax,0x805140
  802844:	a1 40 51 80 00       	mov    0x805140,%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	75 8a                	jne    8027d7 <print_mem_block_lists+0x3b>
  80284d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802851:	75 84                	jne    8027d7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802853:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802857:	75 10                	jne    802869 <print_mem_block_lists+0xcd>
  802859:	83 ec 0c             	sub    $0xc,%esp
  80285c:	68 d4 4b 80 00       	push   $0x804bd4
  802861:	e8 d5 e6 ff ff       	call   800f3b <cprintf>
  802866:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802869:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802870:	83 ec 0c             	sub    $0xc,%esp
  802873:	68 f8 4b 80 00       	push   $0x804bf8
  802878:	e8 be e6 ff ff       	call   800f3b <cprintf>
  80287d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802880:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802884:	a1 40 50 80 00       	mov    0x805040,%eax
  802889:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288c:	eb 56                	jmp    8028e4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80288e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802892:	74 1c                	je     8028b0 <print_mem_block_lists+0x114>
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 50 08             	mov    0x8(%eax),%edx
  80289a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289d:	8b 48 08             	mov    0x8(%eax),%ecx
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a6:	01 c8                	add    %ecx,%eax
  8028a8:	39 c2                	cmp    %eax,%edx
  8028aa:	73 04                	jae    8028b0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8028ac:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	8b 50 08             	mov    0x8(%eax),%edx
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bc:	01 c2                	add    %eax,%edx
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 08             	mov    0x8(%eax),%eax
  8028c4:	83 ec 04             	sub    $0x4,%esp
  8028c7:	52                   	push   %edx
  8028c8:	50                   	push   %eax
  8028c9:	68 c5 4b 80 00       	push   $0x804bc5
  8028ce:	e8 68 e6 ff ff       	call   800f3b <cprintf>
  8028d3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028dc:	a1 48 50 80 00       	mov    0x805048,%eax
  8028e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e8:	74 07                	je     8028f1 <print_mem_block_lists+0x155>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	eb 05                	jmp    8028f6 <print_mem_block_lists+0x15a>
  8028f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f6:	a3 48 50 80 00       	mov    %eax,0x805048
  8028fb:	a1 48 50 80 00       	mov    0x805048,%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	75 8a                	jne    80288e <print_mem_block_lists+0xf2>
  802904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802908:	75 84                	jne    80288e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80290a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80290e:	75 10                	jne    802920 <print_mem_block_lists+0x184>
  802910:	83 ec 0c             	sub    $0xc,%esp
  802913:	68 10 4c 80 00       	push   $0x804c10
  802918:	e8 1e e6 ff ff       	call   800f3b <cprintf>
  80291d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802920:	83 ec 0c             	sub    $0xc,%esp
  802923:	68 84 4b 80 00       	push   $0x804b84
  802928:	e8 0e e6 ff ff       	call   800f3b <cprintf>
  80292d:	83 c4 10             	add    $0x10,%esp

}
  802930:	90                   	nop
  802931:	c9                   	leave  
  802932:	c3                   	ret    

00802933 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802933:	55                   	push   %ebp
  802934:	89 e5                	mov    %esp,%ebp
  802936:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802939:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802940:	00 00 00 
  802943:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80294a:	00 00 00 
  80294d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802954:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802957:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80295e:	e9 9e 00 00 00       	jmp    802a01 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802963:	a1 50 50 80 00       	mov    0x805050,%eax
  802968:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296b:	c1 e2 04             	shl    $0x4,%edx
  80296e:	01 d0                	add    %edx,%eax
  802970:	85 c0                	test   %eax,%eax
  802972:	75 14                	jne    802988 <initialize_MemBlocksList+0x55>
  802974:	83 ec 04             	sub    $0x4,%esp
  802977:	68 38 4c 80 00       	push   $0x804c38
  80297c:	6a 46                	push   $0x46
  80297e:	68 5b 4c 80 00       	push   $0x804c5b
  802983:	e8 ff e2 ff ff       	call   800c87 <_panic>
  802988:	a1 50 50 80 00       	mov    0x805050,%eax
  80298d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802990:	c1 e2 04             	shl    $0x4,%edx
  802993:	01 d0                	add    %edx,%eax
  802995:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80299b:	89 10                	mov    %edx,(%eax)
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	74 18                	je     8029bb <initialize_MemBlocksList+0x88>
  8029a3:	a1 48 51 80 00       	mov    0x805148,%eax
  8029a8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8029ae:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8029b1:	c1 e1 04             	shl    $0x4,%ecx
  8029b4:	01 ca                	add    %ecx,%edx
  8029b6:	89 50 04             	mov    %edx,0x4(%eax)
  8029b9:	eb 12                	jmp    8029cd <initialize_MemBlocksList+0x9a>
  8029bb:	a1 50 50 80 00       	mov    0x805050,%eax
  8029c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c3:	c1 e2 04             	shl    $0x4,%edx
  8029c6:	01 d0                	add    %edx,%eax
  8029c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8029d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d5:	c1 e2 04             	shl    $0x4,%edx
  8029d8:	01 d0                	add    %edx,%eax
  8029da:	a3 48 51 80 00       	mov    %eax,0x805148
  8029df:	a1 50 50 80 00       	mov    0x805050,%eax
  8029e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e7:	c1 e2 04             	shl    $0x4,%edx
  8029ea:	01 d0                	add    %edx,%eax
  8029ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f3:	a1 54 51 80 00       	mov    0x805154,%eax
  8029f8:	40                   	inc    %eax
  8029f9:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8029fe:	ff 45 f4             	incl   -0xc(%ebp)
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a07:	0f 82 56 ff ff ff    	jb     802963 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802a0d:	90                   	nop
  802a0e:	c9                   	leave  
  802a0f:	c3                   	ret    

00802a10 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a1e:	eb 19                	jmp    802a39 <find_block+0x29>
	{
		if(va==point->sva)
  802a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a23:	8b 40 08             	mov    0x8(%eax),%eax
  802a26:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a29:	75 05                	jne    802a30 <find_block+0x20>
		   return point;
  802a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a2e:	eb 36                	jmp    802a66 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	8b 40 08             	mov    0x8(%eax),%eax
  802a36:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a39:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a3d:	74 07                	je     802a46 <find_block+0x36>
  802a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a42:	8b 00                	mov    (%eax),%eax
  802a44:	eb 05                	jmp    802a4b <find_block+0x3b>
  802a46:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4e:	89 42 08             	mov    %eax,0x8(%edx)
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	8b 40 08             	mov    0x8(%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	75 c5                	jne    802a20 <find_block+0x10>
  802a5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a5f:	75 bf                	jne    802a20 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a66:	c9                   	leave  
  802a67:	c3                   	ret    

00802a68 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a68:	55                   	push   %ebp
  802a69:	89 e5                	mov    %esp,%ebp
  802a6b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802a6e:	a1 40 50 80 00       	mov    0x805040,%eax
  802a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802a76:	a1 44 50 80 00       	mov    0x805044,%eax
  802a7b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a81:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a84:	74 24                	je     802aaa <insert_sorted_allocList+0x42>
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	8b 50 08             	mov    0x8(%eax),%edx
  802a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8f:	8b 40 08             	mov    0x8(%eax),%eax
  802a92:	39 c2                	cmp    %eax,%edx
  802a94:	76 14                	jbe    802aaa <insert_sorted_allocList+0x42>
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	8b 50 08             	mov    0x8(%eax),%edx
  802a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9f:	8b 40 08             	mov    0x8(%eax),%eax
  802aa2:	39 c2                	cmp    %eax,%edx
  802aa4:	0f 82 60 01 00 00    	jb     802c0a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802aaa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aae:	75 65                	jne    802b15 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802ab0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab4:	75 14                	jne    802aca <insert_sorted_allocList+0x62>
  802ab6:	83 ec 04             	sub    $0x4,%esp
  802ab9:	68 38 4c 80 00       	push   $0x804c38
  802abe:	6a 6b                	push   $0x6b
  802ac0:	68 5b 4c 80 00       	push   $0x804c5b
  802ac5:	e8 bd e1 ff ff       	call   800c87 <_panic>
  802aca:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	89 10                	mov    %edx,(%eax)
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	74 0d                	je     802aeb <insert_sorted_allocList+0x83>
  802ade:	a1 40 50 80 00       	mov    0x805040,%eax
  802ae3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae6:	89 50 04             	mov    %edx,0x4(%eax)
  802ae9:	eb 08                	jmp    802af3 <insert_sorted_allocList+0x8b>
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	a3 44 50 80 00       	mov    %eax,0x805044
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	a3 40 50 80 00       	mov    %eax,0x805040
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b05:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b0a:	40                   	inc    %eax
  802b0b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b10:	e9 dc 01 00 00       	jmp    802cf1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	8b 50 08             	mov    0x8(%eax),%edx
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	8b 40 08             	mov    0x8(%eax),%eax
  802b21:	39 c2                	cmp    %eax,%edx
  802b23:	77 6c                	ja     802b91 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802b25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b29:	74 06                	je     802b31 <insert_sorted_allocList+0xc9>
  802b2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2f:	75 14                	jne    802b45 <insert_sorted_allocList+0xdd>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 74 4c 80 00       	push   $0x804c74
  802b39:	6a 6f                	push   $0x6f
  802b3b:	68 5b 4c 80 00       	push   $0x804c5b
  802b40:	e8 42 e1 ff ff       	call   800c87 <_panic>
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 50 04             	mov    0x4(%eax),%edx
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	89 50 04             	mov    %edx,0x4(%eax)
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b57:	89 10                	mov    %edx,(%eax)
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	8b 40 04             	mov    0x4(%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 0d                	je     802b70 <insert_sorted_allocList+0x108>
  802b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6c:	89 10                	mov    %edx,(%eax)
  802b6e:	eb 08                	jmp    802b78 <insert_sorted_allocList+0x110>
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	a3 40 50 80 00       	mov    %eax,0x805040
  802b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%eax)
  802b81:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b86:	40                   	inc    %eax
  802b87:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b8c:	e9 60 01 00 00       	jmp    802cf1 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 50 08             	mov    0x8(%eax),%edx
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	8b 40 08             	mov    0x8(%eax),%eax
  802b9d:	39 c2                	cmp    %eax,%edx
  802b9f:	0f 82 4c 01 00 00    	jb     802cf1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802ba5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba9:	75 14                	jne    802bbf <insert_sorted_allocList+0x157>
  802bab:	83 ec 04             	sub    $0x4,%esp
  802bae:	68 ac 4c 80 00       	push   $0x804cac
  802bb3:	6a 73                	push   $0x73
  802bb5:	68 5b 4c 80 00       	push   $0x804c5b
  802bba:	e8 c8 e0 ff ff       	call   800c87 <_panic>
  802bbf:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	89 50 04             	mov    %edx,0x4(%eax)
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	8b 40 04             	mov    0x4(%eax),%eax
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	74 0c                	je     802be1 <insert_sorted_allocList+0x179>
  802bd5:	a1 44 50 80 00       	mov    0x805044,%eax
  802bda:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdd:	89 10                	mov    %edx,(%eax)
  802bdf:	eb 08                	jmp    802be9 <insert_sorted_allocList+0x181>
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	a3 40 50 80 00       	mov    %eax,0x805040
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	a3 44 50 80 00       	mov    %eax,0x805044
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bfa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bff:	40                   	inc    %eax
  802c00:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c05:	e9 e7 00 00 00       	jmp    802cf1 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802c10:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802c17:	a1 40 50 80 00       	mov    0x805040,%eax
  802c1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1f:	e9 9d 00 00 00       	jmp    802cc1 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	8b 50 08             	mov    0x8(%eax),%edx
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 40 08             	mov    0x8(%eax),%eax
  802c38:	39 c2                	cmp    %eax,%edx
  802c3a:	76 7d                	jbe    802cb9 <insert_sorted_allocList+0x251>
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 50 08             	mov    0x8(%eax),%edx
  802c42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c45:	8b 40 08             	mov    0x8(%eax),%eax
  802c48:	39 c2                	cmp    %eax,%edx
  802c4a:	73 6d                	jae    802cb9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802c4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c50:	74 06                	je     802c58 <insert_sorted_allocList+0x1f0>
  802c52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c56:	75 14                	jne    802c6c <insert_sorted_allocList+0x204>
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	68 d0 4c 80 00       	push   $0x804cd0
  802c60:	6a 7f                	push   $0x7f
  802c62:	68 5b 4c 80 00       	push   $0x804c5b
  802c67:	e8 1b e0 ff ff       	call   800c87 <_panic>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 10                	mov    (%eax),%edx
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	89 10                	mov    %edx,(%eax)
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	8b 00                	mov    (%eax),%eax
  802c7b:	85 c0                	test   %eax,%eax
  802c7d:	74 0b                	je     802c8a <insert_sorted_allocList+0x222>
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 00                	mov    (%eax),%eax
  802c84:	8b 55 08             	mov    0x8(%ebp),%edx
  802c87:	89 50 04             	mov    %edx,0x4(%eax)
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c90:	89 10                	mov    %edx,(%eax)
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c98:	89 50 04             	mov    %edx,0x4(%eax)
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 00                	mov    (%eax),%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	75 08                	jne    802cac <insert_sorted_allocList+0x244>
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	a3 44 50 80 00       	mov    %eax,0x805044
  802cac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cb1:	40                   	inc    %eax
  802cb2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802cb7:	eb 39                	jmp    802cf2 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802cb9:	a1 48 50 80 00       	mov    0x805048,%eax
  802cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc5:	74 07                	je     802cce <insert_sorted_allocList+0x266>
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 00                	mov    (%eax),%eax
  802ccc:	eb 05                	jmp    802cd3 <insert_sorted_allocList+0x26b>
  802cce:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd3:	a3 48 50 80 00       	mov    %eax,0x805048
  802cd8:	a1 48 50 80 00       	mov    0x805048,%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	0f 85 3f ff ff ff    	jne    802c24 <insert_sorted_allocList+0x1bc>
  802ce5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce9:	0f 85 35 ff ff ff    	jne    802c24 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802cef:	eb 01                	jmp    802cf2 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802cf1:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802cf2:	90                   	nop
  802cf3:	c9                   	leave  
  802cf4:	c3                   	ret    

00802cf5 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802cf5:	55                   	push   %ebp
  802cf6:	89 e5                	mov    %esp,%ebp
  802cf8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802cfb:	a1 38 51 80 00       	mov    0x805138,%eax
  802d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d03:	e9 85 01 00 00       	jmp    802e8d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d11:	0f 82 6e 01 00 00    	jb     802e85 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d20:	0f 85 8a 00 00 00    	jne    802db0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2a:	75 17                	jne    802d43 <alloc_block_FF+0x4e>
  802d2c:	83 ec 04             	sub    $0x4,%esp
  802d2f:	68 04 4d 80 00       	push   $0x804d04
  802d34:	68 93 00 00 00       	push   $0x93
  802d39:	68 5b 4c 80 00       	push   $0x804c5b
  802d3e:	e8 44 df ff ff       	call   800c87 <_panic>
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 00                	mov    (%eax),%eax
  802d48:	85 c0                	test   %eax,%eax
  802d4a:	74 10                	je     802d5c <alloc_block_FF+0x67>
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d54:	8b 52 04             	mov    0x4(%edx),%edx
  802d57:	89 50 04             	mov    %edx,0x4(%eax)
  802d5a:	eb 0b                	jmp    802d67 <alloc_block_FF+0x72>
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 40 04             	mov    0x4(%eax),%eax
  802d62:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	85 c0                	test   %eax,%eax
  802d6f:	74 0f                	je     802d80 <alloc_block_FF+0x8b>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 40 04             	mov    0x4(%eax),%eax
  802d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7a:	8b 12                	mov    (%edx),%edx
  802d7c:	89 10                	mov    %edx,(%eax)
  802d7e:	eb 0a                	jmp    802d8a <alloc_block_FF+0x95>
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	a3 38 51 80 00       	mov    %eax,0x805138
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9d:	a1 44 51 80 00       	mov    0x805144,%eax
  802da2:	48                   	dec    %eax
  802da3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	e9 10 01 00 00       	jmp    802ec0 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 40 0c             	mov    0xc(%eax),%eax
  802db6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802db9:	0f 86 c6 00 00 00    	jbe    802e85 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dbf:	a1 48 51 80 00       	mov    0x805148,%eax
  802dc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 50 08             	mov    0x8(%eax),%edx
  802dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd0:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd9:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ddc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de0:	75 17                	jne    802df9 <alloc_block_FF+0x104>
  802de2:	83 ec 04             	sub    $0x4,%esp
  802de5:	68 04 4d 80 00       	push   $0x804d04
  802dea:	68 9b 00 00 00       	push   $0x9b
  802def:	68 5b 4c 80 00       	push   $0x804c5b
  802df4:	e8 8e de ff ff       	call   800c87 <_panic>
  802df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 10                	je     802e12 <alloc_block_FF+0x11d>
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e0a:	8b 52 04             	mov    0x4(%edx),%edx
  802e0d:	89 50 04             	mov    %edx,0x4(%eax)
  802e10:	eb 0b                	jmp    802e1d <alloc_block_FF+0x128>
  802e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e15:	8b 40 04             	mov    0x4(%eax),%eax
  802e18:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 0f                	je     802e36 <alloc_block_FF+0x141>
  802e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2a:	8b 40 04             	mov    0x4(%eax),%eax
  802e2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e30:	8b 12                	mov    (%edx),%edx
  802e32:	89 10                	mov    %edx,(%eax)
  802e34:	eb 0a                	jmp    802e40 <alloc_block_FF+0x14b>
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	a3 48 51 80 00       	mov    %eax,0x805148
  802e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e53:	a1 54 51 80 00       	mov    0x805154,%eax
  802e58:	48                   	dec    %eax
  802e59:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e61:	8b 50 08             	mov    0x8(%eax),%edx
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	01 c2                	add    %eax,%edx
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 40 0c             	mov    0xc(%eax),%eax
  802e75:	2b 45 08             	sub    0x8(%ebp),%eax
  802e78:	89 c2                	mov    %eax,%edx
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e83:	eb 3b                	jmp    802ec0 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802e85:	a1 40 51 80 00       	mov    0x805140,%eax
  802e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e91:	74 07                	je     802e9a <alloc_block_FF+0x1a5>
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 00                	mov    (%eax),%eax
  802e98:	eb 05                	jmp    802e9f <alloc_block_FF+0x1aa>
  802e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9f:	a3 40 51 80 00       	mov    %eax,0x805140
  802ea4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	0f 85 57 fe ff ff    	jne    802d08 <alloc_block_FF+0x13>
  802eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb5:	0f 85 4d fe ff ff    	jne    802d08 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ebb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ec0:	c9                   	leave  
  802ec1:	c3                   	ret    

00802ec2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ec2:	55                   	push   %ebp
  802ec3:	89 e5                	mov    %esp,%ebp
  802ec5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802ec8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ecf:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed7:	e9 df 00 00 00       	jmp    802fbb <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee5:	0f 82 c8 00 00 00    	jb     802fb3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ef4:	0f 85 8a 00 00 00    	jne    802f84 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802efa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efe:	75 17                	jne    802f17 <alloc_block_BF+0x55>
  802f00:	83 ec 04             	sub    $0x4,%esp
  802f03:	68 04 4d 80 00       	push   $0x804d04
  802f08:	68 b7 00 00 00       	push   $0xb7
  802f0d:	68 5b 4c 80 00       	push   $0x804c5b
  802f12:	e8 70 dd ff ff       	call   800c87 <_panic>
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	85 c0                	test   %eax,%eax
  802f1e:	74 10                	je     802f30 <alloc_block_BF+0x6e>
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f28:	8b 52 04             	mov    0x4(%edx),%edx
  802f2b:	89 50 04             	mov    %edx,0x4(%eax)
  802f2e:	eb 0b                	jmp    802f3b <alloc_block_BF+0x79>
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 40 04             	mov    0x4(%eax),%eax
  802f36:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 40 04             	mov    0x4(%eax),%eax
  802f41:	85 c0                	test   %eax,%eax
  802f43:	74 0f                	je     802f54 <alloc_block_BF+0x92>
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 40 04             	mov    0x4(%eax),%eax
  802f4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4e:	8b 12                	mov    (%edx),%edx
  802f50:	89 10                	mov    %edx,(%eax)
  802f52:	eb 0a                	jmp    802f5e <alloc_block_BF+0x9c>
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	a3 38 51 80 00       	mov    %eax,0x805138
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f71:	a1 44 51 80 00       	mov    0x805144,%eax
  802f76:	48                   	dec    %eax
  802f77:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	e9 4d 01 00 00       	jmp    8030d1 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f8d:	76 24                	jbe    802fb3 <alloc_block_BF+0xf1>
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 40 0c             	mov    0xc(%eax),%eax
  802f95:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f98:	73 19                	jae    802fb3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802f9a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	8b 40 08             	mov    0x8(%eax),%eax
  802fb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802fb3:	a1 40 51 80 00       	mov    0x805140,%eax
  802fb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fbf:	74 07                	je     802fc8 <alloc_block_BF+0x106>
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	eb 05                	jmp    802fcd <alloc_block_BF+0x10b>
  802fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fcd:	a3 40 51 80 00       	mov    %eax,0x805140
  802fd2:	a1 40 51 80 00       	mov    0x805140,%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	0f 85 fd fe ff ff    	jne    802edc <alloc_block_BF+0x1a>
  802fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe3:	0f 85 f3 fe ff ff    	jne    802edc <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802fe9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fed:	0f 84 d9 00 00 00    	je     8030cc <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ff3:	a1 48 51 80 00       	mov    0x805148,%eax
  802ff8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ffe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803001:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803007:	8b 55 08             	mov    0x8(%ebp),%edx
  80300a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80300d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803011:	75 17                	jne    80302a <alloc_block_BF+0x168>
  803013:	83 ec 04             	sub    $0x4,%esp
  803016:	68 04 4d 80 00       	push   $0x804d04
  80301b:	68 c7 00 00 00       	push   $0xc7
  803020:	68 5b 4c 80 00       	push   $0x804c5b
  803025:	e8 5d dc ff ff       	call   800c87 <_panic>
  80302a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302d:	8b 00                	mov    (%eax),%eax
  80302f:	85 c0                	test   %eax,%eax
  803031:	74 10                	je     803043 <alloc_block_BF+0x181>
  803033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80303b:	8b 52 04             	mov    0x4(%edx),%edx
  80303e:	89 50 04             	mov    %edx,0x4(%eax)
  803041:	eb 0b                	jmp    80304e <alloc_block_BF+0x18c>
  803043:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803046:	8b 40 04             	mov    0x4(%eax),%eax
  803049:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80304e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803051:	8b 40 04             	mov    0x4(%eax),%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 0f                	je     803067 <alloc_block_BF+0x1a5>
  803058:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305b:	8b 40 04             	mov    0x4(%eax),%eax
  80305e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803061:	8b 12                	mov    (%edx),%edx
  803063:	89 10                	mov    %edx,(%eax)
  803065:	eb 0a                	jmp    803071 <alloc_block_BF+0x1af>
  803067:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306a:	8b 00                	mov    (%eax),%eax
  80306c:	a3 48 51 80 00       	mov    %eax,0x805148
  803071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803074:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803084:	a1 54 51 80 00       	mov    0x805154,%eax
  803089:	48                   	dec    %eax
  80308a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80308f:	83 ec 08             	sub    $0x8,%esp
  803092:	ff 75 ec             	pushl  -0x14(%ebp)
  803095:	68 38 51 80 00       	push   $0x805138
  80309a:	e8 71 f9 ff ff       	call   802a10 <find_block>
  80309f:	83 c4 10             	add    $0x10,%esp
  8030a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8030a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a8:	8b 50 08             	mov    0x8(%eax),%edx
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	01 c2                	add    %eax,%edx
  8030b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8030b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8030bf:	89 c2                	mov    %eax,%edx
  8030c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c4:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8030c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ca:	eb 05                	jmp    8030d1 <alloc_block_BF+0x20f>
	}
	return NULL;
  8030cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030d1:	c9                   	leave  
  8030d2:	c3                   	ret    

008030d3 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8030d3:	55                   	push   %ebp
  8030d4:	89 e5                	mov    %esp,%ebp
  8030d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8030d9:	a1 28 50 80 00       	mov    0x805028,%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	0f 85 de 01 00 00    	jne    8032c4 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8030e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8030eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ee:	e9 9e 01 00 00       	jmp    803291 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8030f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030fc:	0f 82 87 01 00 00    	jb     803289 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	8b 40 0c             	mov    0xc(%eax),%eax
  803108:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310b:	0f 85 95 00 00 00    	jne    8031a6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803111:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803115:	75 17                	jne    80312e <alloc_block_NF+0x5b>
  803117:	83 ec 04             	sub    $0x4,%esp
  80311a:	68 04 4d 80 00       	push   $0x804d04
  80311f:	68 e0 00 00 00       	push   $0xe0
  803124:	68 5b 4c 80 00       	push   $0x804c5b
  803129:	e8 59 db ff ff       	call   800c87 <_panic>
  80312e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	85 c0                	test   %eax,%eax
  803135:	74 10                	je     803147 <alloc_block_NF+0x74>
  803137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313a:	8b 00                	mov    (%eax),%eax
  80313c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313f:	8b 52 04             	mov    0x4(%edx),%edx
  803142:	89 50 04             	mov    %edx,0x4(%eax)
  803145:	eb 0b                	jmp    803152 <alloc_block_NF+0x7f>
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 40 04             	mov    0x4(%eax),%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	74 0f                	je     80316b <alloc_block_NF+0x98>
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	8b 40 04             	mov    0x4(%eax),%eax
  803162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803165:	8b 12                	mov    (%edx),%edx
  803167:	89 10                	mov    %edx,(%eax)
  803169:	eb 0a                	jmp    803175 <alloc_block_NF+0xa2>
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	8b 00                	mov    (%eax),%eax
  803170:	a3 38 51 80 00       	mov    %eax,0x805138
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803188:	a1 44 51 80 00       	mov    0x805144,%eax
  80318d:	48                   	dec    %eax
  80318e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	8b 40 08             	mov    0x8(%eax),%eax
  803199:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80319e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a1:	e9 f8 04 00 00       	jmp    80369e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031af:	0f 86 d4 00 00 00    	jbe    803289 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8031bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c0:	8b 50 08             	mov    0x8(%eax),%edx
  8031c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c6:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8031cf:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d6:	75 17                	jne    8031ef <alloc_block_NF+0x11c>
  8031d8:	83 ec 04             	sub    $0x4,%esp
  8031db:	68 04 4d 80 00       	push   $0x804d04
  8031e0:	68 e9 00 00 00       	push   $0xe9
  8031e5:	68 5b 4c 80 00       	push   $0x804c5b
  8031ea:	e8 98 da ff ff       	call   800c87 <_panic>
  8031ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f2:	8b 00                	mov    (%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 10                	je     803208 <alloc_block_NF+0x135>
  8031f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fb:	8b 00                	mov    (%eax),%eax
  8031fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803200:	8b 52 04             	mov    0x4(%edx),%edx
  803203:	89 50 04             	mov    %edx,0x4(%eax)
  803206:	eb 0b                	jmp    803213 <alloc_block_NF+0x140>
  803208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320b:	8b 40 04             	mov    0x4(%eax),%eax
  80320e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803216:	8b 40 04             	mov    0x4(%eax),%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	74 0f                	je     80322c <alloc_block_NF+0x159>
  80321d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803220:	8b 40 04             	mov    0x4(%eax),%eax
  803223:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803226:	8b 12                	mov    (%edx),%edx
  803228:	89 10                	mov    %edx,(%eax)
  80322a:	eb 0a                	jmp    803236 <alloc_block_NF+0x163>
  80322c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	a3 48 51 80 00       	mov    %eax,0x805148
  803236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803242:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803249:	a1 54 51 80 00       	mov    0x805154,%eax
  80324e:	48                   	dec    %eax
  80324f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803257:	8b 40 08             	mov    0x8(%eax),%eax
  80325a:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	8b 50 08             	mov    0x8(%eax),%edx
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	01 c2                	add    %eax,%edx
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	8b 40 0c             	mov    0xc(%eax),%eax
  803276:	2b 45 08             	sub    0x8(%ebp),%eax
  803279:	89 c2                	mov    %eax,%edx
  80327b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803284:	e9 15 04 00 00       	jmp    80369e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803289:	a1 40 51 80 00       	mov    0x805140,%eax
  80328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803295:	74 07                	je     80329e <alloc_block_NF+0x1cb>
  803297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	eb 05                	jmp    8032a3 <alloc_block_NF+0x1d0>
  80329e:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a3:	a3 40 51 80 00       	mov    %eax,0x805140
  8032a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	0f 85 3e fe ff ff    	jne    8030f3 <alloc_block_NF+0x20>
  8032b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b9:	0f 85 34 fe ff ff    	jne    8030f3 <alloc_block_NF+0x20>
  8032bf:	e9 d5 03 00 00       	jmp    803699 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8032c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032cc:	e9 b1 01 00 00       	jmp    803482 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d4:	8b 50 08             	mov    0x8(%eax),%edx
  8032d7:	a1 28 50 80 00       	mov    0x805028,%eax
  8032dc:	39 c2                	cmp    %eax,%edx
  8032de:	0f 82 96 01 00 00    	jb     80347a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8032e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ed:	0f 82 87 01 00 00    	jb     80347a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032fc:	0f 85 95 00 00 00    	jne    803397 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803306:	75 17                	jne    80331f <alloc_block_NF+0x24c>
  803308:	83 ec 04             	sub    $0x4,%esp
  80330b:	68 04 4d 80 00       	push   $0x804d04
  803310:	68 fc 00 00 00       	push   $0xfc
  803315:	68 5b 4c 80 00       	push   $0x804c5b
  80331a:	e8 68 d9 ff ff       	call   800c87 <_panic>
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	8b 00                	mov    (%eax),%eax
  803324:	85 c0                	test   %eax,%eax
  803326:	74 10                	je     803338 <alloc_block_NF+0x265>
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	8b 00                	mov    (%eax),%eax
  80332d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803330:	8b 52 04             	mov    0x4(%edx),%edx
  803333:	89 50 04             	mov    %edx,0x4(%eax)
  803336:	eb 0b                	jmp    803343 <alloc_block_NF+0x270>
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 40 04             	mov    0x4(%eax),%eax
  80333e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803346:	8b 40 04             	mov    0x4(%eax),%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	74 0f                	je     80335c <alloc_block_NF+0x289>
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	8b 40 04             	mov    0x4(%eax),%eax
  803353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803356:	8b 12                	mov    (%edx),%edx
  803358:	89 10                	mov    %edx,(%eax)
  80335a:	eb 0a                	jmp    803366 <alloc_block_NF+0x293>
  80335c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335f:	8b 00                	mov    (%eax),%eax
  803361:	a3 38 51 80 00       	mov    %eax,0x805138
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803379:	a1 44 51 80 00       	mov    0x805144,%eax
  80337e:	48                   	dec    %eax
  80337f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	8b 40 08             	mov    0x8(%eax),%eax
  80338a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	e9 07 03 00 00       	jmp    80369e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	8b 40 0c             	mov    0xc(%eax),%eax
  80339d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033a0:	0f 86 d4 00 00 00    	jbe    80347a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8033a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	8b 50 08             	mov    0x8(%eax),%edx
  8033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8033ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8033c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c7:	75 17                	jne    8033e0 <alloc_block_NF+0x30d>
  8033c9:	83 ec 04             	sub    $0x4,%esp
  8033cc:	68 04 4d 80 00       	push   $0x804d04
  8033d1:	68 04 01 00 00       	push   $0x104
  8033d6:	68 5b 4c 80 00       	push   $0x804c5b
  8033db:	e8 a7 d8 ff ff       	call   800c87 <_panic>
  8033e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	85 c0                	test   %eax,%eax
  8033e7:	74 10                	je     8033f9 <alloc_block_NF+0x326>
  8033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f1:	8b 52 04             	mov    0x4(%edx),%edx
  8033f4:	89 50 04             	mov    %edx,0x4(%eax)
  8033f7:	eb 0b                	jmp    803404 <alloc_block_NF+0x331>
  8033f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fc:	8b 40 04             	mov    0x4(%eax),%eax
  8033ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	8b 40 04             	mov    0x4(%eax),%eax
  80340a:	85 c0                	test   %eax,%eax
  80340c:	74 0f                	je     80341d <alloc_block_NF+0x34a>
  80340e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803411:	8b 40 04             	mov    0x4(%eax),%eax
  803414:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803417:	8b 12                	mov    (%edx),%edx
  803419:	89 10                	mov    %edx,(%eax)
  80341b:	eb 0a                	jmp    803427 <alloc_block_NF+0x354>
  80341d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803420:	8b 00                	mov    (%eax),%eax
  803422:	a3 48 51 80 00       	mov    %eax,0x805148
  803427:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803430:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803433:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80343a:	a1 54 51 80 00       	mov    0x805154,%eax
  80343f:	48                   	dec    %eax
  803440:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803445:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803448:	8b 40 08             	mov    0x8(%eax),%eax
  80344b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	8b 50 08             	mov    0x8(%eax),%edx
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	01 c2                	add    %eax,%edx
  80345b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803464:	8b 40 0c             	mov    0xc(%eax),%eax
  803467:	2b 45 08             	sub    0x8(%ebp),%eax
  80346a:	89 c2                	mov    %eax,%edx
  80346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803475:	e9 24 02 00 00       	jmp    80369e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80347a:	a1 40 51 80 00       	mov    0x805140,%eax
  80347f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803486:	74 07                	je     80348f <alloc_block_NF+0x3bc>
  803488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348b:	8b 00                	mov    (%eax),%eax
  80348d:	eb 05                	jmp    803494 <alloc_block_NF+0x3c1>
  80348f:	b8 00 00 00 00       	mov    $0x0,%eax
  803494:	a3 40 51 80 00       	mov    %eax,0x805140
  803499:	a1 40 51 80 00       	mov    0x805140,%eax
  80349e:	85 c0                	test   %eax,%eax
  8034a0:	0f 85 2b fe ff ff    	jne    8032d1 <alloc_block_NF+0x1fe>
  8034a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034aa:	0f 85 21 fe ff ff    	jne    8032d1 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8034b0:	a1 38 51 80 00       	mov    0x805138,%eax
  8034b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034b8:	e9 ae 01 00 00       	jmp    80366b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8034bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c0:	8b 50 08             	mov    0x8(%eax),%edx
  8034c3:	a1 28 50 80 00       	mov    0x805028,%eax
  8034c8:	39 c2                	cmp    %eax,%edx
  8034ca:	0f 83 93 01 00 00    	jae    803663 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034d9:	0f 82 84 01 00 00    	jb     803663 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8034df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034e8:	0f 85 95 00 00 00    	jne    803583 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8034ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f2:	75 17                	jne    80350b <alloc_block_NF+0x438>
  8034f4:	83 ec 04             	sub    $0x4,%esp
  8034f7:	68 04 4d 80 00       	push   $0x804d04
  8034fc:	68 14 01 00 00       	push   $0x114
  803501:	68 5b 4c 80 00       	push   $0x804c5b
  803506:	e8 7c d7 ff ff       	call   800c87 <_panic>
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	85 c0                	test   %eax,%eax
  803512:	74 10                	je     803524 <alloc_block_NF+0x451>
  803514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803517:	8b 00                	mov    (%eax),%eax
  803519:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80351c:	8b 52 04             	mov    0x4(%edx),%edx
  80351f:	89 50 04             	mov    %edx,0x4(%eax)
  803522:	eb 0b                	jmp    80352f <alloc_block_NF+0x45c>
  803524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803527:	8b 40 04             	mov    0x4(%eax),%eax
  80352a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80352f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803532:	8b 40 04             	mov    0x4(%eax),%eax
  803535:	85 c0                	test   %eax,%eax
  803537:	74 0f                	je     803548 <alloc_block_NF+0x475>
  803539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353c:	8b 40 04             	mov    0x4(%eax),%eax
  80353f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803542:	8b 12                	mov    (%edx),%edx
  803544:	89 10                	mov    %edx,(%eax)
  803546:	eb 0a                	jmp    803552 <alloc_block_NF+0x47f>
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	8b 00                	mov    (%eax),%eax
  80354d:	a3 38 51 80 00       	mov    %eax,0x805138
  803552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803555:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803565:	a1 44 51 80 00       	mov    0x805144,%eax
  80356a:	48                   	dec    %eax
  80356b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803573:	8b 40 08             	mov    0x8(%eax),%eax
  803576:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80357b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357e:	e9 1b 01 00 00       	jmp    80369e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803586:	8b 40 0c             	mov    0xc(%eax),%eax
  803589:	3b 45 08             	cmp    0x8(%ebp),%eax
  80358c:	0f 86 d1 00 00 00    	jbe    803663 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803592:	a1 48 51 80 00       	mov    0x805148,%eax
  803597:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359d:	8b 50 08             	mov    0x8(%eax),%edx
  8035a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8035a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ac:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8035af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035b3:	75 17                	jne    8035cc <alloc_block_NF+0x4f9>
  8035b5:	83 ec 04             	sub    $0x4,%esp
  8035b8:	68 04 4d 80 00       	push   $0x804d04
  8035bd:	68 1c 01 00 00       	push   $0x11c
  8035c2:	68 5b 4c 80 00       	push   $0x804c5b
  8035c7:	e8 bb d6 ff ff       	call   800c87 <_panic>
  8035cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035cf:	8b 00                	mov    (%eax),%eax
  8035d1:	85 c0                	test   %eax,%eax
  8035d3:	74 10                	je     8035e5 <alloc_block_NF+0x512>
  8035d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d8:	8b 00                	mov    (%eax),%eax
  8035da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035dd:	8b 52 04             	mov    0x4(%edx),%edx
  8035e0:	89 50 04             	mov    %edx,0x4(%eax)
  8035e3:	eb 0b                	jmp    8035f0 <alloc_block_NF+0x51d>
  8035e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e8:	8b 40 04             	mov    0x4(%eax),%eax
  8035eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f3:	8b 40 04             	mov    0x4(%eax),%eax
  8035f6:	85 c0                	test   %eax,%eax
  8035f8:	74 0f                	je     803609 <alloc_block_NF+0x536>
  8035fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fd:	8b 40 04             	mov    0x4(%eax),%eax
  803600:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803603:	8b 12                	mov    (%edx),%edx
  803605:	89 10                	mov    %edx,(%eax)
  803607:	eb 0a                	jmp    803613 <alloc_block_NF+0x540>
  803609:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360c:	8b 00                	mov    (%eax),%eax
  80360e:	a3 48 51 80 00       	mov    %eax,0x805148
  803613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803616:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80361c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80361f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803626:	a1 54 51 80 00       	mov    0x805154,%eax
  80362b:	48                   	dec    %eax
  80362c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803634:	8b 40 08             	mov    0x8(%eax),%eax
  803637:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80363c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363f:	8b 50 08             	mov    0x8(%eax),%edx
  803642:	8b 45 08             	mov    0x8(%ebp),%eax
  803645:	01 c2                	add    %eax,%edx
  803647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803650:	8b 40 0c             	mov    0xc(%eax),%eax
  803653:	2b 45 08             	sub    0x8(%ebp),%eax
  803656:	89 c2                	mov    %eax,%edx
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80365e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803661:	eb 3b                	jmp    80369e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803663:	a1 40 51 80 00       	mov    0x805140,%eax
  803668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80366b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80366f:	74 07                	je     803678 <alloc_block_NF+0x5a5>
  803671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803674:	8b 00                	mov    (%eax),%eax
  803676:	eb 05                	jmp    80367d <alloc_block_NF+0x5aa>
  803678:	b8 00 00 00 00       	mov    $0x0,%eax
  80367d:	a3 40 51 80 00       	mov    %eax,0x805140
  803682:	a1 40 51 80 00       	mov    0x805140,%eax
  803687:	85 c0                	test   %eax,%eax
  803689:	0f 85 2e fe ff ff    	jne    8034bd <alloc_block_NF+0x3ea>
  80368f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803693:	0f 85 24 fe ff ff    	jne    8034bd <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80369e:	c9                   	leave  
  80369f:	c3                   	ret    

008036a0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8036a0:	55                   	push   %ebp
  8036a1:	89 e5                	mov    %esp,%ebp
  8036a3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8036a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8036ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8036ae:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036b3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8036b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8036bb:	85 c0                	test   %eax,%eax
  8036bd:	74 14                	je     8036d3 <insert_sorted_with_merge_freeList+0x33>
  8036bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c2:	8b 50 08             	mov    0x8(%eax),%edx
  8036c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c8:	8b 40 08             	mov    0x8(%eax),%eax
  8036cb:	39 c2                	cmp    %eax,%edx
  8036cd:	0f 87 9b 01 00 00    	ja     80386e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8036d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036d7:	75 17                	jne    8036f0 <insert_sorted_with_merge_freeList+0x50>
  8036d9:	83 ec 04             	sub    $0x4,%esp
  8036dc:	68 38 4c 80 00       	push   $0x804c38
  8036e1:	68 38 01 00 00       	push   $0x138
  8036e6:	68 5b 4c 80 00       	push   $0x804c5b
  8036eb:	e8 97 d5 ff ff       	call   800c87 <_panic>
  8036f0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8036f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f9:	89 10                	mov    %edx,(%eax)
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	8b 00                	mov    (%eax),%eax
  803700:	85 c0                	test   %eax,%eax
  803702:	74 0d                	je     803711 <insert_sorted_with_merge_freeList+0x71>
  803704:	a1 38 51 80 00       	mov    0x805138,%eax
  803709:	8b 55 08             	mov    0x8(%ebp),%edx
  80370c:	89 50 04             	mov    %edx,0x4(%eax)
  80370f:	eb 08                	jmp    803719 <insert_sorted_with_merge_freeList+0x79>
  803711:	8b 45 08             	mov    0x8(%ebp),%eax
  803714:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803719:	8b 45 08             	mov    0x8(%ebp),%eax
  80371c:	a3 38 51 80 00       	mov    %eax,0x805138
  803721:	8b 45 08             	mov    0x8(%ebp),%eax
  803724:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372b:	a1 44 51 80 00       	mov    0x805144,%eax
  803730:	40                   	inc    %eax
  803731:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803736:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80373a:	0f 84 a8 06 00 00    	je     803de8 <insert_sorted_with_merge_freeList+0x748>
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	8b 50 08             	mov    0x8(%eax),%edx
  803746:	8b 45 08             	mov    0x8(%ebp),%eax
  803749:	8b 40 0c             	mov    0xc(%eax),%eax
  80374c:	01 c2                	add    %eax,%edx
  80374e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803751:	8b 40 08             	mov    0x8(%eax),%eax
  803754:	39 c2                	cmp    %eax,%edx
  803756:	0f 85 8c 06 00 00    	jne    803de8 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80375c:	8b 45 08             	mov    0x8(%ebp),%eax
  80375f:	8b 50 0c             	mov    0xc(%eax),%edx
  803762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803765:	8b 40 0c             	mov    0xc(%eax),%eax
  803768:	01 c2                	add    %eax,%edx
  80376a:	8b 45 08             	mov    0x8(%ebp),%eax
  80376d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803770:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803774:	75 17                	jne    80378d <insert_sorted_with_merge_freeList+0xed>
  803776:	83 ec 04             	sub    $0x4,%esp
  803779:	68 04 4d 80 00       	push   $0x804d04
  80377e:	68 3c 01 00 00       	push   $0x13c
  803783:	68 5b 4c 80 00       	push   $0x804c5b
  803788:	e8 fa d4 ff ff       	call   800c87 <_panic>
  80378d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803790:	8b 00                	mov    (%eax),%eax
  803792:	85 c0                	test   %eax,%eax
  803794:	74 10                	je     8037a6 <insert_sorted_with_merge_freeList+0x106>
  803796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803799:	8b 00                	mov    (%eax),%eax
  80379b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80379e:	8b 52 04             	mov    0x4(%edx),%edx
  8037a1:	89 50 04             	mov    %edx,0x4(%eax)
  8037a4:	eb 0b                	jmp    8037b1 <insert_sorted_with_merge_freeList+0x111>
  8037a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b4:	8b 40 04             	mov    0x4(%eax),%eax
  8037b7:	85 c0                	test   %eax,%eax
  8037b9:	74 0f                	je     8037ca <insert_sorted_with_merge_freeList+0x12a>
  8037bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037be:	8b 40 04             	mov    0x4(%eax),%eax
  8037c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037c4:	8b 12                	mov    (%edx),%edx
  8037c6:	89 10                	mov    %edx,(%eax)
  8037c8:	eb 0a                	jmp    8037d4 <insert_sorted_with_merge_freeList+0x134>
  8037ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037cd:	8b 00                	mov    (%eax),%eax
  8037cf:	a3 38 51 80 00       	mov    %eax,0x805138
  8037d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e7:	a1 44 51 80 00       	mov    0x805144,%eax
  8037ec:	48                   	dec    %eax
  8037ed:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8037f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8037fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803806:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80380a:	75 17                	jne    803823 <insert_sorted_with_merge_freeList+0x183>
  80380c:	83 ec 04             	sub    $0x4,%esp
  80380f:	68 38 4c 80 00       	push   $0x804c38
  803814:	68 3f 01 00 00       	push   $0x13f
  803819:	68 5b 4c 80 00       	push   $0x804c5b
  80381e:	e8 64 d4 ff ff       	call   800c87 <_panic>
  803823:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382c:	89 10                	mov    %edx,(%eax)
  80382e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803831:	8b 00                	mov    (%eax),%eax
  803833:	85 c0                	test   %eax,%eax
  803835:	74 0d                	je     803844 <insert_sorted_with_merge_freeList+0x1a4>
  803837:	a1 48 51 80 00       	mov    0x805148,%eax
  80383c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80383f:	89 50 04             	mov    %edx,0x4(%eax)
  803842:	eb 08                	jmp    80384c <insert_sorted_with_merge_freeList+0x1ac>
  803844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803847:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80384c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384f:	a3 48 51 80 00       	mov    %eax,0x805148
  803854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803857:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385e:	a1 54 51 80 00       	mov    0x805154,%eax
  803863:	40                   	inc    %eax
  803864:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803869:	e9 7a 05 00 00       	jmp    803de8 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80386e:	8b 45 08             	mov    0x8(%ebp),%eax
  803871:	8b 50 08             	mov    0x8(%eax),%edx
  803874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803877:	8b 40 08             	mov    0x8(%eax),%eax
  80387a:	39 c2                	cmp    %eax,%edx
  80387c:	0f 82 14 01 00 00    	jb     803996 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803885:	8b 50 08             	mov    0x8(%eax),%edx
  803888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80388b:	8b 40 0c             	mov    0xc(%eax),%eax
  80388e:	01 c2                	add    %eax,%edx
  803890:	8b 45 08             	mov    0x8(%ebp),%eax
  803893:	8b 40 08             	mov    0x8(%eax),%eax
  803896:	39 c2                	cmp    %eax,%edx
  803898:	0f 85 90 00 00 00    	jne    80392e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80389e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8038a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8038aa:	01 c2                	add    %eax,%edx
  8038ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038af:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8038b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8038bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ca:	75 17                	jne    8038e3 <insert_sorted_with_merge_freeList+0x243>
  8038cc:	83 ec 04             	sub    $0x4,%esp
  8038cf:	68 38 4c 80 00       	push   $0x804c38
  8038d4:	68 49 01 00 00       	push   $0x149
  8038d9:	68 5b 4c 80 00       	push   $0x804c5b
  8038de:	e8 a4 d3 ff ff       	call   800c87 <_panic>
  8038e3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ec:	89 10                	mov    %edx,(%eax)
  8038ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	85 c0                	test   %eax,%eax
  8038f5:	74 0d                	je     803904 <insert_sorted_with_merge_freeList+0x264>
  8038f7:	a1 48 51 80 00       	mov    0x805148,%eax
  8038fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ff:	89 50 04             	mov    %edx,0x4(%eax)
  803902:	eb 08                	jmp    80390c <insert_sorted_with_merge_freeList+0x26c>
  803904:	8b 45 08             	mov    0x8(%ebp),%eax
  803907:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	a3 48 51 80 00       	mov    %eax,0x805148
  803914:	8b 45 08             	mov    0x8(%ebp),%eax
  803917:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80391e:	a1 54 51 80 00       	mov    0x805154,%eax
  803923:	40                   	inc    %eax
  803924:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803929:	e9 bb 04 00 00       	jmp    803de9 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80392e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803932:	75 17                	jne    80394b <insert_sorted_with_merge_freeList+0x2ab>
  803934:	83 ec 04             	sub    $0x4,%esp
  803937:	68 ac 4c 80 00       	push   $0x804cac
  80393c:	68 4c 01 00 00       	push   $0x14c
  803941:	68 5b 4c 80 00       	push   $0x804c5b
  803946:	e8 3c d3 ff ff       	call   800c87 <_panic>
  80394b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803951:	8b 45 08             	mov    0x8(%ebp),%eax
  803954:	89 50 04             	mov    %edx,0x4(%eax)
  803957:	8b 45 08             	mov    0x8(%ebp),%eax
  80395a:	8b 40 04             	mov    0x4(%eax),%eax
  80395d:	85 c0                	test   %eax,%eax
  80395f:	74 0c                	je     80396d <insert_sorted_with_merge_freeList+0x2cd>
  803961:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803966:	8b 55 08             	mov    0x8(%ebp),%edx
  803969:	89 10                	mov    %edx,(%eax)
  80396b:	eb 08                	jmp    803975 <insert_sorted_with_merge_freeList+0x2d5>
  80396d:	8b 45 08             	mov    0x8(%ebp),%eax
  803970:	a3 38 51 80 00       	mov    %eax,0x805138
  803975:	8b 45 08             	mov    0x8(%ebp),%eax
  803978:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80397d:	8b 45 08             	mov    0x8(%ebp),%eax
  803980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803986:	a1 44 51 80 00       	mov    0x805144,%eax
  80398b:	40                   	inc    %eax
  80398c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803991:	e9 53 04 00 00       	jmp    803de9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803996:	a1 38 51 80 00       	mov    0x805138,%eax
  80399b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80399e:	e9 15 04 00 00       	jmp    803db8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8039a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a6:	8b 00                	mov    (%eax),%eax
  8039a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8039ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ae:	8b 50 08             	mov    0x8(%eax),%edx
  8039b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b4:	8b 40 08             	mov    0x8(%eax),%eax
  8039b7:	39 c2                	cmp    %eax,%edx
  8039b9:	0f 86 f1 03 00 00    	jbe    803db0 <insert_sorted_with_merge_freeList+0x710>
  8039bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c2:	8b 50 08             	mov    0x8(%eax),%edx
  8039c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c8:	8b 40 08             	mov    0x8(%eax),%eax
  8039cb:	39 c2                	cmp    %eax,%edx
  8039cd:	0f 83 dd 03 00 00    	jae    803db0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8039d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d6:	8b 50 08             	mov    0x8(%eax),%edx
  8039d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8039df:	01 c2                	add    %eax,%edx
  8039e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e4:	8b 40 08             	mov    0x8(%eax),%eax
  8039e7:	39 c2                	cmp    %eax,%edx
  8039e9:	0f 85 b9 01 00 00    	jne    803ba8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8039ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f2:	8b 50 08             	mov    0x8(%eax),%edx
  8039f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8039fb:	01 c2                	add    %eax,%edx
  8039fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a00:	8b 40 08             	mov    0x8(%eax),%eax
  803a03:	39 c2                	cmp    %eax,%edx
  803a05:	0f 85 0d 01 00 00    	jne    803b18 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0e:	8b 50 0c             	mov    0xc(%eax),%edx
  803a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a14:	8b 40 0c             	mov    0xc(%eax),%eax
  803a17:	01 c2                	add    %eax,%edx
  803a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803a1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a23:	75 17                	jne    803a3c <insert_sorted_with_merge_freeList+0x39c>
  803a25:	83 ec 04             	sub    $0x4,%esp
  803a28:	68 04 4d 80 00       	push   $0x804d04
  803a2d:	68 5c 01 00 00       	push   $0x15c
  803a32:	68 5b 4c 80 00       	push   $0x804c5b
  803a37:	e8 4b d2 ff ff       	call   800c87 <_panic>
  803a3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3f:	8b 00                	mov    (%eax),%eax
  803a41:	85 c0                	test   %eax,%eax
  803a43:	74 10                	je     803a55 <insert_sorted_with_merge_freeList+0x3b5>
  803a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a48:	8b 00                	mov    (%eax),%eax
  803a4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a4d:	8b 52 04             	mov    0x4(%edx),%edx
  803a50:	89 50 04             	mov    %edx,0x4(%eax)
  803a53:	eb 0b                	jmp    803a60 <insert_sorted_with_merge_freeList+0x3c0>
  803a55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a58:	8b 40 04             	mov    0x4(%eax),%eax
  803a5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a63:	8b 40 04             	mov    0x4(%eax),%eax
  803a66:	85 c0                	test   %eax,%eax
  803a68:	74 0f                	je     803a79 <insert_sorted_with_merge_freeList+0x3d9>
  803a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6d:	8b 40 04             	mov    0x4(%eax),%eax
  803a70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a73:	8b 12                	mov    (%edx),%edx
  803a75:	89 10                	mov    %edx,(%eax)
  803a77:	eb 0a                	jmp    803a83 <insert_sorted_with_merge_freeList+0x3e3>
  803a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7c:	8b 00                	mov    (%eax),%eax
  803a7e:	a3 38 51 80 00       	mov    %eax,0x805138
  803a83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a96:	a1 44 51 80 00       	mov    0x805144,%eax
  803a9b:	48                   	dec    %eax
  803a9c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803aab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803ab5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ab9:	75 17                	jne    803ad2 <insert_sorted_with_merge_freeList+0x432>
  803abb:	83 ec 04             	sub    $0x4,%esp
  803abe:	68 38 4c 80 00       	push   $0x804c38
  803ac3:	68 5f 01 00 00       	push   $0x15f
  803ac8:	68 5b 4c 80 00       	push   $0x804c5b
  803acd:	e8 b5 d1 ff ff       	call   800c87 <_panic>
  803ad2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ad8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803adb:	89 10                	mov    %edx,(%eax)
  803add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae0:	8b 00                	mov    (%eax),%eax
  803ae2:	85 c0                	test   %eax,%eax
  803ae4:	74 0d                	je     803af3 <insert_sorted_with_merge_freeList+0x453>
  803ae6:	a1 48 51 80 00       	mov    0x805148,%eax
  803aeb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803aee:	89 50 04             	mov    %edx,0x4(%eax)
  803af1:	eb 08                	jmp    803afb <insert_sorted_with_merge_freeList+0x45b>
  803af3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803afe:	a3 48 51 80 00       	mov    %eax,0x805148
  803b03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b0d:	a1 54 51 80 00       	mov    0x805154,%eax
  803b12:	40                   	inc    %eax
  803b13:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1b:	8b 50 0c             	mov    0xc(%eax),%edx
  803b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b21:	8b 40 0c             	mov    0xc(%eax),%eax
  803b24:	01 c2                	add    %eax,%edx
  803b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b29:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803b36:	8b 45 08             	mov    0x8(%ebp),%eax
  803b39:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b44:	75 17                	jne    803b5d <insert_sorted_with_merge_freeList+0x4bd>
  803b46:	83 ec 04             	sub    $0x4,%esp
  803b49:	68 38 4c 80 00       	push   $0x804c38
  803b4e:	68 64 01 00 00       	push   $0x164
  803b53:	68 5b 4c 80 00       	push   $0x804c5b
  803b58:	e8 2a d1 ff ff       	call   800c87 <_panic>
  803b5d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b63:	8b 45 08             	mov    0x8(%ebp),%eax
  803b66:	89 10                	mov    %edx,(%eax)
  803b68:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6b:	8b 00                	mov    (%eax),%eax
  803b6d:	85 c0                	test   %eax,%eax
  803b6f:	74 0d                	je     803b7e <insert_sorted_with_merge_freeList+0x4de>
  803b71:	a1 48 51 80 00       	mov    0x805148,%eax
  803b76:	8b 55 08             	mov    0x8(%ebp),%edx
  803b79:	89 50 04             	mov    %edx,0x4(%eax)
  803b7c:	eb 08                	jmp    803b86 <insert_sorted_with_merge_freeList+0x4e6>
  803b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b81:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b86:	8b 45 08             	mov    0x8(%ebp),%eax
  803b89:	a3 48 51 80 00       	mov    %eax,0x805148
  803b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b98:	a1 54 51 80 00       	mov    0x805154,%eax
  803b9d:	40                   	inc    %eax
  803b9e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ba3:	e9 41 02 00 00       	jmp    803de9 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bab:	8b 50 08             	mov    0x8(%eax),%edx
  803bae:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb1:	8b 40 0c             	mov    0xc(%eax),%eax
  803bb4:	01 c2                	add    %eax,%edx
  803bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb9:	8b 40 08             	mov    0x8(%eax),%eax
  803bbc:	39 c2                	cmp    %eax,%edx
  803bbe:	0f 85 7c 01 00 00    	jne    803d40 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803bc4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bc8:	74 06                	je     803bd0 <insert_sorted_with_merge_freeList+0x530>
  803bca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bce:	75 17                	jne    803be7 <insert_sorted_with_merge_freeList+0x547>
  803bd0:	83 ec 04             	sub    $0x4,%esp
  803bd3:	68 74 4c 80 00       	push   $0x804c74
  803bd8:	68 69 01 00 00       	push   $0x169
  803bdd:	68 5b 4c 80 00       	push   $0x804c5b
  803be2:	e8 a0 d0 ff ff       	call   800c87 <_panic>
  803be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bea:	8b 50 04             	mov    0x4(%eax),%edx
  803bed:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf0:	89 50 04             	mov    %edx,0x4(%eax)
  803bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bf9:	89 10                	mov    %edx,(%eax)
  803bfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bfe:	8b 40 04             	mov    0x4(%eax),%eax
  803c01:	85 c0                	test   %eax,%eax
  803c03:	74 0d                	je     803c12 <insert_sorted_with_merge_freeList+0x572>
  803c05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c08:	8b 40 04             	mov    0x4(%eax),%eax
  803c0b:	8b 55 08             	mov    0x8(%ebp),%edx
  803c0e:	89 10                	mov    %edx,(%eax)
  803c10:	eb 08                	jmp    803c1a <insert_sorted_with_merge_freeList+0x57a>
  803c12:	8b 45 08             	mov    0x8(%ebp),%eax
  803c15:	a3 38 51 80 00       	mov    %eax,0x805138
  803c1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c1d:	8b 55 08             	mov    0x8(%ebp),%edx
  803c20:	89 50 04             	mov    %edx,0x4(%eax)
  803c23:	a1 44 51 80 00       	mov    0x805144,%eax
  803c28:	40                   	inc    %eax
  803c29:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c31:	8b 50 0c             	mov    0xc(%eax),%edx
  803c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c37:	8b 40 0c             	mov    0xc(%eax),%eax
  803c3a:	01 c2                	add    %eax,%edx
  803c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803c42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c46:	75 17                	jne    803c5f <insert_sorted_with_merge_freeList+0x5bf>
  803c48:	83 ec 04             	sub    $0x4,%esp
  803c4b:	68 04 4d 80 00       	push   $0x804d04
  803c50:	68 6b 01 00 00       	push   $0x16b
  803c55:	68 5b 4c 80 00       	push   $0x804c5b
  803c5a:	e8 28 d0 ff ff       	call   800c87 <_panic>
  803c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c62:	8b 00                	mov    (%eax),%eax
  803c64:	85 c0                	test   %eax,%eax
  803c66:	74 10                	je     803c78 <insert_sorted_with_merge_freeList+0x5d8>
  803c68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6b:	8b 00                	mov    (%eax),%eax
  803c6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c70:	8b 52 04             	mov    0x4(%edx),%edx
  803c73:	89 50 04             	mov    %edx,0x4(%eax)
  803c76:	eb 0b                	jmp    803c83 <insert_sorted_with_merge_freeList+0x5e3>
  803c78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c7b:	8b 40 04             	mov    0x4(%eax),%eax
  803c7e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c86:	8b 40 04             	mov    0x4(%eax),%eax
  803c89:	85 c0                	test   %eax,%eax
  803c8b:	74 0f                	je     803c9c <insert_sorted_with_merge_freeList+0x5fc>
  803c8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c90:	8b 40 04             	mov    0x4(%eax),%eax
  803c93:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c96:	8b 12                	mov    (%edx),%edx
  803c98:	89 10                	mov    %edx,(%eax)
  803c9a:	eb 0a                	jmp    803ca6 <insert_sorted_with_merge_freeList+0x606>
  803c9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c9f:	8b 00                	mov    (%eax),%eax
  803ca1:	a3 38 51 80 00       	mov    %eax,0x805138
  803ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803caf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cb9:	a1 44 51 80 00       	mov    0x805144,%eax
  803cbe:	48                   	dec    %eax
  803cbf:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803cc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803cce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803cd8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cdc:	75 17                	jne    803cf5 <insert_sorted_with_merge_freeList+0x655>
  803cde:	83 ec 04             	sub    $0x4,%esp
  803ce1:	68 38 4c 80 00       	push   $0x804c38
  803ce6:	68 6e 01 00 00       	push   $0x16e
  803ceb:	68 5b 4c 80 00       	push   $0x804c5b
  803cf0:	e8 92 cf ff ff       	call   800c87 <_panic>
  803cf5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803cfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cfe:	89 10                	mov    %edx,(%eax)
  803d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d03:	8b 00                	mov    (%eax),%eax
  803d05:	85 c0                	test   %eax,%eax
  803d07:	74 0d                	je     803d16 <insert_sorted_with_merge_freeList+0x676>
  803d09:	a1 48 51 80 00       	mov    0x805148,%eax
  803d0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d11:	89 50 04             	mov    %edx,0x4(%eax)
  803d14:	eb 08                	jmp    803d1e <insert_sorted_with_merge_freeList+0x67e>
  803d16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d19:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d21:	a3 48 51 80 00       	mov    %eax,0x805148
  803d26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d30:	a1 54 51 80 00       	mov    0x805154,%eax
  803d35:	40                   	inc    %eax
  803d36:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803d3b:	e9 a9 00 00 00       	jmp    803de9 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803d40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d44:	74 06                	je     803d4c <insert_sorted_with_merge_freeList+0x6ac>
  803d46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d4a:	75 17                	jne    803d63 <insert_sorted_with_merge_freeList+0x6c3>
  803d4c:	83 ec 04             	sub    $0x4,%esp
  803d4f:	68 d0 4c 80 00       	push   $0x804cd0
  803d54:	68 73 01 00 00       	push   $0x173
  803d59:	68 5b 4c 80 00       	push   $0x804c5b
  803d5e:	e8 24 cf ff ff       	call   800c87 <_panic>
  803d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d66:	8b 10                	mov    (%eax),%edx
  803d68:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6b:	89 10                	mov    %edx,(%eax)
  803d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d70:	8b 00                	mov    (%eax),%eax
  803d72:	85 c0                	test   %eax,%eax
  803d74:	74 0b                	je     803d81 <insert_sorted_with_merge_freeList+0x6e1>
  803d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d79:	8b 00                	mov    (%eax),%eax
  803d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  803d7e:	89 50 04             	mov    %edx,0x4(%eax)
  803d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d84:	8b 55 08             	mov    0x8(%ebp),%edx
  803d87:	89 10                	mov    %edx,(%eax)
  803d89:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d8f:	89 50 04             	mov    %edx,0x4(%eax)
  803d92:	8b 45 08             	mov    0x8(%ebp),%eax
  803d95:	8b 00                	mov    (%eax),%eax
  803d97:	85 c0                	test   %eax,%eax
  803d99:	75 08                	jne    803da3 <insert_sorted_with_merge_freeList+0x703>
  803d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803da3:	a1 44 51 80 00       	mov    0x805144,%eax
  803da8:	40                   	inc    %eax
  803da9:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803dae:	eb 39                	jmp    803de9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803db0:	a1 40 51 80 00       	mov    0x805140,%eax
  803db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803db8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dbc:	74 07                	je     803dc5 <insert_sorted_with_merge_freeList+0x725>
  803dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc1:	8b 00                	mov    (%eax),%eax
  803dc3:	eb 05                	jmp    803dca <insert_sorted_with_merge_freeList+0x72a>
  803dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  803dca:	a3 40 51 80 00       	mov    %eax,0x805140
  803dcf:	a1 40 51 80 00       	mov    0x805140,%eax
  803dd4:	85 c0                	test   %eax,%eax
  803dd6:	0f 85 c7 fb ff ff    	jne    8039a3 <insert_sorted_with_merge_freeList+0x303>
  803ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803de0:	0f 85 bd fb ff ff    	jne    8039a3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803de6:	eb 01                	jmp    803de9 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803de8:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803de9:	90                   	nop
  803dea:	c9                   	leave  
  803deb:	c3                   	ret    

00803dec <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803dec:	55                   	push   %ebp
  803ded:	89 e5                	mov    %esp,%ebp
  803def:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803df2:	8b 55 08             	mov    0x8(%ebp),%edx
  803df5:	89 d0                	mov    %edx,%eax
  803df7:	c1 e0 02             	shl    $0x2,%eax
  803dfa:	01 d0                	add    %edx,%eax
  803dfc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803e03:	01 d0                	add    %edx,%eax
  803e05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803e0c:	01 d0                	add    %edx,%eax
  803e0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803e15:	01 d0                	add    %edx,%eax
  803e17:	c1 e0 04             	shl    $0x4,%eax
  803e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803e1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803e24:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803e27:	83 ec 0c             	sub    $0xc,%esp
  803e2a:	50                   	push   %eax
  803e2b:	e8 26 e7 ff ff       	call   802556 <sys_get_virtual_time>
  803e30:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803e33:	eb 41                	jmp    803e76 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803e35:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803e38:	83 ec 0c             	sub    $0xc,%esp
  803e3b:	50                   	push   %eax
  803e3c:	e8 15 e7 ff ff       	call   802556 <sys_get_virtual_time>
  803e41:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803e44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e4a:	29 c2                	sub    %eax,%edx
  803e4c:	89 d0                	mov    %edx,%eax
  803e4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803e51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e57:	89 d1                	mov    %edx,%ecx
  803e59:	29 c1                	sub    %eax,%ecx
  803e5b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803e5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e61:	39 c2                	cmp    %eax,%edx
  803e63:	0f 97 c0             	seta   %al
  803e66:	0f b6 c0             	movzbl %al,%eax
  803e69:	29 c1                	sub    %eax,%ecx
  803e6b:	89 c8                	mov    %ecx,%eax
  803e6d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803e70:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e79:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803e7c:	72 b7                	jb     803e35 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803e7e:	90                   	nop
  803e7f:	c9                   	leave  
  803e80:	c3                   	ret    

00803e81 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803e81:	55                   	push   %ebp
  803e82:	89 e5                	mov    %esp,%ebp
  803e84:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803e87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803e8e:	eb 03                	jmp    803e93 <busy_wait+0x12>
  803e90:	ff 45 fc             	incl   -0x4(%ebp)
  803e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803e96:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e99:	72 f5                	jb     803e90 <busy_wait+0xf>
	return i;
  803e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803e9e:	c9                   	leave  
  803e9f:	c3                   	ret    

00803ea0 <__udivdi3>:
  803ea0:	55                   	push   %ebp
  803ea1:	57                   	push   %edi
  803ea2:	56                   	push   %esi
  803ea3:	53                   	push   %ebx
  803ea4:	83 ec 1c             	sub    $0x1c,%esp
  803ea7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803eab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803eaf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803eb3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803eb7:	89 ca                	mov    %ecx,%edx
  803eb9:	89 f8                	mov    %edi,%eax
  803ebb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ebf:	85 f6                	test   %esi,%esi
  803ec1:	75 2d                	jne    803ef0 <__udivdi3+0x50>
  803ec3:	39 cf                	cmp    %ecx,%edi
  803ec5:	77 65                	ja     803f2c <__udivdi3+0x8c>
  803ec7:	89 fd                	mov    %edi,%ebp
  803ec9:	85 ff                	test   %edi,%edi
  803ecb:	75 0b                	jne    803ed8 <__udivdi3+0x38>
  803ecd:	b8 01 00 00 00       	mov    $0x1,%eax
  803ed2:	31 d2                	xor    %edx,%edx
  803ed4:	f7 f7                	div    %edi
  803ed6:	89 c5                	mov    %eax,%ebp
  803ed8:	31 d2                	xor    %edx,%edx
  803eda:	89 c8                	mov    %ecx,%eax
  803edc:	f7 f5                	div    %ebp
  803ede:	89 c1                	mov    %eax,%ecx
  803ee0:	89 d8                	mov    %ebx,%eax
  803ee2:	f7 f5                	div    %ebp
  803ee4:	89 cf                	mov    %ecx,%edi
  803ee6:	89 fa                	mov    %edi,%edx
  803ee8:	83 c4 1c             	add    $0x1c,%esp
  803eeb:	5b                   	pop    %ebx
  803eec:	5e                   	pop    %esi
  803eed:	5f                   	pop    %edi
  803eee:	5d                   	pop    %ebp
  803eef:	c3                   	ret    
  803ef0:	39 ce                	cmp    %ecx,%esi
  803ef2:	77 28                	ja     803f1c <__udivdi3+0x7c>
  803ef4:	0f bd fe             	bsr    %esi,%edi
  803ef7:	83 f7 1f             	xor    $0x1f,%edi
  803efa:	75 40                	jne    803f3c <__udivdi3+0x9c>
  803efc:	39 ce                	cmp    %ecx,%esi
  803efe:	72 0a                	jb     803f0a <__udivdi3+0x6a>
  803f00:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f04:	0f 87 9e 00 00 00    	ja     803fa8 <__udivdi3+0x108>
  803f0a:	b8 01 00 00 00       	mov    $0x1,%eax
  803f0f:	89 fa                	mov    %edi,%edx
  803f11:	83 c4 1c             	add    $0x1c,%esp
  803f14:	5b                   	pop    %ebx
  803f15:	5e                   	pop    %esi
  803f16:	5f                   	pop    %edi
  803f17:	5d                   	pop    %ebp
  803f18:	c3                   	ret    
  803f19:	8d 76 00             	lea    0x0(%esi),%esi
  803f1c:	31 ff                	xor    %edi,%edi
  803f1e:	31 c0                	xor    %eax,%eax
  803f20:	89 fa                	mov    %edi,%edx
  803f22:	83 c4 1c             	add    $0x1c,%esp
  803f25:	5b                   	pop    %ebx
  803f26:	5e                   	pop    %esi
  803f27:	5f                   	pop    %edi
  803f28:	5d                   	pop    %ebp
  803f29:	c3                   	ret    
  803f2a:	66 90                	xchg   %ax,%ax
  803f2c:	89 d8                	mov    %ebx,%eax
  803f2e:	f7 f7                	div    %edi
  803f30:	31 ff                	xor    %edi,%edi
  803f32:	89 fa                	mov    %edi,%edx
  803f34:	83 c4 1c             	add    $0x1c,%esp
  803f37:	5b                   	pop    %ebx
  803f38:	5e                   	pop    %esi
  803f39:	5f                   	pop    %edi
  803f3a:	5d                   	pop    %ebp
  803f3b:	c3                   	ret    
  803f3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f41:	89 eb                	mov    %ebp,%ebx
  803f43:	29 fb                	sub    %edi,%ebx
  803f45:	89 f9                	mov    %edi,%ecx
  803f47:	d3 e6                	shl    %cl,%esi
  803f49:	89 c5                	mov    %eax,%ebp
  803f4b:	88 d9                	mov    %bl,%cl
  803f4d:	d3 ed                	shr    %cl,%ebp
  803f4f:	89 e9                	mov    %ebp,%ecx
  803f51:	09 f1                	or     %esi,%ecx
  803f53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f57:	89 f9                	mov    %edi,%ecx
  803f59:	d3 e0                	shl    %cl,%eax
  803f5b:	89 c5                	mov    %eax,%ebp
  803f5d:	89 d6                	mov    %edx,%esi
  803f5f:	88 d9                	mov    %bl,%cl
  803f61:	d3 ee                	shr    %cl,%esi
  803f63:	89 f9                	mov    %edi,%ecx
  803f65:	d3 e2                	shl    %cl,%edx
  803f67:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f6b:	88 d9                	mov    %bl,%cl
  803f6d:	d3 e8                	shr    %cl,%eax
  803f6f:	09 c2                	or     %eax,%edx
  803f71:	89 d0                	mov    %edx,%eax
  803f73:	89 f2                	mov    %esi,%edx
  803f75:	f7 74 24 0c          	divl   0xc(%esp)
  803f79:	89 d6                	mov    %edx,%esi
  803f7b:	89 c3                	mov    %eax,%ebx
  803f7d:	f7 e5                	mul    %ebp
  803f7f:	39 d6                	cmp    %edx,%esi
  803f81:	72 19                	jb     803f9c <__udivdi3+0xfc>
  803f83:	74 0b                	je     803f90 <__udivdi3+0xf0>
  803f85:	89 d8                	mov    %ebx,%eax
  803f87:	31 ff                	xor    %edi,%edi
  803f89:	e9 58 ff ff ff       	jmp    803ee6 <__udivdi3+0x46>
  803f8e:	66 90                	xchg   %ax,%ax
  803f90:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f94:	89 f9                	mov    %edi,%ecx
  803f96:	d3 e2                	shl    %cl,%edx
  803f98:	39 c2                	cmp    %eax,%edx
  803f9a:	73 e9                	jae    803f85 <__udivdi3+0xe5>
  803f9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f9f:	31 ff                	xor    %edi,%edi
  803fa1:	e9 40 ff ff ff       	jmp    803ee6 <__udivdi3+0x46>
  803fa6:	66 90                	xchg   %ax,%ax
  803fa8:	31 c0                	xor    %eax,%eax
  803faa:	e9 37 ff ff ff       	jmp    803ee6 <__udivdi3+0x46>
  803faf:	90                   	nop

00803fb0 <__umoddi3>:
  803fb0:	55                   	push   %ebp
  803fb1:	57                   	push   %edi
  803fb2:	56                   	push   %esi
  803fb3:	53                   	push   %ebx
  803fb4:	83 ec 1c             	sub    $0x1c,%esp
  803fb7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803fbb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803fbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fc3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fcb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fcf:	89 f3                	mov    %esi,%ebx
  803fd1:	89 fa                	mov    %edi,%edx
  803fd3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fd7:	89 34 24             	mov    %esi,(%esp)
  803fda:	85 c0                	test   %eax,%eax
  803fdc:	75 1a                	jne    803ff8 <__umoddi3+0x48>
  803fde:	39 f7                	cmp    %esi,%edi
  803fe0:	0f 86 a2 00 00 00    	jbe    804088 <__umoddi3+0xd8>
  803fe6:	89 c8                	mov    %ecx,%eax
  803fe8:	89 f2                	mov    %esi,%edx
  803fea:	f7 f7                	div    %edi
  803fec:	89 d0                	mov    %edx,%eax
  803fee:	31 d2                	xor    %edx,%edx
  803ff0:	83 c4 1c             	add    $0x1c,%esp
  803ff3:	5b                   	pop    %ebx
  803ff4:	5e                   	pop    %esi
  803ff5:	5f                   	pop    %edi
  803ff6:	5d                   	pop    %ebp
  803ff7:	c3                   	ret    
  803ff8:	39 f0                	cmp    %esi,%eax
  803ffa:	0f 87 ac 00 00 00    	ja     8040ac <__umoddi3+0xfc>
  804000:	0f bd e8             	bsr    %eax,%ebp
  804003:	83 f5 1f             	xor    $0x1f,%ebp
  804006:	0f 84 ac 00 00 00    	je     8040b8 <__umoddi3+0x108>
  80400c:	bf 20 00 00 00       	mov    $0x20,%edi
  804011:	29 ef                	sub    %ebp,%edi
  804013:	89 fe                	mov    %edi,%esi
  804015:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804019:	89 e9                	mov    %ebp,%ecx
  80401b:	d3 e0                	shl    %cl,%eax
  80401d:	89 d7                	mov    %edx,%edi
  80401f:	89 f1                	mov    %esi,%ecx
  804021:	d3 ef                	shr    %cl,%edi
  804023:	09 c7                	or     %eax,%edi
  804025:	89 e9                	mov    %ebp,%ecx
  804027:	d3 e2                	shl    %cl,%edx
  804029:	89 14 24             	mov    %edx,(%esp)
  80402c:	89 d8                	mov    %ebx,%eax
  80402e:	d3 e0                	shl    %cl,%eax
  804030:	89 c2                	mov    %eax,%edx
  804032:	8b 44 24 08          	mov    0x8(%esp),%eax
  804036:	d3 e0                	shl    %cl,%eax
  804038:	89 44 24 04          	mov    %eax,0x4(%esp)
  80403c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804040:	89 f1                	mov    %esi,%ecx
  804042:	d3 e8                	shr    %cl,%eax
  804044:	09 d0                	or     %edx,%eax
  804046:	d3 eb                	shr    %cl,%ebx
  804048:	89 da                	mov    %ebx,%edx
  80404a:	f7 f7                	div    %edi
  80404c:	89 d3                	mov    %edx,%ebx
  80404e:	f7 24 24             	mull   (%esp)
  804051:	89 c6                	mov    %eax,%esi
  804053:	89 d1                	mov    %edx,%ecx
  804055:	39 d3                	cmp    %edx,%ebx
  804057:	0f 82 87 00 00 00    	jb     8040e4 <__umoddi3+0x134>
  80405d:	0f 84 91 00 00 00    	je     8040f4 <__umoddi3+0x144>
  804063:	8b 54 24 04          	mov    0x4(%esp),%edx
  804067:	29 f2                	sub    %esi,%edx
  804069:	19 cb                	sbb    %ecx,%ebx
  80406b:	89 d8                	mov    %ebx,%eax
  80406d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804071:	d3 e0                	shl    %cl,%eax
  804073:	89 e9                	mov    %ebp,%ecx
  804075:	d3 ea                	shr    %cl,%edx
  804077:	09 d0                	or     %edx,%eax
  804079:	89 e9                	mov    %ebp,%ecx
  80407b:	d3 eb                	shr    %cl,%ebx
  80407d:	89 da                	mov    %ebx,%edx
  80407f:	83 c4 1c             	add    $0x1c,%esp
  804082:	5b                   	pop    %ebx
  804083:	5e                   	pop    %esi
  804084:	5f                   	pop    %edi
  804085:	5d                   	pop    %ebp
  804086:	c3                   	ret    
  804087:	90                   	nop
  804088:	89 fd                	mov    %edi,%ebp
  80408a:	85 ff                	test   %edi,%edi
  80408c:	75 0b                	jne    804099 <__umoddi3+0xe9>
  80408e:	b8 01 00 00 00       	mov    $0x1,%eax
  804093:	31 d2                	xor    %edx,%edx
  804095:	f7 f7                	div    %edi
  804097:	89 c5                	mov    %eax,%ebp
  804099:	89 f0                	mov    %esi,%eax
  80409b:	31 d2                	xor    %edx,%edx
  80409d:	f7 f5                	div    %ebp
  80409f:	89 c8                	mov    %ecx,%eax
  8040a1:	f7 f5                	div    %ebp
  8040a3:	89 d0                	mov    %edx,%eax
  8040a5:	e9 44 ff ff ff       	jmp    803fee <__umoddi3+0x3e>
  8040aa:	66 90                	xchg   %ax,%ax
  8040ac:	89 c8                	mov    %ecx,%eax
  8040ae:	89 f2                	mov    %esi,%edx
  8040b0:	83 c4 1c             	add    $0x1c,%esp
  8040b3:	5b                   	pop    %ebx
  8040b4:	5e                   	pop    %esi
  8040b5:	5f                   	pop    %edi
  8040b6:	5d                   	pop    %ebp
  8040b7:	c3                   	ret    
  8040b8:	3b 04 24             	cmp    (%esp),%eax
  8040bb:	72 06                	jb     8040c3 <__umoddi3+0x113>
  8040bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040c1:	77 0f                	ja     8040d2 <__umoddi3+0x122>
  8040c3:	89 f2                	mov    %esi,%edx
  8040c5:	29 f9                	sub    %edi,%ecx
  8040c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040cb:	89 14 24             	mov    %edx,(%esp)
  8040ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040d6:	8b 14 24             	mov    (%esp),%edx
  8040d9:	83 c4 1c             	add    $0x1c,%esp
  8040dc:	5b                   	pop    %ebx
  8040dd:	5e                   	pop    %esi
  8040de:	5f                   	pop    %edi
  8040df:	5d                   	pop    %ebp
  8040e0:	c3                   	ret    
  8040e1:	8d 76 00             	lea    0x0(%esi),%esi
  8040e4:	2b 04 24             	sub    (%esp),%eax
  8040e7:	19 fa                	sbb    %edi,%edx
  8040e9:	89 d1                	mov    %edx,%ecx
  8040eb:	89 c6                	mov    %eax,%esi
  8040ed:	e9 71 ff ff ff       	jmp    804063 <__umoddi3+0xb3>
  8040f2:	66 90                	xchg   %ax,%ax
  8040f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040f8:	72 ea                	jb     8040e4 <__umoddi3+0x134>
  8040fa:	89 d9                	mov    %ebx,%ecx
  8040fc:	e9 62 ff ff ff       	jmp    804063 <__umoddi3+0xb3>
