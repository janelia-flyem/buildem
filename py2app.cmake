#
# Install py2app packaging tool from source
#

if (NOT py2app_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_source (py2app
    0.7.3
    py2app-0.7.3.tar.gz
    fad705e63d335c570fde3bee48129730
    http://pypi.python.org/packages/source/p/py2app/)

message ("Installing ${py2app_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${py2app_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${py2app_URL}
    URL_MD5             ${py2app_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${py2app_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT py2app_NAME)
