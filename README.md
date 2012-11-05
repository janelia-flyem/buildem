FlyEM Build System
==================

The [flyem-build](https://github.com/janelia-flyem/flyem-build) repo is part of a CMake-based build system that attempts to simplify and automate a complex build process.  

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
* Required components can be automatically built from source, and CMake is a sufficiently flexible and cross-platform tool on which to base our system.
* Builds of all components should be OS and compiler-specific to minimize conflicts in compiler versions, and we are not sure that pre-compiled components (e.g., RPMs) are available for all target machines/compilers.
* Third-party pre-built packages, like Enthought Python Distribution, are not viable due to licensing costs for cluster operation as well as inability to easily adapt to new dependencies.

The FlyEM build system requires only a few installed components to be available, preferably in this order:

* C/C++ and fortran compilers
* libcurl, https support (note that these components are usually present in standard OS builds but may need to be install explicitly)
* git
* CMake 2.8+

Note that python is built from source as well as all dependencies except for the above.  The FlyEM build system does *not* try to minimize overall build time by reusing pre-compiled packages.  The presence of multiple compiler versions across the different Fedora/RHEL versions and our very heterogeneous workstation environment requires developer attention and tracking of installs across multiple machines.  

In future versions of the build system, we will allow developers to easily specify which components can be reused from outside the FlyEM build.  These specified components will be found via the traditional CMake FIND_PACKAGE approach and only built from source if the component is absent.

## The build process

An empty directory is chosen as the *FlyEM build directory (FBD)* that is specific to OS, compiler versions, and component versions.  The FBD can be thought of as a version-specific /usr/local and will contain bin, lib, include, and other standard directories.  All automatically downloaded and compiled code will reside in the FBD's src directory.  Note that the FBD should not be confused with any component's *build directory*, which can be either in the component's source directory or some user-chosen directory as in standard CMake use.

The build process for a FlyEM application at /path/to/foo/code:

    % mkdir foo-build; cd foo-build
    % cmake -DFLYEM_BUILD_DIR=/path/to/FBD  /path/to/foo/code
    % make

_Note: If this is the first time a FlyEM application was compiled for this FBD, the build script will download the flyem-build repo into the FBD and the user will be prompted to re-run the cmake and make steps as above._

That's it.  The build scripts will automatically download the source for all dependencies, verify MD5 checksums, optionally patch/configure the code, and then compile it using the standard compilers for the build computer.  Source tarballs can be downloaded from either a FlyEM-controlled
cache on Github (the default) or the original project download site.  You can specify exactly which packages should use original project URLs via the following command-line option:

    % cmake -DUSE_PROJECT_DOWNLOAD="libtiff;vigra" -DFLYEM_BUILD_DIR=/path/to/FBD  /path/to/foo/code

The above `USE_PROJECT_DOWNLOAD` setting asks that the libtiff and vigra packages be downloaded from the original project websites.  All other required packages will be downloaded from the default Janelia cache at Github.

Alternative compilers can be specified by modifying CMake variables:

    % cmake -DCMAKE_C_COMPILER=gcc-4.2 -DCMAKE_CXX_COMPILER=g++-4.2 -DFLYEM_BUILD_DIR=/path/to/FBD  /path/to/foo/code
    
## Specifying the build for your application

Application builds are specified through one or more CMake files.  You must create a CMakeLists.txt at the root of your application source that sets the required FBD path and auto-downloads the flyem-build repo.  This CMake script can include any number of required components.  Most of these components should be in the flyem-repo, e.g., a libpng dependency is fulfilled by simply using `include (libpng)`.  

Python packages that can be installed via easy_install are even easier to build.  Simply add `include (EasyInstall)` and then use `easy_install (foo)` to install python package *foo*.  Since we have built python from source and installed it into the *FBD*, we can install python packages into that distribution instead of the build computer's standard python install.

### Your application CMakeLists.txt

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
        PREFIX              ${FLYEM_BUILD_DIR}
        GIT_REPOSITORY      https://github.com/janelia-flyem/flyem-build.git
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   "" 
        BUILD_COMMAND       ""
        BUILD_IN_SOURCE     1
        INSTALL_COMMAND     ""
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

    include (EasyInstall)
    easy_install (networkx)

    # Install Foo -- we use below just as placeholder
    add_custom_target (Foo ALL
        DEPENDS ${APP_DEPENDENCIES}
        COMMENT "Foo built")

    ############################################################################
endif()
```

### Adding packages to build process

If a required package is not available, it is very easy to add your own to the collection of .cmake files in the flyem-build repository. Let's look at libtiff as an example of a standard configure/make/make install build:

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

message ("Installing ${libtiff_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${libtiff_NAME}
    DEPENDS             ${libjpeg_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${libtiff_URL}
    URL_MD5             ${libtiff_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ./configure 
        --prefix=${FLYEM_BUILD_DIR}
        LDFLAGS=${FLYEM_LDFLAGS}
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT libtiff_NAME)
```

We `include` a number of required cmake files -- `ExternalProject` gets us CMake's standard ExternalProject_Add, and `ExternalSource` is our support script that sets appropriate variables for the given project abbreviation.  The `include (BuildSupport)` sets a number of variables that let us explicitly prioritize command and library path order, moving *FBD*/bin and *FBD*/lib to the front of PATH and LD_LIBRARY_PATH.

Each external package dependency is specified via a simple statement like `include (foo)` or in the case of python packages `easy_install (foo)`.  Package builds should be separated -- one package per .cmake in the flyem-build repo.  For every `include (foo)`, you should add `${foo_NAME}` on the `DEPENDS` line of the `ExternalProject_Add` function.

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


### Build notes for Janelia Farm cluster

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

### Troubleshooting

* Some original source repositories or tarballs require https, which may be a problem for operating systems like Scientific Linux due to absent certificates.  This issue can be sidestepped by using default non-https downloads, e.g., all downloads from janelia-flyem cache.

* Common build problems for individual components in the FlyEM Build System are documented in each component's CMake file (e.g. atlas.cmake).  If you see an error, check that file's comments.
