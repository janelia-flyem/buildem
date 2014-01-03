#
# Install lemon from source
#

if (NOT lemon_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

external_source (lemon
    1.2.4
	lemon-1.2.4.tar.gz
	fd89e8bf5035b02e2622a48ac7fe0641
    http://lemon.cs.elte.hu/pub/sources)

message ("Installing ${lemon_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${lemon_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${lemon_URL}
    URL_MD5             ${lemon_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
        # This patch fixes a build error that clang detects.
        # (Already fixed in lemon trunk, but not in the tarball release.)
    	${lemon_SRC_DIR}/lemon/graph_to_eps.h ${PATCH_DIR}/lemon.patch
    	# Apparently one test file is missing from the release.
    	# This patch removes it from CMakeLists.txt
        ${lemon_SRC_DIR}/test/CMakeLists.txt ${PATCH_DIR}/lemon-test.patch

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

    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
)

set_target_properties(${lemon_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT lemon_NAME)

