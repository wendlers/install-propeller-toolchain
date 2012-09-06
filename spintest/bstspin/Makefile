SPINC = bstc 
SPINL = bstl 

all: blink.binary 

blink.binary: blink.spin 
	$(SPINC) -b $< 

load: blink.binary 
	$(SPINL) $< 
	
clean:
	rm -rf *.binary
