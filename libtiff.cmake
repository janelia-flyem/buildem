#
# Install libtiff from source
#

if (NOT libtiff_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (libjpeg)

external_source (libtiff
    4.0.3
    tiff-4.0.3.tar.gz
    051c1068e6a0627f461948c365290410
    ftp://ftp.remotesensing.org/pub/libtiff)

message ("Installing ${libtiff_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${libtiff_NAME}
    DEPENDS             ${libjpeg_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${libtiff_URL}
    URL_MD5             ${libtiff_MD5}
    LINE_SEPARATOR      ^^
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ./configure 
        --prefix=${FLYEM_BUILD_DIR}
        LDFLAGS=-Wl,-rpath,${FLYEM_BUILD_DIR}/lib^^-L${FLYEM_BUILD_DIR}/lib
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT libtiff_NAME)