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


; this function send an byte

.globl si2cSlaveSendByte				; Register Function for C
si2cSlaveSendByte:
    lds	rTemp1, si2cByte				; load byte which we would like to send
    ldi	rTemp2, 8						; counter


	si2cSlaveSendByteLoop:

	; Send high ( if it is )
		sbrs rTemp1, 7
		sbi DDR_I2C, CONF_SI2C_SDA		; Set SDA to output ( and to low )


	; wait for scl high
		rcall SCLWaitHigh
	; Wait for scl low
		rcall SCLWaitLow


	; Switch back
		cbi DDR_I2C, CONF_SI2C_SDA		; Set SDA to input ( and to low )
		nop


		lsl rTemp1						; shift right
		dec rTemp2						; Schleifenzähler um 1 verringern
		brne si2cSlaveSendByteLoop		; wenn noch nicht 0 geworden ist -> Schleife wiederholen

ret										; return



