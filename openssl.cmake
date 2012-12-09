#
# Install openssl from source
#

if (NOT openssl_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (zlib)

external_source (openssl
    1.0.1c
    openssl-1.0.1c.tar.gz
    ae412727c8c15b67880aef7bd2999b2e
    http://www.openssl.org/source)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # On Mac, 64-bit builds must be manually requested.
    set (SSL_CONFIGURE_COMMAND ./Configure darwin64-x86_64-cc )
else()
    # The config script seems to auto-select the platform correctly on linux
    # It calls ./Configure for us.
    set (SSL_CONFIGURE_COMMAND ./config)
endif()

message ("Installing ${openssl_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${openssl_NAME}
    DEPENDS             ${zlib_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${openssl_URL}
    URL_MD5             ${openssl_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${SSL_CONFIGURE_COMMAND}
        --prefix=${BUILDEM_DIR}
        zlib
        shared
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make test
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${openssl_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT openssl_NAME)