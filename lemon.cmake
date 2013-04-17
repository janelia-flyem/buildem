#
# Install lemon from source
#

if (NOT lemon_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

# FIXME: v1.2.3 of lemon doesn't compile under clang.
# From their issue tracker (#449), it looks like the next release (v1.3) will fix this.
# For now, this means that we MUST use gcc for this package.
# As soon as v1.3 is ready, we should try to upgrade.
external_source (lemon
    1.2.3
    lemon-1.2.3.tar.gz
    750251a77be450ddddedab14e5163afb
    http://lemon.cs.elte.hu/pub/sources)

message ("Installing ${lemon_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${lemon_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${lemon_URL}
    URL_MD5             ${lemon_MD5}
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
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
)

set_target_properties(${lemon_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT lemon_NAME)

