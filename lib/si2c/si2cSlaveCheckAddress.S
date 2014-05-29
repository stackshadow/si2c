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



.globl si2cSlaveCheckAddress					; Register Function for C
si2cSlaveCheckAddress:
	lds rTemp1, si2cByte				; load from C value
	lsr rTemp1							; move one byte to right

; compare address
	cpi rTemp1, CONF_SI2C_ADDRESS
	brne si2cCheckAddressNACK


; Address match, send ACK
	sbi DDR_I2C, CONF_SI2C_SDA			; Set SDA to output ( and to low )
	nop

; wait for scl impulse
	rcall SCLWaitHigh
	nop
	rcall SCLWaitLow
	nop

; Switch back
	cbi DDR_I2C, CONF_SI2C_SDA			; Set SDA to input ( and to low )
	nop


; test
	rcall si2cSlaveReadByte
	rcall ShowByte


	rjmp si2cCheckAddressEnd

si2cCheckAddressNACK:
; wait until RS or STOP occure
	rcall SCLWaitHigh
	nop
	rcall SCLWaitLow
	nop

si2cCheckAddressEnd:
	ret									; return


