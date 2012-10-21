
LIBNAME := gnutls
LIB_URL := ftp://ftp.gnu.org/gnu/gnutls/gnutls-3.0.25.tar.xz
LIB_VERSION := 3.0.25

# remove documentation from the bundle.
#
DOCDIR := /tmp/discard
LIB_DOCS := info man doc

# required for configure to detect pkg-config dependencies
#
export P11_KIT_CFLAGS = -I$(DEPDIR)/include/p11-kit-1
export P11_KIT_LIBS = -L$(DEPDIR)/lib -lp11-kit

CONFIGURE = ./configure --prefix=$(INSTALLDIR) --enable-threads=posix --with-libnettle-prefix=$(DEPDIR) --disable-gtk-doc-html $(patsubst %,--%dir=$(DOCDIR),$(LIB_DOCS))

DEPENDENCIES := gmp nettle libtasn1 p11-kit unbound ldns

-include $(HOME)/build/heroku.mk
