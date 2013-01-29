if (NOT raveler_utils_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (BuildSupport)
include (ExternalSource)

external_git_repo (raveler_utils
    HEAD
    http://github.com/janelia-flyem/raveler-utils.git)

message ("Installing ${raveler_utils_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${raveler_utils_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${raveler_utils_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} -DBUILDEM_DIR=${BUILDEM_DIR} ${raveler_utils_SRC_DIR}
    BUILD_COMMAND       make
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${raveler_utils_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT raveler_utils_NAME)
