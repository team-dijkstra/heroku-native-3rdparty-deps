
LIBS := $(basename $(filter-out depend.mk heroku.mk,$(wildcard *.mk)))
LOGDIR := /tmp/log

.PHONY: all clean depend $(LIBS)
.DEFAULT_GOAL = all

all: $(LIBS) ;

depend: $(addsuffix .d,$(LIBS))

%.upload.tgz: %.mk
	tar -czf $@ $<

%.log.tgz: %.upload.tgz
	vulcan build -s $< -p $(LOGDIR) -c "make -f $(@:.log.tgz=).mk LOGDIR=$(LOGDIR)" -v -o $@

# generate targets for dependency checking. Only works locally.
# if a logfile set for a library has already been generated, presumably
# the corresponding library has already been built.
#
# NB: this does not work if there were build errors...
#
$(foreach lib,$(LIBS),$(eval $(lib): $(lib).log.tgz))
$(foreach lib,$(LIBS),$(eval $(lib).log.tgz: $(lib).upload.tgz))

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

