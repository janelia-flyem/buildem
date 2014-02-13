#
# Install HyperLevelDB from source
#

if (NOT hyperleveldb_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (snappy)

external_git_repo (hyperleveldb
    HEAD
    http://github.com/rescrv/HyperLevelDB.git)

message ("Installing ${hyperleveldb_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
if (${APPLE})
    message ("HyperLevelDB cmake system: Detected Apple platform.")
	set (LIBFILE "dylib")
elseif (${UNIX})
    message ("HyperLevelDB cmake system: Detected UNIX-like platform.")
	set (LIBFILE "so")
	set (COMPILE_FLAGS "-lrt")
elseif (${WINDOWS})
    message (FATAL_ERROR "HyperLevelDB system: Detected Windows platform.  Not setup for it yet!")
endif ()

ExternalProject_Add(${hyperleveldb_NAME}
    PREFIX            ${BUILDEM_DIR}
    URL               ${hyperleveldb_URL}
    URL_MD5           ${hyperleveldb_MD5}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) ${COMPILE_FLAGS}
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   ${CMAKE_COMMAND} -E copy 
        ${hyperleveldb_SRC_DIR}/libhyperleveldb.${LIBFILE}.${hyperleveldb_RELEASE} ${BUILDEM_LIB_DIR}/libhyperleveldb.${LIBFILE}
)
ExternalProject_add_step(${hyperleveldb_NAME} install_lib_link
    DEPENDEES   install
    COMMAND     ${CMAKE_COMMAND} -E create_symlink 
        ${BUILDEM_LIB_DIR}/libhyperleveldb.${LIBFILE} ${BUILDEM_LIB_DIR}/libhyperleveldb.${LIBFILE}.1
    COMMENT     "Created symbolic link for libhyperleveldb.so.1 in ${BUILDEM_LIB_DIR}"
)
ExternalProject_add_step(${hyperleveldb_NAME} install_includes
    DEPENDEES   build
    COMMAND     ${CMAKE_COMMAND} -E copy_directory 
        ${hyperleveldb_SRC_DIR}/include/hyperleveldb ${BUILDEM_INCLUDE_DIR}/hyperleveldb
    COMMENT     "Placed hyperleveldb include files in ${BUILDEM_INCLUDE_DIR}/hyperleveldb"
)
include_directories (${BUILDEM_INCLUDE_DIR}/leveldb)

ExternalProject_add_step(${hyperleveldb_NAME} install_static_library
    DEPENDEES   install_includes
    COMMAND     ${CMAKE_COMMAND} -E copy 
        ${hyperleveldb_SRC_DIR}/libhyperleveldb.a ${BUILDEM_LIB_DIR}
    COMMENT     "Placed libhyperleveldb.a in ${BUILDEM_LIB_DIR}"
)

set_target_properties(${hyperleveldb_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

set (hyperleveldb_STATIC_LIBRARIES ${BUILDEM_LIB_DIR}/libhyperleveldb.a)

endif (NOT hyperleveldb_NAME)
