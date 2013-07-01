#
# Install lemon from source
#

if (NOT lemon_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

## FIXME: v1.2.3 of lemon doesn't compile under clang.
## From their issue tracker (#449), it looks like the next release (v1.3) will fix this.
## For now, this means that we MUST use gcc for this package.
## As soon as v1.3 is ready, we should try to upgrade.
#
#set (CMAKE_C_COMPILER /usr/bin/gcc)
#set (CMAKE_CXX_COMPILER /usr/bin/g++)

# This is the snapshot of the lemon commit we are using, but we are using a 
#  github-hosted tarball to avoid requiring CMake-2.8.10
#
## CMake 2.8.10 is required because we want to use ExternalProject_Add with a hg repo.
#CMAKE_MINIMUM_REQUIRED(VERSION 2.8.10)
#
#message ("FIXME: Using a tag from the lemon mainline hg repo instead of a release.")
#message ("       The tests in this version don't pass.")
#message ("       As soon as lemon-1.3 is released, switch to it (and uncomment the test step)!")
#external_git_repo (lemon
#    473c71baff72
#    http://lemon.cs.elte.hu/hg/lemon-main)

# Using special cached tarball.  See note above.
external_source (lemon
    snapshot-473c71baff72
	lemon-snapshot-473c71baff72.tar.gz
	d33dc5d3d3e7f7b56ca9b4ee2cdb525f
    http://janelia-flyem.github.io/downloads)

message ("Installing ${lemon_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${lemon_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${lemon_URL}
    URL_MD5             ${lemon_MD5}
#    HG_REPOSITORY        ${lemon_URL}
#    HG_TAG               ${lemon_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
    	${lemon_SRC_DIR}/lemon/CMakeLists.txt ${PATCH_DIR}/lemon.patch

    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${lemon_SRC_DIR} 
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        # Lemon can be optionally built with glpk to enable the LP solver.
        # We don't want to build with glpk because it isn't needed for cylemon.
        # Kill these cache variables to make sure we don't use it
        # (avoid potential linker errors if cmake finds a version of glpk on our system)
        -DGLPK_LIBRARY=
        -DGLPK_INCLUDE_DIR=
        -DGLPK_ROOT_DIR=

    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    
    # Sadly, the tests do not pass in this version that we are pulling.
    #TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
)

set_target_properties(${lemon_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT lemon_NAME)

