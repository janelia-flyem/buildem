# Provides support for building pipelines in Python. Supports multiprocessing and DRMAA.

if (NOT ruffus_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_git_repo(ruffus
                  e72bdac5ad845c8c16a8516160a76d89fb31ad45 # version 2.6.2
                  https://github.com/bunbun/ruffus)


# Download and install ruffus
message ("Installing ${ruffus_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${ruffus_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${ruffus_URL}
    GIT_TAG             ${ruffus_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${ruffus_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT ruffus_NAME)
