#
# Install thrift from source
#

if (NOT thrift_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

set (thrift_EXE             ${BUILDEM_BIN_DIR}/thrift)
set (thrift_INCLUDE_DIR     ${BUILDEM_INCLUDE_DIR}/thrift)
set (thrift_CXX_FLAGS       "-DHAVE_NETINET_IN_H -DHAVE_INTTYPES_H")

include_directories (${thrift_INCLUDE_DIR})

external_source (thrift
    0.8.0
    thrift-0.8.0.tar.gz
    d29dfcd38d476cbc420b6f4d80ab966c
    https://dist.apache.org/repos/dist/release/thrift/0.8.0)

message ("Installing ${thrift_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${thrift_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${thrift_URL}
    URL_MD5             ${thrift_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./configure 
        --prefix=${BUILDEM_DIR} 
        --with-boost=${BUILDEM_DIR} 
        PY_PREFIX=${BUILDEM_DIR}
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set (thrift_STATIC_LIBRARIES ${BUILDEM_LIB_DIR}/libthrift.a)
set (thrift_LIBRARIES ${BUILDEM_LIB_DIR}/libthrift.so)

endif (NOT thrift_NAME)