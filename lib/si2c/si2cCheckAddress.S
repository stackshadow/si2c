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
; This file contains the function to check if our address match



.globl si2cCheckAddress				; Register Function for C
si2cCheckAddress:
;	push r16						; push r16 to stack

; Clear all register
	clr r17
	clr r18

	lds r16, si2cByte				; load from C value
	lsr r16							; move one byte to right
	cpi r16, CONF_SI2C_ADDRESS		; compare to address
	brne si2cCheckAddressNACK		; if not match, go to end


; Address match, send ACK
	sbi DDR_I2C, CONF_SI2C_SDA		; Set SDA to output ( and to low )
	nop

; wait for scl impulse
	rcall scl_wait_high
	nop
	rcall scl_wait_low
	nop


; Switch back
	cbi DDR_I2C, CONF_SI2C_SDA		; Set SDA to input ( and to low )
	nop

; test, show address
	rcall ShowByte

	rjmp si2cCheckAddressEnd

si2cCheckAddressNACK:
; wait for scl impulse
	rcall scl_wait_high
	nop
	rcall scl_wait_low

; Wait for RS
	rcall scl_wait_high


; save state of sda in r17
	cbr r17, 1						; clear bit
	sbic IS_SDA_ASM					; skips the next instruction if the bit is cleared
	rjmp SDARegisterClear
	cbr r17, 1
	SDARegisterClear: nop

; Tipp: 0b11111100
; Check for repeated start / Stop
	StartStopCheckLoop:

	; If sda was high and get low -> repeadet start
		cpi r17, 0b00000001				; compare to address
		brne NoRepeadetStart			; if not match, check STOP

		sbic IS_SDA_ASM					; if bit is cleared, dont jump -> RS occure
		rjmp NoStop

	; repeated start occure
		rjmp si2cCheckAddressEnd

		NoRepeadetStart:

	; If sda was low and get high -> stop
		sbis IS_SDA_ASM					; if bit is set, dont jump -> Stop occure
		rjmp NoStop

	; stop occure
		rjmp si2cCheckAddressEnd

		NoStop: nop

	sbic IS_SCL_ASM					; skips the next instruction if the bit is cleared
	rjmp StartStopCheckLoop



si2cCheckAddressEnd:
;	pop r16							; restore r18 from stack
	nop
	nop
	ret								; return


