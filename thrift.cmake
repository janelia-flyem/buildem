#
# Install thrift from source
#

if (NOT thrift_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (thrift
    0.8.0
    thrift-0.8.0.tar.gz
    http://apache.osuosl.org/thrift/0.8.0)

message ("Installing ${thrift_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${thrift_NAME}
    PREFIX            ${FLYEM_BUILD_DIR}
    URL               ${thrift_URL}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ./configure 
        --prefix=${FLYEM_BUILD_DIR} 
        --with-boost=${FLYEM_BUILD_DIR} 
        PY_PREFIX=${FLYEM_BUILD_DIR}
        LDFLAGS=-L${FLYEM_BUILD_DIR}/lib
    BUILD_COMMAND     make
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   make install
)

endif (NOT thrift_NAME)