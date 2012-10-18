
LIBNAME := log4cpp
LIB_URL := http://sourceforge.net/projects/log4cpp/files/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1rc3.tar.gz
LIB_VERSION := 1.1rc3

# Note: Issues warnings about --with-pthreads switch, even though it is
# listed in the docs... done automatically?
#
CONFIGURE = ./log4cpp/configure --prefix=$(INSTALLDIR) --disable-doxygen --with-pthreads

DEPENDENCIES :=

-include $(HOME)/build/heroku.mk
