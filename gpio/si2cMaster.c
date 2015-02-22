/* si2c - an i2c-Master library for gpio
Copyright (C) 2015 Martin Langlotz alias stackshadow

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/



#include <unistd.h>
#include <stdio.h>

#include "si2cMaster.h"

si2cMaster_t si2cMaster[1] = {
	{
		.GPIO_SDA = 0,
		.GPIO_SCL = 0,
		.SCL_TIME_U = 0
	}
};

void			si2cMasterSetup( unsigned int GPIO_SDA, unsigned int GPIO_SCL, unsigned int SCL_TIME_U ){
	printf( "%s SDA:%u SCL:%u TIME:%u\n", __FUNCTION__, GPIO_SDA, GPIO_SCL, SCL_TIME_U );

	si2cMaster->GPIO_SDA = GPIO_SDA;
	si2cMaster->GPIO_SCL = GPIO_SCL;
	si2cMaster->SCL_TIME_U = SCL_TIME_U;

// Starte die WiringPi-Api (wichtig)
	if (wiringPiSetupGpio() == -1)
	return;

	pullUpDnControl( si2cMaster->GPIO_SDA, PUD_OFF );
	pinMode( si2cMaster->GPIO_SDA, OUTPUT );

	pullUpDnControl( si2cMaster->GPIO_SCL, PUD_OFF );
	pinMode( si2cMaster->GPIO_SCL, OUTPUT );
	
	usleep( si2cMaster->SCL_TIME_U );
}


int				si2cMasterIsSetup(){
	if( si2cMaster->GPIO_SCL > 0 ){
		return 1;
	}
	return 0;
}


void			si2cMasterInit(){
	printf( "%s\n", __FUNCTION__ );

	digitalWrite( si2cMaster->GPIO_SDA, HIGH );
	digitalWrite( si2cMaster->GPIO_SCL, HIGH );
	
	usleep( si2cMaster->SCL_TIME_U );
}


void			si2cMasterSendStart(){
	printf( "%s\n", __FUNCTION__ );

	digitalWrite( si2cMaster->GPIO_SDA, LOW );
	usleep( si2cMaster->SCL_TIME_U * 1 );
	digitalWrite( si2cMaster->GPIO_SCL, LOW );
	usleep( si2cMaster->SCL_TIME_U * 1 );
}


void			si2cMasterSendStop(){
	printf( "%s\n", __FUNCTION__ );

	digitalWrite( si2cMaster->GPIO_SDA, LOW );
	usleep( si2cMaster->SCL_TIME_U * 1 );
	digitalWrite( si2cMaster->GPIO_SCL, HIGH );
	usleep( si2cMaster->SCL_TIME_U * 1 );
	digitalWrite( si2cMaster->GPIO_SDA, HIGH );
	usleep( si2cMaster->SCL_TIME_U * 1 );
}


void			si2cMasterSendBit( char bit ){
	printf( "%s %i\n", __FUNCTION__, bit );

	if( bit == 1 ){
		digitalWrite( si2cMaster->GPIO_SDA, HIGH );
	} else {
		digitalWrite( si2cMaster->GPIO_SDA, LOW );
	}
	usleep( si2cMaster->SCL_TIME_U * 1 );
	
	digitalWrite( si2cMaster->GPIO_SCL, HIGH );
	usleep( si2cMaster->SCL_TIME_U * 1 );
	
	digitalWrite( si2cMaster->GPIO_SCL, LOW );
	usleep( si2cMaster->SCL_TIME_U * 1 );
	
	digitalWrite( si2cMaster->GPIO_SDA, LOW );
	usleep( si2cMaster->SCL_TIME_U * 1 );
}


void			si2cMasterSendByte( char byte ){
	printf( "%s 0x%1x\n", __FUNCTION__, byte );

	if( byte & 0x80 ){ si2cMasterSendBit(1); } else {  si2cMasterSendBit(0); }
	if( byte & 0x40 ){ si2cMasterSendBit(1); } else {  si2cMasterSendBit(0); }
	if( byte & 0x20 ){ si2cMasterSendBit(1); } else {  si2cMasterSendBit(0); }
	if( byte & 0x10 ){ si2cMasterSendBit(1); } else {  si2cMasterSendBit(0); }
	if( byte & 0x08 ){ si2cMasterSendBit(1); } else {  si2cMasterSendBit(0); }
	if( byte & 0x04 ){ si2cMasterSendBit(1); } else {  si2cMasterSendBit(0); }
	if( byte & 0x02 ){ si2cMasterSendBit(1); } else {  si2cMasterSendBit(0); }	
	if( byte & 0x01 ){ si2cMasterSendBit(1); } else {  si2cMasterSendBit(0); }
}


int				si2cMasterReadBit(){
	printf( "%s\n", __FUNCTION__ );

// 1 means no ack
	int ack = 1;

// Setup SDA to input
	pinMode( si2cMaster->GPIO_SDA, INPUT );

// Set SCL to high
	digitalWrite( si2cMaster->GPIO_SCL, HIGH );
	usleep( si2cMaster->SCL_TIME_U * 1 );

// Wait a time that the client can set SDA to low / high
	usleep( si2cMaster->SCL_TIME_U * 1 );

// Read bit
	ack = digitalRead( si2cMaster->GPIO_SDA );
	printf( "%s bit: %i\n", __FUNCTION__, ack );
	usleep( si2cMaster->SCL_TIME_U * 1 );
	
// Set SCL to low
	digitalWrite( si2cMaster->GPIO_SCL, LOW );
	usleep( si2cMaster->SCL_TIME_U * 1 );

// Setup SDA to output
	pinMode( si2cMaster->GPIO_SDA, OUTPUT );

	if( ack == 1 ){ return 1; }
	if( ack == 0 ){ return 0; }
	return 0;
}


void			si2cMasterReadByte( char *byte ){
	printf( "%s\n", __FUNCTION__ );

	int bit;
	*byte = 0;
	
	bit = si2cMasterReadBit();
	if( bit == 1 ) *byte |= 128;

	bit = si2cMasterReadBit();
	if( bit == 1 ) *byte |= 64;

	bit = si2cMasterReadBit();
	if( bit == 1 ) *byte |= 32;
	
	bit = si2cMasterReadBit();
	if( bit == 1 ) *byte |= 16;
	
	bit = si2cMasterReadBit();
	if( bit == 1 ) *byte |= 8;
	
	bit = si2cMasterReadBit();
	if( bit == 1 ) *byte |= 4;
	
	bit = si2cMasterReadBit();
	if( bit == 1 ) *byte |= 2;

	bit = si2cMasterReadBit();
	if( bit == 1 ) *byte |= 1;

}


void			si2cMasterSetAddress( char *byte, char address ){
	*byte = address << 1;
}


void			si2cMasterSetMode( char *byte, int bit ){
	printf( "%s 0x%1x %i\n", __FUNCTION__, *byte, bit );

	if( bit == 1 ) {
	// set bit 0
		*byte |= 1;
	} else {
	// clear bit 0
		*byte &= ~(1 << 0);
	}
	
}


int				si2cMasterGetACK(){
	printf( "%s\n", __FUNCTION__ );

// 1 means no ack
	int ack = 1;

// Setup SDA to input
	pinMode( si2cMaster->GPIO_SDA, INPUT );

// Set SCL to high
	digitalWrite( si2cMaster->GPIO_SCL, HIGH );
	usleep( si2cMaster->SCL_TIME_U * 1 );

// Wait a time that the client can set SDA to low
	usleep( si2cMaster->SCL_TIME_U * 1 );

// Read ACK
	ack = digitalRead( si2cMaster->GPIO_SDA );
	usleep( si2cMaster->SCL_TIME_U * 1 );
	
// Set SCL to low
	digitalWrite( si2cMaster->GPIO_SCL, LOW );
	usleep( si2cMaster->SCL_TIME_U * 1 );

// Setup SDA to output
	pinMode( si2cMaster->GPIO_SDA, OUTPUT );

	if( ack == 0 ){ return 1; }
	if( ack == 1 ){ return 0; }
	return 0;
}