#
# Install networkx library from source
#

if (NOT networkx_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (numpy)
include (scipy)

external_source (networkx
    1.7
    networkx-1.7.tar.gz
    1a73da9d571a206aa40f6ef69254f7b4
    http://pypi.python.org/packages/source/n/networkx)

message ("Installing ${networkx_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${networkx_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${scipy_NAME} 
    PREFIX              ${BUILDEM_DIR}
    URL                 ${networkx_URL}
    URL_MD5             ${networkx_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${networkx_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT networkx_NAME)
