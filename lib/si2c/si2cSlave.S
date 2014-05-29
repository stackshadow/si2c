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
; This file includes all asm-files to handle i2c-slave communication Project


#define IsASM

#include "si2c_config.h"
#include "si2c.h"
#include <avr/io.h>

; Global vars from C
.extern si2cByte


; Including all needed functions
#include "si2cAdditional.S"
#include "si2cSCL.S"
#include "si2cSlaveWaitInit.S"
#include "si2cSlaveReadByte.S"
#include "si2cSlaveCheckAddress.S"

.globl si2cSlave					; Register Function for C
si2cSlave:

; wait for bus init
	rcall si2cSlaveWaitInit

; read one byte from bus ( The address )
	rcall si2cSlaveReadByte

; Check Address
	rcall si2cSlaveCheckAddress



	si2cSlaveEnd: nop

ret










































#undef IsASM
