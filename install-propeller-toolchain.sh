#!/bin/sh

################################################################################
#
# Simple helper script for installing BST Tools and propgcc to "/opt/parallax"
#
# 02.09.2012, Stefan Wendler, sw@kaltpost.de
# http://gpio.kaltpost.de
#
# NOTE: the script may ask you for your root password to make the install dir
#       with "sudo".
# 
# For more information on the BST tools see this the BST homepage:
# 
#   	http://www.fnarfbargle.com/bst.html
#
# For more information on porp GCC see the propgcc homepage:
#
#		http://code.google.com/p/propgcc/
#
################################################################################

##
# base dir where all the building happens
##
BASE_DIR=$PWD

. $PWD/config.inc

##
# log file for the whole thing
##
LOG=$BASE_DIR/install.log

##
# temporary downloads go here
##
DL_DIR=$BASE_DIR/download

##
# where to install all the stuff (do not change, since the porpgcc goes only here)
##
INST_DIR=/opt/parallax

##
# Stamp dir
##
STAMP_DIR=$BASE_DIR/stamp

##
# patches
##
PATCH_DIR=$BASE_DIR/patches

##
# user and group to set for $INST_DIR
##
INST_USR=$USER
INST_GROUP=$USER

##
# BST tools source URLs
##
URL_BSTC=http://www.fnarfbargle.com/bst/bstc/Latest/bstc-0.15.3.linux.zip
URL_BSTL=http://www.fnarfbargle.com/bst/bstl/Latest/bstl.linux.zip
URL_BST=http://www.fnarfbargle.com/bst/Latest/bst-0.19.3.linux.zip
URL_PROPBAS=http://www.fnarfbargle.com/PropBasic/PropBasic-bst-00.01.14-79.linux.zip

##
# URL for mercurial repo of propgcc
##
URL_HG_PROPGCC=https://code.google.com/p/propgcc/

MACHINE="UNKNOWN"

die() {
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "$1"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	exit 1
}

banner() {
	echo "-------------------------------------------------------------------------------"
	echo "$1"
	echo "-------------------------------------------------------------------------------"
}

banner_bold() {
	echo "*******************************************************************************"
	echo "*******************************************************************************"
	echo "$1"
	echo "*******************************************************************************"
	echo "*******************************************************************************"
}
stamp() {
	
	if [ -f $STAMP_DIR/$1 ];
	then 
		echo 1
	else
		echo 0
	fi
}

stampdone() {
	touch $STAMP_DIR/$1	
}

chkbin() {
	which $1 > /dev/null || die "$1 not found in path"
}

mdine() {
	test -d $1 || mkdir $1 2> /dev/null
	test -d $1 || die "Unable to create directory $1"
}

detectp() {
	m=$(uname -m)

	case $m in
    "i386")
		MACHINE="intel"
        ;;
    "i686")
		MACHINE="intel"
        ;;
	"x86_64")
		MACHINE="intel"
		;;
	esac
}

setup() {

	banner "Setting up environment"

	mdine $STAMP_DIR

	s=`stamp setup`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: skipping - already done"
		return 
	fi

	chkbin wget
	chkbin hg
	chkbin sudo 

	mdine $DL_DIR

	rm -fr $DL_DIR/* 2> /dev/null 
	rm -fr propgcc 2> /dev/null 

	sudo rm -fr $INST_DIR 2> /dev/null	
	sudo mkdir $INST_DIR
	sudo chown $INST_USR:$INST_GROUP $INST_DIR -R
	sudo chmod g+w $INST_DIR

	mdine $INST_DIR/bin

	stampdone setup
}

instbst() {

	banner "Installing BST tools"

	if ! [ "X$MACHINE" = "Xintel" ];
	then
		echo "NOTE: Skipping BST tools install for non intel machine"

		if [ "X$USE_LOADER_HACK" = "X" ];
		then
			echo "NOTE: most likely your machine will fail building propeller-loader"
			echo "NOTE: no propeller-loader prevents building propeller-gdb"
			echo "NOTE: however, a usable propeller-gcc with libs and binutils will be installed"
		fi
		return
	fi		

	banner "Downloading BST tools"

	s=`stamp instbst`

	if [ $s -eq 1 ];
	then 
		echo "skipping - already done"
		return 
	fi

	cd $DL_DIR || dir "Unable to CD to $DL_DIR"

	wget -q $URL_BSTC    2>&1 >> $LOG || die "Unable to get bstc"
	wget -q $URL_BSTL    2>&1 >> $LOG || die "Unable to get bstl"
	wget -q $URL_BST     2>&1 >> $LOG || die "Unable to get bst"
	wget -q $URL_PROPBAS 2>&1 >> $LOG || die "Unable to get PropellerBASIC"

	cd $INST_DIR/bin || dir "Unable to CD to $TMP_DIR"

	banner "Extracting BST tools"

	for z in $DL_DIR/*.zip; 
	do
		unzip $z 2>&1 >> $LOG || die "Unable to unzip $z"
	done 

	cd $INST_DIR/bin

	ln -s bstc.linux bstc
	ln -s bstl.linux bstl
	ln -s bst.linux bst
	ln -s PropBasic-bst.linux PropBasic-bst	

	## TODO: install propeller font ...

	stampdone instbst
}

instgcc() {
	
	cd $BASE_DIR

	banner "Cloning, compiling and installing propgcc, may take very looooong time ..."

	if [ "X$USE_LOADER_HACK" = "X1" ];
	then

		echo "NOTE: propeller-loader hack enabled."
		echo "NOTE: this will copy some prebuild SPIN-binaries to the build path."
		echo "NOTE: using the hack may fail, but if it works, propeller-loader and gdb are build."

		s=`stamp instgcc.lhack`
		if [ $s -eq 1 ];
		then 
			echo "NOTE: skipping loader hack copy - already done"
		else
			cp -a $PATCH_DIR/build $BASE_DIR 
			stampdone instgcc.lhack
		fi
	fi

	s=`stamp instgcc.hg`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: skipping hg clone - already done"
	else
		hg clone $URL_HG_PROPGCC propgcc 2>&1 >> $LOG || die "Unable to clone propgcc"

		stampdone instgcc.hg
	fi

	s=`stamp instgcc.build`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: skipping building - already done"
	else
		cd ./propgcc || die "Unable to CD to propgcc"

		export PATH=$INST_DIR/bin:$PATH

		./jbuild.sh $JBUILD_OPTS >> $LOG 2>> $LOG

		stampdone instgcc.build
	fi
}

clean() {

	banner_bold "Cleaning up all TMP stuff"

	cd $BASE_DIR

	rm -fr $DL_DIR
	rm -fr $STAMP_DIR
	rm -fr propgcc
	rm -fr build
	rm $LOG 2> /dev/null
}

if [ "X$1" = "Xclean" ];
then
	clean
	exit 1
fi

banner_bold "Installing BST tools and propgcc"

detectp
setup

if [ $INSTALL_BST = 1 ];
then
	instbst
fi

if [ $INSTALL_BST = 1 ];
then
	instgcc
fi

banner_bold "NOTE: BST tools and propgcc installed successfully to $INST_DIR\n\rNOTE: See $LOG for details.\n\rNOTE: It may be a good idea to add $INST_DIR/bin to your path."

exit 0
