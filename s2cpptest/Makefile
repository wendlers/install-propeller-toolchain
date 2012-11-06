CC = propeller-elf-gcc
CFLAGS = -O -mfcache
SPIN2CPP = spin2cpp
SPINL = spinloader

all: blink.elf

blink.elf: blink.spin 
	$(SPIN2CPP) --elf -o blink.elf $(CFLAGS) blink.spin

load: blink.binary 
	$(SPINL) $< 
	
clean:
	rm -rf *.elf
