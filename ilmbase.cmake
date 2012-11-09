#
# Install ilmbase from source
#

if (NOT ilmbase_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (zlib)

external_source (ilmbase
    1.0.2
    ilmbase-1.0.2.tar.gz
    26c133ee8ca48e1196fbfb3ffe292ab4
    http://download.savannah.nongnu.org/releases/openexr)

if (${CMAKE_CXX_COMPILER_ID} MATCHES ".*Clang.*")
    set(ilmbase_PATCH_COMMAND ${PATCH_EXE}
        ${ilmbase_SRC_DIR}/Imath/ImathMatrix.h ${PATCH_DIR}/ilmbase-1.patch
        # Add extra patch for clang compatibility
        ${ilmbase_SRC_DIR}/configure ${PATCH_DIR}/ilmbase-clang.patch )
else()
    set(ilmbase_PATCH_COMMAND ${PATCH_EXE}
        ${ilmbase_SRC_DIR}/Imath/ImathMatrix.h ${PATCH_DIR}/ilmbase-1.patch )
endif()

message ("Installing ${ilmbase_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${ilmbase_NAME}
    DEPENDS             ${zlib_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${ilmbase_URL}
    URL_MD5             ${ilmbase_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${ilmbase_PATCH_COMMAND}
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${ilmbase_SRC_DIR}/configure 
        --prefix=${FLYEM_BUILD_DIR}
        LDFLAGS=${FLYEM_LDFLAGS}
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT ilmbase_NAME)