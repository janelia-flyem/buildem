# Another Python code analyzer and error detector like pyflakes. Also, checks for bad smells.
# Required by Spyder.

if (NOT pylint_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (pylint
    1.1.0
    pylint-1.1.0.tar.gz
    017299b5911838a9347a71de5f946afc
    https://pypi.python.org/packages/source/p/pylint)


# Download and install pylint
message ("Installing ${pylint_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${pylint_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${pylint_URL}
    URL_MD5             ${pylint_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pylint_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pylint_NAME)