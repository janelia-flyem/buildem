# A passive Python analyzer and error detector.
# Required by Spyder.

if (NOT pyflakes_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (pyflakes
    1.1.0
    pyflakes-0.8.1.tar.gz
    905fe91ad14b912807e8fdc2ac2e2c23
    https://pypi.python.org/packages/source/p/pyflakes/)


# Download and install pyflakes
message ("Installing ${pyflakes_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${pyflakes_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${pyflakes_URL}
    URL_MD5             ${pyflakes_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pyflakes_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pyflakes_NAME)