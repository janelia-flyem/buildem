# Provides syntax highlighting support for Python.
# Required by iPython. Also, used by Spyder.

if (NOT pygments_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)


include (python)

external_source (pygments
    1.6
    Pygments-1.6.tar.gz
    a18feedf6ffd0b0cc8c8b0fbdb2027b1
    https://pypi.python.org/packages/source/P/Pygments/)

message ("Installing ${pygments_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${pygments_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${pygments_URL}
    URL_MD5             ${pygments_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pygments_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pygments_NAME)