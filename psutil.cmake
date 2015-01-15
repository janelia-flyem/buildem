#
# Install psutil library from source
#

if (NOT psutil_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_git_repo(psutil
        release-2.1.1 # 50bd135bbbd17c970afc4882b0829900e3d9bb4c
        https://github.com/giampaolo/psutil)

message ("Installing ${psutil_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${psutil_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${psutil_URL}
    GIT_TAG             ${psutil_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${psutil_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT psutil_NAME)
