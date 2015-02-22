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




; ########################## SCL / SDA - Waiting functions - Without check ##########################
.global SCLWaitHigh
SCLWaitHigh:
	sbis SCL_ASM		; if SCL == 0
	rjmp SCLWaitHigh	; then jump
	ret

.global SCLWaitLow
SCLWaitLow:
	sbic SCL_ASM		; if SCL == 1
	rjmp SCLWaitLow		; then jump
	ret


.global SDAWaitHigh
SDAWaitHigh:
	sbis SDA_ASM		; if SDA == 0
	rjmp SDAWaitHigh	; then jump
	ret

.global SDAWaitLow
SDAWaitLow:
	sbic SDA_ASM		; if SDA == 1
	rjmp SDAWaitLow		; then jump
	ret


; ########################## SCL / SDA - Waiting functions - With check ##########################

.global SCLWaitLowCheck
SCLWaitLowCheck:
	ldi	rReturnState, 2				; Load Immediate

; Check if SDA is High or Low
	sbic SDA_ASM					; If SDA = 1
	rjmp SCLWaitLowCheckSDAHigh		; then jump


SCLWaitLowCheckSDALow:
	; check if SDA gehts high ( from low -> high = STOP )
	sbic SDA_ASM					; If SDA = 1
	rjmp SCLWaitLowCheckStop		; then jump
	
	; check if SCL gets low
	sbic SCL_ASM					; If SCL = 1
	rjmp SCLWaitLowCheckSDALow		; then jump
	rjmp SCLWaitLowCheckOk			; else jump


SCLWaitLowCheckSDAHigh:

	; check if SDA gehts low ( from high -> low = START/RS )
	sbis SDA_ASM					; If SDA = 0
	rjmp SCLWaitLowCheckRS			; then jump

	; check if SCL gets low
	sbic SCL_ASM					; If SCL = 1
	rjmp SCLWaitLowCheckSDAHigh		; then jump
	rjmp SCLWaitLowCheckOk			; else jump


SCLWaitLowCheckOk:
	ldi	rReturnState, 0				; Load Immediate
	ret

SCLWaitLowCheckRS:
	ldi	rReturnState, 1				; Load Immediate
	ret

SCLWaitLowCheckStop:
	ldi	rReturnState, 2				; Load Immediate
	ret
