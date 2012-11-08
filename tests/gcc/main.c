#include <propeller.h>
#include <stdio.h>

void main()
{
	int i;

	printf("Hallo Propeller!\n");

	// set build in LEDs (pins 16..23) to output
	for(i = 0; i < 8; i++) 
	    DIRA |= (1 << 16 + i);
	
	while(1) {
		
		// turn em all on	
		for(i = 0; i < 8; i++) {
			printf("on LED@pin%i\n", 16 + i);
	    	OUTA |= (1 << 16 + i);	
			// wait for on sec.
			waitcnt(CLKFREQ + CNT);
		}

		// turn off all LEDs
		for(i = 7; i >= 0;  i--) {
			printf("off LED@pin%i\n", 16 + i);
	    	OUTA &= ~((1 << 16 + i));	
			// wait for on sec.
			waitcnt(CLKFREQ + CNT);
		}

		printf("WOW! Thats easy! Once more ...\n");
	}
} 
