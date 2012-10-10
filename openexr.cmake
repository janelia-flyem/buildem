#
# Install openexr from source
#

if (NOT openexr_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (PkgConfig)
include (PatchSupport)

include (ilmbase)

external_source (openexr
    1.6.1
    openexr-1.6.1.tar.gz
    http://download.savannah.nongnu.org/releases/openexr)

message ("Installing ${openexr_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${openexr_NAME}
    DEPENDS           ${ilmbase_NAME}
    PREFIX            ${FLYEM_BUILD_DIR}
    URL               ${openexr_URL}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ${PATCH_EXE}
        ${openexr_SRC_DIR}/exrmaketiled/main.cpp ${PATCH_DIR}/openexr-exrmaketiled.patch
        ${openexr_SRC_DIR}/exrenvmap/main.cpp ${PATCH_DIR}/openexr-exrenvmap.patch
    CONFIGURE_COMMAND ${openexr_SRC_DIR}/configure
        --prefix=${FLYEM_BUILD_DIR}
        --disable-ilmbasetest
        PKG_CONFIG_PATH=${FLYEM_PKGCONFIG_DIR}
        LDFLAGS=-L${FLYEM_BUILD_DIR}/lib
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND     make
    INSTALL_COMMAND   make install
)

endif (NOT openexr_NAME)