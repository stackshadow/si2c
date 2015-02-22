# paths
sourceDir=./
buildDir=.build


sources+=si2c.c
sources+=si2cMaster.c
sourcesFull=$(addprefix $(sourceDir)/,$(sources))

objects=$(sources:.c=.o)
objectsFull=$(addprefix $(buildDir)/,$(objects))

# Progs
GCC=gcc
RM=rm -f -R -v
MKDIR=mkdir -p -v
CFLAGS+=-g -Os -Wall -I$(sourceDir)
LDFLAGS=
ifeq '$(shell uname -m)' 'armv6l'
	LDFLAGS=-lwiringPi
endif

# Target
$(buildDir)/si2c: $(objectsFull)
	$(GCC) $(CFLAGS) $(LDFLAGS) $^ -o $@

clean:
	@$(RM) $(buildDir)
	@$(RM) $(buildDir)/si2c

# Folders
$(buildDir):
	@$(MKDIR) -v -p $@

# Objects
$(buildDir)/%.o: $(sourceDir)/%.c $(buildDir)
	$(GCC) $(CFLAGS) -c $< -o $@


