#!/bin/make
# This is an example makefile on how to use the si2c-library


# First we define some variables
CPU=atmega8
F_CPU=16000000UL
Objects += si2cSlaveExample.o si2cTest.o

# Include the makefile for si2c-Slave
include lib/si2c/si2cSlave.mk


# Objects
%.o: %.c
	avr-gcc -g -Os -mmcu=$(CPU) -DF_CPU=$(F_CPU) -c $< -o $@


firmware.hex: $(si2cSlave)
	avr-gcc -g -mmcu=$(CPU) `ls *.o` $(si2cSlave) -o firmware.elf
	avr-objcopy -j .text -j .data -O ihex firmware.elf $@

Upload:
	sudo /usr/bin/avrdude -P usb -c avrispv2 -p m8 -e -U flash:w:firmware.hex

clean:
	@rm -f -v ./*.elf
	@rm -f -v ./*.hex
	@rm -f -v ./*.o
	@rm -f -v ./*.asmo


# Codeblocks targets

Release: si2cSlaveExample.o firmware.hex
cleanRelease: si2cclean clean

Interrupt: si2cSlaveExampleInterrupt.o firmware.hex
cleanInterrupt: si2cclean clean

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
