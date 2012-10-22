#
# Install thrift from source
#

if (NOT thrift_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (thrift
    0.8.0
    thrift-0.8.0.tar.gz
    d29dfcd38d476cbc420b6f4d80ab966c
    https://dist.apache.org/repos/dist/release/thrift/0.8.0)

message ("Installing ${thrift_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${thrift_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${thrift_URL}
    URL_MD5             ${thrift_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ./configure 
        --prefix=${FLYEM_BUILD_DIR} 
        --with-boost=${FLYEM_BUILD_DIR} 
        PY_PREFIX=${FLYEM_BUILD_DIR}
        LDFLAGS=-Wl,-rpath,${FLYEM_BUILD_DIR}/lib
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT thrift_NAME)