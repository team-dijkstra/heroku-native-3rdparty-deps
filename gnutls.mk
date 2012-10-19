
LIBNAME := gnutls
LIB_URL := ftp://ftp.gnu.org/gnu/gnutls/gnutls-3.1.3.tar.xz
LIB_VERSION := 3.1.3

CONFIGURE = ./configure --prefix=$(INSTALLDIR) --disable-dependency-tracking --enable-threads=posix --disable-gtk-doc-html

DEPENDENCIES := gmp nettle

-include $(HOME)/build/heroku.mk
