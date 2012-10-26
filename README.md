heroku-native-3rdparty-deps
===========================

## Disclaimer ##

If you have found this project via a search, you are probably not where you 
want to be. This build system is basically just a convenience wrapper for the 
Vulcan build server, which can be used to build native binaries for the Heroku
cloud platform. You are of course welcome to use this work if you find it 
useful, but please read the enclosed LICENCE file if you do. This software is 
licenced under the [MIT licence](http://opensource.org/licenses/MIT). 

## Intended Use ##

Builds can be performed both remotely (the primary use case) on a Vulcan build 
server instance, and locally (secondary use case). Since the build system of 
most libraries is usually perfectly adequate, and this system just invokes the 
library build system (with alternate configuration settings), there will 
typically not be much reason to run local builds with this system, except for
debugging.

## Overview ##

This project provides a simplified build infrastructure for building C++ 
binaries using an instance of the 
[Vulcan build server](https://github.com/heroku/vulcan) 
for the 
[Heroku cloud platform](http://www.heroku.com/). Unless otherwise specified, 
all paths are given from the root of the repository.
The build system consists of:

1. A master makefile ('build/heroku.mk') that performs the bulk of the build 
   work. This file must be checked in to your Vulcan build server repository on 
   Heroku as 'build/heroku.mk'. Currently this location  is hardcoded in the 
   driver Makefile, but may be configurable in future versions. 
2. A driver makefile (Makefile) that runs on the client machine. 
3. A dependency generation makefile (depend.mk) that generates library 
   dependency information for use by the driver makefile, and the master 
   makefile. The generated dependency information is used automatically.
4. Many many little tiny makefiles (<libname>.mk), that are used to specify any
   custom build settings needed (or desired) to build <libname>. This also 
   includes dependencies between libraries so that a proper build order can be 
   maintained. 
   
### The Master Makefile (build/heroku.mk) ###


### The Dependency Generation Makefile (depend.mk) ###


### The Driver Makefile (Makefile) ###


### Library Specific Build Configuration (<libname>.mk) ###

At minimum each <libname>.mk file needs to specify 'LIBNAME' and 'LIB\_URL'. 
Optionally, it can also specify 
'DEPENDENCIES', 'CONFIGURE', 'BUILD', 'INSTALL', and 'LIB\_VERSION' to customize
the build process. Beyond these variables, virtually any makefile code can go
in a <libname>.mk file. The only real restriction is that variables and rules
defined in a <libname>.mk file cannot collide with any of the rules defined in
'build/heroku.mk'. This is because <libname>.mk is automatically included 
whenever 'build/heroku.mk' is invoked. 

## Remote Build Steps ##

1. The driver makefile (Makefile) scans all of the <libname>.mk files in the 
   current directory and generates library dependency information from the 
   'DEPENDENCIES' variable in each <libname>.mk file. After this, it knows 
   what libraries depend on what, by including the generated dependency 
   information.
2. The driver makefile will invoke a vulcan build for each of the libraries 
   specified, in dependency sorted order. For each library, it generates a tar 
   file containing only the <lbname>.mk makefile, and specifies this as the 
   'source' for vulcan to build.
3. On the vulcan build server, the build/heroku.mk makefile is invoked, with 
   the <libname>.mk makefile and environment settings implicitly prepended. 
4. It downloads and unpacks the source archive specified by the 'LIB\_URL' 
   variable to the current directory. Then, any dependencies specified by 
   'DEPENDENCIES' (expected to be prebuilt, from prior build runs) are 
   downloaded from an amazon s3 repository. 
4. Next, heroku.mk invokes the build steps specified by 'CONFIGURE', 'BUILD', 
   'INSTALL' in that order.
5. If the build was successful, heroku.mk uploads the built files in an archive
   to the amazon s3 repository (the same one as in step 4.).
6. Finally, Vulcan creates an archive of the build log files, taken from the 
   CONFIGURE, BUILD and INSTALL stages, and downloads them to the current 
   directory on the client machine.

## Local Build Steps ##

== Todo: ==

This document is incomplete.

