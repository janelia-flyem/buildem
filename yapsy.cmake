#
# Install yapsy library from source
#

if (NOT yapsy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_source (yapsy
    1.10
    Yapsy-1.10.2-pythons2n3.tar.gz
    d905b574d4f55ff62e02603ec3dc89b3
    https://pypi.python.org/packages/source/Y/Yapsy)

message ("Installing ${yapsy_NAME} into ilastik build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${yapsy_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${yapsy_URL}
    URL_MD5             ${yapsy_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${yapsy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT yapsy_NAME)

