// For C
#define 	SET_(typ, port, bit) typ##port |= (1<<bit)
#define 	SET(typ, port, bit) SET_(typ, port, bit) /**< Set a bit inside an register */

#define 	CLR_(typ, port, bit) typ##port &= ~(1<<bit)
#define 	CLR(typ, port, bit) CLR_(typ, port, bit) /**< Reset a bit inside an register */

#define 	IS_( port, bit) ( PIN##port & (1<<bit) )
#define 	IS( port, bit) IS_( port, bit) /**< Checks if an bit is set */

// from here we check soma basic stuff

// Of course the CPU-Speed
#ifndef F_CPU
	#warning F_CPU is not set !!!
#endif
