# Refactoring for Python.
# Required by Spyder.

if (NOT rope_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (rope
    0.9.4
    rope-0.9.4.tar.gz
    6c654c6892f78008e04e2d65f9f859bb
    https://pypi.python.org/packages/source/r/rope/)


# Download and install rope
message ("Installing ${rope_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${rope_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${rope_URL}
    URL_MD5             ${rope_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${rope_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT rope_NAME)