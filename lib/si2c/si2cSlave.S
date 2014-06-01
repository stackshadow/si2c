; Copyright (C) 2014 by Martin Langlotz aka stackshadow < stackshadow at evilbrain dot de >
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
; This file includes all asm-files to handle i2c-slave communication Project


#define IsASM

#include "si2c_config.h"
#include "si2c.h"
#include <avr/io.h>

; Global vars from C
.extern si2cByte
.extern si2cSlaveReadRegister
.extern si2cSlaveWriteRegister

; Including all needed functions
#include "si2cAdditional.S"
#include "si2cSCL.S"

#include "si2cSlaveWaitInit.S"
#include "si2cSlaveReadByte.S"
#include "si2cSlaveSendByte.S"
#include "si2cSlaveCheckAddress.S"
#include "si2cSlaveSendACK.S"

.globl si2cSlave						; Register Function for C
si2cSlave:

; wait for bus init
	rcall si2cSlaveWaitInit

; read one byte from bus ( The address )
	rcall si2cSlaveReadByte

; Check Address
	rcall si2cSlaveCheckAddress

; RW ?
	lds rTemp1, si2cStateRW				; load from C value
	sbrc rTemp1, 0						; If bit is 1, master will read
	rjmp si2cSlaveRead


; ################################## Write from master to slave ##################################

; read from master ( register )
	rcall si2cSlaveReadByte
	rcall si2cSlaveSendACK

; save register position
	lds rTemp1, si2cByte
	sts si2cRegisterIndex, rTemp1

	si2cSlaveDataRead:

	; read from master ( byte )
		rcall si2cSlaveReadByte
		rcall si2cSlaveSendACK

	; call c function to save it to an array
		rcall si2cSlaveReadRegister

		rjmp si2cSlaveDataRead


; ################################## Read from slave to master ##################################
	si2cSlaveRead:
		rcall si2cSlaveWriteRegister

		rcall si2cSlaveSendByte
		rcall SCLWaitHigh
		rcall SCLWaitLow


	si2cSlaveEnd: nop

ret










































#undef IsASM
