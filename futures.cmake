#
# Install futures library from source
#

if (NOT futures_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_source (futures
    2.1.6
    futures-2.1.6.tar.gz
    cfab9ac3cd55d6c7ddd0546a9f22f453
    https://pypi.python.org/packages/source/f/futures)

message ("Installing ${futures_NAME} into ilastik build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${futures_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${futures_URL}
    URL_MD5             ${futures_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${futures_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT futures_NAME)

