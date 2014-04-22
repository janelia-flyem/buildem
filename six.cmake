# A python standards module. Provides support for utilities in a compatible way
# between Python 2 and 3.
# Required by Matplotlib.

if (NOT six_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (six
    1.6.1
    six-1.6.1.tar.gz
    07d606ac08595d795bf926cc9985674f
    https://pypi.python.org/packages/source/s/six/)


# Download and install six
message ("Installing ${six_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${six_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${six_URL}
    URL_MD5             ${six_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${six_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT six_NAME)