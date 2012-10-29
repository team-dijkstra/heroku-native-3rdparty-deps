
LIBNAME := mongoose
LIB_URL := https://github.com/downloads/valenok/mongoose/mongoose-3.3.tgz
LIB_VERSION := 3.3.0

CONFIGURE = echo nothing to configure
BUILD = $(MAKE) linux
define INSTALL
cp $(LIBNAME).h $(INSTALLDIR)/include
cp lib$(LIBNAME).so $(INSTALLDIR)/lib
cp $(LIBNAME) $(INSTALLDIR)/bin
endef

DIRECTORIES = $(INSTALLDIR)/include

.SECONDEXPANSION:
install: $$(INSTALLDIR)/include

DEPENDENCIES :=

