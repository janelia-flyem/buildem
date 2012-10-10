#
# Install leveldb from source
#

if (NOT leveldb_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (leveldb
    1.4.0
    leveldb-1.4.0.zip
    http://googletest.googlecode.com/files)

message ("Installing ${leveldb_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${leveldb_NAME}
    PREFIX            ${FLYEM_BUILD_DIR}
    URL               ${leveldb_URL}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     make
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   
)

ExternalProject_add_step(${leveldb_NAME} install_includes
    DEPENDEES   build
    COMMAND     ${CMAKE_COMMAND} -E make_directory ${FLYEM_BUILD_DIR}/include
    COMMAND     ${CMAKE_COMMAND} -E copy_directory 
        ${leveldb_SRC_DIR}/include/leveldb ${FLYEM_BUILD_DIR}/include/leveldb
    COMMENT     "Placed leveldb include files in ${FLYEM_BUILD_DIR}include"
)

ExternalProject_add_step(${leveldb_NAME} install_library
    DEPENDEES   install_includes
    COMMAND     ${CMAKE_COMMAND} -E make_directory ${FLYEM_BUILD_DIR}/lib
    COMMAND     ${CMAKE_COMMAND} -E copy 
        ${leveldb_SRC_DIR}/libleveldb.a ${FLYEM_BUILD_DIR}/lib
    COMMENT     "Placed libleveldb.a in ${FLYEM_BUILD_DIR}/lib"
)

endif (NOT leveldb_NAME)