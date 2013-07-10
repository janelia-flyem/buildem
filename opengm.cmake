#
# Install opebgn libraries from source
#

if (NOT opengm_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

external_git_repo (opengm
    HEAD
    https://github.com/ilastik/opengm)


message ("Installing ${opengm_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${ann_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${opengm_URL}
    # URL_MD5             ${opengm_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       "" #${BUILDEM_ENV_STRING} ${PATCH_EXE}
    # ${opengm_SRC_DIR}/CMakeLists.txt ${PATCH_DIR}/opengm.patch

    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${opengm_SRC_DIR} 
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DWITH_CPLEX=ON


    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
)

set_target_properties(${opengm_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT opengm_NAME)