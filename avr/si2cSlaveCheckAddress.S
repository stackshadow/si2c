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
; This file contains the function to check if our address match

/*
	@fn si2cSlaveCheckAddress()
	@brief Read one byte as an slave
	@param rParameter - The readed byte from the bus
	@return
	- rReturnValue - 0 = write, 1 = read
	- rReturnState - 0 = Address match, 1 = Address not match
	

*/

.globl si2cSlaveCheckAddress				; Register Function for C
si2cSlaveCheckAddress:

; init
	clr rTemp1
	ldi rReturnValue, 0

; Read RW-State
	sbrc rParameter, 0
	ldi rReturnValue, 1

; Shift
	lsr rParameter							; move one byte to left

; compare address1
	cpi rParameter, CONF_SI2C_ADDRESS		; compare address
	brne si2cSlaveCheckAddressNotOk			; jump if bit is not equal
	;CLR_ASM( PORT, CONF_STATUS_PORT, CONF_STATUS_PIN )
	;rcall si2cShowByte

; send ACK
si2cSlaveCheckAddressOk:
	rcall si2cSlaveACK
	ldi	rReturnState, 0						; Load Immediate
	ret

si2cSlaveCheckAddressNotOk:
	rcall si2cSlaveNACK
	ldi	rReturnState, 1						; Load Immediate
	ret										; return


