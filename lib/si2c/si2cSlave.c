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
*/

#include <avr/io.h>
#include <util/delay.h>

// The configuration of software-i2c
#include "si2c_config.h"
#include "si2c.h"
#include "si2cSlave.h"



void				si2cSlaveWaitForStart(){
	// Check if Start condition occure
	if( si2cState == si2cState_READY ){
		if( ! IS_SDA ){
			if( IS_SCL ){

			// Wait that SCL also get low
				while( IS_SCL );
				#ifdef SI2C_USE_STATUS
					CLR( PORT, SI2C_STATUS_PORT, SI2C_STATUS_PIN );
				#endif // SI2C_USE_STATUS

				si2cState = si2cState_RUN;
				return;
			}
		}
	}
}


void				si2cSlaveReadByte(){

    si2cByte = 0;

// Read byte
	for( si2cByteIndex = 7; si2cByteIndex >= 0; si2cByteIndex--){
	// Wait for SCL High
		while( ! (IS_SCL) );

	// Read PIN
		si2cBit = IS_SDA;
		if( si2cBit ){
			si2cByte |= _BV(si2cByteIndex);
		}

	// Wait for SCL Low
		while( IS_SCL ){

		// Stopp
			if( ! si2cBit ){
				if( IS_SDA ){
					si2cState = si2cState_STOP;
					return;
				}
			}
		// Repeaded start
			if( si2cBit ){
				if( ! IS_SDA ){
					si2cState = si2cState_START;
					while( IS_SCL );
					return;
				}
			}

		};

	}
}


void				si2cSlaveSendByte( unsigned char Byte ){

	for( si2cByteIndex = 7; si2cByteIndex >= 0; si2cByteIndex--){

		while( IS_SCL );

		if( Byte & (_BV(si2cByteIndex)) ){
		} else {
			SET( DDR, CONF_SI2C_PORT, CONF_SI2C_SDA ); // Set SDA to output ( LOW )
		}

		while( ! (IS_SCL) );
		while( IS_SCL );
		CLR( DDR, CONF_SI2C_PORT, CONF_SI2C_SDA ); // Set SDA to input

	}

}


void				si2cSlaveSendACK(){

	SET( DDR, CONF_SI2C_PORT, CONF_SI2C_SDA ); // Set SDA to output ( LOW )


	while( ! (IS_SCL) );	// Wait for High
	while( IS_SCL );		// Wait for Low
	IS_SCL;

	//_delay_us(SI2C_US_ACK);

	CLR( DDR, CONF_SI2C_PORT, CONF_SI2C_SDA ); // Set SDA to input

}
















