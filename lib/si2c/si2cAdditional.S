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

.globl delay_func					; Register Function for C
delay_func:
;		ldi   R20,10				; R19 = 10
	delay0:	ldi   rTimer1,160			; R20 = 160
	delay1:	ldi   rTimer2,160			; R21 = 160
	delay2:	dec   rTimer2				; Decrease R22
	brne  delay2					; if (R20 != 0) goto delay2 label
	dec   rTimer1					; Decrease R21
	brne  delay1					; if (R20 != 0) goto delay1 label
	dec   rTimer					; Decrease R20
	brne  delay0					; if (R19 != 0) goto delay0 label
ret									; Return to the caller


; Show the i2c byte
.globl ShowByte						; Register Function for C
ShowByte:

    ldi	rTemp1, 8						; counter of bits
	lds rTemp2, si2cByte				; Load byte from c to r18

ShowByteLoop:

	ldi   rTimer,50					; load time 50

	sbrc rTemp2, 0
	ldi rTimer,100					; load time 100


	cbi CONCAT2(PORT, SI2C_STATUS_PORT), SI2C_STATUS_PIN		; clear bit
	nop
	rcall delay_func

	sbi CONCAT2(PORT, SI2C_STATUS_PORT), SI2C_STATUS_PIN		; set bit
	nop
	ldi rTimer, 50
	rcall delay_func


	lsr rTemp2						; shift right
    dec rTemp1						; Schleifenzähler um 1 verringern, dabei wird das Zero Flag beeinflusst
    brne ShowByteLoop				; wenn r17 noch nicht 0 geworden ist -> Schleife wiederholen



ret


