FlyEM Build System
==================

The flyem-build repo, together with flyem-mirror, constitute a CMake-based build system that attempts to simplify and automate a complex build process.  

Previously, each software component was installed by manually downloading packages, either via yum/apt-get in sudo mode or by compiling source tarballs.  Target executables and libraries were symbolically linked or copied to standard locations.  While this process allowed great latitude in reusing software already available on computers, it has a number of issues:

* The process is tedious and must be replicated for each target computer.
* As the number of required components grows, we encounter [Dependency Hell](http://en.wikipedia.org/wiki/Dependency_hell), particularly when some components are on network drives and shared among heterogeneous workstations.
* The instructions are very OS-specific and require some knowledge of builds.
* The process might break and at least has to be modified if the developer lacks root privileges or the ability to install to conventional directories like /usr/local.  This occurs when installing on the Janelia cluster.

The FlyEM build system is predicated on some basic assertions:

* Developer attention should be minimized since developer time is very expensive compared to freely available computer time.
* Disk space is cheap and plentiful.
* Each application build process should be easily specified and automated.
* Required components should be easily shared on network drives among networked computers that can share software, i.e., the computers have compatible operating systems, because intranets have excellent bandwidth.
* Required components can be automatically built from source.
* Builds of all components should be OS and compiler-specific to minimize conflicts in compiler versions, and we are not sure that pre-compiled components (e.g., RPMs) are available for all target machines/compilers.
* Third-party pre-built packages, like Enthought Python Distribution, are not viable due to licensing costs for cluster operation as well as inability to easily adapt to new dependencies.

Except for C/C++ and fortran compilers, the FlyEM build system does *not* try to minimize overall build time by reusing pre-compiled packages.  The presence of multiple compiler versions across the different Fedora/RHEL versions and our very heterogeneous workstation environment requires developer attention and tracking of installs across multiple machines.  

In future versions of the build system, we will allow developers to easily specify which components can be reused from outside the FlyEM build.  These specified components will be found via the traditional CMake FIND_PACKAGE approach and only built from source if the component is absent.

## The build process

An empty directory is chosen as the *FlyEM build directory (FBD)* that is specific to OS, compilers' versions, and chosen component versions.  The FBD can be thought of as a version-specific /usr/local and will contain bin, lib, include, and other standard directories.  All automatically downloaded and compiled code will reside in the FBD's src directory.  Note that the FBD should not be confused with any component's *build directory*, which can be either in the component's source directory or some user-chosen directory as in standard CMake use.

The build process for a FlyEM application at /path/to/foo/code:

    % mkdir foo-build; cd foo-build
    % cmake -DFLYEM_BUILD_DIR=/path/to/FBD  /path/to/foo/code
    % make

If this is the first time a FlyEM application was compiled for this FBD, the build script will download the flyem-build repo into the FBD and the user will be prompted to re-run the cmake and make steps as above.

That's it.  The build scripts will automatically download the source for all dependencies and compile it using the standard compilers for the build computer.  Alternative compilers can be specified by modifying CMake variables:

    % cmake -DCMAKE_C_COMPILER=gcc-4.2 -DCMAKE_CXX_COMPILER=g++-4.2 -DFLYEM_BUILD_DIR=/path/to/FBD  /path/to/foo/code
    
## Specifying the build for your application

Application builds are specified through one or more CMake files.  You must create a CMakeLists.txt at the root of your application source that sets the required FBD path and auto-downloads the flyem-build repo.  This CMake script can include any number of required components.  Most of these components should be in the flyem-repo, e.g., a libpng dependency is fulfilled by simply using `include (libpng)` and then adding `${libpng_NAME}` as a dependency.

Your application CMakeLists.txt can use the following template:

```cmake
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
project (Foo)

include (ExternalProject)


############################################################################
# Check if FLYEM_BUILD_DIR has already been assigned.  If not, create a default.
set (FLYEM_BUILD_DIR "None" CACHE TYPE STRING)

if (${FLYEM_BUILD_DIR} STREQUAL "None")
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DFLYEM_BUILD_DIR=<path> on cmake command line.")
endif ()

message ("FlyEM downloads and builds will be placed here: ${FLYEM_BUILD_DIR}")

############################################################################

############################################################################
# Download and install flyem-build, if it isn't already in FLYEM_BUILD_DIR.
set (FLYEM_BUILD_REPO_DIR ${FLYEM_BUILD_DIR}/src/flyem-build)
if (NOT EXISTS ${FLYEM_BUILD_REPO_DIR}/python.cmake)
    message ("Installing flyem-build repo...")
    ExternalProject_Add(flyem-build
        PREFIX ${FLYEM_BUILD_DIR}
        GIT_REPOSITORY https://github.com/janelia-flyem/flyem-build.git
        UPDATE_COMMAND ""
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ""
    )
    message ("\n**********************************************************\n")
    message ("\nAfter running make, you must re-run the cmake command once")
    message ("flyem-build has been downloaded!\n")
    message ("\n***********************************************************\n")
else ()
    ############################################################################
    
    # Use modules from the downloaded flyem-build
    set (CMAKE_MODULE_PATH ${FLYEM_BUILD_REPO_DIR})
    message("Using cmake modules from ${FLYEM_BUILD_REPO_DIR}")

    # Download and compile dependencies
    include (python)
    include (libpng)

    # Install Foo -- we use below just as placeholder
    add_custom_target (Foo ALL
        DEPENDS ${python_NAME} ${libpng_NAME}
        COMMENT "Foo built")

        ############################################################################
endif()
```