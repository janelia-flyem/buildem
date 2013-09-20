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

message ("Installing ${libfftw_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${libfftw_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${libfftw_URL}
    URL_MD5             ${libfftw_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${libfftw_SRC_DIR}/configure 
        --prefix=${BUILDEM_DIR}
        --enable-shared
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

# Add additional steps to build and install the fftw single-precision libraries.
# (It is not possible to generate single and double precision libraries in one make step.)

# Configure single-precision
ExternalProject_Add_Step(${libfftw_NAME} singlefloat-configure
    DEPENDEES install
    COMMAND cd ${libfftw_SRC_DIR}-build && ${BUILDEM_ENV_STRING} ${libfftw_SRC_DIR}/configure 
        --prefix=${BUILDEM_DIR}
        --enable-shared
        --enable-float  # This creates libfftw3f single-precision libraries INSTEAD OF the default double libraries.
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
)

# build single-precision
ExternalProject_Add_Step(${libfftw_NAME} singlefloat-build
    DEPENDEES singlefloat-configure
    COMMAND cd ${libfftw_SRC_DIR}-build && ${BUILDEM_ENV_STRING} make
)

# install single-precision
ExternalProject_Add_Step(${libfftw_NAME} singlefloat-install
    DEPENDEES singlefloat-build
    COMMAND cd ${libfftw_SRC_DIR}-build && ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${libfftw_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT libfftw_NAME)
