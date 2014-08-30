# Pulls down the right readline depending on whether it is Windows or Mac using anyreadline.
# Does nothing on Linux as it should have GNU readline.
# 
# Required by iPython.


if (NOT readline_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (setuptools)

external_git_repo(readline
	v0_1_1 #0796d3eaa9158f6ac82b7f8eea96f372851b79e3
	https://github.com/pombredanne/anyreadline)

message ("Installing ${readline_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${readline_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${readline_URL}
    GIT_TAG             ${readline_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
	# Allows readline to be installed for Linux where it may not always be present (i.e. CentOS).
        ${readline_SRC_DIR}/setup.py ${PATCH_DIR}/python-readline-setup.patch
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${readline_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT readline_NAME)
