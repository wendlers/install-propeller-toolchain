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
# For more information on the open source spin compiler see the project page:
#	
#		http://code.google.com/p/open-source-spin-compiler/
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
# Machine (autodetected later) for which we build
##
MACHINE="UNKNOWN"

die() {
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "$1"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	exit 1
}

banner() {
	echo "------------------------------------------------------------------------------------"
	echo "$1"
	echo "------------------------------------------------------------------------------------"
}

banner_bold() {
	echo "************************************************************************************"
	echo "************************************************************************************"
	echo "$1"
	echo "************************************************************************************"
	echo "************************************************************************************"
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
		echo "NOTE: Skipping setup - already done"
		return 
	fi

	chkbin wget
	chkbin svn 
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

	cd $BASE_DIR

	banner "Downloading and installing BST tools"

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

	s=`stamp instbst`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: Skipping BST tools - already done"
		return 
	fi

	cd $DL_DIR || dir "Unable to CD to $DL_DIR"

	wget -q $URL_BSTC    2>> $LOG >> $LOG || die "Unable to get bstc"
	wget -q $URL_BSTL    2>> $LOG >> $LOG || die "Unable to get bstl"
	wget -q $URL_BST     2>> $LOG >> $LOG || die "Unable to get bst"
	wget -q $URL_PROPBAS 2>> $LOG >> $LOG || die "Unable to get PropellerBASIC"

	cd $INST_DIR/bin || dir "Unable to CD to $TMP_DIR"

	for z in $DL_DIR/*.zip; 
	do
		unzip -o $z 2>> $LOG >> $LOG || die "Unable to unzip $z"
	done 

	cd $INST_DIR/bin

	ln -s bstc.linux bstc &> /dev/null
	ln -s bstl.linux bstl &> /dev/null
	ln -s bst.linux bst   &> /dev/null
	ln -s PropBasic-bst.linux PropBasic-bst &> /dev/null	

	cd $DL_DIR || die "Unable to CD to $DL_DIR" 

	wget -q --content-disposition "$URL_FONT" 2>> $LOG >> $LOG || die "Unable to get Parallax TTF"

	if ! [ -d $FONT_DIR ]; 
	then
		sudo mkdir $FONT_DIR || die "Unable to create $FONT_DIR" 	
	fi

	cd $FONT_DIR || die "Unable to CD to $FONT_DIR"
 
	sudo unzip -o $DL_DIR/Parallax.ttf.zip 2>> $LOG >> $LOG || die "Unable to extract Parallax TTF"
	sudo fc-cache -f -v . 2>> $LOG >> $LOG || die "Unable to update font cache"

	stampdone instbst
}

instspin() {

	cd $BASE_DIR

	banner "Installing open-source-spin-compiler"

	s=`stamp instspin.svn`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: Skipping svn checkout - already done"
	else
		svn checkout http://open-source-spin-compiler.googlecode.com/svn/ open-source-spin-compiler 2>> $LOG >> $LOG || die "Unable to checkout spin"
		stampdone instspin.svn
	fi

	s=`stamp instspin.build`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: Skipping build - already done"
	else
		cd $BASE_DIR/open-source-spin-compiler
		make 2>> $LOG >> $LOG || die "Build Failed"
		cp spin $INST_DIR/bin/. || die "Unable to copy binary to $INST_BIN/bin"
		stampdone instspin.build
	fi
}

instspinloader() {

	cd $BASE_DIR

	banner "Installing python based spin loader"

	s=`stamp instspinloader`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: Skipping svn checkout - already done"
		return
	fi

	cp $PATCH_DIR/spinloader $INST_DIR/bin/. || die "Unable to install spinloader to $INST_DIR/bin"
 	
	stampdone instspinloader
}

instgcc() {
	
	cd $BASE_DIR

	banner "Cloning, compiling and installing propgcc, may take very looooong time ..."

	s=`stamp instgcc.hg`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: Skipping hg clone - already done"
	else
		hg clone $URL_HG_PROPGCC propgcc 2>> $LOG >> $LOG || die "Unable to clone propgcc"

		stampdone instgcc.hg
	fi

	if [ "X$USE_LOADER_HACK" = "X1" ];
	then

		echo "NOTE: propeller-loader hack enabled."
		echo "NOTE: this will copy some prebuild SPIN-binaries to the build path."
		echo "NOTE: using the hack may fail, but if it works, propeller-loader and gdb are build."

		s=`stamp instgcc.lhack`
		if [ $s -eq 1 ];
		then 
			echo "NOTE: Skipping loader hack copy - already done"
		else
			cp -r $PATCH_DIR/build $BASE_DIR 
			stampdone instgcc.lhack
		fi
	fi

	s=`stamp instgcc.build`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: Skipping building - already done"
	else
		cd ./propgcc || die "Unable to CD to propgcc"

		export PATH=$INST_DIR/bin:$PATH

		./jbuild.sh $JBUILD_OPTS 2>> $LOG >> $LOG

		if ! [ "X$MACHINE" = "Xintel" ];
		then
			# on non-intel machine remove usless intel binary of bstc
			if [ -f $INST_DIR/bin/bstc.linux ];
			then
				rm $INST_DIR/bin/bstc.linux
			fi
		fi

		stampdone instgcc.build
	fi
}

instspin2cpp() {
	
	cd $BASE_DIR

	banner "Cloning, compiling and installing spin2cpp, may take some time ..."

	s=`stamp instspin2cpp.hg`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: Skipping hg clone - already done"
	else
		hg clone $URL_HG_SPIN2CPP spin2cpp 2>> $LOG >> $LOG || die "Unable to clone spin2cpp"

		stampdone instspin2cpp.hg
	fi

	s=`stamp instspin2cpp.build`

	if [ $s -eq 1 ];
	then 
		echo "NOTE: Skipping building - already done"
	else
		cd ./spin2cpp || die "Unable to CD to spin2cpp"

		make 2>> $LOG >> $LOG || die "Unable to compile spin2cpp"

		install -m 755 spin2cpp $INST_DIR/bin/.  
		stampdone instspin2cpp.build
	fi
}


clean() {

	banner_bold "Cleaning up all TMP stuff"

	cd $BASE_DIR

	rm -fr $DL_DIR
	rm -fr $STAMP_DIR
	rm -fr propgcc
	rm -fr build
	rm -fr open-source-spin-compiler
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

if [ $INSTALL_OSSPIN = 1 ];
then
	instspin
fi

if [ $INSTALL_SPINLOADER = 1 ];
then
	instspinloader
fi

if [ $INSTALL_BST = 1 ];
then
	instgcc
fi

if [ $INSTALL_SPIN2CPP = 1 ];
then
	instspin2cpp
fi

banner_bold "NOTE: BST tools and propgcc installed successfully to $INST_DIR\n\rNOTE: See $LOG for details.\n\rNOTE: It may be a good idea to add $INST_DIR/bin to your path."

exit 0
