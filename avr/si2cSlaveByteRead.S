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

/*
@fn si2cSlaveByteRead()
@return \n
- rReturnValue - The readed byte from the bus
- rReturnState - 0 = everything was okay, 1 = Repeated-Start occure, 2 = STOP occure
*/



; ########################## Read Byte ##########################
.global si2cSlaveByteRead
si2cSlaveByteRead:
    ldi	rTemp1, 8					; counter
	ldi rTemp2, 0					; Register to compare with bit
	sbr rTemp2, 128					; Set bit 8 ( this is the first bit we get from bus )
	ldi rReturnValue, 0				; Clean return bit

; ########################## Read byte ##########################
si2cSlaveReadByteLoop:

; wait for scl high
	rcall SCLWaitHigh

; read bit
	sbic SDA_ASM					; skips the next instruction if the bit is clear
	or rReturnValue, rTemp2
	
; Wait for scl low
	rcall SCLWaitLowCheck
; Check return register
	cpi rReturnState, 0 			; 0 is okay
	brne si2cSlaveByteReadEnd		; Branch if rReturnState <> 0


	lsr rTemp2						; shift left
    dec rTemp1						; decrement loop-counter
    brne si2cSlaveReadByteLoop		; if not 0 go to loop

; ########################## end of read byte ##########################
; Set return Value to good :D
	ldi rReturnState, 0

si2cSlaveByteReadEnd:
	; As return-value the SCLWaitLowCheck return-value is used
	ret
