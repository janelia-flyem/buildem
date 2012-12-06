#
# Install synapse-geometry python library

if (NOT syngeo_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_git_repo (syngeo
    HEAD
    http://github.com/janelia-flyem/synapse-geometry.git)

message ("Installing ${syngeo_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${syngeo_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${syngeo_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${syngeo_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT syngeo_NAME)
