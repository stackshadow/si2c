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
;
; This function wait until the bus is ready

.global si2cWaitEnd
si2cWaitEnd:

	; Wait for high
	rcall SCLWaitHigh

	; Check if SDA is High or Low
	sbic SDA_ASM					; If SDA = 1
	rjmp si2cWaitEndWaitSCLLow		; then jump

	si2cWaitEndWaitStop:
	; SDA is low, wait that its getting high -> STOP
		sbic SDA_ASM					; if SDA gets 1
		rjmp si2cWaitEndFinish			; then jump

	; SCL gets low ?
		sbis SCL_ASM					; if SCL = 0
		rjmp si2cWaitEnd				; then jump
		rjmp si2cWaitEndWaitStop		; else jump


si2cWaitEndWaitSCLLow:
	rcall SCLWaitLow			; wait that scl get low
	rjmp si2cWaitEnd			; jump back

si2cWaitEndFinish: 
	ret