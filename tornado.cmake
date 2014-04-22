# Web framework and asynchronous networking library (from their intro).
# Required by Matplotlib and iPython.

if (NOT tornado_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (backports-ssl_match_hostname)


external_git_repo(tornado
    v3.1.1 # f36652d47fc42205c085ed65e740f4b155d4e5e4
    https://github.com/facebook/tornado)


# Download and install tornado
message ("Installing ${tornado_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${tornado_NAME}
    DEPENDS             ${python_NAME} ${backports-ssl_match_hostname}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${tornado_URL}
    GIT_TAG             ${tornado_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${tornado_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT tornado_NAME)