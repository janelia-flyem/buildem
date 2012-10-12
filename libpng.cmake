#
# Install libpng from source
#

if (NOT libpng_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

# TODO -- The download URL might only be valid for most recent release.
#   Find better mirror that has steady download URL or cache it at janelia.
external_source (libpng
    1.5.13
    libpng-1.5.13.tar.gz
    9c5a584d4eb5fe40d0f1bc2090112c65
    http://downloads.sourceforge.net/project/libpng/libpng15/1.5.13)

message ("Installing ${libpng_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${libpng_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${libpng_URL}
    URL_MD5             ${libpng_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${CMAKE_COMMAND} ${libpng_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX:string=${FLYEM_BUILD_DIR}
        -DCMAKE_FIND_ROOT_PATH=${FLYEM_BUILD_DIR}
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT libpng_NAME)