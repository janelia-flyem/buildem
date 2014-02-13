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
    1.16
    leveldb-1.16.0.tar.gz
    cf311b61142ceffccb98b84fd16e8954
    http://leveldb.googlecode.com/files)

message ("Installing ${leveldb_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
if (${APPLE})
    message ("Standard Google leveldb cmake system: Detected Apple platform.")
	set (LIBFILE "dylib")
elseif (${UNIX})
    message ("Standard Google leveldb cmake system: Detected UNIX-like platform.")
	set (LIBFILE "so")
	set (COMPILE_FLAGS "-lrt")
elseif (${WINDOWS})
    message (FATAL_ERROR "Standard Google leveldb cmake system: Detected Windows platform.  Not setup for it yet!")
endif ()

ExternalProject_Add(${leveldb_NAME}
    PREFIX            ${BUILDEM_DIR}
    URL               ${leveldb_URL}
    URL_MD5           ${leveldb_MD5}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) ${COMPILE_FLAGS}
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   ${CMAKE_COMMAND} -E copy 
        ${leveldb_SRC_DIR}/libleveldb.${LIBFILE}.${leveldb_RELEASE} ${BUILDEM_LIB_DIR}/libleveldb.${LIBFILE}
)
ExternalProject_add_step(${leveldb_NAME} install_lib_link
    DEPENDEES   install
    COMMAND     ${CMAKE_COMMAND} -E create_symlink 
        ${BUILDEM_LIB_DIR}/libleveldb.${LIBFILE} ${BUILDEM_LIB_DIR}/libleveldb.${LIBFILE}.1
    COMMENT     "Created symbolic link for libleveldb.so.1 in ${BUILDEM_LIB_DIR}"
)
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
