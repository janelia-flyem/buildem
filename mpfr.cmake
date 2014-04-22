#
# Install mpfr from source.
# Provides additional multiple precision support.
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

message ("Installing ${mpfr_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${mpfr_NAME}
    DEPENDS             ${gmp_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${mpfr_URL}
    URL_MD5             ${mpfr_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} patch -N -Z -p1 < ${PATCH_DIR}/mpfr-3.1.1.patch
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${mpfr_SRC_DIR}/configure
        --prefix=${BUILDEM_DIR}
        --with-gmp=${BUILDEM_DIR}   # Standard. See http://code.google.com/p/gmpy/wiki/InstallingGmpy2
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${mpfr_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT mpfr_NAME)