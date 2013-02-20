#
# Install lemon from source
#

if (NOT lemon_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (lemon
    1.2.3
    lemon-1.2.3.tar.gz
    750251a77be450ddddedab14e5163afb
    http://lemon.cs.elte.hu/pub/sources)

message ("Installing ${lemon_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${lemon_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${lemon_URL}
    URL_MD5             ${lemon_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
    	${lemon_SRC_DIR}/lemon/CMakeLists.txt ${PATCH_DIR}/lemon.patch

    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${lemon_SRC_DIR} 
        -DBUILD_SHARED_LIBS=1
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}

    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
)

set_target_properties(${lemon_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT lemon_NAME)

