#
# Install libtiff from source
#

if (NOT libtiff_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (libjpeg)

external_source (libtiff
    4.0.3
    tiff-4.0.3.tar.gz
    ftp://ftp.remotesensing.org/pub/libtiff)

message ("Installing ${libtiff_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${libtiff_NAME}
    DEPENDS           ${libjpeg_NAME}
    PREFIX            ${FLYEM_BUILD_DIR}
    URL               ${libtiff_URL}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ./configure 
        --prefix=${FLYEM_BUILD_DIR}
        LDFLAGS=-L${FLYEM_BUILD_DIR}/lib
    BUILD_COMMAND     make
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   make install
)

endif (NOT libtiff_NAME)