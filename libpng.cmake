#
# Install libpng from source
#

if (NOT libpng_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

# TODO -- The download URL might only be valid for most recent release.
#   Find better mirror that has steady download URL or cache it at janelia.
external_source (libpng
    1.5.13
    libpng-1.5.13.tar.gz
    http://downloads.sourceforge.net/project/libpng/libpng15/1.5.13)

message ("Installing ${libpng_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${libpng_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    URL ${libpng_URL}
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ${CMAKE_COMMAND} ${libpng_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX:string=${FLYEM_BUILD_DIR}
        -DCMAKE_FIND_ROOT_PATH=${FLYEM_BUILD_DIR}
    BUILD_COMMAND     make
    INSTALL_COMMAND   make install
)

endif (NOT libpng_NAME)