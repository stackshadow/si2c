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
; This file is an example on how to use the si2c-library in you Project


#define IsASM

#include "si2c_config.h"
#include "si2c.h"
#include <avr/io.h>

.extern si2cByte

.globl si2cReadByte					; Register Function for C
si2cReadByte:
	push r16						; push r16 to stack
	push r17						; push r17 to stack
	push r18						; push r18 to stack


    ldi	r16, 8						; counter
	sbr	r17, 128					; bit 8
	clr	r18							; data byte




; ########################## Read byte ##########################
loop:


; wait for scl high
	scl_wait_high:
	sbis IS_SCL_ASM					; skips the next instruction if the bit is set
	rjmp scl_wait_high

; give the controlle a litte bit time to read the port
	nop
	nop

; read bit
	sbis IS_SDA_ASM					; skips the next instruction if the bit is set
	rjmp sda_is_low

; bit is 1
	or   r18, r17

; if sda is low, do nothin ( bit stay 0 )
	sda_is_low: nop


; wait for scl low
	scl_wait_low:
	sbic  IS_SCL_ASM				; skips the next instruction if the bit is cleared
	rjmp scl_wait_low



	lsr r17							; shift rightmost bit into carry, set Z flag if 0
    dec r16							; Schleifenzähler um 1 verringern, dabei wird das Zero Flag beeinflusst
    brne loop						; wenn r17 noch nicht 0 geworden ist -> Schleife wiederholen

; ########################## end of read byte ##########################



	sts si2cByte,r18				; save to C

	pop r18							; restore r18 from stack
	pop r17							; restore r17 from stack
	pop r16							; restore r16 from stack

ret									; return



#undef IsASM
