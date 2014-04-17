#
# Install cppnetlib library from source
#

if (NOT cppnetlib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.6)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (boost1550)

external_source (cppnetlib
    0.11.0
    cpp-netlib-0.11.0.tar.gz
    6fba4f2f64f19af9f172fd60ad8e76ab 
    http://commondatastorage.googleapis.com/cpp-netlib-downloads/0.11.0/
    )

# set libs properly
set (CPPNETLIB_LIBRARIES ${BUILDEM_DIR}/lib64/libcppnetlib-client-connections.a ${BUILDEM_DIR}/lib64/libcppnetlib-server-parsers.a ${BUILDEM_DIR}/lib64/libcppnetlib-uri.a)

message ("Installing ${cppnetlib_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${cppnetlib_NAME}
    DEPENDS                 ${boost1550_NAME}
    PREFIX                  ${BUILDEM_DIR}
    URL                     ${cppnetlib_URL}
    URL_MD5                 ${cppnetlib_MD5}
    UPDATE_COMMAND          ""
    PATCH_COMMAND           ""
    CONFIGURE_COMMAND       ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${cppnetlib_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        BUILD_COMMAND           ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND         ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${cppnetlib_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT cppnetlib_NAME)
