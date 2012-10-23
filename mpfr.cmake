#
# Install mpfr from source
#

if (NOT mpfr_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (gmp)

external_source (mpfr
    3.1.1
    mpfr-3.1.1.tar.gz
    769411e241a3f063ae1319eb5fac2462
    http://www.mpfr.org/mpfr-current/)

message ("Installing ${mpfr_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${mpfr_NAME}
    DEPENDS             ${gmp_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${mpfr_URL}
    URL_MD5             ${mpfr_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${FLYEM_ENV_STRING} patch -N -Z -p1 < ${PATCH_DIR}/mpfr-3.1.1.patch
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${mpfr_SRC_DIR}/configure
        --prefix=${FLYEM_BUILD_DIR}
        LDFLAGS=${FLYEM_LDFLAGS}
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${FLYEM_ENV_STRING} make check
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT mpfr_NAME)