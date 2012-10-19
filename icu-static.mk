
#
# For building a statically linked variant of the icu library.
# This can make the resulting application binaries smaller if only some 
# parts of ICU are used.
#
LIBNAME := icu-static
LIB_URL := http://download.icu-project.org/files/icu4c/49.1.2/icu4c-49_1_2-src.tgz
LIB_VERSION := 49.1.2

#
# The following settings are recommended, but do not work for building the libraries.
# It seems that the library itself depends on it's own depracated features. wtf?
#
# CFLAGS = -DU_NO_DEFAULT_INCLUDE_UTF_HEADERS=1
# CXXFLAGS = -DUNISTR_FROM_STRING_EXPLICIT=explicit -DUNISTR_FROM_CHAR_EXPLICIT=explicit

# required for configure.
export CFLAGS = -fno-exceptions -DU_CHARSET_IS_UTF8=1
export CXXFLAGS = -DU_USING_ICU_NAMESPACE=0 $(CFLAGS)

CONFIGURE = ./icu/source/runConfigureICU Linux --disable-renaming --enable-static --disable-shared --with-data-packaging=archive --prefix=$(INSTALLDIR)

DEPENDENCIES :=

-include $(HOME)/build/heroku.mk

