# si2c
====

Software based I²C library ( I²C-Slave ) for AVR's atmega


## How to start
====

### Integrate in your Project

To integrate the si2c-library in your Project just copy the "lib/si2c" Folder to your Project.

If you use Make, add this to your Makefile:

```Makefile
# This is needed by si2c-library
CPU=atmega8
F_CPU=16000000UL

# Include the makefile for si2c-Slave
include lib/si2c/si2cSlave.mk
```

And this is the final rule, to create the firmware for atmega:

```Makefile
firmware.hex: $(si2cSlave) 
	avr-gcc -g -mmcu=$(CPU) `ls *.o` $(si2cSlave) -o firmware.elf
	avr-objcopy -j .text -j .data -O ihex firmware.elf $@
```

### Configuration

Edit the si2c_config.h
or [see here](https://stackshadow.github.io/si2c/group__si2c__config.html#si2c_config) on how to do that

### Add function
There are two functions defined which can read/write from/to registers.


si2cSlaveReadRegister