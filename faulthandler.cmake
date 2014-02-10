#
# Install faulthandler library from source
#

if (NOT faulthandler_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_source (faulthandler
    2.3
    faulthandler-2.3.tar.gz
    76d1344adc2302cf5c59a5f8a4f4f4ae
    https://pypi.python.org/packages/source/f/faulthandler/)

message ("Installing ${faulthandler_NAME} into ilastik build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${faulthandler_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${faulthandler_URL}
    URL_MD5             ${faulthandler_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${faulthandler_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT faulthandler_NAME)


