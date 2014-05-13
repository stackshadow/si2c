/*
Copyright (C) 2014 by Martin Langlotz aka stackshadow < stackshadow at evilbrain dot de >

This file is part of si2c

si2c is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License.

si2c is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with si2c.  If not, see <http://www.gnu.org/licenses/>.
*/

/**
@defgroup si2c_slave I2C Functions to be a slave
@{
@anchor si2c_slave
This functions handle communication as a slave.
@}
*/


/** @ingroup si2c_slave
@~english
@brief User defined function: Write request from Master

This function get called if:
- the Master set already the register
- the next byte was readed from the Master
- before this byte get written to the requested register

If you return this function with 0, the byte get not written to the register. \n
Return everything else, and the byte get written to the register
*/
int					(*si2cSlaveRegisterPreWrite )( unsigned char Register, unsigned char WrittenByte );      // Function pointer

/** @ingroup si2c_slave
@~english
@brief User defined function: Read request from Master

This function get called if:
- the Master request an read

If you return this function with 0, the requested register is not send to the master
*/
int					(*si2cSlaveRegisterPreRead )( unsigned char Register );      // Function pointer


/** @ingroup si2c_slave
@~english
@brief Check if START condition occure on I2C-BUS

This function:
- block if SDA gets low and wait for SCL gets low
- set state to RUN if START occure
*/
void				si2cSlaveWaitForStart();

/** @ingroup si2c_slave
@~english
@internal
@brief Read a byte from the bus
This function read a byte from the bus but don't ACK it ( use si2cSendACK() for this )
It's also checks if an STOP or REPEATED-START occure
*/
void				si2cSlaveReadByte();

/** @ingroup si2c_slave
@~english
@internal
@brief Send a byte to Master
This function write a byte to the bus and dont check ACK of Master
@todo Add function to check ACK from Master
*/
void				si2cSlaveSendByte( unsigned char Byte );

/** @ingroup si2c_slave
@~english
@internal
@brief Send an ACK from slave to master
*/
void				si2cSlaveSendACK();

/** @ingroup si2c_slave
@~english
@brief The main function for si2c

This function BLOCK's your Program if an START on the I2C-Bus occure
You need to call si2cSlaveWaitForStart(), to determine if an START occure on the i2c-Bus, before using this function

It handle:
- reading of address
- ACK the Address
- Set the R/W-Register
- Send byte inside R/W-Register to the master back if an Read-Request occure from the Master
- After BUS-communication finished ( STOP-condition ) the function returns to normal and don't block anymore

@param Address The address of your slave-device
*/
void				si2cSlave( unsigned char Address );




/** @} */
































