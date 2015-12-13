/* si2c - An software based i2c-library - Example file
Copyright (C) 2015 by Martin Langlotz aka stackshadow < stackshadow at evilbrain dot de >

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
*/

// Needed thinks for avr
#include <util/delay.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#include "helpers.h"
#include "si2cConfig.h"
#include "si2cSlave.h"


volatile unsigned char LED;

void				si2cSlaveReadRegister(){
	si2cRegister[si2cRegisterIndex] = si2cByte;
}


void				si2cSlaveWriteRegister(){
	si2cByte = si2cRegister[si2cRegisterIndex];
}


void 				si2cShowByte(){

	int byteIndex = 0;

// Read byte
	for( byteIndex = 0; byteIndex <= 7; byteIndex++ ){


		SET( PORT, CONF_STATUS_PORT, CONF_STATUS_PIN );
		_delay_ms(500);

		CLR( PORT, CONF_STATUS_PORT, CONF_STATUS_PIN );
		if( si2cByte & _BV(byteIndex) ){
			_delay_ms(500);
		} else {
			_delay_ms(100);
		}



	}

	SET( PORT, CONF_STATUS_PORT, CONF_STATUS_PIN );
}


int 				main(){



		// Setup Status LED
#ifdef SI2C_USE_STATUS
	SET( DDR, CONF_STATUS_PORT, CONF_STATUS_PIN );
	SET( PORT, CONF_STATUS_PORT, CONF_STATUS_PIN );
#endif


// An test LED	
	SET( DDR, D, 1 );
	SET( PORT, D, 1 );


// Setup bus
	si2cSetup();


// Enable Interrupt for INT1
	//GICR = 0<<INT0 | 1<<INT1;
	//MCUCR = 0<<ISC01 | 0<<ISC00;

// enable interruot
	//sei();
		CLR( PORT, CONF_STATUS_PORT, CONF_STATUS_PIN );
		_delay_ms(1000);
		SET( PORT, CONF_STATUS_PORT, CONF_STATUS_PIN );
		_delay_ms(1000);

		
// Infinite loop
	while( 1 ){
		CLR( PORT, D, 1 );
		_delay_ms(1000);
		SET( PORT, D, 1 );
		_delay_ms(1000);

		//asm volatile ( "rcall si2cSlave" );
		si2cSlave();
	
	// If Register 1 ( 0x01 in HEX ) is set to 0x01, light up the LED
		if( si2cRegister[1] == 0x00 ){
			SET( PORT, D, 1 );
		}
		
		if( si2cRegister[1] == 0x01 ){
		//if( LED > 0 ){
			CLR( PORT, CONF_STATUS_PORT, CONF_STATUS_PIN );
			_delay_ms(1000);
		} else {
			//SET( PORT, CONF_STATUS_PORT, CONF_STATUS_PIN );
		}


		CLR( PORT, D, 1 );
		_delay_ms(1000);
		SET( PORT, D, 1 );
		_delay_ms(1000);
	}
}


/*
ISR(INT1_vect){

// Disable Interrupt
	cli();
	
	asm volatile ( "rcall si2cSlave" );

	SET( PORT, CONF_STATUS_PORT, CONF_STATUS_PIN );
	
	sei();
	
	return;
}

*/