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

// This is an example config
/** @defgroup si2c_config I2C Configuration
@{
@anchor si2c_config

The configuration is done in the si2c_config.h \n
You need to include this header into you project

@todo Implement support for multiple I²C on one controller
*/

// Of course the CPU-Speed
#ifndef F_CPU
	#warning F_CPU is not set inside the MAKEFILE !
#endif

// LED to display I2C-Status
// comment this two lines if you dont wan't to use the status
#define SI2C_STATUS_PORT B		/**< The Port of the Status LED ( Light up when BUS comm is active ) */
#define SI2C_STATUS_PIN 0		/**< The Pin of the Status LED */


// Port configuration for Software I2C
#define CONF_SI2C_PORT D		/**< The Port defined as Letter where the i2c-bus is connected to */
// Pins to be used in the bit banging
#define CONF_SI2C_CLK 4			/**< The SCL-Pin on CONF_SI2C_PORT */
#define CONF_SI2C_SDA 3			/**< The SDA-Pin on CONF_SI2C_PORT */

// Address of our device
#define CONF_SI2C_ADDRESS 0x03

// Baud of i2c-bus
#define CONF_SI2C_BAUD 9600		/**< The baudrate of connected master */

// Count of registers
#define CONF_SI2C_REGISTER 10	/**< The amount of registers ( @link si2c_register see here @endlink) */



/** @} */
