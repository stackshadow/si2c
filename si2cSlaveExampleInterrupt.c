/*
Copyright (C) 2014 by Martin Langlotz aka stackshadow < stackshadow at evilbrain dot de >

This file is part of si2c

si2c is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, version 3 of the License.

si2c is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with si2c.  If not, see <http://www.gnu.org/licenses/>.

This file is an example on how to use the si2c-library in you Project
*/

/**
@ingroup si2c_slave_example
@{
@anchor si2c_slave_example_interrupt

## Basic example

This example show how to use the si2c library with interrupt.

@include si2cSlaveExampleInterrupt.c

Here is the makefile for this example:
@include si2c.make

@}
*/

// Our CPU-Speed
#define F_CPU 16000000UL

// Needed header
#include "lib/si2c/si2c_config.h"
#include "lib/si2c/si2c.h"
#include "lib/si2c/si2cSlave.h"

#include <avr/interrupt.h>


main(){

// We setup an LED we would like to light up
	SET( DDR, C, 5 );
	SET( PORT, C, 5 );

// Init the BUS
	si2cInit();
	si2cReadyWait();


// Enable Interrupt for INT1
	GICR = 0<<INT0 | 1<<INT1;
	MCUCR = 0<<ISC01 | 0<<ISC00;

// enable interruot
	sei();

// Infinite loop
	while(1){
	// If Register 1 ( 0x01 in HEX ) is set to 0x01, light up the LED
		if( si2cRegister[1] == 1 ){
			CLR( PORT, C, 5 );
		} else {
			SET( PORT, C, 5 );
		}

	}

}

ISR(INT1_vect){

// Disable Interrupt
	cli();

	asm volatile ( 	"rcall si2cSlave"		"\n\t");

	sei();
}



