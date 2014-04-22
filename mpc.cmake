# A useful addition to gmp and mpfr, which were already included.
# 
# Required by gmpy.

if (NOT mpc_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (gmp)
include (mpfr)

external_source (mpc
    1.0.2
    mpc-1.0.2.tar.gz
    68fadff3358fb3e7976c7a398a0af4c3
    ftp://ftp.gnu.org/gnu/mpc/)

message ("Installing ${mpc_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${mpc_NAME}
    DEPENDS             ${gmp_NAME} ${mpfr_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${mpc_URL}
    URL_MD5             ${mpc_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${mpc_SRC_DIR}/configure
        --prefix=${BUILDEM_DIR}
        --with-gmp=${BUILDEM_DIR}   # Standard. See http://code.google.com/p/gmpy/wiki/InstallingGmpy2
        --with-mpfr=${BUILDEM_DIR}   # Standard. See http://code.google.com/p/gmpy/wiki/InstallingGmpy2
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${mpc_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT mpc_NAME)