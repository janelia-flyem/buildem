#
# Install drmaa-python library from source
#

if (NOT drmaa-python_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_source (drmaa-python
    0.5
    drmaa-0.5.tar.gz
    04c7fa199a86ccf20d3b91c8705cb8be 
    http://drmaa-python.googlecode.com/files/
    )

message ("Installing ${drmaa-python_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${drmaa-python_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${drmaa-python_URL}
    URL_MD5             ${drmaa-python_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${drmaa-python_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT drmaa-python_NAME)
