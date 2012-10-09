
LIBNAME := $(MAKECMDGOALS)

ifeq ($(LIBNAME),)
$(error "Required variable 'LIBNAME' not set: Should be set to the name of the library to build.")
endif

ifeq ($(wildcard $(LIBNAME).mk),)
$(error "$(LIBNAME).mk does not exist. Impossible to determine dependencies for lib: $(LIBNAME).")
endif

include $(LIBNAME).mk
.PHONY: $(LIBNAME)

$(LIBNAME): $(LIBNAME).d

$(LIBNAME).d: $(LIBNAME).mk
	echo $(LIBNAME): $(DEPENDENCIES) > $@
	
