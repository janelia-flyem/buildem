# Adds pip, the python installer.

if (NOT pip_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_git_repo(pip
	1.5.6 # 81f21f2261d422d243f66b2dfeef0faae72ab119
	https://github.com/pypa/pip)


# Download and install pip
message ("Installing ${pip_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${pip_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${pip_URL}
    GIT_TAG             ${pip_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pip_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pip_NAME)
