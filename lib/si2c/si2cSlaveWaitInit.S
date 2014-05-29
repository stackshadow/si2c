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
; This function wait until the bus is ready



.globl si2cSlaveWaitInit					; Register Function for C
si2cSlaveWaitInit:

; ########################## Wait for bus init ##########################
scl_wait_init:
	sbic IS_SCL_ASM					; skips the next instruction if the bit is cleared
	rjmp scl_wait_init

sda_wait_init:
	sbic IS_SDA_ASM					; skips the next instruction if the bit is cleared
	rjmp sda_wait_init

	nop
	nop

ret									; return


