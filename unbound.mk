
# Note: this gives spurious warnings that 
# 'libunbound.la was not installed in...' even though it has.
#
LIBNAME := unbound
LIB_URL := http://www.unbound.net/downloads/unbound-1.4.18.tar.gz
LIB_VERSION := 1.4.18

# remove documentation from the bundle.
#
DOCDIR := /tmp/discard
LIB_DOCS := info man doc

# NB cannot build --with-libunbound-only, since the install phase fails.
#
CONFIGURE = ./configure --prefix=$(INSTALLDIR) --with-pthreads $(patsubst %,--%dir=$(DOCDIR),$(LIB_DOCS))

# required to build, but can probably use gnutls ssl at runtime. 
# (circular dependency)
DEPENDENCIES := openssl ldns

