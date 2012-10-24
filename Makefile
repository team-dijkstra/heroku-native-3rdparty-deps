
LIBS := $(basename $(filter-out depend.mk heroku.mk,$(wildcard *.mk)))
LOGDIR := /tmp/log

ifdef LOCALBUILD

MAKEFILES = "$(abspath $(@:.log.tgz=).mk)"
MAIN := build/heroku.mk

define build
	MAKEFILES=$(MAKEFILES) $(MAKE) -f ../$(MAIN) -C $(@:.log.tgz=)-src LOGDIR=$(LOGDIR)
    tar -czf $@ $(LOGDIR)
endef

else

MAKEFILES = "$$HOME/.build-env $(@:.log.tgz=).mk"
MAIN := $$HOME/build/heroku.mk

define build
	vulcan build -s $< -p $(LOGDIR) -c 'MAKEFILES=$(MAKEFILES) make -f $(MAIN) LOGDIR=$(LOGDIR)' -v -o $@
endef

endif

.PHONY: all clean depend $(LIBS)
.DEFAULT_GOAL = all

all: $(LIBS) ;

depend: $(addsuffix .d,$(LIBS))

%.upload.tgz: %.mk
	tar -czf $@ $<

%-build.tgz: %.log.tgz
	mv $(<:.log.tgz=)-src/$@ .

%.log.tgz: %.upload.tgz
	$(build)
	
# generate targets for dependency checking. Only works locally.
# if a logfile set for a library has already been generated, presumably
# the corresponding library has already been built.
#
# NB: this does not work if there were build errors...
#
$(foreach lib,$(LIBS),$(eval $(lib): $(lib).log.tgz))
$(foreach lib,$(LIBS),$(eval $(lib).log.tgz: $(lib).upload.tgz))

ifdef LOCALBUILD

define dir_templ
$(1):
	mkdir $(1)
endef

$(foreach lib,$(LIBS),$(eval $(lib).log.tgz: $(lib)-src))
$(foreach lib,$(LIBS),$(eval $(call dir_templ,$(lib)-src)))
$(foreach lib,$(LIBS),$(eval $(lib)-build.tgz: $(lib).log.tgz))

endif

# requires a separate make invocation since each library makefile needs to be
# read for its dependencies, and all use the same variable names
#
%.d: %.mk
	@echo Building $@ 
	$(MAKE) -f depend.mk $(<:.mk=)

clean:
	-rm -f *.d *.upload.tgz *.log.tgz

ifneq ($(MAKECMDGOALS),clean)
-include $(addsuffix .d,$(LIBS))
endif

