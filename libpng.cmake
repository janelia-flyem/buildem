#
# Install libpng from source
#

if (NOT libpng_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (libpng
    1.5.12
    libpng-1.5.12.tar.gz
    http://downloads.sourceforge.net/project/libpng/libpng15/1.5.12)

message ("Installing ${libpng_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${libpng_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    URL ${libpng_URL}
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ${CMAKE_COMMAND} ${libpng_SRC_DIR} -DCMAKE_INSTALL_PREFIX:string=${FLYEM_BUILD_DIR}
    BUILD_COMMAND     make
    INSTALL_COMMAND   make install
)

endif (NOT libpng_NAME)