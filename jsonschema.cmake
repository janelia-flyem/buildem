#
# Install jsonschema library from source
#

if (NOT jsonschema_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_source (jsonschema
    2.3.0
    jsonschema-2.3.0.tar.gz
    410075e1969a9ec1838b5a6e1313c32b
    https://pypi.python.org/packages/source/j/jsonschema)

message ("Installing ${jsonschema_NAME} into ilastik build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${jsonschema_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${jsonschema_URL}
    URL_MD5             ${jsonschema_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${jsonschema_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT jsonschema_NAME)

