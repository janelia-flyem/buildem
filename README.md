The BuildEM System
==================

The [buildem](https://github.com/janelia-flyem/buildem) repo is a modular CMake-based system that leverages [CMake's ExternalProject](http://www.kitware.com/media/html/BuildingExternalProjectsWithCMake2.8.html) to simplify and automate a complex build process.  Its goal is to allow *simple*, *modular* specification of software dependencies and automate the download, patch, configure, build, and install process.

For each version of the buildem repo, we create a *Buildem Prefix Directory (BPD)* that is specific to OS, compiler, and component versions.  The BPD can be thought of as a complete build environment (like a user-controlled /usr/local) and will contain bin, lib, include, and other standard directories.  All automatically downloaded and compiled code will reside in the BPD's src directory.

Each supported software package has a separate `.cmake` file in the buildem repo and uses conventions for how to name variables based on the package name.

## Philosophy of buildem

Previously, each software dependency was installed by manually downloading packages, either via yum/apt-get in sudo mode or by compiling source tarballs.  Target executables and libraries were symbolically linked or copied to standard locations.  While this process allowed great latitude in reusing software already available on computers, it has a number of issues:

* The process is tedious and must be replicated for each target computer.
* As the number of required components grows, we encounter [Dependency Hell](http://en.wikipedia.org/wiki/Dependency_hell), particularly when some components are on network drives and shared among heterogeneous workstations.
* The instructions are very OS-specific and require some knowledge of builds.
* The process might break and at least has to be modified if the developer lacks root privileges or the ability to install to conventional directories like /usr/local.  This occurs when installing on the Janelia cluster.

Buildem is predicated on some basic assertions:

* Developer attention should be minimized since developer time is very expensive compared to freely available computer time.
* Disk space is cheap and plentiful.
* Each application build process should be easily specified and automated.
* Required components should be easily shared on network drives among networked computers that can share software, i.e., the computers have compatible operating systems, because intranets have excellent bandwidth.
* Required components can be automatically built from source, and CMake is a sufficiently flexible and cross-platform tool on which to base our system.
* Builds of all components should be specific to OS, compiler, and compiler version to minimize conflicts in [ABI](http://en.wikipedia.org/wiki/Application_binary_interface), and we are not sure that pre-compiled components (e.g., RPMs) are available for all target machines/compilers.
* Third-party pre-built packages, like Enthought Python Distribution, are not viable due to licensing costs for cluster operation as well as inability to easily adapt to new dependencies.

## The build process

Buildem requires a few installed components:

* C/C++ and fortran compilers
* libcurl and https support (note that these components are usually present in standard OS builds but may need to be installed explicitly)
* git
* CMake 2.8+
* python 2.6+ *if* patches or templates are used in build process.  In future, we could require a python build from source and use that instead *or* switch to a platform-independent patch/template system built into CMake.

Note that a different version of python can be built from source.  Buildem does *not* try to minimize overall build time by reusing pre-compiled packages.  The presence of multiple compiler versions across the different Fedora/RHEL versions and our very heterogeneous workstation environment requires developer attention and tracking of installs across multiple machines.  

The build process for a FlyEM application at /path/to/foo/code:

    % mkdir foo-build; cd foo-build
    % cmake -DBUILDEM_DIR=/path/to/BPD  /path/to/foo/code
    % make

If this is the first time an application was compiled for this BPD, the build script will download the buildem repo into the BPD and the user will be prompted to re-run the cmake and make steps as above. In this initial case, the build process would be:

    % mkdir foo-build; cd foo-build
    % cmake -DBUILDEM_DIR=/path/to/BPD  /path/to/foo/code
    % make
    % cmake -DBUILDEM_DIR=/path/to/BPD  /path/to/foo/code
    % make

That's it.  The build scripts will do the following steps (mostly following the ExternalProject_Add flow):

* download the source for all dependencies, verify MD5 checksums
* optionally patch the code
* build from source
* optionally test the build 
* install built components into appropriate locations under the BPD (e.g., lib, include, bin)
* possibly create customized scripts that handle environment variable setting and call executables in the BPD

Source tarballs can be downloaded from either a FlyEM-controlled cache on Github (the default) or the original project download site.  You can specify exactly which packages should use original project URLs via the following command-line option:

    % cmake -DUSE_PROJECT_DOWNLOAD="libtiff;vigra" -DBUILDEM_DIR=/path/to/BPD  /path/to/foo/code

The above `USE_PROJECT_DOWNLOAD` setting asks that the libtiff and vigra packages be downloaded from the original project websites.  All other required packages will be downloaded from the default Janelia cache at Github.

Alternative compilers can be specified by modifying CMake variables:

    % cmake -DCMAKE_C_COMPILER=gcc-4.2 -DCMAKE_CXX_COMPILER=g++-4.2 -DBUILDEM_DIR=/path/to/BPD  /path/to/foo/code
    
## Specifying the build for your application

Application builds are specified through one or more CMake files.  You must create a CMakeLists.txt at the root of your application source that sets the required BPD path and auto-downloads the buildem repo.  This CMake script can include any number of required components.  Most of these components should be in the buildem repo, e.g., a libpng dependency is fulfilled by simply using `include (libpng)`.  

### Your application CMakeLists.txt

Your application CMakeLists.txt can use the following template:

```cmake
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
project (Foo)

include (ExternalProject)

############################################################################
# Check if BUILDEM_DIR has already been assigned.  If not, create a default.
set (BUILDEM_DIR "None" CACHE TYPE STRING)

if (${BUILDEM_DIR} STREQUAL "None")
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DBUILDEM_DIR=<path> on cmake command line.")
endif ()

message ("FlyEM downloads and builds will be placed here: ${BUILDEM_DIR}")

############################################################################

############################################################################
# Download and install buildem, if it isn't already in BUILDEM_DIR.
set (BUILDEM_REPO_DIR ${BUILDEM_DIR}/src/buildem)
if (NOT EXISTS ${BUILDEM_REPO_DIR}/python.cmake)
    message ("Installing buildem repo...")
    ExternalProject_Add(buildem
        PREFIX              ${BUILDEM_DIR}
        GIT_REPOSITORY      https://github.com/janelia-flyem/buildem.git
        #GIT_TAG            python3  # Example of tagged branch (see doc)
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   "" 
        BUILD_COMMAND       ""
        BUILD_IN_SOURCE     1
        INSTALL_COMMAND     ""
    )
    message ("\n**********************************************************\n")
    message ("\nAfter running make, you must re-run the cmake command once")
    message ("buildem has been downloaded!\n")
    message ("\n***********************************************************\n")
else ()
    ############################################################################
    
    # Use modules from the downloaded buildem
    set (CMAKE_MODULE_PATH ${BUILDEM_REPO_DIR})
    message("Using cmake modules from ${BUILDEM_REPO_DIR}")

    # Download and compile dependencies
    include (python)
    include (libpng)

    # Install Foo -- actual build commands would replace the placeholder
    # below.  Note the auto-generated APP_DEPENDENCIES variable that
    # holds all required targets.
    add_custom_target (Foo ALL
        DEPENDS ${APP_DEPENDENCIES}
        COMMENT "Foo built")

############################################################################
endif()
```

The two-step process is clear from the CMake code above.  If a buildem repo has not been cloned yet, the first part downloads the build repo into the specified `BUILDEM_DIR`.  Note the commented-out `GIT_TAG` when retrieving the build repo.  You can use tagged branches of the build repo to create different software environments as long as each tagged branch uses a *different* `BUILDEM_DIR`.  For example, one application might require python 3 instead of the default python 2.7, which may cause cascading version changes for other requirements.  All of these changes can be made to a branch of the build repo's .cmake files and snapshotted using a tag.

### Release versus debug builds

By convention, the build code in `foo.cmake` should look for a `foo_BUILD` variable.  `foo_BUILD` is by default set to `RELEASE`.  To force a debug version of a dependency, simply set `foo_BUILD` to `DEBUG` before calling `include (foo)`.
    
### Library and include directory paths

Package-specific libraries and include directory paths are set within each buildem module (i.e., the `.cmake` file for a software package).  The generated CMake variables follow a convention.

For a package `foo.cmake`, the following variables can be set within that buildem module:

`foo_INCLUDE_DIRS` -- The include directories for the foo package.  This defaults to *BPD*/include.

Library names that distinguish shared from static and release from debug builds.  We assume shared and release builds, so the shortest names assume that configuration.  For all variables, package-specific names come first, then shared vs static, then debug vs release.

    foo_LIBRARIES                Names of shared, release libraries for package foo.
    foo_STATIC_LIBRARIES         Paths to static, release libraries for package foo.
    foo_SHARED_DEBUG_LIBRARIES   Fully specified.

Some packages will have different components.  For example, the HDF5 libraries allow compiling a "HL" (High-level) version.  Since this is project-specific, by convention the `hdf5.cmake` file will place "HL" in the prefix and set `hdf5_HL_STATIC_LIBRARIES` to the static release HL version library.
    
### Adding packages to build process

If a required package is not available, it is very easy to add your own to the collection of .cmake files in the buildem repository. Let's look at libtiff as an example of a standard configure/make/make install build:

```cmake
# Install libtiff from source

if (NOT libtiff_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (libjpeg)

external_source (libtiff
    4.0.3
    tiff-4.0.3.tar.gz
    051c1068e6a0627f461948c365290410
    ftp://ftp.remotesensing.org/pub/libtiff)

message ("Installing ${libtiff_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${libtiff_NAME}
    DEPENDS             ${libjpeg_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${libtiff_URL}
    URL_MD5             ${libtiff_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./configure 
        --prefix=${BUILDEM_DIR}
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

endif (NOT libtiff_NAME)
```

We `include` a number of required cmake files -- `ExternalProject` gets us CMake's standard ExternalProject_Add, and `ExternalSource` is our support script that sets appropriate variables for the given project abbreviation.  The `include (BuildSupport)` sets a number of variables that let us explicitly prioritize command and library path order, moving *BPD*/bin and *BPD*/lib to the front of PATH and LD_LIBRARY_PATH.

Each external package dependency is specified via a simple statement like `include (foo)`.  Package builds should be separated -- one package per .cmake in the buildem repo.  For every `include (foo)`, you should add `${foo_NAME}` on the `DEPENDS` line of the `ExternalProject_Add` function.

The `external_source()` macro allows you to specify an external URL, typically the project's public download URL.  The macro can be used in three ways.  The standard way is to specify an external URL but by default, download from the FlyEM cache:

```cmake
external_source (libtiff
    4.0.3
    tiff-4.0.3.tar.gz
    051c1068e6a0627f461948c365290410
    ftp://ftp.remotesensing.org/pub/libtiff)
```

With the above standard declaration, you can optionally force a download from the specified external URL by use of the `-DUSE_PROJECT_DOWNLOAD` command-line cmake option as mentioned above.

To force downloads from the external URL, follow the URL parameter with the keyword "FORCE":

```cmake
external_source (libtiff
    4.0.3
    tiff-4.0.3.tar.gz
    051c1068e6a0627f461948c365290410
    ftp://ftp.remotesensing.org/pub/libtiff
    FORCE)
```

The above will force the download from the external URL `ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.3.tar.gz` regardless of command-line options.  Finally, if you do not specify an external URL, the download will always be from the FlyEM cache:

```cmake
external_source (libtiff
    4.0.3
    tiff-4.0.3.tar.gz
    051c1068e6a0627f461948c365290410)
```

In each case, the variable `${foo_URL}` is set by the `external_source()` macro to an appropriate download URL.

### Patching

See the `do_patch.py` utility under the `patches` directory.  This script lets you specify a number of patches to be applied to files and execute them in one step suitable for the `PATCH` directive in `ExternalProject_Add` commands.

Actual patches are kept in the `patches` directory and preserved as part of the build repo.  Add `include (PatchSupport)` to set two variables `PATCH_DIR`, where actual patch files are kept as well as the do_patch.py script, and `PATCH_EXE`, which contains the path to the do_patch.py script.


### Generation of files/scripts using templates

See the `do_template.py` utility under the `templates` directory.  This script will create files by applying command-line arguments to templates in that directory.  This allows you to generate customized scripts that can set environment variables before calling installed executables.  It can also be used to create configuration files, e.g., the matplotlib setup.cfg file, before actually building a component.

Add `include (TemplateSupport)` to set two variables `TEMPLATE_DIR`, where actual template files are kept as well as the do_template.py script, and `TEMPLATE_EXE`, which contains the path to the do_template.py script.

### FindPackage and FindLibrary (discouraged)

CMake's build-in `FindPackage()` and `FindLibrary()` routines are discouraged because buildem strongly prefers all dependencies to be built and installed in the *BPD*.  It is better to know when a dependency is not available than have the build process silently fall back to libraries in paths outside the buildem system.

Example: Earlier boost package builds created multi-threaded libraries with the `-mt` suffix, but later boost builds on Linux removed that suffix.  The boost FindPackage module loops through all directories in the search path in the inner loop and loops through all possible boost library names (starting with `-mt`) in the outer loop.   This causes `FindPackage(boost)` to preferentially return older boost libraries even if the path to a newer boost install is first in the find package search path.

### Easy Install (discouraged)

Python packages that can be installed via easy_install are easy to build but are discouraged because they may install dependencies outside this modular CMake build system.  If you just want to test a component using easy_install, you can add `include (EasyInstall)` and then use `easy_install (foo)` to install python package *foo*.  Since we have built python from source and installed it into the *BPD*, we can install python packages into that distribution instead of the build computer's standard python install.

If the easy_install works, it is recommended to create a separate .cmake file similar to networkx.cmake and progressbar.cmake in this repo.
 
## Troubleshooting

Some original source repositories or tarballs require https, which may be a problem for operating systems like Scientific Linux due to absent certificates.  This issue can be sidestepped by using default non-https downloads, e.g., all downloads from janelia-flyem cache.

Common build problems for individual components in the FlyEM Build System are documented in each component's CMake file (e.g. atlas.cmake).  If you see an error, check that file's comments.

## Roadmap

This build system could be improved in a number of ways, not all of which adhere to the goal of a simple, easily-specified build process.

* Add cross-platform support where needed, particularly for Mac and Windows.  This is left to individual developers to make changes for their projects. Hopefully, we will accumulate these across modules and temper them with our conventions for naming.
* Require a python build from source and use that for templating/patching *or* switch to a platform-independent patch/template system built into CMake.  The latter seems to have ugly regexes instead using simple patches from diff?
* Improve triggers so download, patch, configure, and compilation times are decreased.
* Allow developers to specify components that can be used from outside the Buildem environment.  These specified components will be found via the traditional CMake FIND_PACKAGE approach and only built from source if the component is absent.  The burden of specifying compatible shared libraries will rest with the developer in exchange for time savings.  This approach also flies against our philosophy of limiting the impact of library paths and putting everything we can into the BPD.
* Allow run-time specification of different component versions.  This would require reorganization of the target build directory so each component version would have its own build directory.  Scripts could then modify environment variables like `LD_LIBRARY_PATH` to select chosen versions.  While helpful during debugging builds and considering new component versions, we don't want to lose the simplicity of having a tagged build repo represent a known working version of all software dependencies.

## Build notes for Janelia Farm cluster

The Janelia Farm cluster is an atypical deployment platform that provides one edge case for how to use the FlyEM build system.

#### The cluster executable and library layout

The base cluster OS is a fairly old Linux distribution.  Newer packages, like gcc 4.40 or CMake 2.8.8, are installed independently under /usr/local with the executables in /usr/local/some-package/bin.

We suggest having as clean an environment as possible, i.e., you should not have PATH or LD_LIBRARY_PATH set to a large number of directories.  It's best to start with empty environment variables, determine which libraries or executables cannot be found, and then add the appropriate paths as needed.  This way, you are less likely to have library conflicts due to default paths taking precedence over the libraries you intend to be used.

To build on the cluster, login to a compute node and set the environment variables like so:

```bash
export FLYEMCLUSTER=/groups/flyem/proj/builds/cluster
export PATH=/usr/local/cmake-2.8.8/bin:/usr/local/gcc/bin:/usr/local/git/bin:$FLYEMCLUSTER/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/gcc/lib64:/usr/local/gcc/lib:$FLYEMCLUSTER/lib:/usr/local/mpfr/lib:/usr/local/gmp/lib:$LD_LIBRARY_PATH
export PYTHONPATH=$FLYEMCLUSTER/lib/python2.7:$FLYEMCLUSTER/lib/python2.7/site-packages
```

Note that the PATH is set to automatically use the more recent CMake, gcc, and git builds.

After setting the appropriate environment variables, simply run the standard installation cmake/make (with possible second cmake/make invokation) to build the system.


