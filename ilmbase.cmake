#
# Install ilmbase from source
#

if (NOT ilmbase_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (PatchSupport)

include (zlib)

external_source (ilmbase
    1.0.2
    ilmbase-1.0.2.tar.gz
    http://download.savannah.nongnu.org/releases/openexr)

message ("Installing ${ilmbase_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${ilmbase_NAME}
    DEPENDS             ${zlib_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${ilmbase_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${PATCH_EXE}
        ${ilmbase_SRC_DIR}/Imath/ImathMatrix.h ${PATCH_DIR}/ilmbase-1.patch
    CONFIGURE_COMMAND   ${ilmbase_SRC_DIR}/configure 
        --prefix=${FLYEM_BUILD_DIR}
        LDFLAGS=-L${FLYEM_BUILD_DIR}/lib
    BUILD_COMMAND       make
    INSTALL_COMMAND     make install
)

endif (NOT ilmbase_NAME)