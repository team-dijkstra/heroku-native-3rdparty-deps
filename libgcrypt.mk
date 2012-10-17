
LIBNAME := libgcrypt
LIB_URL := ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.5.0.tar.bz2
LIB_VERSION := 1.5.0

DEPENDENCIES := bzip2 libgpg-error

-include $(HOME)/build/heroku.mk
