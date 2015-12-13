
# paths
sourceDir=$(PWD)/avr-new
buildDir=/tmp/i2c

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

# files
sources += si2cSlave.c
sources += firmwareTest.c
sourcesASM += si2cSlave.S

# This is needed by si2c-library
CPU=atmega8
F_CPU=8000000UL




sourcesFull=$(addprefix $(sourceDir)/,$(objects))
objects=$(sources:.c=.o)
objectsFull=$(addprefix $(buildDir)/,$(objects))
objectsASM=$(sourcesASM:.S=.asmo)
objectsASMFull=$(addprefix $(buildDir)/,$(objectsASM))







# Objects
$(buildDir)/%.o: $(sourceDir)/%.c
	@echo "CC $<"
	@avr-gcc -g -Os -Wall -mmcu=$(CPU) -DF_CPU=$(F_CPU) $(CFLAGS) \
	-c $< -o $@
#	avr-gcc -g -S -fverbose-asm -Wall -mmcu=$(CPU) -DF_CPU=$(F_CPU) $(CFLAGS) \
#    -c $< -o $@.asm

$(buildDir)/%.asmo: $(sourceDir)/%.S
	@echo "ASM $<"
	@avr-gcc -g -Wall -mmcu=$(CPU) -DF_CPU=$(F_CPU) $(CFLAGS) \
	-c $< -o $@

$(buildDir):
	mkdir -p $(buildDir)

$(buildDir)/firmware.hex: $(buildDir) $(objectsFull) $(objectsASMFull)
	avr-gcc -g -mmcu=$(CPU) $(objectsFull) $(objectsASMFull) -o $(buildDir)/firmware.elf
	avr-objcopy -j .text -j .data -O ihex $(buildDir)/firmware.elf $@

firmware: $(buildDir)/firmware.hex

clean:
	@$(RM) $(objectsFull) 
	@$(RM) $(objectsASMFull)
	@$(RM) $(buildDir)/firmware.elf
	@$(RM) $(buildDir)/firmware.hex
	@$(RM) $(buildDir)/*.asm

simulation:
	simulavr -g -P simulavr-disp -d atmega8 $(buildDir)/firmware.elf &


upload: clean $(buildDir)/firmware.hex
	sudo /usr/bin/avrdude -P usb -c avrispv2 -p m8 -e -U flash:w:$(buildDir)/firmware.hex

fuseread:
	avrdude -P usb -c avrispv2 -p m8 -n -U lfuse:r:-:b -U hfuse:r:-:b

writeint:
	avrdude -P usb -c avrispv2 -p m8 -U lfuse:w:0xe4:m -U hfuse:w:0xd9:m
