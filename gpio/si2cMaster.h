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

#ifndef _h_si2cMaster
#define _h_si2cMaster


// WiringPi-Api einbinden
// der wrapper ist zum Test in x64 systemen ;)
#ifdef __arm__
	#include <wiringPi.h>
#else
	// Pin modes
	#define	INPUT					0
	#define	OUTPUT					1
	#define	PWM_OUTPUT				2
	#define	GPIO_CLOCK				3
	#define	SOFT_PWM_OUTPUT			4
	#define	SOFT_TONE_OUTPUT		5
	#define	PWM_TONE_OUTPUT			6


	#define	LOW						0
	#define	HIGH					1
	
	#define PUD_OFF					0
	#define PUD_DOWN				1
	#define PUD_UP					2

	// Wrapper Functions
	#define wiringPiSetupGpio() 0
	#define pinMode( pin, mode )
	#define pullUpDnControl( pin, mode )
	#define digitalWrite( GPIO, BOOL )
	#define digitalRead( GPIO ) 1
#endif

typedef struct si2cMaster_s {
// Setup
	unsigned int 	GPIO_SDA;
	unsigned int 	GPIO_SCL;
	unsigned int 	SCL_TIME_U;
} si2cMaster_t;

si2cMaster_t 	si2cMaster[1];

void			si2cMasterSetup( unsigned int GPIO_SDA, unsigned int GPIO_SCL, unsigned int SCL_TIME_U );


int				si2cMasterIsSetup();


void			si2cMasterInit();


void			si2cMasterSendStart();


void			si2cMasterSendStop();


void			si2cMasterSendBit( char bit );


void			si2cMasterSendByte( char byte );


int				si2cMasterReadBit();


void			si2cMasterReadByte( char *byte );


void			si2cMasterSetAddress( char *byte, char address );


void			si2cMasterSetMode( char *byte, int bit );


int				si2cMasterGetACK();







#endif