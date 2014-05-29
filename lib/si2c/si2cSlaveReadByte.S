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
; This file contains the function in asm to read one byte from i2c-bus


; this function has some temporary register and manipulate register 20

.globl si2cSlaveReadByte			; Register Function for C
si2cSlaveReadByte:
    ldi	rTemp1, 8					; counter
	clr	rTemp2						; data byte
	clr rTemp3
	sbr rTemp3, 128

; ########################## Read byte ##########################
loop:


; wait for scl high
	rcall SCLWaitHigh

; read bit
	sbic IS_SDA_ASM					; skips the next instruction if the bit is clear
	or rTemp2, rTemp3


; Wait for scl low
	rcall SCLWaitLow

	lsr rTemp3						; shift left
    dec rTemp1						; Schleifenzähler um 1 verringern
    brne loop						; wenn r17 noch nicht 0 geworden ist -> Schleife wiederholen

; ########################## end of read byte ##########################
	sts si2cByte,rTemp2				; save to C

ret									; return


