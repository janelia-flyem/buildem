#
# Install boost1550 libraries from source
#

if (NOT boost1550_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (BuildSupport)
include (ExternalSource)

include (python)
include (zlib)

set (boost_INCLUDE_DIR  ${BUILDEM_INCLUDE_DIR}/boost)
include_directories (${boost_INCLUDE_DIR})

external_source (boost1550
    1_55_0
    boost_1_55_0.tar.gz
    93780777cfbf999a600f62883bd54b17 
    http://sourceforge.net/projects/boost/files/boost/1.55.0/)

set (boost_LIBS ${BUILDEM_LIB_DIR}/libboost_thread.${BUILDEM_PLATFORM_DYLIB_EXTENSION} 
                ${BUILDEM_LIB_DIR}/libboost_system.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
                ${BUILDEM_LIB_DIR}/libboost_program_options.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
                ${BUILDEM_LIB_DIR}/libboost_python.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
                ${BUILDEM_LIB_DIR}/libboost_unit_test_framework.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
                ${BUILDEM_LIB_DIR}/libboost_filesystem.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
                ${BUILDEM_LIB_DIR}/libboost_chrono.${BUILDEM_PLATFORM_DYLIB_EXTENSION} )

# Add layout=tagged param to first boost1550 install to explicitly create -mt libraries
# some libraries require.  TODO: Possibly shore up all library find paths to only
# allow use of built libs.
message ("Installing ${boost1550_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${boost1550_NAME}
    DEPENDS             ${python_NAME} ${zlib_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${boost1550_URL}
    URL_MD5             ${boost1550_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./bootstrap.sh 
        --with-libraries=date_time,filesystem,python,regex,serialization,system,test,thread,program_options,chrono
        --with-python=${PYTHON_EXE} 
        --prefix=${BUILDEM_DIR}
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ./b2 
        --layout=tagged
        -sNO_BZIP2=1 
        -sZLIB_INCLUDE=${BUILDEM_DIR}/include 
        -sZLIB_SOURCE=${zlib_SRC_DIR} install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ./b2 
        -sNO_BZIP2=1 
        -sZLIB_INCLUDE=${BUILDEM_DIR}/include 
        -sZLIB_SOURCE=${zlib_SRC_DIR} install
)

set_target_properties(${boost1550_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT boost1550_NAME)
