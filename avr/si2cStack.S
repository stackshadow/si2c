
.include "m8515def.inc"
 
		LDI	R16, low(RAMEND)
		OUT	SPL, R16
		LDI	R16, high(RAMEND)
		OUT	SPH, R16

