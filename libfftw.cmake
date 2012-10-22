#
# Install libfftw from source
#

if (NOT libfftw_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (libfftw
    3.3.2
    fftw-3.3.2.tar.gz
    6977ee770ed68c85698c7168ffa6e178
    http://www.fftw.org)

message ("Installing ${libfftw_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${libfftw_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${libfftw_URL}
    URL_MD5             ${libfftw_MD5}
    LINE_SEPARATOR      ^^
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${libfftw_SRC_DIR}/configure 
        --prefix=${FLYEM_BUILD_DIR}
        --enable-shared
#        --enable-float  # This creates libfftw3f single-precision libraries
        LDFLAGS=-Wl,-rpath,${FLYEM_BUILD_DIR}/lib^^-L${FLYEM_BUILD_DIR}/lib
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT libfftw_NAME)