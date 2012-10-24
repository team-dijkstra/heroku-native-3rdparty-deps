
LIBNAME := openssl
LIB_URL := http://www.openssl.org/source/openssl-1.0.1c.tar.gz
LIB_VERSION := 1.0.1c

CONFIGURE = ./config --prefix=$(INSTALLDIR) --openssldir=$(INSTALLDIR)/openssl threads shared

DEPENDENCIES :=

