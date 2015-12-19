
// Needed thinks for avr
#include <util/delay.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#include "makros.h"
#include "si2cSlave.h"

#define statusLEDPort D
#define statusLEDPin 7
#define commLEDPort D
#define commLEDPin 6

#include "watchdog/si2cWD.h"
volatile unsigned char tempValue;
void                testWatchdog(){

    si2cWDReset();

    asm(".extern tempValue" );

    while(1){
        si2cWD();
        asm("sts tempValue,r23" );


        if( tempValue == 0 ) break;
    }

// Power off LEDs
	CLR( PORT, statusLEDPort, statusLEDPin );


}

void 				si2cShowByte( unsigned char byte ){

	int byteIndex = 0;

// Read byte
	for( byteIndex = 0; byteIndex <= 7; byteIndex++ ){
		SET( PORT, statusLEDPort, statusLEDPin );
		_delay_ms(500);

		CLR( PORT, statusLEDPort, statusLEDPin );
		if( byte & _BV(byteIndex) ){
			_delay_ms(500);
		} else {
			_delay_ms(100);
		}
	}

	SET( PORT, statusLEDPort, statusLEDPin );
}

void				si2cSlaveReadRegister(){
   _delay_ms(1000);
    si2cShowByte( si2cByte );
}



int main (){

// setup pin
    
// Set Ports to output
	SET( DDR, statusLEDPort, statusLEDPin );
	SET( DDR, commLEDPort, commLEDPin );

// Power off LEDs
	SET( PORT, statusLEDPort, statusLEDPin );
	SET( PORT, commLEDPort, commLEDPin );

    asm("rcall si2cSetup");

    si2cShowByte( si2cAddress );

    while(1){
        si2cSlave();
    }
    return 0;
}

