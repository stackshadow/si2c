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
; This file define some basic functions which are used by the other asm-files


; wait for scl high
scl_wait_high:
	sbis IS_SCL_ASM					; skips the next instruction if the bit is set
	rjmp scl_wait_high
ret

; wait for scl low
scl_wait_low:
	sbic  IS_SCL_ASM				; skips the next instruction if the bit is cleared
	rjmp scl_wait_low
ret

delay_func:
;		ldi   R20,10				; R19 = 10
delay0:	ldi   R21,160				; R20 = 160
delay1:	ldi   R22,160				; R21 = 160
delay2:	dec   R22					; Decrease R22
		brne  delay2				; if (R20 != 0) goto delay2 label
		dec   R21					; Decrease R21
		brne  delay1				; if (R20 != 0) goto delay1 label
		dec   R20					; Decrease R20
		brne  delay0				; if (R19 != 0) goto delay0 label
		ret							; Return to the caller


; Show the i2c byte
.globl ShowByte						; Register Function for C
ShowByte:

    ldi	r16, 8						; counter of bits
	sbr	r17, 128					; bit 1
	lds r18, si2cByte				; Load byte from c to r18

ShowByteLoop:

	ldi   R20,100					; load time 10

	bst r18, 1						; Store bit 1 of r17 in T Flag
	brts IsSet						; jump if T Flag set
		ldi R20,50					; time if bit is 0
	IsSet: nop

	cbi CONCAT2(PORT, SI2C_STATUS_PORT), SI2C_STATUS_PIN		; clear bit
	nop
	rcall delay_func

	sbi CONCAT2(PORT, SI2C_STATUS_PORT), SI2C_STATUS_PIN		; set bit
	nop
	ldi r20, 50
	rcall delay_func


	lsr r18							; shift right
    dec r16							; Schleifenzähler um 1 verringern, dabei wird das Zero Flag beeinflusst
    brne ShowByteLoop				; wenn r17 noch nicht 0 geworden ist -> Schleife wiederholen



ret


