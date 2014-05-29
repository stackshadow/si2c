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


.global SCLWaitHigh
SCLWaitHigh:
	nop
	sbis IS_SCL_ASM
	rjmp SCLWaitHigh
ret

;.globl SCLWaitLow					; Register Function for C
;SCLWaitLow:
;	nop
;	sbic IS_SCL_ASM
;	rjmp SCLWaitLow
;ret


.globl SCLWaitLow					; Register Function for C
SCLWaitLow:

; save state of sda in r17
	sbis IS_SDA_ASM
	rjmp SDALow
	rjmp SDAHigh


	; If sda was high and get low -> repeadet start
	SDAHigh:

	; Check if scl gets low
		nop
		sbis IS_SCL_ASM
		rjmp SCLWaitLowEnd

	; sda gets low ?
		nop
		sbic IS_SDA_ASM					; (s)kip if (b)it (i)s (c)lear
		rjmp SDAHigh

		rjmp si2cSlave					; repeated start occure

		rjmp SDAHigh

	; If sda was low and get high -> stop
	SDALow:

	; Check if scl gets low
		nop
		sbis IS_SCL_ASM
		rjmp SCLWaitLowEnd

	; sda gets high ?
		nop
		sbis IS_SDA_ASM					; (s)kip if (b)it (i)s (s)et
		rjmp SDALow

		rjmp si2cSlaveEnd				; stop occure

		rjmp SDALow

SCLWaitLowEnd:
	ret
