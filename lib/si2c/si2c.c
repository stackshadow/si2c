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


#include "si2c_config.h"
#include "si2c.h"

void				si2cInit(){

// Setup soft i2c
	si2cState = si2cState_UNKNOWN;

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


void				si2cWaitInitCheck(){
	if( si2cState == si2cState_UNKNOWN ){
		if( IS_SCL && IS_SDA ){
			si2cState = si2cState_READY;
		}
	}
}


