
LIBNAME := bzip2
LIB_URL := http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
LIB_VERSION := 1.0.6

CONFIGURE = @echo nothing to do for configure
BUILD = @echo build deferred to install stage
INSTALL = $(MAKE) install PREFIX=$(INSTALLDIR)

DEPENDENCIES :=

-include $(HOME)/build/heroku.mk
