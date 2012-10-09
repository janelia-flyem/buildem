#
# Install zlib from source
#

if (NOT zlib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (zlib
    1.2.7
    zlib-1.2.7.tar.gz
    http://zlib.net)

message ("Installing ${zlib_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${zlib_NAME}
    PREFIX            ${FLYEM_BUILD_DIR}
    URL               ${zlib_URL}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ${CMAKE_COMMAND} ${zlib_SRC_DIR} -DCMAKE_INSTALL_PREFIX:string=${FLYEM_BUILD_DIR}
    BUILD_COMMAND     make
    INSTALL_COMMAND   make install
)

endif (NOT zlib_NAME)