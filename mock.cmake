# A python standards module. Provides test support. Added to core tests in Python 3.
# Required by Matplotlib.

if (NOT mock_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (mock
    1.0.1
    mock-1.0.1.tar.gz
    c3971991738caa55ec7c356bbc154ee2
    https://pypi.python.org/packages/source/m/mock/)


# Download and install mock
message ("Installing ${mock_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${mock_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${mock_URL}
    URL_MD5             ${mock_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${mock_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT mock_NAME)
