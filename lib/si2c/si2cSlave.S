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


; Additional functions ( to make code more readable )
#include "si2casm.S"

; Function to init the bus
#include "si2cWaitInit.S"

; Function to read an Byte from the bus
#include "si2cReadByte.S"

; Function to verify the address ( which was readed with ReadByte before )
#include "si2cCheckAddress.S"




#undef IsASM
