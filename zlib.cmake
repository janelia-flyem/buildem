#
# Install zlib from source
#

if (NOT zlib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (zlib
    1.2.7
    zlib-1.2.7.tar.gz
    60df6a37c56e7c1366cca812414f7b85
    http://zlib.net)

message ("Installing ${zlib_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${zlib_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${zlib_URL}
    URL_MD5             ${zlib_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${CMAKE_COMMAND} ${zlib_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${FLYEM_BUILD_DIR}
        -DCMAKE_PREFIX_PATH=${FLYEM_BUILD_DIR}
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT zlib_NAME)