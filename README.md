Parallax Toolchain Installer Script for Linux
=============================================

(c) 2012 Stefan Wendler
sw@kaltpost.de
http://gpio.kaltpost.de/

Introduction
------------

Simple shell script to install Parallax-Propeller toolchain, including the BST tools and the Propeller GCC. 

The script will first try to download and install the The multi-platform Propeller Tool Suite including:

* bst - The GUI IDE
* bstc - The command line compiler
* bstl - The command line loader
* PropBASIC - The Propeller BASIC

For more information on the BST tools see this the [BST homepage] (http://www.fnarfbargle.com/bst.html)

Next, it will clone the Propeller GCC sources.

For more information on porp GCC see the [propgcc homepage] (http://code.google.com/p/propgcc/)


Non Intel Build Hosts
---------------------

Using this scripts on a non intel build host does only work patially. This is because the
propeller-loader tool releays on the bstc.linux binary which is a intel binary. At the moment
the loader fails to build, no poropeller-gdb will be build since it relais on the loader library.
However, on a ARM machine you will end up with a working propeller-gcc including wirkin C-libraries
and binutils, but you will not get the loader nor gdb. 

However, it is possible to copy the SPIN binaries genarated on a intel platform to the non 
intel build host, and make propeller-loader and gdb compile. If you like to try that, you
could enable "USE_LOADER_HACK" in the "config.inc" file.

Requirements
------------

* A working GCC environment on the host system you are building is required.
* Mercurial needs to be installed.
* Internet conenction is required.


Usage
-----

For various user setting see "config.inc".

To build and install the whole toolchain:

	./install-propeller-toolchain.sh

NOTE: the script may ask you for your root password to make the install dir with "sudo".

After the script installed everything, you might want to add "/opt/parallax/bin" to yout path.

To clean up all temporary stuff:

	./install-propeller-toolchain.sh clean


Check the Result
----------------

** Check Propeller GCC

Change to the gcctest subdirectory containing a simple "hello-world" which blinks all the build in LEDs of the 
Parallax QuickStart board and prints out some message through the serial line and build the sources:

	cd ./gcctest
	export PATH=/opt/parallax/bin:$PATH
	make

This should produce a "main.elf" binary. Load this to the propeller:

	make load

Enjoy!


** BST Spin

TODO

