
LIBS := $(basename $(filter-out depend.mk heroku.mk,$(wildcard *.mk)))
LOGDIR := /tmp/log
make_cmd = MAKEFILES=$(MAKEFILES) $(MAKE) -f $(main) $(1) LOGDIR=$(LOGDIR)

ifdef LOCALBUILD

ifeq ($(BUILDENV),)
$(error BUILDENV not defined. Must be set to the location of a makefile specifying S3 keys and any other required settings)
endif

MAKEFILES = "$(BUILDENV) $(abspath $(*).mk)"
main := build/heroku.mk

define build
	$(call make_cmd,)
    tar -czf $@ $(LOGDIR)
endef

else

MAKEFILES = "$$HOME/.build-env $(*).mk"
main := $$HOME/build/heroku.mk

define build
	vulcan build -s $< -p $(LOGDIR) -c '$(call make_cmd,)' -v -o $@
endef

endif

.PHONY: all clean depend $(LIBS)
.DEFAULT_GOAL = all

all: $(LIBS) ;

depend: $(addsuffix .d,$(LIBS))

%.upload.tgz: %.mk
	tar -czf $@ $<

%.log.tgz: %.upload.tgz
	$(build)
	
# generate targets for dependency checking. Only works locally.
# if a logfile set for a library has already been generated, presumably
# the corresponding library has already been built.
#
# NB: this does not work if there were build errors...
#
$(foreach lib,$(LIBS),$(eval $(lib): $(lib).log.tgz))

# requires a separate make invocation since each library makefile needs to be
# read for its dependencies, and all use the same variable names
#
%.d: %.mk
	@echo Building $@ 
	$(MAKE) -f depend.mk $(*)

%-clean: %.mk
	$(call make_cmd,$@)

clean:
	-rm -f *.d *.upload.tgz *.log.tgz

ifneq ($(MAKECMDGOALS),clean)
-include $(addsuffix .d,$(LIBS))
endif

