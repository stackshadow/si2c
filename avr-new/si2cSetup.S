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


; ########################## Setup Hardware ##########################
.global si2cSetup
si2cSetup:
; Disable Pull up ( just to be sure )
	CLR_ASM( PORT, confi2cSCLPort, confi2cSCLPin );
	CLR_ASM( PORT, confi2cSDAPort, confi2cSDAPin );

; Set Ports to input
	CLR_ASM( DDR, confi2cSCLPort, confi2cSCLPin );
	CLR_ASM( DDR, confi2cSDAPort, confi2cSDAPin );
    
; setup i2c
    ldi rTemp1, confi2cAddress
    sts si2cAddress,rTemp1

ret

