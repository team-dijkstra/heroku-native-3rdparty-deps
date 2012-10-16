
LIBNAME := boost
LIB_URL := http://sourceforge.net/projects/boost/files/boost/1.51.0/boost_1_51_0.tar.gz
LIB_VERSION := 1.51.0

CONFIGURE = ./bootstrap.sh --prefix $(INSTALLDIR)
BUILD = @echo build deferred to install
INSTALL = ./b2 install

DEPENDENCIES := bzip2

-include $(HOME)/build/heroku.mk
