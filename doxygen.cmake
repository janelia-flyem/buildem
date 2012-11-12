#
# Install doxygen from source
#

if (NOT doxygen_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (doxygen
    1.8.2
    doxygen-1.8.2.src.tar.gz
    6fa7baf995fa3f71cfc09e264ba88a83
    http://ftp.stack.nl/pub/users/dimitri)

message ("Installing ${doxygen_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${doxygen_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${doxygen_URL}
    URL_MD5             ${doxygen_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ./configure 
        --prefix ${FLYEM_BUILD_DIR}
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT doxygen_NAME)