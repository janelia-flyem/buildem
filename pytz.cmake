# Time zone definitions for Python.
# Used by Matplotlib.

if (NOT pytz_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (pytz
    2014.2
    pytz-2014.2.tar.gz
    c0158314605420cbf6e5328369b06145
    https://pypi.python.org/packages/source/p/pytz/)


# Download and install pytz
message ("Installing ${pytz_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${pytz_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${pytz_URL}
    URL_MD5             ${pytz_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pytz_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pytz_NAME)