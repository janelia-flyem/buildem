CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (BuildSupport)

external_git_repo (emdata
    HEAD
    http://github.com/janelia-flyem/emdata.git)

message ("Installing ${emdata_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${emdata_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${emdata_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} -DBUILDEM_DIR=${BUILDEM_DIR} ${emdata_SRC_DIR}
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)
