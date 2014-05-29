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

// Needed thinks for avr
#include <util/delay.h>
#include <avr/io.h>

#include "si2c_config.h"
#include "si2c.h"

void				si2cInit(){

// Setup Status LED
#ifdef SI2C_USE_STATUS
	SET( DDR, SI2C_STATUS_PORT, SI2C_STATUS_PIN );
	SET( PORT, SI2C_STATUS_PORT, SI2C_STATUS_PIN );
#endif

// Test
// Disable Pull up ( just to be sure )
	CLR( PORT, CONF_SI2C_PORT, CONF_SI2C_CLK );
	CLR( PORT, CONF_SI2C_PORT, CONF_SI2C_SDA );

// Set Ports to input
	CLR( DDR, CONF_SI2C_PORT, CONF_SI2C_CLK );
	CLR( DDR, CONF_SI2C_PORT, CONF_SI2C_SDA );



}


void				si2cReadyWait(){
	WAIT_SCL_HIGH;
	WAIT_SDA_HIGH;
}


void				si2cShowByte( unsigned char byte ){

// Read byte
	for( si2cByteIndex = 7; si2cByteIndex >= 0; si2cByteIndex-- ){


		SET( PORT, SI2C_STATUS_PORT, SI2C_STATUS_PIN );
		_delay_ms(500);

		CLR( PORT, SI2C_STATUS_PORT, SI2C_STATUS_PIN );
		if( byte & _BV(si2cByteIndex) ){
			_delay_ms(500);
		} else {
			_delay_ms(100);
		}



	}

	SET( PORT, SI2C_STATUS_PORT, SI2C_STATUS_PIN );

}



