#
# Install leveldb from source
#

if (NOT leveldb_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (snappy)

external_source (leveldb
    1.9.0
    leveldb-1.9.0.tar.gz
    12f11385cb58ae0de66d4bc2cc7f8194
    http://leveldb.googlecode.com/files)

message ("Installing ${leveldb_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
if (${APPLE})
    message ("Leveldb cmake system: Detected Apple platform.")
    ExternalProject_Add(${leveldb_NAME}
        DEPENDS           ${snappy_NAME}
        PREFIX            ${BUILDEM_DIR}
        URL               ${leveldb_URL}
        URL_MD5           ${leveldb_MD5}
        UPDATE_COMMAND    ""
        PATCH_COMMAND     ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND     ${BUILDEM_ENV_STRING} make
        BUILD_IN_SOURCE   1
        INSTALL_COMMAND   ${CMAKE_COMMAND} -E copy 
            ${leveldb_SRC_DIR}/libleveldb.dylib.1.9 ${BUILDEM_LIB_DIR}/libleveldb.dylib
    )
elseif (${UNIX})
    message ("Leveldb cmake system: Detected UNIX-like platform.")
    ExternalProject_Add(${leveldb_NAME}
        DEPENDS           ${snappy_NAME}
        PREFIX            ${BUILDEM_DIR}
        URL               ${leveldb_URL}
        URL_MD5           ${leveldb_MD5}
        UPDATE_COMMAND    ""
        PATCH_COMMAND     ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND     ${BUILDEM_ENV_STRING} make
        BUILD_IN_SOURCE   1
        INSTALL_COMMAND   ${CMAKE_COMMAND} -E copy 
            ${leveldb_SRC_DIR}/libleveldb.so.1.9 ${BUILDEM_LIB_DIR}/libleveldb.so
    )
elseif (${WINDOWS})
    message (FATAL_ERROR "Leveldb cmake system: Detected Windows platform.  Not setup for it yet!")
endif ()

ExternalProject_add_step(${leveldb_NAME} install_includes
    DEPENDEES   build
    COMMAND     ${CMAKE_COMMAND} -E copy_directory 
        ${leveldb_SRC_DIR}/include/leveldb ${BUILDEM_INCLUDE_DIR}/leveldb
    COMMENT     "Placed leveldb include files in ${BUILDEM_INCLUDE_DIR}/leveldb"
)
include_directories (${BUILDEM_INCLUDE_DIR}/leveldb)

ExternalProject_add_step(${leveldb_NAME} install_static_library
    DEPENDEES   install_includes
    COMMAND     ${CMAKE_COMMAND} -E copy 
        ${leveldb_SRC_DIR}/libleveldb.a ${BUILDEM_LIB_DIR}
    COMMENT     "Placed libleveldb.a in ${BUILDEM_LIB_DIR}"
)

set_target_properties(${leveldb_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

set (leveldb_STATIC_LIBRARIES ${BUILDEM_LIB_DIR}/libleveldb.a)

endif (NOT leveldb_NAME)
