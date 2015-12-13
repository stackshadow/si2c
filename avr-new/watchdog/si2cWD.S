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

; this stuff comes from extern
.extern     si2cWDTickTickTick;
.extern     si2cWDTickTick;
.extern     si2cWDTick;

; This function reset the watchdog
.global si2cWDReset
si2cWDReset:

    clr rTemp1
    sbr rTemp1,255                  ; set
    sts si2cWDTick, rTemp1

    clr rTemp1
    sbr rTemp1,255                  ; set
    sts si2cWDTickTick, rTemp1
    
    clr rTemp1
    sbr rTemp1,5                    ; set
    sts si2cWDTickTickTick, rTemp1

    ret


; Watchdog
.global si2cWD
si2cWD:


; load and check if 0
    lds rTemp1,si2cWDTick           ; load
    cpi rTemp1,0                    ; Compare rTemp1 with 0
    breq si2cWDTickZero             ; Branch if rTemp1 == 0
; decrement
    dec rTemp1
    sts si2cWDTick,rTemp1
    rjmp si2cWDRunning
; is 0
si2cWDTickZero:
    sbr rTemp1,255
    sts si2cWDTick,rTemp1


; load and check if 0
    lds rTemp1,si2cWDTickTick       ; load
    cpi rTemp1,0                    ; Compare rTemp1 with 0
    breq si2cWDTickTickZero         ; Branch if rTemp1 == 0
; decrement
    dec rTemp1
    sts si2cWDTickTick,rTemp1
    rjmp si2cWDRunning
; is 0
si2cWDTickTickZero:
    sbr rTemp1,255
    sts si2cWDTickTick,rTemp1



; load and check if 0
    lds rTemp1,si2cWDTickTickTick   ; load
    cpi rTemp1,0                    ; Compare rTemp1 with 0
    breq si2cWDTickTickTickZero     ; Branch if rTemp1 == 0
; decrement
    dec rTemp1
    sts si2cWDTickTickTick,rTemp1
    rjmp si2cWDRunning
; is 0
si2cWDTickTickTickZero:
    rjmp si2cWDTickFinished


si2cWDRunning:
	ldi rReturnState, 1
    ret

si2cWDTickFinished:
	ldi rReturnState, 0             ; set return state to 0 ( timer is finished )
    ret
    
