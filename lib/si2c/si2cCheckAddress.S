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

.globl si2cCheckAddress				; Register Function for C
si2cCheckAddress:
;	push r16						; push r16 to stack

	lds r16, si2cByte				; load from C value
	lsr r16							; move one byte to right
	cpi r16, CONF_SI2C_ADDRESS		; check if address match
	brne si2cCheckAddressNACK		; if not match, go to end


; Address match, send ACK
	sbi DDR_I2C, CONF_SI2C_SDA		; Set SDA to output ( and to low )
	nop

; wait for scl high
	scl_wait_high:
	sbis IS_SCL_ASM					; skips the next instruction if the bit is set
	rjmp scl_wait_high

	nop

; wait for scl low
	scl_wait_low:
	sbic  IS_SCL_ASM				; skips the next instruction if the bit is cleared
	rjmp scl_wait_low

	nop
	nop
	nop

; Switch back
	cbi DDR_I2C, CONF_SI2C_SDA		; Set SDA to input ( and to low )
	nop


	rjmp si2cCheckAddressEnd

si2cCheckAddressNACK:


si2cCheckAddressEnd:
;	pop r16							; restore r18 from stack
	ret								; return


#undef IsASM
