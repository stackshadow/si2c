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

; set SDA to output ( default is low )
   	SET_ASM( DDR, confi2cSDAPort, confi2cSDAPin );

; ################## wait for SCL high ##################
si2cSlaveACK001:
    sbic IS_SCL_ASM                     ; if 1
    rjmp si2cSlaveACK002                ; then
    rjmp si2cSlaveACK001                ; else



; ################## wait for SCL low ##################
si2cSlaveACK002:
    sbis IS_SCL_ASM                     ; if 0
    rjmp si2cSlaveACK003                ; then
    rjmp si2cSlaveACK002                ; else

si2cSlaveACK003:
; set SDA to input
   	CLR_ASM( DDR, confi2cSDAPort, confi2cSDAPin );

; return
	ret