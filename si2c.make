#!/bin/make
# This is an example makefile on how to use the si2c-library


# This is needed by si2c-library
CPU=atmega8
F_CPU=16000000UL

# Include the makefile for si2c-Slave
include lib/si2c/si2cSlave.mk

# Our test-objects
Objects += si2cSlaveExample.o si2cTest.o



.EXPORT_ALL_VARIABLES:
.DEFAULT: firmware.hex


# Objects
%.o: %.c
	avr-gcc -g -Os -mmcu=$(CPU) -DF_CPU=$(F_CPU) -c $< -o $@


firmware.hex: $(si2cSlave) 
	avr-gcc -g -mmcu=$(CPU) `ls *.o` $(si2cSlave) -o firmware.elf
	avr-objcopy -j .text -j .data -O ihex firmware.elf $@

upload:
	sudo /usr/bin/avrdude -P usb -c avrispv2 -p m8 -e -U flash:w:firmware.hex

clean: si2cclean
	@rm -fR -v ./*.elf
	@rm -fR -v ./*.hex
	@rm -fR -v ./*.o



# Codeblocks targets

Release: clean si2cSlaveExampleInterrupt.o firmware.hex

Preprocess:
	avr-gcc -E -g -Os -mmcu=$(CPU) -DF_CPU=$(F_CPU) -c lib/si2c/si2cCheckAddress.S -o si2cText.pp

docs:
	export SOURCEDIR="../../.." && \
	cd ./doc/si2c/source && \
	doxygen
cleandocs:
	@rm -fRv doc/si2c/html
	@rm -fRv doc/si2c/latex

fuseread:
	avrdude -P usb -c avrispv2 -p m8 -n -U lfuse:r:-:b -U hfuse:r:-:b
