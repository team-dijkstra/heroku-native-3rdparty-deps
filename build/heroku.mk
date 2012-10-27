
ifndef LIBNAME
$(error LIBNAME not defined!: Must be set to the name of the library to be built)
endif
ifndef LIB_VERSION
$(error LIB_VERSION not defined!: Must be set to the version of '$(LIBNAME)' that is to be built)
endif
ifndef LIB_URL
$(error LIB_URL not defined!: Must be set to the URL where a source archive of '$(LIBNAME)' version '$(LIB_VERSION)' can be downloaded)
endif

S3_BUCKET := heroku-binaries
PUBLISHURL := https://s3.amazonaws.com/$(S3_BUCKET)
DEPDIR := /tmp/vendor
PATH := $(PATH):$(DEPDIR)/bin:$(DEPDIR)/sbin
INSTALLDIR := /tmp/vendor
LOGDIR := /tmp/log
LIB_SRC_SUFFIX ?= $(filter-out $(LIB_URL),$(foreach sfx,.tar.gz .tgz .bz2 .xz,$(patsubst %$(sfx),$(sfx),$(LIB_URL))))

export CPATH := $(CPATH):$(DEPDIR)/include
export LIBRARY_PATH := $(LIBRARY_PATH):$(DEPDIR)/lib
export LD_RUN_PATH := $(LD_RUN_PATH):$(DEPDIR)/lib
export LD_LIBRARY_PATH := $(LD_LIBRARY_PATH):$(DEPDIR)/lib

# override in $(LIBNAME).mk env, or make invocation if not suitable
CONFIGURE ?= ./configure --prefix=$(INSTALLDIR)
BUILD ?= $(MAKE) 
INSTALL ?= $(MAKE) install

define extract_src
	tar -x$(1)f $< -C . --transform 's@^\(./\)\{0,1\}[^/]*$(LIBNAME)[^/]*/@@'
	echo . > $@
endef

$(info "Build type: $(if $(LOCALBUILD),local,remote)")
$(info "Library being built: $(LIBNAME)")
$(info "With the following dependencies: $(DEPENDENCIES)")
$(info "Source archive suffix: $(LIB_SRC_SUFFIX)")
$(info "Variables Exported to submake invocations:")
$(info "    CPATH=$(CPATH)")
$(info "    LIBRARY_PATH=$(LIBRARY_PATH)")
$(info "    LD_RUN_PATH=$(LD_RUN_PATH)")
$(info "    LD_LIBRARY_PATH=$(LD_LIBRARY_PATH)") 

.PHONY: all config install publish $(DEPENDENCIES)
.DEFAULT_GOAL = all

# don't publish if we are only doing a local build.
#
all: depend config install $(LIBNAME)-build.tgz $(if $(LOCALBUILD),,publish)

depend config build install publish: $(LOGDIR) 
depend: $(DEPDIR)

# use depend as a file of exclusions for packaging.
#
depend: $(DEPENDENCIES)
	find $(DEPDIR) > $@

$(DEPDIR):
	-mkdir $@

$(LOGDIR):
	-mkdir $@

$(DEPENDENCIES): | $(DEPDIR)
	s3 get $(S3_BUCKET)/$@-build.tgz filename=$@.tgz
	tar -xzf $@.tgz -C $(DEPDIR)
	rm -f $@.tgz 

# if only the makefile was included, then the sources need to be downloaded.
#
$(LIBNAME)-src$(LIB_SRC_SUFFIX):
	curl -L -o $@ $(LIB_URL)

# extract one of the various src archive formats we might have downloaded.
# should just extract the sources into the current directory.
#
%-src: %-src.tgz
	$(call extract_src,z)

%-src: %-src.tar.gz
	$(call extract_src,z)

%-src: %-src.bz2
	$(call extract_src,j)

%-src: %-src.xz
	$(call extract_src,J)

# package all files newer than depend timestamp
#
$(LIBNAME)-build.tgz : install
	tar -czf $@ $(INSTALLDIR) -X depend -P --transform 's@$(INSTALLDIR)/@@' > $(LOGDIR)/package.out

publish: $(LIBNAME)-build.tgz 
	s3 put $(S3_BUCKET)/$< filename=$< > $(LOGDIR)/publish.out

# commands can be overridden by supplying new values for the respective
# variables.
config: depend $(LIBNAME)-src
	$(CONFIGURE) > $(LOGDIR)/configure.out

build: config $(LIBNAME)-src
	$(BUILD) > $(LOGDIR)/build.out

install: build $(LIBNAME)-src
	$(INSTALL) > $(LOGDIR)/install.out
