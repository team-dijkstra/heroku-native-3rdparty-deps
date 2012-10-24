
LIBNAME := gmp
LIB_URL := ftp://ftp.gnu.org/gnu/gmp/gmp-5.0.5.tar.xz
LIB_VERSION := 5.0.5

CONFIGURE = ./configure --prefix=$(INSTALLDIR) --enable-cxx

DEPENDENCIES :=

