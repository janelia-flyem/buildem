# Provides support for PEP8.
# Required by Spyder.

if (NOT pep8_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_git_repo(pep8
	1.5.6 #96290d48b1334fe8542666174d7775cda3f46d9a
	https://github.com/jcrocholl/pep8)


# Download and install pep8
message ("Installing ${pep8_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${pep8_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${pep8_URL}
    GIT_TAG             ${pep8_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pep8_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pep8_NAME)