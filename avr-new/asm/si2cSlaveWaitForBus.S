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


; ########################## wait for SDA/SCL low ##########################
.global si2cSlaveWaitForBus
si2cSlaveWaitForBus:

si2cSlaveWaitForBusSDA:
    sbic IS_SDA_ASM                                 ; if 1
    rjmp si2cSlaveWaitForBusSDA                     ; then loop

si2cSlaveWaitForBusSCL:
    sbic IS_SCL_ASM                                 ; if 1
    rjmp si2cSlaveWaitForBusSCL                     ; then end


; return
    ret

