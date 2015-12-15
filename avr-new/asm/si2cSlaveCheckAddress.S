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
@brief Check if the Address match
@param rParameter - The readed byte from the bus
@return
- rReturnValue - 0 = write, 1 = read
- rReturnState - 0 = Address match, 1 = Address not match
	

*/

.globl si2cSlaveCheckAddress				; Register Function for C
si2cSlaveCheckAddress:

    mov rTemp1,rParameter                   ; load
    lsr rTemp1                              ; shift
;    sts si2cByte,rTemp1
;    ret
    
    lds rTemp2,si2cAddress                  ; load

    cp rTemp1,rTemp2
    brne si2cSlaveWrongAddress              ; jump if <>
    
    ldi rReturnState, 1				        ; return
    ret

si2cSlaveWrongAddress:
    ldi rReturnState, 0				        ; return
    ret
