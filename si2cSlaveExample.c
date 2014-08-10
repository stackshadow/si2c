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
@anchor si2c_slave_example_basic

## Basic example

This basic example show how to use the si2c library without any special Hardware \n
no interrupt, no hardware twi is needed.

@include si2cSlaveExample.c

Here is the makefile for this example:
@include si2c.make

@}
*/

// Our CPU-Speed
#define F_CPU 16000000UL

// Needed header
#include <avr/io.h>
#include "lib/si2c/si2c_config.h"
#include "lib/si2c/si2c.h"
#include "lib/si2c/si2cSlave.h"


main(){

// We setup an LED we would like to light up
	SET( DDR, C, 5 );
	SET( PORT, C, 5 );

// Init the BUS
	si2cInit();

// Infinite loop
	while(1){

	// Wait for BUS is ready
		si2cWaitInitCheck();

	// Check if START occure
		si2cSlaveWaitForStart();

	// Handle Slave-communication if START occure
	// this function is BLOCK you program !
		si2cSlave( 0x04 );

	// If Register 1 ( 0x01 in HEX ) is set to 0x01, light up the LED
		if( si2cRegister[1] == 0x01 ){
			CLR( PORT, C, 5 );
		} else {
			SET( PORT, C, 5 );
		}

	}

}

