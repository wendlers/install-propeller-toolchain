CC = propeller-elf-gcc
LDR = propeller-load
CFLAGS = -O -mfcache
SPIN2CPP = spin2cpp

all: blink.elf

blink.elf: blink.spin 
	$(SPIN2CPP) --elf -o blink.elf $(CFLAGS) blink.spin

load: blink.elf
	$(LDR) -r -t blink.elf -b c3
	
clean:
	rm -rf *.h *.cpp *.elf
