##
# number of parallel make jobs (-j)
##
NUM_OF_PARMAKE=2

##
# select what to install 
##

# install the BST tools
INSTALL_BST=1

# install propeller gcc
INSTALL_GCC=1

##
# jbuild.sh options:
# (1) number of make threads (-j)
# (2) rm for clean buil
##
JBUILD_OPTS="$NUM_OF_PARMAKE rm"

##
# use the porpeller-loader hack (only needed for NON-Intel machines)
##
USE_LOADER_HACK=1
