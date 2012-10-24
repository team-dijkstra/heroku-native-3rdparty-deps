
LIBNAME := boost
LIB_URL := http://sourceforge.net/projects/boost/files/boost/1.51.0/boost_1_51_0.tar.bz2
LIB_VERSION := 1.51.0

CONFIGURE = ./bootstrap.sh --prefix=$(INSTALLDIR)
BUILD = ./b2 
INSTALL = ./b2 install

DEPENDENCIES := bzip2

# add mpi support to the build
config-extra: config
	echo 'using mpi ;' >> user-config.jam
build: config-extra

