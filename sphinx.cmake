# Provide nice Python documentation output.
# Used by Spyder and iPython.

if (NOT sphinx_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (sphinx
    1.2.2
    Sphinx-1.2.2.tar.gz
    3dc73ccaa8d0bfb2d62fb671b1f7e8a4
    https://pypi.python.org/packages/source/S/Sphinx/)


# Download and install sphinx
message ("Installing ${sphinx_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${sphinx_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${sphinx_URL}
    URL_MD5             ${sphinx_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${sphinx_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sphinx_NAME)