#
# Install snappy from source
#

if (NOT snappy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (snappy
    1.0.5
    snappy-1.0.5.tar.gz
    4c0af044e654f5983f4acbf00d1ac236
    http://snappy.googlecode.com/files)

message ("Installing ${snappy_NAME} into build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${snappy_NAME}
    PREFIX            ${BUILDEM_DIR}
    URL               ${snappy_URL}
    URL_MD5           ${snappy_MD5}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./configure 
        --prefix=${BUILDEM_DIR} 
        --enable-shared
        --enable-static
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND     ${BUILDEM_ENV_STRING} make
    BUILD_IN_SOURCE   1
    TEST_COMMAND      ${BUILDEM_ENV_STRING} make check
    INSTALL_COMMAND   ${BUILDEM_ENV_STRING} make install
)

#ExternalProject_add_step(${snappy_NAME} install_includes
#    DEPENDEES   build
#    COMMAND     ${CMAKE_COMMAND} -E copy_directory 
#        ${snappy_SRC_DIR}/include/snappy ${BUILDEM_INCLUDE_DIR}/snappy
#    COMMENT     "Placed snappy include files in ${BUILDEM_INCLUDE_DIR}/snappy"
#)
#include_directories (${BUILDEM_INCLUDE_DIR}/snappy)

#ExternalProject_add_step(${snappy_NAME} install_library
#    DEPENDEES   install_includes
#    COMMAND     ${CMAKE_COMMAND} -E copy 
#        ${snappy_SRC_DIR}/libsnappy.a ${BUILDEM_LIB_DIR}
#    COMMENT     "Placed libsnappy.a in ${BUILDEM_LIB_DIR}"
#)

set_target_properties(${snappy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

set (snappy_STATIC_LIBRARIES ${BUILDEM_LIB_DIR}/libsnappy.a)

endif (NOT snappy_NAME)