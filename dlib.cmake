#
# Install dlib from source
#

if (NOT dlib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

external_source (dlib
    18.3
    dlib-18.3.tar.bz2
    1ad26ec7bddccf8a605e1edfd0620c65
    http://downloads.sourceforge.net/project/dclib/dlib/v18.3)

message ("Installing ${dlib_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${dlib_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${dlib_URL}
    URL_MD5             ${dlib_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
    	${dlib_SRC_DIR}/CMakeLists.txt ${PATCH_DIR}/dlib.patch

    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${dlib_SRC_DIR} 
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}


    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
    TEST_COMMAND        ""
)

set_target_properties(${dlib_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT dlib_NAME)

