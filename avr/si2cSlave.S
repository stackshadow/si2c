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
#include "si2cConfig.h"
#include "si2cSlaveASM.h"

#include "si2cSetup.S"
#include "si2cSCLWait.S"
#include "si2cSlaveByteRead.S"
#include "si2cSlaveByteSend.S"
#include "si2cSlaveACK.S"
#include "si2cSlaveCheckAddress.S"
#include "si2cWaitEnd.S"

.globl si2cSlave
si2cSlave:


; ########################## Wait for bus init ##########################
	rcall SDAWaitLow
	rcall SCLWaitLow

	

; ########################## Address ##########################
; Read byte from bus
	rcall si2cSlaveByteRead
	
; Check Address
	mov rParameter, rReturnValue
	rcall si2cSlaveCheckAddress;

; Check return register
	cpi rReturnState, 0 				; 0 is okay
	brne si2cBusWaitEnd					; Branch if rReturnState <> 0

; RW ?
	sbrc rReturnValue, 0				; If bit is 1, master will read
	rjmp si2cSlaveRead



; ################################## Write from master to slave ##################################



; read from master ( register )
	rcall si2cSlaveByteRead
	cpi rReturnState, 1 				; RepeadedStart occure
	breq si2cSlave						; Branch if equal
	cpi rReturnState, 2 				; Stop occure
	breq si2cSlaveEnd					; Branch if equal
; send ack
	rcall si2cSlaveACK


; save register position
	sts si2cRegisterIndex, rReturnValue

	si2cSlaveDataRead:

	; read from master ( byte )
		rcall si2cSlaveByteRead
		cpi rReturnState, 1 				; RepeadedStart occure
		breq si2cSlave						; Branch if equal
		cpi rReturnState, 2 				; Stop occure
		breq si2cSlaveEnd					; Branch if equal
	; send ack
		rcall si2cSlaveACK


	; rcall c function to save it to an array
		sts si2cByte, rReturnValue
		
		;rcall si2cShowByte
		rcall si2cSlaveReadRegister
		

		rjmp si2cSlaveDataRead


; ################################## Read from slave to master ##################################
	si2cSlaveRead:
		rcall si2cSlaveWriteRegister

		lds	rParameter, si2cByte
		rcall si2cSlaveByteSend

		rcall SCLWaitHigh
		rcall SCLWaitLow

		;rcall si2cShowByte


	si2cBusWaitEnd:
	rcall si2cWaitEnd

	si2cSlaveEnd:
	ret
