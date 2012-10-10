#
# Install libfftw from source
#

if (NOT libfftw_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (libfftw
    3.3.2
    fftw-3.3.2.tar.gz
    http://www.fftw.org)

message ("Installing ${libfftw_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${libfftw_NAME}
    PREFIX            ${FLYEM_BUILD_DIR}
    URL               ${libfftw_URL}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ${libfftw_SRC_DIR}/configure 
        --prefix=${FLYEM_BUILD_DIR}
        --enable-shared
#        --enable-float  # This creates libfftw3f single-precision libraries
        LDFLAGS=-L${FLYEM_BUILD_DIR}/lib
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND     make
    INSTALL_COMMAND   make install
)

endif (NOT libfftw_NAME)