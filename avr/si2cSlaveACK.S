; Copyright (C) 2015 by Martin Langlotz aka stackshadow < stackshadow at evilbrain dot de >
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


.global si2cSlaveACK
si2cSlaveACK:

; Address match, send ACK
	SET_ASM( DDR, CONF_SI2C_PORT, CONF_SI2C_SDA )
	nop

; wait for scl impulse
	rcall SCLWaitHigh
	rcall SCLWaitLow

; Switch back
	CLR_ASM( DDR, CONF_SI2C_PORT, CONF_SI2C_SDA )
	nop
; return
	ret


.global si2cSlaveNACK
si2cSlaveNACK:
; wait for scl impulse
	rcall SCLWaitHigh
	rcall SCLWaitLow
; return
	ret

