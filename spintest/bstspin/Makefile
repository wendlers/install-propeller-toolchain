SPINC = bstc 
SPINL = bstl 

all: blink.binary 

blink.binary: blink.spin 
	$(SPINC) $< -o $@

load: blink.binary 
	$(SPINL) $< 
	
clean:
	rm -rf *.binary
