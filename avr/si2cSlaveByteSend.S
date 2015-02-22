; Copyright (C) 2014-2015 by Martin Langlotz aka stackshadow < stackshadow at evilbrain dot de >
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

.globl si2cSlaveByteSend				; Register Function for C
si2cSlaveByteSend:
    ldi	rTemp1, 8						; counter


	si2cSlaveSendByteLoop:

	; Send high ( if it is )
		sbrs rParameter, 7
		SET_ASM( DDR, CONF_SI2C_PORT, CONF_SI2C_SDA )

	; wait for scl high
		rcall SCLWaitHigh
	; Wait for scl low
		rcall SCLWaitLow


	; Switch back
		CLR_ASM( DDR, CONF_SI2C_PORT, CONF_SI2C_SDA )
		nop


		lsl rParameter					; shift right
		dec rTemp1						; Schleifenzähler um 1 verringern
		brne si2cSlaveSendByteLoop		; wenn noch nicht 0 geworden ist -> Schleife wiederholen

ret										; return



