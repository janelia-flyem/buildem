# Provides dill, which provides support for pickling with a larger set of Python objects.

if (NOT dill_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_git_repo(dill
	dill-0.2.2 #8d3fb53d218082b14839f3e2aa6a3b0f975fb57c
	https://github.com/uqfoundation/dill)


# Download and install dill
message ("Installing ${dill_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${dill_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${dill_URL}
    GIT_TAG             ${dill_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${dill_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT dill_NAME)
