##
# number of parallel make jobs (-j)
##
NUM_OF_PARMAKE=2

##
# select what to install 
##

# install the BST tools
INSTALL_BST=1

# install the open-source spin compiler 
INSTALL_OSSPIN=1

# install the python based spin loader 
INSTALL_SPINLOADER=1

# install propeller gcc
INSTALL_GCC=1

# install spin2cpp
INSTALL_SPIN2CPP=1

##
# propgcc options:
##
MAKE_OPTS="-j$NUM_OF_PARMAKE"

##
# X11 customfont install location for BST
##
FONT_DIR=/usr/share/fonts/truetype/parallax

##
# BST tools source URLs
##
URL_BSTC="http://www.fnarfbargle.com/bst/bstc/Latest/bstc-0.15.3.linux.zip"
URL_BSTL="http://www.fnarfbargle.com/bst/bstl/Latest/bstl.linux.zip"
URL_BST="http://www.fnarfbargle.com/bst/Latest/bst-0.19.3.linux.zip"
URL_PROPBAS="http://www.fnarfbargle.com/PropBasic/PropBasic-bst-00.01.14-79.linux.zip"
URL_FONT="http://forums.parallax.com/attachment.php?attachmentid=53903&d=1212437073"

##
# URL for mercurial repo of propgcc
##
URL_HG_PROPGCC="https://code.google.com/p/propgcc/"

##
# URL for mercurial repo of spin2cpp
##
URL_HG_SPIN2CPP="https://code.google.com/p/spin2cpp/"

