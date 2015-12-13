# si2c

Software based I²C library ( I²C-Slave ) for AVR's atmega

## Whats inside
* software i2c-slave for avr's atmega family
* software i2c-master for raspberry pi ( or all devices which support wiringPi )

## Features not finished yet
* time-streching
* software i2c-master for avr's atmega
* software watchdog ( please use the watchdog of your atmega )


## That works
* read and write from raspberry to atmega8 over pins you can choose ;)
* use speeds at your own choise


## How to start

### Dependencies
* make
* avr-gcc
* gcc
* wiringPi-library ( on raspberry )

### On AVR's site
#### Setup
Please change the variables inside config.h in the avr/ folder
#### build
* change to source-directory
* run make -f make/MakefileAVR.mk firmware


### Raspberry
#### build
* change to source-directory
* run make -f make/MakefileGPIO.mk si2c

#### Command line interface
```
Usage:
-c <SDA-Port> <SCL-Port> <TIME>
-i: init - set SDA/SCL to high
-as <address>: send address on write mode
-ar <address>: send address on read mode
-s: Send i2c-Start
-r <byte>: Read i2c-byte
-w <byte>: Send i2c-byte
-e: Send i2c-stop
-t <chipAddress>: Test if address is present
```

For example, if you would like to send an byte
```
si2c -c 17 27 1 -i -s -as 4 -w 1 -w 1
```
- this will send byte 1 to register 1
- the target chip Address is 4
- SDA-Pin is GPIO 17
- SCL-Pin is GPIO 27


