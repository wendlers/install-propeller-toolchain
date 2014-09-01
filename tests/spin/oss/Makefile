SPINC = openspin 
SPINL = spinloader

all: blink.binary 

blink.binary: blink.spin 
	$(SPINC) $<

load: blink.binary 
	$(SPINL) $< 
	
clean:
	rm -rf *.binary
