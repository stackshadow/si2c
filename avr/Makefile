# paths
buildDir=.build
sourceDir=./


sources=si2cSlaveExample.c
sourcesFull=$(addprefix $(sourceDir)/,$(objects))

objects=$(sources:.c=.o)
objects+=si2cSlave.asmo
objectsFull=$(addprefix $(buildDir)/,$(objects))

# Progs
GCC=gcc
RM=rm -f -R -v
MKDIR=mkdir -p -v
CFLAGS+=-g -Os -Wall -I$(sourceDir)
LDFLAGS=

CFLAGS+=-I$(sourceDir)
ifneq  '$(useStatusLED)' ''
	CFLAGS+=-DSI2C_USE_STATUS
endif

# This is needed by si2c-library
CPU=atmega8
F_CPU=16000000UL


$(buildDir)/firmware.hex:

# Objects
$(buildDir)/%.o: $(sourceDir)/%.c
	avr-gcc -g -Os -Wall -mmcu=$(CPU) -DF_CPU=$(F_CPU) $(CFLAGS) -c $< -o $@

$(buildDir)/%.asmo: $(sourceDir)/%.S
	avr-gcc -g -Os -Wall -mmcu=$(CPU) -DF_CPU=$(F_CPU) $(CFLAGS) -c $< -o $@

$(buildDir):
	mkdir -p $(buildDir)

$(buildDir)/firmware.hex: $(buildDir) $(objectsFull)
	avr-gcc -g -mmcu=$(CPU) $(objectsFull) -o $(buildDir)/firmware.elf
	avr-objcopy -j .text -j .data -O ihex $(buildDir)/firmware.elf $@



clean:
	@rm -fRv ./.build

simulation:
	simulavr -g -P simulavr-disp -d atmega8 firmware.elf &


upload: clean $(buildDir)/firmware.hex
	sudo /usr/bin/avrdude -P usb -c avrispv2 -p m8 -e -U flash:w:$(buildDir)/firmware.hex

fuseread:
	avrdude -P usb -c avrispv2 -p m8 -n -U lfuse:r:-:b -U hfuse:r:-:b
