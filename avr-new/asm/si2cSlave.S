; Copyright (C) 2015 by Martin Langlotz aka stackshadow < stackshadow at evilbrain dot de >
;
; This file is part of si2c
;
; si2c is free software: you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation, version 3 of the License.
;
; si2c is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU Lesser General Public License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with si2c.  If not, see <http://www.gnu.org/licenses/>.
;
; This function wait until the bus is ready

#include <avr/io.h>

#include "config.h"
#include "si2cSlave.asmh"

; include other functions
#include "watchdog/si2cWD.S"

; our i2c functions
#include "si2cSetup.S"
#include "si2cSlaveWaitForBus.S"
#include "si2cSlaveReadByte.S"
#include "si2cSlaveCheckAddress.S"
#include "si2cSlaveSendACK.S"
#include "si2cSlaveSendNACK.S"

.global si2cSlave
si2cSlave:
    rcall si2cSlaveWaitForBus
    rcall si2cSlaveReadByte
    
    SET_ASM( PORT, D, 6 );
    
    ; okay, now we have an Address, check it
    lds rParameter,si2cByte                     ; load byte
    rcall si2cSlaveCheckAddress                 ; check Address
    cpi rReturnState, 1
    breq ack                                    ; if Address is correct, jump
    rcall si2cSlaveNACK
    ret
ack:
    CLR_ASM( PORT, D, 6 );
    rcall si2cSlaveACK

    rcall si2cSlaveReadByte


    ret

