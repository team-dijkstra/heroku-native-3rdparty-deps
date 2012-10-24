
LIBNAME := mongoose
LIB_URL := https://github.com/downloads/valenok/mongoose/mongoose-3.3.tgz
LIB_VERSION := 3.3.0

CONFIGURE = @echo nothing to configure
BUILD = $(MAKE) linux
define INSTALL
	-mkdir -p $(INSTALLDIR)/include
	cp $(LIBNAME).h $(INSTALLDIR)/include
	cp $(LIBNAME) lib$(LIBNAME).so $(INSTALLDIR)
endef

DEPENDENCIES :=

