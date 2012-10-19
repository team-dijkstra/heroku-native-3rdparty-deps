
LIBNAME := nettle
LIB_URL := ftp://ftp.lysator.liu.se/pub/security/lsh/nettle-2.5.tar.gz
LIB_VERSION := 2.5.0

CONFIGURE = ./configure --prefix=$(INSTALLDIR) --disable-dependency-tracking

DEPENDENCIES := gmp

-include $(HOME)/build/heroku.mk

