# si2c

Software based I²C library ( I²C-Slave ) for AVR's atmega

## Whats inside
* software i2c-slave for avr's atmega family
* software i2c-master for raspberry pi ( or all devices which support wiringPi )

## Features not finished yet
* time-streching
* software i2c-master for avr's atmega


## That works
* read and write from raspberry to atmega8 over pins you can choose ;)
* use speeds at your own choise

## Need to be tested
* use of interrupt


## How to start

### Dependencies
* make
* avr-gcc
* gcc
* wiringPi-library ( on raspberry )

### On AVR's site
#### Setup
Please change the variables inside si2cConfig.h in the avr/ folder
#### build
* change to directory avr
* run make
* upload the firmware to your atmega ;)

### Raspberry
#### Setup
Use the function si2cMasterSetup() to change pins ( or the "-c" option from command line )
#### build
* change to directory gpio
* run make
#### usage
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
