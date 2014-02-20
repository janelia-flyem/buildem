#
# Install basholeveldb from source
#

if (NOT basholeveldb_NAME)
	
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (basholeveldb
    1.9
    basholeveldb-1.9.0.tar.gz
    8b8e450aaf3d5ae07d20e604f1c9d0cb)

message ("Installing ${basholeveldb_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
if (${APPLE})
    message ("Basho-tuned leveldb cmake system: Detected Apple platform.")
	set (LIBFILE "dylib")
elseif (${UNIX})
    message ("Basho-tuned leveldb cmake system: Detected UNIX-like platform.")
	set (LIBFILE "so")
    if (CMAKE_SYSTEM_NAME MATCHES "Linux")
        if (EXISTS "/etc/issue")
            file(READ "/etc/issue" LINUX_ISSUE)
            # Ubuntu
            if (LINUX_ISSUE MATCHES "Ubuntu")
                message ("Detected Ubuntu system.  Using -lrt linker flag.")
	            set (CMAKE_SHARED_LINKER_FLAGS "-Wl,--no-as-needed;-lrt")
            endif ()
        endif ()
    endif ()
elseif (${WINDOWS})
    message (FATAL_ERROR "Leveldb cmake system: Detected Windows platform.  Not setup for it yet!")
endif ()

ExternalProject_Add(${basholeveldb_NAME}
    PREFIX            ${BUILDEM_DIR}
    URL               ${basholeveldb_URL}
    URL_MD5           ${basholeveldb_MD5}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   ${CMAKE_COMMAND} -E copy 
        ${basholeveldb_SRC_DIR}/libleveldb.${LIBFILE}.${basholeveldb_RELEASE} ${BUILDEM_LIB_DIR}/libleveldb.${LIBFILE}
)
ExternalProject_add_step(${basholeveldb_NAME} install_lib_link
    DEPENDEES   install
    COMMAND     ${CMAKE_COMMAND} -E create_symlink 
        ${BUILDEM_LIB_DIR}/libleveldb.${LIBFILE} ${BUILDEM_LIB_DIR}/libleveldb.${LIBFILE}.1
    COMMENT     "Created symbolic link for libleveldb.so.1 in ${BUILDEM_LIB_DIR}"
)
ExternalProject_add_step(${basholeveldb_NAME} install_includes
    DEPENDEES   build
    COMMAND     ${CMAKE_COMMAND} -E copy_directory 
        ${basholeveldb_SRC_DIR}/include/leveldb ${BUILDEM_INCLUDE_DIR}/leveldb
    COMMENT     "Placed basholeveldb include files in ${BUILDEM_INCLUDE_DIR}/leveldb"
)
include_directories (${BUILDEM_INCLUDE_DIR}/leveldb)

ExternalProject_add_step(${basholeveldb_NAME} install_static_library
    DEPENDEES   install_includes
    COMMAND     ${CMAKE_COMMAND} -E copy 
        ${basholeveldb_SRC_DIR}/libleveldb.a ${BUILDEM_LIB_DIR}
    COMMENT     "Placed libleveldb.a in ${BUILDEM_LIB_DIR}"
)

set_target_properties(${basholeveldb_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

set (basholeveldb_STATIC_LIBRARIES ${BUILDEM_LIB_DIR}/libleveldb.a)

endif (NOT basholeveldb_NAME)
