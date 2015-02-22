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

