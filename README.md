Parallax Tool-Chain Installer Script for Linux
=============================================

(c) 2012 Stefan Wendler
sw@kaltpost.de
http://gpio.kaltpost.de/


Introduction
------------

Simple shell script to install a Parallax-Propeller tool-chain, including:

* BST tools (compiler, PropBasic, loader, IDE + Propeller TTF)
* Propeller GCC 
* open-source-spin-compiler
* Python based spin-loader from the propeller forums (Loader.py)
* spin2cpp, a SPIN to C++ compiler


For more information on the BST tools see this the [BST homepage] (http://www.fnarfbargle.com/bst.html)

For more information on porp GCC see the [propgcc homepage] (http://code.google.com/p/propgcc/)

For more information on the open-source-spin-compiler see the [project page] (http://code.google.com/p/open-source-spin-compiler/)

The Python based loader is from Remy Blank and I was not able to find a web-page for that tool.
 
For more information on spin2cpp see the [project page] (http://code.google.com/p/spin2cpp/)


Non Intel Build Hosts
---------------------

Using this scripts on a non Intel build host does only work partially. This is because the
propeller-loader tool relays on the bstc.Linux binary which is a Intel binary. At the moment
the loader fails to build, no propeller-gdb will be build since it relays on the loader library.
However, on a ARM machine you will end up with a working propeller-gcc including working C-libraries
and binutils, but you will not get the loader nor gdb. 

However, it is possible to copy the SPIN binaries generated on a Intel platform to the non 
Intel build host, and make propeller-loader and gdb compile. If you like to try that, you
could enable "USE_LOADER_HACK" in the "config.inc" file.


Requirements
------------

* A working GCC environment on the host system you are building is required for gcc.
* Mercurial needs to be installed to build gcc.
* Internet connection is required.
* For the python based loader, python2.6 with py-serial is required
* SVN is required to build the open-source-spin-compiler.


Usage
-----

For various user setting see "config.inc".

To build and install the whole tool-chain:

	./install-propeller-toolchain.sh

NOTE: the script may ask you for your root password to make the install dir with "sudo".

After the script installed everything, you might want to add "/opt/parallax/bin" to your path.

To clean up all temporary stuff:

	./install-propeller-toolchain.sh clean


Check the Result
----------------

*Check Propeller GCC*

Change to the "tests/gcc" subdirectory containing a simple "hello-world" which blinks all the build in 
LEDs of the Parallax Quick-Start board and prints out some message through the serial line and build 
the sources:

	cd ./tests/gcc
	export PATH=/opt/parallax/bin:$PATH
	make

This should produce a "main.elf" binary. Load this to the propeller with:

	make load


*Check open-source-spin-compiler and spin-loader*

Change to "test/spin/oss" subdirectory containing a simple SPIN program which blinks the LED on 
P16:

	cd ./tests/spin/oss
	export PATH=/opt/parallax/bin:$PATH
	make

This should produce a "blinky.binary" binary. Load this to the propeller with:

	make load


*Check BST Spin Command-line*

Change to "test/spin/bst" subdirectory containing a simple SPIN program which blinks the LED on 
P16:

	cd ./test/spin/bst
	export PATH=/opt/parallax/bin:$PATH
	make

This should produce a "blinky.binary" binary. Load this to the propeller with:

	make load


*Check BST Spin GUI*

The above SPIN code (blinky.spin) could also be compiled and uploaded to the propeller through
the GUI. To start the GUI:

	bst

Then, in the file-explorer on the left navigate to the sample code and open it. Then go to 
compile, to compile and upload your program.  

Note: in the editor, check if the font looks "right" otherwise something went wrong
withe the installation of the Propeller TTF-font.

*Check spin2cpp*

Change to "tests/spin2cpp" subdirectory containing a simple SPIN program which blinks the LED on 
P16:

	cd ./tests/spin2cpp
	export PATH=/opt/parallax/bin:$PATH
	make

This should produce a "blinky.h", "blink.cpp" and the "blink.elf" binary from the file
"blink.spin". Load this to the propeller with:

	make load
