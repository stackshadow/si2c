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
#include <stdlib.h>
#include <string.h>


// Write: ./si2c -c 17 27 1 -i -s -as 4 -w 1 -w 1
// Read: ./si2c -c 17 27 1 -i -s -as 4 -w 1 -i -s -ar 4 -r -e


#include "si2cMaster.h"

int		main( int argc, char *argv[] ){

	char targetByte = 0;
	char chipAddress = 8;
	char byte1;

	



	int argvIndex;
	for( argvIndex = 1; argvIndex < argc; argvIndex++ ){
		char *parameter1 = argv[argvIndex];
		
		if( strncmp( parameter1, "-h", 2 ) == 0 ){
			printf("Usage:\n");
			printf("-c <SDA-Port> <SCL-Port> <TIME>\n");
			printf("-i: init - set SDA/SCL to high\n");
			printf("-as <address>: send address on write mode\n");
			printf("-ar <address>: send address on read mode\n");
			printf("-s: Send i2c-Start\n");
			printf("-r <byte>: Read i2c-byte\n");
			printf("-w <byte>: Send i2c-byte\n");
			printf("-e: Send i2c-stop\n");
			printf("-t <chipAddress>: Test if address is present\n");
			continue;
		}


		if( strncmp( parameter1, "-c", 2 ) == 0 ){
			
			if( argvIndex + 3 >= argc ){
				printf( "usage: -c SDA SCL TIME\n" );
				exit(0);
			}

		// Setup the bus
			si2cMasterSetup( 
				atoi(argv[argvIndex+1]), 
				atoi(argv[argvIndex+2]), 
				atoi(argv[argvIndex+3])
			);
			
			argvIndex = argvIndex + 3;
			continue;
		} else {
			if( ! si2cMasterIsSetup() ){
				si2cMasterSetup( 17, 27, 50000 );
			}
		}


		if( strncmp( parameter1, "-i", 2 ) == 0 ){
			si2cMasterInit();
			continue;
		}


		if( strncmp( parameter1, "-as", 3 ) == 0 ){
			if( argvIndex + 1 >= argc ){
				printf( "usage: -a <address>\n" );
				exit(0);
			}
			
			chipAddress = (unsigned int)atoi( argv[argvIndex+1] );

		// Set mode to write
			si2cMasterSetAddress( &targetByte, chipAddress );
			si2cMasterSetMode( &targetByte, 0 );
			
		// Send Address	
			si2cMasterSendByte( targetByte );	
		// Check if client send ack
			if( si2cMasterGetACK() != 1 ){
				printf( "The client doesn't send ack for address\n" );
				exit(-1);
			}

			continue;
		}


		if( strncmp( parameter1, "-ar", 3 ) == 0 ){
			if( argvIndex + 1 >= argc ){
				printf( "usage: -a <address>\n" );
				exit(0);
			}
			
			chipAddress = (unsigned int)atoi( argv[argvIndex+1] );

		// Set mode to write
			si2cMasterSetAddress( &targetByte, chipAddress );
			si2cMasterSetMode( &targetByte, 1 );
			
		// Send Address	
			si2cMasterSendByte( targetByte );	
		// Check if client send ack
			if( si2cMasterGetACK() != 1 ){
				printf( "The client doesn't send ack for address\n" );
				exit(-1);
			}

			continue;
		}


		if( strncmp( parameter1, "-s", 2 ) == 0 ){
			si2cMasterSendStart();
			continue;
		}


		if( strncmp( parameter1, "-r", 2 ) == 0 ){

		// Send Address	
			si2cMasterReadByte( &byte1 );	
			printf( "%s 0x%1x\n", __FUNCTION__, byte1 );
			
		// Send ack
			si2cMasterSendBit( 1 );
			
			continue;
		}


		if( strncmp( parameter1, "-w", 2 ) == 0 ){

			if( argvIndex + 1 >= argc ){
				printf( "usage: -w <byte> - Send i2c-byte\n" );
				exit(0);
			}
			byte1 = atoi( argv[argvIndex+1] );

		// Send Address	
			si2cMasterSendByte( byte1 );	
		// Check if client send ack
			if( si2cMasterGetACK() != 1 ){
				printf( "The client doesn't send ack for byte\n" );
				exit(-1);
			}
			
			continue;
		}


		if( strncmp( parameter1, "-e", 2 ) == 0 ){
			si2cMasterSendStop();
		}


		if( strncmp( parameter1, "-t", 2 ) == 0 ){
			
			if( argvIndex + 1 >= argc ){
				printf( "usage: -check chipAddress\n" );
				exit(0);
			}
			chipAddress = (unsigned int)atoi( argv[argvIndex+1] );

		// Set mode to write
			si2cMasterSetAddress( &targetByte, chipAddress );
			si2cMasterSetMode( &targetByte, 0 );


		// Init the bus
			si2cMasterInit();

		// Send the start on the bus
			si2cMasterSendStart();

		// Send Address	
			si2cMasterSendByte( targetByte );	
		// Check if client send ack
			if( si2cMasterGetACK() != 1 ){
				printf( "The client doesn't send ack for address\n" );
				si2cMasterSendStop();
				exit(-1);
			}

			exit(0);
		}



	}




	return 0;
}

