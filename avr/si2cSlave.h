/* si2c - An software based i2c-library
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

/** 
@defgroup si2cavr AVR-Library for software i2c
@{
	Software i2c for AVR's atmega
@}
*/



// Bits and Bytes
volatile unsigned char				si2cByte;
volatile unsigned char				si2cAddress;
volatile unsigned char				si2cStateRW;

// Registers
unsigned char						si2cRegister[CONF_SI2C_REGISTER];
volatile unsigned char				si2cRegisterIndex;


/**
@ingroup si2cavr
@brief Setup io for i2c use
This function disable the pullups of SDA and SCL pin and set these pins to output
*/
void si2cSetup();


void si2cSlave();

