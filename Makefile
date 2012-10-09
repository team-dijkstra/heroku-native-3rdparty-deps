
LIBS := $(basename $(filter-out depend.mk heroku.mk,$(wildcard *.mk)))
LOGDIR := /tmp/log

# why does this have to be tabbed? is there no other way?
#
define vulcan_build 
	vulcan build -s $(1).upload.tgz -p $(LOGDIR) -c "make -f $(1).mk LOGDIR=$(LOGDIR)" -v -o $(1).log.tgz
	@echo Build Results
	@gunzip -c $(1).log.tgz
endef

define vulcan_template
$(1): $(1).upload.tgz
$(call vulcan_build,$(1))
endef	

.PHONY: all clean depend
.DEFAULT_GOAL = all

all: $(LIBS) ;

#depend: $(addsuffix .d,$(LIBS))

%.upload.tgz: %.mk
	tar -czf $@ $<

$(foreach lib,$(LIBS),$(eval $(call vulcan_template,$(lib))))

# requires a separate make invocation since each library makefile needs to be
# read for its dependencies, and all use the same variable names
#
%.d: %.mk
	@echo Building $@ 
	$(MAKE) -f depend.mk $(<:.mk=)

clean:
	-rm -f *.d *.upload.tgz

ifneq ($(MAKECMDGOALS),clean)
-include $(addsuffix .d,$(LIBS))
endif

