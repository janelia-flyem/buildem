#
# Install leveldb from source
#

if (NOT leveldb_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (leveldb
    1.6.0
    leveldb-1.6.0.tar.gz
    d0b73edbb86996d58b073bba6b206295
    http://leveldb.googlecode.com/files)

message ("Installing ${leveldb_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${leveldb_NAME}
    PREFIX            ${BUILDEM_DIR}
    URL               ${leveldb_URL}
    URL_MD5           ${leveldb_MD5}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ${BUILDEM_ENV_STRING} make
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   ""
)

ExternalProject_add_step(${leveldb_NAME} install_includes
    DEPENDEES   build
    COMMAND     ${CMAKE_COMMAND} -E copy_directory 
        ${leveldb_SRC_DIR}/include/leveldb ${BUILDEM_DIR}/include/leveldb
    COMMENT     "Placed leveldb include files in ${BUILDEM_DIR}include"
)

ExternalProject_add_step(${leveldb_NAME} install_library
    DEPENDEES   install_includes
    COMMAND     ${CMAKE_COMMAND} -E copy 
        ${leveldb_SRC_DIR}/libleveldb.a ${BUILDEM_DIR}/lib
    COMMENT     "Placed libleveldb.a in ${BUILDEM_DIR}/lib"
)

endif (NOT leveldb_NAME)