#!/bin/make
# This makefile needs to be included in your main-makefile

ifndef CPU
$(error Variable "CPU" is not set)
endif

ifndef CPU
$(error Variable "F_CPU" is not set)
endif

# Our i2c-object-files
si2c += lib/si2c/si2c.o
si2cSlave += $(si2c) lib/si2c/si2cSlave.o lib/si2c/si2cWaitInit.asmo lib/si2c/si2cReadByte.asmo lib/si2c/si2cCheckAddress.asmo

# si2c-objects
lib/si2c/%.o: lib/si2c/%.c
	avr-gcc -g -Os -mmcu=$(CPU) -DF_CPU=$(F_CPU) -c $< -o $@

lib/si2c/%.asmo: lib/si2c/%.S
	avr-gcc -g -Os -mmcu=$(CPU) -DF_CPU=$(F_CPU) -c $< -o $@



si2cclean:
	@rm -f -v lib/si2c/*.elf
	@rm -f -v lib/si2c/*.hex
	@rm -f -v lib/si2c/*.o
	@rm -f -v lib/si2c/*.asmo
