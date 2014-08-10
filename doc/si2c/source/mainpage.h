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

@mainpage
# Software I2C-Slave library for AVR's Microcontroller

@author Martin Langlotz <stackshadow@evilbrain.de>

\copyright GNU Lesser General Public License

## About

This library provides an software-based i2c-slave library to communicate over the i2c-bis.

## Known working situations:

I2C-Master		| AVR		| MHz	| I2C-Speeds
----------------|-----------|-------|---------------|
RaspberryPi B	| Atmega 8	| 16Mhz | 9600Baud		|


## Configuration
Before you use the library, you need to do the following steps. \n
- Configure the header: @link si2c_config See here on how to do that @endlink
- You need to define two functions: @ref si2cSlaveReadRegister and @ref si2cSlaveWriteRegister


@anchor si2c_register
## Register
The si2c-library predefine registers from where the Master can be read or write to. \n
You setuped the amount of aviable registers in @link si2c_config the configuration header @endlink \n
The slave handle read-write access to this registers automatically. \n

## Example
@link si2c_slave_example For an si2c-slave example, see here. @endlink

## Compile
You can use the provided codeblocks-project or just navigate in an terminal \n
to the directory where lib/si2c is placed and run:
make -f si2c.make Release

@todo Create Read-Only-Registers
@todo Create callback function if Register get changed or master try to read an specific register.

*/

/**
@defgroup si2c_slave_example EXAMPLE for si2c as slave
@{
@anchor si2c_slave_example

This examples shows you on how to use the si2c in you Project. \n
First you need to extract the lib/si2c directory to you project that the makefile can find it. \n
Also take a look inside the Makefile to get a guess on how to write an makefile with si2c support



@}
*/
