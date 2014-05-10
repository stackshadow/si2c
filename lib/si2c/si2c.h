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
@defgroup si2c_main I2C Main functions
@{
@anchor si2c_main
Main functions of Software-I2C-Library
@}
*/


// Needed thinks for avr
#include <util/delay.h>
#include <avr/io.h>

/** @ingroup si2c_main */
// Some defines we need
#define 	SET_(typ, port, bit) typ##port |= (1<<bit)
#define 	SET(typ, port, bit) SET_(typ, port, bit) /**< Set a bit inside an register */

#define 	CLR_(typ, port, bit) typ##port &= ~(1<<bit)
#define 	CLR(typ, port, bit) CLR_(typ, port, bit) /**< Reset a bit inside an register */

#define 	IS_( port, bit) ( PIN##port & (1<<bit) )
#define 	IS( port, bit) IS_( port, bit) /**< Checks if an bit is set */

// SDA / SCL
#define		IS_SCL IS(CONF_SI2C_PORT,CONF_SI2C_CLK) /**< Checks if SCL is set */
#define		IS_SDA IS(CONF_SI2C_PORT,CONF_SI2C_SDA) /**< Checks if SDA is set */

// Wait time of ACK
#define		SI2C_US_ACK ( F_CPU / CONF_SI2C_BAUD )

// Check define of status-led
#ifdef SI2C_STATUS_PORT
	#ifdef SI2C_STATUS_PIN
		#define SI2C_USE_STATUS
	#endif // SI2C_STATUS_PIN
#endif // SI2C_STATUS_PORT


// Status on the BUS
typedef enum {
	si2cState_UNKNOWN = -1,
	si2cState_READY,
	si2cState_RUN,
	si2cState_RS, 		// repeated start
}
si2cState_t;

// Requested direction from MASTER
typedef enum {
	si2cDirection_NO,
	si2cDirection_READ,
	si2cDirection_WRITE
}
si2cDirection_t;

// Basic infos
si2cState_t			si2cState;
si2cDirection_t 	si2cDirection;

// Bits and Bytes
unsigned char		si2cBit;
unsigned char		si2cByte;
char				si2cByteIndex;

// Registers
unsigned char		si2cRegister[CONF_SI2C_REGISTER];
int					si2cRegisterIndex;



/** @ingroup si2c_main
@~english
@brief Init the soft-i2c-bus

This function init the I2C-Bus and setup the SDA- and SCL-Ports
This function need only to call once ( outside of your main loop )
*/
void				si2cInit();

/** @ingroup si2c_main
@~english
@brief Init the soft-i2c-bus

This function:
- dont block
- Set the state to READY if SDA and SCL is high
*/
void				si2cWaitInitCheck();
