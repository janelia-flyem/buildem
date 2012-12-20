#
# Install gmp from source
#

if (NOT gmp_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (gmp
    5.0.5
    gmp-5.0.5.tar.bz2
    041487d25e9c230b0c42b106361055fe
    ftp://ftp.gnu.org/gnu/gmp)

message ("Installing ${gmp_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${gmp_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${gmp_URL}
    URL_MD5             ${gmp_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${gmp_SRC_DIR}/configure
        --prefix=${BUILDEM_DIR}
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${gmp_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT gmp_NAME)