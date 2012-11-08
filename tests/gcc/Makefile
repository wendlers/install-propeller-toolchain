ifndef MODEL
MODEL = lmm
endif

CC = propeller-elf-gcc
CFLAGS = -Os -m$(MODEL)

all: main.elf 

main.elf: main.c
	$(CC) -o $@ $(CFLAGS) $^ 

load: main.elf
	propeller-load -r -t main.elf -b c3
	
clean:
	rm -rf *.elf *.o
