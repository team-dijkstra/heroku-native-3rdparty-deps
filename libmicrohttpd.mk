
LIBNAME := libmicrohttpd
LIB_URL := http://gnu.mirror.iweb.com/gnu/libmicrohttpd/libmicrohttpd-0.9.22.tar.gz
LIB_VERSION := 0.9.22

export CFLAGS := -I$(DEPDIR)/include
export LDFLAGS := -L$(DEPDIR)/lib

CONFIGURE = ./configure --prefix=$(INSTALLDIR) --disable-curl --with-gnutls --enable-https --enable-bauth --enable-dauth

# Note: currently does not build with SSL support. 
# something missing from gnutls?
DEPENDENCIES := libgcrypt gnutls

-include $(HOME)/build/heroku.mk

