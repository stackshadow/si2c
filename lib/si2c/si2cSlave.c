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




void				si2cSlaveReadRegister(){
	if( si2cRegisterIndex < CONF_SI2C_REGISTER ){
		si2cRegister[si2cRegisterIndex] = si2cByte;
	}
}

void				si2cSlaveWriteRegister(){
	if( si2cRegisterIndex < CONF_SI2C_REGISTER ){
		si2cByte = si2cRegister[si2cRegisterIndex];
	}
}












