# Used for handling any date or time.
# Required by Matplotlib.

if (NOT python-dateutil_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)
include (six)

external_source (python-dateutil
    1.5
    python-dateutil-1.5.tar.gz
    35f3732db3f2cc4afdc68a8533b60a52
    https://labix.org/download/python-dateutil)


# Download and install python-dateutil
message ("Installing ${python-dateutil_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${python-dateutil_NAME}
    DEPENDS             ${python_NAME} ${six_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${python-dateutil_URL}
    URL_MD5             ${python-dateutil_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${python-dateutil_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT python-dateutil_NAME)