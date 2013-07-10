#
# Install libann from source
#

if (NOT libann_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

external_source (libann
    1.1.2
    ann_1.1.2.tar.gz
    7ffaacc7ea79ca39d4958a6378071365
    http://www.cs.umd.edu/~mount/ANN/Files/1.1.2
    FORCE)

message ("Installing ${libann_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${libann_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${libann_URL}
    URL_MD5             ${libann_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
    	${libann_SRC_DIR}/CMakeLists.txt ${PATCH_DIR}/ann.patch

    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${libann_SRC_DIR} 
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}


    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
)

set_target_properties(${libann_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT libann_NAME)

